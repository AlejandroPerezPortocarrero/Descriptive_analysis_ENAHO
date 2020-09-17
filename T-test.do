	
cls
clear all
cd "E:\5_Research\X_Tools"
global bd_enaho "E:\10_BD\ENAHO\Bases anuales"

forv i = 2014/2019 {
display "`i'"
u "$bd_enaho\enaho01a-`i'-300", clear
quietly compress
tempfile input_`i'
save `input_`i'' 	 
}

clear
forv i = 2014/2019{
display "`i'"
quietly append using `input_`i''
}

  * Gender
 	 g female=(p207==2)
	
  * Access to higher education
 	g access=((p308a==5 | p308a==4) & p306==1) if ((p208a>=17 & p208a<=22) & p301a==6)

  * Differences in access to higher education by gender
  
	* T-test without considering the survey design
	ttest access, by(female)
	estpost ttest access, by(female)
  
 	* T-test considering the survey design
 	svyset conglome [pweight=factor07], strata(estrato) vce(linearized) singleunit(missing)
	
	svy: mean access, over(female)
	svy: mean access, over(female) coeflegend
	
	* Adjusted Wald test
	test _b[c.access@0bn.sexo] = _b[c.access@1.sexo]
  
