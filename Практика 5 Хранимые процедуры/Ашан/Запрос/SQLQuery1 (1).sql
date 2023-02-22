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
ADD CONSTRAINT [FKD_Shop_id] FOREIGN KEY ([id_shop]) REFERENCES [Shop]([id_shop]);
ALTER TABLE [Deliveries]
ADD CONSTRAINT [FK_Goods_id] FOREIGN KEY ([id_goods]) REFERENCES [Goods]([id_goods]);

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

--1--
SELECT p.[p_full_name]
FROM [Provider] p JOIN [Shop_Provider] s
ON p.[id_provider]=s.[id_Shop_Provider] AND s.[tp_type_provider]=N'Челябинская область' GROUP BY [p_full_name];

--2--
SET IDENTITY_INSERT [Shop] ON
INSERT [Shop] ([id_shop],[r_naiming],[id_region],[id_hardware])
VALUES (9, N'О’Кей', 4, 8);
SET IDENTITY_INSERT [Shop] OFF

--3--
GO
create  procedure [DeleteMagazin](@id_shop int) AS BEGIN
delete from [Shop] where ([id_shop]=@id_shop);
delete from [Shop_Provider] where ([id_shop]=@id_shop);
delete from [Hardware] where ([id_shop]=@id_shop);
delete from [Worker] where ([id_shop]=@id_shop);
delete from [Deliveries] where ([id_shop]=@id_shop);
END
exec [DeleteMagazin] 2;

--4--


--5--
SET IDENTITY_INSERT [Provider] ON
INSERT [Provider] ([id_provider], [p_full_name], [id_type_provider])
VALUES (6, N'Михайлов Михаил Михайлович', 6);
SET IDENTITY_INSERT [Provider] OFF
SET IDENTITY_INSERT [Type_Provider] ON
INSERT [Type_Provider] ([id_type_provider], [tp_type_provider])
VALUES (6, N'Федеральный');
SET IDENTITY_INSERT [Type_Provider] OFF

--6--
SET IDENTITY_INSERT [Provider] ON
INSERT [Provider] ([id_provider], [p_full_name], [id_type_provider])
VALUES (7, N'Архипов Олег Тихонович', 7);
SET IDENTITY_INSERT [Provider] OFF
SET IDENTITY_INSERT [Type_Provider] ON
INSERT [Type_Provider] ([id_type_provider], [tp_type_provider])
VALUES (7, N'Областной');
SET IDENTITY_INSERT [Type_Provider] OFF

--7--
SET IDENTITY_INSERT [Provider] ON
INSERT [Provider] ([id_provider], [p_full_name], [id_type_provider])
VALUES (6, N'Михайлов Михаил Михайлович', 6);
SET IDENTITY_INSERT [Provider] OFF
SET IDENTITY_INSERT [Type_Provider] ON
INSERT [Type_Provider] ([id_type_provider], [tp_type_provider])
VALUES (6, N'Федеральный/Областной');
SET IDENTITY_INSERT [Type_Provider] OFF

--8--
DELETE FROM [Provider]
WHERE [p_full_name] = N'Архипов Олег Тихонович';
DELETE FROM [Type_Provider]
WHERE [id_type_provider] = 7;

--9--

--10--

--11--

--12--
SELECT [b_what's_broken] FROM [Breakage]

--13--

--14--

--15--
SET IDENTITY_INSERT [Deliveries] ON
INSERT [Deliveries] ([id_deliveries], [d_delivery_date], [d_quantity_of_goods], [id_shop], [id_goods])
VALUES (9, N'01.09.2023', 100, 8, 8);
SET IDENTITY_INSERT [Deliveries] OFF

--16--







--Хранимые процедуры--

go
create   procedure [GetDate] as begin
select getdate();
end;
execute [GetDate];


create   table [Product] (
[id] int primary key identity (1,1),
[name] nvarchar(50) not null,
[manufaturer] nvarchar(25),
[price] money not null,
[count] int default 0
)

insert into [Product]([name],[manufaturer],[price],[count]) values
(N'RTX 4090', N'Nvidia',150000,10),
(N'RTX 4080', N'Nvidia',110000,5);

select * from [Product];

go
create   procedure [AddProduct](@name NVARCHAR(50), @manufaturer NVARCHAR(25), @price money, @count int
) as begin
insert into [Product]([name],[manufaturer],[price],[count]) values
(@name, @manufaturer,@price,@count);
end

exec [AddProduct] N'RTX 4070TI', N'Nvidia', 80000,15;

select * from [Product];

go
create   procedure [GetProductPrice](@name nvarchar(50))
as begin
return select[price] from [Product] where [name] = @name;
end

declare @price money = 0
exec @price=[GetProductPrice] N'RTX 4070TI'
print @price

go
create   procedure [GetSum](
    @price money,
   @count int,
   @sum money output
) as begin
   set @sum=@price * @count;
   return @sum;
end

drop   Procedure [GetSum];

declare @sum money
exec [GetSum] 25000, 7, @sum output;
print @sum;


go
create   procedure [GetFullName](
   @first_name NVARCHAR(50),
   @second_name NVARCHAR(50),
   @last_name NVARCHAR(50),
   @full_name NVARCHAR(150) output
) as begin
set @full_name= concat(@last_name,' ',@first_name,' ',@second_name);
end

declare @full_name NVARCHAR(150) = N'';

exec [GetFullName] N'Иван', N'Иванович' ,N'Иванов', @full_name output;
print @full_name

go
create   procedure [GetBinaryValue](
   @number int,
   @binary_value nvarchar(max) output
) as begin
while @number>0 begin
   set @binary_value = concat(@binary_value,@number%2)
   set @number/=2
end
set @binary_value =reverse(@binary_value);
end


declare @number int = 7632, @value nvarchar(max)
exec [GetBinaryValue] @number, @value output;
print @value;

drop   procedure [GetBinaryValue];

