--import stylequiz excel and store in QUIZEXPORT$
--select important columns into analysis_stylequiz table
select Created_Date, Email, Name, subscribe_or_giftcard, Schedule_call into analysis_stylequiz from QUIZEXPORT$
select * from analysis_stylequiz

-- create temp table 
Create TABLE #cleaned_data
( Email VARCHAR(40), Name VARCHAR(40), 
subscribe_or_giftcard VARCHAR(10), 
Schedule_call VARCHAR(100));
-- convert Datetime data to Date
INSERT INTO #cleaned_data
SELECT CONVERT(VARCHAR(255), [Created_Date], 101),
Email, Name, subscribe_or_giftcard, Schedule_call
FROM analysis_stylequiz 

-- delete duplicate rows
Create TABLE #duplicate_data
(Created_Date Date, Email VARCHAR(40), Name VARCHAR(40), 
subscribe_or_giftcard VARCHAR(10), 
Schedule_call VARCHAR(100),  duplicate_email int);

--only deal with data from 2022.1-2022.7
INsert into #duplicate_data
select *, count(Email) Over (partition by Email) as duplicate_email
from #cleaned_data
where Created_date > '20220101' And Created_date < '20220801' 
AND Email is not null

select * from #duplicate_data
where duplicate_email > 1 
--delete duplicate email
delete from #duplicate_data
where Name = 'Patrick Finley' And Schedule_call = 'Yes, schedule a call to further personalize my box.'
-- drop column
ALTER TABLE #duplicate_data
DROP COLUMN duplicate_email;
drop column duplicate_email from #duplicate_data

--export cleaned data
select * from #duplicate_data
order by Created_Date

create table cleaned_data (
	Created_Date Date, Email VARCHAR(40), Name VARCHAR(40), 
	subscribe_or_giftcard VARCHAR(10), 
	Schedule_call VARCHAR(100)
)

insert into cleaned_data
select * from #duplicate_data
order by Created_Date
