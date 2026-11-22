-- ============================================================================
-- PROYECTO: RutaAndina - Sistema de Gestión de Taxis por Aplicación
-- ARCHIVO: 02_dml.sql (Datos de prueba: 20 pasajeros, 10 conductores, 10 veh., 3 emp., 50 viajes)
-- ============================================================================

USE ruta_andina;

-- 1. MONEDAS (PEN y COP)
INSERT INTO Moneda (nombreMoneda, simbolo) VALUES
('Sol Peruano', 'PEN'),
('Peso Colombiano', 'COP');

-- 2. PAISES (Perú y Colombia)
INSERT INTO Pais (nombrePais, idMoneda) VALUES
('Perú', 1),
('Colombia', 2);

-- 3. EMPRESAS (1 Operadora, 1 Cliente Corporativo, 1 Flota)
INSERT INTO Empresa (idPais, RUC_NIT, razonSocial, nombre, tipo, contacto) VALUES
(1, '20601234561', 'RutaAndina Operaciones S.A.C.', 'RutaAndina HQ', 'OPERADORA', 'soporte@rutaandina.com'),
(1, '20559876543', 'TechAndes Soluciones S.A.C.', 'TechAndes', 'CLIENTE_CORPORATIVO', 'rrhh@techandes.pe'),
(2, '900456789-1', 'Transportes Bogotá Flota S.A.S.', 'Flota Bogotá', 'FLOTA', 'flota@bogotataxi.co');

-- 4. DIRECCIONES (Perú y Colombia)
INSERT INTO Direccion (idPais, ciudad, direccionTexto) VALUES
(1, 'Lima', 'Av. Javier Prado Este 450, San Isidro'),
(1, 'Lima', 'Av. Larco 1230, Miraflores'),
(1, 'Lima', 'Aeropuerto Internacional Jorge Chávez, Callao'),
(1, 'Lima', 'Av. Universitaria 1801, San Miguel'),
(1, 'Lima', 'Jirón de la Unión 550, Cercado de Lima'),
(2, 'Bogotá', 'Calle 93 # 14-20, Chapinero'),
(2, 'Bogotá', 'Carrera 7 # 71-52, Zona G'),
(2, 'Bogotá', 'Aeropuerto Internacional El Dorado, Engativá'),
(2, 'Bogotá', 'Av. El Dorado # 68C-61, Salitre'),
(2, 'Bogotá', 'Calle 116 # 15-40, Usaquén');

-- 5. PASAJEROS (20 registros: 10 Perú, 10 Colombia)
INSERT INTO Pasajero (idPais, nombre, apellido1, apellido2, documentoIdentidad, telefono, correo) VALUES
(1, 'Carlos', 'Mendoza', 'Ruiz', '71234501', '987654301', 'carlos@mail.com'),
(1, 'Valeria', 'Quispe', 'Torres', '71234502', '987654302', 'valeria.q@mail.com'),
(1, 'Diego', 'Fernández', 'Salas', '71234503', '987654303', 'diego.f@mail.com'),
(1, 'Camila', 'Rojas', 'Vega', '71234504', '987654304', 'camila.r@mail.com'),
(1, 'Jorge', 'Paredes', 'Luna', '71234505', '987654305', 'jorge.p@mail.com'),
(1, 'Lucía', 'Castillo', 'Mora', '71234506', '987654306', 'lucia.c@mail.com'),
(1, 'Mateo', 'Huamán', 'Cruz', '71234507', '987654307', 'mateo.h@mail.com'),
(1, 'Sofía', 'Delgado', 'Paz', '71234508', '987654308', 'sofia.d@mail.com'),
(1, 'Andrés', 'Navarro', 'Silva', '71234509', '987654309', 'andres.n@mail.com'),
(1, 'Elena', 'Vargas', 'Ríos', '71234510', '987654310', 'elena.v@mail.com'),
(2, 'Santiago', 'Gómez', 'Mejía', '102030401', '3101234501', 'santiago.g@mail.co'),
(2, 'Mariana', 'Rodríguez', 'Pinto', '102030402', '3101234502', 'mariana.r@mail.co'),
(2, 'Sebastián', 'López', 'Cano', '102030403', '3101234503', 'sebastian.l@mail.co'),
(2, 'Valentina', 'Martínez', 'Díaz', '102030404', '3101234504', 'valentina.m@mail.co'),
(2, 'Nicolás', 'Restrepo', 'Gil', '102030405', '3101234505', 'nicolas.r@mail.co'),
(2, 'Isabella', 'Ospina', 'Ortiz', '102030406', '3101234506', 'isabella.o@mail.co'),
(2, 'Alejandro', 'Cardona', 'Reyes', '102030407', '3101234507', 'alejandro.c@mail.co'),
(2, 'Gabriela', 'Morales', 'Peña', '102030408', '3101234508', 'gabriela.m@mail.co'),
(2, 'Daniel', 'Herrera', 'Soto', '102030409', '3101234509', 'daniel.h@mail.co'),
(2, 'Paula', 'Suárez', 'León', '102030410', '3101234510', 'paula.s@mail.co');

-- 6. EMPRESA-PASAJERO (Afiliados a TechAndes idEmpresa=2)
INSERT INTO EmpresaPasajero (idPasajero, idEmpresa, cargo, estado) VALUES
(1, 2, 'Analista TI', 'Activo'),
(2, 2, 'Jefa de Proyectos', 'Activo'),
(3, 2, 'Consultor Senior', 'Activo'),
(4, 2, 'Ejecutiva Comercial', 'Activo');

-- 7. DIRECCIONES FAVORITAS
INSERT INTO DireccionesFavoritas (idPasajero, idDireccion, sobrenombre) VALUES
(1, 1, 'Oficina'),
(1, 2, 'Casa'),
(11, 6, 'Trabajo'),
(11, 8, 'Aeropuerto');

-- 8. METODOS DE PAGO (Uno por pasajero como predeterminado)
INSERT INTO MetodoPago (idPasajero, tipoPago, predeterminado) VALUES
(1, 'Tarjeta Visa', 1), (1, 'Yape / QR', 0),
(2, 'Tarjeta Mastercard', 1), (3, 'Efectivo', 1), (4, 'Yape / QR', 1), (5, 'Tarjeta Visa', 1),
(6, 'Efectivo', 1), (7, 'Yape / QR', 1), (8, 'Tarjeta Visa', 1), (9, 'Efectivo', 1), (10, 'Yape / QR', 1),
(11, 'Tarjeta Mastercard', 1), (12, 'Nequi / QR', 1), (13, 'Efectivo', 1), (14, 'Tarjeta Visa', 1), (15, 'Nequi / QR', 1),
(16, 'Efectivo', 1), (17, 'Tarjeta Visa', 1), (18, 'Nequi / QR', 1), (19, 'Efectivo', 1), (20, 'Tarjeta Mastercard', 1);

-- 9. CONDUCTORES (10 registros: 5 Perú, 5 Colombia)
INSERT INTO Conductor (idPais, nombre, apellido1, apellido2, documentoIdentidad, telefono, correo, estado, cuentaPago) VALUES
(1, 'Luis', 'Gómez', 'Chávez', '41234501', '991122301', 'luis@mail.com', 'Activo', 'BCP-191000111'),
(1, 'Pedro', 'Salazar', 'Méndez', '41234502', '991122302', 'pedro.cond@mail.com', 'Activo', 'BBVA-001100222'),
(1, 'Miguel', 'Torres', 'Ramos', '41234503', '991122303', 'miguel.cond@mail.com', 'Activo', 'IBK-200300333'),
(1, 'José', 'Ramírez', 'Paredes', '41234504', '991122304', 'jose.cond@mail.com', 'Activo', 'BCP-191000444'),
(1, 'Ricardo', 'Flores', 'Vega', '41234505', '991122305', 'ricardo.cond@mail.com', 'Suspendido', 'BCP-191000555'),
(2, 'Andrés', 'Cárdenas', 'Roa', '80123401', '3201122301', 'andres.cond@mail.co', 'Activo', 'BANCOLOMBIA-501'),
(2, 'Camilo', 'Vargas', 'Duarte', '80123402', '3201122302', 'camilo.cond@mail.co', 'Activo', 'DAVIVIENDA-502'),
(2, 'Felipe', 'Rincón', 'Acosta', '80123403', '3201122303', 'felipe.cond@mail.co', 'Activo', 'BANCOLOMBIA-503'),
(2, 'Juan', 'Castro', 'Mora', '80123404', '3201122304', 'juan.cond@mail.co', 'Activo', 'NEQUI-3201122304'),
(2, 'Óscar', 'Pineda', 'Cruz', '80123405', '3201122305', 'oscar.cond@mail.co', 'En revisión', 'BANCOLOMBIA-505');

-- 10. LICENCIAS (10 registros, incluye una por vencer en <30 días para las consultas)
INSERT INTO Licencia (idConductor, numero, categoria, vencimiento) VALUES
(1, 'Q41234501', 'A-IIb', '2028-05-15'),
(2, 'Q41234502', 'A-IIb', '2026-12-10'),
(3, 'Q41234503', 'A-IIa', '2027-08-20'),
(4, 'Q41234504', 'A-IIb', '2028-01-30'),
(5, 'Q41234505', 'A-IIa', '2026-10-01'),
(6, 'C80123401', 'C1', '2028-06-12'),
(7, 'C80123402', 'C1', '2026-12-15'),
(8, 'C80123403', 'C2', '2027-11-05'),
(9, 'C80123404', 'C1', '2028-03-18'),
(10, 'C80123405', 'C1', '2027-04-22');

-- 11. SEGUROS (10 registros)
INSERT INTO Seguro (tipoSeguro, fechaEmision, fechaVencimiento, costo) VALUES
('SOAT', '2026-01-10', '2027-01-10', 180.00),
('SOAT', '2025-12-05', '2026-12-05', 185.00),
('SOAT', '2026-03-15', '2027-03-15', 180.00),
('SOAT', '2026-05-20', '2027-05-20', 190.00),
('SOAT', '2025-09-01', '2026-09-01', 180.00),
('SOAT Colombia', '2026-02-10', '2027-02-10', 450000.00),
('SOAT Colombia', '2025-12-12', '2026-12-12', 460000.00),
('SOAT Colombia', '2026-04-01', '2027-04-01', 450000.00),
('SOAT Colombia', '2026-06-18', '2027-06-18', 470000.00),
('SOAT Colombia', '2026-07-22', '2027-07-22', 450000.00);

-- 12. VEHICULOS (10 registros: 5 Perú propios, 5 Colombia afiliados a Flota idEmpresa=3)
INSERT INTO Vehiculo (idEmpresa, idSeguro, placa, marca, modelo, anio, color, tipoServicio) VALUES
(NULL, 1, 'ABC-101', 'Toyota', 'Yaris', 2021, 'Gris', 'Económico'),
(NULL, 2, 'ABC-102', 'Kia', 'Soluto', 2022, 'Blanco', 'Económico'),
(NULL, 3, 'ABC-103', 'Hyundai', 'Elantra', 2023, 'Negro', 'Confort'),
(NULL, 4, 'ABC-104', 'Toyota', 'Rush', 2022, 'Plata', 'XL'),
(NULL, 5, 'ABC-105', 'Nissan', 'Versa', 2020, 'Azul', 'Económico'),
(3, 6, 'BOG-201', 'Chevrolet', 'Onix', 2022, 'Blanco', 'Económico'),
(3, 7, 'BOG-202', 'Renault', 'Logan', 2021, 'Gris', 'Económico'),
(3, 8, 'BOG-203', 'Mazda', 'Mazda 3', 2023, 'Negro', 'Confort'),
(3, 9, 'BOG-204', 'Kia', 'Sportage', 2022, 'Rojo', 'XL'),
(3, 10, 'BOG-205', 'Hyundai', 'Accent', 2021, 'Plata', 'Económico');

-- 13. MANEJA (Asignación activa de cada conductor a su vehículo)
INSERT INTO Maneja (idVehiculo, idConductor, activo, fechaAsignacion) VALUES
(1, 1, 1, '2026-01-15'), (2, 2, 1, '2026-01-15'), (3, 3, 1, '2026-01-15'), (4, 4, 1, '2026-01-15'), (5, 5, 1, '2026-01-15'),
(6, 6, 1, '2026-02-01'), (7, 7, 1, '2026-02-01'), (8, 8, 1, '2026-02-01'), (9, 9, 1, '2026-02-01'), (10, 10, 1, '2026-02-01');

-- 14. VIAJES (50 viajes: 1 al 25 en Perú PEN, 26 al 50 en Colombia COP)
INSERT INTO Viaje (idPasajero, idEmpresa, idConductor, idDireccionOrigen, idDireccionDestino, fechaHoraSolicitud, fechaHoraInicio, fechaHoraFin, distancia, tarifa, esCorporativo) VALUES
-- 25 viajes Perú (incluye viajes corporativos de TechAndes idEmpresa=2 y 2 viajes en estado Solicitado para probar)
(1, 2, 1, 1, 2, '2026-11-01 08:00:00', '2026-11-01 08:05:00', '2026-11-01 08:25:00', 5.2, 18.00, 1),
(1, 2, 1, 2, 3, '2026-11-02 09:00:00', '2026-11-02 09:08:00', '2026-11-02 09:45:00', 16.5, 45.00, 1),
(2, 2, 2, 1, 3, '2026-11-03 10:00:00', '2026-11-03 10:06:00', '2026-11-03 10:40:00', 15.0, 42.00, 1),
(3, 2, 3, 2, 1, '2026-11-04 11:00:00', '2026-11-04 11:05:00', '2026-11-04 11:22:00', 4.8, 22.00, 1),
(4, 2, 4, 3, 1, '2026-11-05 14:00:00', '2026-11-05 14:10:00', '2026-11-05 14:50:00', 15.8, 55.00, 1),
(1, NULL, 1, 2, 4, '2026-11-06 16:00:00', '2026-11-06 16:05:00', '2026-11-06 16:30:00', 8.0, 24.00, 0),
(2, NULL, 1, 4, 5, '2026-11-07 17:00:00', '2026-11-07 17:06:00', '2026-11-07 17:28:00', 6.5, 20.00, 0),
(3, NULL, 1, 5, 1, '2026-11-08 18:00:00', '2026-11-08 18:04:00', '2026-11-08 18:25:00', 5.5, 19.00, 0),
(4, NULL, 1, 1, 4, '2026-11-09 08:30:00', '2026-11-09 08:35:00', '2026-11-09 09:00:00', 7.2, 23.00, 0),
(5, NULL, 2, 2, 5, '2026-11-10 09:30:00', '2026-11-10 09:35:00', '2026-11-10 10:00:00', 7.0, 21.00, 0),
(6, NULL, 2, 3, 2, '2026-11-11 10:30:00', '2026-11-11 10:38:00', '2026-11-11 11:15:00', 16.0, 44.00, 0),
(7, NULL, 2, 4, 1, '2026-11-12 11:30:00', '2026-11-12 11:35:00', '2026-11-12 12:00:00', 7.5, 22.50, 0),
(8, NULL, 2, 5, 2, '2026-11-13 12:30:00', '2026-11-13 12:36:00', '2026-11-13 13:02:00', 6.8, 20.50, 0),
(9, NULL, 3, 1, 3, '2026-11-14 13:30:00', '2026-11-14 13:35:00', '2026-11-14 14:15:00', 15.2, 48.00, 0),
(10, NULL, 3, 2, 4, '2026-11-15 14:30:00', '2026-11-15 14:35:00', '2026-11-15 15:00:00', 8.1, 28.00, 0),
(5, NULL, 3, 3, 4, '2026-11-16 15:30:00', '2026-11-16 15:37:00', '2026-11-16 16:05:00', 9.0, 30.00, 0),
(6, NULL, 3, 4, 5, '2026-11-17 16:30:00', '2026-11-17 16:35:00', '2026-11-17 16:58:00', 6.4, 23.00, 0),
(7, NULL, 4, 5, 3, '2026-11-18 17:30:00', '2026-11-18 17:36:00', '2026-11-18 18:10:00', 12.0, 42.00, 0),
(8, NULL, 4, 1, 2, '2026-11-19 18:30:00', '2026-11-19 18:34:00', '2026-11-19 18:50:00', 4.5, 21.00, 0),
(9, NULL, 4, 2, 3, '2026-11-19 19:30:00', '2026-11-19 19:38:00', '2026-11-19 20:15:00', 16.5, 56.00, 0),
(10, NULL, 4, 3, 5, '2026-11-20 08:00:00', '2026-11-20 08:06:00', '2026-11-20 08:38:00', 11.5, 40.00, 0),
(1, NULL, 2, 1, 5, '2026-11-20 10:00:00', NULL, NULL, 5.5, 18.50, 0), -- Cancelado
(2, NULL, 3, 2, 1, '2026-11-20 12:00:00', NULL, NULL, 4.8, 22.00, 0), -- Cancelado
(1, 2, NULL, 1, 3, '2026-11-21 20:00:00', NULL, NULL, 15.0, 45.00, 1), -- Solicitado (pendiente)
(3, NULL, NULL, 2, 4, '2026-11-21 20:15:00', NULL, NULL, 8.0, 24.00, 0), -- Solicitado (pendiente)
-- 25 viajes Colombia (COP)
(11, NULL, 6, 6, 7, '2026-11-01 08:15:00', '2026-11-01 08:20:00', '2026-11-01 08:40:00', 4.2, 16000.00, 0),
(12, NULL, 6, 7, 8, '2026-11-02 09:15:00', '2026-11-02 09:22:00', '2026-11-02 10:00:00', 14.0, 38000.00, 0),
(13, NULL, 6, 8, 9, '2026-11-03 10:15:00', '2026-11-03 10:20:00', '2026-11-03 10:42:00', 7.5, 22000.00, 0),
(14, NULL, 6, 9, 10, '2026-11-04 11:15:00', '2026-11-04 11:20:00', '2026-11-04 11:50:00', 10.2, 29000.00, 0),
(15, NULL, 6, 10, 6, '2026-11-05 12:15:00', '2026-11-05 12:20:00', '2026-11-05 12:38:00', 4.5, 17000.00, 0),
(16, NULL, 7, 6, 8, '2026-11-06 13:15:00', '2026-11-06 13:22:00', '2026-11-06 14:02:00', 15.1, 41000.00, 0),
(17, NULL, 7, 7, 9, '2026-11-07 14:15:00', '2026-11-07 14:20:00', '2026-11-07 14:45:00', 8.0, 24000.00, 0),
(18, NULL, 7, 8, 10, '2026-11-08 15:15:00', '2026-11-08 15:22:00', '2026-11-08 16:00:00', 16.0, 44000.00, 0),
(19, NULL, 7, 9, 6, '2026-11-09 16:15:00', '2026-11-09 16:20:00', '2026-11-09 16:48:00', 9.0, 26000.00, 0),
(20, NULL, 7, 10, 7, '2026-11-10 17:15:00', '2026-11-10 17:20:00', '2026-11-10 17:42:00', 6.2, 20000.00, 0),
(11, NULL, 8, 6, 9, '2026-11-11 08:45:00', '2026-11-11 08:50:00', '2026-11-11 09:18:00', 8.8, 31000.00, 0),
(12, NULL, 8, 7, 10, '2026-11-12 09:45:00', '2026-11-12 09:50:00', '2026-11-12 10:12:00', 6.0, 24000.00, 0),
(13, NULL, 8, 8, 6, '2026-11-13 10:45:00', '2026-11-13 10:52:00', '2026-11-13 11:30:00', 14.5, 46000.00, 0),
(14, NULL, 8, 9, 7, '2026-11-14 11:45:00', '2026-11-14 11:50:00', '2026-11-14 12:15:00', 7.8, 28000.00, 0),
(15, NULL, 8, 10, 8, '2026-11-15 12:45:00', '2026-11-15 12:52:00', '2026-11-15 13:32:00', 15.8, 49000.00, 0),
(16, NULL, 9, 6, 10, '2026-11-16 13:45:00', '2026-11-16 13:50:00', '2026-11-16 14:10:00', 4.6, 25000.00, 0),
(17, NULL, 9, 7, 6, '2026-11-17 14:45:00', '2026-11-17 14:50:00', '2026-11-17 15:08:00', 4.1, 23000.00, 0),
(18, NULL, 9, 8, 7, '2026-11-18 15:45:00', '2026-11-18 15:52:00', '2026-11-18 16:30:00', 13.8, 52000.00, 0),
(19, NULL, 9, 9, 8, '2026-11-19 16:45:00', '2026-11-19 16:50:00', '2026-11-19 17:12:00', 7.4, 32000.00, 0),
(20, NULL, 9, 10, 9, '2026-11-20 17:45:00', '2026-11-20 17:50:00', '2026-11-20 18:20:00', 10.0, 39000.00, 0),
(11, NULL, 6, 6, 8, '2026-11-20 19:00:00', NULL, NULL, 15.0, 41000.00, 0), -- Cancelado
(12, NULL, 7, 7, 10, '2026-11-20 20:00:00', NULL, NULL, 6.0, 20000.00, 0), -- Cancelado
(13, NULL, 8, 8, 9, '2026-11-21 09:00:00', NULL, NULL, 7.5, 28000.00, 0), -- Cancelado
(11, NULL, NULL, 6, 7, '2026-11-21 20:20:00', NULL, NULL, 4.2, 16000.00, 0), -- Solicitado (pendiente)
(14, NULL, NULL, 9, 10, '2026-11-21 20:25:00', NULL, NULL, 10.2, 29000.00, 0); -- Solicitado (pendiente)

-- 15. HISTORIAL DE ESTADOS DE VIAJE
INSERT INTO HistoriaEstadoViaje (idViaje, estado, fechaHoraDeCambio) VALUES
(1, 'Solicitado', '2026-11-01 08:00:00'), (1, 'Finalizado', '2026-11-01 08:25:00'),
(2, 'Solicitado', '2026-11-02 09:00:00'), (2, 'Finalizado', '2026-11-02 09:45:00'),
(3, 'Solicitado', '2026-11-03 10:00:00'), (3, 'Finalizado', '2026-11-03 10:40:00'),
(4, 'Solicitado', '2026-11-04 11:00:00'), (4, 'Finalizado', '2026-11-04 11:22:00'),
(5, 'Solicitado', '2026-11-05 14:00:00'), (5, 'Finalizado', '2026-11-05 14:50:00'),
(6, 'Finalizado', '2026-11-06 16:30:00'), (7, 'Finalizado', '2026-11-07 17:28:00'),
(8, 'Finalizado', '2026-11-08 18:25:00'), (9, 'Finalizado', '2026-11-09 09:00:00'),
(10, 'Finalizado', '2026-11-10 10:00:00'), (11, 'Finalizado', '2026-11-11 11:15:00'),
(12, 'Finalizado', '2026-11-12 12:00:00'), (13, 'Finalizado', '2026-11-13 13:02:00'),
(14, 'Finalizado', '2026-11-14 14:15:00'), (15, 'Finalizado', '2026-11-15 15:00:00'),
(16, 'Finalizado', '2026-11-16 16:05:00'), (17, 'Finalizado', '2026-11-17 16:58:00'),
(18, 'Finalizado', '2026-11-18 18:10:00'), (19, 'Finalizado', '2026-11-19 18:50:00'),
(20, 'Finalizado', '2026-11-19 20:15:00'), (21, 'Finalizado', '2026-11-20 08:38:00'),
(22, 'Cancelado', '2026-11-20 10:05:00'), (23, 'Cancelado', '2026-11-20 12:05:00'),
(24, 'Solicitado', '2026-11-21 20:00:00'), (25, 'Solicitado', '2026-11-21 20:15:00'),
(26, 'Finalizado', '2026-11-01 08:40:00'), (27, 'Finalizado', '2026-11-02 10:00:00'),
(28, 'Finalizado', '2026-11-03 10:42:00'), (29, 'Finalizado', '2026-11-04 11:50:00'),
(30, 'Finalizado', '2026-11-05 12:38:00'), (31, 'Finalizado', '2026-11-06 14:02:00'),
(32, 'Finalizado', '2026-11-07 14:45:00'), (33, 'Finalizado', '2026-11-08 16:00:00'),
(34, 'Finalizado', '2026-11-09 16:48:00'), (35, 'Finalizado', '2026-11-10 17:42:00'),
(36, 'Finalizado', '2026-11-11 09:18:00'), (37, 'Finalizado', '2026-11-12 10:12:00'),
(38, 'Finalizado', '2026-11-13 11:30:00'), (39, 'Finalizado', '2026-11-14 12:15:00'),
(40, 'Finalizado', '2026-11-15 13:32:00'), (41, 'Finalizado', '2026-11-16 14:10:00'),
(42, 'Finalizado', '2026-11-17 15:08:00'), (43, 'Finalizado', '2026-11-18 16:30:00'),
(44, 'Finalizado', '2026-11-19 17:12:00'), (45, 'Finalizado', '2026-11-20 18:20:00'),
(46, 'Cancelado', '2026-11-20 19:05:00'), (47, 'Cancelado', '2026-11-20 20:05:00'),
(48, 'Cancelado', '2026-11-21 09:05:00'), (49, 'Solicitado', '2026-11-21 20:20:00'),
(50, 'Solicitado', '2026-11-21 20:25:00');

-- 16. PAGOS (Comisión 15% para la plataforma)
INSERT INTO Pago (idViaje, idMetodoPago, idMoneda, monto, estado, comisionPlataforma) VALUES
(1, 1, 1, 18.00, 'Facturado', 2.70),
(2, 1, 1, 45.00, 'Facturado', 6.75),
(3, 3, 1, 42.00, 'Facturado', 6.30),
(4, 4, 1, 22.00, 'Facturado', 3.30),
(5, 5, 1, 55.00, 'Facturado', 8.25),
(6, 1, 1, 24.00, 'Pagado', 3.60),
(7, 3, 1, 20.00, 'Pagado', 3.00),
(8, 4, 1, 19.00, 'Pagado', 2.85),
(9, 5, 1, 23.00, 'Pagado', 3.45),
(10, 6, 1, 21.00, 'Pagado', 3.15),
(26, 12, 2, 16000.00, 'Pagado', 2400.00),
(27, 13, 2, 38000.00, 'Pagado', 5700.00),
(28, 14, 2, 22000.00, 'Pagado', 3300.00),
(29, 15, 2, 29000.00, 'Pagado', 4350.00),
(30, 16, 2, 17000.00, 'Pagado', 2550.00);

-- 17. CALIFICACIONES (Bidireccionales en viajes finalizados)
INSERT INTO Calificacion (idViaje, calificacion, comentario, emisor) VALUES
(1, 5, 'Excelente servicio y puntualidad', 'PASAJERO'),
(1, 5, 'Pasajero muy amable', 'CONDUCTOR'),
(2, 5, 'Auto limpio y rápido', 'PASAJERO'),
(6, 4, 'Buen viaje', 'PASAJERO'),
(7, 5, 'Muy cordial el conductor', 'PASAJERO'),
(8, 5, 'Todo perfecto', 'PASAJERO'),
(26, 5, 'Muy buen conductor en Bogotá', 'PASAJERO'),
(26, 5, 'Excelente pasajero', 'CONDUCTOR'),
(27, 4, 'Buen trayecto al aeropuerto', 'PASAJERO'),
(36, 5, 'Vehículo muy cómodo', 'PASAJERO');