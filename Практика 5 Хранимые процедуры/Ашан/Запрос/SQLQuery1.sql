CREATE TABLE [Region]( 
    [id_region] INT CONSTRAINT [PK_Region_id] PRIMARY KEY IDENTITY, 
    [r_naiming] NVARCHAR(50),
    [r_coefficient] FLOAT,
);

CREATE TABLE [Shop]( 
    [id_shop] INT CONSTRAINT [PK_Shop_id] PRIMARY KEY IDENTITY, 
    [r_naiming] NVARCHAR(50),
    [id_region] INT,
    [id_hardware] INT
);

ALTER TABLE [Shop]
ADD CONSTRAINT [FK_Region_id] FOREIGN KEY ([id_region]) REFERENCES [Region]([id_region]);
ALTER TABLE [Shop]
ADD CONSTRAINT [FK_Hardware_id] FOREIGN KEY ([id_hardware]) REFERENCES [Hardware]([id_hardware]);

CREATE TABLE [Hardware]( 
    [id_hardware] INT CONSTRAINT [PK_Hardware_id] PRIMARY KEY IDENTITY,
    [h_naiming] NVARCHAR(50),
    [h_service_start_date] DATE,
    [h_service_end_date] DATE,
    [id_shop] INT
);

ALTER TABLE [Hardware]
ADD CONSTRAINT [FK_Shop_id] FOREIGN KEY ([id_shop]) REFERENCES [Shop]([id_shop]);

CREATE TABLE [Breakage]( 
    [id_bardware] INT CONSTRAINT [PK_Breakage_id] PRIMARY KEY IDENTITY,
    [b_what's_broken] NVARCHAR(50),
    [b_repair_start_date] DATE,
    [b_repair_end_date] DATE,
    [id_hardware] INT
);
ALTER TABLE [Breakage] DROP COLUMN [b_what's_broken];
ALTER TABLE [Breakage] ADD [b_what_broken] NVARCHAR(50);
ALTER TABLE [Breakage]
ADD CONSTRAINT [FKB_Hardware_id] FOREIGN KEY ([id_hardware]) REFERENCES [Hardware]([id_hardware]);

CREATE TABLE [Goods]( 
    [id_goods] INT CONSTRAINT [PK_Goods_id] PRIMARY KEY IDENTITY,
    [g_naiming] NVARCHAR(50),
    [g_goods_cost] MONEY,
    [id_provider] INT
);

ALTER TABLE [Goods]
ADD CONSTRAINT [FK_Provider_id] FOREIGN KEY ([id_provider]) REFERENCES [Provider]([id_provider]);

CREATE TABLE [Provider]( 
    [id_provider] INT CONSTRAINT [PK_Provider_id] PRIMARY KEY IDENTITY,
    [p_full_name] NVARCHAR(50),
    [id_type_provider] INT
);
ALTER TABLE [Provider] ADD [id_region] int;
ALTER TABLE [Provider]
ADD CONSTRAINT [FK_Type_Provider_id] FOREIGN KEY ([id_type_provider]) REFERENCES [Type_Provider]([id_type_provider]);

CREATE TABLE [Type_Provider]( 
    [id_type_provider] INT CONSTRAINT [PK_Type_Provider_id] PRIMARY KEY IDENTITY,
    [tp_type_provider] NVARCHAR(20),
);

CREATE TABLE [Worker]( 
    [id_worker] INT CONSTRAINT [PK_Worker_id] PRIMARY KEY IDENTITY,
    [w_salary] MONEY,
    [w_full_name] NVARCHAR(50),
    [id_shop] INT
);
ALTER TABLE [Worker] ADD [id_region] int;
ALTER TABLE [Worker]
ADD CONSTRAINT [FKW_Shop_id] FOREIGN KEY ([id_shop]) REFERENCES [Shop]([id_shop]);

CREATE TABLE [Shop_Provider]( 
    [id_Shop_Provider] INT CONSTRAINT [PK_Shop_Provider_id] PRIMARY KEY IDENTITY, 
    [id_provider] INT,
    [id_shop] INT
);

ALTER TABLE [Shop_Provider]
ADD CONSTRAINT [FKSP_Shop_id] FOREIGN KEY ([id_shop]) REFERENCES [Shop]([id_shop]);

CREATE TABLE [Deliveries]( 
    [id_deliveries] INT CONSTRAINT [PK_Deliveries_id] PRIMARY KEY IDENTITY, 
    [d_delivery_date] DATE,
    [d_quantity_of_goods] INT,
    [id_shop] INT,
    [id_goods] INT
);
ALTER TABLE [Deliveries]
ADD [d_delivery_cost] MONEY;
ALTER TABLE [Deliveries]
ADD CONSTRAINT [FKD_Shop_id] FOREIGN KEY ([id_shop]) REFERENCES [Shop]([id_shop]);
ALTER TABLE [Deliveries]
ADD CONSTRAINT [FK_Goods_id] FOREIGN KEY ([id_goods]) REFERENCES [Goods]([id_goods]);

CREATE   TABLE [Sales](
[id_sale] INT IDENTITY(1, 1) NOT NULL,
[id_supply] INT NOT NULL,
[sale_sate] DATE NOT NULL,
[sale_count] INT NOT NULL,
[sale_price] MONEY NOT NULL
);
ALTER TABLE [Sales]
ADD CONSTRAINT [PK_Sale_Id] PRIMARY KEY ([id_sale]);
ALTER TABLE [Sales]
ADD CONSTRAINT [FK_supply_second_id] FOREIGN KEY([id_supply]) REFERENCES [Deliveries] ([id_deliveries]);

SELECT * FROM [Region];
SELECT * FROM [Shop];
SELECT * FROM [Hardware];
SELECT * FROM [Breakage];
SELECT * FROM [Goods];
SELECT * FROM [Provider];
SELECT * FROM [Type_Provider];
SELECT * FROM [Worker];
SELECT * FROM [Shop_Provider];
SELECT * FROM [Deliveries];
SELECT * FROM [Sales];

--1--
go 
create procedure [GetProvider](@id_region nvarchar(50)=null, @r_naiming nvarchar(50)=null) as
begin
IF (@id_region IS NULL)
BEGIN
SET @id_region = (SELECT [id_region] FROM [Region] WHERE [r_naiming] = @r_naiming);
END
SELECT [p_full_name] FROM [Provider] WHERE [id_region] = @id_region;
END;
exec [GetProvider] @id_region = 2;
exec [GetProvider] @r_naiming = N'Челябинск';
drop procedure [GetProvider]

--2--
Go
create  procedure [ShopNew](@id_shop int, @r_naiming NVARCHAR (50), @id_region INT, @id_hardware INT ) AS BEGIN
SET IDENTITY_INSERT [Shop] ON
INSERT into [Shop] ([id_shop],[r_naiming],[id_region],[id_hardware])
VALUES (@id_shop, @r_naiming, @id_region, @id_hardware);
SET IDENTITY_INSERT [Shop] OFF
END
exec [ShopNew] 9, N'О’Кей', 4, 8;
drop procedure [ShopNew]

--3--
GO
create  procedure [DeleteMagazin](@id_shop int) AS BEGIN
delete from [Shop] where ([id_shop]=@id_shop);
delete from [Shop_Provider] where ([id_shop]=@id_shop);
delete from [Hardware] where ([id_shop]=@id_shop);
delete from [Worker] where ([id_shop]=@id_shop);
delete from [Deliveries] where ([id_shop]=@id_shop);
END
exec [DeleteMagazin] 9;
drop procedure [DeleteMagazin]

--4-- Не работает
GO
create  procedure [GetGoods]
(@id_provider int, @g_naiming NVARCHAR(50), @id_type_provider int, @tp_type_provider NVARCHAR(50))
AS BEGIN
select [id_provider] AS [ID Поставщика], [tp_type_provider] AS [Тип поставщика]
from [Type_Provider] JOIN [Provider]
on [Type_Provider].[id_type_provider] = [Provider].[id_type_provider]
UNION
select [g_naiming] AS [Товары], [Provider].[p_full_name] AS [ФИО]
from [Goods] join [Provider]
on [Goods].[id_provider] = [Provider].[id_provider]
END
exec [GetGoods] 1, 1, 1, 1;
drop procedure [GetGoods]

--5--
GO
CREATE PROCEDURE [AddFedProvider](@id_type_provider INT = NULL, @p_full_name NVARCHAR(50) = NULL) AS BEGIN
SET @id_type_provider = 1;
INSERT INTO [Provider]([id_type_provider], [p_full_name]) VALUES(@id_type_provider, @p_full_name)
END;
EXEC [AddFedProvider] @p_full_name = N'ФИО';
SELECT * from [Provider]
drop procedure [AddFedProvider]

--6--
GO
CREATE PROCEDURE [AddOblProvider](@id_type_provider INT = NULL, @p_full_name NVARCHAR(50) = NULL) AS BEGIN
SET @id_type_provider = 2;
INSERT INTO [Provider]([id_type_provider], [p_full_name])
VALUES(@id_type_provider, @p_full_name)
END;
EXEC [AddOblProvider] @p_full_name = N'ФИО'
SELECT * from [Provider]
drop procedure [AddOblProvider]

--7--
GO
CREATE PROCEDURE [AddProvider](@id_type_provider INT = NUll, @tp_type_provider NVARCHAR(50) = NULL, @p_full_name NVARCHAR(50)=NULL) AS BEGIN
IF(@id_type_provider IS NULL) BEGIN
SET @id_type_provider = (SELECT [id_type_provider] FROM [Type_Provider] WHERE [tp_type_provider] = @tp_type_provider);
END
INSERT INTO [Provider]([id_type_provider], [p_full_name])
VALUES(@id_type_provider, @p_full_name);
END;
EXEC [AddProvider] @id_type_provider=2, @p_full_name=N'ФИО';
EXEC [AddProvider] @id_type_provider=1, @p_full_name=N'ФИО';
SELECT * from [Provider]
drop procedure [AddProvider]

--8--
GO
create  procedure [DeleteProvider](@id_provider int) AS BEGIN
delete from [Provider] where ([id_provider]=@id_provider);
delete from [Shop_Provider] where ([id_provider]=@id_provider);
delete from [Type_Provider] where ([id_type_provider]=@id_provider);
delete from [Goods] where ([id_provider]=@id_provider);
END
exec [DeleteProvider] 7;
drop procedure [DeleteProvider]

--9--
GO
CREATE PROCEDURE [AddWorker](@min INT  = 18000, @w_full_name NVARCHAR(50)=NULL, @w_salary MONEY = NULL, @id_region INT = NULL, @r_coefficient float =  null, @id_shop INT = NULL) AS
BEGIN
SET @r_coefficient = (SELECT [r_coefficient] FROM [Region] WHERE [id_region] = @id_region)
SET @w_salary = @min * @r_coefficient;
INSERT INTO [Worker] ([id_shop], [w_full_name], [w_salary], [id_region]) 
VALUES (@id_shop, @w_full_name, @w_salary, @id_region)
END;
EXEC [AddWorker] @id_shop=1, @w_full_name = N'Работяга№9', @id_region = 1;
SELECT * FROM [Worker]
drop procedure [AddWorker]

--10-- 
GO
CREATE PROCEDURE [WeekRepair](@h_service_start_date DATE = NULL , @h_service_end_date DATE = NULL) AS BEGIN
SET @h_service_start_date = GETDATE();
SET @h_service_end_date = DATEADD(WEEK, 1, @h_service_start_date);
SELECT * FROM [Hardware]
WHERE [h_service_end_date] BETWEEN @h_service_start_date and @h_service_end_date;
END;
exec [WeekRepair]
drop procedure [WeekRepair]

--11--
GO
CREATE PROCEDURE [WhatBreak](@id_hardware INT = NULL) AS BEGIN
SELECT [b_what_broken] FROM [Breakage] WHERE [id_hardware]=@id_hardware;
END;
EXEC [WhatBreak] @id_hardware = 3;
drop procedure [WhatBreak]

--12--
GO 
CREATE PROCEDURE [AllBreak] AS BEGIN
SELECT DISTINCT [b_what_broken] FROM [Breakage];
END;
exec [AllBreak]
drop procedure [AllBreak];

--13--
GO
CREATE PROCEDURE [HardwareOnRepare] (@id_hardware INT = NULL, @b_repair_start_date DATE = NULL, @b_what_broken NVARCHAR(50)=NULL, @h_naiming NVARCHAR(50)=NULL) AS
BEGIN
INSERT INTO [Breakage] ([id_hardware], [b_repair_start_date], [b_what_broken] ) 
VALUES (@id_hardware, @b_repair_start_date, @b_what_broken);
END;
exec [HardwareOnRepare] @id_hardware = 2, @b_repair_start_date = '2023-1-20', @b_what_broken = N'Поломка№9';
drop procedure [HardwareOnRepare]

--14--
GO
CREATE PROCEDURE [RepairEndDate] (@id_bardware INT = NULL, @b_repair_end_date DATE = NULL) AS BEGIN
UPDATE [Breakage]
SET [b_repair_end_date] = @b_repair_end_date
WHERE [id_bardware] = @id_bardware;
END;
exec [RepairEndDate] @id_bardware = 11, @b_repair_end_date = '2023-1-22';
drop procedure [RepairEndDate]

--15--
GO
create procedure [AddDeliver](@id_deliveries int, @delivery_date DATE, @quantity_of_goods int, @id_shop int, @id_goods int) as begin
SET IDENTITY_INSERT [Deliveries] ON
insert into [Deliveries]([id_deliveries],[d_delivery_date],[d_quantity_of_goods],[id_shop],[id_goods]) values
(@id_deliveries, @delivery_date,@quantity_of_goods,@id_shop, @id_goods);
SET IDENTITY_INSERT [Deliveries] OFF
END
exec [AddDeliver] 10, N'2023-2-9', 80, 3, 6;
select * from [Deliveries];
drop procedure [AddDeliver]

--16--
GO
CREATE PROCEDURE [SolуPerDay](@sale_date DATE = NULL) AS BEGIN
SELECT SUM(sale_price) FROM [Sales] WHERE [sale_sate] = @sale_date;
END;
EXEC [SolуPerDay] @sale_date = '2023-1-2';
drop procedure [SolуPerDay]