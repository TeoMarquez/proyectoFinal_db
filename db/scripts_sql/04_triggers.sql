CREATE TRIGGER TR_SubcontratosUbicacionConsistente
ON Subcontratos
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM Subcontratos S
        JOIN Servicios Sv
            ON S.IdServicio = Sv.IdServicio
        JOIN Zonas Z
            ON Sv.IdZona = Z.IdZona
        WHERE S.IdContrato IN
        (
            SELECT DISTINCT IdContrato
            FROM Inserted
        )
        GROUP BY S.IdContrato
        HAVING COUNT(DISTINCT Z.IdCiudad) > 1
    )
    BEGIN
        RAISERROR(
            'Todos los subcontratos de un contrato deben pertenecer a la misma ciudad.',
            16,
            1
        );

        ROLLBACK TRANSACTION;
    END
END;
GO


CREATE TRIGGER TR_SubcontratosFechaFirma
ON Subcontratos
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM Inserted I
        JOIN Contratos C
            ON I.IdContrato = C.IdContrato
        WHERE I.FechaFirma < C.FechaFirma
    )
    BEGIN
        RAISERROR(
            'La fecha del subcontrato no puede ser anterior a la del contrato.',
            16,
            1
        );

        ROLLBACK TRANSACTION;
    END
END;
GO