CREATE DATABASE IF NOT EXISTS biblioteca_digital CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE biblioteca_digital;

CREATE TABLE usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL, -- Almacena hash cifrado
    tipousuario ENUM('Estudiante', 'Bibliotecario', 'Administrador') NOT NULL,
    intentos_fallidos INT DEFAULT 0,
    bloqueado TINYINT(1) DEFAULT 0
);

CREATE TABLE estudiante (
    idUsuario INT PRIMARY KEY,
    carrera VARCHAR(100) NOT NULL,
    matricula VARCHAR(30) UNIQUE NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario) ON DELETE CASCADE
);

CREATE TABLE bibliotecario (
    idUsuario INT PRIMARY KEY,
    numero_empleado INT UNIQUE NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario) ON DELETE CASCADE
);

CREATE TABLE administrador (
    idUsuario INT PRIMARY KEY,
    nivelAcceso INT DEFAULT 1,
    FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario) ON DELETE CASCADE
);

CREATE TABLE libromaterial (
    id_libromaterial INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    estado_disponibilidad ENUM('Disponible', 'Reservado', 'Prestado') DEFAULT 'Disponible'
);

CREATE TABLE prestamo (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_bibliotecario INT NULL,
    id_libromaterial INT NOT NULL,
    fecha_solicitud DATE NOT NULL,
    fecha_devolucion DATE NULL,
    estado ENUM('Pendiente', 'Aprobado', 'Devuelto', 'Rechazado') DEFAULT 'Pendiente',
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(idUsuario),
    FOREIGN KEY (id_bibliotecario) REFERENCES bibliotecario(idUsuario),
    FOREIGN KEY (id_libromaterial) REFERENCES libromaterial(id_libromaterial)
);

CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_libromaterial INT NOT NULL,
    fecha_reserva DATE NOT NULL,
    estado_reserva ENUM('Activa', 'Confirmada', 'Cancelada') DEFAULT 'Activa',
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(idUsuario),
    FOREIGN KEY (id_libromaterial) REFERENCES libromaterial(id_libromaterial)
);

CREATE TABLE reporte (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_bibliotecario INT NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_generacion DATE NOT NULL,
    tipo_reporte ENUM('Atraso', 'Maltrato Material', 'Uso') NOT NULL,
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(idUsuario),
    FOREIGN KEY (id_bibliotecario) REFERENCES bibliotecario(idUsuario)
);

CREATE TABLE notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    mensaje VARCHAR(255) NOT NULL,
    fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(idUsuario)
);