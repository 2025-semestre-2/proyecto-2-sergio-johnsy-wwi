use master;
GO

-- Crear datos necesarios

INSERT INTO [Corporativo].[Application].[Users] 
    (Username, HashedPassword, FullName, Active, Rol, Email, HireDate)
VALUES
    ('gerente', HASHBYTES('SHA2_256', 'abc1234'), 'Gerente', 1, 'Administrador', 'gerencia@wideworldimporters.cr', '2023-01-01'),
    ('subgerente', HASHBYTES('SHA2_256', 'wwipassw'), 'Subgerente', 1, 'Administrador', 'subgerencia@wideworldimporters.cr', '2023-01-01'),
    ('admin', HASHBYTES('SHA2_256', 'admin2323'), 'Administrador', 1, 'Administrador', 'admin@wideworldimporters.cr', '2023-01-01'),
    ('ccampos', HASHBYTES('SHA2_256', 'admin1234'), 'Cristian Campos', 1, 'Administrador', 'ccampos@wideworldimporters.cr', '2023-01-01');
GO


INSERT INTO [Sucursal_SJ].[Application].[Users] 
    (Username, HashedPassword, FullName, Active, Rol, Email, HireDate)
VALUES
    ('johnsy', HASHBYTES('SHA2_256', 'admin2323'), 'Sergio Johnsy', 1, 'Administrador', 'johnsy@wideworldimporters.cr', '2023-01-01'),
    ('admin', HASHBYTES('SHA2_256', 'admin2323'), 'Administrador', 1, 'Administrador', 'admin@wideworldimporters.cr', '2023-01-01'),
    ('adminsj', HASHBYTES('SHA2_256', 'sj1234'), 'Admin San José', 1, 'Administrador', 'adminsj@wideworldimporters.cr', '2023-01-01');
GO


INSERT INTO [Sucursal_LI].[Application].[Users] 
    (Username, HashedPassword, FullName, Active, Rol, Email, HireDate)
VALUES
    ('johnsy', HASHBYTES('SHA2_256', 'sermonbadi09'), 'Sergio Johnsy', 1, 'Administrador', 'sergio@wideworldimporters.cr', '2023-01-01'),
    ('admin', HASHBYTES('SHA2_256', 'admin2323'), 'Administrador', 1, 'Administrador', 'admin@wideworldimporters.cr', '2023-01-01'),
    ('adminli', HASHBYTES('SHA2_256', 'li1234'), 'Admin Limón', 1, 'Administrador', 'adminli@wideworldimporters.cr', '2023-01-01');
GO

