//// all graphs for the project 

clear
// import formatted apple data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\Formatted-Apple-Mobility-Trends.csv"
//change the date type
gen time = date(date, "MDY")
format time %td
keep if time >= td(1mar2020) & time <= td(19feb2021)
keep if region_type == ""
drop date region_type region_name 

rename mobility_type type 
encode type, generate(mobility_type)
drop type

rename province prov
encode prov, generate(province)
drop prov

move trend mobility_type
move time mobility_type
move time trend
move province mobility_type


set scheme s1color

drop if province == 8 // no observations

line trend time if mobility_type == 1 & time >= td(1mar2020) & time <= td(1apr2020), by(province)
line trend time if mobility_type == 1 & time >= td(1oct2020) & time <= td(1nov2020), by(province)
line trend time if mobility_type == 2 & time >= td(1mar2020) & time <= td(1apr2020), by(province)
line trend time if mobility_type == 2 & time >= td(1oct2020) & time <= td(1nov2020), by(province)
line trend time if mobility_type == 3 & time >= td(1mar2020) & time <= td(1apr2020), by(province)
line trend time if mobility_type == 3 & time >= td(1oct2020) & time <= td(1nov2020), by(province)


clear
// import the google data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\2020_CA_Region_Mobility_Report.csv"
// change the date string variable to use in graphs
gen time = date(date, "YMD")
format time %td
keep if time >= td(1mar2020) & time <= td(19feb2021)
keep sub_region_1 iso_3166_2_code retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha parks_percent_change_from_baseli transit_stations_percent_change_ workplaces_percent_change_from_b residential_percent_change_from_ time
drop if missing(iso_3166_2_code)
rename sub_region_1 prov
drop iso_3166_2_code
encode prov, generate(province)
drop prov

set scheme s1color

line workplaces_percent_change_from_b  time if time >= td(1mar2020) & time <= td(1apr2020), by(province)
line workplaces_percent_change_from_b  time if time >= td(1oct2020) & time <= td(1nov2020), by(province)
line retail_and_recreation_percent_ch time if time >= td(1mar2020) & time <= td(1apr2020), by(province)

drop if province == 8
line retail_and_recreation_percent_ch time if time >= td(1oct2020) & time <= td(1nov2020), by(province)
line grocery_and_pharmacy_percent_cha time if time >= td(1mar2020) & time <= td(1apr2020), by(province)

drop if province == 6
drop if province == 13

line grocery_and_pharmacy_percent_cha time if time >= td(1oct2020) & time <= td(1nov2020), by(province)
line residential_percent_change_from_ time if time >= td(1mar2020) & time <= td(1apr2020), by(province)
line residential_percent_change_from_ time if time >= td(1oct2020) & time <= td(1nov2020), by(province)

drop if province == 10

line parks_percent_change_from_baseli  time if time >= td(1mar2020) & time <= td(1apr2020), by(province)
line parks_percent_change_from_baseli  time if time >= td(1oct2020) & time <= td(1nov2020), by(province)


clear
// import breton first wave start date dataset
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\Policy-Implementation-Dates.csv", varnames(1) 

gen stateofemergency = date( declaredstateofemergency , "DMY")
format stateofemergency %td

gen schoolclosure = date( closedk12schools , "DMY")
format schoolclosure %td

gen visitstolongtermcarehomeban = date( bannedvisitstolongtermcarehomes , "DMY")
format visitstolongtermcarehomeban %td

gen nonessentialbusinessclosure = date( closednonessentialbusinesses , "DMY")
format nonessentialbusinessclosure   %td

gen selfisolationfines = date(finesfornotrespectingselfisolati , "DMY")
format selfisolationfines %td

gen restaurantrestrictions = date(restrictedrestaurantcapacity,"DMY")
format restaurantrestrictions %td

gen restaurantsclosed = date(closedrestaurantsexcepttakeout, "DMY")
format restaurantsclosed %td

gen interprovincialrestriction = date(restrictionsoninterprovincialter, "DMY")
format interprovincialrestriction %td

gen intraprovincialrestriction = date(intraprovincialtravelrestriction, "DMY")
format intraprovincialrestriction %td

encode provinceterritory , generate(province)

set scheme s1color 

twoway (dot stateofemergency schoolclosure visitstolongtermcarehomeban nonessentialbusinessclosure restaurantrestrictions selfisolationfines restaurantsclosed interprovincialrestriction intraprovincialrestriction  province, horizontal), ylabel(1 "Alberta" 2 "British Columbia" 3 "Manitoba" 4 "New Brunswick" 5 "Newfoundland and Labrador" 6 "Northwest Territories" 7 "Nova Scotia" 8 "Nunavut" 9  "Ontario" 10 "Prince Edward Island" 11 "Quebec" 12 "Saskatchewan" 13 "Yukon")


clear
// import breton data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\Canada-COVID19-Stringency.csv", varnames(1) encoding(ISO-8859-2) 
gen time = date(date, "YMD")
format time %td
keep if time <= td(19feb2021)
encode provinceterritory, generate(province)

keep provinceterritory s3_schools s6_diningandrestaurants s7_nonessentialretailbusiness s8_nonessentialservices s9_culturalservicesandvenues s10_intratravel s11_intertravel time

// policy strictness for each province
encode s9_culturalservicesandvenues , generate(cultural_services)
replace cultural_services = 0 if cultural_services == 1
replace cultural_services = 1 if cultural_services == 2
replace cultural_services = 2 if cultural_services == 3

encode s3_schools, generate(school_closures)
replace school_closures = 0 if school_closures == 1
replace school_closures = 1 if school_closures == 2
replace school_closures = 2 if school_closures == 3
replace school_closures = 3 if school_closures == 4

encode s6_diningandrestaurants , generate(dining_and_restaurants)
replace dining_and_restaurants = 0 if dining_and_restaurants == 1
replace dining_and_restaurants = 1 if dining_and_restaurants == 2
replace dining_and_restaurants = 2 if dining_and_restaurants == 3

encode s7_nonessentialretailbusiness, generate(non_essential_businesses)
replace non_essential_businesses = 0 if non_essential_businesses  == 1
replace non_essential_businesses  = 1 if non_essential_businesses  == 2
replace non_essential_businesses  = 2 if non_essential_businesses  == 3

encode s8_nonessentialservices, generate(non_essential_services)
replace non_essential_services = 0 if non_essential_services == 1
replace non_essential_services = 1 if non_essential_services == 2
replace non_essential_services = 2 if non_essential_services == 3

encode s11_intertravel , generate(interprovincial_travel)
replace interprovincial_travel = 0 if interprovincial_travel == 1
replace interprovincial_travel = 1 if interprovincial_travel == 2

encode s10_intratravel , generate(intraprovincial_travel)
replace intraprovincial_travel = 0 if intraprovincial_travel == 1
replace intraprovincial_travel = 1 if intraprovincial_travel == 2


label variable cultural_services "cultural services"
label variable school_closures "school closure"
label variable dining_and_restaurants "dining and restaurants"
label variable non_essential_businesses "non-essential retial businesses"
label variable non_essential_services "non-essential services"
label variable interprovincial_travel "interprovincial travel"
label variable intraprovincial_travel "intraprovincial travel"

// graphs for each province
twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services interprovincial_travel time if provinceterritory == "Alberta"), title("Alberta")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "British Columbia"), title("British Columbia")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Manitoba"), title("Manitoba")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "New Brunswick"), title("New Brunswick")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Newfoundland and Labrador"),title("Newfoundland and Labrador")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Northwest Territories"), title("Northwest Territories")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Nova Scotia"), title("Nova Scotia")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Nunavut"), title("Nunavut")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Ontario"), title("Ontario")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Prince Edward Island"), title("Prince Edward Island")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Quebec"), title("Quebec")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Saskatchewan"), title("Saskatchewan")

twoway (scatter cultural_services school_closures dining_and_restaurants non_essential_businesses non_essential_services intraprovincial_travel interprovincial_travel time if provinceterritory == "Yukon"), title("Yukon")


clear
// import reopenning data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\covid_indicators_appended.csv"

gen time = date(compiledate, "YMD")
format time %td
keep if time >= td(1mar2020) & time <= td(19feb2021)

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "Alberta"), ylabel(1(1)5) title("Alberta")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "BritishColumbia"), ylabel(1(1)5) title("British Columbia")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "Manitoba"), ylabel(1(1)5) title("Manitoba")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "NewBrunswick"), ylabel(1(1)5) title("New Brunswick")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "NewfoundlandAndLabrador"), ylabel(1(1)5) title("Newfoundland And Labrador")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "NorthwestTerritories"), ylabel(1(1)5) title("Northwest Territories")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "NovaScotia"), ylabel(1(1)5) title("Nova Scotia")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "Nunavut"), ylabel(1(1)5) title("Nunavut")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "Ontario"), ylabel(1(1)5) title("Ontario")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "PrinceEdwardIsland"), ylabel(1(1)5) title("Prince Edward Island")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "Quebec"), ylabel(1(1)5) title("Quebec")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "Saskatchewan"), ylabel(1(1)5) title("Saskatchewan")

twoway (scatter cultural borders eateries schooling stores time if jurisdiction == "Yukon"), ylabel(1(1)5) title("Yukon")


// for overall smooth trend graphs from google and apple

//// parks_percent_change_from_baseli
clear
// import the google data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\2020_CA_Region_Mobility_Report.csv"

// change the date string variable to use in graphs
gen time = date(date, "YMD")
format time %td

keep iso_3166_2_code parks_percent_change_from_baseli time
drop if missing(iso_3166_2_code)

encode iso_3166_2_code, gen(province)

drop if iso_3166_2_code == "CA-PE" 
drop if iso_3166_2_code == "CA-YT"
drop if iso_3166_2_code == "CA-NU" 
drop if iso_3166_2_code == "CA-NT"

sepscatter parks_percent_change_from_baseli time, sep(province) recast(line) ///
legend(pos(3) col(1)) xtitle("time")

egen id = group(time)
move id time
drop iso_3166_2_code

rename parks_percent_change_from_baseli x
reshape wide x, i(id) j(province)

tsset time

//generate line graph for each state
local mygraph "`mygraph'"
foreach var of varlist x1-x9 {
    local mygraph "line `var' time if time>td(11mar2020) & time<td(01jun2020), lc(erose) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01jun2020) & time<td(01oct2020), lc(eltblue) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01oct2020) & time<=td(23feb2021), lc(erose) lw(thin) ||  `mygraph'"
}

egen ur_mean = rowmean(x1-x9)
tssmooth ma ubar = ur_mean, w(7 0 0 )
line x1-x9 time , c(L) lc(gs13 ..) lw(thin ..)  /// 
    || `mygraph '  /// 
    || line ubar time , lw(medthick) lc(black) /// 
    ||, legend(off)	
	
	
//// grocery and pharmacy
clear
// import the google data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\2020_CA_Region_Mobility_Report.csv"

// change the date string variable to use in graphs
gen time = date(date, "YMD")
format time %td

keep iso_3166_2_code grocery_and_pharmacy_percent_cha time
drop if missing(iso_3166_2_code)

encode iso_3166_2_code, gen(province)

drop if iso_3166_2_code == "CA-NT" 
drop if iso_3166_2_code == "CA-YT"
drop if iso_3166_2_code == "CA-YT"

sepscatter grocery_and_pharmacy_percent_cha time, sep(province) recast(line) ///
legend(pos(3) col(1)) xtitle("time")

egen id = group(time)
move id time
drop iso_3166_2_code

rename grocery_and_pharmacy_percent_cha x
reshape wide x, i(id) j(province)

tsset time

//generate line graph for each state
local mygraph "`mygraph'"
foreach var of varlist x1-x10 {
    local mygraph "line `var' time if time>td(11mar2020) & time<td(01jun2020), lc(erose) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01jun2020) & time<td(01oct2020), lc(eltblue) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01oct2020) & time<=td(23feb2021), lc(erose) lw(thin) ||  `mygraph'"
}

egen ur_mean = rowmean(x1-x10)
tssmooth ma ubar = ur_mean, w(7 0 0 )
line x1-x10 time , c(L) lc(gs13 ..) lw(thin ..)  /// 
    || `mygraph '  /// 
    || line ubar time , lw(medthick) lc(black) /// 
    ||, legend(off)
	
// retail and recreation
clear
// import the google data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\2020_CA_Region_Mobility_Report.csv"

set scheme s1color 

// change the date string variable to use in graphs
gen time = date(date, "YMD")
format time %td

keep iso_3166_2_code retail_and_recreation_percent_ch time
drop if missing(iso_3166_2_code)

describe

encode iso_3166_2_code, gen(province)
egen id = group(time)
move id time
drop iso_3166_2_code

rename retail_and_recreation_percent_ch x
reshape wide x, i(id) j(province)

tsset time

//generate line graph for each state
local mygraph "`mygraph'"
foreach var of varlist x1-x13 {
    local mygraph "line `var' time if time>td(11mar2020) & time<td(01jun2020), lc(erose) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01jun2020) & time<td(01oct2020), lc(eltblue) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01oct2020) & time<=td(23feb2021), lc(erose) lw(thin) ||  `mygraph'"
}

egen ur_mean = rowmean(x1-x13)
tssmooth ma ubar = ur_mean, w(7 0 0 )
line x1-x13 time , c(L) lc(gs13 ..) lw(thin ..)  /// 
    || `mygraph '  /// 
    || line ubar time , lw(medthick) lc(black) /// 
    ||, legend(off)	

	
// workplaces_percent_change_from_b
clear
// import the google data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\2020_CA_Region_Mobility_Report.csv"

// change the date string variable to use in graphs
gen time = date(date, "YMD")
format time %td

keep iso_3166_2_code workplaces_percent_change_from_b time
drop if missing(iso_3166_2_code)

encode iso_3166_2_code, gen(province)
egen id = group(time)
move id time
drop iso_3166_2_code

rename workplaces_percent_change_from_b x
reshape wide x, i(id) j(province)

tsset time

//generate line graph for each state
local mygraph "`mygraph'"
foreach var of varlist x1-x13 {
    local mygraph "line `var' time if time>td(11mar2020) & time<td(01jun2020), lc(erose) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01jun2020) & time<td(01oct2020), lc(eltblue) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01oct2020) & time<=td(23feb2021), lc(erose) lw(thin) ||  `mygraph'"
}

egen ur_mean = rowmean(x1-x13)
tssmooth ma ubar = ur_mean, w(7 0 0 )
line x1-x13 time , c(L) lc(gs13 ..) lw(thin ..)  /// 
    || `mygraph '  /// 
    || line ubar time , lw(medthick) lc(black) /// 
    ||, legend(off)	


//residential_percent_change_from_
clear
// import the google data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\2020_CA_Region_Mobility_Report.csv"

// change the date string variable to use in graphs
gen time = date(date, "YMD")
format time %td

keep iso_3166_2_code residential_percent_change_from_ time
drop if missing(iso_3166_2_code)

encode iso_3166_2_code, gen(province)
egen id = group(time)
move id time
drop iso_3166_2_code

rename residential_percent_change_from_ x
reshape wide x, i(id) j(province)

tsset time

//generate line graph for each state
local mygraph "`mygraph'"
foreach var of varlist x1-x13 {
    local mygraph "line `var' time if time>td(11mar2020) & time<td(01jun2020), lc(erose) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01jun2020) & time<td(01oct2020), lc(eltblue) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01oct2020) & time<=td(23feb2021), lc(erose) lw(thin) ||  `mygraph'"
}

egen ur_mean = rowmean(x1-x13)
tssmooth ma ubar = ur_mean, w(7 0 0 )
line x1-x13 time , c(L) lc(gs13 ..) lw(thin ..)  /// 
    || `mygraph '  /// 
    || line ubar time , lw(medthick) lc(black) /// 
    ||, legend(off)	
	
//trend 1 - driving
clear
// import formatted apple data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\Formatted-Apple-Mobility-Trends.csv"
//change the date type
gen time = date(date, "MDY")
format time %td
keep if time >= td(1mar2020) & time <= td(19feb2021)
keep if region_type == ""
drop date region_type region_name 

rename mobility_type type 
encode type, generate(mobility_type)
drop type

rename province prov
encode prov, generate(province)
drop prov

egen id = group(time province)

reshape wide trend, i(id) j(mobility_type)
drop id

keep province trend1 time

sepscatter trend1 time, sep(province) recast(line) ///
legend(pos(3) col(1)) xtitle("time") ytitle("Driving % Change")

egen id = group(time)
move id time

rename trend1 x
reshape wide x, i(id) j(province)

tsset time

//generate line graph for each state
local mygraph "`mygraph'"
foreach var of varlist x1-x13 {
    local mygraph "line `var' time if time>td(11mar2020) & time<td(01jun2020), lc(erose) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01jun2020) & time<td(01oct2020), lc(eltblue) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01oct2020) & time<=td(23feb2021), lc(erose) lw(thin) ||  `mygraph'"
}

egen ur_mean = rowmean(x1-x13)
tssmooth ma ubar = ur_mean, w(7 0 0 )
line x1-x13 time , c(L) lc(gs13 ..) lw(thin ..)  /// 
    || `mygraph '  /// 
    || line ubar time , lw(medthick) lc(black) /// 
    ||, legend(off)	

//trend 2 - transit
clear
// import formatted apple data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\Formatted-Apple-Mobility-Trends.csv"
//change the date type
gen time = date(date, "MDY")
format time %td
keep if time >= td(1mar2020) & time <= td(19feb2021)
keep if region_type == ""
drop date region_type region_name 

rename mobility_type type 
encode type, generate(mobility_type)
drop type

rename province prov
encode prov, generate(province)
drop prov

egen id = group(time province)

reshape wide trend, i(id) j(mobility_type)
drop id

keep province trend2 time

sepscatter trend2 time, sep(province) recast(line) ///
legend(pos(3) col(1)) xtitle("time") ytitle("Transit % Change")

egen id = group(time)
move id time

rename trend2 x
reshape wide x, i(id) j(province)

tsset time

//generate line graph for each state
local mygraph "`mygraph'"
foreach var of varlist x1-x13 {
    local mygraph "line `var' time if time>td(11mar2020) & time<td(01jun2020), lc(erose) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01jun2020) & time<td(01oct2020), lc(eltblue) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01oct2020) & time<=td(23feb2021), lc(erose) lw(thin) ||  `mygraph'"
}

egen ur_mean = rowmean(x1-x13)
tssmooth ma ubar = ur_mean, w(7 0 0 )
line x1-x13 time , c(L) lc(gs13 ..) lw(thin ..)  /// 
    || `mygraph '  /// 
    || line ubar time , lw(medthick) lc(black) /// 
    ||, legend(off)	

	
//trend 3 - walking
clear
// import formatted apple data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\Formatted-Apple-Mobility-Trends.csv"
//change the date type
gen time = date(date, "MDY")
format time %td
keep if time >= td(1mar2020) & time <= td(19feb2021)
keep if region_type == ""
drop date region_type region_name 

rename mobility_type type 
encode type, generate(mobility_type)
drop type

rename province prov
encode prov, generate(province)
drop prov

egen id = group(time province)

reshape wide trend, i(id) j(mobility_type)
drop id

keep province trend3 time

egen id = group(time)
move id time

rename trend3 x
reshape wide x, i(id) j(province)

tsset time

//generate line graph for each state
local mygraph "`mygraph'"
foreach var of varlist x1-x13 {
    local mygraph "line `var' time if time>td(11mar2020) & time<td(01jun2020), lc(erose) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01jun2020) & time<td(01oct2020), lc(eltblue) lw(thin) ||  `mygraph'"
	local mygraph "line `var' time if time>=td(01oct2020) & time<=td(23feb2021), lc(erose) lw(thin) ||  `mygraph'"
}

egen ur_mean = rowmean(x1-x13)
tssmooth ma ubar = ur_mean, w(7 0 0 )
line x1-x13 time , c(L) lc(gs13 ..) lw(thin ..)  /// 
    || `mygraph '  /// 
    || line ubar time , lw(medthick) lc(black) /// 
    ||, legend(off)	
