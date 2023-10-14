-- database: :memory:
-- Crear la base de datos "inventory_data_base"
CREATE DATABASE inventory_data_base;
GO

-- Usar la base de datos "inventory_data_base"
USE inventory_data_base;
GO


-- Crear tabla tipo de "payment_type"
CREATE TABLE payment_type (
    ID INT PRIMARY KEY IDENTITY(1,1), --001
    Name NVARCHAR(50) NOT NULL, -- Efectivo, Transferencia, bitcoin
    Description NVARCHAR(255), --no se admiten billetes de $100, solo bac y lafise, solo Bitcoin
);

-- Crear la tabla "currency" (Moneda)
CREATE TABLE dbo.currency (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL, -- Nombre , Cordoba
    symbol NVARCHAR(10) NOT NULL, -- Símbolo, C$
    international_identifier NVARCHAR(10) NOT NULL -- Identificador Internacional: NIO
);
GO

-- Crear la tabla "plan_Type" (Tipo de Plan)
CREATE TABLE dbo.plan_Type (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL, -- Nombre- Plan Free, Basic
    max_product_record_count INT NOT NULL -- Cantidad Máxima de Registros de Producto permitidos: 100 registros,  5000 registros etc...

);
GO

-- Crear la table "auth_user" (Tabla de Usuario)
-- esta tabla maneja todas las autenticaciones de los usuarios
CREATE TABLE dbo.auth_user (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(150) NOT NULL UNIQUE,
    first_name NVARCHAR(30) NOT NULL, -- Nombre
    last_name NVARCHAR(150) NOT NULL, -- Apellido
    email NVARCHAR(254) NOT NULL UNIQUE, -- Correo Electrónico
    password NVARCHAR(128) NOT NULL,
    is_staff BIT NOT NULL,
    is_active BIT NOT NULL,
    date_joined DATETIME NOT NULL
);
GO

-- Crear la tabla "business" (Negocio)
CREATE TABLE dbo.business (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL, -- Nombre
    photo_link NVARCHAR(MAX), -- foto del negocio
    authorization_number NVARCHAR(100) NOT NULL, -- Número de Autorización, ese se lo da la dgi
    invoice_series NVARCHAR(50) NOT NULL, -- Serie de Factura , ese lo da la dgi
    invoice_number NVARCHAR(10) NOT NULL, -- Número de Factura, ese lo da la dgi
    last_registered_invoice NVARCHAR(10) NOT NULL, -- Última Factura Registrada -- debe de ser actualizada cada vez que se agrege una factura
    number_of_product_records_available INT NOT NULL, -- Este registro será una copia de la cantidad de registros disponibles según en plan que se contrató, y por cada producto registrado va disminullendo en 1 hasta que llege a cero
    user_id INT NOT NULL, -- ID de Usuario
    plan_type_id INT NOT NULL, -- ID de Tipo de Plan
    currency_id INT NOT NULL, -- ID de Moneda
    CONSTRAINT FK_business_user_id FOREIGN KEY (user_id) REFERENCES dbo.auth_user(id),
    CONSTRAINT FK_business_plan_type_id FOREIGN KEY (plan_type_id) REFERENCES dbo.plan_Type(id),
    CONSTRAINT FK_business_currency_id FOREIGN KEY (currency_id) REFERENCES dbo.currency(id)
);
GO

-- Crear la tabla "user_role" (Rol de Usuario)
--Esta tabla es únicamente para los sub usuarios
--tendremos roles poredefinidos, ejemplo: Cajero etc
CREATE TABLE dbo.user_role (
    id INT IDENTITY(1,1) PRIMARY KEY,
    role NVARCHAR(50) NOT NULL, -- Rol
    detail NVARCHAR(255), -- Detalle
);
GO

-- Crear la tabla "sub_user_registration" (Registro de Subusuarios)
CREATE TABLE dbo.sub_user_registration (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL, -- Nombres
    last_name NVARCHAR(100) NOT NULL, -- Apellidos
    user_id INT NOT NULL, -- ID de Usuario
    role_id INT NOT NULL, -- ID de Rol
    CONSTRAINT FK_sub_user_registration_user_id FOREIGN KEY (user_id) REFERENCES dbo.auth_user(id),
    CONSTRAINT FK_sub_user_registration_role_id FOREIGN KEY (role_id) REFERENCES dbo.user_role(id)
);
GO

-- Crear la tabla "product_category" (Categoría de Producto)
CREATE TABLE dbo.product_category (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL, -- Nombre de la categoria
    icon_link NVARCHAR(MAX),
    business_id INT NOT NULL, -- ID de Negocio
    CONSTRAINT FK_product_category_business_id FOREIGN KEY (business_id) REFERENCES dbo.business(id)
);
GO

-- Crear la tabla "product" (Producto)
CREATE TABLE dbo.product (
    id INT IDENTITY(1,1) PRIMARY KEY,
    photo_link NVARCHAR(MAX),
    name NVARCHAR(255) NOT NULL, -- Nombre
    description NVARCHAR(MAX), -- Descripción
    stock INT NOT NULL, -- Inventario
    cost_price DECIMAL(10, 2) NOT NULL, -- Precio de costo
    sale_price DECIMAL(10, 2) NOT NULL, -- Precio de venta
    category_id INT NOT NULL, -- ID de Categoría
    business_id INT NOT NULL, -- ID de Negocio
    with_iva BIT NOT NULL, -- valida si tiene IVA o no tiene , 1: si tiene iva, 0: no tiene iva, Esta validación no debe estar en la version 1.0
    CONSTRAINT FK_product_category_id FOREIGN KEY (category_id) REFERENCES dbo.product_category(id),
    CONSTRAINT FK_product_business_id FOREIGN KEY (business_id) REFERENCES dbo.business(id)
);
GO

-- Crear la tabla "supplier" (Proveedores)
CREATE TABLE dbo.supplier (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL, -- Nombres
    last_name NVARCHAR(100) NOT NULL, -- Apellidos
    email NVARCHAR(254) NOT NULL, -- Correo Electrónico
    phone NVARCHAR(20) NOT NULL, -- Teléfono
    s_address NVARCHAR(254) NOT NULL, -- direccion
    business_id INT NOT NULL, -- ID de Negocio
    CONSTRAINT FK_supplier_business_id FOREIGN KEY (business_id) REFERENCES dbo.business(id)
);
GO

-- Crear la tabla "customer" (Clientes)
CREATE TABLE dbo.customer (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL, -- Nombres
    last_name NVARCHAR(100) NOT NULL, -- Apellidos
    email NVARCHAR(254) NOT NULL, -- Correo Electrónico
    phone NVARCHAR(20) NOT NULL, -- Teléfono
    c_address NVARCHAR(254) NOT NULL, -- direccion
    business_id INT NOT NULL, -- ID de Negocio
    CONSTRAINT FK_customer_business_id FOREIGN KEY (business_id) REFERENCES dbo.business(id)
);
GO

-- Crear la tabla "invoice" (Facturas)
CREATE TABLE dbo.invoice (
    id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_number NVARCHAR(50) NOT NULL, -- Número de Factura
    invoice_date DATETIME NOT NULL, -- Fecha de Factura
    sub_total DECIMAL(10, 2) NOT NULL,
    iva DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL, -- Total
    customer_id INT NOT NULL, -- ID de Cliente que facturó
    business_id INT NOT NULL, -- ID de Negocio que facturó
    id_payment_type INT NOT NULL, -- ID de Tipo de Pago
    CONSTRAINT FK_invoice_customer_id FOREIGN KEY (customer_id) REFERENCES dbo.customer(id),
    CONSTRAINT FK_invoice_business_id FOREIGN KEY (business_id) REFERENCES dbo.business(id),
    CONSTRAINT FK_invoice_payment_type FOREIGN KEY (id_payment_type) REFERENCES payment_type(ID)
);
GO

-- Crear la tabla "sale" (Ventas)
-- una venta se vincula con una factura es una fecha específica
CREATE TABLE dbo.sale (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL, -- ID de Producto
    quantity INT NOT NULL, -- Cantidad
    cost_price_at_time DECIMAL(10, 2) NOT NULL, -- Precio de costo
    sale_price_at_time DECIMAL(10, 2) NOT NULL, -- Precio de costo
    invoice_id INT NOT NULL, -- ID de Factura
    CONSTRAINT FK_sales_product_id FOREIGN KEY (product_id) REFERENCES dbo.product(id),
    CONSTRAINT FK_sales_invoice_id FOREIGN KEY (invoice_id) REFERENCES dbo.invoice(id)
);
GO
