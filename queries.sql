--1. Schools in flood zones (in risk of flood)

select a.sch_name,a.postcode, a.geom as schools_locations,
b.geom as floodwarnings_locations,
st_intersection(a.geom,b.geom) as schools_in_risk
from cw1920.secondary_schools as a
join environ.floodwarning as b 
on st_intersects(a.geom,b.geom)
where a.postcode like 'CF%'
order by a.sch_name;

--2. Proximity of care homes to closest pharmacies and hospitals

select a.name as carehomes_names, a.geom as carehomes_locations,
floor(st_distance(a.geom,b.geom)) as nearest_pharmacies_in_500m, 
floor(st_distance(a.geom,c.geom)) as nearest_hospitals_in_500m,
b.name as pharmacies_names, b.geom as pharmacies_locations,
c.name as hospitals_names, c.geom as hospitals_locations
from cw1920.carehomes as a
join cw1920.pharmacies as b 
on st_dwithin(a.geom,b.geom,500)
join cw1920.hospitals as c 
on st_dwithin(a.geom,c.geom,500)
order by carehomes_names;

--3. Burglary crime rate of in cities

select a.city_name as cities, floor(st_area(a.geom)/1000000) as Km2, count(b.crimetype) as burglaries
from cw1920.major_towns as a
join other.crime_sample as b
on st_contains(a.geom,b.geom)
where b.crimetype = 'Burglary'
and b.month like '%01'
group by a.city_name, b.crimetype, a.geom
order by a.city_name asc;
