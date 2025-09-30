* RRF 2025 - Processing Data Template	
*-------------------------------------------------------------------------------	
* Loading data
*------------------------------------------------------------------------------- 	
	
	* Load TZA_CCT_baseline.dta
	use "${data}/Raw/TZA_CCT_baseline.dta", clear
	
*-------------------------------------------------------------------------------	
* Sumamrize and browse data
*------------------------------------------------------------------------------- 	
	
	* Summarize dataset
	summarize
	
	* Browse dataset
	br
	
*-------------------------------------------------------------------------------	
* Checking for unique ID and fixing duplicates
*------------------------------------------------------------------------------- 		

// 	* Check unique IDs
// 	isid hhid
//	
// 	* Check duplicates values in HH IDs
// 	duplicates list hhid
//	
// 	* Browse if duplicated
// 	duplicates tag hhid, gen(dup)
// 	br if dup == 1	
		
	* Identify duplicates using DIME command
	ieduplicates	hhid ///
					using "${outputs}/duplicates.xlsx", ///
					uniquevars(key) 					/// Variables that are truly unique within the data, in this case, key
					keepvars(vid enid submissionday)	///
					nodaily
					
/// After modifying the .xlsx file stating which ones I want to keep (correct) and which ones I want to drop (drop), I need to save the file, close it, and re run the Stata code from the beggining.

*-------------------------------------------------------------------------------	
* Define locals to store variables for each level
*------------------------------------------------------------------------------- 							
	
	* IDs
	local ids 		vid hhid enid
	
	* Unit: household
	local hh_vars 	floor - n_elder ///
					food_cons - submissionday
	
	* Unit: Household-memebr
	local hh_mem	gender age read clinic_visit sick days_sick /// Define them without underscore as they are globals
					treat_fin treat_cost ill_impact days_impact
	
	
	* Define locals with suffix and for reshape
	foreach mem in `hh_mem' {
		
		local mem_vars 		" `mem_vars' `mem'_* "	
		local reshape_mem	" `reshape_mem' `mem'_ "	
	}
		
*-------------------------------------------------------------------------------	
* Tidy Data: HH-member 
*-------------------------------------------------------------------------------*

// 	preserve 

		keep `mem_vars' `ids'

		* Tidy: reshape to hh-mem level 
		reshape long `reshape_mem' , i(`ids') j(member)
		
		* Clean variable names 
		rename *_ *
		
		* Drop missings 
		drop if mi(gender)
		
		* Cleaning using iecodebook
		// recode the non-responses to extended missing
		// add variable/value labels
		// create a template first, then edit the template and change the syntax to 
		// iecodebook apply
		iecodebook template 	using ///
								"${outputs}/hh_mem_codebook.xlsx"
								
		isid ???					
		
		* Save data: Use iesave to save the clean data and create a report 
		iesave 	???  
				
	restore			
		
*-------------------------------------------------------------------------------	
* Tidy Data: HH
*-------------------------------------------------------------------------------	

	preserve 
		
		* Keep HH vars
		keep `ids' `hh_vars'
		
		* Check if data type is string
				
		
		* Fix data types 
		* numeric should be numeric
		* dates should be in the date format
		* Categorical should have value labels 
		
				
		
		* Turn numeric variables with negative values into missings
		ds, has(type ???)
		global ??? ???

		foreach numVar of global numVars {
			
			???
		}	
		
		* Explore variables for outliers
		sum ???
		
		* dropping, ordering, labeling before saving
		drop 	???
				
		order 	???
		
		lab var ???
		
		isid ???
		
		* Save data		
		iesave 	"${data}/Intermediate/???", ///
				idvars(???)  version(???) replace ///
				report(path("${outputs}/???.csv") replace)  
		
	restore
	
*-------------------------------------------------------------------------------	
* Tidy Data: Secondary data
*------------------------------------------------------------------------------- 	
	
	* Import secondary data 
	???
	
	* reshape  
	reshape ???
	
	* rename for clarity
	rename ???
	
	* Fix data types
	encode ???
	
	* Label all vars 
	lab var district "District"
	???
	???
	???
	
	* Save
	keeporder ???
	
	save "${data}/Intermediate/???.dta", replace

	
****************************************************************************end!
	
