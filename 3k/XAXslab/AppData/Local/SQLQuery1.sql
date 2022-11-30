DROP TABLE [Student];
DROP TABLE [Speciality];
DROP TABLE [Scholarship];
DROP TABLE [StudentSpec];
 





CREATE TABLE [Student]( 
[id_student] INT CONSTRAINT [PK_Student] PRIMARY KEY IDENTITY(1,1), 
[s_surname] NVARCHAR(25) NOT NULL, 
[s_name] NVARCHAR(25) NOT NULL, 
[s_patronymic] NVARCHAR(25) NOT NULL, 
[s_age] NVARCHAR(10) NOT NULL 
); 
 
CREATE TABLE [Speciality]( 
[id_speciality] INT CONSTRAINT [PK_Speciality] PRIMARY KEY IDENTITY(1,1), 
[s_number] NVARCHAR(30) NOT NULL, 
[s_naming] NVARCHAR(25) NOT NULL
); 
 
CREATE TABLE [Scholarship]( 
[id_student] INT CONSTRAINT [FK_Scholarship_Id] FOREIGN KEY REFERENCES [Student]([id_student]) NOT NULL, 
[s_summ_month] MONEY NOT NULL, 
[s_summ_duty] MONEY NOT NULL 
); 
 
CREATE TABLE [StudentSpec]( 
[id_student] INT CONSTRAINT [FK_StudentSpec_id] FOREIGN KEY REFERENCES [Student]([id_student]) NOT NULL, 
[id_speciality] INT CONSTRAINT [FK_SpecialitySpec_id] FOREIGN KEY REFERENCES [Speciality]([id_speciality]) NOT NULL
); 
    
ALTER TABLE [StudentSpec] 
ADD CONSTRAINT [PK_StudentSpec] PRIMARY KEY ([id_student]); 
ALTER TABLE [StudentSpec] 
ADD CONSTRAINT [FK_StudentSpec] FOREIGN KEY ([id_student]) REFERENCES [Student]([id_student]); 
 
ALTER TABLE [Scholarship] 
ADD CONSTRAINT [PK_Scholarship_id] PRIMARY KEY ([id_student]); 
 
ALTER TABLE [Scholarship] 
ADD CONSTRAINT [FK_Scholarship] FOREIGN KEY ([id_student]) REFERENCES [Student]([id_student]); 
 
ALTER TABLE [StudentSpec] 
ADD CONSTRAINT [FK_StudentSpec] FOREIGN KEY ([id_speciality]) REFERENCES [Speciality]([id_speciality]); 
 
ALTER TABLE [StudentSpec] 
ADD CONSTRAINT [PK_StudentSpec] PRIMARY KEY; 
 
  
  






--1--

SELECT * FROM [Student];

SELECT *
FROM [Student]
WHERE [s_age] > 20; --2--

SELECT *
FROM [Student]
WHERE [s_age] BETWEEN 11 AND 24; --3--

SELECT *
FROM [Student]
WHERE [s_age] IS NOT NULL; --4--

SELECT [s_surname]
FROM [Student]
WHERE [s_surname] LIKE N'_о%'; --5--

SELECT DISTINCT [s_surname],[s_name],[s_patronymic]
FROM [Student]
WHERE [s_age]>=20 AND [s_age]<=25; --6--

SELECT [s_number], [s_naming]
FROM [Speciality]
ORDER BY [s_naming] ASC; --7--

SELECT SUM([s_summ_month]) AS [Общая сумма долга] --8--
FROM [Scholarship]

SELECT SUM([s_summ_month]) AS [Общая сумма за месяц] --9--
FROM [Scholarship]

SELECT MIN([s_summ_month]) AS [Минимальная стипендия],
       MAX([s_summ_month]) AS [Максимальная стипендия] --10--
FROM [Scholarship]

SELECT COUNT([id_student]) AS [Количество студентов] --11--
FROM [Student]

SELECT COUNT([id_student]) AS [Количество студентов чей возраст известен] --12--
FROM [Student]
WHERE [s_age] IS NOT NULL; 

SELECT*
INTO [Student 2] 
FROM [Student]; --13--

SELECT COUNT([id_student]) AS [Количество студентов чей возраст не известен]
FROM [Student]
WHERE [s_age] IS NULL; --14--

SELECT COUNT([id_student]) AS [Общее количество студентов],
       SUM([s_summ_month]) AS [Общий долг] --15--
FROM [Scholarship] 

SELECT MIN([s_summ_month]) AS [Минимальная Стипендия],
       MAX([s_summ_month]) AS [Максимальная Стипендия], --16--
       AVG([s_summ_month]) AS [Средняя Стипендия]
FROM [Scholarship] 

SELECT COUNT([id_student]) AS [Общее количество студентов],
       SUM([s_summ_month]) AS [Общий долг] 
FROM [Scholarship] 
Where [s_summ_month]>=1000 AND [s_summ_month]<=20000 --17--

SELECT [id_student] AS [Список студентов кто учится на иностранеца]
FROM [StudentSpec] 
WHERE [id_speciality]=(SELECT [id_speciality] FROM [Speciality] WHERE [s_naming] LIKE N'иностранец'); --18-- 
 
SELECT [s_naming] 
FROM [Speciality] 
ORDER BY [s_naming] DESC; --19--

SELECT [id_student] AS [ID студентов чья стипендия выше средней] FROM [Scholarship]
WHERE [s_summ_month] > (SELECT AVG([s_summ_month])FROM [Scholarship]); --20--