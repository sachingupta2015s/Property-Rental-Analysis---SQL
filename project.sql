--- creating Database

create database pr_anly;
use pr_anly

---altering datatypes for use

alter table review_dallas_df alter column "listing_id" varchar (max)
alter table review_dallas_df alter column "listing_id" bigint

alter table review_austin_df alter column "id" varchar (max)
alter table review_austin_df alter column "id" bigint

alter table listing_dallas_df alter column "id" varchar (max)
alter table listing_dallas_df alter column "id" bigint

alter table listing_austin_df alter column "name" varchar (max)
alter table listing_austin_df alter column "property_type" varchar (max)
alter table listing_austin_df alter column "room_type" varchar (max)
alter table listing_austin_df alter column "instant_bookable" varchar (max)


alter table listing_dallas_df alter column "name" varchar (max)
alter table listing_dallas_df alter column "property_type" varchar (max)
alter table listing_dallas_df alter column "room_type" varchar (max)
alter table listing_austin_df alter column "neighbourhood_cleansed" varchar (max)
select * from df_austin_availability

/*a. Analyze different metrics to draw the distinction between the different types of property along with 
      their price listings(bucketize them within 3-4 categories basis your understanding):
      To achieve this, you can use the following metrics and explore a few yourself as well. 
	  Availability within 15,30,45,etc. days, Acceptance Rate, Average no of bookings, reviews, etc.*/ 

select * from listing_austin_df
select * from df_dallas_availability
select * from review_austin_df
select * from host_austin_df

---(i) based on average ratings (individual cities, years combined)
select room_type, 
avg ((review_scores_rating + review_scores_accuracy + review_scores_checkin + review_scores_cleanliness
+ review_scores_communication + review_scores_location + review_scores_value)  / 7)
as average_ratings from listing_austin_df
group by room_type

select room_type, 
avg ((review_scores_rating + review_scores_accuracy + review_scores_checkin + review_scores_cleanliness
+ review_scores_communication + review_scores_location + review_scores_value)  / 7)
as average_ratings from listing_dallas_df
group by room_type

---based on accomodation (Combined for 2 years)

select A.*,B.Avg_accomodates_Dallas from
(select A.property_type, Avg(accommodates) as Avg_accomodates_austin from listing_austin_df as A
inner join df_austin_availability as B
on A.id=b.id group by property_type) as A inner join
(select A.property_type, Avg(accommodates) as Avg_accomodates_Dallas from listing_dallas_df as A
inner join df_dallas_availability as B
on A.id=b.id group by property_type) as B
on A.property_type=B.property_type



---b. Study the trends of the different categories and provide insights on same

SELECT room_type, avg(price) as avg_price_austin
 from listing_austin_df group by room_type          

 SELECT room_type, avg(price) as avg_price_dallas
 from listing_dallas_df group by room_type  


 --- based on property type (individual)
 select property_type, room_type, avg(price) as average_price
from listing_austin_df
group by property_type, room_type order by avg(price) desc;

 select property_type, room_type, avg(price) as average_price
from listing_dallas_df
group by property_type, room_type order by avg(price) desc;

-- max price top 10
select top 10 property_type, room_type, max(price) as maximum_price
from listing_austin_df
group by property_type, room_type order by max(price) desc;

--- minimum price top 10
select top 10 property_type, room_type, min(price) as maximum_price
from listing_austin_df
group by property_type, room_type order by min(price) desc;




---c. Using the above analysis, identify top 2 crucial metrics which makes different property types 
--    along their listing price stand ahead of other categories





---d. Analyze how does the comments of reviewers vary for listings of distinct categories
--      (Extract words from the comments provided by the reviewers)

--- INDIVIDUAL CITY - DALLAS
with CTE1 as
(select A.property_type, Count (B.Comments) as Beautiful from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%Beautiful%'
group by a.property_type),
CTE2 as
(select A.property_type, Count (B.Comments) as great from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%great%'
group by A.property_type),
CTE3 AS
(select A.property_type, Count (B.Comments) as Awsome from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%Awsome%'
group by A.property_type),
CTE4 AS
(select A.property_type, Count (B.Comments) as Perfect from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%Perfect%'
group by A.property_type),
CTE5 AS
(select A.property_type, Count (B.Comments) as Fantastic from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%Fantastic%'
group by A.property_type),
CTE6 AS
(select A.property_type, Count (B.Comments) as Bad from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%Bad%'
group by A.property_type),
CTE7 AS
(select A.property_type, Count (B.Comments) as negative from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%negative%'
group by A.property_type),
CTE8 AS
(select A.property_type, Count (B.Comments) as worst from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%worst%'
group by A.property_type),
CTE9 AS
(select A.property_type, Count (B.Comments) as Late from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%Late%'
group by A.property_type),
CTE10 AS
(select A.property_type, Count (B.Comments) as Horrible from listing_dallas_df as A
Inner join review_dallas_df as B on A.id=B.listing_id
where B.Comments like '%Horrible%'
group by A.property_type)
Select A.property_type, (Beautiful + Great + Awsome + Perfect + Fantastic) as Positive_Rating,
(Bad + Negative + worst + late + horrible) as Negative_Rating
from CTE1  as A
inner join CTE2 as B on A.property_type = B.Property_type
inner join CTE3 as C on B.property_type = C.Property_type
inner join CTE4 as D on C.property_type = D.Property_type
inner join CTE5 as E on D.property_type = E.Property_type
inner join CTE6 as F on E.property_type = F.Property_type
inner join CTE7 as G on F.property_type = G.Property_type
inner join CTE8 as H on G.property_type = H.Property_type
inner join CTE9 as I on H.property_type = I.Property_type
inner join CTE10 as J on I.property_type = J.Property_type

---breaking query into smaller parts
with CTE1 as
(select A.property_type, Count (B.Comments) as Beautiful from listing_austin_df as A
Inner join review_austin_df as B on A.id=B.listing_id
where B.Comments like '%Beautiful%'
group by a.property_type),
CTE2 as
(select A.property_type, Count (B.Comments) as great from listing_austin_df as A
Inner join review_austin_df as B on A.id=B.listing_id
where B.Comments like '%great%'
group by A.property_type),
CTE3 AS
(select A.property_type, Count (B.Comments) as Awsome from listing_austin_df as A
Inner join review_austin_df as B on A.id=B.listing_id
where B.Comments like '%Awsome%'
group by A.property_type),
CTE4 AS
(select A.property_type, Count (B.Comments) as Perfect from listing_austin_df as A
Inner join review_austin_df as B on A.id=B.listing_id
where B.Comments like '%Perfect%'
group by A.property_type),
CTE5 AS
(select A.property_type, Count (B.Comments) as Fantastic from listing_austin_df as A
Inner join review_austin_df as B on A.id=B.listing_id
where B.Comments like '%Fantastic%'
group by A.property_type)
Select A.property_type, (Beautiful + Great + Awsome + Perfect + Fantastic) as Positive_Rating
from CTE1  as A
inner join CTE2 as B on A.property_type = B.Property_type
inner join CTE3 as C on B.property_type = C.Property_type
inner join CTE4 as D on C.property_type = D.Property_type
inner join CTE5 as E on D.property_type = E.Property_type





---e. Analyze if there is any correlation between property type and their availability across the months

---based on availability (combined years)
select property_type, count (case when available = 'true' then 1 end) as Available,
count (case when Available = 'false' then 1 end) as Not_available 
from (select a.id, a.name, a.property_type, b.available from (
(select * from listing_austin_df union select * from listing_dallas_df) as A
inner join (select * from df_austin_availability union select * from df_dallas_availability) as B
on A.id=B.id)) AA
Group by property_type

--- based on years

select room_type, month (date) as Month, year (date) as year,Count (case when Available= 'true' then 1 end) as Available,
Count (case when Available= 'false'  then 1 end) as Not_Available from 
(select * from df_austin_availability union select * from df_dallas_availability) as A inner join
(select * from listing_austin_df union select * from listing_dallas_df) as B
on A.id=b.id
group by room_type, month (date), year (date)
order by room_type, month (date), Not_Available 

---austin
select room_type, month (date) as Month, year (date) as year,Count (case when Available= 'true' then 1 end) as Available,
Count (case when Available= 'false'  then 1 end) as Not_Available from 
(df_austin_availability as A inner join
listing_austin_df as B
on A.id=b.id)
group by room_type, month (date), year (date)
order by room_type, month (date), Not_Available 

---dallas
select room_type, month (date) as Month, year (date) as year,Count (case when Available= 'true' then 1 end) as Available,
Count (case when Available= 'false'  then 1 end) as Not_Available from 
(df_dallas_availability as A inner join
listing_dallas_df as B
on A.id=b.id)
group by room_type, month (date), year (date)
order by room_type, month (date), Not_Available 






---f. Analyze what are the peak and off-peak time for the different categories of property type and their listings. 
--    Do we see some commonalities in the trend or is it dependent on the category

---room type
select room_type, month (date) as Month, year (date) as year,Count (case when Available= 'true' then 1 end) as Available,
Count (case when Available= 'false'  then 1 end) as Not_Available from 
(select * from df_austin_availability union select * from df_dallas_availability) as A inner join
(select * from listing_austin_df union select * from listing_dallas_df) as B
on A.id=b.id
group by room_type, month (date), year (date)
order by room_type, month (date), Not_Available 

---property type
select property_type, month (date) as Month, year (date) as year,Count (case when Available= 'true' then 1 end) as Available,
Count (case when Available= 'false'  then 1 end) as Not_Available from 
(select * from df_austin_availability union select * from df_dallas_availability) as A inner join
(select * from listing_austin_df union select * from listing_dallas_df) as B
on A.id=b.id
group by property_type, month (date), year (date)
order by property_type, month (date), Not_Available 






---g. Using the above analysis, suggest what is the best performing category for the company
as per the data available for both the cities combined
, Entire home / Apartments has the heighest demand followed by Hotel rooms.



---h. Analyze the above trends for the two cities for which data has been provided and provide insights on comparison

--AVG PRICE

select A.*,B.Avg_price_Dallas from
(select A.property_type, Avg(B.Price) as Avg_price_austin from listing_austin_df as A
inner join df_austin_availability as B
on A.id=b.id group by property_type) as A inner join
(select A.property_type, Avg(B.Price) as Avg_price_Dallas from listing_dallas_df as A
inner join df_dallas_availability as B
on A.id=b.id group by property_type) as B
on A.property_type=B.property_type

---ACCOMODATION

select A.*,B.Avg_accomodates_Dallas from
(select A.property_type, Avg(accommodates) as Avg_accomodates_austin from listing_austin_df as A
inner join df_austin_availability as B
on A.id=b.id group by property_type) as A inner join
(select A.property_type, Avg(accommodates) as Avg_accomodates_Dallas from listing_dallas_df as A
inner join df_dallas_availability as B
on A.id=b.id group by property_type) as B
on A.property_type=B.property_type

