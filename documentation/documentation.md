# Multi-Temporal Data Processing for Detection of urban growth - Documentation

## 1. Data Acquisition
We downloaded Landsat Collection 2 Level-2 satellite imagery of Heidelberg for two different years from Landsat 7 and Landsat 9 using [USGS Earth Explorer](https://earthexplorer.usgs.gov/). The selected images were chosen based on minimal cloud cover (0% over area of interest) and comparable seasonal conditions to ensure consistency in the analysis.

The chosen images were acquired on the 9th of June in 2000 and the 25th of June in 2023.

The Area of Interest - file (heidelberg_aoi.gpkg) was created using the Shape Digitizing Toolabr in QGIS and exported as a GeoPackage. 


## 2. GRASS GIS Set Up
We created a new GRASS GIS Location and Mapset based on the coordinate reference system of the Landsat data (EPSG: 32632).
The Red, Near-Infrared (NIR) and Shortwave Infrared (SWIR) bands from Landsat 7 and Landsat 9 were imported into GRASS GIS, with B3 (Red), B4 (NIR) and B5 (SWIR) for Landsat 7 and B4 (Red), B5 (NIR) and B6 (SWIR) for Landsat 9. These bands are crucial for calculating the Normalized Difference Built-up Index (NDBI) as well as the Normalized Difference Vegetation Index, which are used to analyze built-up areas [(Zha & Ni, 2003)](https://doi.org/10.1080/01431160304987).


## 3. Preprocessing
The Landsat bands were clipped to the area of interest using 'r.mask' in GRASS GIS, ensuring that only the area of interest was retained for analysis. Since both datasets share the same spatial resolution of 30 meters, no resampling was necessary.


## 4. Calculating NDBI
The NDBI was calculated using the command 'r.mapcalc' and the following formula:

NDBI = (SWIR - NIR) / (SWIR + NIR)

Additionally, a binary raster was created to classify built-up areas, where values greater than 0 indicate built-up areas, and values less than 0 represent non-built-up areas [(Zha & Ni, 2003)](https://doi.org/10.1080/01431160304987). This was also done using the 'r.mapcalc' command.


## 5. Calculating NDVI 
The NDVI was calculated using the command 'r.mapcalc' and the following formula:

NDVI = (NIR - Red) / (NIR + Red)

A binary raster was then generated, with values above 0.15 indicating vegetated areas, while values below this threshold represent non-vegetated regions. The original threshold value '0' used in [Zha & Ni, 2003](https://doi.org/10.1080/01431160304987) was adapted because the NDVI showed positive values everywhere but on the river and therefore didn`t affect the results of the NDBI. By adapting the threshold to 0.15, built-up areas were not classified as vegetated areas anymore and could influence the results.


## 6. Calculating Difference
Finally, the binary NDVI raster was subtracted from the binary NDBI raster as described in [Zha & Ni, 2003](https://doi.org/10.1080/01431160304987) using the 'r.mapcalc' command.


## 7. Visualization
All results were exported as GeoTIFF (command: 'r.out.gdal') and the final results (difference) visualized as maps in the .png-format using the following commands:

- d.rast to display the raster layers,
- d.legend to add a legend,
- d.out.file to export the maps as PNG images.

## 8. Website
The blogpost was published on a [public website](https://kexsmaren.github.io/FOSSGIS_WS2024/) created with GitHub Pages


## Rejected Approaches (InProgress)
In the attempt to make the NDBI applicable for Heidelberg, several approaches were pursued that ultimately proved to be ineffective. These include:

- Using Sentinel-2 data: Since Sentinel-2 data only covers less than the last 10 years, hardly any noticeable and reliable difference in the city's extent between the two years could be identified, and was therefore discarded. The combination of Landsat and Sentinel data was avoided to reduce the potential for errors, as their resolutions and spectral bands differ.
- Originally, data from Delhi was intended to be used for the analysis, as the city has experienced significant growth in recent decades. However, due to the high sand content in the surrounding areas, large portions were classified as urban, although they were actually desert. [Zha & Ni, 2003](https://doi.org/10.1080/01431160304987) address this problem as well. Seasonal variations did not resolve this issue, which led to the exclusion of Delhi and several other cities from the analysis. 