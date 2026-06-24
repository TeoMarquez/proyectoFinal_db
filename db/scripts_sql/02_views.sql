CREATE VIEW VW_ContratacionesMes
AS
SELECT
    MONTH(FechaFirma) AS Mes,
    COUNT(*) AS CantidadContratos
FROM Contratos
GROUP BY MONTH(FechaFirma);
GO


CREATE VIEW VW_CancelacionesProveedores
AS
SELECT
    Proveedores.Nombre AS Proveedor,
    COUNT(*) AS CantidadCancelaciones
FROM Cancelaciones

JOIN Subcontratos
    ON Cancelaciones.IdSubcontrato = Subcontratos.IdSubcontrato

JOIN Servicios
    ON Subcontratos.IdServicio = Servicios.IdServicio

JOIN Proveedores
    ON Servicios.IdProveedor = Proveedores.IdProveedor

GROUP BY Proveedores.Nombre;
GO


CREATE VIEW VW_RendimientoProveedores
AS
SELECT
    Proveedor,
    Relacion,
    RANK() OVER (
        ORDER BY Relacion DESC
    ) AS Ranking
FROM
(
    SELECT
        Proveedores.Nombre AS Proveedor,
        (
            AVG(EvaluacionesServicios.CalificacionCosto)
            +
            AVG(EvaluacionesServicios.CalificacionRendimiento)
        ) / 2.0 AS Relacion
    FROM Proveedores

    JOIN Servicios
        ON Proveedores.IdProveedor = Servicios.IdProveedor

    JOIN Subcontratos
        ON Servicios.IdServicio = Subcontratos.IdServicio

    JOIN EvaluacionesServicios
        ON Subcontratos.IdSubcontrato = EvaluacionesServicios.IdSubcontrato

    GROUP BY Proveedores.Nombre
) AS Datos;
GO


CREATE VIEW VW_EventosProvincias
AS
SELECT
    Provincia,
    CantidadEventos,
    RANK() OVER (
        ORDER BY CantidadEventos DESC
    ) AS Ranking
FROM
(
    SELECT
        Provincias.Nombre AS Provincia,
        COUNT(DISTINCT Eventos.IdEvento) AS CantidadEventos
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
    WHERE Eventos.Estado = 'Exitoso'
    GROUP BY Provincias.Nombre
) AS Cantidades;
GO


CREATE VIEW VW_ContratacionesProveedores
AS
SELECT
    Proveedor,
    Cantidad,
    RANK() OVER (
        ORDER BY Cantidad DESC
    ) AS Ranking
FROM
(
    SELECT
        Proveedores.Nombre AS Proveedor,
        COUNT(Subcontratos.IdSubcontrato) AS Cantidad
    FROM Subcontratos

    JOIN Servicios
        ON Subcontratos.IdServicio = Servicios.IdServicio

    JOIN Proveedores
        ON Servicios.IdProveedor = Proveedores.IdProveedor

    GROUP BY Proveedores.Nombre
) AS Contrataciones;
GO


CREATE VIEW VW_IngresosClientes
AS
WITH IngresosTicket AS
(
    SELECT
        IdEvento,
        SUM(Precio * CantidadVendida) AS TicketTotal
    FROM Tickets
    GROUP BY IdEvento
),
TotalIngresosEvento AS
(
    SELECT
        IdEvento,
        SUM(Monto) AS TotalIngresosEvento
    FROM IngresosEventos
    GROUP BY IdEvento
)

SELECT
    Cliente,
    Ingreso,
    RANK() OVER (
        ORDER BY Ingreso DESC
    ) AS Ranking
FROM
(
    SELECT
        Clientes.Nombre AS Cliente,
        SUM(
            Contratos.PresupuestoAcordado
            +
            ISNULL(TotalIngresosEvento.TotalIngresosEvento, 0)
            +
            ISNULL(IngresosTicket.TicketTotal, 0)
        ) AS Ingreso
    FROM Clientes

    LEFT JOIN Contratos
        ON Clientes.IdCliente = Contratos.IdCliente

    LEFT JOIN Eventos
        ON Contratos.IdContrato = Eventos.IdContrato

    LEFT JOIN IngresosTicket
        ON Eventos.IdEvento = IngresosTicket.IdEvento

    LEFT JOIN TotalIngresosEvento
        ON Eventos.IdEvento = TotalIngresosEvento.IdEvento

    GROUP BY Clientes.IdCliente, Clientes.Nombre
) AS Ingresos;
GO


CREATE VIEW VW_AsistenciaEventos
AS
SELECT
    Tipo,
    CantidadAsistencias,
    RANK() OVER (
        ORDER BY CantidadAsistencias DESC
    ) AS Ranking
FROM
(
    SELECT
        Contratos.TipoEvento AS Tipo,
        SUM(Eventos.CantidadAsistentes) AS CantidadAsistencias
    FROM Contratos

    JOIN Eventos
        ON Contratos.IdContrato = Eventos.IdContrato

    GROUP BY Contratos.TipoEvento
) AS TiposEvento;
GO


CREATE VIEW VW_GananciasEventos
AS
WITH IngresosTicket AS
(
    SELECT
        IdEvento,
        SUM(Precio * CantidadVendida) AS TicketTotal
    FROM Tickets
    GROUP BY IdEvento
),
TotalIngresosEvento AS
(
    SELECT
        IdEvento,
        SUM(Monto) AS TotalIngresosEvento
    FROM IngresosEventos
    GROUP BY IdEvento
),
IngresosTotales AS
(
    SELECT
        Contratos.TipoEvento,
        SUM(
            Contratos.PresupuestoAcordado
            +
            ISNULL(TotalIngresosEvento.TotalIngresosEvento, 0)
            +
            ISNULL(IngresosTicket.TicketTotal, 0)
        ) AS Ingreso
    FROM Contratos

    LEFT JOIN Eventos
        ON Contratos.IdContrato = Eventos.IdContrato

    LEFT JOIN IngresosTicket
        ON Eventos.IdEvento = IngresosTicket.IdEvento

    LEFT JOIN TotalIngresosEvento
        ON Eventos.IdEvento = TotalIngresosEvento.IdEvento

    GROUP BY Contratos.TipoEvento
),
CostosTotales AS
(
    SELECT
        Contratos.TipoEvento,
        SUM(Subcontratos.Costo) AS Costo
    FROM Contratos

    JOIN Subcontratos
        ON Contratos.IdContrato = Subcontratos.IdContrato

    GROUP BY Contratos.TipoEvento
),
GananciasTotales AS
(
    SELECT
        IngresosTotales.TipoEvento,
        IngresosTotales.Ingreso - CostosTotales.Costo AS Ganancia
    FROM IngresosTotales

    JOIN CostosTotales
        ON IngresosTotales.TipoEvento = CostosTotales.TipoEvento
)

SELECT
    TipoEvento,
    Ganancia,
    RANK() OVER (
        ORDER BY Ganancia DESC
    ) AS Ranking
FROM GananciasTotales;
GO


CREATE VIEW VW_EventosNoRealizados
AS
SELECT
    Servicios.Categoria,
    COUNT(DISTINCT Eventos.IdEvento) AS EventosCancelados
FROM Eventos

JOIN Cancelaciones
    ON Eventos.IdEvento = Cancelaciones.IdEvento

JOIN Subcontratos
    ON Cancelaciones.IdSubcontrato = Subcontratos.IdSubcontrato

JOIN Servicios
    ON Subcontratos.IdServicio = Servicios.IdServicio

WHERE Eventos.Estado = 'Cancelado'

GROUP BY Servicios.Categoria;
GO

CREATE VIEW VW_EstadoEventos
AS
SELECT
    Eventos.IdEvento,
    Eventos.Nombre,
    Contratos.TipoEvento,
    Eventos.FechaReal,
    Eventos.Estado
FROM Eventos

JOIN Contratos
    ON Eventos.IdContrato = Contratos.IdContrato;
GO