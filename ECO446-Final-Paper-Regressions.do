cap log close _all // closes any previously opened log files
log using "ECO446 Final Paper Regressions.log", replace text

/// appending datasets

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

save "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\apple_append.dta", replace


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

rename retail_and_recreation_percent_ch x1111
rename grocery_and_pharmacy_percent_cha x2222
rename parks_percent_change_from_baseli x3333
rename transit_stations_percent_change_ x4444
rename workplaces_percent_change_from_b x5555
rename residential_percent_change_from_ x6666

gen id = _n
reshape long x, i(id) j(mobility_type)
drop id

move province mobility_type
rename x trend

save "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\google_append.dta", replace


clear
// import breton data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\COVID19-Canada-Provinces-master\Data\Canada-COVID19-Stringency.csv", varnames(1) encoding(ISO-8859-2) 
gen time = date(date, "YMD")
format time %td
keep if time <= td(19feb2021)
encode provinceterritory, generate(province)

drop provinceterritory date stringencyindex v1
drop s1_flag s2_flag s3_flag s4_flag s5_flag s6_flag s7_flag s8_flag s9_flag s10_flag s11_flag s12_flag

encode s1_gathering, generate(x1000)
encode s2_maskspublic, generate(x2000)
encode s3_schools, generate(x3000)
encode s4_masksschools, generate(x4000)
encode s5_carehomevisitation, generate(x5000)
encode s6_diningandrestaurants, generate(x6000)
encode s7_nonessentialretailbusiness, generate(x7000)
encode s8_nonessentialservices, generate(x8000)
encode s9_culturalservicesandvenues, generate(x9000)
encode s10_intratravel, generate(x10000)
encode s11_intertravel, generate(x11000)
encode s12_curfew, generate(x12000)

drop s1_gathering s2_maskspublic s3_schools s4_masksschools s6_diningandrestaurants s5_carehomevisitation s7_nonessentialretailbusiness s8_nonessentialservices s9_culturalservicesandvenues s10_intratravel s11_intertravel s12_curfew

gen id = _n
reshape long x, i(id) j(mobility_type)

drop id

move province mobility_type
move time x
rename x trend

save "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\breton_append.dta", replace

clear
// import reopenning data
import delimited "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\covid_indicators_appended.csv"

gen time = date(compiledate, "YMD")
format time %td
keep if time >= td(1mar2020) & time <= td(19feb2021)

keep if jurisdiction == "Alberta" | jurisdiction =="BritishColumbia" | jurisdiction =="Manitoba" | jurisdiction =="NewBrunswick" | jurisdiction =="NewfoundlandAndLabrador" | jurisdiction =="NorthwestTerritories" | jurisdiction == "NovaScotia" | jurisdiction =="Nunavut" | jurisdiction =="Ontario" | jurisdiction =="PrinceEdwardIsland" | jurisdiction =="Quebec" | jurisdiction =="Saskatchewan" | jurisdiction =="Yukon"

encode jurisdiction, generate(province)
drop jurisdiction compiledate

rename cultural x13000
rename borders x14000
rename gatherings x15000
rename manufacturing x16000
rename contact x17000
rename leisure x18000
rename eateries x19000
rename schooling x20000
rename stores x21000

gen id = _n
reshape long x, i(id) j(mobility_type)

drop id
move province mobility_type

rename x trend


save "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\reopeningcovid_append.dta", replace


clear
append using "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\apple_append.dta" "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\breton_append.dta" "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\google_append.dta" "C:\Users\hatho\Desktop\University Stuff\Economics\ECO446\Research Paper Data\Covid Data\reopeningcovid_append.dta"

egen id = group(time province)
rename trend x

reshape wide x, i(id) j(mobility_type)

rename x1 driving
rename x2 transit
rename x3 walking
rename x1111 retail_and_recreation_percent_ch 
rename x2222 grocery_and_pharmacy_percent_cha 
rename x3333 parks_percent_change_from_baseli 
rename x4444 transit_stations_percent_change_ 
rename x5555 workplaces_percent_change_from_b 
rename x6666 residential_percent_change_from_ 
rename x1000 s1_gathering
rename x2000 maskspublic
rename x3000 schools
rename x4000 masksschools
rename x5000 carehomevisitation
rename x6000 diningandrestaurants
rename x7000 nonessentialretailbusiness
rename x8000 nonessentialservices
rename x9000 culturalservicesandvenues
rename x10000 intratravel
rename x11000 intertravel
rename x12000 curfew
rename x13000 cultural
rename x14000 borders
rename x15000 gatherings
rename x16000 manufacturing 
rename x17000 contact
rename x18000 leisure
rename x19000 eateries
rename x20000 schooling
rename x21000 stores

gen wave = 1 if inrange(time, mdy(3,1,2020), mdy(6,1,2020))
	replace wave = 0 if inrange(time, mdy(6,2,2020), mdy(10,1,2020))
	replace wave = 2 if wave == .

// install following packages for this: reghdfe and ftools, using ssc install ___(pkg name)___
	
	
// Breton Main Regressions Overall
reghdfe driving i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province, a(time) keepsing

reghdfe walking i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province, a(time)

reghdfe transit i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province, a(time)

reghdfe workplaces_percent_change_from_b i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province, a(time)

reghdfe retail_and_recreation_percent_ch i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province, a(time)

reghdfe grocery_and_pharmacy_percent_cha i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province, a(time)

reghdfe residential_percent_change_from_ i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province, a(time)

reghdfe parks_percent_change_from_baseli i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province, a(time)

// Reopening Regressions Overall

reghdfe driving i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province, a(time)

reghdfe walking i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province, a(time)

reghdfe transit i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province, a(time)

reghdfe workplaces_percent_change_from_b i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province, a(time)

reghdfe retail_and_recreation_percent_ch i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province, a(time)

reghdfe residential_percent_change_from_ i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province, a(time)

reghdfe parks_percent_change_from_baseli i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province, a(time)

reghdfe grocery_and_pharmacy_percent_cha i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province, a(time)

// Breton Main Regressions First Wave
reghdfe driving i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 1, a(time)

reghdfe walking i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 1, a(time)

reghdfe transit i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 1, a(time)

reghdfe workplaces_percent_change_from_b i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 1, a(time)

reghdfe retail_and_recreation_percent_ch i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 1, a(time)

reghdfe residential_percent_change_from_ i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 1, a(time)

reghdfe grocery_and_pharmacy_percent_cha i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 1, a(time)

reghdfe parks_percent_change_from_baseli i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 1, a(time)

// Reopenning Regressions Reopening Phase

reghdfe driving i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province if wave == 0, a(time)

reghdfe walking i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province if wave == 0, a(time)

reghdfe transit i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province if wave == 0, a(time)

reghdfe workplaces_percent_change_from_b i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province if wave == 0, a(time)

reghdfe retail_and_recreation_percent_ch i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province if wave == 0, a(time)

reghdfe residential_percent_change_from_ i.stores i.schooling i.borders i.eateries i.cultural i.gatherings i.province if wave == 0, a(time)

// Breton Main Regressions Second Wave
reghdfe driving i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 2, a(time)

reghdfe walking i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 2, a(time)

reghdfe transit i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 2, a(time)

reghdfe workplaces_percent_change_from_b i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 2, a(time)

reghdfe retail_and_recreation_percent_ch i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 2, a(time)

reghdfe residential_percent_change_from_ i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 2, a(time)

reghdfe grocery_and_pharmacy_percent_cha i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 2, a(time)

reghdfe parks_percent_change_from_baseli i.nonessentialretailbusiness i.nonessentialservices i.culturalservicesandvenues i.schools i.intertravel i.intratravel i.diningandrestaurants i.province if wave == 2, a(time)


log close	




