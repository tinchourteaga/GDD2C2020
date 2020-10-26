USE [GD2C2020]
GO

--CREACION DEL ESQUEMA
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='LOS_TABLATUBBIES')
BEGIN
	EXEC('CREATE SCHEMA [LOS_TABLATUBBIES]')
END
GO

--CREACION DE TABLAS
CREATE TABLE [LOS_TABLATUBBIES].Cliente (
	idCliente INTEGER NOT NULL IDENTITY PRIMARY KEY,
	nombre NVARCHAR(255),
	apellido NVARCHAR(255),
	direccion NVARCHAR(255),
	dni DECIMAL(18,0),
	mail NVARCHAR(255),
	fechaNac DATETIME2(3)
);

CREATE TABLE [LOS_TABLATUBBIES].Automovil (
	nroChasis NVARCHAR(50) NOT NULL PRIMARY KEY,
	patente NVARCHAR(50),
	nroMotor NVARCHAR(50),
	fechaAlta DATETIME2(3),
	cantKM DECIMAL(18,0),
	CONSTRAINT cantidadKM CHECK (cantKM>=0)
);

CREATE TABLE [LOS_TABLATUBBIES].Autoparte (
	codAutoparte DECIMAL(18,0) NOT NULL PRIMARY KEY,
	descripcion NVARCHAR(255),
	fabricante NVARCHAR(255)
);

CREATE TABLE [LOS_TABLATUBBIES].Sucursal (
	idSucursal INTEGER NOT NULL IDENTITY PRIMARY KEY,
	direccion NVARCHAR(255),
	mail NVARCHAR(255),
	telefono INTEGER,
	ciudad NVARCHAR(255)
);

CREATE TABLE [LOS_TABLATUBBIES].Caja (
	codCaja DECIMAL(18,0) NOT NULL PRIMARY KEY,
	descCaja NVARCHAR(255)
);

CREATE TABLE [LOS_TABLATUBBIES].Transmision (
	codTransmision DECIMAL(18,0) NOT NULL PRIMARY KEY,
	descTransmision NVARCHAR(255)
);

CREATE TABLE [LOS_TABLATUBBIES].TipoAuto (
	codTipoAuto DECIMAL(18,0) NOT NULL PRIMARY KEY,
	descripcion NVARCHAR(255)
);

CREATE TABLE [LOS_TABLATUBBIES].TipoProducto (
	codTipoProducto NCHAR(4) NOT NULL PRIMARY KEY,
	detalleTipoProd VARCHAR(15)
);

---------------------------------------------------------------------------
-----------------------Estas tablas tienen FKs-----------------------------
---------------------------------------------------------------------------

CREATE TABLE [LOS_TABLATUBBIES].Modelo (
	codModelo DECIMAL(18,0) NOT NULL PRIMARY KEY,
	codTransmision DECIMAL(18,0) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Transmision(codTransmision),
	codCaja DECIMAL(18,0) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Caja(codCaja),
	codTipoAuto DECIMAL(18,0) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].TipoAuto(codTipoAuto),
	nombre NVARCHAR(255),
	potencia DECIMAL(18,0),
	codMotor DECIMAL(18,0)
);

CREATE TABLE [LOS_TABLATUBBIES].Producto (
	codProducto NVARCHAR(50) NOT NULL PRIMARY KEY,
	modelo DECIMAL(18,0) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Modelo(codModelo),
	tipoProducto NCHAR(4) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].TipoProducto(codTipoProducto)
);

CREATE TABLE [LOS_TABLATUBBIES].Stock (
	producto NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Producto(codProducto),
	sucursal INTEGER NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Sucursal(idSucursal),
	cantidadStock INTEGER,
	CONSTRAINT stock_pk_compuesta PRIMARY KEY (producto, sucursal)
);

CREATE TABLE [LOS_TABLATUBBIES].Compra (
	nroCompra DECIMAL(18,0) NOT NULL PRIMARY KEY,
	cliente INTEGER NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Cliente(idCliente),
	sucursal INTEGER NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Sucursal(idSucursal),
	fecha DATETIME
);

CREATE TABLE [LOS_TABLATUBBIES].FacturaVta (
	nroFactura DECIMAL(18,0) NOT NULL PRIMARY KEY,
	sucursal INTEGER NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Sucursal(idSucursal),
	cliente INTEGER NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Cliente(idCliente),
	fecha DATETIME
);

CREATE TABLE [LOS_TABLATUBBIES].ItemFactura (
	nroFactura DECIMAL(18,0) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].FacturaVta(nroFactura),
	producto NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Producto(codProducto),
	precioUnitario DECIMAL(12,2),
	cantidadItemFactura INTEGER,
	CONSTRAINT itemFact_pk_compuesta PRIMARY KEY (nroFactura, producto),
	CONSTRAINT cantidadFac CHECK (cantidadItemFactura>=0),
	CONSTRAINT precioUniFac CHECK (precioUnitario>=0)
);

CREATE TABLE [LOS_TABLATUBBIES].ItemCompra (
	nroCompra DECIMAL(18,0) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Compra(nroCompra),
	producto NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].Producto(codProducto),
	precioUnitario DECIMAL(12,2),
	cantidadItemCompra INTEGER,
	CONSTRAINT itemComp_pk_compuesta PRIMARY KEY (nroCompra, producto),
	CONSTRAINT cantidadCom CHECK (cantidadItemCompra>=0),
	CONSTRAINT precioUniCom CHECK (precioUnitario>=0)
);
GO

-- Dropeo de tablas
/*
DROP TABLE [LOS_TABLATUBBIES].ItemFactura
DROP TABLE [LOS_TABLATUBBIES].FacturaVta
DROP TABLE [LOS_TABLATUBBIES].ItemCompra
DROP TABLE [LOS_TABLATUBBIES].Compra
DROP TABLE [LOS_TABLATUBBIES].Stock
DROP TABLE [LOS_TABLATUBBIES].Producto
DROP TABLE [LOS_TABLATUBBIES].Modelo
DROP TABLE [LOS_TABLATUBBIES].TipoProducto
DROP TABLE [LOS_TABLATUBBIES].TipoAuto
DROP TABLE [LOS_TABLATUBBIES].Transmision
DROP TABLE [LOS_TABLATUBBIES].Caja
DROP TABLE [LOS_TABLATUBBIES].Sucursal
DROP TABLE [LOS_TABLATUBBIES].Autoparte
DROP TABLE [LOS_TABLATUBBIES].Automovil
DROP TABLE [LOS_TABLATUBBIES].Cliente
*/

-- Agregar una CONSTRAINT por fuera del CREATE TABLE:
-- ALTER TABLE Stock
-- ADD CONSTRAINT cantidad CHECK (cantidad>=0)


-- Agregar una FK por fuera del CREATE TABLE:
-- ALTER TABLE Stock
-- ADD CONSTRAINT producto_fk FOREIGN KEY (producto) REFERENCES Autoparte(codAutoparte)

---------------------------------------------------------------------------
-------------------------------- Vistas -----------------------------------
---------------------------------------------------------------------------










---------------------------------------------------------------------------
-------------------------------Migracion-----------------------------------
---------------------------------------------------------------------------

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarCliente
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].Cliente (nombre, apellido, direccion, dni, mail, fechaNac)
	SELECT DISTINCT CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_DNI, CLIENTE_MAIL, CLIENTE_FECHA_NAC
	FROM gd_esquema.Maestra
	WHERE CLIENTE_DNI IS NOT NULL

	INSERT INTO [LOS_TABLATUBBIES].Cliente (nombre, apellido, direccion, dni, mail, fechaNac)
	SELECT DISTINCT FAC_CLIENTE_NOMBRE, FAC_CLIENTE_APELLIDO, FAC_CLIENTE_DIRECCION, FAC_CLIENTE_DNI, FAC_CLIENTE_MAIL, FAC_CLIENTE_FECHA_NAC
	FROM gd_esquema.Maestra
	WHERE FAC_CLIENTE_DNI IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarAutomovil
AS
BEGIN
	INSERT INTO [LOS_TABLATUBBIES].Automovil(nroChasis, patente, nroMotor, fechaAlta, cantKM)
	
	SELECT AUTO_NRO_CHASIS, AUTO_PATENTE, AUTO_NRO_MOTOR,  AUTO_FECHA_ALTA, AUTO_CANT_KMS
	FROM (
                SELECT  AUTO_NRO_CHASIS, AUTO_PATENTE, AUTO_NRO_MOTOR,  AUTO_FECHA_ALTA, AUTO_CANT_KMS,
                        ROW_NUMBER() OVER(PARTITION BY AUTO_NRO_CHASIS ORDER BY AUTO_FECHA_ALTA DESC) rn
                    FROM gd_esquema.Maestra
					WHERE AUTO_NRO_CHASIS IS NOT NULL
              ) a
	WHERE rn = 1

END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarAutoparte
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].Autoparte(codAutoparte, descripcion, fabricante)
	SELECT DISTINCT AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, FABRICANTE_NOMBRE
	FROM gd_esquema.Maestra
	WHERE AUTO_PARTE_CODIGO IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarSucursal
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].Sucursal(direccion, mail, telefono, ciudad)
	SELECT DISTINCT SUCURSAL_DIRECCION, SUCURSAL_MAIL, SUCURSAL_TELEFONO, SUCURSAL_CIUDAD
	FROM gd_esquema.Maestra
	WHERE SUCURSAL_DIRECCION IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarCaja
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].Caja(codCaja, descCaja)
	SELECT DISTINCT TIPO_CAJA_CODIGO, TIPO_CAJA_DESC
	FROM gd_esquema.Maestra
	WHERE TIPO_CAJA_CODIGO IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarTransmision
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].Transmision(codTransmision, descTransmision)
	SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC
	FROM gd_esquema.Maestra
	WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarTipoAuto
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].TipoAuto(codTipoAuto, descripcion)
	SELECT DISTINCT TIPO_AUTO_CODIGO, TIPO_AUTO_DESC
	FROM gd_esquema.Maestra
	WHERE TIPO_AUTO_CODIGO IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarTipoProducto
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].TipoProducto (codTipoProducto, detalleTipoProd)
	VALUES('1010','AUTOMOVIL')
	INSERT INTO [LOS_TABLATUBBIES].TipoProducto (codTipoProducto, detalleTipoProd)
	VALUES('1020','AUTOPARTE')
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarModelo
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].Modelo(codModelo, codTransmision, codCaja, codTipoAuto, nombre, potencia, codMotor)
	SELECT MODELO_CODIGO, TIPO_TRANSMISION_CODIGO, TIPO_CAJA_CODIGO, TIPO_AUTO_CODIGO, MODELO_NOMBRE, MODELO_POTENCIA, TIPO_MOTOR_CODIGO
	FROM (
                SELECT  MODELO_CODIGO, TIPO_TRANSMISION_CODIGO, TIPO_CAJA_CODIGO, TIPO_AUTO_CODIGO, MODELO_NOMBRE, MODELO_POTENCIA, TIPO_MOTOR_CODIGO,
                        ROW_NUMBER() OVER(PARTITION BY MODELO_CODIGO ORDER BY MODELO_POTENCIA DESC) rn
                    FROM gd_esquema.Maestra
					WHERE AUTO_NRO_CHASIS IS NOT NULL
              ) a
	WHERE rn = 1
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarProducto
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].Producto(codProducto, modelo, tipoProducto)
	SELECT DISTINCT AUTO_PARTE_CODIGO, MODELO_CODIGO, '1020'
	FROM gd_esquema.Maestra
	WHERE AUTO_PARTE_CODIGO IS NOT NULL

	INSERT INTO [LOS_TABLATUBBIES].Producto(codProducto, modelo, tipoProducto)
	SELECT DISTINCT AUTO_NRO_CHASIS, MODELO_CODIGO, '1010'
	FROM gd_esquema.Maestra
	WHERE AUTO_PARTE_CODIGO IS NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarCompra
AS
BEGIN
	INSERT INTO [LOS_TABLATUBBIES].Compra(nroCompra, cliente, sucursal, fecha)
	SELECT COMPRA_NRO, (SELECT idCliente FROM Cliente WHERE dni = MIN(CLIENTE_DNI) AND fechaNac = MIN(CLIENTE_FECHA_NAC)), (SELECT idSucursal FROM Sucursal WHERE direccion = MIN(SUCURSAL_DIRECCION)), MIN(COMPRA_FECHA)
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NULL AND COMPRA_NRO IS NOT NULL
	GROUP BY COMPRA_NRO
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarItemCompra
AS
BEGIN
	INSERT INTO [LOS_TABLATUBBIES].ItemCompra(nroCompra, precioUnitario, cantidadItemCompra, producto)
	SELECT COMPRA_NRO, (SUM(COMPRA_PRECIO)/SUM(COMPRA_CANT)), SUM(COMPRA_CANT), AUTO_PARTE_CODIGO
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NULL AND COMPRA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL 
	GROUP BY COMPRA_NRO, AUTO_PARTE_CODIGO

	INSERT INTO [LOS_TABLATUBBIES].ItemCompra(nroCompra, precioUnitario, cantidadItemCompra, producto)
	SELECT COMPRA_NRO, SUM(COMPRA_PRECIO), 1, AUTO_NRO_CHASIS
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NULL AND COMPRA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NULL
	GROUP BY COMPRA_NRO, AUTO_NRO_CHASIS
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarFactura
AS
BEGIN
	INSERT INTO [LOS_TABLATUBBIES].FacturaVta(nroFactura, cliente, sucursal, fecha)
	SELECT FACTURA_NRO, (SELECT idCliente FROM Cliente WHERE dni = MIN(FAC_CLIENTE_DNI) AND fechaNac = MIN(FAC_CLIENTE_FECHA_NAC)), (SELECT idSucursal FROM Sucursal WHERE direccion = MIN(FAC_SUCURSAL_DIRECCION)), MIN(FACTURA_FECHA)
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NOT NULL
	GROUP BY FACTURA_NRO
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarItemFactura
AS
BEGIN
	INSERT INTO [LOS_TABLATUBBIES].ItemFactura(nroFactura, precioUnitario, cantidadItemFactura, producto)
	SELECT FACTURA_NRO, (SUM(PRECIO_FACTURADO)/SUM(CANT_FACTURADA)), SUM(CANT_FACTURADA), AUTO_PARTE_CODIGO
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NOT NULL
	GROUP BY FACTURA_NRO, AUTO_PARTE_CODIGO

	INSERT INTO [LOS_TABLATUBBIES].ItemFactura(nroFactura, precioUnitario, cantidadItemFactura, producto)
	SELECT FACTURA_NRO, SUM(PRECIO_FACTURADO), 1, AUTO_NRO_CHASIS
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NOT NULL AND AUTO_PARTE_CODIGO IS NULL
	GROUP BY FACTURA_NRO, AUTO_NRO_CHASIS
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarStock
AS
BEGIN
	INSERT INTO [LOS_TABLATUBBIES].Stock(producto, sucursal, cantidadStock)
	SELECT C.producto, Com.sucursal, (SUM(C.cantidadItemCompra) - SUM(F.cantidadItemFactura))
	FROM ItemCompra C JOIN [LOS_TABLATUBBIES].ItemFactura F ON C.producto = F.producto JOIN [LOS_TABLATUBBIES].Compra Com ON C.nroCompra = Com.nroCompra
	WHERE LEN(C.producto)<5
	GROUP BY C.producto, Com.sucursal

	INSERT INTO [LOS_TABLATUBBIES].Stock(producto, sucursal, cantidadStock)
	SELECT C.producto, Com.sucursal, 
	CASE
		WHEN EXISTS (SELECT * FROM ItemFactura WHERE producto = C.producto) THEN 0
		ELSE 1
	END
	FROM [LOS_TABLATUBBIES].ItemCompra C JOIN Compra Com ON C.nroCompra = Com.nroCompra
	WHERE LEN(C.producto)>5
	GROUP BY C.producto, Com.sucursal
END;
GO

EXEC [LOS_TABLATUBBIES].cargarCliente
EXEC [LOS_TABLATUBBIES].cargarAutomovil
EXEC [LOS_TABLATUBBIES].cargarAutoparte
EXEC [LOS_TABLATUBBIES].cargarSucursal
EXEC [LOS_TABLATUBBIES].cargarCaja
EXEC [LOS_TABLATUBBIES].cargarTransmision
EXEC [LOS_TABLATUBBIES].cargarTipoAuto
EXEC [LOS_TABLATUBBIES].cargarTipoProducto
EXEC [LOS_TABLATUBBIES].cargarModelo
EXEC [LOS_TABLATUBBIES].cargarProducto
EXEC [LOS_TABLATUBBIES].cargarCompra
EXEC [LOS_TABLATUBBIES].cargarItemCompra
EXEC [LOS_TABLATUBBIES].cargarFactura
EXEC [LOS_TABLATUBBIES].cargarItemFactura
EXEC [LOS_TABLATUBBIES].cargarStock

-- Dropeo de stored procedures
/*
DROP PROCEDURE [LOS_TABLATUBBIES].cargarCliente
DROP PROCEDURE [LOS_TABLATUBBIES].cargarAutomovil
DROP PROCEDURE [LOS_TABLATUBBIES].cargarAutoparte
DROP PROCEDURE [LOS_TABLATUBBIES].cargarSucursal
DROP PROCEDURE [LOS_TABLATUBBIES].cargarCaja
DROP PROCEDURE [LOS_TABLATUBBIES].cargarTransmision
DROP PROCEDURE [LOS_TABLATUBBIES].cargarTipoAuto
DROP PROCEDURE [LOS_TABLATUBBIES].cargarTipoProducto
DROP PROCEDURE [LOS_TABLATUBBIES].cargarModelo
DROP PROCEDURE [LOS_TABLATUBBIES].cargarProducto
DROP PROCEDURE [LOS_TABLATUBBIES].cargarCompra
DROP PROCEDURE [LOS_TABLATUBBIES].cargarItemCompra
DROP PROCEDURE [LOS_TABLATUBBIES].cargarFactura
DROP PROCEDURE [LOS_TABLATUBBIES].cargarItemFactura
DROP PROCEDURE [LOS_TABLATUBBIES].cargarStock
*/

SELECT * FROM [LOS_TABLATUBBIES].Cliente
SELECT * FROM [LOS_TABLATUBBIES].Automovil
SELECT * FROM [LOS_TABLATUBBIES].Autoparte
SELECT * FROM [LOS_TABLATUBBIES].Sucursal
SELECT * FROM [LOS_TABLATUBBIES].Caja
SELECT * FROM [LOS_TABLATUBBIES].Transmision
SELECT * FROM [LOS_TABLATUBBIES].TipoAuto
SELECT * FROM [LOS_TABLATUBBIES].TipoProducto
SELECT * FROM [LOS_TABLATUBBIES].Modelo
SELECT * FROM [LOS_TABLATUBBIES].Producto
SELECT * FROM [LOS_TABLATUBBIES].Compra
SELECT * FROM [LOS_TABLATUBBIES].ItemCompra
SELECT * FROM [LOS_TABLATUBBIES].FacturaVta
SELECT * FROM [LOS_TABLATUBBIES].ItemFactura
SELECT * FROM [LOS_TABLATUBBIES].Stock