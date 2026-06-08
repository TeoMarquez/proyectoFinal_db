IF DB_ID('EmpresaEventos') IS NOT NULL
BEGIN
    ALTER DATABASE EmpresaEventos SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EmpresaEventos;
END
GO

CREATE DATABASE EmpresaEventos;
GO

USE EmpresaEventos;
GO

create table provincias (
id INT IDENTITY(1,1),
nombre VARCHAR(50),
CONSTRAINT PK_Provincias
PRIMARY KEY(id),
CONSTRAINT UQ_Provincias_Nombre
UNIQUE(nombre)
);

create table ciudad (
id INT IDENTITY(1,1),
provincia_id INT NOT NULL,
nombre VARCHAR(50) NOT NULL,
CONSTRAINT PK_Ciudad
PRIMARY KEY(id),
CONSTRAINT FK_Ciudad_Provincia
FOREIGN KEY(provincia_id)
REFERENCES provincias(id)
);

create table zona(
id INT IDENTITY(1,1),
ciudad_id INT NOT NULL,
nombre_zona VARCHAR(50) NOT NULL,
codigo_postal VARCHAR(80) NOT NULL,
descripcion VARCHAR(250),
CONSTRAINT PK_Zona
PRIMARY KEY(id),
CONSTRAINT FK_Zona_Ciudad
FOREIGN KEY(ciudad_id)
REFERENCES ciudad(id)
);

create table cliente (
id int IDENTITY(1,1),
nombre varchar(50) NOT NULL,
cuit VARCHAR(20)NOT NULL,
telefono VARCHAR(30),
email VARCHAR(120),
CONSTRAINT PK_Cliente
PRIMARY KEY(id),
CONSTRAINT UQ_Cliente_Cuit
UNIQUE(cuit)
);

create table proveedor (
id int IDENTITY(1,1),
nombre VARCHAR(100) NOT NULL,
cuit VARCHAR(20) NOT NULL,
telefono VARCHAR(30) NOT NULL,
email VARCHAR(120) NOT NULL,
CONSTRAINT PK_Proveedor
PRIMARY KEY(id),
CONSTRAINT UQ_Proveedor_Cuit
UNIQUE(cuit)
);

create table servicio (
id INT IDENTITY(1,1),
zona_id INT NOT NULL,
proveedor_id INT NOT NULL,
categoria VARCHAR(100) NOT NULL,
nombre VARCHAR(30) NOT NULL,
descripcion VARCHAR(200),
CONSTRAINT PK_Servicio
PRIMARY KEY(id),
CONSTRAINT FK_Servicio_Zona
FOREIGN KEY(zona_id)
REFERENCES zona(id),
CONSTRAINT FK_Servicio_Proveedor
FOREIGN KEY(proveedor_id)
REFERENCES proveedor(id)
);

create table recinto(
id INT IDENTITY(1,1),
servicio_id int NOT NULL,
nombre VARCHAR(80) NOT NULL,
capacidad INT NOT NULL,
direccion VARCHAR(150) NOT NULL,
CONSTRAINT PK_Recinto
PRIMARY KEY(id),
CONSTRAINT FK_Recinto_Servicio
FOREIGN KEY(servicio_id)
REFERENCES servicio(id),
CONSTRAINT CK_Recinto_Capacidad
CHECK(capacidad > 0)
);

create table contrato (
id INT IDENTITY(1,1),
cliente_id INT NOT NULL,
fecha_firma DATE NOT NULL,
fecha_programada DATE NOT NULL,
presupuesto_acordado DECIMAL(14,2) NOT NULL,
informacion VARCHAR(250) NOT NULL,
tipo_evento VARCHAR(80) NOT NULL,
estado VARCHAR (20) NOT NULL,
CONSTRAINT PK_Contrato
PRIMARY KEY(id),
CONSTRAINT FK_Contrato_Cliente
FOREIGN KEY (cliente_id)
REFERENCES cliente(id),
CONSTRAINT CK_Contrato_Fechaprogramada
CHECK (fecha_programada >= fecha_firma),
CONSTRAINT CK_Contrato_Presupuestoacordado
CHECK (presupuesto_acordado >= 0),
CONSTRAINT CK_Contato_Estado
CHECK (estado in ('Cumplido', 'Pendiente', 'Cancelado'))
);

create table subcontrato (
id INT IDENTITY(1,1),
contrato_id INT NOT NULL,
servicio_id INT NOT NULL,
costo DECIMAL(14,2) NOT NULL,
fecha_firma DATE NOT NULL,
estado VARCHAR(50) NOT NULL,
CONSTRAINT PK_Subcontrato
PRIMARY KEY(id),
CONSTRAINT FK_Subcontrato_Contrato
FOREIGN KEY(contrato_id)
REFERENCES contrato(id),
CONSTRAINT FK_Subcontrato_Servicio
FOREIGN KEY(servicio_id)
REFERENCES servicio(id),
CONSTRAINT CK_Subcontrato_Estado
CHECK (estado in('Cumplido', 'Pendiente', 'Cancelado')),
CONSTRAINT CK_Subcontrato_Costo
CHECK (costo >= 0)
);

create table evento(
id INT IDENTITY(1,1),
contrato_id int NOT NULL,
nombre VARCHAR(100) NOT NULL,
fecha_real DATE NOT NULL,
estado VARCHAR(50) NOT NULL,
cantidad_asistentes INT NOT NULL,
CONSTRAINT PK_Evento
PRIMARY KEY(id),
CONSTRAINT FK_Evento_Contrato
FOREIGN KEY(contrato_id)
REFERENCES contrato(id),
CONSTRAINT CK_Evento_Cantidadasistentes
CHECK (cantidad_asistentes >= 0),
CONSTRAINT CK_Evento_Estado
CHECK (estado IN ('Pendiente', 'Exitoso', 'Cancelado')),
CONSTRAINT UQ_Evento_Contrato
UNIQUE(contrato_id)
);

create table ticket (
id INT IDENTITY(1,1),
evento_id INT NOT NULL,
tipo VARCHAR(50) NOT NULL,
precio DECIMAL (12,2) NOT NULL,
cantidad_vendida INT NOT NULL,
CONSTRAINT PK_Ticket
PRIMARY KEY(id),
CONSTRAINT FK_Ticket_Evento
FOREIGN KEY(evento_id)
REFERENCES evento(id),
CONSTRAINT CK_Ticket_Precio
CHECK(precio >= 0),
CONSTRAINT CK_Ticket_Cantidadvendida
CHECK(cantidad_vendida >= 0)
);

create table ingresos_evento(
id INT IDENTITY(1,1),
evento_id INT NOT NULL,
tipo_ingreso VARCHAR(50) NOT NULL,
monto DECIMAL(14,2) NOT NULL,
CONSTRAINT PK_Ingresosevento
PRIMARY KEY(id),
CONSTRAINT FK_Ingresosevento_Evento
FOREIGN KEY(evento_id)
REFERENCES evento(id),
CONSTRAINT CK_Ingresosevento_Monto
CHECK(monto >= 0)
);

create table cancelacion (
id INT IDENTITY(1,1),
subcontrato_id INT NULL,
evento_id INT NOT NULL,
detalle VARCHAR (250),
CONSTRAINT PK_Cancelacion
PRIMARY KEY(id),
CONSTRAINT FK_Cancelacion_Subcontrato
FOREIGN KEY(subcontrato_id)
REFERENCES subcontrato(id),
CONSTRAINT FK_Cancelacion_Evento
FOREIGN KEY(evento_id)
REFERENCES evento(id),
CONSTRAINT UQ_Cancelacion_Evento
UNIQUE(evento_id),
);

create table evaluacion_servicio (
id INT IDENTITY(1,1),
subcontrato_id INT NOT NULL,
calificacion_rendimiento INT NOT NULL,
calificacion_costo INT NOT NULL,
comentario VARCHAR(250),
CONSTRAINT PK_Evaluacionservicio
PRIMARY KEY(id),
CONSTRAINT FK_Evaluacionservicio_Subcontrato
FOREIGN KEY(subcontrato_id)
REFERENCES subcontrato(id),
CONSTRAINT CK_Evaluacionservicio_Calificacionrendimiento
CHECK(calificacion_rendimiento BETWEEN 1 and 10),
CONSTRAINT CK_Evaluacionservicio_Calificacioncosto
CHECK(calificacion_costo BETWEEN 1 and 10),
CONSTRAINT UQ_Evaluacionservicio_Subcontrato
UNIQUE(subcontrato_id)
);

CREATE UNIQUE INDEX UX_Cancelacion_Subcontrato
ON cancelacion(subcontrato_id)
WHERE subcontrato_id IS NOT NULL;