CREATE TABLE [Post](
[id_post] INT CONSTRAINT [PK_Post_id] PRIMARY KEY IDENTITY NOT NULL,
[p_name] NVARCHAR(35) NOT NULL
);

CREATE TABLE [City](
[id_city] INT CONSTRAINT [PK_City_id] PRIMARY KEY IDENTITY NOT NULL,
[c_name] NVARCHAR(35) NOT NULL
);

CREATE TABLE [Department](
[id_department] INT CONSTRAINT [PK_Department_id] PRIMARY KEY IDENTITY NOT NULL,
[d_name] NVARCHAR(35) NOT NULL
);

CREATE TABLE [Worker](
[id_worker] INT CONSTRAINT [PK_Worker_id] PRIMARY KEY IDENTITY NOT NULL,
[id_post] INT CONSTRAINT [FK_Post_id] FOREIGN KEY REFERENCES [Post]([id_post]) NOT NULL,
[id_city] INT CONSTRAINT [FK_City_id] FOREIGN KEY REFERENCES [City]([id_city]) NOT NULL,
[id_department] INT CONSTRAINT [FK_Department_id] FOREIGN KEY REFERENCES [Department]([id_department]) NOT NULL,
[w_bearth_year] DATE NOT NULL,
[w_start_year] DATE NOT NULL
);

ALTER TABLE [Worker]
DROP COLUMN [w_bearth_year];
ALTER TABLE [Worker]
DROP COLUMN [w_start_year];

ALTER TABLE [Worker]
ADD [w_bearth_year] DATE NOT NULL;
ALTER TABLE [Worker]
ADD  [w_start_year] DATE NOT NULL;

SELECT [FIO] FROM [Worker];
DROP TABLE [Post];
DROP TABLE [Department];
DROP TABLE [Worker];
DROP TABLE [City];
DROP TABLE [Fired_Workers];
DROP TABLE [Pay];

CREATE TABLE [Pay](
[id_pay] INT CONSTRAINT [PK_Pay_id] PRIMARY KEY IDENTITY NOT NULL,
[id_worker] INT CONSTRAINT [FK_Worker_id] FOREIGN KEY REFERENCES [Worker]([id_worker]) NOT NULL,
[p_year] DATE NOT NULL
);

ALTER TABLE [Pay] DROP COLUMN [p_year];
ALTER TABLE [Pay]
ADD [p_summ] MONEY NOT NULL;

CREATE TABLE [Fired_Workers](
[id_fired] INT CONSTRAINT [PK_Fired_id] PRIMARY KEY IDENTITY NOT NULL,
[id_worker] INT CONSTRAINT [FK_Worker_id_Fired] FOREIGN KEY REFERENCES [Worker]([id_worker]) NOT NULL,
[f_year] DATE NOT NULL
);

SELECT [FIO], [p_name]--1
FROM [Worker] w JOIN [Post] p
ON w.[id_post]=p.[id_post] ORDER BY p.[p_name] ASC;
    
SELECT [FIO], [p_summ]--2
FROM [Worker] w JOIN [Pay] p
ON w.[id_worker]=p.[id_worker] ORDER BY p.[p_summ] ASC;

SELECT  [FIO],	[f_year]--3
FROM [Worker] e INNER JOIN [Fired_Workers] f
ON e.[id_worker]=f.[id_worker] AND DATEDIFF(year, [f_year], '2022-12-16')<3
Order by [FIO] ASC;

SELECT [FIO], [d_name]--4
FROM [Worker] w JOIN [Department] d
ON w.[id_department]=d.[id_department];

SELECT [d_name], count(d.[id_department])--5
FROM [Worker] w JOIN [Department] d
ON w.[id_department]=d.[id_department] GROUP BY [d_name];   

SELECT [FIO]--6
FROM [Post] s, [Worker] w, [Pay] p
WHERE w.[id_post]=s.[id_post] AND w.[id_worker]=p.[id_worker] AND p.[p_summ]>100000 AND [FIO] LIKE N'П%' AND s.[p_name] = N'Програмист';

SELECT [FIO] AS [Worker],--7
       [p_name] AS [Post]
FROM [Worker] AS w JOIN [Post] p
ON w.[id_post]=p.[id_post] AND datediff(year,[w_start_year],getdate())>3;

SELECT count(w.[id_worker]), f.[f_year]--8
FROM [Worker] w JOIN [Fired_Workers] f
ON w.[id_worker]=f.[id_worker] GROUP BY [f_year] ORDER BY f.[f_year] DESC;

SELECT [FIO], [c_name]--9
FROM [Worker] w JOIN [City] c
ON w.[id_city]=c.[id_city];

SELECT c.[c_name], COUNT(w.[id_worker])--10
FROM [Worker] w JOIN [City] c
ON w.[id_city]=c.[id_city] GROUP BY [c].[c_name] ORDER BY COUNT(c.[id_city]) Desc;

SELECT AVG(datediff(year,w.[w_bearth_year], '2022-12-16'))--11
FROM [Worker] w INNER JOIN [Fired_Workers] f
ON w.[id_worker]=f.[id_worker];




   


