
--Задание 1--

CREATE TABLE [Provider]( 
    [id_provider] INT CONSTRAINT [PK_provider_id] PRIMARY KEY IDENTITY, 
    [p_naiming] NVARCHAR(40),
    [p_raiting] INT,
    [p_city] NVARCHAR(60) 
); 


CREATE TABLE [Product]( 
    [id_product] INT CONSTRAINT [PK_product_id] PRIMARY KEY IDENTITY, 
    [p_product] NVARCHAR(40) ,
    [p_weight] INT,
    [p_color] NVARCHAR(40) ,
    [p_city] NVARCHAR(60)
); 

CREATE TABLE [Supply]( 
    [id_supply] INT CONSTRAINT [PK_supply_id] PRIMARY KEY, 
    [id_provider] INT, 
    [id_product] INT, 
    [s_count] INT
); 

DROP TABLE [Supply];

ALTER TABLE [Supply]
ADD CONSTRAINT [FK_Provider_id] FOREIGN KEY ([id_provider]) REFERENCES [Provider]([id_provider]);

ALTER TABLE [Supply] 
ADD CONSTRAINT [FK_Product_id] FOREIGN KEY ([id_product]) REFERENCES [Product]([id_product]);

SELECT * FROM [Provider], [Product], [Supply];



SELECT DISTINCT CONCAT([a].[p_naiming], '    id = ',[a].[id_provider], '    Raiting = ',[a].[p_raiting]) AS [Поставщики],
                CONCAT([b].[p_naiming], '    id = ',[b].[id_provider], '    Raiting = ',[b].[p_raiting]) AS [Второй поставщик]

FROM [Provider] ​ AS [a], [Provider]​ AS [b]​ 

WHERE [a].[p_naiming]<>[b].[p_naiming] AND [a].[p_city]=[b].[p_city] AND [a].[p_raiting]>=4 AND [b].[p_raiting]>=4;


 
 SELECT DISTINCT CONCAT([a].[p_naiming], '    id = ',[a].[id_provider], '    Raiting = ',[a].[p_raiting],'   AND    ',[b].[p_naiming]
                , '    id = ',[b].[id_provider], '    Raiting = ',[b].[p_raiting]) AS [Поставщики]

FROM [Provider] ​ AS [a], [Provider]​ AS [b]​ 

WHERE [a].[p_naiming]<>[b].[p_naiming] AND [a].[p_city]=[b].[p_city] AND [a].[p_raiting]>=4 AND [b].[p_raiting]>=4
UNION
 SELECT DISTINCT CONCAT('NULL =    ', [b].[p_naiming]) AS [Поставщики]

--FROM [Provider] ORDER BY [p_city] ASC, [Provider] AS [a], [Provider]​ AS [b]
FROM [Provider] AS [a], [Provider]​ AS [b]

WHERE [a].[p_naiming]<>[b].[p_naiming] AND [a].[p_city]<>[b].[p_city] AND [a].[p_raiting]<4 AND [b].[p_raiting]<4;



 SELECT DISTINCT [a].[p_naiming], [a].[id_provider], [a].[p_raiting], [b].[p_naiming]
                ,[b].[id_provider],[b].[p_raiting] AS [Поставщики]

FROM [Provider] ​ AS [a], [Provider]​ AS [b]​ 

WHERE [a].[p_naiming]<>[b].[p_naiming] AND [a].[p_city]=[b].[p_city] AND [a].[p_raiting]>=4 AND [b].[p_raiting]>=4;



--HAVING--
SELECT  a.[id_provider], a.[p_naiming], a.[p_raiting], b.[id_provider], b.[p_naiming], b.[p_raiting]
FROM [Provider] a, [Provider] b
WHERE a.[p_raiting] <= b.[p_raiting] and a.[p_city] = b.[p_city] AND a.[id_provider] <> b.[id_provider] OR
b.[p_city] IS NULL AND a.[p_city] IN (
SELECT [p_city] FROM [Provider]
Group BY [p_city]
HAVING count([p_city]) = 1)
ORDER BY a.[p_city] ASC;
--​HAVING--





 --Задание 2--

CREATE TABLE [Blyudo]( 
    [id_blyudo] INT CONSTRAINT [PK_blyudo_id] PRIMARY KEY IDENTITY, 
    [b_naiming] NVARCHAR(40),
    [b_category] NVARCHAR(60) 
); 


CREATE TABLE [Products]( 
    [id_products] INT CONSTRAINT [PK_products_id] PRIMARY KEY IDENTITY, 
    [p_naiming] NVARCHAR(40),
    [p_calories] INT
); 

CREATE TABLE [Recipe]( 
    [id_recipe] INT CONSTRAINT [PK_recipe_id] PRIMARY KEY, 
    [id_blyudo] INT, 
    [id_products] INT, 
    [p_products_count] INT
); 

DROP TABLE [Recipe];

ALTER TABLE [Recipe]
ADD CONSTRAINT [FK_blyudo_id] FOREIGN KEY ([id_blyudo]) REFERENCES [Blyudo]([id_blyudo]);

ALTER TABLE [Recipe] 
ADD CONSTRAINT [FK_products_id] FOREIGN KEY ([id_products]) REFERENCES [Products]([id_products]);

SELECT * FROM [Blyudo], [Products], [Recipe];



SELECT DISTINCT a.[id_blyudo], a.[b_naiming] AS [Блюдоа]

FROM [Blyudo] a, [Products] b

WHERE b.[p_calories]<50;

SELECT  [id_blyudo], [b_naiming]
FROM [Blyudo]
WHERE [b_naiming] <= [b_category] OR [b_naiming] IS NULL AND [b_naiming] IN (
SELECT [b_naiming] FROM [Blyudo]
Group BY [b_naiming]);


----
SELECT [id_blyudo],[b_naiming] FROM [Blyudo]
WHERE [id_blyudo]
IN (SELECT [id_blyudo] FROM [Recipe] GROUP BY [id_blyudo] HAVING COUNT([id_blyudo])=1) AND [id_blyudo] IN (
SELECT [id_blyudo] FROM [Recipe]
WHERE ([b_naiming]=1 AND [id_blyudo] IN (SELECT [id_blyudo] FROM [Recipe] WHERE [id_products] IN (SELECT [id_products] FROM [Products] WHERE [p_calories]<=50))
OR [b_naiming] IS NULL)
GROUP BY [id_blyudo]
)
ORDER BY [b_naiming] ASC;




--K3--
SELECT [id_blyudo],[b_naiming] FROM [Blyudo]
WHERE [id_blyudo]
IN (SELECT [id_blyudo] FROM [Recipe] GROUP BY [id_blyudo] HAVING COUNT([id_blyudo])=1)
AND
[id_blyudo] IN (
SELECT [id_blyudo] FROM [Recipe]
WHERE ([p_products_count]=1 AND [id_blyudo] IN (SELECT [id_blyudo] FROM [Recipe] WHERE [id_products] IN (SELECT [id_products] FROM [Products] WHERE [p_products_count]<=50))
OR [p_products_count] IS NULL)
GROUP BY [id_blyudo]
)
ORDER BY [b_naiming] ASC;
--K3--