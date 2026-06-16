-- ============================================================
-- PROYECTO FINAL — BASES DE DATOS
-- Sistema de Gestión de Biblioteca
-- Script de consultas SQL

--------------------------

-- En este archivo se encuentran las consultas utilizadas para
-- obtener información del sistema y generar reportes de apoyo
-- para la administración de la biblioteca.
-- ============================================================

-- ============================================================
-- CONSULTA 1:
-- Libros más prestados en los últimos 3 meses.

----------------------------------------------

-- Muestra los libros que han sido prestados con mayor frecuencia
-- durante los últimos tres meses.
-- ============================================================

SELECT l.isbn,
       l.titulo,
       COUNT(p.id_prestamo) AS total_prestamos
FROM prestamo p
JOIN ejemplar e ON e.id_ejemplar = p.id_ejemplar
JOIN libro l ON l.isbn = e.isbn
WHERE p.fecha_salida >= CURRENT_TIMESTAMP - INTERVAL '3 months'
GROUP BY l.isbn, 
         l.titulo
ORDER BY total_prestamos DESC;

-- ============================================================
-- CONSULTA 2:
-- Socios con multas pendientes.

-------------------------------

-- Lista los socios que tienen multas sin pagar y muestra el
-- monto total adeudado por cada uno.

-------------------------------------

-- También considera préstamos vencidos que todavía no han sido
-- devueltos.
-- ============================================================

SELECT s.id_socio,
       s.nombre,
       s.correo,
       s.telefono,
       COUNT(DISTINCT m.id_multa) AS cantidad_multas,
       SUM(m.monto_acumulado) AS deuda_total
FROM socio s
JOIN prestamo p ON p.id_socio = s.id_socio
LEFT JOIN devolucion d ON d.id_prestamo = p.id_prestamo
LEFT JOIN multa m ON m.id_devolucion = d.id_devolucion
WHERE m.estado_multa = 'Pendiente'
   OR (p.estado_prestamo = 'Activo' AND p.fecha_limite < CURRENT_DATE)
GROUP BY s.id_socio, 
         s.nombre, 
         s.correo, 
         s.telefono
ORDER BY deuda_total DESC;

-- ============================================================
-- CONSULTA 3:
-- Autores con más libros registrados.

-------------------------------------

-- Permite ver qué autores tienen más títulos dentro del catálogo
-- de la biblioteca.
-- ============================================================

SELECT a.id_autor,
       a.nombre_autor,
       a.nacionalidad,
       COUNT(la.isbn) AS total_titulos
FROM autor a
JOIN libro_autor la ON la.id_autor = a.id_autor
GROUP BY a.id_autor, 
         a.nombre_autor, 
         a.nacionalidad
ORDER BY total_titulos DESC;

-- ============================================================
-- CONSULTA 4
-- Ejemplares que nunca han sido prestados.

------------------------------------------

-- Muestra los ejemplares que no poseen registros en la tabla
-- de préstamos.
-- ============================================================

SELECT e.id_ejemplar,
       e.ubicacion_estante,
       e.estado_disponibilidad,
       l.isbn,
       l.titulo
FROM ejemplar e
JOIN libro l ON l.isbn = e.isbn
WHERE e.id_ejemplar NOT IN (
    SELECT DISTINCT id_ejemplar
    FROM prestamo
)
ORDER BY l.titulo, 
         e.id_ejemplar;

-- ============================================================
-- CONSULTA 5:
-- Empleado con más préstamos registrados este mes.

--------------------------------------------------

-- Muestra el empleado que ha gestionado la mayor cantidad de
-- préstamos durante el mes actual.
-- ============================================================

SELECT
    em.id_empleado,
    em.nombre_empleado,
    em.cargo,
    COUNT(p.id_prestamo)   AS prestamos_procesados
FROM empleado  em
JOIN prestamo  p ON p.id_empleado_salida = em.id_empleado
WHERE DATE_TRUNC('month', p.fecha_salida) = DATE_TRUNC('month', CURRENT_DATE)
GROUP BY em.id_empleado, em.nombre_empleado, em.cargo
ORDER BY prestamos_procesados DESC
LIMIT 1;



-- ============================================================
-- REPORTES COMPLEMENTARIOS
-- ============================================================

---

-- REPORTE A:
-- Préstamos pendientes de devolución.

-------------------------------------

-- Permite revisar los préstamos que siguen activos y verificar
-- si la fecha límite ya fue superada.

---

SELECT p.id_prestamo,
       s.nombre AS socio,
       l.titulo AS libro,
       p.fecha_salida,
       p.fecha_limite,
       CASE 
            WHEN p.fecha_limite < CURRENT_DATE THEN 'Vencido'
            ELSE 'En tiempo'
       END AS estado_entrega
FROM prestamo p
JOIN socio s    ON p.id_socio = s.id_socio
JOIN ejemplar e ON p.id_ejemplar = e.id_ejemplar
JOIN libro l    ON e.isbn = l.isbn
WHERE p.id_prestamo NOT IN (
    SELECT id_prestamo
    FROM devolucion
)
ORDER BY p.fecha_limite;

---

-- REPORTE B:
-- Estado actual de los ejemplares.

----------------------------------

-- Muestra todos los ejemplares registrados junto con su estado
-- actual y la ubicación donde se encuentran.

---

SELECT l.titulo,
       e.id_ejemplar,
       e.estado_disponibilidad,
       e.ubicacion_estante
FROM ejemplar e
JOIN libro l ON e.isbn = l.isbn
ORDER BY l.titulo, 
         e.id_ejemplar;