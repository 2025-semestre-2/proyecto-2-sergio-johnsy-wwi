-- Desde cada nodo
EXEC sp_addlinkedserver @server = N'LIMON', @srvproduct = N'SQL Server';
EXEC sp_addlinkedserver @server = N'SANJOSE', @srvproduct = N'SQL Server';

EXEC sp_addlinkedsrvlogin @rmtsrvname = N'LIMON', @useself = N'false', @locallogin = NULL, @rmtuser = N'sa', @rmtpassword = N'LI_2025*';
EXEC sp_addlinkedsrvlogin @rmtsrvname = N'SANJOSE', @useself = N'false', @locallogin = NULL, @rmtuser = N'sa', @rmtpassword = N'SJ_2025*';

-- En el nodo que será distribuidor
USE [master];
DECLARE @distributor SYSNAME = @@SERVERNAME;
DECLARE @password SYSNAME = N'CORP_2025*';

EXEC sp_adddistributor @distributor = @distributor, @password = @password;

EXEC sp_adddistributiondb 
    @database = N'distribution', 
    @data_folder = N'/var/opt/mssql/data', 
    @log_folder = N'/var/opt/mssql/data', 
    @security_mode = 1;

go

USE [distribution];
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'UIProperties' AND type = 'U ')
    CREATE TABLE UIProperties(id INT);
IF EXISTS (SELECT * FROM ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', NULL, NULL))
    EXEC sp_updateextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';
ELSE
    EXEC sp_addextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';

DECLARE @publisher SYSNAME = @@SERVERNAME;
DECLARE @password SYSNAME = N'CORP_2025*';
EXEC sp_adddistpublisher 
    @publisher = @publisher, 
    @distribution_db = N'distribution', 
    @security_mode = 0, 
    @login = N'sa', 
    @password = @password,
    @working_directory = N'/var/opt/mssql/ReplData', 
    @trusted = N'false', 
    @publisher_type = N'MSSQLSERVER';

-- 6. Desde el nodo que creó la publicación

USE [Corporativo];
EXEC sp_helppublication;

EXEC sp_addsubscription 
    @publication = N'RepliCorp', 
    @subscriber = N'LIMON', 
    @destination_db = N'Sucursal_LI', 
    @subscription_type = N'Push', 
    @sync_type = N'replication support only', 
    @article = N'all', 
    @update_mode = N'read only', 
    @subscriber_type = 0;

EXEC sp_addpushsubscription_agent 
    @publication = N'RepliCorp', 
    @subscriber = N'LIMON', 
    @subscriber_db = N'Sucursal_LI', 
    @subscriber_security_mode = 1;

-- Suscriptor: CORP
EXEC sp_addsubscription 
    @publication = N'RepliCorp', 
    @subscriber = N'SANJOSE', 
    @destination_db = N'Sucursal_SJ', 
    @subscription_type = N'Push', 
    @sync_type = N'replication support only', 
    @article = N'all', 
    @update_mode = N'read only', 
    @subscriber_type = 0;

EXEC sp_addpushsubscription_agent 
    @publication = N'RepliCorp', 
    @subscriber = N'SANJOSE', 
    @subscriber_db = N'Sucursal_SJ', 
    @subscriber_security_mode = 1;