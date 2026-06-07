CREATE TRIGGER TR_Subcontrato_UbicacionConsistente
ON subcontrato
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM subcontrato s
        JOIN servicio sv ON s.servicio_id = sv.id
        GROUP BY s.contrato_id
        HAVING COUNT(DISTINCT sv.zona_id) > 1
    )
    BEGIN
        RAISERROR (
            'Todos los subcontratos de un contrato deben pertenecer a la misma ciudad/provincia.',
            16, 1
        );
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER TR_Subcontrato_FechaFirma
ON subcontrato
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN contrato c ON i.contrato_id = c.id
        WHERE i.fecha_firma < c.fecha_firma
    )
    BEGIN
        RAISERROR ('La fecha del subcontrato no puede ser anterior a la del contrato.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO