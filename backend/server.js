const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '../frontend')));

app.get('/', (req, res) => {
  res.redirect('/login.html');
});

// Conexión a MySQL
const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'body7910',
  database: 'ruta_andina',
  waitForConnections: true,
  connectionLimit: 10
});

// 1. Login inteligente: detecta automáticamente si es Pasajero, Conductor o Empresa
app.post('/api/login', (req, res) => {
  const identificador = (req.body.identificador || '').trim();

  // Buscar primero en Pasajero
  const sqlPasajero = `
    SELECT p.idPasajero AS id, 'pasajero' AS rol, CONCAT(p.nombre, ' ', p.apellido1) AS nombre,
           p.correo, pa.nombrePais AS pais, m.simbolo AS moneda, ep.idEmpresa AS id_empresa
    FROM Pasajero p
    JOIN Pais pa ON p.idPais = pa.idPais
    JOIN Moneda m ON pa.idMoneda = m.idMoneda
    LEFT JOIN EmpresaPasajero ep ON p.idPasajero = ep.idPasajero AND ep.estado = 'Activo'
    WHERE p.correo = ? LIMIT 1`;

  db.query(sqlPasajero, [identificador], (err, rowsP) => {
    if (err) return res.status(500).json({ error: err.message });
    if (rowsP.length > 0) return res.json(rowsP[0]);

    // Si no es pasajero, buscar en Conductor
    const sqlConductor = `
      SELECT c.idConductor AS id, 'conductor' AS rol, CONCAT(c.nombre, ' ', c.apellido1) AS nombre,
             c.correo, pa.nombrePais AS pais, c.estado,
             l.vencimiento AS venc_licencia, s.fechaVencimiento AS venc_seguro
      FROM Conductor c
      JOIN Pais pa ON c.idPais = pa.idPais
      LEFT JOIN Licencia l ON c.idConductor = l.idConductor
      LEFT JOIN Maneja man ON c.idConductor = man.idConductor AND man.activo = 1
      LEFT JOIN Vehiculo v ON man.idVehiculo = v.idVehiculo
      LEFT JOIN Seguro s ON v.idSeguro = s.idSeguro
      WHERE c.correo = ? LIMIT 1`;

    db.query(sqlConductor, [identificador], (err, rowsC) => {
      if (err) return res.status(500).json({ error: err.message });
      if (rowsC.length > 0) return res.json(rowsC[0]);

      // Si no es conductor, buscar en Empresa por RUC o NIT
      const sqlEmpresa = `
        SELECT e.idEmpresa AS id, 'empresa' AS rol, e.nombre, e.RUC_NIT AS ruc_nit,
               pa.nombrePais AS pais, m.simbolo AS moneda
        FROM Empresa e
        JOIN Pais pa ON e.idPais = pa.idPais
        JOIN Moneda m ON pa.idMoneda = m.idMoneda
        WHERE e.RUC_NIT = ? LIMIT 1`;

      db.query(sqlEmpresa, [identificador], (err, rowsE) => {
        if (err) return res.status(500).json({ error: err.message });
        if (rowsE.length > 0) return res.json(rowsE[0]);

        res.status(401).json({ error: 'Credencial no encontrada en Pasajeros, Conductores ni Empresas.' });
      });
    });
  });
});

// 2. Registrar nuevo pasajero y asignarle un método de pago inicial
app.post('/api/pasajeros', (req, res) => {
  const { nombre, apellido, documento, telefono, correo, pais } = req.body;
  const idPais = pais.toLowerCase().includes('colombia') ? 2 : 1;
  const metodoInicial = idPais === 2 ? 'Nequi / QR' : 'Yape / QR';

  const sql = `INSERT INTO Pasajero (idPais, nombre, apellido1, documentoIdentidad, telefono, correo) VALUES (?, ?, ?, ?, ?, ?)`;
  db.query(sql, [idPais, nombre, apellido, documento, telefono, correo], (err, result) => {
    if (err) return res.status(400).json({ error: 'Correo o documento ya registrado.' });
    const nuevoId = result.insertId;
    db.query('INSERT INTO MetodoPago (idPasajero, tipoPago, predeterminado) VALUES (?, ?, 1)', [nuevoId, metodoInicial]);
    res.json({ mensaje: 'Cuenta creada correctamente', id: nuevoId });
  });
});

// 3. Solicitar nuevo viaje
app.post('/api/viajes', (req, res) => {
  const { id_pasajero, id_empresa, pais, origen, destino, distancia, tarifa, es_corporativo } = req.body;
  const idPais = pais.toLowerCase().includes('colombia') ? 2 : 1;
  const ciudad = idPais === 2 ? 'Bogotá' : 'Lima';

  db.query('INSERT INTO Direccion (idPais, ciudad, direccionTexto) VALUES (?, ?, ?)', [idPais, ciudad, origen], (err, resO) => {
    if (err) return res.status(500).json({ error: err.message });

    db.query('INSERT INTO Direccion (idPais, ciudad, direccionTexto) VALUES (?, ?, ?)', [idPais, ciudad, destino], (err, resD) => {
      if (err) return res.status(500).json({ error: err.message });

      const sqlV = `INSERT INTO Viaje (idPasajero, idEmpresa, idDireccionOrigen, idDireccionDestino, distancia, tarifa, esCorporativo)
                    VALUES (?, ?, ?, ?, ?, ?, ?)`;
      db.query(sqlV, [id_pasajero, es_corporativo ? id_empresa : null, resO.insertId, resD.insertId, distancia, tarifa, es_corporativo ? 1 : 0], (err, resV) => {
        if (err) return res.status(500).json({ error: err.message });

        db.query("INSERT INTO HistoriaEstadoViaje (idViaje, estado) VALUES (?, 'Solicitado')", [resV.insertId], (err) => {
          if (err) return res.status(500).json({ error: err.message });
          res.json({ mensaje: 'Viaje solicitado', id_viaje: resV.insertId });
        });
      });
    });
  });
});

// 4. Obtener métodos de pago del pasajero
app.get('/api/pasajeros/:id/metodos-pago', (req, res) => {
  db.query('SELECT idMetodoPago, tipoPago, predeterminado FROM MetodoPago WHERE idPasajero = ?', [req.params.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// 5. Registrar pago real de un viaje finalizado en la tabla Pago
app.post('/api/pagos', (req, res) => {
  const { id_viaje, id_metodo_pago, moneda, monto } = req.body;
  const idMoneda = moneda === 'COP' ? 2 : 1;
  const comision = (parseFloat(monto) * 0.15).toFixed(2);

  const sql = `INSERT INTO Pago (idViaje, idMetodoPago, idMoneda, monto, estado, comisionPlataforma)
               VALUES (?, ?, ?, ?, 'Pagado', ?)`;
  db.query(sql, [id_viaje, id_metodo_pago, idMoneda, monto, comision], (err) => {
    if (err) return res.status(400).json({ error: 'Este viaje ya fue pagado o hubo un error.' });
    res.json({ mensaje: 'Pago confirmado y registrado en MySQL' });
  });
});

// 6. Historial de viajes del pasajero (incluye estado de pago y calificación)
app.get('/api/viajes/pasajero/:id', (req, res) => {
  const sql = `
    SELECT v.idViaje AS id_viaje, d1.direccionTexto AS origen, d2.direccionTexto AS destino,
           v.tarifa, m.simbolo AS moneda, v.esCorporativo AS es_corporativo,
           LOWER((SELECT h.estado FROM HistoriaEstadoViaje h WHERE h.idViaje = v.idViaje ORDER BY h.idHistorialViaje DESC LIMIT 1)) AS estado,
           (SELECT pg.estado FROM Pago pg WHERE pg.idViaje = v.idViaje LIMIT 1) AS estado_pago,
           (SELECT c.calificacion FROM Calificacion c WHERE c.idViaje = v.idViaje AND c.emisor = 'PASAJERO' LIMIT 1) AS calificacion
    FROM Viaje v
    JOIN Direccion d1 ON v.idDireccionOrigen = d1.idDireccion
    JOIN Direccion d2 ON v.idDireccionDestino = d2.idDireccion
    JOIN Pais pa ON d1.idPais = pa.idPais
    JOIN Moneda m ON pa.idMoneda = m.idMoneda
    WHERE v.idPasajero = ?
    ORDER BY v.idViaje DESC`;

  db.query(sql, [req.params.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// 7. Calificar viaje (soporta PASAJERO y CONDUCTOR)
app.post('/api/viajes/:id/calificar', (req, res) => {
  const { puntaje, emisor } = req.body;
  const rolEmisor = emisor === 'CONDUCTOR' ? 'CONDUCTOR' : 'PASAJERO';
  const sql = `INSERT INTO Calificacion (idViaje, calificacion, comentario, emisor) VALUES (?, ?, 'Calificado en app', ?)`;

  db.query(sql, [req.params.id, puntaje, rolEmisor], (err) => {
    if (err) return res.status(400).json({ error: 'Ya calificaste este viaje.' });
    res.json({ mensaje: 'Calificación registrada' });
  });
});

// 8. Viajes solicitados disponibles para conductores
app.get('/api/viajes/pendientes', (req, res) => {
  const sql = `
    SELECT v.idViaje AS id_viaje, CONCAT(p.nombre, ' ', p.apellido1) AS nombre_pasajero,
           d1.direccionTexto AS origen, d2.direccionTexto AS destino, v.tarifa, m.simbolo AS moneda
    FROM Viaje v
    JOIN Pasajero p ON v.idPasajero = p.idPasajero
    JOIN Direccion d1 ON v.idDireccionOrigen = d1.idDireccion
    JOIN Direccion d2 ON v.idDireccionDestino = d2.idDireccion
    JOIN Pais pa ON d1.idPais = pa.idPais
    JOIN Moneda m ON pa.idMoneda = m.idMoneda
    WHERE (SELECT h.estado FROM HistoriaEstadoViaje h WHERE h.idViaje = v.idViaje ORDER BY h.idHistorialViaje DESC LIMIT 1) = 'Solicitado'
    ORDER BY v.idViaje DESC`;

  db.query(sql, (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// 9. Viajes asignados al conductor (incluye si ya calificó al pasajero)
app.get('/api/viajes/conductor/:id', (req, res) => {
  const sql = `
    SELECT v.idViaje AS id_viaje, CONCAT(p.nombre, ' ', p.apellido1) AS nombre_pasajero,
           d1.direccionTexto AS origen, d2.direccionTexto AS destino, v.tarifa, m.simbolo AS moneda,
           LOWER((SELECT h.estado FROM HistoriaEstadoViaje h WHERE h.idViaje = v.idViaje ORDER BY h.idHistorialViaje DESC LIMIT 1)) AS estado,
           (SELECT c.calificacion FROM Calificacion c WHERE c.idViaje = v.idViaje AND c.emisor = 'CONDUCTOR' LIMIT 1) AS calificacion_conductor
    FROM Viaje v
    JOIN Pasajero p ON v.idPasajero = p.idPasajero
    JOIN Direccion d1 ON v.idDireccionOrigen = d1.idDireccion
    JOIN Direccion d2 ON v.idDireccionDestino = d2.idDireccion
    JOIN Pais pa ON d1.idPais = pa.idPais
    JOIN Moneda m ON pa.idMoneda = m.idMoneda
    WHERE v.idConductor = ?
    ORDER BY v.idViaje DESC`;

  db.query(sql, [req.params.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// 10. Cambiar estado del viaje (Aceptado -> En curso -> Finalizado)
app.put('/api/viajes/:id/estado', (req, res) => {
  const { nuevo_estado, id_conductor } = req.body;
  const estadoEnum = nuevo_estado.charAt(0).toUpperCase() + nuevo_estado.slice(1);

  const actualizar = (cb) => {
    if (estadoEnum === 'Aceptado' && id_conductor) {
      db.query('UPDATE Viaje SET idConductor = ? WHERE idViaje = ?', [id_conductor, req.params.id], cb);
    } else if (estadoEnum === 'En curso') {
      db.query('UPDATE Viaje SET fechaHoraInicio = NOW() WHERE idViaje = ?', [req.params.id], cb);
    } else if (estadoEnum === 'Finalizado') {
      db.query('UPDATE Viaje SET fechaHoraFin = NOW() WHERE idViaje = ?', [req.params.id], cb);
    } else {
      cb(null);
    }
  };

  actualizar((err) => {
    if (err) return res.status(500).json({ error: err.message });
    db.query('INSERT INTO HistoriaEstadoViaje (idViaje, estado) VALUES (?, ?)', [req.params.id, estadoEnum], (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ mensaje: `Estado actualizado a ${estadoEnum}` });
    });
  });
});

// 11. Reporte corporativo de empresa
app.get('/api/empresa/:id/consumo', (req, res) => {
  const sql = `
    SELECT v.idViaje AS id_viaje, CONCAT(p.nombre, ' ', p.apellido1) AS nombre_pasajero,
           d1.direccionTexto AS origen, d2.direccionTexto AS destino, v.tarifa, m.simbolo AS moneda,
           LOWER((SELECT h.estado FROM HistoriaEstadoViaje h WHERE h.idViaje = v.idViaje ORDER BY h.idHistorialViaje DESC LIMIT 1)) AS estado
    FROM Viaje v
    JOIN Pasajero p ON v.idPasajero = p.idPasajero
    JOIN Direccion d1 ON v.idDireccionOrigen = d1.idDireccion
    JOIN Direccion d2 ON v.idDireccionDestino = d2.idDireccion
    JOIN Pais pa ON d1.idPais = pa.idPais
    JOIN Moneda m ON pa.idMoneda = m.idMoneda
    WHERE v.esCorporativo = 1 AND v.idEmpresa = ?
    ORDER BY v.idViaje DESC`;

  db.query(sql, [req.params.id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    const total = rows.reduce((acc, v) => acc + parseFloat(v.tarifa), 0);
    res.json({ total_mensual: total.toFixed(2), viajes: rows });
  });
});

app.listen(3000, () => {
  console.log('Servidor RutaAndina activo en http://localhost:3000');
});