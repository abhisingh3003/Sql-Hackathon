select * from daily_cases;
select * from detailed_numbers;


/* Q1. For Each State which district is having highest confirmed cases.  */
select state, district, confirmed from detailed_numbers
where (state, confirmed) in 
(select state, max(confirmed) from
detailed_numbers
group by state);

/* Q2. For the Month with highest cases what was “Cured to Confirmed Ratio” of state with highest deaths. */
select monthname(last_day(date)) as 'Month', sum(new_cases) as 'highest cases' ,(Cured/Total_Confirmed_cases) as 'Ratio' from daily_cases
group by month(date)
order by sum(new_cases) desc
limit 1;

/* Q3. List top 5 districts in which least number of deaths occurred (greater than zero). */
select district, deceased as 'Death' from detailed_numbers
where deceased > 0
order by deceased asc
limit 5;


/* Q4. Which state had highest percentage of deceased cases? */
select state, sum(confirmed) as 'Confirend', sum(deceased) as 'Deceased',
concat((sum(deceased)/sum(confirmed))*100,'%')  as 'percentage of deceased cases'
from detailed_numbers
group by state
order by (sum(deceased)/sum(confirmed))*100 desc
limit 1 ;

/* Q5. Which Month shows highest number of New Cases 
(Represent month as Jan, feb not as 1, 2)? */
select monthname(date) as 'Month', sum(new_cases) as ' New Cases' 
from daily_cases
group by month(date)
order by sum(new_cases) desc
limit 1;


/* Q6. For Each State in which month ratio of cured to confirmed was least (greater than 0)? */
select state,monthname(date),(max(cured)/max(total_confirmed_cases)) as'Ratio' from 
daily_cases
where (cured/total_confirmed_cases)>0
group by state
order by ratio;


/* Q7. For each State which District had min Confirmed Delta Cases */
select state, district, (Delta_Confirmed) from detailed_numbers
where (state, confirmed) in 
(select state, min(delta_confirmed) from
detailed_numbers
group by state );

/* Q8. How Many Deaths Occurred for State codes 
[“AR”, “CT”,” BR “, “DL”, “KA”,” MH”, “UP”] in the month of May. */
select (b.state), a.state_code, (b.death) as deaths, monthname(date) from detailed_numbers as a
left join daily_cases as b on
a.state = b.state
where a.state_code IN ('AR','CT','BR','DL','KA','MH','UP') and monthname(date) = 'May'
group by b.state;

/* Q9. ind out top 20 Districts with best recovery rate for Delta Cases */
select district, sum(delta_confirmed), sum(delta_recovered),
concat((sum(delta_recovered)/sum(delta_confirmed))*100,'%' ) as 'Recovery Rate'
from detailed_numbers
where Delta_Confirmed > '0'
group by district
order by (sum(Delta_Recovered)/sum(Delta_Confirmed))*100 desc
limit 20;

/* Q10. For the state of Maharashtra, Gujarat and Goa 
List down top 2 districts with highest overall recovery rate (Normal + Delta)*/
select * from
(select state, district ,
concat((((recovered + delta_recovered)/(confirmed + delta_confirmed))*100),'%') as 'Recovery',
row_number() over (partition by state 
order by  (((recovered + delta_recovered)/(confirmed + delta_confirmed))*100) desc) as a
from detailed_numbers)rnk
where state in ('Maharashtra','Gujarat','Goa') and a<= 2;
