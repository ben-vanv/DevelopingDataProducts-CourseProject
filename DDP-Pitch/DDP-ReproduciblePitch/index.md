---
title       : Reproducible Pitch
subtitle    : Developing Data Products - Course Project
author      : Benjamin Van Vliet
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<style>
.title-slide {
  background-color: #FFFFFF; /* #EDE0CF; ; #CA9F9D*/
  color: #FFFFFF; /* #EDE0CF; ; #CA9F9D*/
}

img {     
  max-height: 450px;     
  max-width: 964px; 
}
</style>

## The general public's trust has been broken by car manufacturers 

- Events like the VW emissions and fuel consumption scandal have damaged the reputation of car manufacturers
- The general public is right to question the emission and fuel consumption numbers spruiked by these unscrupulous operators
- In order to make the process of finding the truth around manufacturer claims easier, we have developed an app that compares the stated fuel consumption quoted by the manufacturer against a model that predicts what a car with the same characteristics generally achieves in terms of fuel consumption

---

## The Application: Inputs and Outputs

- The user interface is styled as follows. All input parameters are labelled and described in the application.

<img src = 'assets/img/screenshot.PNG'></img>

---

## Application Data Model

- The Model to predict from a car's MPG efficiency is built on the mtcars dataset that is included in the standard R distribution.


```r
library(datasets)
head(mtcars, 5)
```

```
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
```

---

## Accessing the Application

- The application has been published and can be access via ShinyApps.io
- Please utilise the following URL

```
https://benvanv.shinyapps.io/DDP-CourseProject/
```

---

## Help and Contact Details

- Should you encounter any issues with the application or its functionality, or would like to pass on additional feedback, please do not hesitate to contact the author and maintainer:


benjamin.g.vanvliet+DDP+Support @ gmail.com



