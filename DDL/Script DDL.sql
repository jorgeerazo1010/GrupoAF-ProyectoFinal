-- ============================================================
-- PROYECTO FINAL — BASES DE DATOS
-- Escenario C: Sistema de Gestión de Biblioteca Pública
-- SCRIPT DDL 
-- ============================================================

-- Crear y conectar a la base de datos
CREATE DATABASE biblioteca_publica;
\c biblioteca_publica;

-- ============================================================
-- TABLA: categorias
-- Almacena las categorías o géneros literarios de los libros
-- ============================================================
CREATE TABLE categorias (
    id_categoria    SERIAL          PRIMARY KEY,
    nombre_categoria VARCHAR(100)   NOT NULL UNIQUE
);

-- ============================================================
-- TABLA: editoriales
-- Almacena la información de las editoriales que publican libros
-- ============================================================
CREATE TABLE editoriales (
    id_editorial    SERIAL          PRIMARY KEY,
    nombre_editorial VARCHAR(150)   NOT NULL,
    pais            VARCHAR(100)
);

-- ============================================================
-- TABLA: autores
-- Almacena los autores registrados en el catálogo
-- ============================================================
CREATE TABLE autores (
    id_autor        SERIAL          PRIMARY KEY,
    nombre_autor    VARCHAR(150)    NOT NULL,
    nacionalidad    VARCHAR(100)
);

-- ============================================================
-- TABLA: libros
-- Catálogo principal de libros (un libro puede tener varios ejemplares)
-- ============================================================
CREATE TABLE libros (
    isbn            VARCHAR(20)     PRIMARY KEY,
    titulo          VARCHAR(250)    NOT NULL,
    anio_publicacion INT,
    id_categoria    INT             NOT NULL,
    id_editorial    INT             NOT NULL,
    CONSTRAINT fk_libro_categoria  FOREIGN KEY (id_categoria)  REFERENCES categorias(id_categoria),
    CONSTRAINT fk_libro_editorial  FOREIGN KEY (id_editorial)  REFERENCES editoriales(id_editorial)
);

-- ============================================================
-- TABLA: libros_autores
-- Tabla intermedia para la relación muchos-a-muchos entre libros y autores
-- ============================================================
CREATE TABLE libros_autores (
    isbn            VARCHAR(20)     NOT NULL,
    id_autor        INT             NOT NULL,
    PRIMARY KEY (isbn, id_autor),
    CONSTRAINT fk_la_libro  FOREIGN KEY (isbn)      REFERENCES libros(isbn),
    CONSTRAINT fk_la_autor  FOREIGN KEY (id_autor)  REFERENCES autores(id_autor)
);

-- ============================================================
-- TABLA: empleados
-- Personal de la biblioteca que procesa préstamos y devoluciones
-- ============================================================
CREATE TABLE empleados (
    id_empleado     SERIAL          PRIMARY KEY,
    nombre_empleado VARCHAR(150)    NOT NULL,
    cargo           VARCHAR(50)     NOT NULL
);

-- ============================================================
-- TABLA: socios
-- Miembros registrados de la biblioteca que pueden realizar préstamos
-- ============================================================
CREATE TABLE socios (
    id_socio        SERIAL          PRIMARY KEY,
    dui             VARCHAR(10)     NOT NULL UNIQUE,
    nombre          VARCHAR(150)    NOT NULL,
    direccion       TEXT,
    telefono        VARCHAR(15),
    correo          VARCHAR(100)    NOT NULL UNIQUE,
    fecha_registro  DATE            NOT NULL DEFAULT CURRENT_DATE
);

-- ============================================================
-- TABLA: ejemplares
-- Copias físicas de cada libro disponibles en la biblioteca
-- ============================================================
CREATE TABLE ejemplares (
    id_inventory        SERIAL          PRIMARY KEY,
    isbn                VARCHAR(20)     NOT NULL,
    estado_disponibilidad VARCHAR(30)   NOT NULL DEFAULT 'disponible',
    ubicacion_estante   VARCHAR(50),
    CONSTRAINT fk_ejemplar_libro  FOREIGN KEY (isbn) REFERENCES libros(isbn),
    CONSTRAINT chk_estado_ejemplar CHECK (estado_disponibilidad IN ('disponible', 'prestado', 'reservado', 'dañado'))
);

-- ============================================================
-- TABLA: prestamos
-- Registro de cada préstamo de un ejemplar a un socio
-- ============================================================
CREATE TABLE prestamos (
    id_prestamo         SERIAL          PRIMARY KEY,
    id_inventory        INT             NOT NULL,
    id_socio            INT             NOT NULL,
    id_empleado_salida  INT             NOT NULL,
    fecha_salida        TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_limite        TIMESTAMP       NOT NULL,
    CONSTRAINT fk_prestamo_ejemplar   FOREIGN KEY (id_inventory)       REFERENCES ejemplares(id_inventory),
    CONSTRAINT fk_prestamo_socio      FOREIGN KEY (id_socio)           REFERENCES socios(id_socio),
    CONSTRAINT fk_prestamo_empleado   FOREIGN KEY (id_empleado_salida) REFERENCES empleados(id_empleado)
);

-- ============================================================
-- TABLA: devoluciones
-- Registro de la devolución de cada préstamo
-- ============================================================
CREATE TABLE devoluciones (
    id_devolucion           SERIAL      PRIMARY KEY,
    id_prestamo             INT         NOT NULL UNIQUE,
    id_empleado_recepcion   INT         NOT NULL,
    fecha_entrega_real      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_devolucion_prestamo  FOREIGN KEY (id_prestamo)             REFERENCES prestamos(id_prestamo),
    CONSTRAINT fk_devolucion_empleado  FOREIGN KEY (id_empleado_recepcion)   REFERENCES empleados(id_empleado)
);

-- ============================================================
-- TABLA: multas
-- Multas generadas por devoluciones con retraso
-- ============================================================
CREATE TABLE multas (
    id_multa        SERIAL          PRIMARY KEY,
    id_devolucion   INT             NOT NULL UNIQUE,
    monto_acumulado NUMERIC(6,2)    NOT NULL,
    estado_multa    VARCHAR(20)     NOT NULL DEFAULT 'pendiente',
    CONSTRAINT fk_multa_devolucion  FOREIGN KEY (id_devolucion) REFERENCES devoluciones(id_devolucion),
    CONSTRAINT chk_estado_multa     CHECK (estado_multa IN ('pendiente', 'pagada'))
);

-- ============================================================
-- TABLA: reservas
-- Reservas de libros que están actualmente en préstamo
-- ============================================================
CREATE TABLE reservas (
    id_reserva      SERIAL          PRIMARY KEY,
    isbn            VARCHAR(20)     NOT NULL,
    id_socio        INT             NOT NULL,
    fecha_solicitud TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_reserva  VARCHAR(20)     NOT NULL DEFAULT 'activa',
    CONSTRAINT fk_reserva_libro  FOREIGN KEY (isbn)     REFERENCES libros(isbn),
    CONSTRAINT fk_reserva_socio  FOREIGN KEY (id_socio) REFERENCES socios(id_socio),
    CONSTRAINT chk_estado_reserva CHECK (estado_reserva IN ('activa', 'completada', 'cancelada'))
);

