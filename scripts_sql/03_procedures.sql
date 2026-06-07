CREATE PROCEDURE SP_Evento_entre_fechas
   @fecha_inicio DATE,
   @fecha_final DATE
AS
BEGIN
  SELECT
  nombre,
  fecha_real,
  estado,
  cantidad_asistentes
  FROM evento

  WHERE fecha_real BETWEEN @fecha_inicio AND @fecha_final;
END;
GO

CREATE PROCEDURE SP_Evento_tipo
  @tipo_evento VARCHAR(80)
AS
BEGIN
  SELECT
  evento.nombre,
  evento.fecha_real,
  evento.estado,
  evento.cantidad_asistentes,
  contrato.tipo_evento
  FROM evento

  JOIN contrato
  ON evento.contrato_id = contrato.id

  WHERE contrato.tipo_evento = @tipo_evento;
END;
GO

CREATE PROCEDURE SP_Buscar_cliente
  @nombre VARCHAR(50)
AS
BEGIN
  SELECT *
  FROM cliente
  WHERE nombre LIKE '%' + @nombre + '%'
END;
GO


CREATE PROCEDURE SP_Evento_provincia
  @provincia VARCHAR(50)
AS
BEGIN
  SELECT
  evento.nombre,
  evento.fecha_real,
  evento.estado,
  evento.cantidad_asistentes,
  provincia.nombre
  FROM evento

  JOIN contrato
  ON evento.contrato_id = contrato.id

  JOIN subcontrato
  ON contrato.id = subcontrato.contrato_id

  JOIN servicio
  ON subcontrato.servicio_id = servicio.id

  JOIN zona
  ON servicio.zona_id = zona.id

  JOIN ciudad
  ON zona.ciudad_id = ciudad.id

  JOIN provincia
  ON ciudad.provincia_id = provincias.id

  WHERE provincia.nombre = @provincia;
END;
GO  

CREATE PROCEDURE SP_Evento_recinto
  @recinto VARCHAR(50)
AS
BEGIN
  SELECT
  evento.nombre,
  evento.fecha_real,
  evento.estado,
  evento.cantidad_asistentes,
  recinto.nombre AS recinto
  FROM evento

  JOIN contrato
  ON evento.contrato_id = contrato.id

  JOIN subcontrato
  ON contrato.id = subcontrato.contrato_id

  JOIN servicio
  ON subcontrato.servicio_id = servicio.id

  JOIN recinto
  ON servicio.id = recinto.servicio_id

  WHERE recinto.nombre = @recinto;
END;
GO


CREATE PROCEDURE SP_Proveedor_categoria
  @categoria VARCHAR(100)
AS
BEGIN
  SELECT
  proveedor.nombre,
  proveedor.cuit,
  proveedor.telefono,
  proveedor.email,
  servicio.categoria AS categoria
  FROM proveedor

  JOIN servicio
  ON proveedor.id = servicio.proveedor_id

  WHERE servicio.categoria = @categoria;
END;
GO