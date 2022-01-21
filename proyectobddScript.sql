
create table comerciante(
	nombres char(20),
    apellidos char(20),
    cedula char(20) primary key
);

create table cliente(
	nombres char(20),
    cedula char(20) primary key
);

create table vende(
	cedulaComerciante char(20),
    cedulaCliente char(20),
    fechaVenta date,
    cantidad int,
    foreign key (cedulaComerciante) references comerciante(cedula),
    foreign key (cedulaCliente)references cliente(cedula)
);

create table pescador(
	nombres char(20),
    apellidos char(20),
    cedula char(20),
    codigo char(10) primary key,
    cedulaComerciante char(10),
    foreign key (cedulaComerciante) references comerciante(cedula)
);

create table panga(
	nombre char(20) primary key,
    ganacia int,
    capacidadMax float,
    codigoPescador char(10),
    foreign key (codigoPescador) references pescador(codigo)
);

create table producto(
	temporada char(20),
    peso int,
    tipo char(20),
    talla char(20),
    codigo char(10) primary key,
    estado boolean,
    codigoPescador char(10),
    cedulaCliente char(10),
    foreign key (cedulaCliente)references cliente(cedula),
    foreign key (codigoPescador) references pescador(codigo)
    
);

create table direccionP(
	callePrincipal char(30),
    calleSecundaria char(30),
    ciudad char(20),
    cedulaComerciante char(10) primary key,
    foreign key(cedulaComerciante) references comerciante(cedula)
);

create table direccionC(
	callePrincipal char(30),
    calleSecundaria char(30),
    ciudad char(20),
    cedulaCliente char(10) primary key,
    foreign key(cedulaCliente) references cliente(cedula)
);

create table permiso(
	codigo char(10) primary key,
    estado boolean,
    fechadezarpe date,
    dias int,
    tituloPropiedad char(100),
    codigoPescador char(10),
    foreign key (codigoPescador) references pescador(codigo)
);

create table material(
	codigo char(10) primary key,
    cantidad int,
    tipo char(20),
    nombre char(20),
    cedulaComerciante char(10),
    codigoPescador char(10),
    foreign key (codigoPescador) references pescador(codigo),
    foreign key (cedulaComerciante) references comerciante(cedula)
);

CREATE OR REPLACE VIEW REPORTE_PESCADORES AS
SELECT P.CEDULA AS CEDULA, concat(P.NOMBRES,' ',P.APELLIDOS) AS PESCADOR
FROM PESCADOR P;

CREATE OR REPLACE VIEW REPORTE_COMERCIANTES AS
SELECT CO.CEDULA, CONCAT(CO.NOMBRES,' ',CO.APELLIDOS) AS COMERCIANTE
FROM COMERCIANTE CO;

CREATE OR REPLACE VIEW REPORTE_CLIENTES AS
SELECT CLI.CEDULA, CLI.NOMBRES
FROM CLIENTE CLI;

CREATE OR REPLACE VIEW REPORTE_TIPOS_PRODUCTOS AS
SELECT DISTINCT PRO.TIPO, PRO.ESTADO
FROM PRODUCTO PRO;

## CONSULTA LA CANTIDAD DE PRODUCTOS QUE TIENEN LOS CLIENTES POR PESCADOR 
SELECT CLI.NOMBRES AS CLIENTE, PE.NOMBRES AS PESCADOR, COUNT(1) AS PRODUCTOS_COMPRADOS
FROM CLIENTE CLI,
     PRODUCTO PRO,
     PESCADOR PE
WHERE CLI.CEDULA = PRO.CEDULACLIENTE
AND   PRO.CODIGOPESCADOR = PE.CODIGO
GROUP BY CLI.CEDULA, CLI.NOMBRES, PE.CODIGO, PE.NOMBRES, PE.APELLIDOS;

## CONSULTA CUANTAS VENTAS SE HAN REALIZADO POR CLIENTE Y POR COMERCIANTE
SELECT CLI.NOMBRES AS CLIENTE, CO.NOMBRES AS COMERCIANTE, COUNT(1) AS VENTAS
FROM CLIENTE CLI,
     VENDE VE,
     COMERCIANTE CO
WHERE CLI.CEDULA = VE.CEDULACLIENTE
AND   VE.CEDULACOMERCIANTE = CO.CEDULA
GROUP BY CLI.CEDULA, CLI.NOMBRES, CO.CEDULA, CO.NOMBRES, CO.APELLIDOS;

## CONSULTA CUANTOS MATERIALES HAN PEDIDO LOS PESCADORES POR COMERCIANTE
SELECT CO.NOMBRES AS COMERCIANTE, PE.NOMBRES AS PESCADOR, SUM(MA.CANTIDAD) AS MATERIALES
FROM COMERCIANTE CO,
     MATERIAL MA,
     PESCADOR PE
WHERE CO.CEDULA = MA.CEDULACOMERCIANTE
AND   MA.CODIGOPESCADOR = PE.CODIGO
GROUP BY CO.CEDULA, CO.NOMBRES, PE.CODIGO, PE.NOMBRES, PE.APELLIDOS;

## CONSULTA CUANTOS MATERIALES HAN PEDIDO LOS PESCADORES POR COMERCIANTE
SELECT CO.NOMBRES AS COMERCIANTE, PE.NOMBRES AS PESCADOR, SUM(MA.CANTIDAD) AS MATERIALES
FROM COMERCIANTE CO,
     MATERIAL MA,
     PESCADOR PE
WHERE CO.CEDULA = MA.CEDULACOMERCIANTE
AND   MA.CODIGOPESCADOR = PE.CODIGO
GROUP BY CO.CEDULA, CO.NOMBRES, PE.CODIGO, PE.NOMBRES, PE.APELLIDOS;

##CUALES SON LOS COMENRCIANTES QUE TRABAJAN CON PESCADORES QUE TIENE UN PESCADOR COMO OFICIAL, 
##ADICIONALMENTE MUESTRE EL NOMBRE DE SU PANGA
## CONSULTA CUANTOS MATERIALES HAN PEDIDO LOS PESCADORES POR COMERCIANTE
SELECT CO.NOMBRES AS COMERCIANTE, PE.NOMBRES AS PESCADOR, PA.NOMBRE
FROM COMERCIANTE CO,
     PESCADOR PE,
     PANGA PA
WHERE PE.CEDULACOMERCIANTE = CO.CEDULA
AND   PE.CODIGO = PA.CODIGOPESCADOR
AND   PE.CODIGOPESCADOR IS NOT NULL;
