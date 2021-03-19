/*
	nombre: Jose Alberto Sanchez Nava
    Sistema: Rinko
*/
drop database desarrolloApp; 
create database desarrolloApp;
use desarrolloApp;

create table TipoEmpleados(
idTipoEmpleado int not null primary key,
tipoDescripcion varchar(80) not null
);

  insert into TipoEmpleados(idTipoEmpleado,tipoDescripcion)values(1,'Interno');
  insert into TipoEmpleados(idTipoEmpleado,tipoDescripcion)values(2,'Externo');

 
-- select * from TipoEmpleados;
Create table Roles(
idRol int not null primary key  auto_increment,
descripcionRol varchar(60) not null,
idTipoRol int not null,
foreign key(idTipoRol) references TipoEmpleados(idTipoEmpleado)
);

-- select * from Roles;

insert into Roles(descripcionRol,idTipoRol)values('Chofer',1);
insert into Roles(descripcionRol,idTipoRol)values('Cargador',1);
insert into Roles(descripcionRol,idTipoRol)values('Auxiliar',1);

-- select * from Roles;

create table Empleados(
	idEmpleado INT NOT NULL primary key default 10000,
    nombreEmpleado varchar(80) not null,
    edad int not null,
    sexo varchar(6) not null,
    idRolEmpleado int not null,
    idTipoEmpleado int not null,
    statusEmpleado int not null,
    jornadaLaboral int default 8,
    foreign key(idRolEmpleado) references Roles(idRol),
    foreign key(idTipoEmpleado) references TipoEmpleados(idTipoEmpleado)
);


create table Sueldos(
idSueldBase int not null auto_increment,
idEmpleado int not null,
sueldoBaseHora double default 0.00,
pagoXEntrega double default 0.00,
bonoHora  double default 0.00,
valeDespensa int,
sueldoBase double default 0.00,
ISRRetencion int not null default 9,
ISRAdicional int not  null default 0,
primary key (idSueldBase,idEmpleado),
foreign key(idEmpleado) references Empleados(idEmpleado)
);


create table movimientos
(
	idMovimientos int not null primary key auto_increment,
    idEmpleado int not null ,
    nombreEmpleado varchar(80),
    totalEntregasDiaria int,
    subTotalEntregaDiaria double default 0.00,
    subTotalBonoHora double default 0.00,
	subTotalSueldoDiario double default 0.00,
    fechaCaptura date,
    turno int not null
);


create table nominamensual(
idnominamensual int not null primary key auto_increment,
idEmpleado int not null,
Ingresos double not null default 0.00,
Deducciones double default 0.00,
SueldoMensual double default 0.00 
);




USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_registra_empleado`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_registra_empleado`(in pIdEmpleado int, in pNombreEmpleado varchar(80),in pEdad int ,in pSexo varchar(8),in pRolEmpleado int,in pTipoEmpleado int,
in pSueldoBaseHora double,in pPagoXEntrega double, in pBonoHora double, in pValeDespensa double,in pSueldoBase double,
 out codigoRespuesta char(5), out mensaje varchar(60))
BEGIN

insert into Empleados(idEmpleado,nombreEmpleado,edad,sexo,idRolEmpleado,idTipoEmpleado,statusEmpleado) 
values(pIdEmpleado,pNombreEmpleado,pEdad,pSexo,pRolEmpleado,pTipoEmpleado,1);

insert into Sueldos(idEmpleado,sueldoBaseHora,pagoXEntrega,bonoHora,valeDespensa,sueldoBase,ISRRetencion,ISRAdicional)
values(pIdEmpleado,pSueldoBaseHora,pPagoXEntrega,pBonoHora,pValeDespensa,pSueldoBase,9,3);

set codigoRespuesta='00000';
set mensaje='registro exitoso';
END$$
DELIMITER ;


USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_consulta_num_emp`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_consulta_num_emp`(out NumEmpleado int, out codigoRespuesta char(5))
BEGIN
declare NumEmp int;

select max(idEmpleado)  into NumEmp
from Empleados;

set codigoRespuesta='00000';
set NumEmpleado=NumEmp;
END$$
DELIMITER ;

-- CALL `desarrolloapp`.`sp_consulta_num_emp`(@NumEmpleado,@codigoRespuesta);

-- CALL `desarrolloapp`.`spalta`('JOSE MEDINA M', 25, 'h', 1,1,@codigoRespuesta ,@mensaje);

USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_actualiza_empleado`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_actualiza_empleado`(in pIdEmpleado int, in pRolEmpleado int, 
										in pTipoEmpleado int, in pSueldoBaseHora double , 
                                        in pPagoXEntrega double, in pBonoHora double,
                                        in pValeDespensa double,in pSueldoBase double,
                                        out codigoRespuesta char(5), out mensaje varchar(60))
BEGIN

update Empleados set idRolEmpleado=pRolEmpleado,idTipoEmpleado=pTipoEmpleado
where idEmpleado=pIdEmpleado;

update Sueldos set sueldoBaseHora=pSueldoBaseHora,pagoXEntrega=pPagoXEntrega,
		bonoHora=pBonoHora,valeDespensa=pValeDespensa,sueldoBase=pSueldoBase
where idEmpleado=pIdEmpleado;

set codigoRespuesta='00000';
set mensaje="Actualizacion de datos Correctamente";
END$$
DELIMITER ;

-- CALL `desarrolloapp`.`sp_actualiza_empleado`(10009,'JOSE MEDINA MEDINA', 3,1,40.00,10.00,9600.00,@codigoRespuesta ,@mensaje);



USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_baja_empleado`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_baja_empleado`(in pIdEmpleado int ,out codigoRespuesta char(5), out mensaje varchar(60))
BEGIN

update Empleados set statusEmpleado=0
where idEmpleado=pIdEmpleado;

set codigoRespuesta='00000';
set mensaje="se dio de baja correctamente";
END$$
DELIMITER ;


-- CALL `desarrolloapp`.`sp_baja_empleado`(10001,@codigoRespuesta ,@mensaje);



USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_consulta_empleado`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_consulta_empleado`() 
BEGIN

select emp.idEmpleado,emp.nombreEmpleado,emp.edad,emp.sexo,rol.descripcionRol,tp.tipoDescripcion from empleados
as emp, Roles as rol, TipoEmpleados as tp
where emp.idRolEmpleado=rol.idRol
and emp.idTipoEmpleado=tp.idTipoEmpleado
and emp.statusEmpleado=1
order by emp.idEmpleado;

END$$
DELIMITER ;


-- CALL `desarrolloapp`.`sp_consulta_empleado`();



USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_registra_movimientos`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_registra_movimientos`(in pIdEmpleado int, in pNombreEmpleado varchar(80),in pEntregasDiaria int ,in pFecha datetime, in pTurno int,
 out codigoRespuesta char(5), out mensaje varchar(60))
BEGIN
declare subTotalPagoXEntrega double;
declare pagoXEntrega double;
declare subTotalBonoDiario double;
declare bono double;
declare jornada int ;
declare sueldoBaseHora double;
declare sueldoBaseDiario double;
declare subTotalSueldo double;
 
select sd.pagoXEntrega,sd.bonoHora,emp.jornadaLaboral,sd.sueldoBaseHora into pagoXEntrega,bono, jornada,sueldoBaseHora from sueldos as sd, empleados as emp
where sd.idEmpleado=pIdEmpleado
and sd.idEmpleado=emp.idempleado
and emp.idEmpleado=sd.idEmpleado;

-- calcular subTotalEntregaDiaria
set subTotalPagoXEntrega=pEntregasDiaria*PagoXEntrega;
-- calcular subTotalBono
set subTotalBonoDiario=bono*jornada;
-- calcular sueldo diario
set sueldoBaseDiario=sueldoBaseHora * jornada;

set subTotalSueldo= sueldoBaseDiario+subTotalPagoXEntrega+subTotalBonoDiario;
-- calcular sueldo diario
insert into Movimientos(idEmpleado,nombreEmpleado,totalEntregasDiaria,subTotalEntregaDiaria,subTotalBonoHora,subTotalSueldoDiario,fechaCaptura,turno)
values(pIdEmpleado,pNombreEmpleado,pEntregasDiaria,subTotalPagoXEntrega,subTotalBonoDiario,subTotalSueldo,pFecha,pTurno);

set codigoRespuesta='00000';
set mensaje='registro exitoso';
END$$
DELIMITER ;


 -- CALL `desarrolloapp`.`sp_registra_movimientos`(10001,'JOSE',5,current_date(),1,@codigoRespuesta ,@mensaje);
 

 -- CALL `desarrolloapp`.`sp_consulta_movimientos`(10003);

USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_consulta_movimientos`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_consulta_movimientos`(in Id_Empleado int)
BEGIN

select mov.idMovimientos,emp.idEmpleado,emp.nombreEmpleado,mov.subTotalEntregaDiaria,mov.subTotalBonoHora,mov.subTotalSueldoDiario,mov.fechaCaptura from empleados
as emp, movimientos as mov
where emp.idEmpleado=Id_Empleado
and emp.statusEmpleado=1
and emp.idEmpleado=mov.idEmpleado
order by emp.idEmpleado;

END$$
DELIMITER ;



USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_eliminar_movimiento`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_eliminar_movimiento`(in pIdMovimiento int, in pIdEmpleado int ,out codigoRespuesta char(5), out mensaje varchar(60))
BEGIN

delete from movimientos 
where idMovimientos=pIdMovimiento
and idEmpleado=pIdEmpleado;

set codigoRespuesta='00000';
set mensaje="Se elimino el movimiento correctamente";
END$$
DELIMITER ;



USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_consultar_reporte_nomina`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_consultar_reporte_nomina`(in pIdEmpleado int,out numEmpleado int, out nombreEmpleado varchar(80),
												out ingresos double,out deducciones double, out totalPagarEmpleado double)
BEGIN
declare empleado int;
declare nombre varchar(80);
declare despensa double;
declare totalDespensa double;
declare subTotalRetencion double;

declare sueldo double;
declare sueldoMensualEmpleado double;
declare isrRetencion double;
declare isrAdicional double;
declare subTotalSueldo double;
declare montoMax double;
declare totalPagar double;
declare totalISR double;
--  select * from sueldos
set montoMax=16000.00;

SELECT 
    mov.idEmpleado,
    mov.nombreEmpleado,
    sd.valeDespensa,
    sd.ISRRetencion,
    sd.ISRAdicional,
    SUM(sd.sueldoBase) 
INTO empleado , nombre , despensa , isrRetencion , isrAdicional , sueldo FROM
    movimientos AS mov,
    sueldos AS sd
WHERE
    mov.idEmpleado = pIdEmpleado
        AND mov.idEmpleado = sd.idEmpleado;

-- calcular ingreso
set totalDespensa=(despensa/100) * sueldo;

set ingresos=sueldo+totalDespensa;
IF sueldo < montoMax THEN 
	set isrAdicional=0.00;
ELSE
	set isrAdicional=3.00;
END IF;

-- calcular deduccion.
set subTotalRetencion= ((isrRetencion+isrAdicional)/100)* sueldo;

-- calcular sueldo mensual empleado

set deducciones=subTotalRetencion;

set subTotalSueldo= (sueldo-deducciones)+totalDespensa ;
-- set totalPagar= totalDespensa;

set totalPagarEmpleado= subTotalSueldo;

insert into nominamensual(idEmpleado,Ingresos,Deducciones,SueldoMensual)
values(pIdEmpleado,ingresos,deducciones,totalPagarEmpleado);


set numEmpleado=pIdEmpleado;
set nombreEmpleado=nombre;

END$$
DELIMITER ;