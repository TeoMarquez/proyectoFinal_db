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

CREATE TABLE Provincias (
    IdProvincia INT IDENTITY(1,1),
    Nombre VARCHAR(50),
    CONSTRAINT PK_Provincias
        PRIMARY KEY (IdProvincia),
    CONSTRAINT UQ_Provincias_Nombre
        UNIQUE (Nombre)
);

CREATE TABLE Ciudades (
    IdCiudad INT IDENTITY(1,1),
    IdProvincia INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Ciudades
        PRIMARY KEY (IdCiudad),
    CONSTRAINT FK_Ciudades_Provincias
        FOREIGN KEY (IdProvincia)
        REFERENCES Provincias(IdProvincia)
);

CREATE TABLE Zonas (
    IdZona INT IDENTITY(1,1),
    IdCiudad INT NOT NULL,
    NombreZona VARCHAR(50) NOT NULL,
    CodigoPostal VARCHAR(80) NOT NULL,
    Descripcion VARCHAR(250),
    CONSTRAINT PK_Zonas
        PRIMARY KEY (IdZona),
    CONSTRAINT FK_Zonas_Ciudades
        FOREIGN KEY (IdCiudad)
        REFERENCES Ciudades(IdCiudad)
);

CREATE TABLE Clientes (
    IdCliente INT IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    Cuit VARCHAR(20) NOT NULL,
    Telefono VARCHAR(30),
    Email VARCHAR(120),
    CONSTRAINT PK_Clientes
        PRIMARY KEY (IdCliente),
    CONSTRAINT UQ_Clientes_Cuit
        UNIQUE (Cuit)
);

CREATE TABLE Proveedores (
    IdProveedor INT IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Cuit VARCHAR(20) NOT NULL,
    Telefono VARCHAR(30) NOT NULL,
    Email VARCHAR(120) NOT NULL,
    CONSTRAINT PK_Proveedores
        PRIMARY KEY (IdProveedor),
    CONSTRAINT UQ_Proveedores_Cuit
        UNIQUE (Cuit)
);

CREATE TABLE Servicios (
    IdServicio INT IDENTITY(1,1),
    IdZona INT NOT NULL,
    IdProveedor INT NOT NULL,
    Categoria VARCHAR(100) NOT NULL,
    Nombre VARCHAR(30) NOT NULL,
    Descripcion VARCHAR(200),
    CONSTRAINT PK_Servicios
        PRIMARY KEY (IdServicio),
    CONSTRAINT FK_Servicios_Zonas
        FOREIGN KEY (IdZona)
        REFERENCES Zonas(IdZona),
    CONSTRAINT FK_Servicios_Proveedores
        FOREIGN KEY (IdProveedor)
        REFERENCES Proveedores(IdProveedor)
);

CREATE TABLE Recintos (
    IdRecinto INT IDENTITY(1,1),
    IdServicio INT NOT NULL,
    Nombre VARCHAR(80) NOT NULL,
    Capacidad INT NOT NULL,
    Direccion VARCHAR(150) NOT NULL,
    CONSTRAINT PK_Recintos
        PRIMARY KEY (IdRecinto),
    CONSTRAINT FK_Recintos_Servicios
        FOREIGN KEY (IdServicio)
        REFERENCES Servicios(IdServicio),
    CONSTRAINT CK_Recintos_Capacidad
        CHECK (Capacidad > 0)
);

CREATE TABLE Contratos (
    IdContrato INT IDENTITY(1,1),
    IdCliente INT NOT NULL,
    FechaFirma DATE NOT NULL,
    FechaProgramada DATE NOT NULL,
    PresupuestoAcordado DECIMAL(14,2) NOT NULL,
    Informacion VARCHAR(250) NOT NULL,
    TipoEvento VARCHAR(80) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Contratos
        PRIMARY KEY (IdContrato),
    CONSTRAINT FK_Contratos_Clientes
        FOREIGN KEY (IdCliente)
        REFERENCES Clientes(IdCliente),
    CONSTRAINT CK_Contratos_FechaProgramada
        CHECK (FechaProgramada >= FechaFirma),
    CONSTRAINT CK_Contratos_PresupuestoAcordado
        CHECK (PresupuestoAcordado >= 0),
    CONSTRAINT CK_Contratos_Estado
        CHECK (Estado IN ('Cumplido', 'Pendiente', 'Cancelado'))
);

CREATE TABLE Subcontratos (
    IdSubcontrato INT IDENTITY(1,1),
    IdContrato INT NOT NULL,
    IdServicio INT NOT NULL,
    Costo DECIMAL(14,2) NOT NULL,
    FechaFirma DATE NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Subcontratos
        PRIMARY KEY (IdSubcontrato),
    CONSTRAINT FK_Subcontratos_Contratos
        FOREIGN KEY (IdContrato)
        REFERENCES Contratos(IdContrato),
    CONSTRAINT FK_Subcontratos_Servicios
        FOREIGN KEY (IdServicio)
        REFERENCES Servicios(IdServicio),
    CONSTRAINT CK_Subcontratos_Estado
        CHECK (Estado IN ('Cumplido', 'Pendiente', 'Cancelado')),
    CONSTRAINT CK_Subcontratos_Costo
        CHECK (Costo >= 0)
);

CREATE TABLE Eventos (
    IdEvento INT IDENTITY(1,1),
    IdContrato INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    FechaReal DATE NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    CantidadAsistentes INT NOT NULL,
    CONSTRAINT PK_Eventos
        PRIMARY KEY (IdEvento),
    CONSTRAINT FK_Eventos_Contratos
        FOREIGN KEY (IdContrato)
        REFERENCES Contratos(IdContrato),
    CONSTRAINT CK_Eventos_CantidadAsistentes
        CHECK (CantidadAsistentes >= 0),
    CONSTRAINT CK_Eventos_Estado
        CHECK (Estado IN ('Pendiente', 'Exitoso', 'Cancelado')),
    CONSTRAINT UQ_Eventos_Contrato
        UNIQUE (IdContrato)
);

CREATE TABLE Tickets (
    IdTicket INT IDENTITY(1,1),
    IdEvento INT NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Precio DECIMAL(12,2) NOT NULL,
    CantidadVendida INT NOT NULL,
    CONSTRAINT PK_Tickets
        PRIMARY KEY (IdTicket),
    CONSTRAINT FK_Tickets_Eventos
        FOREIGN KEY (IdEvento)
        REFERENCES Eventos(IdEvento),
    CONSTRAINT CK_Tickets_Precio
        CHECK (Precio >= 0),
    CONSTRAINT CK_Tickets_CantidadVendida
        CHECK (CantidadVendida >= 0)
);

CREATE TABLE IngresosEventos (
    IdIngresoEvento INT IDENTITY(1,1),
    IdEvento INT NOT NULL,
    TipoIngreso VARCHAR(50) NOT NULL,
    Monto DECIMAL(14,2) NOT NULL,
    CONSTRAINT PK_IngresosEventos
        PRIMARY KEY (IdIngresoEvento),
    CONSTRAINT FK_IngresosEventos_Eventos
        FOREIGN KEY (IdEvento)
        REFERENCES Eventos(IdEvento),
    CONSTRAINT CK_IngresosEventos_Monto
        CHECK (Monto >= 0)
);

CREATE TABLE Cancelaciones (
    IdCancelacion INT IDENTITY(1,1),
    IdSubcontrato INT NULL,
    IdEvento INT NOT NULL,
    Detalle VARCHAR(250),
    CONSTRAINT PK_Cancelaciones
        PRIMARY KEY (IdCancelacion),
    CONSTRAINT FK_Cancelaciones_Subcontratos
        FOREIGN KEY (IdSubcontrato)
        REFERENCES Subcontratos(IdSubcontrato),
    CONSTRAINT FK_Cancelaciones_Eventos
        FOREIGN KEY (IdEvento)
        REFERENCES Eventos(IdEvento),
    CONSTRAINT UQ_Cancelaciones_Evento
        UNIQUE (IdEvento)
);

CREATE TABLE EvaluacionesServicios (
    IdEvaluacionServicio INT IDENTITY(1,1),
    IdSubcontrato INT NOT NULL,
    CalificacionRendimiento INT NOT NULL,
    CalificacionCosto INT NOT NULL,
    Comentario VARCHAR(250),
    CONSTRAINT PK_EvaluacionesServicios
        PRIMARY KEY (IdEvaluacionServicio),
    CONSTRAINT FK_EvaluacionesServicios_Subcontratos
        FOREIGN KEY (IdSubcontrato)
        REFERENCES Subcontratos(IdSubcontrato),
    CONSTRAINT CK_EvaluacionesServicios_CalificacionRendimiento
        CHECK (CalificacionRendimiento BETWEEN 1 AND 10),
    CONSTRAINT CK_EvaluacionesServicios_CalificacionCosto
        CHECK (CalificacionCosto BETWEEN 1 AND 10),
    CONSTRAINT UQ_EvaluacionesServicios_Subcontrato
        UNIQUE (IdSubcontrato)
);

CREATE UNIQUE INDEX UX_Cancelaciones_Subcontrato
ON Cancelaciones(IdSubcontrato)
WHERE IdSubcontrato IS NOT NULL;