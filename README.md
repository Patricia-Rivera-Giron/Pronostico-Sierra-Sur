# Pronostico SPI para la Sierra Sur del Perú
Proyecto: “Fortalecimiento de los sistemas nacionales y regionales de monitoreo y gestión de riesgos de la sequía e inundaciones en un contexto de cambio climático y desertificación en los países andinos”

Centro Internacional para la Investigación del Fenómeno de El Niño (CIIFEN) - Servicio Nacional de Meteorología e Hidrología del Perú (SENAMHI)

Construcción del pronóstico de SPI para la sierra sur del Perú
Se presentan 3 metodologías para el pronóstico del SPI en la Sierra Sur del Perú, para el trimestres EFM.

1.- Stepwisefit: 
Este tipo de regresión permite evaluar la significancia de los predictores elegidos a fin de mantener a los que sean significativos en la construcción del modelo. La regresión requiere dos niveles de significancia: uno para agregar variables y otro para eliminar variables.

2.- Análisis de regresión canónica (ACC): 
Permite relacionar simultáneamente dos (o más) grupos de variables, de las cuales un grupo usualmente es considerado como independiente y el otro como dependiente. El análisis crea combinaciones lineales (variables canónicas) de los dos grupos de variables, de forma que la correlación entre grupos de variables se maximiza.

3.- Modelo generalizado lineal (GLM): 
Generaliza la regresión lineal al permitir que el modelo lineal se relacione con la variable de respuesta a través de una función de enlace. Unifica varios otros modelos estadísticos, incluida la regresión lineal, la regresión logística y la regresión de Poisson.
En el ajuste para el GLM, primero se analizó el tipo de distribución que tienen los datos del SPI. De acuerdo a la distribución se aplicó la función asociada al tipo de regresión. 

Los tres modelos de pronóstico estadístico presentados se alimentan de variables atmosféricas (vientos), oceánicas (índice ONI y anomalías de temperatura superficial del mar) e índices climáticos. Esto permite capturar mayor influencia de las condiciones climáticas sobre la región.
