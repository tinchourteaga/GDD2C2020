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
	nroChasis NVARCHAR(50) NOT NULL,
	patente NVARCHAR(50) NOT NULL,
	nroMotor NVARCHAR(50),
	fechaAlta DATETIME2(3),
	cantKM DECIMAL(18,0),
	CONSTRAINT automovil_pk_compuesta PRIMARY KEY (nroChasis, patente),
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
	codTipoProducto NCHAR(4) NOT NULL PRIMARY KEY,
	detalleTipoProd VARCHAR(15)
);

---------------------------------------------------------------------------
-----------------------Estas tablas tienen FKs-----------------------------
---------------------------------------------------------------------------

CREATE TABLE Modelo (
	codModelo INTEGER NOT NULL PRIMARY KEY,
	codTransmision INTEGER NOT NULL FOREIGN KEY REFERENCES Transmision(codTransmision),
	codCaja INTEGER NOT NULL FOREIGN KEY REFERENCES Caja(codCaja),
	codTipoAuto INTEGER NOT NULL FOREIGN KEY REFERENCES TipoAuto(codTipoAuto),
	nombre NVARCHAR(255),
	potencia INTEGER,
	codMotor INTEGER
);

CREATE TABLE Producto (
	codProducto NVARCHAR(100) NOT NULL PRIMARY KEY,
	modelo INTEGER NOT NULL FOREIGN KEY REFERENCES Modelo(codModelo),
	tipoProducto NCHAR(4) NOT NULL FOREIGN KEY REFERENCES TipoProducto(codTipoProducto)
);

CREATE TABLE Stock (
	producto NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Producto(codProducto),
	sucursal INTEGER NOT NULL FOREIGN KEY REFERENCES Sucursal(idSucursal),
	cantidadStock INTEGER,
	CONSTRAINT stock_pk_compuesta PRIMARY KEY (producto, sucursal)
);

CREATE TABLE Compra (
	nroCompra DECIMAL(18,0) NOT NULL PRIMARY KEY,
	cliente INTEGER NOT NULL FOREIGN KEY REFERENCES Cliente(idCliente),
	sucursal INTEGER NOT NULL FOREIGN KEY REFERENCES Sucursal(idSucursal),
	fecha DATETIME
);

CREATE TABLE FacturaVta (
	nroFactura DECIMAL(18,0) NOT NULL PRIMARY KEY,
	sucursal INTEGER NOT NULL FOREIGN KEY REFERENCES Sucursal(idSucursal),
	cliente INTEGER NOT NULL FOREIGN KEY REFERENCES Cliente(idCliente),
	fecha DATETIME
);

CREATE TABLE ItemFactura (
	nroFactura DECIMAL(18,0) NOT NULL FOREIGN KEY REFERENCES FacturaVta(nroFactura),
	producto NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Producto(codProducto),
	precioUnitario DECIMAL(12,2),
	cantidadItemFactura INTEGER,
	CONSTRAINT itemFact_pk_compuesta PRIMARY KEY (nroFactura, producto),
	CONSTRAINT cantidadFac CHECK (cantidadItemFactura>=0),
	CONSTRAINT precioUniFac CHECK (precioUnitario>=0)
);

CREATE TABLE ItemCompra (
	nroCompra DECIMAL(18,0) NOT NULL FOREIGN KEY REFERENCES Compra(nroCompra),
	producto NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Producto(codProducto),
	precioUnitario DECIMAL(12,2),
	cantidadItemCompra INTEGER,
	CONSTRAINT itemComp_pk_compuesta PRIMARY KEY (nroCompra, producto),
	CONSTRAINT cantidadCom CHECK (cantidadItemCompra>=0),
	CONSTRAINT precioUniCom CHECK (precioUnitario>=0)
);
GO

-- SELECT * FROM ItemFactura

-- Borra toda la tabla
/*
DROP TABLE ItemFactura
DROP TABLE FacturaVta
DROP TABLE ItemCompra
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
DROP TABLE Cliente
*/

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

	INSERT INTO Cliente (nombre, apellido, direccion, dni, mail, fechaNac)
	SELECT DISTINCT FAC_CLIENTE_NOMBRE, FAC_CLIENTE_APELLIDO, FAC_CLIENTE_DIRECCION, FAC_CLIENTE_DNI, FAC_CLIENTE_MAIL, FAC_CLIENTE_FECHA_NAC
	FROM gd_esquema.Maestra
	WHERE FAC_CLIENTE_DNI IS NOT NULL
END;
GO

CREATE PROCEDURE cargarAutomovil
AS
BEGIN
	INSERT INTO Automovil(nroChasis, patente, nroMotor, fechaAlta, cantKM)
	SELECT DISTINCT AUTO_NRO_CHASIS, AUTO_PATENTE, AUTO_NRO_MOTOR,  AUTO_FECHA_ALTA, AUTO_CANT_KMS
	FROM gd_esquema.Maestra
	WHERE AUTO_PATENTE IS NOT NULL AND AUTO_NRO_CHASIS IS NOT NULL
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
    INSERT INTO TipoProducto (codTipoProducto, detalleTipoProd)
	VALUES('1010','AUTOMOVIL')
	INSERT INTO TipoProducto (codTipoProducto, detalleTipoProd)
	VALUES('1020','AUTOPARTE')
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

/*
 DROP PROCEDURE cargarProducto
 DROP PROCEDURE cargarCompra
 DROP PROCEDURE cargarFactura
 DROP PROCEDURE cargarItemCompra
 DROP PROCEDURE cargarItemFactura
 DROP PROCEDURE cargarStock
 */

CREATE PROCEDURE cargarProducto
AS
BEGIN
    INSERT INTO Producto(codProducto, modelo, tipoProducto)
	SELECT DISTINCT AUTO_PARTE_CODIGO, MODELO_CODIGO, '1020'
	FROM gd_esquema.Maestra
	WHERE AUTO_PARTE_CODIGO IS NOT NULL

	INSERT INTO Producto(codProducto, modelo, tipoProducto)
	SELECT DISTINCT AUTO_NRO_CHASIS+AUTO_PATENTE, MODELO_CODIGO, '1010'
	FROM gd_esquema.Maestra
	WHERE AUTO_PARTE_CODIGO IS NULL
END;
GO

CREATE PROCEDURE cargarCompra
AS
BEGIN
	INSERT INTO Compra(nroCompra, cliente, sucursal, fecha)
	SELECT COMPRA_NRO, (SELECT idCliente FROM Cliente WHERE dni = MIN(CLIENTE_DNI) AND fechaNac = MIN(CLIENTE_FECHA_NAC)), (SELECT idSucursal FROM Sucursal WHERE direccion = MIN(SUCURSAL_DIRECCION)), MIN(COMPRA_FECHA)
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NULL AND COMPRA_NRO IS NOT NULL
	GROUP BY COMPRA_NRO
END;
GO

CREATE PROCEDURE cargarItemCompra
AS
BEGIN
	INSERT INTO ItemCompra(nroCompra, precioUnitario, cantidadItemCompra, producto)
	SELECT COMPRA_NRO, (SUM(COMPRA_PRECIO)/SUM(COMPRA_CANT)), SUM(COMPRA_CANT), AUTO_PARTE_CODIGO
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NULL AND AUTO_PARTE_CODIGO IS NOT NULL AND COMPRA_NRO IS NOT NULL
	GROUP BY COMPRA_NRO, AUTO_PARTE_CODIGO

	INSERT INTO ItemCompra(nroCompra, precioUnitario, cantidadItemCompra, producto)
	SELECT COMPRA_NRO, SUM(COMPRA_PRECIO), 1, AUTO_NRO_CHASIS+AUTO_PATENTE
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NULL AND AUTO_PARTE_CODIGO IS NULL AND COMPRA_NRO IS NOT NULL
	GROUP BY COMPRA_NRO, AUTO_NRO_CHASIS+AUTO_PATENTE
END;
GO

CREATE PROCEDURE cargarFactura
AS
BEGIN
	INSERT INTO FacturaVta(nroFactura, cliente, sucursal, fecha)
	SELECT FACTURA_NRO, (SELECT idCliente FROM Cliente WHERE dni = MIN(FAC_CLIENTE_DNI) AND fechaNac = MIN(FAC_CLIENTE_FECHA_NAC)), (SELECT idSucursal FROM Sucursal WHERE direccion = MIN(FAC_SUCURSAL_DIRECCION)), MIN(FACTURA_FECHA)
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NOT NULL
	GROUP BY FACTURA_NRO
END;
GO

CREATE PROCEDURE cargarItemFactura
AS
BEGIN
	INSERT INTO ItemFactura(nroFactura, precioUnitario, cantidadItemFactura, producto)
	SELECT FACTURA_NRO, (SUM(PRECIO_FACTURADO)/SUM(CANT_FACTURADA)), SUM(CANT_FACTURADA), AUTO_PARTE_CODIGO
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL
	GROUP BY FACTURA_NRO, AUTO_PARTE_CODIGO

	INSERT INTO ItemFactura(nroFactura, precioUnitario, cantidadItemFactura, producto)
	SELECT FACTURA_NRO, SUM(PRECIO_FACTURADO), 1, AUTO_NRO_CHASIS+AUTO_PATENTE
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NULL
	GROUP BY FACTURA_NRO, AUTO_NRO_CHASIS+AUTO_PATENTE
END;
GO

CREATE PROCEDURE cargarStock
AS
BEGIN
	INSERT INTO Stock(producto, sucursal, cantidadStock)
	SELECT C.producto, Com.sucursal, (SUM(C.cantidadItemCompra) - SUM(F.cantidadItemFactura))
	FROM ItemCompra C JOIN ItemFactura F ON C.producto = F.producto JOIN Compra Com ON C.nroCompra = Com.nroCompra
	WHERE LEN(C.producto)<5
	GROUP BY C.producto, Com.sucursal

	INSERT INTO Stock(producto, sucursal, cantidadStock)
	SELECT C.producto, Com.sucursal, 
	CASE
		WHEN EXISTS (SELECT * FROM ItemFactura WHERE producto = C.producto) THEN 0
		ELSE 1
	END
	FROM ItemCompra C JOIN Compra Com ON C.nroCompra = Com.nroCompra
	WHERE LEN(C.producto)>5
	GROUP BY C.producto, Com.sucursal
END;
GO

EXEC cargarCliente
EXEC cargarAutomovil
EXEC cargarAutoparte
EXEC cargarSucursal
EXEC cargarCaja
EXEC cargarTransmision
EXEC cargarTipoAuto
EXEC cargarTipoProducto
EXEC cargarModelo
EXEC cargarProducto
EXEC cargarCompra
EXEC cargarItemCompra
EXEC cargarFactura
EXEC cargarItemFactura
EXEC cargarStock

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
SELECT * FROM Compra
SELECT * FROM ItemCompra
SELECT * FROM FacturaVta
SELECT * FROM ItemFactura
SELECT * FROM Stock ORDER BY cantidadStock