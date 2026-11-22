# RutaAndina — Sistema de Gestión de Taxis por Aplicación (Perú / Colombia)

Prototipo funcional y modelo de base de datos relacional para **RutaAndina**, una plataforma binacional de movilidad y transporte corporativo que opera en **Perú (PEN)** y **Colombia (COP)**, desarrollado en el marco del proyecto académico **COIL (Tecsup — Politécnico Grancolombiano)**.

---

## 1. Arquitectura y Tecnologías

* **Base de Datos:** MySQL 8.0+ (17 entidades normalizadas hasta 3FN, integridad referencial explícita, historial de estados de viaje y soporte multimoneda).
* **Backend:** Node.js con Express y `mysql2` (API REST con pool de conexiones y consultas parametrizadas).
* **Frontend:** HTML5, CSS3 y JavaScript Vanilla con control de acceso por sesión y rol (`Pasajero`, `Conductor` y `Empresa`).

### Estructura del Proyecto

```text
BD_COIL_Equipo3_RutaAndina/
├── backend/
│   ├── package.json
│   └── server.js              # Servidor Express y endpoints conectados a MySQL
├── database/
│   ├── 01_ddl.sql             # Creación de esquema y 17 tablas con restricciones
│   ├── 02_dml.sql             # Carga inicial (20 pasajeros, 10 conductores, 10 vehículos, 3 empresas, 50 viajes)
│   └── 03_consultas.sql       # 8 consultas analíticas de negocio + 1 vista consolidada
├── frontend/
│   ├── auth.js                # Protección de rutas por rol en el navegador
│   ├── login.html             # Acceso por perfil y registro de nuevos pasajeros
│   ├── pasajero.html          # Solicitud de viajes (personal/corporativo), historial y calificación
│   ├── conductor.html         # Gestión de solicitudes y flujo de estados (Aceptado -> En curso -> Finalizado)
│   ├── empresa.html           # Reporte y control de consumo mensual corporativo
│   └── styles.css             # Hoja de estilos unificada
└── README.md