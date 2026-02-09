-- CREAR BASE DE DATOS
CREATE DATABASE PortalActividadesDB;
GO

USE PortalActividadesDB;
GO

-- TABLA CATEGORIAS
CREATE TABLE Categories (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Active BIT DEFAULT 1
);
GO

-- TABLA FACULTADES
CREATE TABLE Faculties (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);
GO

-- TABLA CARRERAS
CREATE TABLE Careers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);
GO

-- TABLA USUARIOS
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20),
    Password NVARCHAR(255),
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Admin', 'Organizador', 'Estudiante')),
    Active BIT DEFAULT 1,
    PhotoUrl NVARCHAR(500)
);
GO

-- TABLA ORGANIZADORES
CREATE TABLE Organizers (
    UserId INT PRIMARY KEY,
    Department NVARCHAR(50),
    Position NVARCHAR(50),
    Bio NVARCHAR(500),
    Shifts NVARCHAR(200),
    WorkDays NVARCHAR(200),
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
);
GO

-- TABLA ESTUDIANTES
CREATE TABLE Students (
    UserId INT PRIMARY KEY,
    CareerId INT,
    Semester INT,
    Modality NVARCHAR(20) CHECK (Modality IN ('Presencial', 'Híbrida', 'Virtual')),
    Schedule NVARCHAR(20) CHECK (Schedule IN ('Matutina', 'Vespertina', 'Nocturna')),
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (CareerId) REFERENCES Careers(Id)
);
GO

-- TABLA ACTIVIDADES
CREATE TABLE Activities (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    CategoryId INT NOT NULL,
    OrganizerId INT NOT NULL,
    Date DATE NOT NULL,
    RegistrationDeadline DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Location NVARCHAR(100) NOT NULL,
    Capacity INT NOT NULL,
    Description NVARCHAR(MAX),
    PhotoUrl NVARCHAR(500),
    Active BIT DEFAULT 1,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    FOREIGN KEY (OrganizerId) REFERENCES Users(Id)
);
GO

-- TABLA INSCRIPCIONES
CREATE TABLE Enrollments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ActivityId INT NOT NULL,
    StudentId INT NOT NULL,
    EnrollmentDate DATE NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Inscrito', 'Cancelado')),
    Note NVARCHAR(500),
    FOREIGN KEY (ActivityId) REFERENCES Activities(Id),
    FOREIGN KEY (StudentId) REFERENCES Users(Id),
    UNIQUE (ActivityId, StudentId)
);
GO

-- TABLA CALIFICACIONES
CREATE TABLE Ratings (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ActivityId INT NOT NULL,
    StudentId INT NOT NULL,
    Stars INT NOT NULL CHECK (Stars >= 1 AND Stars <= 5),
    Comment NVARCHAR(MAX) NOT NULL,
    RatingDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ActivityId) REFERENCES Activities(Id),
    FOREIGN KEY (StudentId) REFERENCES Users(Id)
);
GO

-- INSERTAR CATEGORÍAS
INSERT INTO Categories (Name, Active) VALUES
('Cultura', 1),
('Deporte', 1),
('Bienestar', 1),
('Arte', 1),
('Música', 1),
('Tecnología', 1),
('Ciencia', 1);
GO

-- INSERTAR FACULTADES
INSERT INTO Faculties (Name) VALUES
('CIENCIAS ADMINISTRATIVAS'),
('CIENCIAS MÉDICAS'),
('INGENIERÍA INDUSTRIAL'),
('FILOSOFÍA, LETRAS Y CIENCIAS DE LA EDUCACIÓN'),
('ARQUITECTURA Y URBANISMO'),
('CIENCIAS AGRARIAS'),
('CIENCIAS ECONÓMICAS'),
('CIENCIAS MATEMÁTICAS Y FÍSICAS'),
('JURISPRUDENCIA, CIENCIAS SOCIALES Y POLÍTICAS'),
('CIENCIAS NATURALES'),
('MEDICINA VETERINARIA'),
('CIENCIAS PARA EL DESARROLLO'),
('CIENCIAS PSICOLÓGICAS'),
('CIENCIAS QUÍMICAS'),
('COMUNICACIÓN SOCIAL'),
('EDUCACIÓN FÍSICA, DEPORTES Y RECREACIÓN'),
('INGENIERÍA QUÍMICA'),
('ODONTOLOGÍA');
GO

-- INSERTAR CARRERAS
INSERT INTO Careers (Name, FacultyId) VALUES
('ADMINISTRACIÓN DE EMPRESAS', 1),
('COMERCIO EXTERIOR', 1),
('MERCADOTECNIA', 1),
('CONTABILIDAD Y AUDITORÍA', 1),
('FINANZAS', 1),
('GESTIÓN DE LA INFORMACIÓN GERENCIAL', 1),
('NEGOCIOS INTERNACIONALES', 1),
('TURISMO', 1),
('MEDICINA', 2),
('ENFERMERÍA', 2),
('FONOAUDIOLOGÍA', 2),
('NUTRICIÓN Y DIETÉTICA', 2),
('OBSTETRICIA', 2),
('TERAPIA OCUPACIONAL', 2),
('INGENIERÍA INDUSTRIAL', 3),
('INGENIERÍA DE LA PRODUCCIÓN', 3),
('INGENIERÍA EN TELEMÁTICA', 3),
('PEDAGOGÍA DE LA HISTORIA Y CIENCIAS SOCIALES', 4),
('EDUCACIÓN BÁSICA', 4),
('EDUCACIÓN INICIAL', 4),
('PEDAGOGÍA DE LAS CIENCIAS EXPERIMENTALES EN INFORMÁTICA', 4),
('PEDAGOGÍA DE LOS IDIOMAS NACIONALES Y EXTRANJEROS', 4),
('PEDAGOGÍA DE LA LENGUA Y LITERATURA', 4),
('PEDAGOGÍA DE LAS CIENCIAS EXPERIMENTALES EN QUÍMICA Y BIOLOGÍA', 4),
('PEDAGOGÍA DE LAS CIENCIAS EXPERIMENTALES EN MATEMÁTICAS Y FÍSICA', 4),
('ARQUITECTURA', 5),
('DISEÑO DE INTERIORES', 5),
('INGENIERÍA AGRÓNOMA', 6),
('ECONOMÍA', 7),
('INGENIERÍA CIVIL', 8),
('INGENIERÍA EN SOFTWARE', 8),
('INGENIERÍA EN TECNOLOGÍAS DE LA INFORMACIÓN', 8),
('DERECHO', 9),
('ODONTOLOGÍA', 18),
('BIOLOGÍA', 10),
('INGENIERÍA AMBIENTAL', 10),
('INGENIERÍA GEOLÓGICA', 10),
('MEDICINA VETERINARIA', 11),
('INGENIERÍA AGRONÓMICA', 12),
('INGENIERÍA AGROPECUARIA', 12),
('MEDICINA VETERINARIA Y ZOOTECNIA', 12),
('PSICOLOGÍA', 13),
('BIOQUÍMICO FARMACÉUTICO', 14),
('DISEÑO GRÁFICO', 15),
('COMUNICACIÓN', 15),
('PUBLICIDAD', 15),
('PEDAGOGÍA DE LA ACTIVIDAD FÍSICA Y EL DEPORTE', 16),
('INGENIERÍA QUÍMICA', 17),
('INGENIERÍA DE LA PRODUCCIÓN', 17);
GO

-- INSERTAR USUARIOS
INSERT INTO Users (Name, Email, Phone, Password, Role, Active, PhotoUrl) VALUES
('Administrador Principal', 'admin.master@uni.edu', '+593900000001', '$2b$10$Zmv83P4xdxzj0EF1H3S17uBNXtBDeJgZ8NpNyBZdQPJBveHAcD1/i', 'Admin', 1, NULL),
('Soporte Tecnico', 'admin.support@uni.edu', '+593900000002', '$2b$10$YJdhmFzqB6QSFWHH9vUHbeYBf/lHnJ78WwXV10/Ub5csqY9Yjgxji', 'Admin', 1, NULL),

('Maria Gonzalez', 'maria.gonzalez@uni.edu', '+593987654321', '$2b$10$W.yErS79CNUywAW76PhfqOd9DQb7zj8izvtPMLlSOMKRmYSoVIrBy', 'Organizador', 1, NULL),
('Carlos Perez', 'carlos.perez@uni.edu', '+593987222111', '$2b$10$Og4cjoQ.h2ulwjfCMNGo2.LhhzlaC91j.kRaL73NShnWIzbZ4Xi8e', 'Organizador', 1, NULL),
('Daniela Ruiz', 'daniela.ruiz@uni.edu', '+593981111222', '$2b$10$EOd3zJPIV2i31dmFlrzRvOXKvsAFKfBl6QwPEVyDwbcfugVY9WFYS', 'Organizador', 1, NULL),
('Jorge Alvarez', 'jorge.alvarez@uni.edu', '+593984444555', '$2b$10$HGLYamYQSixwUl21Lxo7huIY5NsipWB27lDfCNMLTcha9.W6PjhDe', 'Organizador', 1, NULL),
('Lucia Herrera', 'lucia.herrera@uni.edu', '+593983333444', '$2b$10$AN8A1Dd2M0z9poap2vZJ5eobWtFYu4KV7bSlUCoxlHWkXgbyiimku', 'Organizador', 1, NULL),
('Pedro Medina', 'pedro.medina@uni.edu', '+593989898989', '$2b$10$WYTR8WFIpr1B5wbMefRcBeStJ5..VihDuLwij3u10X8w2wgyoRTNi', 'Organizador', 1, NULL),
('Ana Villamar', 'ana.villamar@uni.edu', '+593981223344', '$2b$10$Vjbkf2lF45XFmtViBwr/PORExICJKXNvyrIGAuJBbwd4qCiHnAKZW', 'Organizador', 1, NULL),
('Ricardo Salinas', 'ricardo.salinas@uni.edu', '+593989999000', '$2b$10$bnGyDmNnob1c8lXjAglrreZCiiMuJq00gZyymiVcC9fc/4i3oaEGW', 'Organizador', 1, NULL),
('Sofia Torres', 'sofia.torres@uni.edu', '+593981010101', '$2b$10$cBZ2C1BF5TAis25XdC8eQOVQigaLLhCCoMHKTPv5DSFVaP1tz57va', 'Organizador', 1, NULL),
('Mario Castillo', 'mario.castillo@uni.edu', '+593982222333', '$2b$10$eEtKbzjpE.c62Fm.0h9JZemYCNO3lkxlsM.090MlCH77GUGnZLbGa', 'Organizador', 1, NULL),

('Ana Perez', 'ana.perez@uni.edu', '+593987654321', '$2b$10$x.hHRbj6tQ0Jo8C2uvVh3e1wr3bwNDZFrVe/1xdURT2SgtdZaDGTK', 'Estudiante', 1, NULL),
('Luis Gomez', 'luis.gomez@uni.edu', '+593998877665', '$2b$10$BdJGcttgVjuRbKegpuCjCul895iCbwajD0xz.Baj350RaqilA1sdC', 'Estudiante', 1, NULL),
('Carla Sanchez', 'carla.sanchez@uni.edu', '+593987112233', '$2b$10$Z94tFJ5GSdKOn3xSfW3Ixu.wK/CK25zb1KePuwiYOxrbyhxnPSQ0q', 'Estudiante', 1, NULL),
('Juan Torres', 'juan.torres@uni.edu', '+593987221144', '$2b$10$KH91tStfVKd1ELUUDARSk.Bh8m5PyvNHZdrKAbLQcN/DCYBZE.H5W', 'Estudiante', 1, NULL),
('Maria Lopez', 'maria.lopez@uni.edu', '+593987334455', '$2b$10$ThnBvBdUAAaWqsyC3ZdMtuUGuE3LkdgVfCPOZMoV5CM3N6oPWVPhS', 'Estudiante', 1, NULL),
('Diego Castillo', 'diego.castillo@uni.edu', '+593999887766', '$2b$10$/UnDsuA08Xwi7jlopcJFG.nW/Rv5Ek1rKmjIHGzd1dlqrXRIc0yEW', 'Estudiante', 1, NULL),
('Sofia Morales', 'sofia.morales@uni.educ', '+593987445566', '$2b$10$BA8ElHuT0piPfJhzgPzN/uhUDLmbf7z316J7zGOvsB7gBlfOfCRFK', 'Estudiante', 1, NULL),
('Carlos Fernandez', 'carlos.fernandez@uni.edu', '+593987556677', '$2b$10$cdDit4ognP1aZ5PN8XkzRuo6dhVyI8.55DdkW504le1258NUkCE22', 'Estudiante', 1, NULL),
('Valentina Ruiz', 'valentina.ruiz@uni.edu', '+593988776655', '$2b$10$im/rVTKsvhAA36j9zIh3h.MpylJn6npyVaGvlBBznhEpPmsHq8ZXS', 'Estudiante', 1, NULL),
('Miguel Herrera', 'miguel.herrera@uni.edu', '+593987667788', '$2b$10$hOS4Dv8VakTVDW3BfsnnueAhcVCtuKlIwJ0m/p/lYDJZkLWKvWpfa', 'Estudiante', 1, NULL),

('Laura Mendez', 'laura.mendez@uni.edu', '+593987123456', '$2b$10$Gb8eqi7R86OVGkQm7w3dwu.wRmk/aZKsL33iuDczHsw7AoYyCTnga', 'Organizador', 1, NULL),
('Roberto Silva', 'roberto.silva@uni.edu', '+593987234567', '$2b$10$U1k7nSm3eI6E7j0lXvrMm.9FcnqfGluQ2y3Ma4VbMgprmJ7HwdNYa', 'Organizador', 1, NULL),
('Patricia Castro', 'patricia.castro@uni.edu', '+593987345678', '$2b$10$TtDIMGqtmfpD.5KJNT2lWeroKaRrJHaIlzBC9HS10E8zMJCxMyTlC', 'Organizador', 1, NULL),
('Fernando Ortega', 'fernando.ortega@uni.edu', '+593987456789', '$2b$10$50XUTo0trFj8qdp1BTgdBuNdkTqDPbOzlDHUiC/JH4m0PNW08UF9.', 'Organizador', 1, NULL),

('Andrea Vasquez', 'andrea.vasquez@uni.edu', '+593987567890', '$2b$10$8q2qsNm3DR1mTKlD6jA/meTLLbkVFQNk0I2KXZuLbcNDchcWFR/tu', 'Estudiante', 1, NULL),
('Javier Ramirez', 'javier.ramirez@uni.edu', '+593987678901', '$2b$10$LuFcd2xAkRifs57B4xGcHeuCdRy6fQwkYeQOqEJYCRyN1AwNmqpGa', 'Estudiante', 1, NULL),
('Gabriela Flores', 'gabriela.flores@uni.edu', '+593987789012', '$2b$10$.KLXpO/6okIo8SxhT5VA8uPmD5jfgWcgDpRG7HYoh9DuF46buaIH.', 'Estudiante', 1, NULL),
('Eduardo Mendoza', 'eduardo.mendoza@uni.edu', '+593987890123', '$2b$10$ETyKy3jUabIm53eKkID2UufxYt3sJIA39mcqdPXgdn13E6M5jMwyW', 'Estudiante', 1, NULL),
('Camila Reyes', 'camila.reyes@uni.edu', '+593987901234', '$2b$10$KTRR.8DGtR6N5kZt6rSWx.3ZXl/8PgI4pHsQgxU8RPuPdUaDqk4c.', 'Estudiante', 1, NULL),
('Sebastian Cruz', 'sebastian.cruz@uni.edu', '+593987012345', '$2b$10$Ab2BnXU53L1pzAFz894xsuMqoQviLjmXOvv0ddmuaffYIeyP2AD6C', 'Estudiante', 1, NULL),
('Isabela Torres', 'isabela.torres@uni.edu', '+593987123456', '$2b$10$5yWaHqeflQQz4b1drvz2sObT1dBtUQG39d07dkT3hTY8NrLoF8Un2', 'Estudiante', 1, NULL),
('David Paredes', 'david.paredes@uni.edu', '+593987234567', '$2b$10$6Lc.VkP1/7gYRyOznClyEeWHX.BBfvnGWD8L/USxYa57QHL1c8hBK', 'Estudiante', 1, NULL),
('Natalia Guzman', 'natalia.guzman@uni.edu', '+593987345678', '$2b$10$omY6AqHywrgcwq4PbvMRXeLySxBqJDfPngwgjptWeX5Vx5kFLVHpu', 'Estudiante', 1, NULL),
('Andres Salazar', 'andres.salazar@uni.edu', '+593987456789', '$2b$10$U97iSvtMbNCCkNCXF3pd3uf9hdMvyRVd1OM7tOJdQqSwnsOSl.D.e', 'Estudiante', 1, NULL);

-- INSERTAR ORGANIZADORES
INSERT INTO Organizers (UserId, Department, Position, Bio, Shifts, WorkDays) VALUES
(3, 'Cultura', 'Coordinadora', 'Apasionada por actividades artísticas.', 'Mañana,Tarde', 'Lunes,Martes,Miércoles,Jueves,Viernes,Sábado,Domingo'),
(4, 'Deportes', 'Entrenador', 'Instructor con experiencia en preparación física.', 'Tarde', 'Miércoles,Viernes'),
(5, 'Bienestar', 'Facilitadora', 'Especialista en meditación y bienestar.', 'Mañana,Tarde', 'Martes,Jueves'),
(6, 'Arte', 'Instructor de Teatro', 'Actor profesional.', 'Noche', 'Viernes,Sábado'),
(7, 'Danza', 'Coreógrafa', 'Experta en danza contemporánea.', 'Mañana', 'Lunes,Miércoles'),
(8, 'Deportes', 'Instructor de Fútbol', 'Entrenador certificado.', 'Tarde', 'Martes,Jueves'),
(9, 'Bienestar', 'Psicóloga', 'Especialista en bienestar emocional.', 'Mañana', 'Miércoles,Viernes'),
(10, 'Música', 'Instructor de Música', 'Músico profesional.', 'Tarde', 'Lunes,Miércoles'),
(11, 'Danza', 'Instructora de Ballet', 'Bailarina profesional.', 'Noche', 'Martes,Viernes'),
(12, 'Deportes', 'Entrenador de Natación', 'Instructor con experiencia.', 'Mañana', 'Lunes,Jueves'),
(23, 'Tecnología', 'Coordinador TI', 'Especialista en tecnologías educativas y plataformas digitales.', 'Mañana,Tarde', 'Lunes,Martes,Miércoles,Jueves,Viernes'),
(24, 'Arte', 'Profesor de Pintura', 'Artista plástico con 10 años de experiencia en enseñanza.', 'Tarde', 'Martes,Jueves,Sábado'),
(25, 'Música', 'Directora de Coro', 'Directora coral con experiencia en orquestación.', 'Noche', 'Miércoles,Viernes'),
(26, 'Deportes', 'Entrenador de Voleibol', 'Ex jugador profesional de voleibol.', 'Tarde', 'Lunes,Miércoles,Viernes');
GO

-- INSERTAR ESTUDIANTES
INSERT INTO Students (UserId, CareerId, Semester, Modality, Schedule) VALUES
(13, 9, 4, 'Presencial', 'Matutina'),
(14, 15, 4, 'Híbrida', 'Vespertina'),
(15, 31, 3, 'Virtual', 'Nocturna'),
(16, 39, 5, 'Presencial', 'Matutina'),
(17, 27, 3, 'Virtual', 'Nocturna'),
(18, 6, 4, 'Presencial', 'Vespertina'),
(19, 4, 2, 'Híbrida', 'Matutina'),
(20, 1, 1, 'Presencial', 'Vespertina'),
(21, 7, 4, 'Virtual', 'Nocturna'),
(22, 5, 2, 'Presencial', 'Matutina'),
(27, 18, 2, 'Presencial', 'Matutina'),
(28, 32, 5, 'Híbrida', 'Vespertina'),
(29, 45, 3, 'Virtual', 'Nocturna'),
(30, 10, 4, 'Presencial', 'Matutina'),
(31, 34, 6, 'Presencial', 'Vespertina'),
(32, 47, 2, 'Virtual', 'Nocturna'),
(33, 40, 5, 'Híbrida', 'Matutina'),
(34, 25, 3, 'Presencial', 'Vespertina'),
(35, 12, 4, 'Presencial', 'Matutina'),
(36, 36, 2, 'Híbrida', 'Vespertina');    
GO

-- INSERTAR ACTIVIDADES
INSERT INTO Activities (Title, CategoryId, OrganizerId, Date, RegistrationDeadline, StartTime, EndTime, Location, Capacity, Description, PhotoUrl, Active) VALUES
('Taller de Fotografía Básica', 1, 3, '2026-02-05', '2026-02-04', '10:00', '12:00', 'Sala A1', 50, 'Aprende fotografía básica, composición, manejo de luz y edición digital. Taller intensivo para principiantes.', 'https://th.bing.com/th/id/R.25f51885e72010543fa8216e0a97df88?rik=7SwmZyjwgO%2bZSg&riu=http%3a%2f%2fwww.dzoom.org.es%2fwp-content%2fuploads%2f2012%2f12%2fqcam.jpg&ehk=NcD7RVxl9NgiRad5BQWq3UP%2fAlkZoMVyISMour6Ha4M%3d&risl=&pid=ImgRaw&r=0', 1),
('Torneo de Fútbol Interfacultades', 2, 4, '2026-02-08', '2026-02-06', '14:00', '18:00', 'Cancha Principal', 16, 'Torneo interfacultades de fútbol 7. ¡Inscribe tu equipo!', 'https://tse1.mm.bing.net/th/id/OIP.nGLSwvgJMNmrDRBQAmcEcAHaD4?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Clase de Yoga para Principiantes', 3, 5, '2026-02-10', '2026-02-09', '08:30', '10:00', 'Sala Zen', 40, 'Sesión de Hatha Yoga para todos los niveles.', 'https://www.boomlive.in/wp-content/uploads/2014/08/sunset_yoga.jpg', 1),
('Taller de Pintura al Óleo', 4, 6, '2026-02-12', '2026-02-11', '13:00', '16:00', 'Sala B1', 20, 'Introducción y práctica de la pintura al óleo. Materiales incluidos.', 'https://i1.wp.com/www.sonria.com/wp-content/uploads/2016/05/pintura2.jpg?resize=1080%2C675', 1),
('Carrera 5K Saludable', 2, 4, '2026-02-20', '2026-02-18', '07:00', '09:00', 'Pista Atlética', 200, 'Carrera de 5 kilómetros para promover hábitos saludables.', 'https://th.bing.com/th/id/R.a2df894bc8dee10a400bb386006c34e3?rik=G8wg9Pm3SyH7tw&riu=http%3a%2f%2fadex5k.adexperu.edu.pe%2f_astro%2fsection1_bg.81e84748.png&ehk=lcOGzeTPH%2brI8sEVzOC6PG7EEAMP%2fthCMDbeddeoVsM%3d&risl=&pid=ImgRaw&r=0', 1),
('Taller de Danza Contemporánea', 1, 7, '2026-02-25', '2026-02-23', '15:00', '17:00', 'Estudio 3', 30, 'Exploración de los fundamentos de la danza contemporánea.', 'https://tse4.mm.bing.net/th/id/OIP.Q2O6lAIl8ep07jOstWimSQHaE8?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Concierto Acústico Universitario', 5, 10, '2026-02-28', '2026-02-26', '18:00', '20:00', 'Auditorio Central', 120, 'Noche de música acústica con talento universitario.', 'https://tse2.mm.bing.net/th/id/OIP.LijxDjdzwrHNEiokYhaNEgHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Meditación Mindfulness', 3, 5, '2026-03-05', '2026-03-04', '09:30', '10:30', 'Sala Zen', 35, 'Sesión guiada de meditación mindfulness para reducir estrés.', 'https://tse1.mm.bing.net/th/id/OIP.e5J8Kohl8SOQZwQdeZP0XAHaEi?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Torneo de Baloncesto 3x3', 2, 4, '2026-03-12', '2026-03-10', '15:00', '18:00', 'Coliseo Deportivo', 40, 'Competencia rápida 3x3 de baloncesto.', 'https://wallpapers.com/images/featured/imagenes-de-baloncesto-ofuozdpxcugrqz1l.jpg', 1),
('Sesión de Calistenia Avanzada', 2, 8, '2026-03-18', '2026-03-16', '08:00', '09:00', 'Parque Norte', 50, 'Entrenamiento funcional usando peso corporal.', 'https://tse2.mm.bing.net/th/id/OIP.qUor2O248b4-qyZbwW09CQHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Círculo de Lectura: Literatura Latinoamericana', 1, 3, '2026-03-22', '2026-03-20', '10:00', '11:30', 'Biblioteca Central', 33, 'Conversatorio sobre autores latinoamericanos contemporáneos.', 'https://img.genial.ly/61860d099a6bcf00127f980f/83c0f9ae-5b78-47b4-b399-b16942de0ee6.png', 1),
('Taller de Respiración Consciente', 3, 5, '2026-04-02', '2026-03-31', '11:00', '12:00', 'Sala Calm', 25, 'Técnicas de respiración para gestión de ansiedad.', 'https://tse4.mm.bing.net/th/id/OIP.gXrQFpffr4mDrGiI6m7voAHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Taller de Acuarela Avanzada', 4, 6, '2026-04-10', '2026-04-08', '14:00', '16:00', 'Sala A1', 15, 'Exploración de técnicas avanzadas de acuarela.', 'https://tse2.mm.bing.net/th/id/OIP.PB4m8mpnMoP8p5bHZifCgwHaEr?cb=ucfimg2&ucfimg=1&w=1024&h=647&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Torneo de Ajedrez Universitario', 7, 3, '2026-05-08', '2026-05-06', '09:00', '13:00', 'Sala Multiusos', 68, 'Torneo oficial de ajedrez rápido (Blitz).', 'https://tse2.mm.bing.net/th/id/OIP.hop24G50eMGUc3Vq7mutNAHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Taller de Técnicas Vocales', 5, 10, '2026-05-15', '2026-05-13', '15:00', '17:00', 'Sala Acústica', 30, 'Taller de proyección, resonancia y técnica vocal.', 'https://tse3.mm.bing.net/th/id/OIP.r36bG7M14c4OFVSjNcUl6AHaDt?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Clase de Pilates Suave', 3, 5, '2026-05-20', '2026-05-18', '09:00', '10:00', 'Sala Zen', 30, 'Sesión de Pilates de bajo impacto para fortalecimiento.', 'https://tse4.mm.bing.net/th/id/OIP.oKeNokswvieznW9BKp-mugHaEo?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Noche de Cine: Cine Latinoamericano', 1, 3, '2026-05-25', '2026-05-23', '18:30', '21:00', 'Auditorio C4', 155, 'Proyección de película latinoamericana con debate.', 'https://th.bing.com/th/id/R.069cd14c746b6ab459beb0f97d40c1d3?rik=AISRJOyqFlLiyw&riu=http%3a%2f%2f2.bp.blogspot.com%2f-g5rKFgFBbCE%2fU7TZOBbpj3I%2fAAAAAAAAAC4%2fMpOiPHT_jz8%2fs1600%2fcine.jpg&ehk=AvcDUDXzRsLg%2bEy8vefuOSkckFFhnRyWLeMWaQB7jfE%3d&risl=&pid=ImgRaw&r=0', 1),
('Clase de Baile Fitness', 2, 4, '2026-06-05', '2026-06-03', '16:00', '18:00', 'Coliseo Deportivo', 80, 'Sesión intensa de cardio con ritmos latinos.', 'https://tse4.mm.bing.net/th/id/OIP.nV-0GYTyzlBw1FWWtxPMHAHaEa?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Taller de Escritura Creativa', 1, 3, '2026-06-12', '2026-06-10', '10:00', '12:00', 'Sala Letras', 20, 'Taller para mejorar estilo de escritura y desarrollar narrativas.', 'https://tse3.mm.bing.net/th/id/OIP.htC6AiXku32_ovvH6OivBgHaEK?cb=ucfimg2&ucfimg=1&w=1280&h=720&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Feria Universitaria de Bienestar', 3, 5, '2026-06-20', '2026-06-18', '09:00', '14:00', 'Plazoleta Central', 500, 'Evento con charlas sobre nutrición, salud mental y stands.', 'https://tse2.mm.bing.net/th/id/OIP.Fi5i0siPOY0wFrOIcjotNgHaDU?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Taller de Programación Python', 6, 23, '2026-07-10', '2026-07-08', '14:00', '17:00', 'Laboratorio 5', 25, 'Introducción a Python para estudiantes sin experiencia previa.', 'https://tse2.mm.bing.net/th/id/OIP.fWUCFV7uWmfd6c7ZzmNhNwHaE8?w=1280&h=854&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Exposición de Arte Moderno', 4, 24, '2026-07-15', '2026-07-14', '10:00', '18:00', 'Galería Central', 100, 'Exposición de obras de estudiantes de arte y artistas locales.', 'https://tse4.mm.bing.net/th/id/OIP.H3m8Azy8uo4tM_yTc9-6owHaE7?w=800&h=533&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Concierto de Jazz Universitario', 5, 25, '2026-07-20', '2026-07-18', '19:00', '21:30', 'Auditorio Principal', 150, 'Noche de jazz con la banda universitaria y invitados especiales.', 'https://tse2.mm.bing.net/th/id/OIP.yx6mEkY1nBNzjCcwNSfsNwHaDt?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Torneo de Voleibol Mixto', 2, 26, '2026-07-25', '2026-07-23', '09:00', '13:00', 'Cancha Cubierta', 12, 'Torneo de voleibol mixto por equipos de 6 jugadores.', 'https://tse1.mm.bing.net/th/id/OIP.COE5AuXH3oXd_bDUShejvQHaE7?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Taller de Inteligencia Emocional', 3, 9, '2026-08-05', '2026-08-03', '15:00', '17:00', 'Sala 302', 30, 'Desarrollo de habilidades de inteligencia emocional para estudiantes.', 'https://tse4.mm.bing.net/th/id/OIP.yA-lrPp3hSPQrlQ8Z-jfSQHaD8?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Feria de Ciencias y Tecnología', 7, 23, '2026-08-12', '2026-08-10', '09:00', '16:00', 'Plaza de Ciencias', 300, 'Exposición de proyectos científicos y tecnológicos estudiantiles.', 'https://tse2.mm.bing.net/th/id/OIP.n6deM-ikXJJzd0_0G5oepAHaDg?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Maratón de Debate Académico', 1, 3, '2026-08-18', '2026-08-16', '08:00', '18:00', 'Aula Magna', 50, 'Competencia de debate sobre temas de actualidad académica.', 'https://tse1.mm.bing.net/th/id/OIP.QsjNJEIi9At6a9TZNof2-wHaER?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Clínica de Natación Avanzada', 2, 12, '2026-08-22', '2026-08-20', '07:00', '09:00', 'Piscina Olímpica', 20, 'Sesión de entrenamiento avanzado para nadadores experimentados.', 'https://tse3.mm.bing.net/th/id/OIP.ABHFbM8-e5Lh-lYC1zfnAQHaEK?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Taller de Fotografía Nocturna', 1, 3, '2026-09-05', '2026-09-03', '18:00', '21:00', 'Campus Central', 15, 'Técnicas especiales para fotografía en condiciones de baja luz.', 'https://tse4.mm.bing.net/th/id/OIP.wD6g2K-IsuI7iyQvO9r2LgHaE8?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Seminario de Emprendimiento', 6, 4, '2026-09-12', '2026-09-10', '10:00', '13:00', 'Sala de Conferencias', 80, 'Herramientas y estrategias para desarrollar proyectos emprendedores.', 'https://tse1.mm.bing.net/th/id/OIP.Usr5SC0zKxUFkJRfJh-rJgHaE8?rs=1&pid=ImgDetMain&o=7&rm=3', 1);
GO

-- INSERTAR INSCRIPCIONES
INSERT INTO Enrollments (ActivityId, StudentId, EnrollmentDate, Status, Note) VALUES
(1, 13, '2026-02-01', 'Inscrito', 'Estudiante muy interesado en fotografía.'),
(1, 14, '2026-02-02', 'Inscrito', 'Tiene cámara propia.'),
(1, 15, '2026-02-03', 'Inscrito', 'Solicitó material adicional.'),
(2, 14, '2026-02-05', 'Inscrito', 'Capitán del equipo de Medicina.'),
(2, 16, '2026-02-05', 'Inscrito', 'Jugador defensa.'),
(2, 18, '2026-02-06', 'Inscrito', 'Portero del equipo.'),
(3, 15, '2026-02-08', 'Inscrito', 'Primera vez en yoga.'),
(3, 17, '2026-02-09', 'Inscrito', 'Necesita colchoneta prestada.'),
(3, 19, '2026-02-09', 'Inscrito', 'Practicante intermedio.'),
(4, 16, '2026-02-10', 'Inscrito', 'Con experiencia en acuarela.'),
(4, 20, '2026-02-11', 'Inscrito', 'Principiante total.'),
(5, 13, '2026-02-15', 'Inscrito', 'Entrenando para la carrera.'),
(5, 15, '2026-02-16', 'Inscrito', 'Corredor habitual.'),
(8, 14, '2026-03-01', 'Inscrito', 'Interesado en meditación.'),
(9, 16, '2026-03-05', 'Inscrito', 'Jugador de baloncesto.'),
(10, 18, '2026-03-10', 'Inscrito', 'Busca mejorar condición física.'),
(12, 20, '2026-03-30', 'Inscrito', 'Necesita manejar ansiedad académica.'),
(5, 17, '2026-02-17', 'Cancelado', 'Lesión deportiva.'),
(21, 27, '2026-07-05', 'Inscrito', 'Interesado en programación'),
(21, 28, '2026-07-06', 'Inscrito', 'Estudiante de software'),
(21, 29, '2026-07-06', 'Inscrito', 'Quiere aprender Python'),
(22, 30, '2026-07-10', 'Inscrito', 'Amante del arte'),
(22, 31, '2026-07-11', 'Inscrito', 'Estudiante de derecho interesado en arte'),
(23, 32, '2026-07-15', 'Inscrito', 'Músico aficionado'),
(23, 33, '2026-07-16', 'Inscrito', 'Fan del jazz'),
(24, 34, '2026-07-20', 'Inscrito', 'Jugador de voleibol'),
(24, 35, '2026-07-21', 'Inscrito', 'Equipo mixto'),
(25, 36, '2026-08-01', 'Inscrito', 'Necesita mejorar habilidades sociales'),
(6, 27, '2026-02-20', 'Inscrito', 'Bailarina principiante'),
(7, 28, '2026-02-22', 'Inscrito', 'Músico guitarrista'),
(8, 29, '2026-03-02', 'Inscrito', 'Buscando reducir estrés'),
(9, 30, '2026-03-08', 'Inscrito', 'Jugador de baloncesto'),
(10, 31, '2026-03-15', 'Inscrito', 'Entrenamiento físico'),
(11, 32, '2026-03-18', 'Inscrito', 'Amante de la literatura'),
(12, 33, '2026-03-28', 'Inscrito', 'Problemas de ansiedad'),
(13, 34, '2026-04-05', 'Inscrito', 'Artista en formación'),
(14, 35, '2026-05-04', 'Inscrito', 'Jugador de ajedrez'),
(15, 36, '2026-05-10', 'Inscrito', 'Cantante aficionado');
GO

-- INSERTAR CALIFICACIONES
INSERT INTO Ratings (ActivityId, StudentId, Stars, Comment, RatingDate) VALUES
(1, 13, 5, 'Excelente taller! El instructor explicó los conceptos de composición y luz de manera muy clara. Las prácticas fueron muy útiles. Aprendí más en 2 horas que en meses viendo tutoriales.', '2026-02-06'),
(1, 14, 4, 'Muy buen contenido, aunque me hubiera gustado más tiempo para la práctica de edición. La ubicación en Sala A1 fue cómoda y con buena luz. Recomendado para principiantes.', '2026-02-07'),
(2, 14, 4, 'Torneo muy bien organizado. La logística fue impecable y el ambiente entre facultades fue de sana competencia. Solo sugeriría mejorar el estado de la cancha en algunas áreas.', '2026-02-09'),
(2, 16, 5, '¡Experiencia increíble! La energía de los equipos y la organización del evento fueron excelentes. Nuestro equipo quedó en segundo lugar, pero el espíritu deportivo fue lo más valioso.', '2026-02-10'),
(3, 15, 5, 'La mejor forma de empezar el fin de semana. La instructora tiene una voz muy calmante y las instrucciones fueron fáciles de seguir. Me ayudó mucho con el estrés de los exámenes.', '2026-02-11'),
(3, 17, 4, 'Sesión muy relajante. Agradezco que prestaran colchonetas. Solo sugeriría un poco más de variedad en las posturas para próximas sesiones.', '2026-02-12'),
(4, 16, 3, 'El taller estuvo bien, pero la duración fue muy corta para cubrir adecuadamente las técnicas de óleo. Los materiales eran de buena calidad, pero el ritmo fue muy rápido para principiantes.', '2026-02-13'),
(4, 20, 4, 'Mi primera experiencia con pintura al óleo y fue maravillosa. El instructor fue muy paciente. Me llevé mi primer cuadro y estoy muy orgulloso. ¡Gracias!', '2026-02-14'),
(5, 27, 5, 'Excelente organización de la carrera 5K. El recorrido fue espectacular y la logística impecable. ¡Volveré el próximo año!', '2026-02-21'),
(6, 28, 4, 'El taller de danza fue muy entretenido, aunque la instructora podría ser más clara en las instrucciones. El ambiente fue excelente.', '2026-02-26'),
(7, 29, 5, 'Concierto maravilloso. El talento de nuestros compañeros es increíble. Deberían hacer estos eventos más seguido.', '2026-02-28'),
(8, 30, 4, 'La meditación me ayudó mucho con el estrés de los exámenes. La instructora tiene una voz muy relajante.', '2026-03-06'),
(9, 31, 5, 'Torneo de baloncesto muy bien organizado. La competencia fue reñida y el espíritu deportivo excelente.', '2026-03-13'),
(10, 32, 3, 'La sesión de calistenia fue demasiado intensa para principiantes. El instructor debería considerar diferentes niveles.', '2026-03-19'),
(11, 33, 4, 'Interesante círculo de lectura. Las discusiones fueron enriquecedoras y aprendí sobre nuevos autores.', '2026-03-23'),
(12, 34, 5, 'Taller de respiración muy útil. Las técnicas aprendidas me están ayudando en mi vida diaria.', '2026-04-03'),
(13, 35, 4, 'Buen taller de acuarela, aunque faltaron algunos materiales. El instructor fue muy paciente.', '2026-04-11'),
(14, 36, 5, 'Torneo de ajedrez excelente. Bien organizado y con jugadores de buen nivel. ¡Gané mi primera partida!', '2026-05-09');
GO

-- CREAR ÍNDICES
CREATE INDEX IX_Activities_Date ON Activities(Date);
GO
CREATE INDEX IX_Activities_Category ON Activities(CategoryId);
GO
CREATE INDEX IX_Enrollments_Student ON Enrollments(StudentId);
GO
CREATE INDEX IX_Enrollments_Activity ON Enrollments(ActivityId);
GO
CREATE INDEX IX_Ratings_Activity ON Ratings(ActivityId);
GO
CREATE INDEX IX_Users_Email ON Users(Email);
GO
CREATE INDEX IX_Users_Role ON Users(Role);
GO
CREATE INDEX IX_Students_Career ON Students(CareerId);
GO
CREATE INDEX IX_Organizers_Department ON Organizers(Department);
GO
CREATE INDEX IX_Students_Modality ON Students(Modality);
GO
CREATE INDEX IX_Students_Schedule ON Students(Schedule);
GO
CREATE INDEX IX_Enrollments_Status ON Enrollments(Status);
GO

-- CREAR PROCEDIMIENTOS ALMACENADOS

-- PROCEDIMIENTO PARA OBTENER TODAS LAS ESTADÍSTICAS PRINCIPALES PARA EL DASHBOARD
CREATE PROCEDURE sp_GetDashboardTotals
AS
BEGIN
    SELECT
        (SELECT COUNT(*) FROM Activities WHERE Active = 1) AS TotalActivities,
        (SELECT COUNT(*) FROM Organizers O INNER JOIN Users U ON O.UserId = U.Id WHERE U.Active = 1) AS TotalOrganizers,
        (SELECT COUNT(*) FROM Users) AS TotalUsers,
        (SELECT COUNT(*) FROM Students) AS TotalStudents,
        (SELECT COUNT(*) FROM Enrollments) AS TotalEnrollments,
        (SELECT COUNT(*) FROM Categories) AS TotalCategories,
        (SELECT COUNT(*) FROM Ratings) AS TotalRatings;
END;
GO

-- PROCEDIMIENTO PARA OBTENER EL NÚMERO DE ACTIVIDADES AGRUPADAS POR CATEGORÍA
CREATE PROCEDURE sp_GetActivitiesByCategory
AS
BEGIN
    SELECT
        C.Name AS CategoryName,
        COUNT(A.Id) AS TotalActivities
    FROM Categories C
    LEFT JOIN Activities A ON A.CategoryId = C.Id AND A.Active = 1
    GROUP BY C.Name
    ORDER BY TotalActivities DESC;
END;
GO

-- PROCEDIMIENTO PARA OBTENER LAS 5 ACTIVIDADES MEJOR CALIFICADAS
CREATE PROCEDURE sp_GetTopRatings
AS
BEGIN
    SELECT TOP 5
        A.Title AS ActivityTitle,
        AVG(R.Stars*1.0) AS AvgRating
    FROM Ratings R
    INNER JOIN Activities A ON R.ActivityId = A.Id
    GROUP BY A.Title
    ORDER BY AvgRating DESC;
END;
GO