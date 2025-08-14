-- SQL script implementing Spruce Up cleaning business scenario
IF OBJECT_ID('dbo.SpruceCustomers','U') IS NOT NULL
    DROP TABLE dbo.SpruceCustomers;

CREATE TABLE dbo.SpruceCustomers(
    CustomerID INT IDENTITY(1,1) CONSTRAINT c_SpruceCustomers_CustomerID_primarykey PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL CONSTRAINT c_SpruceCustomers_FirstName_not_blank CHECK (FirstName <> ''),
    LastName NVARCHAR(50) NOT NULL CONSTRAINT c_SpruceCustomers_LastName_not_blank CHECK (LastName <> ''),
    Phone NVARCHAR(20) NOT NULL CONSTRAINT c_SpruceCustomers_Phone_not_blank CHECK (Phone <> ''),
    Address NVARCHAR(100) NOT NULL CONSTRAINT c_SpruceCustomers_Address_not_blank CHECK (Address <> ''),
    Frequency NVARCHAR(10) NOT NULL CONSTRAINT c_SpruceCustomers_Frequency_not_blank CHECK (Frequency <> ''),
    PricePerHour DECIMAL(5,2) NOT NULL,
    Hours DECIMAL(4,1) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    MonthlyIncome AS (
        PricePerHour * Hours *
        CASE WHEN Frequency='weekly' THEN 52.0/12.0
             WHEN Frequency='bi weekly' THEN 26.0/12.0
        END
    )
);

INSERT INTO dbo.SpruceCustomers
    (FirstName, LastName, Phone, Address, Frequency, PricePerHour, Hours, StartDate, EndDate)
VALUES
    ('Tara','Hughes','727 456 2346','3478 71st Ave N','bi weekly',25,5,'2017-04-04',NULL),
    ('David','Sullivan','727 346 6945','5061 47th St. N','bi weekly',30,6,'2019-05-14',NULL),
    ('Jennifer','Hill','727 456 8689','2890 6th St. S','weekly',35,7,'2020-03-10',NULL),
    ('Bob','Evans','727 680 3867','1747 1st Ave N','bi weekly',30,8,'2018-08-15',NULL),
    ('Amy','Campbell','727 245 6956','1820 Tropical Shores Dr SE','bi weekly',35,8,'2017-05-24','2020-11-29'),
    ('Peter','Mitchell','727 357 9765','4059 Burlington Ave N','bi weekly',30,7,'2021-09-30',NULL),
    ('Sarah','Reed','727 356 8708','4908 Central Ave S','bi weekly',32,8,'2020-12-06',NULL),
    ('Diana','Moore','727 476 7908','5554 22nd Ave S','bi weekly',25,6,'2017-07-04','2021-02-21'),
    ('Amanda','Roberts','727 446 7964','2778 20th Ave S','weekly',35,8,'2020-04-30',NULL),
    ('George','Anderson','727 589 5756','1918 Sunrise Dr SE','bi weekly',28,5,'2017-09-26',NULL),
    ('George','Anderson','727 589 5756','2917 Beach Dr SE','bi weekly',25,3,'2018-04-09',NULL),
    ('Samuel','Newman','727 374 6632','3344 Oak St NE','weekly',30,6,'2018-10-03','2022-10-07'),
    ('Judy','Davis','727 233 0875','2323 Mangrove St N','bi weekly',25,4,'2018-12-28',NULL),
    ('Walter','Nelson','727 066 6356','2734 Pinellas Point Dr S','bi weekly',28,5,'2019-11-20',NULL),
    ('Stephanie','Johnson','727 007 5335','1145 Driftwood Rd S','bi weekly',32,8,'2017-08-03',NULL),
    ('Heather','Miller','727 568 9967','2890 Coral Way N','bi weekly',35,8,'2019-12-11','2020-06-09'),
    ('Michele','Lopez','727 245 7667','3786 Snell Isle Blvd NE','weekly',35,8,'2020-09-26',NULL),
    ('Michele','Lopez','727 245 7667','1604 Gulf Way','bi weekly',35,7,'2021-01-25',NULL),
    ('Rodney','Wright','727 345 7857','3675 Driftwood Rd S','bi weekly',32,6,'2021-02-21',NULL),
    ('Susan','Lee','727 134 6783','2674 Central Ave S','bi weekly',27,6,'2021-11-03',NULL),
    ('Isaiah','Eisenberg','727 794 6865','1665 Bayshore Dr NE','bi weekly',32,5,'2018-08-22',NULL),
    ('Kelly','Brooks','727 456 7857','1777 1st St S','bi weekly',30,5,'2018-07-29',NULL),
    ('Lisa','Adams','727 285 8999','1386 48th Ave N','bi weekly',30,6,'2020-09-01',NULL),
    ('Lisa','Adams','727 285 8999','1533 48th Ave N','bi weekly',25,3,'2017-11-12',NULL),
    ('John','Allen','727 709 7985','2722 Bay St NE','bi weekly',30,6,'2019-03-31',NULL),
    ('Kim','White','727 264 8996','1718 50th Ave N','weekly',34,7,'2019-06-19','2020-04-05'),
    ('Christina','Lewis','727 245 7240','1444 Newton Ave S','bi weekly',32,5,'2021-01-17',NULL),
    ('James','Morris','727 277 3365','1006 5th Ave S','bi weekly',35,8,'2018-09-08',NULL),
    ('James','Morris','727 277 3365','4789 41st St S','bi weekly',25,4,'2019-11-30',NULL),
    ('Michael','Rogers','727 955 62464','2789 6th St S','weekly',30,8,'2017-07-27',NULL);

-- 1) Deep clean quotes
SELECT LastName + ', ' + FirstName + ' (' + Phone + ') - $' +
       FORMAT(PricePerHour * Hours * 1.5, 'N2') AS Quote
FROM dbo.SpruceCustomers;

-- 2) Months worked for each current customer
SELECT LastName + ' - ' + Frequency AS CustomerFrequency,
       DATEDIFF(month, StartDate, GETDATE()) AS MonthsWorked
FROM dbo.SpruceCustomers
WHERE EndDate IS NULL
ORDER BY MonthsWorked DESC;

-- 3) Average hourly price for regular and deep cleans
SELECT AVG(PricePerHour) AS AvgRegularPricePerHour,
       AVG(PricePerHour * 1.5) AS AvgDeepCleanPricePerHour
FROM dbo.SpruceCustomers;

-- 4) Customer generating the most annual income (regular cleans only)
SELECT TOP 1 FirstName, LastName,
       PricePerHour * Hours *
       CASE WHEN Frequency='weekly' THEN 52 ELSE 26 END AS AnnualIncome
FROM dbo.SpruceCustomers
ORDER BY AnnualIncome DESC;

-- 5) Customers gained and lost in 2020
SELECT
    SUM(CASE WHEN YEAR(StartDate) = 2020 THEN 1 ELSE 0 END) AS GainedIn2020,
    SUM(CASE WHEN YEAR(EndDate) = 2020 THEN 1 ELSE 0 END) AS LostIn2020
FROM dbo.SpruceCustomers;
