

-- 1. Crear el distribuidor.





USE [master];

DECLARE @distributor SYSNAME;
SELECT @distributor = @@SERVERNAME;

EXEC sp_adddistributor @distributor = @distributor, @password = N'CORP_2025*';
GO
EXEC sp_adddistributiondb 
    @database = N'distribution', 
    @data_folder = N'/var/opt/mssql/Data', 
    @log_folder = N'/var/opt/mssql/Data', 
    @log_file_size = 2, 
    @min_distretention = 0, 
    @max_distretention = 72, 
    @history_retention = 48, 
    @deletebatchsize_xact = 5000, 
    @deletebatchsize_cmd = 2000, 
    @security_mode = 1
;
GO

-- 2. Crear publicador.

USE [distribution];

IF (NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'UIProperties' AND type = 'U ')) 
    CREATE TABLE UIProperties(id INT) 
IF (EXISTS (SELECT * FROM ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', NULL, NULL))) 
    EXEC sp_updateextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';
ELSE 
    EXEC sp_addextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';
GO

DECLARE @publisher SYSNAME;
SELECT @publisher = @@SERVERNAME;

EXEC sp_adddistpublisher 
	@publisher = @publisher, 
	@distribution_db = N'distribution', 
	@security_mode = 0, 
	@login = N'sa', 
	@password = N'CORP_2025*', 
	@working_directory = N'/var/opt/mssql/ReplData', 
	@trusted = N'false', 
	@thirdparty_flag = 0, 
	@publisher_type = N'MSSQLSERVER'
;
GO


-- 3. Crear la publicaión desde el Wizard.



-- 4. Agregar la base subscriptora a la publicación.


USE [Corporativo];
EXEC sp_addsubscription 
	@publication = N'Repl-Corp-WWI', 
	@subscriber = '172.20.0.11', 
	@destination_db = N'Sucursal_SJ', 
	@subscription_type = N'Push',
	@sync_type = N'replication support only',
	@article = N'all', @update_mode = N'read only',
	@subscriber_type = 0
;

EXEC sp_addpushsubscription_agent 
	@publication = N'Repl-Corp-WWI', 
	@subscriber = '172.20.0.11', 
	@subscriber_db = N'Sucursal_SJ', 
	@subscriber_login = N'sa',
    @subscriber_password = N'SJ_2025*',
	@subscriber_security_mode = 0, 
	@frequency_type = 64, 
	@frequency_interval = 0,
	@frequency_relative_interval = 0,
	@frequency_recurrence_factor = 0, 
	@frequency_subday = 0, 
	@frequency_subday_interval = 0,
	@active_start_time_of_day = 0,
	@active_end_time_of_day = 235959, 
	@active_start_date = 20241023,
	@active_end_date = 99991231,
	@enabled_for_syncmgr = N'False',
	@dts_package_location = N'Distributor'
;
GO

EXEC sp_addsubscription 
	@publication = N'Repl-Corp-WWI', 
	@subscriber = '172.20.0.12', 
	@destination_db = N'Sucursal_LI', 
	@subscription_type = N'Push',
	@sync_type = N'replication support only',
	@article = N'all', @update_mode = N'read only',
	@subscriber_type = 0
;

EXEC sp_addpushsubscription_agent 
	@publication = N'Repl-Corp-WWI', 
	@subscriber = '172.20.0.12', 
	@subscriber_db = N'Sucursal_LI', 
	@subscriber_login = N'sa',
    @subscriber_password = N'LI_2025*',
	@subscriber_security_mode = 0, 
	@frequency_type = 64, 
	@frequency_interval = 0,
	@frequency_relative_interval = 0,
	@frequency_recurrence_factor = 0, 
	@frequency_subday = 0, 
	@frequency_subday_interval = 0,
	@active_start_time_of_day = 0,
	@active_end_time_of_day = 235959, 
	@active_start_date = 20241023,
	@active_end_date = 99991231,
	@enabled_for_syncmgr = N'False',
	@dts_package_location = N'Distributor'
;
GO

--SIN TAMAÑO MAXIMO DE REPLICACION
EXEC sp_configure 'max text repl size', -1;
RECONFIGURE;


-- 5. Agregar el nodo al diagrama Peer-to-Peer.


-- 6. Agregar la base de datos inicial como subscriptora.




--INVENTARIO Y FACTURACION

EXEC sp_addpushsubscription_agent 
	@publication = N'Repl-Corp-WWI2', 
	@subscriber = '172.20.0.11', 
	@subscriber_db = N'Sucursal_SJ', 
	@subscriber_login = N'sa',
    @subscriber_password = N'SJ_2025*',
	@subscriber_security_mode = 0, 
	@frequency_type = 64, 
	@frequency_interval = 0,
	@frequency_relative_interval = 0,
	@frequency_recurrence_factor = 0, 
	@frequency_subday = 0, 
	@frequency_subday_interval = 0,
	@active_start_time_of_day = 0,
	@active_end_time_of_day = 235959, 
	@active_start_date = 20241023,
	@active_end_date = 99991231,
	@enabled_for_syncmgr = N'False',
	@dts_package_location = N'Distributor'
;
GO

EXEC sp_addsubscription 
	@publication = N'Repl-Corp-WWI2', 
	@subscriber = '172.20.0.12', 
	@destination_db = N'Sucursal_LI', 
	@subscription_type = N'Push',
	@sync_type = N'replication support only',
	@article = N'all', @update_mode = N'read only',
	@subscriber_type = 0
;

EXEC sp_addpushsubscription_agent 
	@publication = N'Repl-Corp-WWI', 
	@subscriber = '172.20.0.12', 
	@subscriber_db = N'Sucursal_LI', 
	@subscriber_login = N'sa',
    @subscriber_password = N'LI_2025*',
	@subscriber_security_mode = 0, 
	@frequency_type = 64, 
	@frequency_interval = 0,
	@frequency_relative_interval = 0,
	@frequency_recurrence_factor = 0, 
	@frequency_subday = 0, 
	@frequency_subday_interval = 0,
	@active_start_time_of_day = 0,
	@active_end_time_of_day = 235959, 
	@active_start_date = 20241023,
	@active_end_date = 99991231,
	@enabled_for_syncmgr = N'False',
	@dts_package_location = N'Distributor'
;
GO