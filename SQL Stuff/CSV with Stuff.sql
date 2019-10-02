use AdventureWorks2014
go

select    p.LastName + ', ' + p.FirstName + ISNULL(' ' + p.MiddleName, '') as SalesPerson, spt.Territories
from      Person.Person p
          join (select    sp.BusinessEntityID as SalesPersonID,
                          STUFF((select   distinct ', ' + st.Name
                                 from     Sales.SalesOrderHeader soh
                                          join Sales.SalesTerritory st
                                               on soh.TerritoryID = st.TerritoryID
                                 where    soh.SalesPersonID = sp.BusinessEntityID
                                 order by ', ' + st.Name
                                 for xml path ('')), 1, 2, '') as Territories
                from      Sales.SalesPerson sp) spt
               on p.BusinessEntityID = spt.SalesPersonID
order by  p.LastName, p.FirstName