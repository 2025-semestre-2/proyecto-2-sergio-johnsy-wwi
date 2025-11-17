-- 1. LINKED SERVERS 
EXEC sp_addlinkedserver @server = N'CORP', @srvproduct = N'SQL Server';
EXEC sp_addlinkedserver @server = N'SANJOSE', @srvproduct = N'SQL Server';

EXEC sp_addlinkedsrvlogin @rmtsrvname = N'CORP', @useself = N'false', @locallogin = NULL, @rmtuser = N'sa', @rmtpassword = N'CORP_2025*';
EXEC sp_addlinkedsrvlogin @rmtsrvname = N'SANJOSE', @useself = N'false', @locallogin = NULL, @rmtuser = N'sa', @rmtpassword = N'SJ_2025*';


-- 2. CREAR EL DISTRIBUIDOR
USE [master];
DECLARE @distributor SYSNAME = @@SERVERNAME;
DECLARE @password SYSNAME = N'LI_2025*';

EXEC sp_adddistributor @distributor = @distributor, @password = @password;

EXEC sp_adddistributiondb 
    @database = N'distribution', 
    @data_folder = N'/var/opt/mssql/data', 
    @log_folder = N'/var/opt/mssql/data', 
    @security_mode = 1;

GO
--3. CONFIGURAR CARPETA DE SNAPSHOTS
USE [distribution];
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'UIProperties' AND type = 'U ')
    CREATE TABLE UIProperties(id INT);
IF EXISTS (SELECT * FROM ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', NULL, NULL))
    EXEC sp_updateextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';
ELSE
    EXEC sp_addextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';

GO
--4. CONFIGURAR EL PUBLICADOR
DECLARE @publisher SYSNAME = @@SERVERNAME;
DECLARE @password SYSNAME = N'LI_2025*';
EXEC sp_adddistpublisher 
    @publisher = @publisher, 
    @distribution_db = N'distribution', 
    @security_mode = 0, 
    @login = N'sa', 
    @password = @password,
    @working_directory = N'/var/opt/mssql/ReplData', 
    @trusted = N'false', 
    @publisher_type = N'MSSQLSERVER';

-- 5. CREAR LA PUBLICACION EN SSMS

-- 6.AGREGAR LAS SUSCRIPCIONES AL NODO ACTUAL
-- Suscriptor: SANJOSE

EXEC sp_addsubscription 
    @publication = N'RepliLI', 
    @subscriber = N'SANJOSE', 
    @destination_db = N'Sucursal_SJ', 
    @subscription_type = N'Push', 
    @sync_type = N'replication support only', 
    @article = N'all', 
    @update_mode = N'read only', 
    @subscriber_type = 0;

EXEC sp_addpushsubscription_agent 
    @publication = N'RepliLI', 
    @subscriber = N'SANJOSE', 
    @subscriber_db = N'Sucursal_SJ', 
    @subscriber_security_mode = 1;

-- Suscriptor: CORP
EXEC sp_addsubscription 
    @publication = N'RepliLI', 
    @subscriber = N'CORP', 
    @destination_db = N'Corporativo', 
    @subscription_type = N'Push', 
    @sync_type = N'replication support only', 
    @article = N'all', 
    @update_mode = N'read only', 
    @subscriber_type = 0;

EXEC sp_addpushsubscription_agent 
    @publication = N'RepliLI', 
    @subscriber = N'CORP', 
    @subscriber_db = N'Corporativo', 
    @subscriber_security_mode = 1;

GO

-- 7. AGREGAR LOS PEERS
USE [Sucursal_LI]



