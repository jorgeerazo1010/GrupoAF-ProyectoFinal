 -- ============================================================
-- PROYECTO FINAL — BASES DE DATOS
-- Escenario C: Sistema de Gestión de Biblioteca Pública
-- Script: DDL — Creación de tablas y restricciones
-- Motor: PostgreSQL 17
-- ============================================================

-- ------------------------------------------------------------
-- 0. PREPARACIÓN: Eliminar y crear la base de datos limpia
-- ------------------------------------------------------------
-- Ejecutar estas dos líneas conectado a la BD "postgres" antes
-- de correr el resto del script:
--
    DROP DATABASE IF EXISTS biblioteca_db;
    CREATE DATABASE biblioteca_db;

-- Luego debemos conectarnos a la base de datos y ejecutar el script
-- ------------------------------------------------------------

-- ============================================================
-- 1. TABLAS BÁSICAS DEL SISTEMA
-- ============================================================

-- Tabla donde se almacenan las categorías o géneros de los libros.
CREATE TABLE categoria (
    id_categoria     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_categoria VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla que guarda la información de las editoriales que publican
-- los libros disponibles en la biblioteca.
CREATE TABLE editorial (
    id_editorial     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_editorial VARCHAR(150) NOT NULL,
    pais             VARCHAR(100)
);

-- Tabla utilizada para registrar los autores de los libros.
CREATE TABLE autor (
    id_autor     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_autor VARCHAR(150) NOT NULL,
    nacionalidad VARCHAR(100)
);


-- ============================================================
-- 2. CATÁLOGO DE LIBROS
-- ============================================================

-- Contiene la información general de cada libro.
-- Se utiliza el ISBN como identificador único.
CREATE TABLE libro (
    isbn             VARCHAR(20) PRIMARY KEY,
    titulo           VARCHAR(250) NOT NULL,
    anio_publicacion INT,
    id_categoria     INT NOT NULL,
    id_editorial     INT NOT NULL,

    CONSTRAINT fk_libro_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria),

    CONSTRAINT fk_libro_editorial
        FOREIGN KEY (id_editorial)
        REFERENCES editorial (id_editorial)
);

-- Relación entre libros y autores.
-- Un libro puede tener varios autores y un autor puede
-- participar en varios libros.
CREATE TABLE libro_autor (
    isbn     VARCHAR(20) NOT NULL,
    id_autor INT NOT NULL,

    CONSTRAINT pk_libro_autor
        PRIMARY KEY (isbn, id_autor),

    CONSTRAINT fk_la_libro
        FOREIGN KEY (isbn)
        REFERENCES libro (isbn)
        ON DELETE CASCADE,

    CONSTRAINT fk_la_autor
        FOREIGN KEY (id_autor)
        REFERENCES autor (id_autor)
        ON DELETE CASCADE
);

-- Cada registro representa una copia física de un libro.
-- Esto permite tener varios ejemplares del mismo título.
CREATE TABLE ejemplar (
    id_ejemplar           INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    isbn                  VARCHAR(20) NOT NULL,
    estado_disponibilidad VARCHAR(30) NOT NULL DEFAULT 'Disponible',
    ubicacion_estante     VARCHAR(50),

    CONSTRAINT fk_ejemplar_libro
        FOREIGN KEY (isbn)
        REFERENCES libro (isbn),

    CONSTRAINT chk_ejemplar_estado
        CHECK (
            estado_disponibilidad IN
            ('Disponible','Prestado','Reservado','Mantenimiento')
        )
);


-- ============================================================
-- 3. PERSONAS QUE UTILIZAN EL SISTEMA
-- ============================================================

-- Tabla que almacena los socios registrados en la biblioteca.
-- Los socios son los usuarios autorizados para solicitar préstamos.
CREATE TABLE socio (
    id_socio       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dui            VARCHAR(10) UNIQUE NOT NULL,
    nombre         VARCHAR(150) NOT NULL,
    direccion      TEXT,
    telefono       VARCHAR(15) UNIQUE,
    correo         VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT chk_socio_dui
        CHECK (dui ~ '^\d{8}-\d$'),

    CONSTRAINT chk_socio_correo
        CHECK (correo ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$'),

    CONSTRAINT chk_socio_telefono
        CHECK (telefono ~ '^[67]\d{3}-\d{4}$')
);

-- Tabla donde se registran los empleados encargados de realizar
-- préstamos, devoluciones y otras operaciones administrativas.
CREATE TABLE empleado (
    id_empleado     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_empleado VARCHAR(150) NOT NULL,
    cargo           VARCHAR(50) NOT NULL,
    correo          VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro  DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT chk_empleado_correo
        CHECK (correo ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$')
);


-- ============================================================
-- 4. CONTROL DE PRÉSTAMOS Y DEVOLUCIONES
-- ============================================================

-- Registra cada préstamo realizado en la biblioteca.
-- Se guarda el ejemplar prestado, el socio que lo solicita,
-- el empleado responsable y la fecha límite de devolución.
CREATE TABLE prestamo (
    id_prestamo        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_ejemplar        INT NOT NULL,
    id_socio           INT NOT NULL,
    id_empleado_salida INT NOT NULL,
    estado_prestamo    VARCHAR(20) NOT NULL DEFAULT 'Activo',
    fecha_salida       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_limite       TIMESTAMP NOT NULL,

    CONSTRAINT fk_prestamo_ejemplar
        FOREIGN KEY (id_ejemplar)
        REFERENCES ejemplar (id_ejemplar),

    CONSTRAINT fk_prestamo_socio
        FOREIGN KEY (id_socio)
        REFERENCES socio (id_socio),

    CONSTRAINT fk_prestamo_empleado_salida
        FOREIGN KEY (id_empleado_salida)
        REFERENCES empleado (id_empleado),

    CONSTRAINT chk_prestamo_fechas
        CHECK (fecha_limite > fecha_salida),

    CONSTRAINT chk_prestamo_estado
        CHECK (
            estado_prestamo IN
            ('Activo','Devuelto','Vencido')
        )
);

-- Registra la devolución de un préstamo.
-- Cada préstamo puede tener únicamente una devolución asociada.
CREATE TABLE devolucion (
    id_devolucion         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_prestamo           INT UNIQUE NOT NULL,
    id_empleado_recepcion INT NOT NULL,
    fecha_recepcion       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_devolucion_prestamo
        FOREIGN KEY (id_prestamo)
        REFERENCES prestamo (id_prestamo),

    CONSTRAINT fk_devolucion_empleado
        FOREIGN KEY (id_empleado_recepcion)
        REFERENCES empleado (id_empleado)
);

-- Almacena las multas generadas por retrasos en la devolución
-- de los libros prestados.
CREATE TABLE multa (
    id_multa        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_devolucion   INT UNIQUE NOT NULL,
    dias_retraso    INT NOT NULL,
    monto_acumulado NUMERIC(6,2) NOT NULL,
    estado_multa    VARCHAR(20) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT fk_multa_devolucion
        FOREIGN KEY (id_devolucion)
        REFERENCES devolucion (id_devolucion),

    CONSTRAINT chk_multa_estado
        CHECK (estado_multa IN ('Pendiente','Pagada')),

    CONSTRAINT chk_multa_dias
        CHECK (dias_retraso > 0),

    CONSTRAINT chk_multa_monto
        CHECK (monto_acumulado > 0)
);


-- ============================================================
-- 5. RESERVAS
-- ============================================================

-- Permite que un socio reserve un libro cuando no hay
-- ejemplares disponibles para préstamo inmediato.
CREATE TABLE reserva (
    id_reserva      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    isbn            VARCHAR(20) NOT NULL,
    id_socio        INT NOT NULL,
    fecha_solicitud TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_reserva  VARCHAR(20) NOT NULL DEFAULT 'Activa',

    CONSTRAINT fk_reserva_libro
        FOREIGN KEY (isbn)
        REFERENCES libro (isbn),

    CONSTRAINT fk_reserva_socio
        FOREIGN KEY (id_socio)
        REFERENCES socio (id_socio),

    CONSTRAINT chk_reserva_estado
        CHECK (
            estado_reserva IN
            ('Activa','Completada','Cancelada')
        )
);
