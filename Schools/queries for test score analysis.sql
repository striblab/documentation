-- Updated August 2018

-- The table called "districtlist" has one row for each district and 
-- it identifies whether the district is in the 7-county
-- metro area and also it's "location" (corecities=located in Minneapolis or 
-- St Paul; suburbs is the suburban cities of the 7-county
-- and "out state" is everywhere else)
--
-- There is also a table called "schoollist" that has one row for 
-- each school and it also identifies whether in metro and it's location
--
-- Use those 2 tables in joins to MCA whenever need to restrict results
-- to only metro area
--
-- Field called "districttype" identifies charter schools (type=07). 
-- The "traditional" districts are type=01 or type=03. Anything with some other 
-- number are speciality districts that we generally don't pay much attention to
--
-- The schooltype or school classification fields tell you if it's 
-- elementary, middle, senior high, etc. 
--
-- In the MCA table, there are multiple rows for each GRADE in each 
-- school, plus separate records at the district level and the 
-- state level and county LEVEL see the "summarylevel" field to 
-- know which records are which



-- --
-- This query generates the sub-group totals for statewide; also useful for 
-- looking at opt-out rates.
-- Notes: districtnumber 9999 represents all schools statewide
-- Limited to 05-06 and newer years due to changes in the tests
SELECT
  datayear,
  subject,
  reportcategory,
  reportdescription,
  SUM(counttested) as NumTested,
  SUM(countlevel1) as NumLev1,
  SUM(countlevel2) as NumLev2,
  SUM(countlevel3) as NumLev3,
  SUM(countlevel4) as NumLev4,
  COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0) as NumProficient,
  SUM(countabsent) as NumAbsent,
  SUM(countMedExempt) as NumExempt,
  -- CountRefused is no longer used, and split into CountRefusedParent
  -- and CountRefusedStudent
  CASE
    WHEN CountRefused > 0 THEN SUM(CountRefused)
    WHEN (CountRefused = 0 OR CountRefused IS NULL)
      THEN COALESCE(SUM(CountRefusedParent), 0) + COALESCE(SUM(CountRefusedStudent), 0)
    ELSE 0
  END as NumRefused,
  SUM(gradeEnrollment) as Enrollment
FROM
  mca
WHERE
  districtnumber = '9999'
  AND (
    subject = 'M'
    OR subject = 'R'
  )
  AND datayear >= '05-06'
GROUP BY
  datayear,
  subject,
  reportcategory,
  reportdescription
ORDER By
  datayear,
  subject,
  reportcategory,
  reportdescription;



-- --
-- This pulls out the race/ethnicity results to use for looking at achievement gap
-- Notes: they changed the categories a few years ago, splitting Pacific Islander
-- off from Asian and creating 2 or more race field
SELECT
  datayear,
  subject,
  reportdescription,
  COALESCE(SUM(counttested), 0) as NumTested,
  COALESCE(SUM(countlevel1), 0) as NumLev1,
  COALESCE(SUM(countlevel2), 0) as NumLev2,
  COALESCE(SUM(countlevel3), 0) as NumLev3,
  COALESCE(SUM(countlevel4), 0) as NumLev4,
  COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0) as NumProficient,
  (COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0)) / COALESCE(SUM(countTested), 0) as PctProficient
FROM
  mca
WHERE
  districtnumber = '9999'
  AND (
    subject = 'M'
    OR subject = 'R'
  )
  AND reportCategory = 'Race/Ethnicity'
  AND datayear >= '05-06'
GROUP BY
  datayear,
  subject,
  reportdescription
ORDER By
  subject,
  reportdescription,
  datayear;
  
-- --
-- Look at poor kids versus not poor kids is another way to look at 
-- the achievement gap
SELECT
  datayear,
  subject,
  reportdescription,
  COALESCE(SUM(counttested), 0) as NumTested,
  COALESCE(SUM(countlevel1), 0) as NumLev1,
  COALESCE(SUM(countlevel2), 0) as NumLev2,
  COALESCE(SUM(countlevel3), 0) as NumLev3,
  COALESCE(SUM(countlevel4), 0) as NumLev4,
  COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0) as NumProficient,
  (COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0)) / COALESCE(SUM(countTested), 0) as PctProficient
FROM
  mca
WHERE
  districtnumber = '9999'
  AND (
    subject = 'M'
    OR subject = 'R'
  )
  AND reportCategory LIKE '%Economic%'
  AND datayear >= '05-06'
GROUP BY
  datayear,
  subject,
  reportdescription
ORDER By
  subject,
  reportdescription,
  datayear;



-- --
-- This generates the 2 records needed to add to the graphic data
-- "statewide proficiency over time.xlsx"
SELECT
  datayear,
  subject,
  COALESCE(SUM(counttested), 0) as TotTested,
  COALESCE(SUM(countlevel3), 0) as TotLev3,
  COALESCE(SUM(countlevel4), 0) as TotLev4,
  0 as TotLev5,
  COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0) as Countprof,
  (COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0)) / COALESCE(SUM(countTested), 0) as PctProficient
FROM
  mca
WHERE
  -- datayear = '17-18' AND
  districtnumber = '9999'
  AND reportorder = '1'
GROUP BY
  datayear,
  subject;



-- --
-- This query pulls out the sub-group info (like above), except it 
-- is at the district level FOR METRO AREA ONLY.
-- This allows reporters to look at sub-groups within districts; grades 
-- are all collapsed put this in an Excel file for reporters.
-- Can exclude charter schools by adding this to the where line:  districtType<>'07'
SELECT  
  location,
  mca.districtname,
  datayear,
  subject,
  reportcategory,
  reportdescription,
  SUM(counttested) as NumTested,
  SUM(countlevel1) as NumLev1,
  SUM(countlevel2) as NumLev2,
  SUM(countlevel3) as NumLev3,
  SUM(countlevel4) as NumLev4,
  COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0) as NumProficient,
  CASE
    WHEN SUM(counttested) > 0
      THEN (COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0)) / (SUM(counttested))
    ELSE 0
  END as PctProficient
FROM
  mca
    INNER JOIN DistrictList
      ON schoolid = IDnumber
WHERE
  filtered = 'N'
  AND (
    subject = 'M'
    OR subject = 'R'
  )
  AND datayear >= '15-16'
  AND summarylevel = 'district'
  AND metro7county = 'yes'
GROUP BY
  mca.districtname,
  datayear,
  subject,
  reportcategory,
  reportdescription;


-- --
-- District level results; not summarized in any way
SELECT
  datayear, 
  districtnumber, 
  districtType, 
  districtname, 
  schoolnumber, 
  schoolname, 
  grade, 
  subject, 
  reportorder, 
  reportCategory, 
  ReportDescription, 
  filtered, 
  counttested, 
  IFNULL(countLevel3, 0) + IFNULL(countLevel4, 0) as NumProficient,
  CASE
    WHEN counttested > 0
      THEN (IFNULL(countLevel3, 0) + IFNULL(countLevel4, 0)) / counttested
    ELSE 0
  END as PctProficient 
FROM 
  mca
WHERE 
  (
    subject = 'M'
    OR subject = 'R'
  )
  AND datayear >= '05-06' 
  AND schoolnumber = '000' 
  AND filtered = 'N';



-- --
-- Compare 3rd grade over the years at statewide LEVEL
-- I'll be using these queries for a future story
SELECT
  datayear, 
  subject, 
  COALESCE(SUM(counttested), 0) as NumTested, 
  COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0) as NumProficient
FROM
  mca
WHERE
  filtered = 'N'
  AND datayear >= '05-06'
  AND summarylevel = 'state'
  AND grade = '03'
GROUP BY
  datayear,
  subject;

-- --
-- how many kids in poverty each year in third grade; does that help 
-- explain why scores have come down?
SELECT
  datayear,
  SUM(freek12) + SUM(redk12) as Freelunch,
  SUM(k12enr) as TotEnroll
FROM
  enroll_special
WHERE
  grade = '03'
GROUP BY
  datayear;



-- --
-- This query pulls out school-level results (grades are collapsed) for schools in the metro area; 
-- excludes the special education and alternative learning schools
-- includes only 2 most recent years of data
SELECT
  SchoolList.SchoolID, 
  SchoolList.districtname_new, 
  SchoolList.SCHOOLNAME_NEW, 
  SchoolList.Metro7county, 
  SchoolList.Location,
  SchoolList.SchoolType, 
  mca.dataYear, 
  mca.subject, 
  SUM(mca.countTested) as numtested, 
  SUM(mca.countLevel3) + SUM(mca.countLevel4) as NumProf,
  SUM(countabsent) as NumAbsent,
  SUM(countMedExempt) as NumExempt,
  SUM(CountRefused) as NumRefused,
  SUM(gradeEnrollment) as Enrollment 
FROM
  mca
    INNER JOIN SchoolList
      ON mca.schoolid = SchoolList.SchoolID
WHERE
  filtered = 'N'
  AND reportorder = '1' 
  AND metro7county = 'yes' 
  AND SchoolList.classification < '41'
  AND (
    SUBJECT = 'm'
    OR SUBJECT = 'R'
  )
  AND (
    datayear = '16-17'
    OR datayear='17-18'
  )
GROUP BY
  SchoolList.SchoolID, 
  SchoolList.districtname_new, 
  SchoolList.SCHOOLNAME_NEW, 
  SchoolList.Metro7county, 
  SchoolList.Location, 
  SchoolList.SchoolType, 
  mca.dataYear, 
  mca.subject;


-- This pulls out school-level results for all schools in a given district
-- includes just most recent 2 years of data
-- Minneapolis (districtnumber=0001, districtype=03) 
-- St. Paul (districtnumber=0625 and districttype=01) 
-- Anoka-Hennepin (districtnumber=0011 and districttype=01)
SELECT
  mca.schoolid, 
  schoolname_new, 
  schooltype, 
  datayear, 
  subject, 
  reportorder, 
  reportcategory, 
  reportdescription, 
  filtered, 
  SUM(counttested) as NumTested,
  SUM(countlevel1) as NumLev1,
  SUM(countlevel2) as NumLev2,
  SUM(countlevel3) as NumLev3,
  SUM(countlevel4) as NumLev4,
  SUM(countlevel3) + SUM(countlevel4) as NumProf,
  (SUM(countLevel3) + SUM(countLevel4)) / SUM(counttested) as PctProficient,
  SUM(countabsent) as NumAbsent,
  SUM(countMedExempt) as NumExempt,
  SUM(CountRefused) as NumRefused
FROM
  mca
    LEFT JOIN SchoolList
      ON mca.schoolid = SchoolList.schoolid
WHERE
  mca.districtnumber = '0001'
  AND mca.districttype = '03'
  AND filtered = 'N'
  AND datayear >= '16-17'
GROUP BY
  mca.schoolid, 
  schoolname_new, 
  schooltype, 
  datayear, 
  subject, 
  reportorder, 
  reportcategory, 
  reportdescription, 
  filtered
ORDER By 
  datayear, 
  subject, 
  schoolid, 
  reportorder;



-- --
-- This pulls sub-group summary data for a single district
-- Change districtnumber and districttype to change to a different district
SELECT
  districtname, 
  datayear, 
  subject, 
  reportcategory, 
  reportdescription, 
  SUM(counttested) as NumTested, 
  SUM(countlevel1) as NumLev1, 
  SUM(countlevel2) as NumLev2, 
  SUM(countlevel3) as NumLev3, 
  SUM(countlevel4) as NumLev4, 
  SUM(countlevel3) + SUM(countlevel4) as NumProficient,
  SUM(countabsent) as NumAbsent,
  SUM(countMedExempt) as NumExempt,
  SUM(CountRefused) as NumRefused,
  SUM(gradeEnrollment) as Enrollment 
FROM
  mca
WHERE
  -- Update as needed
  districtnumber = '0011' 
  AND districttype = '01' 
  AND filtered = 'N'
GROUP BY
  districtname, 
  datayear, 
  subject, 
  reportcategory, 
  reportdescription
ORDER BY 
  districtname, 
  datayear, 
  subject, 
  reportcategory, 
  reportdescription;



-- --
-- For a district, get achievement breakdown
SELECT
  districtname, 
  datayear, 
  subject, 
  reportcategory, 
  reportdescription, 
  COALESCE(SUM(counttested), 0) as NumTested, 
  COALESCE(SUM(countlevel1), 0) as NumLev1, 
  COALESCE(SUM(countlevel2), 0) as NumLev2, 
  COALESCE(SUM(countlevel3), 0) as NumLev3, 
  COALESCE(SUM(countlevel4), 0) as NumLev4, 
  COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0) as NumProficient,
  CASE
    WHEN COALESCE(SUM(counttested), 0) > 0
      THEN (COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0)) / COALESCE(SUM(counttested), 0)
    ELSE 0
  END as PctProficient,
  COALESCE(SUM(countabsent), 0) as NumAbsent,
  COALESCE(SUM(countMedExempt), 0) as NumExempt,
  COALESCE(SUM(CountRefused), 0) as NumRefused,
  COALESCE(SUM(gradeEnrollment), 0) as Enrollment 
FROM
  mca
WHERE
  -- Update as needed
  -- Minneapolis (districtnumber=0001, districtype=03) 
  -- St. Paul (districtnumber=0625 and districttype=01) 
  -- Anoka-Hennepin (districtnumber=0011 and districttype=01)
  districtnumber = '0625' 
  AND districttype = '01' 
  --
  AND reportCategory = 'Race/Ethnicity' 
  AND dataYear = '17-18'
  AND summaryLevel = 'district'
GROUP BY
  districtname, 
  datayear, 
  subject, 
  reportcategory, 
  reportdescription
ORDER BY 
  districtname, 
  datayear, 
  subject, 
  reportcategory, 
  reportdescription;



-- --
-- Total proficiency for all districts
SELECT
  districtname, 
  datayear, 
  subject,  
  COALESCE(SUM(counttested), 0) as NumTested, 
  COALESCE(SUM(countlevel1), 0) as NumLev1, 
  COALESCE(SUM(countlevel2), 0) as NumLev2, 
  COALESCE(SUM(countlevel3), 0) as NumLev3, 
  COALESCE(SUM(countlevel4), 0) as NumLev4, 
  COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0) as NumProficient,
  CASE
    WHEN COALESCE(SUM(counttested), 0) > 0
      THEN (COALESCE(SUM(countlevel3), 0) + COALESCE(SUM(countlevel4), 0)) / COALESCE(SUM(counttested), 0)
    ELSE 0
  END as PctProficient,
  COALESCE(SUM(countabsent), 0) as NumAbsent,
  COALESCE(SUM(countMedExempt), 0) as NumExempt,
  COALESCE(SUM(CountRefused), 0) as NumRefused,
  COALESCE(SUM(gradeEnrollment), 0) as Enrollment 
FROM
  mca
WHERE
  reportCategory = 'All Categories' 
  AND dataYear = '17-18'
  AND summaryLevel = 'district'
GROUP BY
  districtname, 
  datayear, 
  subject
ORDER BY
  districtname, 
  datayear, 
  subject;



-- OPT OUT RATES


-- This pulls out the key fields you will need, summarized to the state level, for looking at opt-out rates over time

-- TODO: calculate total refused, as it changed last year

SELECT DATAYEAR, GRADE, SUBJECT, SUM(countabsent) AS absentt, SUM(countMedExempt) as exempt, SUM(CountRefused) + SUM(countRefusedParent) + SUM(countRefusedStudent) as refused, SUM(counttested) as tested, SUM(countinvalid) as invalid, SUM(countnotcomplete) as notcomplete, 
SUM(countRefusedParent) as parent, SUM(countRefusedStudent) as student, SUM(countwronggrade) as wronggrd, SUM(gradeenrollment) as OctEnroll
from mca 
where reportorder='1' and districtnumber='9999'
GROUP BY datayear, grade, subject;


-- This pulls out school-level counts to look at opt-out rates by school, just for the most current year

SELECT districtname, schoolname, subject, SUM(countabsent) AS absentt, SUM(countMedExempt) as exempt, SUM(CountRefused) as refused, SUM(counttested) as tested, SUM(countinvalid) as invalid, SUM(countnotcomplete) as notcomplete, 
SUM(countRefusedParent) as parent, SUM(countRefusedStudent) as student, SUM(countwronggrade) as wronggrd, SUM(gradeenrollment) as OctEnroll
from mca
where reportorder='1' and datayear='17-18' and schoolnumber<>'000'
GROUP BY districtname, schoolname, subject
ORDER By 4 desc;














