SQL-скрипт бази даних «Ядерний Арсенал Країн»
 SELECT * FROM `countries`; /*1*/
SELECT `Population`, Capital FROM `countries`; /*2*/
SELECT DISTINCT `Continent` FROM `countries`; /*3*/
SELECT * FROM `countries` WHERE Capital='Tehran';/*4*/
SELECT `capital` FROM `countries` WHERE GDP>10000;/*5*/
SELECT * FROM `countries` WHERE NOT Capital='Moscow' AND `GDP`>=5000000;/*6*/
SELECT * FROM `countries` WHERE `Country_ID` BETWEEN 5 AND 8;/*7*/
SELECT Capital FROM `countries` WHERE Population ='26070000' OR Population='235860000' ;/*8*/
SELECT Capital FROM `countries` WHERE NameOfCountry IN ('Jerusalem','Tehran');/*8.1*/
SELECT * FROM `countries` WHERE NameOfCountry IN ('India', 'USA', 'Bulgaria', 'Iran');/*9*/
SELECT * FROM `countries` WHERE Capital LIKE 'B%';/*10*/
SELECT * FROM `countries` WHERE Continent LIKE '%M%';/*11*/
SELECT Year_Signed FROM `traties` WHERE Treaty_Name IS NOT NULL;/*12*/
SELECT Test_Location, Test_Result, Test_Date*5 FROM `nuclear_tests`;/*13*/
SELECT CONCAT('Статус: ', Status, ', Тип оружия: ', Weapon_Type, ', Тип доставки: ', Delivery_System, ', Боеголовки: ', Warheads, ', ID оружия: ', Weapon_ID, ', ID страны: ', Country_ID) AS INFO FROM nuclear_weapons;
/*14*/
SELECT * FROM `countries` ORDER BY Population ASC;/*15*/
SELECT * FROM `nuclear_tests` WHERE Test_Result='Успешно' ORDER BY Test_Location DESC;/*16*/
SELECT * FROM `nuclear_tests` WHERE Test_Location='Тхар' ORDER BY 4 DESC;
SELECT COUNT(Treaty_ID) FROM `traties`;/*17*/
SELECT COUNT(DISTINCT Name) FROM `kind_sanctions`;/*18*/
SELECT COUNT(*) FROM `aboveground`;/*19*/
SELECT AVG(Warheads) FROM `nuclear_weapons`;/*20*/
SELECT MAX(Test_Depth) FROM `underwater`;/*21*/
SELECT MIN(Containment_Method) FROM `underground`;/*22*/
SELECT NameofCountry, AVG(GDP) FROM `countries` GROUP BY NameofCountry;/*23*/
SELECT NameofCountry, COUNT(Country_ID) FROM countries GROUP BY NameofCountry;/*24*/
SELECT Warheads, Weapon_ID, COUNT(Weapon_Type) FROM `nuclear_weapons` GROUP BY Warheads, Weapon_ID;/*25*/
SELECT Warheads, COUNT(Weapon_ID) FROM `nuclear_weapons` GROUP BY Warheads HAVING COUNT(Weapon_ID)>1 ;/*26*/
SELECT Population, AVG(GDP) FROM `countries` GROUP BY Population HAVING AVG(GDP)>=100000;/*27*/
INSERT INTO `countries` (GDP, Population, Capital, Continent, NameofCountry, Country_ID)VALUES(4533980, 75400000, 'Kiev', 'Europe', 'Ukraine', 16);
INSERT INTO `countries` (GDP, Population, Capital, Continent, NameofCountry, Country_ID)VALUES(2340050, 45300000, 'Gomel', 'Europe', 'Belarus', 17);
UPDATE `underground` SET Depth='Засекречено';
DELETE FROM `countries` WHERE Country_ID=16;
DELETE FROM `countries` WHERE Country_ID=17;



SELECT * FROM `countries` INNER JOIN `countries_tratie`;/*1*/

SELECT * FROM `nuclear_tests` INNER JOIN `nuclear_weapons` using(Weapon_ID);/*2*/

SELECT * FROM countries INNER JOIN kind_sanctions ON NameOfCountry = NameOfCountry;/*3*/

SELECT * FROM `aboveground` LEFT JOIN `underwater` ON Fallout_Pattern = Test_Depth;/*4*/

SELECT Test_Date FROM `nuclear_tests` LEFT JOIN `nuclear_weapons` ON Test_Result = Weapon_Type WHERE Warheads IS NULL;/*5*/

SELECT * FROM `nuclear_weapons` RIGHT JOIN `nuclear_tests` ON Test_Location = Weapon_Type;/*6*/

SELECT * FROM `countries` LEFT JOIN `test_type` ON Country_ID = Type_ID;/*7*/

/*1*/
SELECT Country_ID AS GDP, Population, Capital, Continent, NameOfCountry, Country_ID 
FROM countries 
WHERE Capital = "Paris" 

UNION 

SELECT NULL AS GDP, NULL AS Population, NULL AS Capital, NULL AS Continent, NULL AS NameOfCountry, Country_ID 
FROM nuclear_weapons 
WHERE Status = "Обладание ЯО" 

ORDER BY Country_ID;


/*2*/
SELECT * FROM `underwater` WHERE Test_Depth > (SELECT AVG(Test_Depth) FROM `underwater`);

/*3*/
SELECT NameofCountry 
FROM countries 
WHERE Country_ID = (
    SELECT Country_ID 
    FROM nuclear_weapons 
    WHERE Weapon_Type ='Ракеты/бомбы/торпеды'
    LIMIT 1
);
/*4*/
SELECT * FROM `international_sanctions`
WHERE Start_Date = (SELECT MIN(End_Date) FROM `kind_sanctions`);

/*5*/
SELECT * FROM `countries_tratie`
WHERE Country_ID IN (SELECT Treaty_ID FROM `countries`);
/*6*/
SELECT * FROM `nuclear_tests`
WHERE Test_Purpose NOT IN (SELECT Country_ID FROM `countries`);
/*7*/
SELECT * FROM `underwater`
WHERE Test_Depth < ALL(SELECT Test_Depth FROM `underwater` WHERE Hydroacoustic_Signature='Подписано');

/*8*/
SELECT * FROM `underwater`
WHERE Enviromental_Im_pact<(SELECT MIN(Enviromental_Im_pact) FROM `underwater` WHERE Hydroacoustic_Signature='Не подписано');

/*9*/
SELECT nw.Country_ID, nw.Weapon_ID
FROM nuclear_weapons nw
WHERE nw.`Country_ID` IN
  (SELECT nt.`Weapon_ID`
     FROM nuclear_tests nt
	WHERE nt.Weapon_ID < 7);


/*1*/
SELECT 
    Year_Signed, 
    Year_Effective, 
    CURRENT_DATE,
    (YEAR(CURRENT_DATE) - YEAR(Year_Effective))
    - (YEAR(CURRENT_DATE) < YEAR(Year_Effective))
    AS Year_Signed 
FROM `traties`;


/*2*/
SELECT 
    Sanction_ID, 
    Start_Date, 
    End_Date,
    (YEAR(End_Date) - YEAR(Start_Date)) - (YEAR(End_Date) < YEAR(Start_Date)) 
    AS duration 
FROM international_sanctions 
WHERE End_Date IS NOT NULL 
ORDER BY duration;



/*3*/
SELECT 
    Sanction_ID, 
    Start_Date, 
    MONTH(Start_Date) AS Birth_Month 
FROM international_sanctions;



/*4*/
SELECT  
    Treaty_Name,
    Year_Signed,
    Year_Effective
    
FROM `traties`
WHERE Year_Effective = '2024-10-13';

/*5*/
SELECT 
    Treaty_Name,
    Treaty_ID
FROM traties
WHERE MONTH(Year_Effective) = MONTH(DATE_ADD(NOW(), INTERVAL 1 MONTH));

/*1*/
SELECT *
FROM underground
WHERE Depth IS NULL;

/*2*/
UPDATE underground
SET Containment_Method = NULL
WHERE Tunneling_Method = 'Глинистая порода';

/*3*/
DELETE FROM underground
WHERE Seismic_Signature IS NULL;

/*4*/
SELECT DISTINCT Tunneling_Method
FROM underground
WHERE Tunneling_Method IS NOT NULL;

/*5*/
SELECT AVG(Depth)
FROM underground
WHERE Containment_Method IS NOT NULL;



/*1*/
SELECT @min_year:=MIN(Year_Effective), @max_year:=MAX(Year_Signed) FROM traties;
SELECT * FROM traties WHERE Year_Effective = @min_year AND Year_Signed = @max_year;

/*2*/
SELECT @min_year:=MIN(Year_Signed), @max_year:=MAX(Year_Effective) FROM traties;
SELECT * FROM traties WHERE Year_Effective = @max_year AND Year_Signed = @min_year;

/*3*/
SELECT @min_year:=MIN(Year_Signed) FROM traties;
UPDATE traties SET Year_Signed = @min_year;

/*4*/
SELECT @max_year:=MAX(Year_Signed) FROM traties;
UPDATE traties SET Year_Signed = @max_year;

/*5*/
SELECT @max_year:=MAX(Year_Signed) FROM traties;
SELECT * FROM traties WHERE Year_Signed = @max_year;
DROP VIEW IF EXISTS `Information_about_countries`;
CREATE VIEW `Information_about_Countries` AS
SELECT `countries`.`GDP` AS `GDP`, `countries`.`Population` AS `Population`,
`countries`.`Capital` AS `Capital`, `countries`.`Continent` AS `Continent`
FROM `countries`
WHERE `countries`.`Country_ID` = 1 AND `countries`.`NameOfCountry` = 'North Corea';

DROP VIEW IF EXISTS `Information_about_sanctions`;
CREATE VIEW `Information_about_sanctions` AS
SELECT `countries_sanction`.`Country_ID` AS `Country_ID`, `countries_sanction`.`Sanction_ID` AS `Sanction_ID`
FROM `countries_sanction`;

DROP VIEW IF EXISTS `Information_about_aboveground`;
CREATE VIEW `Information_about_aboveground` AS
SELECT
`ab`.`Fallout_Pattern` AS `Fallout_Pattern`,
`ab`.`Detonation_Method` AS `Detonation_Method`,
`ab`.`Test_Atitude` AS `Test_Atitude`,
`ab`.`Type_ID` AS `Type_ID`
FROM `aboveground` `ab`
WHERE `ab`.`Test_Atitude` > 1000;

DROP VIEW IF EXISTS `InformationTests`;
CREATE VIEW `InformationTests` AS
SELECT `Test_Location`, `Test_Result`, `Test_ID`, `Test_Date`, `Test_Purpose`
FROM `nuclear_tests`
ORDER BY `Test_Date` DESC 
LIMIT 15;


DROP PROCEDURE IF EXISTS `show_the_countries`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_the_countries`(
    IN `i` INTEGER
)
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
    SELECT
        `GDP`,
        `Population`,
        `Capital`,
        `Continent`,
        `NameOfCountry`,
        `Country_ID`
    FROM
        `countries`
    WHERE
        `Country_ID` = i;
END;

DROP PROCEDURE IF EXISTS `not_treaty`;
CREATE DEFINER = `root`@`localhost` PROCEDURE `not_treaty`()
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT''
BEGIN
SELECT * FROM `traties` WHERE `Year_Effective` > NOW();
END;

DROP PROCEDURE IF EXISTS `warheads_weapons`;
CREATE DEFINER = `root`@`localhost` PROCEDURE `warheads_weapons`()
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT''
BEGIN
    DECLARE WarheadsCount INT;

    SELECT COUNT(*) INTO WarheadsCount FROM nuclear_weapons WHERE Warheads = 1000;

    IF WarheadsCount > 0 THEN
        SELECT
            `Status`,
            `Weapon_Type`,
            `Delivery_System`,
            `Warheads`,
            `Weapon_ID`,
            `Country_ID`
        FROM
            `nuclear_weapons` WHERE Warheads < 1000;
    ELSE
        SELECT
            `Status`,
            `Weapon_Type`,
            `Delivery_System`,
            `Warheads`,
            `Weapon_ID`,
            `Country_ID`
        FROM
            `nuclear_weapons` WHERE Warheads > 1000;
    END IF;
END;


DROP PROCEDURE IF EXISTS `info_countries`;
CREATE DEFINER = `root`@`localhost` PROCEDURE `info_countries`()
BEGIN
    IF (0 > 1) THEN
        SELECT
            `GDP`,
            `Population`,
            `Capital`,
            `Continent`,
            `NameOfCountry`,
            `Country_ID`
        FROM
            `countries`
        WHERE
            `Population` > 45000000;
    ELSE
        SELECT
            `GDP`,
            `Population`,
            `Capital`,
            `Continent`,
            `NameOfCountry`,
            `Country_ID`
            
        FROM
            `countries`
        WHERE      
             `Population` < 50000000; 
    END IF;
END;
DROP TRIGGER IF EXISTS unknown;
CREATE DEFINER = 'root'@'localhost' TRIGGER unknown BEFORE INSERT ON `countries`
FOR EACH ROW
BEGIN
    SET NEW.NameOfCountry = IFNULL(NEW.NameofCountry, '-Нет данных-');
END;


DROP TRIGGER IF EXISTS populationzero;
CREATE DEFINER = 'root'@'localhost' TRIGGER populationzero BEFORE
INSERT ON `countries`
FOR EACH ROW
BEGIN
IF NEW.Population < 1 THEN
SET NEW.Population = 0;
END IF;
END;

DROP TRIGGER IF EXISTS `capitalunknown`;
CREATE DEFINER = `root`@'localhost' TRIGGER `capitalunknown` BEFORE INSERT ON `countries`
FOR EACH ROW
BEGIN
    SET NEW.Capital = IFNULL(NEW.Capital, ' - data missing! -');
END;


DROP TRIGGER IF EXISTS `leastkon`;
CREATE DEFINER = 'root'@'localhost' TRIGGER `leastkon` BEFORE INSERT ON `countries`
FOR EACH ROW
BEGIN 
    IF NEW.Capital LIKE '%kon' THEN
        SET NEW.Population = 2;
    END IF;
END;
