CREATE PROCEDURE SP_EventosEntreFechas
    @FechaInicio DATE,
    @FechaFinal DATE
AS
BEGIN
    SELECT
        Nombre,
        FechaReal,
        Estado,
        CantidadAsistentes
    FROM Eventos
    WHERE FechaReal BETWEEN @FechaInicio AND @FechaFinal;
END;
GO


CREATE PROCEDURE SP_EventosTipo
    @TipoEvento VARCHAR(80)
AS
BEGIN
    SELECT
        Eventos.Nombre,
        Eventos.FechaReal,
        Eventos.Estado,
        Eventos.CantidadAsistentes,
        Contratos.TipoEvento
    FROM Eventos

    JOIN Contratos
        ON Eventos.IdContrato = Contratos.IdContrato

    WHERE Contratos.TipoEvento = @TipoEvento;
END;
GO


CREATE PROCEDURE SP_BuscarClientes
    @Nombre VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Clientes
    WHERE Nombre LIKE '%' + @Nombre + '%';
END;
GO


CREATE PROCEDURE SP_EventosProvincia
    @Provincia VARCHAR(50)
AS
BEGIN
    SELECT
        Eventos.Nombre,
        Eventos.FechaReal,
        Eventos.Estado,
        Eventos.CantidadAsistentes,
        Provincias.Nombre AS Provincia
    FROM Eventos

    JOIN Contratos
        ON Eventos.IdContrato = Contratos.IdContrato

    JOIN Subcontratos
        ON Contratos.IdContrato = Subcontratos.IdContrato

    JOIN Servicios
        ON Subcontratos.IdServicio = Servicios.IdServicio

    JOIN Zonas
        ON Servicios.IdZona = Zonas.IdZona

    JOIN Ciudades
        ON Zonas.IdCiudad = Ciudades.IdCiudad

    JOIN Provincias
        ON Ciudades.IdProvincia = Provincias.IdProvincia

    WHERE Provincias.Nombre = @Provincia;
END;
GO


CREATE PROCEDURE SP_EventosRecinto
    @Recinto VARCHAR(80)
AS
BEGIN
    SELECT
        Eventos.Nombre,
        Eventos.FechaReal,
        Eventos.Estado,
        Eventos.CantidadAsistentes,
        Recintos.Nombre AS Recinto
    FROM Eventos

    JOIN Contratos
        ON Eventos.IdContrato = Contratos.IdContrato

    JOIN Subcontratos
        ON Contratos.IdContrato = Subcontratos.IdContrato

    JOIN Servicios
        ON Subcontratos.IdServicio = Servicios.IdServicio

    JOIN Recintos
        ON Servicios.IdServicio = Recintos.IdServicio

    WHERE Recintos.Nombre = @Recinto;
END;
GO


CREATE PROCEDURE SP_ProveedoresCategoria
    @Categoria VARCHAR(100)
AS
BEGIN
    SELECT
        Proveedores.Nombre,
        Proveedores.Cuit,
        Proveedores.Telefono,
        Proveedores.Email,
        Servicios.Categoria
    FROM Proveedores

    JOIN Servicios
        ON Proveedores.IdProveedor = Servicios.IdProveedor

    WHERE Servicios.Categoria = @Categoria;
END;
GO