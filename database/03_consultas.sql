-- ============================================================================
-- PROYECTO: RutaAndina - Sistema de Gestión de Taxis por Aplicación
-- ARCHIVO: 03_consultas.sql (8 Consultas Analíticas de Negocio + 1 Vista)
-- ============================================================================

USE ruta_andina;

-- ----------------------------------------------------------------------------
-- CONSULTA 1: Total de viajes e ingresos generados por país y moneda (PEN / COP)
-- ----------------------------------------------------------------------------
SELECT 
    pa.nombrePais AS Pais,
    m.simbolo AS Moneda,
    COUNT(v.idViaje) AS Total_Viajes_Finalizados,
    SUM(v.tarifa) AS Ingreso_Bruto,
    SUM(pg.comisionPlataforma) AS Comision_RutaAndina
FROM Viaje v
JOIN Direccion d ON v.idDireccionOrigen = d.idDireccion
JOIN Pais pa ON d.idPais = pa.idPais
JOIN Moneda m ON pa.idMoneda = m.idMoneda
LEFT JOIN Pago pg ON v.idViaje = pg.idViaje
WHERE (SELECT h.estado FROM HistoriaEstadoViaje h WHERE h.idViaje = v.idViaje ORDER BY h.idHistorialViaje DESC LIMIT 1) = 'Finalizado'
GROUP BY pa.nombrePais, m.simbolo;

-- ----------------------------------------------------------------------------
-- CONSULTA 2: Top 5 conductores con mejor calificación promedio (mínimo 1 viaje)
-- ----------------------------------------------------------------------------
SELECT 
    c.idConductor,
    CONCAT(c.nombre, ' ', c.apellido1) AS Conductor,
    pa.nombrePais AS Pais,
    COUNT(DISTINCT v.idViaje) AS Viajes_Realizados,
    ROUND(AVG(cal.calificacion), 2) AS Calificacion_Promedio
FROM Conductor c
JOIN Pais pa ON c.idPais = pa.idPais
JOIN Viaje v ON c.idConductor = v.idConductor
JOIN Calificacion cal ON v.idViaje = cal.idViaje
WHERE cal.emisor = 'PASAJERO'
GROUP BY c.idConductor, Conductor, pa.nombrePais
ORDER BY Calificacion_Promedio DESC, Viajes_Realizados DESC
LIMIT 5;

-- ----------------------------------------------------------------------------
-- CONSULTA 3: Consumo mensual y cantidad de viajes por empresa corporativa
-- ----------------------------------------------------------------------------
SELECT 
    e.razonSocial AS Empresa,
    e.RUC_NIT,
    pa.nombrePais AS Pais,
    m.simbolo AS Moneda,
    COUNT(v.idViaje) AS Total_Viajes_Corporativos,
    SUM(v.tarifa) AS Consumo_Total
FROM Viaje v
JOIN Empresa e ON v.idEmpresa = e.idEmpresa
JOIN Pais pa ON e.idPais = pa.idPais
JOIN Moneda m ON pa.idMoneda = m.idMoneda
WHERE v.esCorporativo = 1
GROUP BY e.idEmpresa, e.razonSocial, e.RUC_NIT, pa.nombrePais, m.simbolo
ORDER BY Consumo_Total DESC;

-- ----------------------------------------------------------------------------
-- CONSULTA 4: Conductores con licencia o seguro vencido o por vencer en <= 30 días
-- ----------------------------------------------------------------------------
SELECT 
    c.idConductor,
    CONCAT(c.nombre, ' ', c.apellido1) AS Conductor,
    pa.nombrePais AS Pais,
    l.numero AS Numero_Licencia,
    l.vencimiento AS Vencimiento_Licencia,
    veh.placa AS Placa_Vehiculo,
    s.fechaVencimiento AS Vencimiento_Seguro
FROM Conductor c
JOIN Pais pa ON c.idPais = pa.idPais
JOIN Licencia l ON c.idConductor = l.idConductor
JOIN Maneja man ON c.idConductor = man.idConductor AND man.activo = 1
JOIN Vehiculo veh ON man.idVehiculo = veh.idVehiculo
JOIN Seguro s ON veh.idSeguro = s.idSeguro
WHERE l.vencimiento <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)
   OR s.fechaVencimiento <= DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- ----------------------------------------------------------------------------
-- CONSULTA 5: Viajes cancelados agrupados por país y tipo de servicio
-- ----------------------------------------------------------------------------
SELECT 
    pa.nombrePais AS Pais,
    COALESCE(veh.tipoServicio, 'Sin asignar') AS Tipo_Servicio,
    COUNT(v.idViaje) AS Total_Cancelados
FROM Viaje v
JOIN Direccion d ON v.idDireccionOrigen = d.idDireccion
JOIN Pais pa ON d.idPais = pa.idPais
LEFT JOIN Maneja man ON v.idConductor = man.idConductor AND man.activo = 1
LEFT JOIN Vehiculo veh ON man.idVehiculo = veh.idVehiculo
WHERE (SELECT h.estado FROM HistoriaEstadoViaje h WHERE h.idViaje = v.idViaje ORDER BY h.idHistorialViaje DESC LIMIT 1) = 'Cancelado'
GROUP BY pa.nombrePais, Tipo_Servicio;

-- ----------------------------------------------------------------------------
-- CONSULTA 6: Distribución de viajes y monto recaudado por método de pago
-- ----------------------------------------------------------------------------
SELECT 
    mp.tipoPago AS Metodo_Pago,
    m.simbolo AS Moneda,
    COUNT(pg.idPago) AS Cantidad_Transacciones,
    SUM(pg.monto) AS Total_Recaudado
FROM Pago pg
JOIN MetodoPago mp ON pg.idMetodoPago = mp.idMetodoPago
JOIN Moneda m ON pg.idMoneda = m.idMoneda
GROUP BY mp.tipoPago, m.simbolo
ORDER BY Cantidad_Transacciones DESC;

-- ----------------------------------------------------------------------------
-- CONSULTA 7: Pasajeros más frecuentes con su gasto acumulado por país
-- ----------------------------------------------------------------------------
SELECT 
    p.idPasajero,
    CONCAT(p.nombre, ' ', p.apellido1) AS Pasajero,
    pa.nombrePais AS Pais,
    m.simbolo AS Moneda,
    COUNT(v.idViaje) AS Viajes_Solicitados,
    SUM(v.tarifa) AS Gasto_Total
FROM Pasajero p
JOIN Pais pa ON p.idPais = pa.idPais
JOIN Moneda m ON pa.idMoneda = m.idMoneda
JOIN Viaje v ON p.idPasajero = v.idPasajero
GROUP BY p.idPasajero, Pasajero, pa.nombrePais, m.simbolo
ORDER BY Viajes_Solicitados DESC, Gasto_Total DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- CONSULTA 8: Rendimiento de vehículos afiliados a flotas vs. independientes
-- ----------------------------------------------------------------------------
SELECT 
    COALESCE(e.nombre, 'Conductor Independiente') AS Flota_O_Propietario,
    veh.placa,
    CONCAT(veh.marca, ' ', veh.modelo) AS Vehiculo,
    veh.tipoServicio,
    COUNT(v.idViaje) AS Viajes_Completados,
    COALESCE(SUM(v.tarifa), 0) AS Facturacion_Generada
FROM Vehiculo veh
LEFT JOIN Empresa e ON veh.idEmpresa = e.idEmpresa
LEFT JOIN Maneja man ON veh.idVehiculo = man.idVehiculo AND man.activo = 1
LEFT JOIN Viaje v ON man.idConductor = v.idConductor
GROUP BY Flota_O_Propietario, veh.placa, Vehiculo, veh.tipoServicio
ORDER BY Facturacion_Generada DESC;

-- ----------------------------------------------------------------------------
-- VISTA (CREATE VIEW): Resumen consolidado de viajes operativos para reportes
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_resumen_viajes_ruta_andina AS
SELECT 
    v.idViaje,
    pa.nombrePais AS pais,
    m.simbolo AS moneda,
    CONCAT(p.nombre, ' ', p.apellido1) AS pasajero,
    COALESCE(CONCAT(c.nombre, ' ', c.apellido1), 'Pendiente de asignar') AS conductor,
    d1.direccionTexto AS origen,
    d2.direccionTexto AS destino,
    v.distancia AS km,
    v.tarifa,
    IF(v.esCorporativo = 1, 'Corporativo', 'Personal') AS modalidad,
    (SELECT h.estado FROM HistoriaEstadoViaje h WHERE h.idViaje = v.idViaje ORDER BY h.idHistorialViaje DESC LIMIT 1) AS estado_actual,
    v.fechaHoraSolicitud
FROM Viaje v
JOIN Pasajero p ON v.idPasajero = p.idPasajero
LEFT JOIN Conductor c ON v.idConductor = c.idConductor
JOIN Direccion d1 ON v.idDireccionOrigen = d1.idDireccion
JOIN Direccion d2 ON v.idDireccionDestino = d2.idDireccion
JOIN Pais pa ON d1.idPais = pa.idPais
JOIN Moneda m ON pa.idMoneda = m.idMoneda;

-- Prueba de la vista:
SELECT * FROM vw_resumen_viajes_ruta_andina LIMIT 15;