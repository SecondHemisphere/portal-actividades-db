-- =====================================================================
-- 1. CREAR BASE DE DATOS
-- =====================================================================
CREATE DATABASE PortalActividadesDB;
GO

USE PortalActividadesDB;
GO

-- =====================================================================
-- 2. TABLAS PRINCIPALES
-- =====================================================================

-- Tabla de Categorías
CREATE TABLE Categories (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Active BIT DEFAULT 1
);
GO

-- Tabla de Facultades
CREATE TABLE Faculties (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);
GO

-- Tabla de Carreras
CREATE TABLE Careers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);
GO

-- =====================================================================
-- 3. TABLA DE USUARIOS (BASE PARA TODOS LOS TIPOS)
-- =====================================================================
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

-- =====================================================================
-- 4. TABLA DE ORGANIZADORES (EXTENSIÓN DE USERS)
-- =====================================================================
CREATE TABLE Organizers (
    UserId INT PRIMARY KEY,
    Department NVARCHAR(50), -- En lugar de tabla separada
    Position NVARCHAR(50),
    Bio NVARCHAR(500),
    Shifts NVARCHAR(200), -- Almacena múltiples turnos separados por comas (Mañana,Tarde,Noche)
    WorkDays NVARCHAR(200), -- Almacena múltiples días separados por comas (Lunes,Martes,...)
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
);
GO

-- =====================================================================
-- 5. TABLA DE ESTUDIANTES (EXTENSIÓN DE USERS)
-- =====================================================================
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

-- =====================================================================
-- 6. TABLA DE ACTIVIDADES
-- =====================================================================
CREATE TABLE Activities (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    CategoryId INT NOT NULL,
    OrganizerId INT NOT NULL,
    Date DATE NOT NULL,
    RegistrationDeadline DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Location NVARCHAR(100),
    Capacity INT NOT NULL,
    Description NVARCHAR(MAX),
    PhotoUrl NVARCHAR(500),
    Active BIT DEFAULT 1,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    FOREIGN KEY (OrganizerId) REFERENCES Users(Id)
);
GO

-- =====================================================================
-- 7. TABLA DE INSCRIPCIONES (CON ENUM PARA STATUS)
-- =====================================================================
CREATE TABLE Enrollments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ActivityId INT NOT NULL,
    StudentId INT NOT NULL,
    EnrollmentDate DATE NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Inscrito', 'Cancelado', 'Pendiente', 'Completado')),
    Note NVARCHAR(500),
    FOREIGN KEY (ActivityId) REFERENCES Activities(Id),
    FOREIGN KEY (StudentId) REFERENCES Users(Id),
    UNIQUE (ActivityId, StudentId)
);
GO

-- =====================================================================
-- 8. TABLA DE CALIFICACIONES
-- =====================================================================
CREATE TABLE Ratings (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ActivityId INT NOT NULL,
    StudentId INT NOT NULL,
    Stars INT NOT NULL CHECK (Stars >= 1 AND Stars <= 5),
    Comment NVARCHAR(MAX),
    RatingDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ActivityId) REFERENCES Activities(Id),
    FOREIGN KEY (StudentId) REFERENCES Users(Id)
);
GO

-- =====================================================================
-- 9. INSERTAR DATOS DE CONFIGURACIÓN
-- =====================================================================

-- Insertar datos en Categories
INSERT INTO Categories (Name, Active) VALUES
('Cultura', 1),
('Deporte', 1),
('Bienestar', 1),
('Arte', 1),
('Música', 1),
('Tecnología', 1),
('Ciencia', 1);
GO

-- Insertar datos en Faculties
INSERT INTO Faculties (Name) VALUES
('CIENCIAS ADMINISTRATIVAS'),
('CIENCIAS MEDICAS'),
('INGENIERIA INDUSTRIAL'),
('FILOSOFIA, LETRAS Y CIENCIAS DE LA EDUCACION');
GO

-- Insertar datos en Careers
INSERT INTO Careers (Name, FacultyId) VALUES
('ADMINISTRACIÓN DE EMPRESAS', 1),
('COMERCIO EXTERIOR', 1),
('MEDICINA', 2),
('ENFERMERÍA', 2),
('INGENIERÍA INDUSTRIAL', 3),
('INGENIERÍA DE LA PRODUCCIÓN', 3),
('PEDAGOGÍA DE LA HISTORIA Y CIENCIAS SOCIALES', 4);
GO

-- =====================================================================
-- 10. INSERTAR DATOS DE USUARIOS
-- =====================================================================

-- Insertar datos en Users
INSERT INTO Users (Name, Email, Phone, Password, Role, Active, PhotoUrl) VALUES
-- Admins
('Administrador Principal', 'admin.master@uni.edu', '+593900000001', '$2b$10$f01CAQyLzYYIDOAKMVT3WOJe5Tuw0BvuLtWMF7BJp74xLDAnHjbki', 'Admin', 1, NULL),
('Soporte Tecnico', 'admin.support@uni.edu', '+593900000002', '$2b$10$Nrj4CtZU.OffgvMxKdxltuUUnDxoqj5s9DkiINwTDAq1pHUnWrGsq', 'Admin', 1, NULL),
-- Organizadores
('Maria Gonzalez', 'maria.gonzalez@uni.edu', '+593987654321', '$2b$10$eYAoW0f.1gtFCw0orSZeqeK5BDGd29B05GymoV7Fra9uPTEovBA6u', 'Organizador', 1, 'https://th.bing.com/th/id/R.cd9ea35a68606155285ca4d97e7f7aa3?rik=3AAgvsmAMydQAQ&pid=ImgRaw&r=0'),
('Carlos Perez', 'carlos.perez@uni.edu', '+593987222111', '$2b$10$TlOW76MVhmW99ioVT7PZ7eLU3159dH//lb8y71ocW7lr0WwDItEMe', 'Organizador', 1, NULL),
('Daniela Ruiz', 'daniela.ruiz@uni.edu', '+593981111222', '$2b$10$UeT3ge6s.5aqr/8mVt82QOOHisI5SBtbG96B4mjoRGq.76EMGQcFu', 'Organizador', 1, NULL),
('Jorge Alvarez', 'jorge.alvarez@uni.edu', '+593984444555', '$2b$10$4YoHchPoWSqAwAOQ7cKeYuo9VfxECi5PCib1a00t/gJe6SkfaHCWW', 'Organizador', 1, NULL),
('Lucia Herrera', 'lucia.herrera@uni.edu', '+593983333444', '$2b$10$nL6Wey8GO0zcZKYPKaeCwuXOG8Ftl3/q9p600JESI31nuk8.YmB1G', 'Organizador', 1, NULL),
('Pedro Medina', 'pedro.medina@uni.edu', '+593989898989', '$2b$10$aC8Bi1eKNbonMGm9TCTyJepakgl/7SXwR9kgoOXuCNJrF16gFghHC', 'Organizador', 1, NULL),
('Ana Villamar', 'ana.villamar@uni.edu', '+593981223344', '$2b$10$SVBu08VF4EdELzWURO9Wue6Niox1nDt55VNS8UzJD1FQPlE/aCkDe', 'Organizador', 1, NULL),
('Ricardo Salinas', 'ricardo.salinas@uni.edu', '+593989999000', '$2b$10$0oF.6r4JDhYMjnKuBboUN.xPSwZC57vi.GUrYATEJfYkfRDW8mdiW', 'Organizador', 1, NULL),
('Sofia Torres', 'sofia.torres@uni.edu', '+593981010101', '$2b$10$P371ZqGds4kCZpZC3HhQN.afL2pbTqF0t85IbFyF9b1Xi4tFFV8MC', 'Organizador', 1, NULL),
('Mario Castillo', 'mario.castillo@uni.edu', '+593982222333', '$2b$10$OqjM80FX3699bWU4BmN6Ju2mT1xvvhVFkJsyeJrz3sV4daMBvvjvS', 'Organizador', 1, NULL),
-- Estudiantes
('Ana Perez', 'ana.perez@ug.edu.ec', '+593987654321', '$2b$10$.hIkj/i20Y3op/1PaYXn/e4mH/5JXsZwvv/xn0D2LBjPsYE7n50Ee', 'Estudiante', 1, 'https://tse1.mm.bing.net/th/id/OIP.LDCemXrKhbyhvz7V35gfiAHaE7?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3'),
('Luis Gomez', 'luis.gomez@ug.edu.ec', '+593998877665', '$2b$10$qoHvaMwgooT7sW3uEYzAs.EEZRUe4p6MHWBwevMZkXA4RJRU8Amt2', 'Estudiante', 1, NULL),
('Carla Sanchez', 'carla.sanchez@ug.edu.ec', '+593987112233', '$2b$10$jZHjgvpU1MKKd/8947NSCemK1tP2ViPp9XbO6336aurXJw4SNR8vG', 'Estudiante', 1, NULL),
('Juan Torres', 'juan.torres@ug.edu.ec', '+593987221144', '$2b$10$vbR9FDHT2gmMgzz2k4ox7ew.G9Ve7tpgvHYKmOsjBhYzX3ujyTkhO', 'Estudiante', 1, NULL),
('Maria Lopez', 'maria.lopez@ug.edu.ec', '+593987334455', '$2b$10$T8/2eO0BuhPfrhy6hsug5un8ufg4Herlc8tve5Z6ZXG7R5ZCYOScm', 'Estudiante', 1, NULL),
('Diego Castillo', 'diego.castillo@ug.edu.ec', '+593999887766', '$2b$10$wWkDA4g.lH5tm2cCB1Bj7ekGmTymZXQvyKgXWaPAzaTmhZ14TLYJO', 'Estudiante', 1, NULL),
('Sofia Morales', 'sofia.morales@ug.edu.ec', '+593987445566', '$2b$10$J2SY2LsZ42fwJEusZBmKQOA2vijOR3BYv6X5q/1wrW/KswG79Z7N2', 'Estudiante', 1, NULL),
('Carlos Fernandez', 'carlos.fernandez@ug.edu.ec', '+593987556677', '$2b$10$TsdqmYSOU2SC.8.lkyySWumNx7woYcSsYmekPNeeq00TYjZWxHPi.', 'Estudiante', 1, NULL),
('Valentina Ruiz', 'valentina.ruiz@ug.edu.ec', '+593988776655', '$2b$10$ESmJ6UYkyNKzKEj3f93w/ubpG1MomYtZvknPmeLSwWrC8.w6LEzQS', 'Estudiante', 1, NULL),
('Miguel Herrera', 'miguel.herrera@ug.edu.ec', '+593987667788', '$2b$10$DHx63RgFy7u2ExUl0dh6r.TgmOtMlU7lu67Wa.CfxpPyrUpxL/F5u', 'Estudiante', 1, NULL);
GO

-- Insertar datos en Organizers (con enums en formato string)
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
(12, 'Deportes', 'Entrenador de Natación', 'Instructor con experiencia.', 'Mañana', 'Lunes,Jueves');
GO

-- Insertar datos en Students (con enums)
INSERT INTO Students (UserId, CareerId, Semester, Modality, Schedule) VALUES
(13, 3, 4, 'Presencial', 'Matutina'),
(14, 3, 4, 'Híbrida', 'Vespertina'),
(15, 2, 3, 'Virtual', 'Nocturna'),
(16, 5, 5, 'Presencial', 'Matutina'),
(17, 7, 3, 'Virtual', 'Nocturna'),
(18, 6, 4, 'Presencial', 'Vespertina'),
(19, 4, 2, 'Híbrida', 'Matutina'),
(20, 1, 1, 'Presencial', 'Vespertina'),
(21, 7, 4, 'Virtual', 'Nocturna'),
(22, 5, 2, 'Presencial', 'Matutina');
GO

-- =====================================================================
-- 11. INSERTAR DATOS DE ACTIVIDADES
-- =====================================================================

INSERT INTO Activities (Title, CategoryId, OrganizerId, Date, RegistrationDeadline, StartTime, EndTime, Location, Capacity, Description, PhotoUrl, Active) VALUES
('Taller de Fotografía', 1, 3, '2025-12-07', '2025-12-06', '10:00', '12:00', 'Sala A1', 50, 
 'Aprende fotografía básica, composición, manejo de luz y edición digital. Este taller intensivo de un día te proporcionará las herramientas necesarias para capturar imágenes impactantes con cualquier tipo de cámara. Ideal para principiantes que desean mejorar sus habilidades de inmediato. Tendremos una práctica al aire libre para aplicar lo aprendido.',
 'https://th.bing.com/th/id/R.25f51885e72010543fa8216e0a97df88?rik=7SwmZyjwgO%2bZSg&riu=http%3a%2f%2fwww.dzoom.org.es%2fwp-content%2fuploads%2f2012%2f12%2fqcam.jpg&ehk=NcD7RVxl9NgiRad5BQWq3UP%2fAlkZoMVyISMour6Ha4M%3d&risl=&pid=ImgRaw&r=0', 1),
('Torneo Fútbol', 2, 4, '2025-12-05', '2025-12-11', '14:00', '18:00', 'Cancha Principal', 16,
 'Torneo interfacultades de fútbol 7. Se requiere inscripción previa de equipos completos. Habrá premios para los tres primeros lugares y reconocimiento al goleador del campeonato. ¡Prepara tu equipo y vive la emoción de la competencia!',
 'https://tse1.mm.bing.net/th/id/OIP.nGLSwvgJMNmrDRBQAmcEcAHaD4?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Clase Yoga', 3, 5, '2025-12-09', '2025-12-08', '08:30', '11:00', 'Sala Zen', 40,
 'Sesión de Hatha Yoga enfocada en la relajación profunda y la alineación postural. Esta clase es apta para todos los niveles, desde principiantes hasta avanzados. Recuerda traer tu propia colchoneta y una botella de agua. Terminaremos con una meditación corta de 15 minutos.',
 'https://www.boomlive.in/wp-content/uploads/2014/08/sunset_yoga.jpg', 1),
('Taller Pintura', 4, 6, '2025-12-10', '2025-12-08', '13:00', '16:00', 'Sala B1', 20,
 'Introducción y práctica de la pintura al óleo. Exploraremos técnicas de mezcla de colores, sombreado y textura. Todos los materiales están incluidos: lienzo, pinceles y óleos de calidad profesional. Al final, cada participante se llevará su obra terminada.',
 'https://i1.wp.com/www.sonria.com/wp-content/uploads/2016/05/pintura2.jpg?resize=1080%2C675', 1),
('Carrera 5K', 2, 4, '2025-12-15', '2025-12-13', '07:00', '08:00', 'Pista Atlética', 200,
 'Gran competencia deportiva universitaria de 5 kilómetros. Abierta a estudiantes, personal administrativo y profesores. Se entregará un kit de corredor (camiseta y dorsal) al momento de la inscripción. Habrá puestos de hidratación a lo largo de la ruta.',
 'https://th.bing.com/th/id/R.a2df894bc8dee10a400bb386006c34e3?rik=G8wg9Pm3SyH7tw&riu=http%3a%2f%2fadex5k.adexperu.edu.pe%2f_astro%2fsection1_bg.81e84748.png&ehk=lcOGzeTPH%2brI8sEVzOC6PG7EEAMP%2fthCMDbeddeoVsM%3d&risl=&pid=ImgRaw&r=0', 1),
('Taller Danza Moderna', 1, 7, '2025-12-06', '2025-12-05', '10:00', '12:00', 'Estudio 3', 30,
 'Exploración de los fundamentos de la danza contemporánea y moderna. Se trabajarán secuencias coreográficas básicas, improvisación y conciencia corporal. No se requiere experiencia previa, solo ganas de moverse y expresarse. Se recomienda ropa cómoda.',
 'https://tse4.mm.bing.net/th/id/OIP.Q2O6lAIl8ep07jOstWimSQHaE8?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Concierto Acústico', 5, 10, '2025-12-18', '2025-12-17', '18:00', '20:00', 'Auditorio Central', 120,
 'Noche de presentación musical íntima con artistas locales e invitados especiales. Disfruta de un ambiente relajado con baladas, pop acústico y bossa nova. La entrada es gratuita, pero el aforo es limitado. ¡Una velada perfecta para desconectar!',
 'https://tse2.mm.bing.net/th/id/OIP.LijxDjdzwrHNEiokYhaNEgHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Meditación Intensiva', 3, 5, '2025-12-10', '2025-12-09', '09:30', '10:30', 'Sala Zen', 35,
 'Sesión guiada de meditación *mindfulness* de una hora. Aprenderás a enfocar la respiración, reducir el estrés y aumentar la concentración. Ideal para estudiantes en época de exámenes. No requiere experiencia previa.',
 'https://img.europapress.es/fotoweb/fotonoticia_20170826085952_1200.jpg', 1),
('Torneo Baloncesto', 2, 4, '2025-12-11', '2025-12-10', '15:00', '18:00', 'Coliseo Deportivo', 40,
 'Competencia rápida 3x3 de baloncesto. Se valorará la agilidad, el trabajo en equipo y la estrategia. Los equipos se formarán al inicio del evento o puedes venir con tu propio trío.',
 'https://wallpapers.com/images/featured/imagenes-de-baloncesto-ofuozdpxcugrqz1l.jpg', 1),
('Sesión Calistenia', 2, 8, '2025-12-08', '2025-12-07', '08:00', '09:00', 'Parque Norte', 50,
 'Entrenamiento funcional usando el peso corporal. Aprenderás las bases de la calistenia, incluyendo dominadas, flexiones y sentadillas. Sesión de alta intensidad, adecuada para quienes ya tienen una base física.',
 'https://tse2.mm.bing.net/th/id/OIP.qUor2O248b4-qyZbwW09CQHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Círculo de Lectura', 1, 3, '2025-12-09', '2025-12-07', '10:00', '11:30', 'Biblioteca Central', 33,
 'Conversatorio literario sobre autores latinoamericanos contemporáneos. Discutiremos temas de identidad, cultura y política social. Por favor, lee previamente ''Cien Años de Soledad'' (Capítulo 3) para la discusión. Es un espacio de diálogo abierto y respetuoso.',
 'https://img.genial.ly/61860d099a6bcf00127f980f/83c0f9ae-5b78-47b4-b399-b16942de0ee6.png', 1),
('Respiración Consciente', 3, 5, '2025-12-06', '2025-12-05', '11:00', '12:00', 'Sala Calm', 25,
 'Técnicas de respiración profunda y controlada para la gestión de la ansiedad. Un taller esencial para manejar el estrés académico. Aprende a usar tu respiración como ancla para el momento presente y a mejorar la calidad de tu sueño.',
 'https://tse4.mm.bing.net/th/id/OIP.gXrQFpffr4mDrGiI6m7voAHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Acuarela Avanzada', 4, 6, '2025-12-14', '2025-12-12', '14:00', '16:00', 'Sala A1', 15,
 'Exploración de técnicas avanzadas de acuarela como veladuras, trabajo en negativo y uso de sal y alcohol. Dirigido a estudiantes que ya tienen conocimientos básicos y quieren llevar sus obras al siguiente nivel. El instructor proporcionará ejemplos de maestros modernos.',
 'https://tse2.mm.bing.net/th/id/OIP.PB4m8mpnMoP8p5bHZifCgwHaEr?cb=ucfimg2&ucfimg=1&w=1024&h=647&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Ajedrez Universitario', 7, 3, '2025-12-11', '2025-12-10', '09:00', '13:00', 'Sala Multiusos', 68,
 'Torneo oficial de ajedrez rápido (Blitz). Se usarán relojes y se aplicarán las reglas de la FIDE. Es una excelente oportunidad para poner a prueba tu estrategia y mejorar tu apertura y medio juego. ¡Inscríbete y demuestra quién es el maestro del campus!',
 'https://tse2.mm.bing.net/th/id/OIP.hop24G50eMGUc3Vq7mutNAHaEK?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Técnicas Vocales', 5, 10, '2025-12-13', '2025-12-12', '15:00', '17:00', 'Sala Acústica', 30,
 'Taller enfocado en la proyección, resonancia y técnica vocal para canto y oratoria. Aprenderás ejercicios de calentamiento, control diafragmático y cómo evitar la fatiga vocal. Es ideal para futuros líderes, oradores o músicos.',
 'https://tse3.mm.bing.net/th/id/OIP.r36bG7M14c4OFVSjNcUl6AHaDt?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Pilates Suave', 3, 5, '2025-12-16', '2025-12-15', '09:00', '10:00', 'Sala Zen', 30,
 'Sesión de Pilates de bajo impacto centrada en el fortalecimiento del core y la flexibilidad. Una excelente manera de combatir el dolor de espalda asociado a largas horas de estudio. No se necesita experiencia previa, solo ropa que te permita estirarte.',
 'https://tse4.mm.bing.net/th/id/OIP.oKeNokswvieznW9BKp-mugHaEo?rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Noche de Cine', 1, 3, '2025-12-13', '2025-12-12', '18:30', '21:00', 'Auditorio C4', 155,
 'Proyección cultural de una película premiada latinoamericana, seguida de un breve debate moderado sobre el impacto social de la obra. Las palomitas corren por cuenta de la casa. ¡Ven a compartir y debatir sobre arte cinematográfico!',
 'https://th.bing.com/th/id/R.069cd14c746b6ab459beb0f97d40c1d3?rik=AISRJOyqFlLiyw&riu=http%3a%2f%2f2.bp.blogspot.com%2f-g5rKFgFBbCE%2fU7TZOBbpj3I%2fAAAAAAAAAC4%2fMpOiPHT_jz8%2fs1600%2fcine.jpg&ehk=AvcDUDXzRsLg%2bEy8vefuOSkckFFhnRyWLeMWaQB7jfE%3d&risl=&pid=ImgRaw&r=0', 1),
('Baile Fitness', 2, 4, '2025-12-14', '2025-12-13', '16:00', '18:00', 'Coliseo Deportivo', 80,
 'Sesión intensa de cardio con ritmos latinos. Quema calorías y diviértete con coreografías sencillas y mucha energía. Trae ropa deportiva y calzado cómodo. El mejor ejercicio para liberar el estrés acumulado.',
 'https://tse4.mm.bing.net/th/id/OIP.nV-0GYTyzlBw1FWWtxPMHAHaEa?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Escritura Creativa', 1, 3, '2025-10-12', '2025-12-11', '10:00', '12:00', 'Sala Letras', 20,
 'Taller para mejorar tu estilo de escritura, desarrollar personajes convincentes y estructurar narrativas cortas. Usaremos ejercicios de *brainstorming* y *prompts* para desbloquear tu creatividad. Perfecto para cualquier carrera, ¡la escritura es clave!',
 'https://tse3.mm.bing.net/th/id/OIP.htC6AiXku32_ovvH6OivBgHaEK?cb=ucfimg2&ucfimg=1&w=1280&h=720&rs=1&pid=ImgDetMain&o=7&rm=3', 1),
('Feria Bienestar', 3, 5, '2025-11-16', '2025-12-15', '09:00', '14:00', 'Plazoleta Central', 500,
 'Gran evento con charlas sobre nutrición, salud mental, manejo del tiempo y stands de productos orgánicos. Habrá demostraciones gratuitas de masajes y mini-sesiones de yoga. ¡Cuida tu cuerpo y mente en un solo lugar!',
 'https://tse2.mm.bing.net/th/id/OIP.Fi5i0siPOY0wFrOIcjotNgHaDU?cb=ucfimg2&ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3', 1);
GO

-- =====================================================================
-- 12. INSERTAR DATOS DE INSCRIPCIONES Y CALIFICACIONES
-- =====================================================================

-- Insertar datos en Enrollments (ahora con enum para Status)
INSERT INTO Enrollments (ActivityId, StudentId, EnrollmentDate, Status, Note) VALUES
(1, 13, '2025-11-20', 'Inscrito', 'Prefiere sentarse cerca de la ventana.'),
(2, 14, '2025-11-21', 'Inscrito', ''),
(3, 15, '2025-11-22', 'Inscrito', 'Solicitó material adicional por adelantado.'),
(4, 16, '2025-11-23', 'Inscrito', ''),
(5, 17, '2025-11-24', 'Inscrito', ''),
(6, 18, '2025-11-25', 'Inscrito', ''),
(7, 19, '2025-11-26', 'Inscrito', ''),
(8, 20, '2025-11-27', 'Inscrito', ''),
(9, 21, '2025-11-28', 'Inscrito', ''),
(10, 22, '2025-11-29', 'Inscrito', 'Desea participar en el grupo de discusión posterior.'),
(2, 13, '2025-12-07', 'Inscrito', 'Jugador de reserva, pero muy comprometido.'),
(3, 14, '2025-12-04', 'Inscrito', 'Necesita silla especial.'),
(2, 15, '2025-12-04', 'Inscrito', ''),
(1, 14, '2025-11-21', 'Inscrito', ''),
(4, 18, '2025-11-24', 'Inscrito', ''),
(6, 15, '2025-11-26', 'Inscrito', ''),
(11, 16, '2025-11-30', 'Inscrito', 'Interesado en la sección de Borges.'),
(14, 17, '2025-12-01', 'Inscrito', ''),
(15, 20, '2025-12-03', 'Inscrito', 'Quiere enfocar el entrenamiento vocal en canto lírico.'),
(17, 22, '2025-12-04', 'Cancelado', '');
GO

-- Insertar datos en Ratings
INSERT INTO Ratings (ActivityId, StudentId, Stars, Comment, RatingDate) VALUES
(1, 13, 5, 'El taller superó todas mis expectativas. La organizadora, María, explicó los conceptos de composición y luz de una manera muy clara y práctica. Pude mejorar drásticamente mis fotos con solo dos horas de instrucción. ¡Totalmente recomendado para cualquiera que empiece en fotografía!', '2025-12-07'),
(1, 14, 4, 'Muy buen contenido, aunque me hubiera gustado un poco más de tiempo para la práctica de edición digital, que fue muy rápida. La ubicación en Sala A1 fue cómoda y con buena luz. Un excelente inicio, sin duda.', '2025-12-08'),
(2, 14, 4, 'Fue un evento muy divertido y competitivo. La organización del torneo fue puntual, aunque la cancha principal estaba un poco descuidada en un par de áreas. El ambiente entre facultades fue de respeto y sana rivalidad. ¡Volveré a inscribirme en la próxima edición!', '2025-12-13'),
(2, 13, 5, '¡Increíble energía! Como jugador de reserva, pude ver la pasión de todos los equipos. La logística de hidratación fue excelente y el ambiente deportivo inmejorable. Un evento que realmente une a la universidad.', '2025-12-14'),
(3, 15, 4, 'Muy relajante y útil para desconectar. La profesora Daniela tiene una voz muy calmante y sus instrucciones de yoga y meditación fueron fáciles de seguir. Definitivamente sentí un alivio del estrés al salir de la Sala Zen. Un poco más de música suave sería ideal.', '2025-12-10'),
(3, 14, 5, 'La mejor forma de empezar la semana. La clase de Hatha Yoga fue un respiro. Agradezco que se hiciera énfasis en la alineación correcta. El personal fue muy atento con mi solicitud de tener una silla especial, haciendo la experiencia inclusiva.', '2025-12-11'),
(4, 16, 3, 'El taller estuvo bien en contenido (introducción a la pintura al óleo), pero la duración fue muy corta para cubrir adecuadamente las técnicas de sombreado. Se sintió apresurado. Los materiales eran de buena calidad, eso sí fue un punto a favor.', '2025-12-11'),
(4, 18, 4, 'Una gran experiencia para iniciarse en el óleo. El instructor fue muy paciente y explicó muy bien la mezcla de colores. Me hubiera gustado ver más ejemplos de trabajos avanzados, pero la práctica fue intensa y me llevo mi primer cuadro.', '2025-12-11'),
(5, 17, 4, 'Competencia interesante y muy bien organizada. La hora de inicio a las 7 AM fue difícil, ¡pero valió la pena! La ruta estaba bien señalizada y los puntos de hidratación eran suficientes. Un gran evento para la comunidad universitaria.', '2025-12-15'),
(6, 18, 5, 'Aprendí mucho sobre mi cuerpo y cómo se mueve. Lucía es una excelente coreógrafa que te motiva a explorar el espacio y la improvisación. La clase de fundamentos de danza moderna fue dinámica y me dejó con ganas de tomar más clases con ella.', '2025-12-07'),
(6, 15, 5, 'Una clase que te desafía físicamente y mentalmente. La combinación de técnica con expresión corporal es genial. Me encantó la energía del grupo. Es un espacio seguro para experimentar y divertirse sin presión de ser un profesional.', '2025-12-08'),
(7, 19, 4, 'Música muy buena y variada. Los artistas invitados tenían mucho talento y el ambiente en el Auditorio Central era íntimo y acogedor. El sonido estaba perfectamente balanceado. Solo le pongo 4 estrellas porque la fila para entrar fue un poco larga.', '2025-12-19'),
(8, 20, 5, 'La sesión de meditación fue profundamente relajante y muy necesaria antes de la temporada de exámenes. Las técnicas de *mindfulness* fueron explicadas con claridad y pude aplicarlas inmediatamente. Salí sintiéndome totalmente renovado y enfocado.', '2025-12-11'),
(9, 21, 4, 'Competencia rápida y muy emocionante. La modalidad 3x3 es muy exigente y eleva el nivel de adrenalina. Hubo algunos retrasos en la asignación de canchas, pero el espíritu deportivo lo compensó con creces. Una tarde de buen baloncesto.', '2025-12-12'),
(10, 22, 5, 'Sesión intensa y útil. El instructor Pedro nos llevó al límite, pero siempre con una técnica impecable. La calistenia en Parque Norte es una manera fantástica de aprovechar el espacio al aire libre. ¡Ya estoy esperando la próxima sesión!', '2025-12-09'),
(10, 18, 4, 'Un gran entrenamiento. La única razón por la que no es 5 estrellas es porque me gustaría que hubiera una sesión para principiantes absolutos, esta fue un poco demandante. El instructor fue motivador y corrigió posturas constantemente.', '2025-12-10'),
(11, 16, 5, 'El conversatorio literario fue fascinante. Discutir ''Cien Años de Soledad'' en el contexto social actual abrió mi mente a nuevas interpretaciones. La moderadora (María) dirigió el diálogo con mucha inteligencia y respeto por todas las opiniones. Un tesoro en la Biblioteca Central.', '2025-12-10'),
(14, 17, 5, 'Torneo de Ajedrez perfectamente organizado y muy profesional. El ritmo rápido hizo que cada partida fuera un desafío mental. La Sala Multiusos fue un buen lugar, aunque el ruido de las facultades cercanas a veces distraía. ¡Logré una buena posición y ya practico para el próximo!', '2025-12-12'),
(15, 20, 5, 'Las técnicas vocales enseñadas por Ricardo fueron transformadoras. Pude sentir una mejora inmediata en mi proyección vocal y mi control diafragmático. Los ejercicios de calentamiento son ahora parte de mi rutina diaria. ¡Este taller es oro puro para cualquier orador o cantante!', '2025-12-14');
GO

-- =====================================================================
-- 13. CREAR ÍNDICES
-- =====================================================================

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

-- =====================================================================
-- 14. CREAR PROCEDIMIENTOS ALMACENADOS (ACTUALIZADOS)
-- =====================================================================

-- Procedimiento para contar inscripciones por actividad
CREATE PROCEDURE sp_GetActivityEnrollmentCount
    @ActivityId INT
AS
BEGIN
    SELECT 
        A.Title,
        A.Capacity,
        COUNT(E.Id) AS CurrentEnrollments,
        (A.Capacity - COUNT(E.Id)) AS AvailableSpots
    FROM Activities A
    LEFT JOIN Enrollments E ON A.Id = E.ActivityId 
        AND E.Status = 'Inscrito'
    WHERE A.Id = @ActivityId
    GROUP BY A.Id, A.Title, A.Capacity;
END;
GO

-- Procedimiento para obtener estadísticas generales
CREATE PROCEDURE sp_GetActivityStatistics
AS
BEGIN
    SELECT 
        C.Name AS Category,
        COUNT(A.Id) AS TotalActivities,
        AVG(CAST(A.Capacity AS DECIMAL(10,2))) AS AvgCapacity,
        SUM(CASE WHEN A.Date >= GETDATE() THEN 1 ELSE 0 END) AS UpcomingActivities,
        SUM(CASE WHEN A.Date < GETDATE() THEN 1 ELSE 0 END) AS PastActivities
    FROM Activities A
    INNER JOIN Categories C ON A.CategoryId = C.Id
    WHERE A.Active = 1
    GROUP BY C.Name
    ORDER BY TotalActivities DESC;
END;
GO

-- Procedimiento para inscribir estudiante en actividad (ACTUALIZADO)
CREATE PROCEDURE sp_EnrollStudentInActivity
    @ActivityId INT,
    @StudentId INT,
    @Note NVARCHAR(500) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Verificar si la actividad existe y está activa
        IF NOT EXISTS (SELECT 1 FROM Activities WHERE Id = @ActivityId AND Active = 1)
        BEGIN
            RAISERROR('La actividad no existe o no está activa.', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Verificar si la fecha de registro ha pasado
        DECLARE @Deadline DATE;
        SELECT @Deadline = RegistrationDeadline FROM Activities WHERE Id = @ActivityId;
        
        IF GETDATE() > @Deadline
        BEGIN
            RAISERROR('La fecha límite de registro ha pasado.', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Verificar cupos disponibles
        DECLARE @Capacity INT, @Enrolled INT;
        SELECT @Capacity = Capacity FROM Activities WHERE Id = @ActivityId;
        
        SELECT @Enrolled = COUNT(*) FROM Enrollments 
        WHERE ActivityId = @ActivityId 
        AND Status = 'Inscrito';
        
        IF @Enrolled >= @Capacity
        BEGIN
            RAISERROR('No hay cupos disponibles para esta actividad.', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Verificar si ya está inscrito
        IF EXISTS (SELECT 1 FROM Enrollments WHERE ActivityId = @ActivityId AND StudentId = @StudentId)
        BEGIN
            RAISERROR('El estudiante ya está inscrito en esta actividad.', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        -- Insertar la inscripción
        INSERT INTO Enrollments (ActivityId, StudentId, EnrollmentDate, Status, Note)
        VALUES (@ActivityId, @StudentId, GETDATE(), 'Inscrito', @Note);
        
        COMMIT TRANSACTION;
        SELECT 'Inscripción exitosa' AS Result, SCOPE_IDENTITY() AS EnrollmentId;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- =====================================================================
-- 15. CREAR FUNCIONES (ACTUALIZADAS)
-- =====================================================================

-- Función para verificar disponibilidad de cupos
CREATE FUNCTION fn_CheckActivityAvailability(@ActivityId INT)
RETURNS INT
AS
BEGIN
    DECLARE @Capacity INT, @Enrolled INT;
    
    SELECT @Capacity = Capacity 
    FROM Activities 
    WHERE Id = @ActivityId AND Active = 1;
    
    IF @Capacity IS NULL
        RETURN 0;
    
    SELECT @Enrolled = COUNT(*) 
    FROM Enrollments 
    WHERE ActivityId = @ActivityId 
    AND Status = 'Inscrito';
    
    RETURN @Capacity - @Enrolled;
END;
GO

-- Función para obtener el promedio de calificaciones de una actividad
CREATE FUNCTION fn_GetActivityAverageRating(@ActivityId INT)
RETURNS DECIMAL(3,2)
AS
BEGIN
    DECLARE @AvgRating DECIMAL(3,2);
    
    SELECT @AvgRating = AVG(CAST(Stars AS DECIMAL(3,2)))
    FROM Ratings
    WHERE ActivityId = @ActivityId;
    
    RETURN ISNULL(@AvgRating, 0);
END;
GO

-- =====================================================================
-- 16. CREAR TRIGGERS (ACTUALIZADOS)
-- =====================================================================

-- Trigger para prevenir inscripciones después de la fecha límite
CREATE TRIGGER trg_PreventLateEnrollment
ON Enrollments
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1 
        FROM inserted I
        INNER JOIN Activities A ON I.ActivityId = A.Id
        WHERE I.EnrollmentDate > A.RegistrationDeadline
    )
    BEGIN
        RAISERROR('No se puede inscribir después de la fecha límite de registro.', 16, 1);
        RETURN;
    END
    
    -- Si pasa la validación, proceder con la inserción
    INSERT INTO Enrollments (ActivityId, StudentId, EnrollmentDate, Status, Note)
    SELECT ActivityId, StudentId, EnrollmentDate, Status, Note FROM inserted;
END;
GO

-- Trigger para actualizar automáticamente el estado de actividades pasadas
CREATE TRIGGER trg_UpdateActivityStatus
ON Activities
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Activities
    SET Active = 0
    WHERE Date < GETDATE() AND Active = 1;
END;
GO

-- Trigger para prevenir calificaciones duplicadas
CREATE TRIGGER trg_PreventDuplicateRating
ON Ratings
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1 
        FROM inserted I
        INNER JOIN Ratings R ON I.ActivityId = R.ActivityId AND I.StudentId = R.StudentId
    )
    BEGIN
        RAISERROR('El estudiante ya calificó esta actividad.', 16, 1);
        RETURN;
    END
    
    INSERT INTO Ratings (ActivityId, StudentId, Stars, Comment, RatingDate)
    SELECT ActivityId, StudentId, Stars, Comment, RatingDate FROM inserted;
END;
GO