-- ============================================================
-- PROYECTO FINAL — BASES DE DATOS
-- Sistema de Gestión de Biblioteca Pública
-- Parte 1: Función de cálculo de multas y trigger de devolución
-- ============================================================


-- ============================================================
-- 1. FUNCIÓN: calcular_monto_multa
-- ============================================================
-- Recibe la cantidad de días de retraso y devuelve el monto
-- que debe pagar el socio.
-- Tarifa fija: $0.25 por cada día de atraso.
-- ============================================================

CREATE OR REPLACE FUNCTION calcular_monto_multa(p_dias_retraso INT)
RETURNS NUMERIC(6, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tarifa_diaria CONSTANT NUMERIC(6, 2) := 0.25;
BEGIN

    -- Si no existe retraso, no se genera ningún cobro.
    IF p_dias_retraso <= 0 THEN
        RETURN 0.00;
    END IF;

    RETURN (p_dias_retraso * v_tarifa_diaria)::NUMERIC(6, 2);

END;
$$;


-- ============================================================
-- 2. FUNCIÓN DEL TRIGGER: fn_generar_multa
-- ============================================================
-- Al registrarse una devolución, verifica si el libro fue
-- entregado después de la fecha límite.
-- Si hay retraso, crea la multa y actualiza préstamo y ejemplar.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_generar_multa()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_fecha_limite   TIMESTAMP;
    v_dias_retraso   INT            := 0;
    v_monto          NUMERIC(6, 2)  := 0.00;
    v_id_ejemplar    INT;
BEGIN

    -- Obtener la fecha límite y el ejemplar asociado al préstamo.
    SELECT fecha_limite, id_ejemplar
    INTO STRICT v_fecha_limite, v_id_ejemplar
    FROM prestamo
    WHERE id_prestamo = NEW.id_prestamo;

    -- Calcular cuántos días pasaron después de la fecha límite.
    IF NEW.fecha_recepcion > v_fecha_limite THEN
        v_dias_retraso :=
            CEIL(
                EXTRACT(
                    EPOCH FROM (NEW.fecha_recepcion - v_fecha_limite)
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


-- ============================================================
-- 3. TRIGGER: tr_generar_multa
-- ============================================================
-- Ejecuta fn_generar_multa automáticamente después de cada
-- INSERT en la tabla devolucion.
-- ============================================================

DROP TRIGGER IF EXISTS tr_generar_multa ON devolucion;

CREATE TRIGGER tr_generar_multa
AFTER INSERT ON devolucion
FOR EACH ROW
EXECUTE FUNCTION fn_generar_multa();