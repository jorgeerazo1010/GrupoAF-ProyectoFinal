-- ============================================================
-- DML — Carga inicial de datos representativos y de prueba
-- ============================================================

-- ------------------------------------------------------------
-- 1. CATÁLOGOS MAESTROS
-- Información base requerida para clasificar los libros
-- ------------------------------------------------------------

-- Categorías temáticas de la biblioteca
INSERT INTO categoria (nombre_categoria) VALUES
    ('Ficción'),
    ('Ciencia y Tecnología'),
    ('Historia'),
    ('Filosofía'),
    ('Literatura Infantil'),
    ('Derecho'),
    ('Economía'),
    ('Psicología');

-- Proveedores y casas editoriales
INSERT INTO editorial (nombre_editorial, pais) VALUES
    ('Planeta',                         'España'),
    ('Anagrama',                        'España'),
    ('Fondo de Cultura Económica',      'México'),
    ('Penguin Random House',            'Estados Unidos'),
    ('Santillana',                      'España'),
    ('UCA Editores',                    'El Salvador');

-- Autores nacionales e internacionales
INSERT INTO autor (nombre_autor, nacionalidad) VALUES
    ('Gabriel García Márquez', 'Colombiana'),
    ('Isabel Allende',         'Chilena'),
    ('Yuval Noah Harari',      'Israelí'),
    ('Mario Vargas Llosa',     'Peruana'),
    ('Jorge Luis Borges',      'Argentina'),
    ('Paulo Coelho',           'Brasileña'),
    ('Umberto Eco',            'Italiana'),
    ('Octavio Paz',            'Mexicana'),
    ('Rigoberta Menchú',       'Guatemalteca'),
    ('Claribel Alegría',       'Salvadoreña');

-- ------------------------------------------------------------
-- 2. CATÁLOGO BIBLIOGRÁFICO E INVENTARIO FÍSICO
-- ------------------------------------------------------------

-- Registro de los títulos (obras conceptuales)
INSERT INTO libro (isbn, titulo, anio_publicacion, id_categoria, id_editorial) VALUES
    ('978-84-376-0494-7', 'Cien años de soledad',          1967, 1, 1),
    ('978-84-339-7428-5', 'La casa de los espíritus',      1982, 1, 2),
    ('978-84-9999-102-3', 'Sapiens: De animales a dioses', 2011, 2, 4),
    ('978-84-322-1803-3', 'La ciudad y los perros',        1963, 1, 1),
    ('978-84-204-5124-4', 'Ficciones',                     1944, 1, 3),
    ('978-84-376-0495-4', 'El alquimista',                 1988, 1, 4),
    ('978-84-376-0496-1', 'El nombre de la rosa',          1980, 1, 2),
    ('978-84-376-0497-8', 'El laberinto de la soledad',    1950, 3, 3),
    ('978-84-376-0498-5', 'Me llamo Rigoberta Menchú',     1983, 3, 5),
    ('978-503-000-001-2', 'Luisa en el país de la realidad',1987, 4, 6);

-- Vinculación (Muchos a Muchos) entre libros y sus autores
INSERT INTO libro_autor (isbn, id_autor) VALUES
    ('978-84-376-0494-7', 1),
    ('978-84-339-7428-5', 2),
    ('978-84-9999-102-3', 3),
    ('978-84-322-1803-3', 4),
    ('978-84-204-5124-4', 5),
    ('978-84-376-0495-4', 6),
    ('978-84-376-0496-1', 7),
    ('978-84-376-0497-8', 8),
    ('978-84-376-0498-5', 9),
    ('978-503-000-001-2', 10);

-- Creación de las copias físicas reales. Se insertan múltiples 
-- ejemplares por título para simular una biblioteca real.
INSERT INTO ejemplar (isbn, estado_disponibilidad, ubicacion_estante) VALUES
    ('978-84-376-0494-7', 'Prestado',    'A-01'),
    ('978-84-376-0494-7', 'Disponible',  'A-01'),
    ('978-84-376-0494-7', 'Disponible',  'A-01'),
    ('978-84-339-7428-5', 'Disponible',  'A-02'),
    ('978-84-339-7428-5', 'Prestado',    'A-02'),
    ('978-84-9999-102-3', 'Disponible',  'B-01'),
    ('978-84-9999-102-3', 'Reservado',   'B-01'),
    ('978-84-322-1803-3', 'Disponible',  'A-03'),
    ('978-84-322-1803-3', 'Mantenimiento','A-03'),
    ('978-84-204-5124-4', 'Disponible',  'A-04'),
    ('978-84-376-0495-4', 'Disponible',  'A-05'),
    ('978-84-376-0495-4', 'Prestado',    'A-05'),
    ('978-84-376-0496-1', 'Disponible',  'A-06'),
    ('978-84-376-0497-8', 'Disponible',  'C-01'),
    ('978-84-376-0497-8', 'Disponible',  'C-01'),
    ('978-84-376-0498-5', 'Disponible',  'C-02'),
    ('978-84-376-0498-5', 'Prestado',    'C-02'),
    ('978-503-000-001-2', 'Disponible',  'C-03');

-- ------------------------------------------------------------
-- 3. USUARIOS DEL SISTEMA
-- ------------------------------------------------------------

-- Miembros de la comunidad habilitados para prestar libros
INSERT INTO socio (dui, nombre, direccion, telefono, correo, fecha_registro) VALUES
    ('01234567-8', 'Ana María López',      'Col. Escalón, San Salvador',      '7001-1001', 'ana.lopez@correo.com',          '2023-03-10'),
    ('02345678-9', 'Carlos Ernesto Rivas', 'Soyapango, San Salvador',         '7002-2002', 'carlos.rivas@correo.com',       '2023-05-22'),
    ('03456789-0', 'Sofía Beatriz Morán',  'Santa Ana, Santa Ana',            '7003-3003', 'sofia.moran@correo.com',        '2023-07-15'),
    ('04567890-1', 'Diego Alejandro Cruz', 'Antiguo Cuscatlán, La Libertad',  '7004-4004', 'diego.cruz@correo.com',         '2023-09-01'),
    ('05678901-2', 'Laura Guadalupe Vega', 'Mejicanos, San Salvador',         '7005-5005', 'laura.vega@correo.com',         '2024-01-20'),
    ('06789012-3', 'Roberto José Pineda',  'San Miguel, San Miguel',          '7006-6006', 'roberto.pineda@correo.com',     '2024-02-14'),
    ('07890123-4', 'Valeria Concepción',   'Usulután, Usulután',              '7007-7007', 'valeria.concepcion@correo.com', '2024-04-05'),
    ('08901234-5', 'Marco Antonio Pérez',  'Zacatecoluca, La Paz',            '7008-8008', 'marco.perez@correo.com',        '2024-06-18');

-- Personal operativo de la biblioteca
INSERT INTO empleado (nombre_empleado, cargo, correo, fecha_registro) VALUES
    ('María Teresa Fuentes',  'Bibliotecaria Jefe', 'teresa.fuentes@biblioteca.gob.sv',  '2020-01-15'),
    ('José Antonio Herrera',  'Auxiliar',           'jose.herrera@biblioteca.gob.sv',    '2021-03-01'),
    ('Karla Vanessa Orellana','Auxiliar',           'karla.orellana@biblioteca.gob.sv',  '2022-06-10');

-- ------------------------------------------------------------
-- 4. OPERACIONES E HISTORIAL
-- ------------------------------------------------------------

-- Historial de préstamos: Incluye casos de préstamos activos y 
-- finalizados para validar las consultas de métricas.
INSERT INTO prestamo (id_ejemplar, id_socio, id_empleado_salida, estado_prestamo, fecha_salida, fecha_limite) VALUES
    (1,  1, 1, 'Activo',   '2025-06-01 09:00:00', '2025-06-15 09:00:00'),
    (5,  2, 2, 'Devuelto', '2025-05-01 10:00:00', '2025-05-15 10:00:00'),
    (12, 3, 1, 'Devuelto', '2025-04-01 08:00:00', '2025-04-15 08:00:00'),
    (17, 4, 3, 'Activo',   '2025-06-05 11:00:00', '2025-06-19 11:00:00'),
    (2,  5, 2, 'Activo',   '2025-06-10 14:00:00', '2025-06-24 14:00:00'),
    (6,  6, 1, 'Devuelto', '2025-05-10 09:00:00', '2025-05-24 09:00:00'),
    (14, 1, 3, 'Activo',   '2025-06-08 10:00:00', '2025-06-22 10:00:00'),
    (10, 7, 2, 'Activo',   '2025-06-12 16:00:00', '2025-06-26 16:00:00');

-- Registro de recepciones físicas de los préstamos devueltos.
-- Nota: La devolución del préstamo 3 se realiza fuera de tiempo.
INSERT INTO devolucion (id_prestamo, id_empleado_recepcion, fecha_recepcion) VALUES
    (2, 2, '2025-05-13 10:30:00'),
    (3, 1, '2025-04-25 09:00:00'), -- Entrega con 10 días de retraso
    (6, 3, '2025-05-20 11:00:00');

-- Inserción manual de multa para pruebas (En producción es generada por Trigger)
INSERT INTO multa (id_devolucion, dias_retraso, monto_acumulado, estado_multa) VALUES
    (2, 10, 2.50, 'Pendiente');

-- ------------------------------------------------------------
-- 5. RESERVAS DE TÍTULOS
-- ------------------------------------------------------------

-- Apartados de libros solicitados por los socios
INSERT INTO reserva (isbn, id_socio, fecha_solicitud, estado_reserva) VALUES
    ('978-84-9999-102-3', 8, '2025-06-11 08:00:00', 'Activa'),
    ('978-84-339-7428-5', 3, '2025-06-09 10:00:00', 'Activa'),
    ('978-84-376-0495-4', 2, '2025-05-20 09:00:00', 'Completada'),
    ('978-84-376-0496-1', 5, '2025-05-25 14:00:00', 'Cancelada');