USE [GD2C2020]
GO

CREATE TABLE Cliente (
	idCliente INTEGER NOT NULL IDENTITY PRIMARY KEY,
	nombre NVARCHAR(255),
	apellido NVARCHAR(255),
	direccion NVARCHAR(255),
	dni DECIMAL(18,0),
	mail NVARCHAR(255),
	fechaNac DATETIME2(3)
);

CREATE TABLE Automovil (
	idAutomovil INTEGER NOT NULL IDENTITY PRIMARY KEY,
	nroChasis NVARCHAR(50),
	nroMotor NVARCHAR(50),
	patente NVARCHAR(50),
	fechaAlta DATETIME2(3),
	cantKM DECIMAL(18,0),
	CONSTRAINT cantidadKM CHECK (cantKM>=0)
);

CREATE TABLE Autoparte (
	codAutoparte INTEGER NOT NULL PRIMARY KEY,
	-- No puse el IDENTITY porque dice "codAutoparte"
	descripcion NVARCHAR(255),
	fabricante NVARCHAR(255)
);

CREATE TABLE Sucursal (
	idSucursal INTEGER NOT NULL IDENTITY PRIMARY KEY,
	direccion NVARCHAR(255),
	mail NVARCHAR(255),
	telefono INTEGER,
	ciudad NVARCHAR(255)
);

CREATE TABLE Caja (
	codCaja INTEGER NOT NULL PRIMARY KEY,
	-- No puse el IDENTITY porque dice "codCaja"
	descCaja NVARCHAR(255)
);

CREATE TABLE Transmision (
	codTransmision INTEGER NOT NULL PRIMARY KEY,
	-- No puse el IDENTITY porque dice "codTransmision"
	descTransmision NVARCHAR(255)
);

CREATE TABLE TipoAuto (
	codTipoAuto INTEGER NOT NULL PRIMARY KEY,
	-- No puse el IDENTITY porque dice "codTipoAuto"
	descripcion NVARCHAR(255)
);

CREATE TABLE TipoProducto (
	idTipoProducto INTEGER NOT NULL IDENTITY PRIMARY KEY,
	detalleTipoProd VARCHAR(15)
);

---------------------------------------------------------------------------
-----------------------Estas tablas tienen FKs-----------------------------
---------------------------------------------------------------------------

CREATE TABLE Modelo (
	codModelo INTEGER NOT NULL PRIMARY KEY,
	-- No puse el IDENTITY porque dice "codModelo"
	codTransmision INTEGER NOT NULL FOREIGN KEY REFERENCES Transmision(codTransmision),
	codCaja INTEGER NOT NULL FOREIGN KEY REFERENCES Caja(codCaja),
	codTipoAuto INTEGER NOT NULL FOREIGN KEY REFERENCES TipoAuto(codTipoAuto),
	nombre NVARCHAR(255),
	potencia INTEGER,
	codMotor INTEGER
);

CREATE TABLE Producto (
	idProducto INTEGER NOT NULL IDENTITY PRIMARY KEY,
	modelo INTEGER NOT NULL FOREIGN KEY REFERENCES Modelo(codModelo),
	tipoProducto INTEGER NOT NULL FOREIGN KEY REFERENCES TipoProducto(idTipoProducto),
	automovil INTEGER FOREIGN KEY REFERENCES Automovil(idAutomovil),
	autoparte INTEGER FOREIGN KEY REFERENCES Autoparte(codAutoparte)
);

CREATE TABLE Stock (
	producto INTEGER NOT NULL FOREIGN KEY REFERENCES Producto(idProducto),
	sucursal INTEGER NOT NULL FOREIGN KEY REFERENCES Sucursal(idSucursal),
	cantidadStock INTEGER,
	CONSTRAINT stock_pk_compuesta PRIMARY KEY (producto, sucursal),
	CONSTRAINT cantidadStk CHECK (cantidadStock>=0)
);

CREATE TABLE Compra (
	nroCompra INTEGER NOT NULL PRIMARY KEY,
	cliente INTEGER NOT NULL FOREIGN KEY REFERENCES Cliente(idCliente),
	sucursal INTEGER NOT NULL FOREIGN KEY REFERENCES Sucursal(idSucursal),
	producto INTEGER NOT NULL FOREIGN KEY REFERENCES Producto(idProducto),
	cantidadCompra INTEGER,
	fecha DATETIME,
	precioTotal DECIMAL(12,2),
	CONSTRAINT cantCompra CHECK (cantidadCompra>=0),
	CONSTRAINT precio CHECK (precioTotal>=0)
);

CREATE TABLE FacturaVta (
	nroFactura INTEGER NOT NULL PRIMARY KEY,
	sucursal INTEGER NOT NULL FOREIGN KEY REFERENCES Sucursal(idSucursal),
	cliente INTEGER NOT NULL FOREIGN KEY REFERENCES Cliente(idCliente),
	fecha DATETIME,
	precioTotal DECIMAL(12,2),
	CONSTRAINT precioFact CHECK (precioTotal>=0)
);

CREATE TABLE ItemFactura (
	nroItem INTEGER NOT NULL,
	nroFactura INTEGER NOT NULL FOREIGN KEY REFERENCES FacturaVta(nroFactura),
	producto INTEGER NOT NULL FOREIGN KEY REFERENCES Producto(idProducto),
	precioUnitario DECIMAL(12,2),
	cantidadItemFactura INTEGER,
	CONSTRAINT itemFact_pk_compuesta PRIMARY KEY (nroItem, nroFactura),
	CONSTRAINT cantidad CHECK (cantidadItemFactura>=0),
	CONSTRAINT precioUni CHECK (precioUnitario>=0)
);
GO

-- SELECT * FROM ItemFactura

-- Borra toda la tabla

/*DROP TABLE ItemFactura
DROP TABLE FacturaVta
DROP TABLE Compra
DROP TABLE Stock
DROP TABLE Producto
DROP TABLE Modelo
DROP TABLE TipoProducto
DROP TABLE TipoAuto
DROP TABLE Transmision
DROP TABLE Caja
DROP TABLE Sucursal
DROP TABLE Autoparte
DROP TABLE Automovil
DROP TABLE Cliente*/

-- Agregar una CONSTRAINT por fuera del CREATE TABLE:
-- ALTER TABLE Stock
-- ADD CONSTRAINT cantidad CHECK (cantidad>=0)


-- Agregar una FK por fuera del CREATE TABLE:
-- ALTER TABLE Stock
-- ADD CONSTRAINT producto_fk FOREIGN KEY (producto) REFERENCES Autoparte(codAutoparte)


---------------------------------------------------------------------------
-------------------------------Migracion-----------------------------------
---------------------------------------------------------------------------

CREATE PROCEDURE cargarCliente
AS
BEGIN
    INSERT INTO Cliente (nombre, apellido, direccion, dni, mail, fechaNac)
	SELECT DISTINCT CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_DNI, CLIENTE_MAIL, CLIENTE_FECHA_NAC
	FROM gd_esquema.Maestra
	WHERE CLIENTE_DNI IS NOT NULL
END;
GO


CREATE PROCEDURE cargarAutomovil
AS
BEGIN
	INSERT INTO Automovil(nroChasis, nroMotor, patente, fechaAlta, cantKM)
	SELECT DISTINCT AUTO_NRO_CHASIS, AUTO_NRO_MOTOR, AUTO_PATENTE, AUTO_FECHA_ALTA, AUTO_CANT_KMS
	FROM gd_esquema.Maestra
	WHERE AUTO_PATENTE IS NOT NULL
END;
GO

CREATE PROCEDURE cargarAutoparte
AS
BEGIN
    INSERT INTO Autoparte(codAutoparte, descripcion, fabricante)
	SELECT DISTINCT AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, FABRICANTE_NOMBRE
	FROM gd_esquema.Maestra
	WHERE AUTO_PARTE_CODIGO IS NOT NULL
END;
GO



CREATE PROCEDURE cargarSucursal
AS
BEGIN
    INSERT INTO Sucursal(direccion, mail, telefono, ciudad)
	SELECT DISTINCT SUCURSAL_DIRECCION, SUCURSAL_MAIL, SUCURSAL_TELEFONO, SUCURSAL_CIUDAD
	FROM gd_esquema.Maestra
	WHERE SUCURSAL_DIRECCION IS NOT NULL
END;
GO

CREATE PROCEDURE cargarCaja
AS
BEGIN
    INSERT INTO Caja(codCaja, descCaja)
	SELECT DISTINCT TIPO_CAJA_CODIGO, TIPO_CAJA_DESC
	FROM gd_esquema.Maestra
	WHERE TIPO_CAJA_CODIGO IS NOT NULL
END;
GO

CREATE PROCEDURE cargarTransmision
AS
BEGIN
    INSERT INTO Transmision(codTransmision, descTransmision)
	SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC
	FROM gd_esquema.Maestra
	WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL
END;
GO

CREATE PROCEDURE cargarTipoAuto
AS
BEGIN
    INSERT INTO TipoAuto(codTipoAuto, descripcion)
	SELECT DISTINCT TIPO_AUTO_CODIGO, TIPO_AUTO_DESC
	FROM gd_esquema.Maestra
	WHERE TIPO_AUTO_CODIGO IS NOT NULL
END;
GO

CREATE PROCEDURE cargarTipoProducto
AS
BEGIN
    INSERT INTO TipoProducto(detalleTipoProd)
	VALUES('AUTOMOVIL')
	INSERT INTO TipoProducto(detalleTipoProd)
	VALUES('AUTOPARTE')
END;
GO

CREATE PROCEDURE cargarModelo
AS
BEGIN
    INSERT INTO Modelo(codModelo, codTransmision, codCaja, codTipoAuto, nombre, potencia, codMotor)
	SELECT DISTINCT MODELO_CODIGO, TIPO_TRANSMISION_CODIGO, TIPO_CAJA_CODIGO, TIPO_AUTO_CODIGO, MODELO_NOMBRE, MODELO_POTENCIA, TIPO_MOTOR_CODIGO
	FROM gd_esquema.Maestra
	WHERE MODELO_CODIGO IS NOT NULL AND
	TIPO_TRANSMISION_CODIGO IS NOT NULL AND
	TIPO_CAJA_CODIGO IS NOT NULL AND
	TIPO_AUTO_CODIGO IS NOT NULL
END;
GO

CREATE PROCEDURE cargarProducto
AS
BEGIN
	--Autos
	DECLARE @AUTOS TABLE(codModelo INTEGER, nroChasis NVARCHAR(50), nroMotor NVARCHAR(50), patente NVARCHAR(50), fechaAlta DATETIME2(3),  cantKM DECIMAL(18,0), id INTEGER NOT NULL IDENTITY)
	INSERT INTO @AUTOS
	SELECT DISTINCT MODELO_CODIGO, AUTO_NRO_CHASIS, AUTO_NRO_MOTOR, AUTO_PATENTE, AUTO_FECHA_ALTA, AUTO_CANT_KMS
	FROM gd_esquema.Maestra
	WHERE AUTO_PATENTE IS NOT NULL

	INSERT INTO Automovil(nroChasis, nroMotor, patente, fechaAlta, cantKM)
	SELECT DISTINCT nroChasis, nroMotor, patente, fechaAlta, cantKM
	FROM @AUTOS

	INSERT INTO Producto(modelo, tipoProducto, automovil)
	SELECT codModelo, 1, id FROM @AUTOS

	--Autopartes
	DECLARE @AUTOPARTES TABLE(codModelo INTEGER,codAutoparte INTEGER, descripcion NVARCHAR(255), fabricante NVARCHAR(255))
	INSERT INTO @AUTOPARTES
	SELECT DISTINCT MODELO_CODIGO ,AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, FABRICANTE_NOMBRE
	FROM gd_esquema.Maestra
	WHERE AUTO_PARTE_CODIGO IS NOT NULL

	INSERT INTO Autoparte(codAutoparte, descripcion, fabricante)
	SELECT DISTINCT codAutoparte, descripcion, fabricante
	FROM @AUTOPARTES

	INSERT INTO Producto(modelo, tipoProducto, autoparte)
	SELECT codModelo, 2, codAutoparte FROM @AUTOPARTES
	

	/*
    INSERT INTO Producto(modelo, tipoProducto, autoparte)
	SELECT DISTINCT MODELO_CODIGO, (SELECT CASE WHEN AUTO_PARTE_CODIGO IS NULL THEN 1 ELSE 2 END), AUTO_PARTE_CODIGO
	FROM gd_esquema.Maestra
	WHERE MODELO_CODIGO IS NOT NULL
	*/
END;
GO

drop procedure cargarProducto

EXEC cargarCliente
--EXEC cargarAutomovil
--EXEC cargarAutoparte
EXEC cargarSucursal
EXEC cargarCaja
EXEC cargarTransmision
EXEC cargarTipoAuto
EXEC cargarTipoProducto
EXEC cargarModelo
EXEC cargarProducto

SELECT * FROM Cliente
SELECT * FROM Automovil
SELECT * FROM Autoparte
SELECT * FROM Sucursal
SELECT * FROM Caja
SELECT * FROM Transmision
SELECT * FROM TipoAuto
SELECT * FROM TipoProducto
SELECT * FROM Modelo
SELECT * FROM Producto

SELECT * FROM gd_esquema.Maestra ORDER BY AUTO_PATENTE DESC

SELECT distinct * FROM gd_esquema.Maestra WHERE AUTO_PARTE_CODIGO IS NOT NULL OR AUTO_PATENTE IS NOT NULL 