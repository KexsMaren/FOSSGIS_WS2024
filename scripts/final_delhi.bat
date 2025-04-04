:: Author: Jan-Josef Hartke, Maren Strydhorst
:: Version: 1.0

:: This script calculates urban area by determining the difference between the Normalized Difference Built-up Index (NDBI) and the Normalized Difference Vegetation Index (NDVI).
:: It requires two Landsat 7 and Landsat 8/9 raster images from different points in time, as well as a .gpkg file containing the area of interest (aoi).
:: The results will be exported as GeoTIFF and as maps in .png-format.

:: 0. Set up GRASS
:: 1. Import 
:: 2. Preprocessing
::		2.1 Clip to AoI
:: 3. Calculations
:: 4. Visualization & Export

:: --------------------------------------------------------------
:: 0. Set up GRASS GIS (requires GRASS GIS 8.4)
:: --------------------------------------------------------------
:: Make sure to set location and mapset right using GUI. (e.g. Delhi: location=loc_delhi, mapset=delhi, EPSG: 32643)

:: Print aktuelle Region und Mapset
call g.region -p
call g.mapset -p

:: --------------------------------------------------------------
:: 1. Import raster bands (Red, NIR & SWIR) to GRASS GIS
:: --------------------------------------------------------------
echo Importing raster data...

:: First dataset
call r.import input="..\data\delhi\LE07_L2SP_146040_20001008_20200917_02_T1_SR_B3.TIF" output=Red_1
call r.import input="..\data\delhi\LE07_L2SP_146040_20001008_20200917_02_T1_SR_B4.TIF" output=NIR_1
call r.import input="..\data\delhi\LE07_L2SP_146040_20001008_20200917_02_T1_SR_B5.TIF" output=SWIR_1

:: Second dataset
call r.import input="..\data\delhi\LC09_L2SP_146040_20241010_20241011_02_T1_SR_B4.TIF" output=Red_2
call r.import input="..\data\delhi\LC09_L2SP_146040_20241010_20241011_02_T1_SR_B5.TIF" output=NIR_2
call r.import input="..\data\delhi\LC09_L2SP_146040_20241010_20241011_02_T1_SR_B6.TIF" output=SWIR_2

:: --------------------------------------------------------------
:: 2. Preprocessing
:: --------------------------------------------------------------
echo Starting preprocessing...

:: --------------------------------------------------------------
:: 2.1 Clip to Area of Interest
echo Clipping to AoI...

:: Load AoI-file
call v.in.ogr input="..\data\delhi\delhi_aoi.gpkg" output=aoi

:: Set region
call g.region vector=aoi

:: Create mask
call r.mask vector=aoi

:: Clip to AoI using mask
call r.mapcalc "Red_1_aoi = Red_1"
call r.mapcalc "Red_2_aoi = Red_2"
call r.mapcalc "NIR_1_aoi = NIR_1"
call r.mapcalc "SWIR_1_aoi = SWIR_1"
call r.mapcalc "NIR_2_aoi = NIR_2"
call r.mapcalc "SWIR_2_aoi = SWIR_2"

:: Remove mask
call r.mask -r


:: --------------------------------------------------------------
:: 3. Calculations
:: --------------------------------------------------------------

:: --------------------------------------------------------------
:: 3.1 Calculate NDBI
echo Calculating NDBI...

call r.mapcalc "ndbi_1 = float(SWIR_1_aoi - NIR_1_aoi) / (SWIR_1_aoi + NIR_1_aoi)"
call r.mapcalc "ndbi_2 = float(SWIR_2_aoi - NIR_2_aoi) / (SWIR_2_aoi + NIR_2_aoi)"

:: --------------------------------------------------------------
:: 3.2 Create NDBI binary map (values >0 -> urban; <= 0 -> not urban)
call r.mapcalc "ndbi_bi_1 = if(ndbi_1 > 0, 1, 0)"
call r.mapcalc "ndbi_bi_2 = if(ndbi_2 > 0, 1, 0)"

:: --------------------------------------------------------------
:: 3.3 Calculate NDVI
echo Calculating NDVI...

call r.mapcalc "ndvi_1 = float(NIR_1_aoi - Red_1_aoi) / (NIR_1_aoi + Red_1_aoi)"
call r.mapcalc "ndvi_2 = float(NIR_2_aoi - Red_2_aoi) / (NIR_2_aoi + Red_2_aoi)"

:: --------------------------------------------------------------
:: 3.4 Create NDVI binary map ((values >0.15 -> vegetation; <= 0 -> no vegetation))
call r.mapcalc "ndvi_bi_1 = if(ndvi_1 > 0.15, 1, 0)"
call r.mapcalc "ndvi_bi_2 = if(ndvi_2 > 0.15, 1, 0)"

:: --------------------------------------------------------------
:: 3.5 Calculate difference
echo Calculating difference...

call r.mapcalc "diff_bi_1 = (ndbi_bi_1 - ndvi_bi_1)"
call r.mapcalc "diff_bi_2 = (ndbi_bi_2 - ndvi_bi_2)"

:: --------------------------------------------------------------
:: 4. Visualizaiton & Export
:: --------------------------------------------------------------
:: 4.1 Export as GeoTIFF
::echo Exporting as GeoTIFF...

call r.out.gdal input=ndbi_1 format=GTiff output="..\results\delhi\delhi_ndbi_1.tif"
call r.out.gdal input=ndbi_2 format=GTiff output="..\results\delhi\delhi_ndbi_2.tif"

call r.out.gdal input=ndvi_1 format=GTiff output="..\results\delhi\delhi_ndvi_1.tif"
call r.out.gdal input=ndvi_2 format=GTiff output="..\results\delhi\delhi_ndvi_2.tif"

call r.out.gdal input=ndbi_bi_1 format=GTiff output="..\results\delhi\ndbi_bi_1.tif"
call r.out.gdal input=ndbi_bi_2 format=GTiff output="..\results\delhi\ndbi_bi_2.tif"

call r.out.gdal input=ndvi_bi_1 format=GTiff output="..\results\delhi\ndvi_bi_1.tif"
call r.out.gdal input=ndvi_bi_2 format=GTiff output="..\results\delhi\ndvi_bi_2.tif"

call r.out.gdal input=diff_bi_1 format=GTiff output="..\results\delhi\diff_bi_1.tif"
call r.out.gdal input=diff_bi_2 format=GTiff output="..\results\delhi\diff_bi_2.tif"

:: --------------------------------------------------------------
:: 4.2 Create Maps
echo Creating maps...

:: --------------------------------------------------------------
:: 4.2.1 Map diff_bi_1

:: Start png graphic monitor
call d.mon start=png output="..\results\delhi\diff_bi_1_map.png"

:: Add raster layer
call d.rast map=diff_bi_1

:: Add legend
call d.legend raster=diff_bi_1 at=1,15,76,81 title="NDBI" title_fontsize=12 fontsize=12 -b bgcolor=255:255:255 border_color=white -f

:: Stop png graphic monitor
call d.mon stop=png

:: --------------------------------------------------------------
:: 4.2.2 Map diff_bi_2

:: Start png graphic monitor
call d.mon start=png output="..\results\delhi\diff_bi_2_map.png"

:: Add raster layer
call d.rast map=diff_bi_2

:: Add legend
call d.legend raster=diff_bi_2 at=1,15,76,81 title="NDBI" title_fontsize=12 fontsize=12 -b bgcolor=255:255:255 border_color=white -f

:: Stop png graphic monitor
call d.mon stop=png