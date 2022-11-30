CREATE TABLE [buyers](
[u_address] NVARCHAR(25) NOT NULL,
[u_age] INT NOT NULL, 
[u_gender] NVARCHAR(25) NOT NULL,
[u_email] VARCHAR(25) NOT NULL,
[u_discount] NVARCHAR(25) NOT NULL
);

CREATE TABLE [order](
[o_date] DATE NOT NULL, 
[o_cost] MONEY NOT NULL,
[id_buyer] INT NOT NULL,
[id_seller] INT NOT NULL
);

CREATE TABLE [order_lines](
[id_order] INT NOT NULL, 
[id_product] INT NOT NULL,
[p_count] NVARCHAR(25) NOT NULL
);

CREATE TABLE [users](
[u_frame] INT NOT NULL, 
[u_lname] VARCHAR(5) NOT NULL,
[u_email] VARCHAR(40) NOT NULL,
[u_login] NVARCHAR(50) NOT NULL, 
[u_pass] NVARCHAR(100) NOT NULL
);

CREATE TABLE [sellers](
[u_rating] NVARCHAR(5) NOT NULL
);

CREATE TABLE [products](
[p_name] NVARCHAR(25) NOT NULL, 
[p_price] MONEY NOT NULL,
[id_categoty] NVARCHAR(5) NOT NULL
);

CREATE TABLE [properties](
[pr_name] NVARCHAR(35) NOT NULL
);

CREATE TABLE [categories](
[c_category] NVARCHAR(25) NOT NULL, 
[c_name] NVARCHAR(25) NOT NULL, 
[id_parent] NVARCHAR(15) NOT NULL
);

CREATE TABLE [property_value](
[value] NVARCHAR(70) NOT NULL
);

SELECT *
Into[new_products]
FROM[products]


EXEC sp_rename 'order', 'orders';

ALTER TABLE [products]
ADD [p_description] INT NOT NULL;

ALTER TABLE [orders]
ADD [o_status] NVARCHAR(40) NOT NULL;

DROP TABLE [orders];

ALTER TABLE [new_products]
ALTER COLUMN [p_name] NCHAR(30);

ALTER TABLE [new_products]
ADD [p_price] NVARCHAR(10) NOT NULL 
	DEFAULT(100);

ALTER TABLE [new_products]
DROP COLUMN [p_price];

ALTER TABLE [orders]
ADD [o_status]INT;

ALTER TABLE [orders]
ADD [o_status] NVARCHAR(18) CHECK([o_status] LIKE 'ожидает, обработан, закрыт, отменён');

ALTER TABLE [orders]
ALTER COLUMN [o_cost] MONEY NULL;

ALTER TABLE [users]
ADD [id_user] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [buyers]
ADD [id_buyers]INT;

ALTER TABLE [orders]
ADD FOREIGN KEY([id_buyer]) 
REFERENCES [buyers]([id_buyer]);

ALTER TABLE [buyers]
ADD FOREIGN KEY([id_buyer]) 
REFERENCES [users]([id_user]);

ALTER TABLE [buyers]
ADD [id_buyer] INT PRIMARY KEY IDENTITY(1, 1),
[id_buyer] INT FOREIGN KEY REFERENCES [orders]([id_buyer]);

ALTER TABLE [orders]
ADD [id_order] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [order_lines]
ADD FOREIGN KEY([id_order]) 
REFERENCES [orders]([id_order]);

ALTER TABLE [order_lines]
ADD [id_line] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [products]
ADD [id_product] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [order_lines]
ADD FOREIGN KEY([id_product]) 
REFERENCES [products]([id_product]);

ALTER TABLE [categories]
ADD [id_product] INT PRIMARY KEY IDENTITY(1, 1);

DROP TABLE [categories];

ALTER TABLE [products]
ADD [id_caregory]INT;

ALTER TABLE [products]
DROP COLUMN [id_categoty];

ALTER TABLE [categories]
ADD [id_category] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [products]
ADD [id_category]INT;

ALTER TABLE [products]
ADD FOREIGN KEY([id_category]) 
REFERENCES [categories]([id_category]);


ALTER TABLE [categories]
ADD FOREIGN KEY([id_parent]) 
REFERENCES [categories]([id_category]);

ALTER TABLE [properties]
ADD [id_property] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [property_value]
ADD [id_product] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [property_value]
ADD [id_property] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [property_value]
ADD [id_property]INT;

ALTER TABLE [property_value]
ADD FOREIGN KEY([id_product]) 
REFERENCES [products]([id_product]);

ALTER TABLE [property_value]
ADD [id_property] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [sellers]
ADD [id_seller] INT PRIMARY KEY IDENTITY(1, 1);

ALTER TABLE [orders]
ADD [id_seller]INT;

ALTER TABLE [orders]
ADD FOREIGN KEY([id_seller]) 
REFERENCES [sellers]([id_seller]);

ALTER TABLE [sellers]
ADD FOREIGN KEY([id_seller]) 
REFERENCES [orders]([id_seller]);





