USE ICX0_P3_6;

/*
Sustituir los operadores OR en lo posible en las cláusulas WHERE
*/
SELECT * FROM actividad WHERE id_actividad = 1 OR id_actividad = 2 OR id_actividad = 3; 
SELECT * FROM actividad WHERE id_actividad IN (1, 2, 3); 

/*
Realizar busquedas binarias sobre índices FULLTEXT para sustituir carácteres comodín
*/
SELECT * FROM actividad WHERE MATCH (descripción) AGAINST (‘+aero*’ IN BOOLEAN MODE); 

/*
Tener un equilibrio en el número de índices
*/
-- Índice en la columna 'id_socio' para mejorar la búsqueda por socio. CREATE INDEX idx_id_socio ON inscripciones (id_socio); 
-- Índice en la columna 'id_actividad' para mejorar la búsqueda por actividad.
CREATE INDEX idx_id_actividad ON inscripciones (id_actividad); 
-- Índice compuesto en las columnas 'id_socio' y 'id_actividad' para consultas que involucran ambas.
CREATE INDEX idx_id_socio_id_actividad ON inscripciones (id_socio, id_actividad); 
-- Índice en la columna 'fecha_inscripcion' para mejorar la búsqueda por fecha de inscripción.
CREATE INDEX idx_fecha_inscripcion ON inscripciones (fecha_inscripcion); 

/* 
Preparar VISTAS o utilizar tablas temporales para sustituir JOINS en una consulta
*/
CREATE VIEW VistaActividades AS 
SELECT 
A.id AS id_actividad, 
A.nombre AS actividad, 
M.id AS id_monitor, 
M.nombre AS monitor, 
S.id AS id_socio, 
S.nombre AS nombre, 
FROM 
actividad A 
JOIN 
actividad_monitor AM ON A.id = AM.id_actividad 
JOIN 
monitores M ON AM.id_monitor = M.id 
LEFT JOIN 
inscripciones I ON A.id = I.id_actividad 
LEFT JOIN 
socio S ON I.id_socio = S.id; 

/*
Todas las tablas deben tener una clave primaria y según el tipo de búsqueda que se hagan un índice agrupado
*/
CREATE TABLE actividad 
id_actividad INT PRIMARY KEY, 
actividad VARCHAR(255), 
descripción VARCHAR(255), 
dirigida_a VARCHAR(255), 
….. (incluimos el resto de columnas que tenemos en nuestra BBDD) “Creariamos el índice” 
CREATE INDEX idx_actividad 
ON actividad(actividad); 

/*
Ejemplo de EXPLAIN
*/
EXPLAIN SELECT * FROM socio WHERE nombre = 'Juan'; 

/*
Ejemplo de OPTIMIZE TABLE
*/
OPTIMIZE TABLE nombre_de_la_tabla;

/*
Crear índices
*/
CREATE INDEX idx_nombre
ON socio(nombre)

/*
Eliminar índice
*/
DROP INDEX idx_nombre
ON socio;

/*
Ejemplo de tipos de ÍNDICE PRIMARY | UNIQUE | FULLTEXT | SPATIAL
*/
-- PRIMARY KEY
CREATE TABLE socio ( 
id_socio INT PRIMARY KEY, 
nombre VARCHAR(255), 
edad INT); 

-- UNIQUE
CREATE TABLE socio (
 id_socio INT, 
nombre VARCHAR(255), 
correo_electronico VARCHAR(255) UNIQUE, 
PRIMARY KEY (id_socio) ); 

-- FULLTEXT
CREATE TABLE actividad ( 
id_actividad INT PRIMARY KEY, 
descripcion TEXT, 
FULLTEXT INDEX idx_descripcion (descripcion)
 ); 
-- SPATIAL
CREATE TABLE instalacion ( 
id_instalacion INT PRIMARY KEY, 
zona VARCHAR(255), 
denominación VARCHAR(255), 
descripcion_zona VARCHAR(255), 
metros_cuadrados FLOAT, 
aforo INT, 
SPATIAL INDEX idx_coordenadas (coordenadas) 
); 

/*
Ejemplos de Índices B-TREE y HASH
*/
-- B-TREE
CREATE INDEX idx_nombre ON socio (nombre); 
-- HASH
CREATE INDEX idx_codigo_actividad USING HASH ON actividad (codigo_actividad); 

/*
Ejemplo de búsqueda FULLTEXT
*/
-- “Creamos la tabla” 
CREATE TABLE actividad ( 
id_actividad INT PRIMARY KEY, 
descripcion TEXT, 
FULLTEXT INDEX idx_descripcion (descripcion)
 ); 
-- “Insertamos datos de ejemplo” 
INSERT INTO actividad (id_actividad, descripcion) 
VALUES 
(1, 'Clases de aerobic y fitness'), 
(2, 'Entrenamiento funcional para mejorar la resistencia'), 
(3, 'Yoga para relajación y flexibilidad'), 
(4, 'Spinning para quemar calorías'); 
-- “Realizamos la busqueda FULLTEXT” 
SELECT *FROM actividad 
WHERE MATCH (descripcion) AGAINST ('aerobic fitness' IN BOOLEAN MODE); 

/*
Pasos a seguir para crear un Prepared Statement
*/
-- Preparar la Sentencia
SET @consulta = 'SELECT id_socio, nombre FROM socio WHERE fecha_alta > ?'; 
-- Precompilación
PREPARE stmt FROM @consulta; 
-- Asignar Valores a los Marcadores de Posición
SET @fecha_alta_param = '2023-01-01'; 
-- Ejecución del Prepared Statement
EXECUTE stmt USING @fecha_alta_param; 
-- Desprenderse del Prepared Statement
DEALLOCATE PREPARE stmt; 

/*
Sentencias Roles
*/
-- Crear Rol
CREATE ROLE rol_nuevo; 
-- Asignar Rol
GRANT rol_nuevo TO usuario_carlos; 
-- Retirar Rol
REVOKE rol_nuevo FROM usuario_carlos; 
-- Eliminar Rol
DROP ROLE rol_nuevo; 










