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
    sexo char(1) not null,
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
    fechaCaptura datetime,
    turno int not null
);

create table ingresos(
idIngresos int not null primary key,
idEmpleado int not null,
subTotalDiario double default 0.00,
despensa int default 4 
);

create table retencion(
idRetencion int not null primary key,
idEmpleado int not null,
ISRRetencion int not null default 9,
ISRAdicional int not  null default 4
);

create table nomina(
idNomina int not null primary key,
idEmpleado int not null,
sueldo double  not null default 0.00,
totalDespensa double not null default 0.00,
ISRImporte double not null default 0.00,
subtotal double not null  default 0.00,
totalPagar double not null  default 0.00 
);




USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_registra_empleado`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_registra_empleado`(in pIdEmpleado int, in pNombreEmpleado varchar(80),in pEdad int ,in pSexo char(1),in pRolEmpleado int,in pTipoEmpleado int,
in pSueldoBaseHora double,in pPagoXEntrega double, in pBonoHora double, in pValeDespensa double,in pSueldoBase double,
 out codigoRespuesta char(5), out mensaje varchar(60))
BEGIN
insert into Empleados(idEmpleado,nombreEmpleado,edad,sexo,idRolEmpleado,idTipoEmpleado,statusEmpleado) 
values(pIdEmpleado,pNombreEmpleado,pEdad,pSexo,pRolEmpleado,pTipoEmpleado,1);

insert into Sueldos(idEmpleado,sueldoBaseHora,pagoXEntrega,bonoHora,valeDespensa,sueldoBase)
values(pIdEmpleado,pSueldoBaseHora,pPagoXEntrega,pBonoHora,pValeDespensa,pSueldoBase);

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

select * from sueldos
where idempleado=10001
1	10001	30	5	10	4	7200

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
 


USE `desarrolloapp`;
DROP procedure IF EXISTS `sp_consulta_movimientos`;

DELIMITER $$
USE `desarrolloapp`$$
CREATE PROCEDURE `sp_consulta_movimientos`(in Id_Empleado int,out Movimiento int,
											out Empleado int ,out Nombre varchar(80),
                                            out SubTotalEntrega double, out SubTotalBono double,
                                            out SubTotalSueldoDiario double, out Fecha varchar(60))
BEGIN

select mov.idMovimientos,emp.idEmpleado,emp.nombreEmpleado,mov.subTotalEntregaDiaria,mov.subTotalBonoHora,mov.subTotalSueldoDiario,mov.fechaCaptura from empleados
as emp, movimientos as mov
where emp.idEmpleado=Id_Empleado
and emp.statusEmpleado=1
order by emp.idEmpleado;

END$$
DELIMITER ;





CALL `desarrolloapp`.`sp_consulta_movimientos`(10001,@Movimiento,
											 @Empleado  , @Nombre,
                                             @SubTotalEntrega ,  @SubTotalBono ,
                                             @SubTotalSueldoDiario ,  @Fecha)
 



/*
select emp.idEmpleado,emp.NombreEmpleado,sd.pagoXEntrega,sd.bonoHora,emp.jornadaLaboral,mov.subTotalBonoEntregaDiaria,
mov.subTotalBonoHora,mov.subTotalSueldoDiario  from sueldos as sd, empleados as emp, movimientos as mov
where sd.idEmpleado=10003
and sd.idEmpleado=emp.idempleado
and emp.idEmpleado=sd.idEmpleado
and emp.idEmpleado=mov.idEmpleado;

select * from movimientos
where idEmpleado=10001;

*/


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




-- CALL `desarrolloapp`.`sp_eliminar_movimiento`(1,10001,@codigoRespuesta ,@mensaje);


/*
delete from movimientos
where idMovimientos=7 and idEmpleado=10001;
*/

-- CALL `desarrolloapp`.`sp_consulta_empleado`(@Empleado,@Nombre, @Edad,@Sexo,@Rol,@Tipo);
/*

select emp.idEmpleado,emp.nombreEmpleado,emp.edad,emp.sexo,rol.descripcionRol,tp.tipoDescripcion,sd.sueldoBaseHora,sd.pagoXEntrega,sd.bonoHora,sd.valeDespensa from empleados
as emp, Roles as rol, TipoEmpleados as tp, sueldos as sd
where emp.idRolEmpleado=rol.idRol
and emp.idTipoEmpleado=tp.idTipoEmpleado
and emp.statusEmpleado=1
and emp.idEmpleado=sd.idEmpleado
order by emp.idEmpleado;
*/



/*

select su.idEmpleado,emp.nombreEmpleado,emp.sexo,rol.idRol,rol.descripcionRol,tpEmp.idTipoEmpleado ,tpEmp.tipoDescripcion, su.sueldoBase,su.bonoHora,su.valeDespensa 
from empleados as emp, sueldos as su, Roles rol, TipoEmpleados as tpEmp
where emp.idEmpleado=su.idEmpleado
and emp.idRolEmpleado=rol.idRol
and emp.idTipoEmpleado=tpEmp.idTipoEmpleado;

select emp.idEmpleado,emp.nombreEmpleado,emp.edad,emp.sexo,rol.descripcionRol,tp.tipoDescripcion from empleados
as emp, Roles as rol, TipoEmpleados as tp
where emp.idRolEmpleado=rol.idRol
and emp.idTipoEmpleado=tp.idTipoEmpleado
and emp.statusEmpleado=1
order by emp.idEmpleado;




select * from TipoEmpleados;

select * from empleados;
select * from TipoEmpleados;
select * from sueldos;

*/

select * from movimientos