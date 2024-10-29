# Consolidating ENAHO Modules in Stata

ENAHO data is organized into multiple modules, each covering a different topic (e.g., demographics, employment, income). To conduct comprehensive analyses, you’ll often need to combine information across modules and across years. Here’s a basic approach to consolidating ENAHO data:

Merging: Use merge to combine different modules for the same year. Merging allows you to match records by common identifiers, like household or individual IDs, linking information from various modules.

Appending: Use append to stack data from the same module across different years, which lets you build time series or analyze trends.

Creating Temporary Files: Working with large datasets can be memory-intensive. Creating and saving temporary files for intermediate steps helps avoid memory issues until you’ve built the final consolidated dataset.

## Key Considerations When Working with ENAHO

When consolidating ENAHO data, keep in mind the following:

Variable Name Changes: Variable names sometimes change between years. To ensure consistency, review the variable names in each module before merging or appending datasets.

Changes in Variable Categories: Categories within variables may also shift over time. For example, employment status categories might be redefined in a way that affects your analysis. Check each module’s documentation and codebook to understand these differences.

Expansion Factors: ENAHO data includes expansion factors (also called "weights") to ensure that estimates reflect the population accurately. Choose the appropriate expansion factor—either household or individual—based on the analysis you’re performing. We’ll cover how to apply expansion factors in Stata in future notes.

## Example Stata Code
Here is a basic example of how to consolidate data from ENAHO using merge and append in Stata. Remember, this code is just a starting point and may require modifications based on your specific modules and analysis goals.

``` js

// Clear all existing data and settings
clear all

// Display and store the machine hostname, useful for user-specific file paths
dis "`c(hostname)'"
local machine "`c(hostname)'" // Save the hostname for user-specific file paths

// Specify file paths based on the machine's hostname
#delimit ;  // Switch to `;` as the delimiter for multi-line commands

if "`machine'" == "WORKSTATION_1" {; // User 1's workstation
    cd "C:\path\to\user1\working\directory";
    global db "C:\path\to\user1\ENAHO\database";
};
else if "`machine'" == "LAPTOP_1" {; // User 1's laptop
    cd "C:\path\to\user1\working\directory";
    global db "C:\path\to\user1\ENAHO\database";
};  
else if "`machine'" == "WORKSTATION_2" {; // User 2's workstation
    cd "D:\path\to\user2\working\directory";
    global db "D:\path\to\user2\ENAHO\database";
};  
#delimit cr  // Return to the standard delimiter

// Define the range of years for the consolidation
global start_year "2004"
global end_year "2023"

// Loading and consolidating data by year
forv i = $start_year / $end_year {
    display "`i'"  // Display current year for tracking progress

    // Load household-level variables from Module 01
    use a_o mes ubigeo conglome vivienda hogar p11* p111* p103 p102 p103a p104 result f* using "$db\module 01\\`i'\\`i'.dta", clear

    // Remove unneeded variable to save memory
    cap drop p110i  

    // Merge with Module 34 for additional household data
    quietly merge 1:1 conglome vivienda hogar using "$db\module 34\\`i'\\`i'.dta", nogen keepusing(a_o mes pobreza* e* ingmo1hd ingmo2hd inghog1d inghog2d gashog2d linea f* mieperho)

    // Merge individual-level data from Module 02
    quietly merge 1:m conglome vivienda hogar using "$db\module 02\\`i'\\`i'.dta", nogen  

    // Drop unnecessary variables
    cap drop codtarea codtiempo p201p

    // Merge more individual data from Module 03
    quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 03\\`i'\\`i'.dta", nogen keepusing(a_o mes p208a p301* p302a p306 p307 p314a* p308* f* codinfor)

    // Drop additional variables to save memory
    cap drop p301a1o p310c1  

    // Continue merging data from Modules 04 and 05
    quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 04\\`i'\\`i'.dta", nogen keepusing(a_o mes p401 p419* p402* p409* p4031* codinfor)
    quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 05\\`i'\\`i'.dta", nogen keepusing(a_o mes p208a ocu* i524a1 d529t i530a d536 d538a* i538a* d540t i541a d543 d544t f* i520 p511a p517b* p558a5 p520 p521 p521a p513t p518 p519 p510a* i513t i518 codinfor)

    // Merge data from Module 85 (two separate datasets)
    quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 85\\`i'\\`i'_2.dta", nogen keepusing(a_o mes p40* p* codinfor)
    quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 85\\`i'\\`i'_1.dta", nogen keepusing(a_o mes p* codinfor)

    // Final household-level merge with Module 84
    quietly merge m:1 conglome vivienda hogar using "$db\module 84\\`i'\\`i'_1.dta", nogen keepusing(a_o mes p* codinfor)

    // Convert year and month to numeric, if necessary
    destring a_o mes, replace

    // Compress data to save memory and create a temporary file for this year's data
    quietly compress
    tempfile input_`i'
    save `input_`i''  // Save as temporary file
}

// Clear memory and append all temporary files to consolidate data
clear
forv i = $start_year / $end_year {
    display "`i'"  // Display current year for tracking progress
    quietly append using `input_`i''  // Append each year’s data
}

// Dropping unneeded variables to reduce dataset size
drop p1 p1a p2a* p3a* p4 p4a p15-p22a p23_* p23a* p23b p419a* p402*n p117* p35* p36* p37* p38* p39* p22_* p22a_*

// Final compression and summary table for quality check
quietly compress
tabstat fac* , by(a_o)  // Tabulate summary statistics for key variables by year


```

## Next Steps
Familiarize yourself with ENAHO’s questionnaires and documentation for each module and year you’re using. This step helps you clarify your analysis goals and understand the potential limitations. Further guidance on weighting and interpreting results will be included in the next edition of these notes.


