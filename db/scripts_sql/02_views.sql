create view VW_Contrataciones_mes 
  AS
  SELECT 
    MONTH(fecha_firma) AS mes,
    COUNT(*) AS cantidad_contratos
  FROM contrato
  GROUP BY MONTH(fecha_firma);
GO


create view VW_Cancelacion_proveedor
  AS

  SELECT 
  proveedor.nombre,
    COUNT(*) AS cantidad_cancelaciones
  FROM cancelacion

  JOIN subcontrato
  ON cancelacion.subcontrato_id = subcontrato.id

  JOIN  servicio
  ON subcontrato.servicio_id = servicio.id

  JOIN proveedor
  ON servicio.proveedor_id = proveedor.id
  GROUP BY proveedor.nombre;
GO


create view VW_Proveedor_rendimiento
  AS
  SELECT
    proveedor,
    relacion,
    RANK() OVER(
      ORDER BY relacion DESC
    ) AS ranking
  FROM (
  SELECT 
    proveedor.nombre AS proveedor,
    (AVG(evaluacion_servicio.calificacion_costo)
    +
    AVG(evaluacion_servicio.calificacion_rendimiento))/2 AS relacion
  FROM proveedor

  JOIN servicio
  ON proveedor.id = servicio.proveedor_id

  JOIN subcontrato
  ON servicio.id = subcontrato.servicio_id

  JOIN evaluacion_servicio
  ON subcontrato.id = evaluacion_servicio.subcontrato_id
  GROUP BY proveedor.nombre
  ) AS datos;
GO


create view VW_Provincias_evento
  AS
  SELECT
    provincia,
    cantidad_eventos,
    RANK() OVER(
      ORDER BY cantidad_eventos DESC
    ) as ranking
  FROM (
  SELECT 
    provincias.nombre AS provincia,
    count(DISTINCT evento.id) AS cantidad_eventos
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

  JOIN provincias
  ON ciudad.provincia_id = provincias.id

  GROUP BY provincias.nombre
  ) AS cantidad;
GO


create view VW_Proveedores_Contrataciones
  AS
  SELECT
    proveedor,
    cantidad,
    RANK() OVER(
      ORDER BY cantidad DESC
    )AS ranking
  FROM (
  SELECT
    proveedor.nombre as proveedor,
    count(subcontrato.id) as cantidad
  FROM subcontrato

  JOIN servicio
  ON subcontrato.servicio_id = servicio.id

  JOIN proveedor
  ON servicio.proveedor_id = proveedor.id
  GROUP BY proveedor.nombre
  ) AS contrataciones;
GO


create view VW_Clientes_Ingreso
  AS
  WITH ingresos_ticket AS
  (
    SELECT
    evento_id,
    SUM(precio * cantidad_vendida) AS ticket_total
    FROM ticket
    GROUP BY evento_id
  ),
  total_ingresos_evento AS
  (
    SELECT
    evento_id,
    SUM(monto) AS total_ingresos_evento
    FROM ingresos_evento
    GROUP BY evento_id
  )
  SELECT
    cliente,
    ingreso,
    RANK() OVER(
      ORDER BY ingreso DESC
    )AS ranking
  FROM (
  SELECT
  cliente.nombre AS cliente,
  SUM( contrato.presupuesto_acordado
    +
    ISNULL(total_ingresos_evento.total_ingresos_evento,0)
    +
    ISNULL(ingresos_ticket.ticket_total,0)
  ) AS ingreso
  FROM cliente

  LEFT JOIN contrato
  ON cliente.id = contrato.cliente_id

  LEFT JOIN evento
  ON contrato.id = evento.contrato_id

  LEFT JOIN ingresos_ticket
  ON evento.id = ingresos_ticket.evento_id

  LEFT JOIN total_ingresos_evento
  ON evento.id = total_ingresos_evento.evento_id
  GROUP BY cliente.id, cliente.nombre
  ) AS ingresos;
GO



create view VW_Evento_asistencia
  AS
  SELECT
  tipo,
  cantidad_asistencias,
  RANK() OVER(
    ORDER BY cantidad_asistencias DESC
  )AS ranking
  FROM (
  SELECT
  contrato.tipo_evento AS tipo,
  SUM(evento.cantidad_asistentes) AS cantidad_asistencias
  FROM contrato
  JOIN evento
  ON contrato.id = evento.contrato_id
  GROUP BY contrato.tipo_evento
  ) AS tipo_evento;
GO


create view VW_Evento_ganancias
  AS

    WITH ingresos_ticket AS
  (
    SELECT
    evento_id,
    SUM(precio * cantidad_vendida) AS ticket_total
    FROM ticket
    GROUP BY evento_id
  ),
  total_ingresos_evento AS
  (
    SELECT
    evento_id,
    SUM(monto) AS total_ingresos_evento
    FROM ingresos_evento
    GROUP BY evento_id
  ),
  ingresos_total AS
  (
  SELECT
  contrato.tipo_evento AS tipo_evento,
  SUM(contrato.presupuesto_acordado
    +
    ISNULL(total_ingresos_evento.total_ingresos_evento,0)
    +
    ISNULL(ingresos_ticket.ticket_total,0)
  ) AS ingreso 
    FROM contrato

    LEFT JOIN evento
    ON contrato.id = evento.contrato_id

    LEFT JOIN ingresos_ticket
    ON evento.id = ingresos_ticket.evento_id

    LEFT JOIN total_ingresos_evento
    ON evento.id = total_ingresos_evento.evento_id
    group by contrato.tipo_evento
  ),
  costo_total AS
  (
    SELECT
    contrato.tipo_evento AS tipo_evento,
    SUM(subcontrato.costo)AS costo
    FROM contrato

    JOIN subcontrato
    ON contrato.id = subcontrato.contrato_id
    GROUP BY contrato.tipo_evento
  ),
  ganancia_total AS
  (
    SELECT
    ingresos_total.tipo_evento AS tipo_evento,
    ingresos_total.ingreso - costo_total.costo AS ganancia
    FROM ingresos_total

    JOIN costo_total
    ON ingresos_total.tipo_evento = costo_total.tipo_evento
  )

  SELECT
  tipo_evento,
  ganancia,
  RANK() OVER(
    ORDER BY ganancia DESC
  )AS ranking
  FROM ganancia_total;
GO

CREATE VIEW VW_Eventos_No_Realizados
AS
WITH total_eventos AS
(
    SELECT COUNT(*) AS total
    FROM evento
),
cancelaciones_categoria AS
(
    SELECT
        ISNULL(servicio.categoria, 'Causa externa') AS causa,
        COUNT(DISTINCT evento.id) AS eventos_cancelados
    FROM evento

    JOIN cancelacion
    ON evento.id = cancelacion.evento_id

    LEFT JOIN subcontrato
    ON cancelacion.subcontrato_id = subcontrato.id

    LEFT JOIN servicio
    ON subcontrato.servicio_id = servicio.id

    WHERE evento.estado = 'Cancelado'

    GROUP BY ISNULL(servicio.categoria, 'Causa externa')
)
SELECT
    causa,
    eventos_cancelados,
    CAST(
        100.0 * eventos_cancelados / total_eventos.total
        AS DECIMAL(5,2)
    ) AS porcentaje_sobre_total
FROM cancelaciones_categoria
CROSS JOIN total_eventos;
GO

CREATE VIEW VW_Estado_Eventos
AS
SELECT
    evento.id,
    evento.nombre,
    contrato.tipo_evento,
    evento.fecha_real,
    evento.estado
FROM evento

JOIN contrato
ON evento.contrato_id = contrato.id;
GO