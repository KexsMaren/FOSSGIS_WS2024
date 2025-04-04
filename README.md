# Multi-Temporal Data Processing for Detection of urban growth

This project aims to detect urban growth by calculating the difference between the Normalized Difference Built-up Index (NDBI) and the Normalized Difference Vegetation Index (NDVI) using multi-temporal Landsat satellite data (Landsat 7, 8, and 9). The analysis focuses on the changes in built-up areas in cities between two points in time (e.g., 2000 and 2023).

## Description

Urbanization is a critical factor in environmental changes. This project utilizes satellite data from Landsat 7, 8, and 9 to calculate the difference between NDBI and NDVI for different points in time. The analysis is focused on the identification of built-up areas by comparing Near Infrared (NIR) and Short-Wave Infrared (SWIR) bands, while subtracting vegetated areas, which are determined using the Red and NIR bands.

The project uses the GRASS GIS tool for data processing, allowing to visualize urban area and analyze changes over time. Additionally, the script is designed to be easily applied to a variety of cities, making it adaptable for different regions and time periods of interest.

## Getting Started

### Software Requirements

- GRASS GIS (version 8.4 or higher)
- GDAL
- Optional: QGIS (version 3.34 or higher) for visualization

### Installing

- Install GRASS GIS, GDAL/OGR and optional QGIS using OSGeo4W installer from [GRASS GIS official website](https://grass.osgeo.org/download/)
- Clone this repository to your local computer

### Executing program

1. Open GRASS GIS GUI and create
    - a new location for your area of interest (e.g. Heidelberg)
    - and a mapset for your location (e.g. EPSG: 32632). Make this mapset the current mapset.
2. In the GRASS GIS CLI
    - navigate to the scripts-folder
    ```
    cd C:\path\to\project\scripts
    ```
    - execute the script for you location of interest, e.g.:
    ```
    final_heidelberg.bat
    ```
3. The results (GeoTIFFs and maps as png) will be saved in the results-folder.
4. Before running the script again, make sure to delete all maps from the current mapset to avoid errors. Delete also the results in the results-folder or change the output name in the script.
5. Feel free to try out data from other cities or points in time! Be aware of the limitations described in the [blog_post.md](blog_post.md). Only use Landsat 7 or 8/9 Level 2 raster data (e.g. from [USGS Earth Explorer](https://earthexplorer.usgs.gov/)).

## Acknowledgments

 - [Product information](https://www.usgs.gov/landsat-missions/landsat-collection-2-level-2-science-products)
 - [Zha & Ni (2003): Use of normalized difference built-up index in
 automatically mapping urban areas from TM imagery](https://doi.org/10.1080/01431160304987)