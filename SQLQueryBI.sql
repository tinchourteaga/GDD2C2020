---------------------------------------------------------------------------
-------------------------------Dimensiones---------------------------------
---------------------------------------------------------------------------

CREATE TABLE [LOS_TABLATUBBIES].BI_Fabricante(
	idFabricante INTEGER NOT NULL IDENTITY PRIMARY KEY,
	fabricante NVARCHAR(255)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_Autoparte(
	codAutoparte DECIMAL(18,0) NOT NULL PRIMARY KEY,
	idFabricante INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Fabricante(idFabricante),
	descripcion NVARCHAR(255)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_Tiempo(
	idTiempo INTEGER NOT NULL IDENTITY PRIMARY KEY,
	mes INTEGER,
	anio INTEGER
)

CREATE TABLE [LOS_TABLATUBBIES].BI_Sucursal(
	idSucursal INTEGER NOT NULL PRIMARY KEY,
	direccion NVARCHAR(255),
	mail NVARCHAR(255),
	telefono INTEGER,
	ciudad NVARCHAR(255)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_Stock(
	producto NVARCHAR(50),
	cantidadStock INTEGER,
	sucursal INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Sucursal(idSucursal),
	CONSTRAINT stock_pk_compuesta_BI PRIMARY KEY (producto, sucursal)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_ItemCompra(
	idItemCompra INTEGER NOT NULL IDENTITY PRIMARY KEY,
	producto  NVARCHAR(50),
	fecha DATETIME,
	sucursal INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Sucursal(idSucursal),
	precioUnitario DECIMAL(12,2),
	cantidadItemCompra INTEGER
)

CREATE TABLE [LOS_TABLATUBBIES].BI_CantidadCambios(
	idCantCambios INTEGER NOT NULL PRIMARY KEY,
	cantidad INTEGER
)

CREATE TABLE [LOS_TABLATUBBIES].BI_TipoCajaCambios(
	codCaja DECIMAL(18,0) NOT NULL PRIMARY KEY,
	idCantCambiso INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_CantidadCambios(idCantCambios),
	descCaja NVARCHAR(255)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_Potencia(
	idPotencia INTEGER NOT NULL IDENTITY PRIMARY KEY,
	potencia DECIMAL(18,0)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_TipoMotor(
	codTipoMotor INTEGER NOT NULL IDENTITY PRIMARY KEY,
	tipoMotor VARCHAR(25)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_TipoTransmision(
	codTransmision DECIMAL(18,0) NOT NULL PRIMARY KEY,
	descTransmision NVARCHAR(255)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_TipoAutomovil(
	codTipoAuto DECIMAL(18,0) NOT NULL PRIMARY KEY,
	descripcion NVARCHAR(255)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_Modelo(
	codModelo DECIMAL(18,0) NOT NULL PRIMARY KEY,
	idPotencia INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Potencia(idPotencia),
	codTipoMotor INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_TipoMotor(codTipoMotor),
	codCaja DECIMAL(18,0) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_TipoCajaCambios(codCaja),
	codTransmision DECIMAL(18,0) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_TipoTransmision(codTransmision),
	codTipoAuto DECIMAL(18,0) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_TipoAutomovil(codTipoAuto),
	nombre NVARCHAR(255)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_Automovil(
	nroChasis NVARCHAR(50) NOT NULL PRIMARY KEY,
	codModelo DECIMAL(18,0) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Modelo(codModelo),
	patente NVARCHAR(50),
	nroMotor NVARCHAR(50),
	fechaAlta DATETIME2(3),
	cantKM DECIMAL(18,0)
)


CREATE TABLE [LOS_TABLATUBBIES].BI_Cliente(
	idCliente INTEGER NOT NULL IDENTITY PRIMARY KEY,
	nombre NVARCHAR(255),
	apellido NVARCHAR(255),
	direccion NVARCHAR(255),
	dni DECIMAL(18,0),
	mail NVARCHAR(255),
	fechaNac DATETIME2(3),
	edad INTEGER,
	sexo CHAR(1)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_ItemVenta(
	idItemVenta INTEGER NOT NULL IDENTITY PRIMARY KEY,
	fecha DATETIME,
	sucursal INTEGER,
	precioUnitario DECIMAL(12,2),
	cantidadItemVenta INTEGER,
	producto NVARCHAR(50)
)


---------------------------------------------------------------------------
-------------------------------Tablas de Hechos----------------------------
---------------------------------------------------------------------------

CREATE TABLE [LOS_TABLATUBBIES].BI_Hecho_Compra(
	idTiempo INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Tiempo(idTiempo),
	idCliente INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Cliente(idCliente),
	idAutoparte DECIMAL(18,0) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Autoparte(codAutoparte),
	idAutomovil NVARCHAR(50) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Automovil(nroChasis),
	idItemCompra INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_ItemCompra(idItemCompra),
	cantidadAutomoviles INTEGER,
	cantidadAutopartes INTEGER,
	precioPromAutomoviles DECIMAL(18,2),
	precioPromAutopartes DECIMAL(18,2)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_Hecho_Venta(
	idTiempo INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Tiempo(idTiempo),
	idCliente INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Cliente(idCliente),
	idAutoparte DECIMAL(18,0) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Autoparte(codAutoparte),
	idAutomovil NVARCHAR(50) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Automovil(nroChasis),
	idItemVenta INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_ItemVenta(idItemVenta),
	cantidadAutomoviles INTEGER,
	cantidadAutopartes INTEGER,
	precioPromAutomoviles DECIMAL(18,2),
	precioPromAutopartes DECIMAL(18,2)
)

/*
DROP TABLE [LOS_TABLATUBBIES].BI_Hecho_Venta
DROP TABLE [LOS_TABLATUBBIES].BI_Hecho_Compra

DROP TABLE [LOS_TABLATUBBIES].BI_Autoparte
DROP TABLE [LOS_TABLATUBBIES].BI_Fabricante

DROP TABLE [LOS_TABLATUBBIES].BI_Tiempo

DROP TABLE [LOS_TABLATUBBIES].BI_ItemVenta
DROP TABLE [LOS_TABLATUBBIES].BI_ItemCompra
DROP TABLE [LOS_TABLATUBBIES].BI_Stock
DROP TABLE [LOS_TABLATUBBIES].BI_Sucursal

DROP TABLE [LOS_TABLATUBBIES].BI_Cliente

DROP TABLE [LOS_TABLATUBBIES].BI_Automovil
DROP TABLE [LOS_TABLATUBBIES].BI_Modelo
DROP TABLE [LOS_TABLATUBBIES].BI_TipoCajaCambios
DROP TABLE [LOS_TABLATUBBIES].BI_CantidadCambios
DROP TABLE [LOS_TABLATUBBIES].BI_Potencia
DROP TABLE [LOS_TABLATUBBIES].BI_TipoMotor
DROP TABLE [LOS_TABLATUBBIES].BI_TipoTransmision
DROP TABLE [LOS_TABLATUBBIES].BI_TipoAutomovil
*/

GO

---------------------------------------------------------------------------
-------------------------------Migracion-----------------------------------
---------------------------------------------------------------------------

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarClienteBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Cliente(nombre, apellido, direccion, dni, mail, fechaNac)
	SELECT DISTINCT nombre, apellido, direccion, dni, mail, fechaNac
	FROM [LOS_TABLATUBBIES].Cliente
	WHERE dni IS NOT NULL
END;
GO
--En stand by--
/*CREATE PROCEDURE [LOS_TABLATUBBIES].cargarSucursalBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Sucursal(idSucursal, idStock ,direccion, mail, telefono, ciudad)
	SELECT *
	FROM [LOS_TABLATUBBIES].Stock stk
	JOIN [LOS_TABLATUBBIES].Sucursal s ON s.idSucursal = stk.sucursal
	WHERE direccion IS NOT NULL
END;
GO*/

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarTiempoBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Tiempo(mes, anio)
	SELECT DISTINCT MONTH(fecha) Mes, YEAR(fecha) Anio
	FROM [LOS_TABLATUBBIES].Compra
	WHERE YEAR(fecha) = 2018
	ORDER BY Anio, Mes ASC

	INSERT INTO [LOS_TABLATUBBIES].BI_Tiempo(mes, anio)
	SELECT DISTINCT MONTH(fecha) Mes, YEAR(fecha) Anio
	FROM [LOS_TABLATUBBIES].FacturaVta
	WHERE YEAR(fecha) >= 2019
	ORDER BY Anio, Mes ASC
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarFabricanteBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Fabricante(fabricante)
	SELECT DISTINCT fabricante
	FROM [LOS_TABLATUBBIES].Autoparte
	WHERE codAutoparte IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarAutoparteBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Autoparte(codAutoparte, idFabricante, descripcion)
	SELECT DISTINCT codAutoparte, idFabricante, descripcion
	FROM [LOS_TABLATUBBIES].Autoparte ap
	JOIN [LOS_TABLATUBBIES].BI_Fabricante fab ON ap.fabricante = fab.fabricante
	WHERE codAutoparte IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarTipoCajaCambiosBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_TipoCajaCambios(codCaja, descCaja)
	SELECT DISTINCT codCaja, descCaja
	FROM [LOS_TABLATUBBIES].Caja
	WHERE codCaja IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarTipoTransmisionBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_TipoTransmision(codTransmision, descTransmision)
	SELECT DISTINCT codTransmision, descTransmision
	FROM [LOS_TABLATUBBIES].Transmision
	WHERE codTransmision IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarTipoAutomovilBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_TipoAutomovil(codTipoAuto, descripcion)
	SELECT DISTINCT codTipoAuto, descripcion
	FROM [LOS_TABLATUBBIES].TipoAuto
	WHERE codTipoAuto IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarTipoMotorBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_TipoMotor(tipoMotor)
	SELECT DISTINCT codMotor codigo
	FROM [LOS_TABLATUBBIES].Modelo
	WHERE codModelo IS NOT NULL
	ORDER BY codigo ASC
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarPotenciaBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Potencia(potencia)
	SELECT DISTINCT potencia
	FROM [LOS_TABLATUBBIES].Modelo
	WHERE codModelo IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarModeloBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Modelo(codModelo, idPotencia, codTipoMotor, codCaja, codTransmision, codTipoAuto, nombre)
	SELECT codModelo, idPotencia, codTipoMotor, codCaja, codTransmision, codTipoAuto, nombre
	FROM [LOS_TABLATUBBIES].Modelo m
	JOIN [LOS_TABLATUBBIES].BI_Potencia p ON m.potencia = p.potencia
	JOIN [LOS_TABLATUBBIES].BI_TipoMotor tm ON m.codMotor = tm.tipoMotor
	WHERE codModelo IS NOT NULL
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarAutomovilBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Automovil(nroChasis, codModelo, patente, nroMotor, fechaAlta, cantKM)
	SELECT nroChasis, (SELECT codModelo FROM [LOS_TABLATUBBIES].BI_Modelo WHERE codModelo = modelo), patente, nroMotor, fechaAlta, cantKM
	FROM [LOS_TABLATUBBIES].Automovil a
	JOIN [LOS_TABLATUBBIES].Producto prod ON a.nroChasis = prod.codProducto
	WHERE nroChasis IS NOT NULL	
END;
GO

/*
	SELECT fecha, sucursal, precioUnitario, cantidadItemFactura, producto  
	FROM [LOS_TABLATUBBIES].FacturaVta fv 
	JOIN [LOS_TABLATUBBIES].ItemFactura ifac ON fv.nroFactura = ifac.nroFactura
	JOIN [LOS_TABLATUBBIES].Producto p ON ifac.producto = p.codProducto
*/
------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarItemCompraBI 
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_ItemCompra(fecha, sucursal, precioUnitario, cantidadItemCompra, producto)
	SELECT fecha, sucursal, precioUnitario, cantidadItemCompra, producto  
	FROM [LOS_TABLATUBBIES].Compra c 
	JOIN [LOS_TABLATUBBIES].ItemCompra ic ON c.nroCompra = ic.nroCompra
	JOIN [LOS_TABLATUBBIES].Producto p ON ic.producto = p.codProducto
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarItemVentaBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_ItemVenta(fecha, sucursal, precioUnitario, cantidadItemVenta, producto)
	SELECT fecha, sucursal, precioUnitario, cantidadItemFactura, producto  
	FROM [LOS_TABLATUBBIES].FacturaVta fv 
	JOIN [LOS_TABLATUBBIES].ItemFactura ifac ON fv.nroFactura = ifac.nroFactura
	JOIN [LOS_TABLATUBBIES].Producto p ON ifac.producto = p.codProducto
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarStockBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Stock(cantidadStock, sucursal, producto)
	SELECT DISTINCT cantidadStock, sucursal, producto
	FROM [LOS_TABLATUBBIES].Stock
END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarHechosCompra
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Hecho_Compra(idFabricante, idAutoparte, idItemCompra, idStock)
	SELECT idFabricante, codAutoparte, idItemCompra, idStock FROM [LOS_TABLATUBBIES].BI_Autoparte a
	JOIN [LOS_TABLATUBBIES].BI_Fabricante f ON a.codAutoparte = f.idFabricante
	JOIN [LOS_TABLATUBBIES].BI_ItemCompra ic ON CAST(a.codAutoparte AS NVARCHAR(50)) = ic.producto
	JOIN [LOS_TABLATUBBIES].BI_Stock s ON CAST(a.codAutoparte AS NVARCHAR(50)) = s.producto

	INSERT INTO [LOS_TABLATUBBIES].BI_Hecho_Compra(idAutomovil, idFabricante, idItemCompra, idStock)
	SELECT nroChasis, codModelo, codCaja, codTipoAutomovil, codPotencia, codTransmision, codMotor, idItemCompra,idStock FROM [LOS_TABLATUBBIES].BI_Automovil am
	JOIN [LOS_TABLATUBBIES].BI_ItemCompra ic ON am.nroChasis = ic.producto
	JOIN [LOS_TABLATUBBIES].BI_Modelo m ON ic.MODELO = m.codModelo
	JOIN [LOS_TABLATUBBIES].BI_Potencia pot ON m.POTENCIA = pot.idPotencia
	JOIN [LOS_TABLATUBBIES].BI_TipoAutomovil tam ON 

END;
GO


EXEC [LOS_TABLATUBBIES].cargarClienteBI
--EXEC [LOS_TABLATUBBIES].cargarSucursalBI
EXEC [LOS_TABLATUBBIES].cargarTiempoBI

EXEC [LOS_TABLATUBBIES].cargarFabricanteBI
EXEC [LOS_TABLATUBBIES].cargarAutoparteBI


EXEC [LOS_TABLATUBBIES].cargarTipoCajaCambiosBI
EXEC [LOS_TABLATUBBIES].cargarTipoTransmisionBI
EXEC [LOS_TABLATUBBIES].cargarTipoAutomovilBI
EXEC [LOS_TABLATUBBIES].cargarTipoMotorBI
EXEC [LOS_TABLATUBBIES].cargarPotenciaBI
EXEC [LOS_TABLATUBBIES].cargarModeloBI
EXEC [LOS_TABLATUBBIES].cargarAutomovilBI

EXEC [LOS_TABLATUBBIES].cargarItemCompraBI 
EXEC [LOS_TABLATUBBIES].cargarItemVentaBI
EXEC [LOS_TABLATUBBIES].cargarStockBI

EXEC [LOS_TABLATUBBIES].cargarHechosCompra

--Borrar desp estos selects
SELECT * FROM [LOS_TABLATUBBIES].BI_ItemCompra
WHERE producto = '1001'
SELECT * FROM [LOS_TABLATUBBIES].ItemCompra
SELECT * FROM [LOS_TABLATUBBIES].BI_Stock
WHERE producto = '1001'
SELECT * FROM [LOS_TABLATUBBIES].BI_ItemVenta
SELECT * FROM [LOS_TABLATUBBIES].BI_Autoparte
SELECT * FROM [LOS_TABLATUBBIES].BI_Fabricante
SELECT * FROM [LOS_TABLATUBBIES].Modelo
SELECT * FROM [LOS_TABLATUBBIES].BI_TipoMotor
SELECT * FROM [LOS_TABLATUBBIES].Transmision
SELECT * FROM [LOS_TABLATUBBIES].BI_Modelo
SELECT * FROM [LOS_TABLATUBBIES].Compra
SELECT * FROM [LOS_TABLATUBBIES].Modelo
SELECT * FROM [LOS_TABLATUBBIES].TipoAuto
SELECT * FROM [LOS_TABLATUBBIES].BI_TipoAutomovil
SELECT DISTINCT * FROM [LOS_TABLATUBBIES].BI_Potencia

DROP PROCEDURE [LOS_TABLATUBBIES].cargarClienteBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarSucursalBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarModeloBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarTipoAutomovilBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarTipoTransmisionBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarTipoCajaCambiosBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarTipoMotorBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarPotenciaBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarAutoparteBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarFabricanteBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarItemCompraBI 
DROP PROCEDURE [LOS_TABLATUBBIES].cargarItemVentaBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarAutomovilBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarStockBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarTiempoBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarHechosCompra