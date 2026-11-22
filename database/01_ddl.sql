-- ============================================================================
-- PROYECTO: RutaAndina - Sistema de Gestión de Taxis por Aplicación
-- ARCHIVO: 01_ddl.sql (Con nombres explícitos en todos los CONSTRAINTS)
-- MOTOR: MySQL 8.0+
-- ============================================================================

DROP DATABASE IF EXISTS ruta_andina;
CREATE DATABASE ruta_andina CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ruta_andina;

-- ----------------------------------------------------------------------------
-- 1. TABLA: Moneda
-- ----------------------------------------------------------------------------
CREATE TABLE Moneda (
    idMoneda INT AUTO_INCREMENT,
    nombreMoneda VARCHAR(50) NOT NULL,
    simbolo VARCHAR(10) NOT NULL,
    CONSTRAINT pk_moneda PRIMARY KEY (idMoneda),
    CONSTRAINT uq_moneda_simbolo UNIQUE (simbolo)
);

-- ----------------------------------------------------------------------------
-- 2. TABLA: Pais
-- ----------------------------------------------------------------------------
CREATE TABLE Pais (
    idPais INT AUTO_INCREMENT,
    nombrePais VARCHAR(60) NOT NULL,
    idMoneda INT NOT NULL,
    CONSTRAINT pk_pais PRIMARY KEY (idPais),
    CONSTRAINT uq_pais_nombre UNIQUE (nombrePais),
    CONSTRAINT fk_pais_moneda FOREIGN KEY (idMoneda) REFERENCES Moneda(idMoneda)
);

-- ----------------------------------------------------------------------------
-- 3. TABLA: Direccion
-- ----------------------------------------------------------------------------
CREATE TABLE Direccion (
    idDireccion INT AUTO_INCREMENT,
    idPais INT NOT NULL,
    ciudad VARCHAR(80) NOT NULL,
    direccionTexto VARCHAR(200) NOT NULL,
    CONSTRAINT pk_direccion PRIMARY KEY (idDireccion),
    CONSTRAINT fk_direccion_pais FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

-- ----------------------------------------------------------------------------
-- 4. TABLA: Empresa
-- ----------------------------------------------------------------------------
CREATE TABLE Empresa (
    idEmpresa INT AUTO_INCREMENT,
    idPais INT NOT NULL,
    RUC_NIT VARCHAR(25) NOT NULL,
    razonSocial VARCHAR(150) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('OPERADORA', 'CLIENTE_CORPORATIVO', 'FLOTA') NOT NULL,
    contacto VARCHAR(100) NOT NULL,
    CONSTRAINT pk_empresa PRIMARY KEY (idEmpresa),
    CONSTRAINT uq_empresa_ruc_nit UNIQUE (RUC_NIT),
    CONSTRAINT fk_empresa_pais FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

-- ----------------------------------------------------------------------------
-- 5. TABLA: Pasajero
-- ----------------------------------------------------------------------------
CREATE TABLE Pasajero (
    idPasajero INT AUTO_INCREMENT,
    idPais INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    apellido1 VARCHAR(60) NOT NULL,
    apellido2 VARCHAR(60) NULL,
    documentoIdentidad VARCHAR(25) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    CONSTRAINT pk_pasajero PRIMARY KEY (idPasajero),
    CONSTRAINT uq_pasajero_documento UNIQUE (documentoIdentidad),
    CONSTRAINT uq_pasajero_correo UNIQUE (correo),
    CONSTRAINT fk_pasajero_pais FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

-- ----------------------------------------------------------------------------
-- 6. TABLA: EmpresaPasajero
-- ----------------------------------------------------------------------------
CREATE TABLE EmpresaPasajero (
    idEmprePasajero INT AUTO_INCREMENT,
    idPasajero INT NOT NULL,
    idEmpresa INT NOT NULL,
    cargo VARCHAR(80) NOT NULL,
    estado ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
    CONSTRAINT pk_empresapasajero PRIMARY KEY (idEmprePasajero),
    CONSTRAINT uq_empresapasajero_relacion UNIQUE (idPasajero, idEmpresa),
    CONSTRAINT fk_empresapasajero_pasajero FOREIGN KEY (idPasajero) REFERENCES Pasajero(idPasajero),
    CONSTRAINT fk_empresapasajero_empresa FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa)
);

-- ----------------------------------------------------------------------------
-- 7. TABLA: DireccionesFavoritas
-- ----------------------------------------------------------------------------
CREATE TABLE DireccionesFavoritas (
    idPasajero INT NOT NULL,
    idDireccion INT NOT NULL,
    sobrenombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_direccionesfavoritas PRIMARY KEY (idPasajero, idDireccion),
    CONSTRAINT fk_dirfavoritas_pasajero FOREIGN KEY (idPasajero) REFERENCES Pasajero(idPasajero),
    CONSTRAINT fk_dirfavoritas_direccion FOREIGN KEY (idDireccion) REFERENCES Direccion(idDireccion)
);

-- ----------------------------------------------------------------------------
-- 8. TABLA: MetodoPago
-- ----------------------------------------------------------------------------
CREATE TABLE MetodoPago (
    idMetodoPago INT AUTO_INCREMENT,
    idPasajero INT NOT NULL,
    tipoPago VARCHAR(40) NOT NULL,
    predeterminado TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT pk_metodopago PRIMARY KEY (idMetodoPago),
    CONSTRAINT chk_metodopago_predeterminado CHECK (predeterminado IN (0, 1)),
    CONSTRAINT fk_metodopago_pasajero FOREIGN KEY (idPasajero) REFERENCES Pasajero(idPasajero)
);

-- ----------------------------------------------------------------------------
-- 9. TABLA: Conductor
-- ----------------------------------------------------------------------------
CREATE TABLE Conductor (
    idConductor INT AUTO_INCREMENT,
    idPais INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    apellido1 VARCHAR(60) NOT NULL,
    apellido2 VARCHAR(60) NULL,
    documentoIdentidad VARCHAR(25) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    estado ENUM('Activo', 'Suspendido', 'En revisión') NOT NULL DEFAULT 'En revisión',
    cuentaPago VARCHAR(50) NOT NULL,
    CONSTRAINT pk_conductor PRIMARY KEY (idConductor),
    CONSTRAINT uq_conductor_documento UNIQUE (documentoIdentidad),
    CONSTRAINT uq_conductor_correo UNIQUE (correo),
    CONSTRAINT fk_conductor_pais FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);

-- ----------------------------------------------------------------------------
-- 10. TABLA: Licencia
-- ----------------------------------------------------------------------------
CREATE TABLE Licencia (
    idLicencia INT AUTO_INCREMENT,
    idConductor INT NOT NULL,
    numero VARCHAR(30) NOT NULL,
    categoria VARCHAR(20) NOT NULL,
    vencimiento DATE NOT NULL,
    CONSTRAINT pk_licencia PRIMARY KEY (idLicencia),
    CONSTRAINT uq_licencia_conductor UNIQUE (idConductor),
    CONSTRAINT uq_licencia_numero UNIQUE (numero),
    CONSTRAINT fk_licencia_conductor FOREIGN KEY (idConductor) REFERENCES Conductor(idConductor)
);

-- ----------------------------------------------------------------------------
-- 11. TABLA: Seguro
-- ----------------------------------------------------------------------------
CREATE TABLE Seguro (
    idSeguro INT AUTO_INCREMENT,
    tipoSeguro VARCHAR(50) NOT NULL,
    fechaEmision DATE NOT NULL,
    fechaVencimiento DATE NOT NULL,
    costo DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_seguro PRIMARY KEY (idSeguro),
    CONSTRAINT chk_seguro_fechas CHECK (fechaVencimiento > fechaEmision),
    CONSTRAINT chk_seguro_costo CHECK (costo >= 0)
);

-- ----------------------------------------------------------------------------
-- 12. TABLA: Vehiculo
-- ----------------------------------------------------------------------------
CREATE TABLE Vehiculo (
    idVehiculo INT AUTO_INCREMENT,
    idEmpresa INT NULL,
    idSeguro INT NOT NULL,
    placa VARCHAR(15) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio SMALLINT NOT NULL,
    color VARCHAR(30) NOT NULL,
    tipoServicio ENUM('Económico', 'Confort', 'XL') NOT NULL,
    CONSTRAINT pk_vehiculo PRIMARY KEY (idVehiculo),
    CONSTRAINT uq_vehiculo_seguro UNIQUE (idSeguro),
    CONSTRAINT uq_vehiculo_placa UNIQUE (placa),
    CONSTRAINT chk_vehiculo_anio CHECK (anio >= 2000),
    CONSTRAINT fk_vehiculo_empresa FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa),
    CONSTRAINT fk_vehiculo_seguro FOREIGN KEY (idSeguro) REFERENCES Seguro(idSeguro)
);

-- ----------------------------------------------------------------------------
-- 13. TABLA: Maneja
-- ----------------------------------------------------------------------------
CREATE TABLE Maneja (
    idManeja INT AUTO_INCREMENT,
    idVehiculo INT NOT NULL,
    idConductor INT NOT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    fechaAsignacion DATE NOT NULL,
    CONSTRAINT pk_maneja PRIMARY KEY (idManeja),
    CONSTRAINT chk_maneja_activo CHECK (activo IN (0, 1)),
    CONSTRAINT fk_maneja_vehiculo FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo),
    CONSTRAINT fk_maneja_conductor FOREIGN KEY (idConductor) REFERENCES Conductor(idConductor)
);

-- ----------------------------------------------------------------------------
-- 14. TABLA: Viaje
-- ----------------------------------------------------------------------------
CREATE TABLE Viaje (
    idViaje INT AUTO_INCREMENT,
    idPasajero INT NOT NULL,
    idEmpresa INT NULL,
    idConductor INT NULL,
    idDireccionOrigen INT NOT NULL,
    idDireccionDestino INT NOT NULL,
    fechaHoraSolicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fechaHoraInicio DATETIME NULL,
    fechaHoraFin DATETIME NULL,
    distancia DECIMAL(8, 2) NOT NULL,
    tarifa DECIMAL(10, 2) NOT NULL,
    esCorporativo TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT pk_viaje PRIMARY KEY (idViaje),
    CONSTRAINT chk_viaje_distancia CHECK (distancia > 0),
    CONSTRAINT chk_viaje_tarifa CHECK (tarifa >= 0),
    CONSTRAINT chk_viaje_corporativo CHECK (esCorporativo IN (0, 1)),
    CONSTRAINT fk_viaje_pasajero FOREIGN KEY (idPasajero) REFERENCES Pasajero(idPasajero),
    CONSTRAINT fk_viaje_empresa FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa),
    CONSTRAINT fk_viaje_conductor FOREIGN KEY (idConductor) REFERENCES Conductor(idConductor),
    CONSTRAINT fk_viaje_direccion_origen FOREIGN KEY (idDireccionOrigen) REFERENCES Direccion(idDireccion),
    CONSTRAINT fk_viaje_direccion_destino FOREIGN KEY (idDireccionDestino) REFERENCES Direccion(idDireccion)
);

-- ----------------------------------------------------------------------------
-- 15. TABLA: HistoriaEstadoViaje
-- ----------------------------------------------------------------------------
CREATE TABLE HistoriaEstadoViaje (
    idHistorialViaje INT AUTO_INCREMENT,
    idViaje INT NOT NULL,
    estado ENUM('Solicitado', 'Aceptado', 'En curso', 'Finalizado', 'Cancelado') NOT NULL,
    fechaHoraDeCambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_historiaestadoviaje PRIMARY KEY (idHistorialViaje),
    CONSTRAINT fk_historiaestado_viaje FOREIGN KEY (idViaje) REFERENCES Viaje(idViaje)
);

-- ----------------------------------------------------------------------------
-- 16. TABLA: Pago
-- ----------------------------------------------------------------------------
CREATE TABLE Pago (
    idPago INT AUTO_INCREMENT,
    idViaje INT NOT NULL,
    idMetodoPago INT NOT NULL,
    idMoneda INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Pendiente', 'Pagado', 'Facturado', 'Fallido') NOT NULL DEFAULT 'Pendiente',
    comisionPlataforma DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY (idPago),
    CONSTRAINT uq_pago_viaje UNIQUE (idViaje),
    CONSTRAINT chk_pago_monto CHECK (monto >= 0),
    CONSTRAINT chk_pago_comision CHECK (comisionPlataforma >= 0),
    CONSTRAINT fk_pago_viaje FOREIGN KEY (idViaje) REFERENCES Viaje(idViaje),
    CONSTRAINT fk_pago_metodopago FOREIGN KEY (idMetodoPago) REFERENCES MetodoPago(idMetodoPago),
    CONSTRAINT fk_pago_moneda FOREIGN KEY (idMoneda) REFERENCES Moneda(idMoneda)
);

-- ----------------------------------------------------------------------------
-- 17. TABLA: Calificacion
-- ----------------------------------------------------------------------------
CREATE TABLE Calificacion (
    idCalificacion INT AUTO_INCREMENT,
    idViaje INT NOT NULL,
    calificacion TINYINT NOT NULL,
    comentario VARCHAR(255) NULL,
    emisor ENUM('PASAJERO', 'CONDUCTOR') NOT NULL,
    CONSTRAINT pk_calificacion PRIMARY KEY (idCalificacion),
    CONSTRAINT uq_calificacion_viaje_emisor UNIQUE (idViaje, emisor),
    CONSTRAINT chk_calificacion_puntaje CHECK (calificacion BETWEEN 1 AND 5),
    CONSTRAINT fk_calificacion_viaje FOREIGN KEY (idViaje) REFERENCES Viaje(idViaje)
);