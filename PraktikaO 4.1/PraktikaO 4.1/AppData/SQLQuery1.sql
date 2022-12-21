CREATE TABLE [Patient](
[id_patient] INT CONSTRAINT [PK_Patient_id] PRIMARY KEY IDENTITY,
[p_FIO] NVARCHAR(45) NOT NULL,
[p_category] NVARCHAR(40) NOT NULL,
[p_date] DATE NOT NULL
);

CREATE TABLE [Doctor](
[id_doctor] INT CONSTRAINT [PK_Doctor_id] PRIMARY KEY IDENTITY,
[d_FIO] NVARCHAR(45) NOT NULL,
[d_speciality] NVARCHAR(40) NOT NULL,
[d_stage] INT NOT NULL,
[d_born_date] DATE NOT NULL
);

ALTER TABLE [Doctor]
ADD [d_exp] INT;

CREATE TABLE [Appointment](
[id_appointment] INT CONSTRAINT [PK_Appointment_id] PRIMARY KEY IDENTITY,
[id_patient] INT CONSTRAINT [FK_Patient_id] FOREIGN KEY REFERENCES [Patient]([id_patient])NOT NULL,
[id_doctor] INT CONSTRAINT [FK_Doctor_id] FOREIGN KEY REFERENCES [Doctor]([id_doctor])NOT NULL,
[a_date] DATETIME NOT NULL,
[a_kabinet] INT NOT NULL
);

DROP TABLE [Appointment], [Patient], [Doctor];


SELECT [P].[id_patient] as 'ID', p.[p_FIO] AS 'ФИО', N'Пациент' as 'Тип', --1
(SELECT count([id_patient]) FROM [Appointment] AS [A] WHERE [P].[id_patient]=[A].[id_patient] AND YEAR(GETDATE()) = YEAR([a_date])) AS 'Приемов' 
FROM [patient] AS [P] 
WHERE [P].[id_patient] IN (SELECT [id_patient] FROM [Appointment] WHERE YEAR(GETDATE()) = YEAR([a_date])) 
GROUP BY [P].[id_patient],p.[p_FIO]
UNION 
SELECT [D].[id_doctor] as 'ID', p.[p_FIO] AS 'ФИО', N'Врач' as 'Тип', 
(SELECT count([id_doctor]) FROM [Appointment] AS [A] WHERE [D].[id_doctor]=[A].[id_doctor] AND YEAR(GETDATE()) = YEAR([a_date])) AS 'Приемов' 
FROM [doctor] AS [D], [Patient] AS [P] 
WHERE [D].[id_doctor] IN (SELECT [id_doctor] FROM [Appointment] WHERE YEAR(GETDATE()) = YEAR([a_date])) 
GROUP BY [D].[id_doctor], p.[p_FIO] ORDER BY N'Тип', N'ФИО'; 

SELECT [id_doctor], [d_FIO],--2--
(SELECT COUNT(a.[id_doctor]) FROM [Appointment] a WHERE d.[id_doctor] = a.[id_doctor] AND a.[id_patient] NOT IN 
(SELECT [id_patient] FROM [Patient] WHERE [p_category]=N'Cторонний')) AS 'Количество принятых пациентов' 
FROM [Doctor] d WHERE [d_speciality] = N'Терапевт' AND 
(SELECT COUNT(a.[id_doctor]) FROM [Appointment] a WHERE d.[id_doctor] = a.[id_doctor] AND a.[id_patient] NOT IN 
(SELECT [id_patient] FROM [Patient] WHERE [p_category]=N'Cторонний'))/200<0.75 
GROUP BY [id_doctor], [d_FIO] ORDER BY d.[d_FIO] ASC;

SELECT DISTINCT [P].[p_category],--3
(SELECT COUNT(DISTINCT [id_patient]) FROM [Appointment] WHERE [id_patient] IN (SELECT [id_patient] FROM [patient] WHERE [p_category]=[P].[p_category] AND [p_date] > '1976-01-01')) AS 'Количество приемов пациентов', 
(SELECT COUNT(DISTINCT [A].[id_doctor]) FROM [Appointment] AS [A] WHERE [id_patient] IN (SELECT [id_patient] FROM [patient] WHERE [p_category]=[P].[p_category] AND [p_date] > '1976-01-01') 
AND [A].[id_doctor] IN (SELECT [id_doctor] FROM [Doctor] WHERE [d_exp]>=1 )) AS 'Количество врачей' 
FROM [Patient] AS [P] ORDER BY [P].[p_category]; 

SELECT [D].[id_doctor], [D].[d_FIO],--4
(SELECT COUNT(*) FROM [Appointment] HAVING COUNT(*)>(SELECT COUNT(*) FROM [Appointment] WHERE [id_doctor]=123)) AS 'Число принятых пациентов' 
FROM [Doctor] AS [D]
WHERE [D].[d_speciality] = (SELECT [d_speciality] FROM [Doctor] WHERE [id_doctor] = 123);

SELECT DISTINCT [P].[id_patient], p.[p_FIO] --5
FROM [Patient] AS [P], [Appointment] AS [A] 
WHERE [A].[id_patient] = [P].[id_patient] AND 
[A].[id_doctor] NOT IN 
(SELECT [id_doctor] FROM [Appointment] WHERE [id_patient] IN (SELECT [id_patient] FROM [Patient] WHERE [p_FIO] = N'Иванов%')) 
ORDER BY [P].[id_patient] DESC;

SELECT p.[id_patient], p.[p_FIO]--6--
FROM [Patient] p
WHERE p.[p_category] = N'Пенсионер' AND (SELECT COUNT(a.[id_doctor]) FROM [Appointment] a WHERE p.[id_patient]=a.[id_patient]
AND a.[id_doctor] IN (SELECT [id_doctor] FROM [Doctor] WHERE [d_speciality]=N'Терапевт')) = 0  OR 
(SELECT COUNT(a.[id_doctor]) FROM [Appointment] AS a WHERE p.[id_patient] = a.[id_patient] AND a.[id_doctor] IN (SELECT [id_doctor] FROM [Doctor] WHERE [d_speciality]=N'Окулист')) > 1 ORDER BY p.[p_FIO];

SELECT COUNT([id_patient]) AS [Кол-во преклонных]--7
FROM [Patient] 
WHERE DATEDIFF(year, [p_date], CAST(GETDATE() AS DATE)) BETWEEN 55 AND 60; 

SELECT [p_FIO] AS [Пациенты]--8
FROM [Patient] WHERE [p_FIO] LIKE N'П%' GROUP BY [p_FIO]
UNION
SELECT [d_FIO] AS [Пациенты]
FROM [Doctor] WHERE [d_FIO] LIKE N'П%'
GROUP BY [d_FIO]

SELECT [d_FIO] AS [Врачи]--9
FROM [Doctor] d
WHERE d.[d_FIO] LIKE N'У%' AND  d.[d_exp] < 10 AND d.[d_exp] > 5
GROUP BY d.[d_FIO]

SELECT d.[d_speciality] as [Специальности], COUNT(d.[id_doctor]) AS [Кол-во]--10
FROM [Doctor] d WHERE [d_speciality]=d.[d_speciality]
GROUP BY d.[d_speciality]

SELECT TOP 5--11 --Ограничивает число строк, возвращаемых в результирующем наборе запроса до заданного числа
CAST(a.[a_date] AS DATE), COUNT(*)
FROM [Appointment] a
WHERE CAST(a.[a_date] AS DATE) = CAST(a.[a_date] AS DATE) 
GROUP BY CAST(a.[a_date] AS DATE);

SELECT [d_FIO] AS [Врачи]--12
FROM [Patient] p JOIN [Doctor] d
ON d.[d_FIO] LIKE N'А%' AND  DATEDIFF(year, [d_born_date], '2022-12-20')>30 AND DATEDIFF(year, [d_born_date], '2022-12-20')<40
GROUP BY d.[d_FIO]



INSERT [Doctor]([id_doctor], [d_FIO], [d_speciality], [d_born_date], [d_exp]) VALUES
(123, N'Стеренко Забут Клитович', N'Невролог', '01/01/1991', 12);
SET IDENTITY_INSERT [Doctor] ON