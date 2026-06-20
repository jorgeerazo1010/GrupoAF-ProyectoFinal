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

```
GrupoAF-ProyectoFinal/
├── Diagrams/
│   ├── diagrama_er_chen.jpeg
│   └── esquema_relacional_3fn/
│       ├── esquema_relacional_3fn.png
│       └── esquema_relacional_3fn.pdf
│
├── Docs/
│   └── sistema_gestion_biblioteca.pdf
│
└── Scripts/
    ├── 01_ddl_tablas.sql
    ├── 02_dml_inserts.sql
    ├── 03_consultas_reportes.sql
    └── 04_triggers_funciones.sql
```

* 📁 `Diagrams/` — Material de diseño y modelado de la base de datos.
  * `diagrama_er_chen.jpeg` — Modelo Conceptual inicial (Notación Chen) con entidades, atributos propios y relaciones.
  * `esquema_relacional_3fn/` — Modelo Lógico definitivo, disponible tanto en imagen (`.png`) como en PDF, con restricciones completas e indicadores de cardinalidad (1:1 y 1:N).
* 📁 `Docs/` — Entregable final del proyecto.
  * `sistema_gestion_biblioteca.pdf` — Documento técnico completo: descripción del escenario, diagramas, diccionario de datos y documentación de consultas y programación de base de datos.
* 📁 `Scripts/` — Scripts SQL listos para ejecutar en PostgreSQL.
  * `01_ddl_tablas.sql` — Script de creación de la base de datos, definición de tablas (`CREATE TABLE`), llaves primarias, llaves foráneas y restricciones avanzadas (`NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`).
  * `02_dml_inserts.sql` — Script de población de la base de datos con registros de prueba consistentes para cada una de las 12 tablas.
  * `03_consultas_reportes.sql` — Consultas de selección, uniones (`JOIN`), agregaciones y reportes analíticos solicitados en los requerimientos.
  * `04_triggers_funciones.sql` — Funciones almacenadas y triggers para la automatización de la lógica del negocio (como el cálculo y generación de multas por retrasos).

---

## 🚀 Instrucciones de Ejecución y Despliegue

Para replicar y montar este entorno de base de datos desde cero, siga estrictamente el siguiente orden dentro de su cliente SQL (DBeaver) conectado a una instancia de PostgreSQL. **Nota:** el orden de ejecución no coincide con la numeración de los archivos — los triggers (`04`) deben crearse antes de probar las consultas (`03`), ya que varios reportes dependen de la lógica automatizada de multas.

### Paso 1: Inicialización de la Estructura (DDL)
Ejecute el archivo `Scripts/01_ddl_tablas.sql`. Esto creará el esquema limpio con las 12 tablas obligatorias (`categoria`, `editorial`, `autor`, `libro`, `libro_autor`, `ejemplar`, `socio`, `empleado`, `prestamo`, `devolucion`, `multa`, `reserva`), incluyendo la tabla de ruptura `libro_autor`, y aplicando restricciones `CHECK` para blindar los estados de disponibilidad y asegurar la coherencia de fechas.

### Paso 2: Carga de Datos (DML)
Ejecute el archivo `Scripts/02_dml_inserts.sql`. Esto insertará los datos maestros de categorías, editoriales, autores, libros, ejemplares físicos, socios y empleados, seguidos de transacciones reales de préstamos y reservas para testing.

### Paso 3: Funciones y Automatizaciones
Ejecute el archivo `Scripts/04_triggers_funciones.sql` para compilar los disparadores lógicos encargados del control interno del sistema antes de correr las pruebas de consultas.

### Paso 4: Pruebas y Reportes
Abra y ejecute de forma individual las consultas contenidas en `Scripts/03_consultas_reportes.sql` para verificar la correcta extracción de métricas, reportes de morosidad y rendimiento del inventario.
