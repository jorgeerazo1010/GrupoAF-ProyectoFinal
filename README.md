# Sistema de Gestión de Base de Datos para Biblioteca

Este repositorio contiene el diseño e implementación de la solución de base de datos relacional para el sistema de gestión de la biblioteca, desarrollado como proyecto final para la cátedra de Bases de Datos.

El sistema está completamente normalizado en **Tercera Forma Normal (3FN)** y diseñado de forma robusta para garantizar la integridad referencial, el rendimiento óptimo y la automatización de las reglas de negocio de la biblioteca (gestión de inventario, préstamos, devoluciones, multas automáticas y reservas).

## 🛠️ Tecnologías Utilizadas
* **Motor de Base de Datos:** PostgreSQL
* **Cliente de Gestión SQL:** DBeaver
* **Herramientas de Modelado:** dbdiagram.io & ERDPlus
* **Control de Versiones:** Git & GitHub

---

## 📂 Estructura del Repositorio

El proyecto se encuentra organizado de la siguiente manera para facilitar su revisión y despliegue técnico:

* 📁 `docs/`
  * `diagrama_chen.png` — Modelo Conceptual inicial (Notación Chen) con entidades, atributos propios y relaciones.
  * `esquema_relacional_3fn.pdf` — Modelo Lógico definitivo exportado con restricciones completas e indicadores de cardinalidad (1:1 y 1:N).
* 📁 `scripts/`
  * `01_ddl_tablas.sql` — Script de creación de la base de datos, definición de tablas (`CREATE TABLE`), llaves primarias, llaves foráneas y restricciones avanzadas (`NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`).
  * `02_dml_inserts.sql` — Script de población de la base de datos con registros de prueba consistentes para cada una de las 11 tablas.
  * `03_consultas_reportes.sql` — Consultas de selección, uniones (`JOIN`), agregaciones y reportes analíticos solicitados en los requerimientos.
  * `04_triggers_funciones.sql` — Funciones almacenadas y triggers para la automatización de la lógica del negocio (como el cálculo y generación de multas por retrasos).

---

## 🚀 Instrucciones de Ejecución y Despliegue

Para replicar y montar este entorno de base de datos desde cero, siga estrictamente el orden de ejecución de los scripts dentro de su cliente SQL (DBeaver) conectado a una instancia de PostgreSQL:

### Paso 1: Inicialización de la Estructura (DDL)
Ejecute el archivo `scripts/01_ddl_tablas.sql`. Esto creará el esquema limpio con las 11 tablas obligatorias y la tabla de ruptura `libros_autores`, aplicando restricciones `CHECK` para blindar los estados de disponibilidad y asegurar la coherencia de fechas.

### Paso 2: Carga de Datos (DML)
Ejecute el archivo `scripts/02_dml_inserts.sql`. Esto insertará los datos maestros de categorías, editoriales, autores, libros, ejemplares físicos, socios y empleados, seguidos de transacciones reales de préstamos y reservas para testing.

### Paso 3: Funciones y Automatizaciones
Ejecute el archivo `scripts/04_triggers_funciones.sql` para compilar los disparadores lógicos encargados del control interno del sistema antes de correr las pruebas de consultas.

### Paso 4: Pruebas y Reportes
Abra y ejecute de forma individual las consultas contenidas en `scripts/03_consultas_reportes.sql` para verificar la correcta extracción de métricas, reportes de morosidad y rendimiento del inventario.
