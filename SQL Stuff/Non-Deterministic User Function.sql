USE AdventureWorks2014
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Demo')
BEGIN
     EXECUTE sp_executesql N'create schema Demo'
END
GO

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'vRandom')
BEGIN
     DROP VIEW Demo.vRandom
END
GO

CREATE VIEW Demo.vRandom
AS
(
     SELECT RAND() AS RandomValue
)
GO

IF OBJECTPROPERTY(OBJECT_ID('Demo.ufnGetDummySSN'), 'IsScalarFunction') = 1
BEGIN
     DROP FUNCTION Demo.ufnGetDummySSN
END
GO

CREATE FUNCTION Demo.ufnGetDummySSN()
RETURNS nchar(11)
AS
BEGIN
     DECLARE   @Digits nvarchar(9) = null

     SELECT    @Digits = CONVERT(nvarchar(9), CAST(RandomValue * 1000000000 AS int))
     FROM      Demo.vRandom

     SET @Digits = RIGHT('000000000' + @Digits, 9)

     RETURN STUFF(STUFF(@Digits, 6, 0, '-'), 4, 0, '-')
END
GO

SELECT    p.LastName + ', ' + p.FirstName + ISNULL(' ' + p.MiddleName, '') AS Employee,
          e.JobTitle, e.BirthDate, e.Gender, Demo.ufnGetDummySSN() AS SSN
FROM      HumanResources.Employee e
          JOIN Person.Person p
               ON e.BusinessEntityID = p.BusinessEntityID