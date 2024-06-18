
 #### Verificando la aplicación de los factores de expansión
 La aplicación de los factores de expansión dependen de qué tipo de bases de datos se estén usando (a nivel de personas o nivel de hogares) y qué tipo de resultados se está buscando presentar (a nivel de personas o nivel de hogares).
 Para fines prácticos, véamos un ejemplo contabilizando la población del país a través de distintos módulos de la ENAHO, algunos a nivel e personas y otros a nivel de hogares.   
 
 1. En caso de usarse una base de datos a nivel de pesonas (por ejemplo, el módulo 300 Educación de la ENAHO con un total de 108,354 observaciones como muestra), y en caso de querer presentar resultados a nivel de personas, solo debe usarse el factor de expansión que ya viene contenida en la base de datos.

 ``` js
use "$ruta\1. Bases de datos\1.1. Externas (INEI)\1.1.1. ENAHO\module 03\2023\2023.dta"
tab a_o [iw=factor07]
```    

| año de la encuesta |     Freq.     | Percent |   Cum.   |
|--------------------|---------------|---------|----------|
|               2023 |   33108245.3  |  100.00 |   100.00 |
|--------------------|---------------|---------|----------|
|              Total |   33108245.3  |  100.00 |   100.00 |

 2. En caso de usarse una base de datos a nivel de hogares (por ejemplo, el módulo 340 Sumaria de la ENAHO con un total de 33,886 observaciones como muetra), y en caso de querer presentar resultados a nivel de personas, debe usarse el factor de expansión pero multiplicándose por el número de miembros del hogar.

 ``` js
use "$ruta\1. Bases de datos\1.1. Externas (INEI)\1.1.1. ENAHO\module 34\2023\2023.dta"
tab a_o [iw=factor07*mieperho]
```    

| año de la encuesta |     Freq.     | Percent |   Cum.   |
|--------------------|---------------|---------|----------|
|               2023 |   34107047.6  |  100.00 |   100.00 |
|--------------------|---------------|---------|----------|
|              Total |   34107047.6  |  100.00 |          |


    
    
