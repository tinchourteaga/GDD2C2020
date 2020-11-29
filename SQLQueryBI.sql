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

---------------------------------------------------------------------------
-------------------------------Tablas de Hechos----------------------------
---------------------------------------------------------------------------

CREATE TABLE [LOS_TABLATUBBIES].BI_Hecho_Compra(
	idTiempo INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Tiempo(idTiempo),
	idCliente INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Cliente(idCliente),
	idAutoparte DECIMAL(18,0) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Autoparte(codAutoparte),
	idAutomovil NVARCHAR(50) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Automovil(nroChasis),
	idSucursal INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Sucursal(idSucursal),
	cantidad INTEGER,
	precio DECIMAL(18,2)
)

CREATE TABLE [LOS_TABLATUBBIES].BI_Hecho_Venta(
	idTiempo INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Tiempo(idTiempo),
	idCliente INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Cliente(idCliente),
	idAutoparte DECIMAL(18,0) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Autoparte(codAutoparte),
	idAutomovil NVARCHAR(50) FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Automovil(nroChasis),
	idSucursal INTEGER FOREIGN KEY REFERENCES [LOS_TABLATUBBIES].BI_Sucursal(idSucursal),
	cantidad INTEGER,
	precio DECIMAL(18,2)
)

/*
DROP TABLE [LOS_TABLATUBBIES].BI_Hecho_Venta
DROP TABLE [LOS_TABLATUBBIES].BI_Hecho_Compra

DROP TABLE [LOS_TABLATUBBIES].BI_Autoparte
DROP TABLE [LOS_TABLATUBBIES].BI_Fabricante

DROP TABLE [LOS_TABLATUBBIES].BI_Tiempo

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

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarSucursalBI
AS
BEGIN
    INSERT INTO [LOS_TABLATUBBIES].BI_Sucursal(idSucursal, direccion, mail, telefono, ciudad)
	SELECT idSucursal, direccion, mail, telefono, ciudad
	FROM [LOS_TABLATUBBIES].Sucursal
	WHERE direccion IS NOT NULL
END;
GO

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

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarHechosCompra
AS
BEGIN

    INSERT INTO [LOS_TABLATUBBIES].BI_Hecho_Compra(idAutoparte, idTiempo, idSucursal, idCliente, cantidad, precio)
	SELECT codAutoparte, idTiempo, c.sucursal, c.cliente, ic.cantidadItemCompra, ic.precioUnitario FROM [LOS_TABLATUBBIES].ItemCompra ic
	JOIN [LOS_TABLATUBBIES].BI_Autoparte ap ON ic.producto = CAST(ap.codAutoparte AS NVARCHAR(50))
	JOIN [LOS_TABLATUBBIES].Compra c ON ic.nroCompra = c.nroCompra
	JOIN [LOS_TABLATUBBIES].BI_Tiempo t ON MONTH(c.fecha) = t.mes AND  YEAR(c.fecha) = t.anio


	INSERT INTO [LOS_TABLATUBBIES].BI_Hecho_Compra(idAutomovil, idTiempo, idSucursal, idCliente, cantidad, precio)
	SELECT nroChasis, idTiempo, c.sucursal, c.cliente, ic.cantidadItemCompra, ic.precioUnitario FROM [LOS_TABLATUBBIES].ItemCompra ic
	JOIN [LOS_TABLATUBBIES].BI_Automovil a ON ic.producto = a.nroChasis
	JOIN [LOS_TABLATUBBIES].Compra c ON ic.nroCompra = c.nroCompra
	JOIN [LOS_TABLATUBBIES].BI_Tiempo t ON MONTH(c.fecha) = t.mes AND  YEAR(c.fecha) = t.anio

END;
GO

CREATE PROCEDURE [LOS_TABLATUBBIES].cargarHechosVenta
AS
BEGIN

    INSERT INTO [LOS_TABLATUBBIES].BI_Hecho_Venta(idAutoparte, idTiempo, idSucursal, idCliente, cantidad, precio)
	SELECT codAutoparte, idTiempo, fv.sucursal, fv.cliente, i.cantidadItemFactura, i.precioUnitario FROM [LOS_TABLATUBBIES].ItemFactura i
	JOIN [LOS_TABLATUBBIES].BI_Autoparte ap ON i.producto = CAST(ap.codAutoparte AS NVARCHAR(50))
	JOIN [LOS_TABLATUBBIES].FacturaVta fv ON i.nroFactura = fv.nroFactura
	JOIN [LOS_TABLATUBBIES].BI_Tiempo t ON MONTH(fv.fecha) = t.mes AND  YEAR(fv.fecha) = t.anio


	INSERT INTO [LOS_TABLATUBBIES].BI_Hecho_Venta(idAutomovil, idTiempo, idSucursal, idCliente, cantidad, precio)
	SELECT nroChasis, idTiempo, fv.sucursal, fv.cliente, i.cantidadItemFactura, i.precioUnitario FROM [LOS_TABLATUBBIES].ItemFactura i
	JOIN [LOS_TABLATUBBIES].BI_Automovil a ON i.producto = a.nroChasis
	JOIN [LOS_TABLATUBBIES].FacturaVta fv ON i.nroFactura = fv.nroFactura
	JOIN [LOS_TABLATUBBIES].BI_Tiempo t ON MONTH(fv.fecha) = t.mes AND  YEAR(fv.fecha) = t.anio

END;
GO

EXEC [LOS_TABLATUBBIES].cargarClienteBI
EXEC [LOS_TABLATUBBIES].cargarSucursalBI
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

EXEC [LOS_TABLATUBBIES].cargarHechosCompra
EXEC [LOS_TABLATUBBIES].cargarHechosVenta


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
DROP PROCEDURE [LOS_TABLATUBBIES].cargarAutomovilBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarTiempoBI
DROP PROCEDURE [LOS_TABLATUBBIES].cargarHechosCompra
DROP PROCEDURE [LOS_TABLATUBBIES].cargarHechosVenta