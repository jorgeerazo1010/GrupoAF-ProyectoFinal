-- ============================================================
-- PROYECTO FINAL — BASES DE DATOS
-- Escenario C: Sistema de Gestión de Biblioteca Pública
-- Script: 02_datos_iniciales.sql  (DML)
-- Descripción: Carga inicial de datos representativos
-- ============================================================

\c biblioteca_publica;

-- ============================================================
-- CATEGORIAS
-- ============================================================
INSERT INTO categorias (nombre_categoria) VALUES
    ('Ficción'),
    ('Ciencia'),
    ('Historia'),
    ('Tecnología'),
    ('Literatura Clásica'),
    ('Filosofía'),
    ('Matemáticas'),
    ('Arte');

-- ============================================================
-- EDITORIALES
-- ============================================================
INSERT INTO editoriales (nombre_editorial, pais) VALUES
    ('Planeta',             'España'),
    ('Alfaguara',           'España'),
    ('Anagrama',            'España'),
    ('Sudamericana',        'Argentina'),
    ('Fondo de Cultura',    'México'),
    ('O''Reilly',           'Estados Unidos'),
    ('Penguin Books',       'Reino Unido'),
    ('Siglo XXI',           'México');

-- ============================================================
-- AUTORES
-- ============================================================
INSERT INTO autores (nombre_autor, nacionalidad) VALUES
    ('Gabriel García Márquez',  'Colombiana'),
    ('Isabel Allende',          'Chilena'),
    ('Mario Vargas Llosa',      'Peruana'),
    ('Jorge Luis Borges',       'Argentina'),
    ('Pablo Neruda',            'Chilena'),
    ('Octavio Paz',             'Mexicana'),
    ('Carlos Fuentes',          'Mexicana'),
    ('Julio Cortázar',          'Argentina'),
    ('Stephen Hawking',         'Británica'),
    ('Yuval Noah Harari',       'Israelí');

-- ============================================================
-- LIBROS
-- ============================================================
INSERT INTO libros (isbn, titulo, anio_publicacion, id_categoria, id_editorial) VALUES
    ('978-958-42-0000-1', 'Cien años de soledad',            1967, 1, 1),
    ('978-958-42-0000-2', 'La casa de los espíritus',        1982, 1, 2),
    ('978-958-42-0000-3', 'La ciudad y los perros',          1963, 1, 3),
    ('978-958-42-0000-4', 'Ficciones',                       1944, 5, 4),
    ('978-958-42-0000-5', 'Veinte poemas de amor',           1924, 5, 5),
    ('978-958-42-0000-6', 'El laberinto de la soledad',      1950, 6, 5),
    ('978-958-42-0000-7', 'Terra Nostra',                    1975, 1, 4),
    ('978-958-42-0000-8', 'Rayuela',                         1963, 1, 3),
    ('978-958-42-0000-9', 'Una breve historia del tiempo',   1988, 2, 7),
    ('978-958-42-0001-0', 'Sapiens',                         2011, 3, 7);

-- ============================================================
-- LIBROS_AUTORES (relación libro-autor)
-- ============================================================
INSERT INTO libros_autores (isbn, id_autor) VALUES
    ('978-958-42-0000-1', 1),
    ('978-958-42-0000-2', 2),
    ('978-958-42-0000-3', 3),
    ('978-958-42-0000-4', 4),
    ('978-958-42-0000-5', 5),
    ('978-958-42-0000-6', 6),
    ('978-958-42-0000-7', 7),
    ('978-958-42-0000-8', 8),
    ('978-958-42-0000-9', 9),
    ('978-958-42-0001-0', 10);

-- ============================================================
-- EMPLEADOS
-- ============================================================
INSERT INTO empleados (nombre_empleado, cargo) VALUES
    ('Ana Martínez',    'Bibliotecaria'),
    ('Carlos López',    'Auxiliar'),
    ('María Flores',    'Bibliotecaria'),
    ('José Ramírez',    'Auxiliar'),
    ('Laura Mendoza',   'Jefe de Biblioteca');

-- ============================================================
-- SOCIOS
-- ============================================================
INSERT INTO socios (dui, nombre, direccion, telefono, correo, fecha_registro) VALUES
    ('01234567-8', 'Roberto Sánchez',   'Col. Escalón, San Salvador',   '7111-0001', 'roberto@mail.com',  '2024-01-10'),
    ('02345678-9', 'Sofía Herrera',     'Col. Miramonte, San Salvador',  '7111-0002', 'sofia@mail.com',    '2024-02-15'),
    ('03456789-0', 'Diego Castillo',    'Santa Tecla, La Libertad',      '7111-0003', 'diego@mail.com',    '2024-03-20'),
    ('04567890-1', 'Valeria Torres',    'Soyapango, San Salvador',       '7111-0004', 'valeria@mail.com',  '2024-04-05'),
    ('05678901-2', 'Miguel Aguilar',    'Mejicanos, San Salvador',       '7111-0005', 'miguel@mail.com',   '2024-05-12'),
    ('06789012-3', 'Gabriela Rivas',    'Apopa, San Salvador',           '7111-0006', 'gabriela@mail.com', '2024-06-18'),
    ('07890123-4', 'Andrés Vásquez',    'Antiguo Cuscatlán, La Libertad','7111-0007', 'andres@mail.com',   '2024-07-22'),
    ('08901234-5', 'Lucía Moreno',      'San Marcos, San Salvador',      '7111-0008', 'lucia@mail.com',    '2024-08-30');

-- ============================================================
-- EJEMPLARES (2-3 copias por libro)
-- ============================================================
INSERT INTO ejemplares (isbn, estado_disponibilidad, ubicacion_estante) VALUES
    -- Cien años de soledad
    ('978-958-42-0000-1', 'disponible',  'A-01'),
    ('978-958-42-0000-1', 'prestado',    'A-01'),
    -- La casa de los espíritus
    ('978-958-42-0000-2', 'disponible',  'A-02'),
    ('978-958-42-0000-2', 'prestado',    'A-02'),
    -- La ciudad y los perros
    ('978-958-42-0000-3', 'disponible',  'A-03'),
    -- Ficciones
    ('978-958-42-0000-4', 'disponible',  'B-01'),
    ('978-958-42-0000-4', 'disponible',  'B-01'),
    -- Veinte poemas de amor
    ('978-958-42-0000-5', 'prestado',    'B-02'),
    -- El laberinto de la soledad
    ('978-958-42-0000-6', 'disponible',  'C-01'),
    -- Terra Nostra
    ('978-958-42-0000-7', 'disponible',  'C-02'),
    -- Rayuela
    ('978-958-42-0000-8', 'disponible',  'C-03'),
    ('978-958-42-0000-8', 'dañado',      'C-03'),
    -- Una breve historia del tiempo
    ('978-958-42-0000-9', 'disponible',  'D-01'),
    -- Sapiens
    ('978-958-42-0001-0', 'disponible',  'D-02'),
    ('978-958-42-0001-0', 'prestado',    'D-02');

-- ============================================================
-- PRESTAMOS
-- (Algunos con fecha límite pasada para generar multas en pruebas)
-- ============================================================
INSERT INTO prestamos (id_inventory, id_socio, id_empleado_salida, fecha_salida, fecha_limite) VALUES
    -- Préstamo activo normal
    (2,  1, 1, NOW() - INTERVAL '5 days',  NOW() + INTERVAL '10 days'),
    -- Préstamo activo normal
    (4,  2, 2, NOW() - INTERVAL '3 days',  NOW() + INTERVAL '12 days'),
    -- Préstamo con retraso (para trigger de multa)
    (8,  3, 1, NOW() - INTERVAL '30 days', NOW() - INTERVAL '16 days'),
    -- Préstamo con retraso (para trigger de multa)
    (16, 4, 3, NOW() - INTERVAL '25 days', NOW() - INTERVAL '11 days'),
    -- Préstamo activo normal
    (15, 5, 2, NOW() - INTERVAL '2 days',  NOW() + INTERVAL '13 days');

-- ============================================================
-- DEVOLUCIONES
-- (Solo para los préstamos 3 y 4 que tienen retraso — el trigger generará multas)
-- ============================================================
INSERT INTO devoluciones (id_prestamo, id_empleado_recepcion, fecha_entrega_real) VALUES
    (3, 3, NOW() - INTERVAL '2 days'),
    (4, 1, NOW() - INTERVAL '1 day');

-- ============================================================
-- RESERVAS
-- ============================================================
INSERT INTO reservas (isbn, id_socio, fecha_solicitud, estado_reserva) VALUES
    ('978-958-42-0000-1', 6, NOW() - INTERVAL '1 day',  'activa'),
    ('978-958-42-0000-2', 7, NOW() - INTERVAL '2 days', 'activa'),
    ('978-958-42-0001-0', 8, NOW() - INTERVAL '3 days', 'activa');

-- ============================================================
-- FIN DEL SCRIPT DML
-- ============================================================
