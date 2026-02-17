# 🚚 Logistic_Foods

Sistema backend de gestión de pedidos, usuarios y logística de entregas.

**Logistic_Foods** es una base de datos relacional optimizada junto con un conjunto de Stored Procedures diseñados para soportar una plataforma tipo delivery con:

- 👤 Gestión de usuarios (Admin, Client, Delivery)
- 🔐 Autenticación segura
- 🛍 Gestión de productos y categorías
- 📦 Gestión de órdenes
- 🚚 Asignación de repartidores
- 📍 Direcciones con coordenadas GPS
- 🔔 Soporte para notificaciones push

---

# 📌 Tabla de Contenido

- [Arquitectura General](#-arquitectura-general)
- [Modelo Relacional](#-modelo-relacional)
- [Estructura de Base de Datos](#-estructura-de-base-de-datos)
- [Stored Procedures](#-stored-procedures)
- [Flujo del Sistema](#-flujo-del-sistema)
- [Seguridad](#-seguridad)
- [Índices y Rendimiento](#-índices-y-rendimiento)
- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Escalabilidad](#-escalabilidad)

---

# 🧠 Arquitectura General

El sistema está basado en:

- MySQL / MariaDB
- Motor InnoDB
- Integridad referencial
- Transacciones en operaciones críticas
- Uso de DECIMAL para valores monetarios
- Coordenadas GPS con precisión decimal

Diseñado para integrarse con:

- Node.js
- Java / Spring Boot
- .NET
- Flutter / React Native

---

# 🗂 Modelo Relacional

```
roles
   │
users ─── person ─── addresses
                 │
                 ├── orders ─── order_details ─── products ─── categories
                                   │
                                   └── image_product
```

---

# 🗄 Estructura de Base de Datos

## 1️⃣ roles
Define los tipos de usuario del sistema.

| Campo | Tipo |
|-------|------|
| id | INT (PK) |
| rol | VARCHAR(50) |
| description | VARCHAR(100) |
| state | BOOLEAN |

Roles iniciales:
- Admin
- Client
- Delivery

---

## 2️⃣ person
Contiene información personal del usuario.

| Campo | Tipo |
|-------|------|
| uid | INT (PK) |
| firstName | VARCHAR(50) |
| lastName | VARCHAR(50) |
| phone | VARCHAR(15) |
| image | VARCHAR(255) |
| state | BOOLEAN |
| created_at | DATETIME |

---

## 3️⃣ users
Tabla de autenticación.

| Campo | Tipo |
|-------|------|
| username | VARCHAR(50) |
| email | VARCHAR(100) UNIQUE |
| password_hash | VARCHAR(255) |
| persona_id | FK → person |
| rol_id | FK → roles |
| notification_token | VARCHAR(255) |

---

## 4️⃣ addresses
Direcciones asociadas a usuarios.

| Campo | Tipo |
|-------|------|
| street | VARCHAR(100) |
| reference | VARCHAR(100) |
| latitude | DECIMAL(10,8) |
| longitude | DECIMAL(11,8) |
| persona_id | FK → person |

---

## 5️⃣ categories
Categorías de productos.

---

## 6️⃣ products

| Campo | Tipo |
|-------|------|
| nameProduct | VARCHAR(100) |
| description | VARCHAR(255) |
| price | DECIMAL(11,2) |
| stock | INT |
| status | BOOLEAN |
| category_id | FK → categories |

---

## 7️⃣ image_product
Imágenes asociadas a productos.

Relación 1:N con products.

---

## 8️⃣ orders

| Campo | Tipo |
|-------|------|
| client_id | FK → person |
| delivery_id | FK → person |
| address_id | FK → addresses |
| latitude | DECIMAL |
| longitude | DECIMAL |
| status | VARCHAR(50) |
| amount | DECIMAL(11,2) |
| pay_type | VARCHAR(50) |
| created_at | DATETIME |

Estados recomendados:
- PENDING
- ACCEPTED
- ON_THE_WAY
- DELIVERED
- CANCELED

---

## 9️⃣ order_details

| Campo | Tipo |
|-------|------|
| order_id | FK → orders |
| product_id | FK → products |
| quantity | INT |
| price | DECIMAL(11,2) |

---

# ⚙ Stored Procedures

## 🔐 SP_REGISTER
Registra un nuevo usuario usando transacción.

- Inserta en `person`
- Inserta en `users`
- Rollback automático si ocurre error

---

## 🔐 SP_LOGIN
Obtiene información del usuario por email.

Devuelve:
- Datos personales
- Rol
- Token
- Hash de contraseña

---

## 🔄 SP_RENEWTOKENLOGIN
Renueva sesión por ID.

---

## 👤 SP_UPDATE_PROFILE
Actualiza información personal.

---

## 🔎 SP_USER_BY_ID
Obtiene información completa del usuario.

---

## 🗂 SP_ADD_CATEGORY
Inserta nueva categoría.

---

## 🛍 SP_GET_PRODUCTS_TOP
Obtiene los últimos 10 productos activos con imagen principal.

---

## 🔎 SP_SEARCH_PRODUCT
Busca productos por nombre usando LIKE.

---

## 📦 SP_ALL_ORDERS_STATUS
Obtiene órdenes filtradas por estado con información completa:

- Cliente
- Delivery
- Dirección
- Total
- Método de pago

---

# 🔄 Flujo del Sistema

### 1️⃣ Registro
Usuario se registra → `SP_REGISTER`

### 2️⃣ Login
Usuario inicia sesión → `SP_LOGIN`

### 3️⃣ Explorar Productos
Consulta catálogo → `SP_GET_PRODUCTS_TOP`

### 4️⃣ Crear Orden
Inserción en:
- orders
- order_details

### 5️⃣ Asignación
Admin asigna delivery.

### 6️⃣ Seguimiento
Cambio de estado:
```
PENDING → ACCEPTED → ON_THE_WAY → DELIVERED
```

---

# 🔐 Seguridad

- Contraseñas almacenadas como hash (bcrypt recomendado)
- Integridad referencial con ON UPDATE / ON DELETE
- Transacciones en operaciones críticas
- Índices en campos clave
- Preparado para JWT en backend

---

# ⚡ Índices y Rendimiento

Índices recomendados:

- email
- category_id
- order status
- client_id
- delivery_id
- product name

Uso de:
- DECIMAL para dinero
- InnoDB para integridad
- UTF8MB4 para soporte completo Unicode

---

# 🛠 Requisitos

- MySQL 8+
- MariaDB 10+
- Motor InnoDB habilitado

---

# 🚀 Instalación

1. Crear base de datos:
   ```sql
   SOURCE database.sql;
   ```

2. Ejecutar procedimientos:
   ```sql
   SOURCE procedures.sql;
   ```

3. Configurar backend con conexión a MySQL.

---

# 📈 Escalabilidad

Este sistema está preparado para:

- Multiusuario
- Alta concurrencia
- Integración con API REST
- Microservicios
- Arquitectura cloud
- Control de inventario
- Notificaciones push

---

# 🏗 Nivel del Proyecto

✔ Producción  
✔ Escalable  
✔ Seguro  
✔ Optimizado  
✔ Arquitectura profesional  

---

# 👨‍💻 Autor

Proyecto desarrollado como sistema logístico de gestión de pedidos y entregas.

---

# 📄 Licencia

Uso libre para fines educativos y comerciales.
