-- ============================================================
-- PROYECTO FINAL — BASES DE DATOS
-- Sistema de Gestión de Biblioteca Pública
-- Programación en Base de Datos
--
-- Este script contiene los elementos programables utilizados
-- para automatizar procesos importantes del sistema, como el
-- cálculo de multas, la generación automática de sanciones y
-- el registro de préstamos.
-- ============================================================

-- ============================================================
-- 1. FUNCIÓN: calcular_monto_multa
-- ============================================================
-- Esta función recibe la cantidad de días de retraso y devuelve
-- el monto que debe pagar el socio.
--
-- Para este proyecto se utiliza una tarifa fija de $0.25 por
-- cada día de atraso en la devolución.
-- ============================================================

CREATE OR REPLACE FUNCTION calcular_monto_multa(p_dias_retraso INT)
RETURNS NUMERIC(6,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tarifa_diaria CONSTANT NUMERIC(6,2) := 0.25;
BEGIN

    -- Si no existe retraso, no se genera ningún cobro.
    IF p_dias_retraso <= 0 THEN
        RETURN 0.00;
    END IF;

    RETURN (p_dias_retraso * v_tarifa_diaria)::NUMERIC(6,2);

END;
$$;


-- ============================================================
-- 2. TRIGGER PARA GENERAR MULTAS
-- ============================================================
-- Cuando se registra una devolución, este proceso verifica si
-- el libro fue entregado después de la fecha límite.
--
-- Si existe retraso, se crea automáticamente una multa.
-- Además, se actualizan los estados del préstamo y del ejemplar.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_generar_multa()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_fecha_limite TIMESTAMP;
    v_dias_retraso INT := 0;
    v_monto NUMERIC(6,2) := 0.00;
    v_id_ejemplar INT;
BEGIN

    -- Obtener la fecha límite y el ejemplar asociado al préstamo.
    SELECT fecha_limite, id_ejemplar
    INTO STRICT v_fecha_limite, v_id_ejemplar
    FROM prestamo
    WHERE id_prestamo = NEW.id_prestamo;

    -- Calcular cuántos días han pasado después de la fecha límite.
    IF NEW.fecha_recepcion > v_fecha_limite THEN
        v_dias_retraso :=
            CEIL(
                EXTRACT(
                    EPOCH FROM (
                        NEW.fecha_recepcion - v_fecha_limite
                    )
                ) / 86400
            )::INT;
    END IF;

    -- Si existe retraso, registrar la multa correspondiente.
    IF v_dias_retraso > 0 THEN

        v_monto := calcular_monto_multa(v_dias_retraso);

        INSERT INTO multa (
            id_devolucion,
            dias_retraso,
            monto_acumulado,
            estado_multa
        )
        VALUES (
            NEW.id_devolucion,
            v_dias_retraso,
            v_monto,
            'Pendiente'
        );

        RAISE NOTICE
            'Se generó una multa de $% por % días de retraso.',
            v_monto,
            v_dias_retraso;

    END IF;

    -- Marcar el préstamo como devuelto.
    UPDATE prestamo
    SET estado_prestamo = 'Devuelto'
    WHERE id_prestamo = NEW.id_prestamo;

    -- Hacer disponible nuevamente el ejemplar.
    UPDATE ejemplar
    SET estado_disponibilidad = 'Disponible'
    WHERE id_ejemplar = v_id_ejemplar;

    RETURN NEW;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION
        'No se encontró el préstamo asociado a la devolución.';
END;
$$;


-- El trigger ejecutará automáticamente la función anterior
-- cada vez que se registre una devolución.

DROP TRIGGER IF EXISTS tr_generar_multa ON devolucion;

CREATE TRIGGER tr_generar_multa
AFTER INSERT ON devolucion
FOR EACH ROW
EXECUTE FUNCTION fn_generar_multa();


-- ============================================================
-- 3. PROCEDIMIENTO: sp_registrar_prestamo
-- ============================================================
-- Este procedimiento centraliza el proceso de préstamo de libros.
--
-- Antes de registrar un préstamo se validan tres condiciones:
--
-- 1. El ejemplar debe existir y estar disponible.
-- 2. El socio no debe tener multas pendientes.
-- 3. El socio no puede tener más de tres préstamos activos.
--
-- Si todas las validaciones son correctas, el préstamo se
-- registra y el ejemplar pasa al estado "Prestado".
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_registrar_prestamo(
    p_id_ejemplar INT,
    p_id_socio INT,
    p_id_empleado_salida INT,
    p_dias_prestamo INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_estado_ejemplar VARCHAR(30);
    v_multas_pendientes INT;
    v_prestamos_activos INT;
    v_fecha_limite TIMESTAMP;
BEGIN

    -- Verificar que el ejemplar exista y esté disponible.

    SELECT estado_disponibilidad
    INTO v_estado_ejemplar
    FROM ejemplar
    WHERE id_ejemplar = p_id_ejemplar;

    IF NOT FOUND THEN
        RAISE EXCEPTION
        'El ejemplar con ID % no existe.',
        p_id_ejemplar;
    END IF;

    IF v_estado_ejemplar <> 'Disponible' THEN
        RAISE EXCEPTION
        'El ejemplar % no está disponible para préstamo.',
        p_id_ejemplar;
    END IF;


    -- Verificar si el socio tiene multas pendientes.

    SELECT COUNT(*)
    INTO v_multas_pendientes
    FROM (
        SELECT m.id_multa
        FROM prestamo p
        JOIN devolucion d ON d.id_prestamo = p.id_prestamo
        JOIN multa m ON m.id_devolucion = d.id_devolucion
        WHERE p.id_socio = p_id_socio AND m.estado_multa = 'Pendiente'
        UNION
        SELECT id_prestamo
        FROM prestamo
        WHERE id_socio = p_id_socio AND estado_prestamo = 'Activo' AND fecha_limite < CURRENT_TIMESTAMP
    ) as multas_y_retrasos;

    IF v_multas_pendientes > 0 THEN
        RAISE EXCEPTION
        'El socio tiene multas pendientes de pago o libros vencidos sin devolver.';
    END IF;


    -- Verificar que el socio no exceda el límite permitido.

    SELECT COUNT(*)
    INTO v_prestamos_activos
    FROM prestamo
    WHERE id_socio = p_id_socio
      AND estado_prestamo = 'Activo';

    IF v_prestamos_activos >= 3 THEN
        RAISE EXCEPTION
        'El socio ya posee el máximo de préstamos permitidos.';
    END IF;


    -- Calcular la fecha límite de devolución.

    v_fecha_limite :=
        CURRENT_TIMESTAMP +
        (p_dias_prestamo || ' days')::INTERVAL;


    -- Registrar el préstamo.

    INSERT INTO prestamo (
        id_ejemplar,
        id_socio,
        id_empleado_salida,
        estado_prestamo,
        fecha_salida,
        fecha_limite
    )
    VALUES (
        p_id_ejemplar,
        p_id_socio,
        p_id_empleado_salida,
        'Activo',
        CURRENT_TIMESTAMP,
        v_fecha_limite
    );


    -- Actualizar el estado del ejemplar.

    UPDATE ejemplar
    SET estado_disponibilidad = 'Prestado'
    WHERE id_ejemplar = p_id_ejemplar;


    RAISE NOTICE
        'Préstamo registrado correctamente. Fecha límite: %',
        v_fecha_limite;

END;
$$;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================