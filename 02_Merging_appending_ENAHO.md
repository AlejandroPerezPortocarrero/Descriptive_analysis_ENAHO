

``` js



*********************************************************************************
*
* Proyecto: La pobreza multidimensional y el acceso a los servicios de agua potable y alcantarillado en el Perú: una propuesta para el sector saneamiento, 2004-2023
*
*********************************************************************************

	clear all

	dis "`c(hostname)'"

	local machine "`c(hostname)'" // anyone who is working could add his/her // hostname

	#d ;

	  if "`machine'" == "WSDPNAPERERZ" {; // Alejandro
		cd "C:\Users\aperezp\OneDrive - Superintendencia Nacional de Servicios de Saneamiento\0_Estudios\1_Pobreza multidimensional";
		global db "C:\Users\aperezp\OneDrive - Superintendencia Nacional de Servicios de Saneamiento\1. Bases de datos\1.1. Externas (INEI)\1.1.1. ENAHO";	
	  };
	  else if "`machine'" == "LPDPNAPEREZP" {; // Alejandro (laptop)
		cd "C:\Users\aperezp\OneDrive - Superintendencia Nacional de Servicios de Saneamiento\0_Estudios\1_Pobreza multidimensional";
		global db "C:\Users\aperezp\OneDrive - Superintendencia Nacional de Servicios de Saneamiento\1. Bases de datos\1.1. Externas (INEI)\1.1.1. ENAHO";	
	  };  
	  else if "`machine'" == "DESKTOP-TA8QGR3" {; // Antony
		cd "D:\OneDrive\8._ Pobreza Multidimensional\2._ Dofiles";
		global db "D:\OneDrive\8._ Pobreza Multidimensional\1._ Bases_ENAHO";	
	  };    
	#d cr

	global start_year "2004"
	global end_year "2023"

	// CARGANDO LA BASE DE DATOS	
	forv i = $start_year / $end_year {
	display "`i'"
	u a_o mes ubigeo conglome vivienda hogar p11* p111* p103 p102 p103a p104 result f* using "$db\module 01\\`i'\\`i'.dta", clear // Nivel de hogar
	cap drop p110i
	quietly merge 1:1 conglome vivienda hogar using "$db\module 34\\`i'\\`i'.dta", nogen keepusin(a_o mes pobreza* e* ingmo1hd ingmo2hd inghog1d inghog2d gashog2d linea f* mieperho) // Nivel de hogar
	quietly merge 1:m conglome vivienda hogar using "$db\module 02\\`i'\\`i'.dta", nogen // Nivel de individuo
	cap drop codtarea codtiempo 
	cap drop p201p
	cap drop p208a2


	quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 03\\`i'\\`i'.dta", nogen keepusin(a_o mes p208a p301* p302a p306 p307 p314a* p308* f* codinfor) // Nivel de individuo
	cap drop p301a1o
	cap drop p310c1 

	quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 04\\`i'\\`i'.dta", nogen keepusin(a_o mes p401 p419* p402* p409* p4031* codinfor) // Nivel de individuo


	quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 05\\`i'\\`i'.dta", nogen  keepusin(a_o mes p208a ocu* i524a1 d529t i530a d536 d538a* i538a* d540t i541a d543 d544t f* i520 p511a p517b* p558a5 p520 p521 p521a p513t p518 p519 p510a* i513t i518 codinfor) // Nivel de individuo


	quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 85\\`i'\\`i'_2.dta", nogen  keepusin(a_o mes p40* p* codinfor) // p23 // Nivel de individuo

	quietly merge 1:1 conglome vivienda hogar codperso using "$db\module 85\\`i'\\`i'_1.dta", nogen  keepusin(a_o mes p* codinfor) // p5 // Nivel de individuo

	quietly merge m:1 conglome vivienda hogar using "$db\module 84\\`i'\\`i'_1.dta", nogen  keepusin(a_o mes p* codinfor) // Nivel de hogar


	destring a_o mes, replace

	quietly compress
	tempfile input_`i'
	save `input_`i'' 	 
	}


	clear
	forv i = $start_year / $end_year {
	display "`i'"
	quietly append using `input_`i''
	}

	// GENERANDO LAS VARIABLES PARA EL ANÁLISIS

	// Reduciendo el tamaño de la base de datos retirando variables que no se utilizarán
	drop p1 p1a
	drop p2a*
	drop p3a*
	drop p4 p4a
	drop p15-p22a
	drop p23_*
	drop p23a* p23b
	drop p419a*
	drop p402*n
	drop p117*
	drop p35*
	drop p36*
	drop p37*
	drop p38*
	drop p39*
	*drop p1_*
	*drop p2_*


```
	// Eliminando variables con alto número de missings
	drop p22_* p22a_*

	quietly compress
	*tabstat fac* , by(a_o)

\
