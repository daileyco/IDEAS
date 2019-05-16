---
title: "IDEAS Computational Workshop"
author: "Cody Dailey"
date: "May 13, 2019"
output: 
  html_document:
    keep_md: true
    toc: true
    toc_float: true
    code_folding: hide
---




# Module 1 


```r
if(require(lubridate)){library(lubridate)}else{install.packages("lubridate");library(lubridate)}
if(require(ggplot2)){library(ggplot2)}else{install.packages("ggplot2");library(ggplot2)}
#if(require(ggplot2-exts)){library(ggplot2-exts)}else{install.packages("ggplot2-exts");library(ggplot2-exts)}
if(require(plotly)){library(plotly)}else{install.packages("plotly");library(plotly)}
```

## Data Visualization


```r
mers <- read.csv("./Workshop I/Data/cases.csv")
```




```r
# mers$hospitalized[890] == 2012-02-20
mers$hospitalized[890] <- c('2015-02-20')

# ?
mers <- mers[-471,]
```


```r
mers$onset2 <- ymd(mers$onset)
mers$hospitalized2 <- ymd(mers$hospitalized)
```

```
## Warning: 5 failed to parse.
```

```r
day0 <- min(na.omit(mers$onset2))

mers$epi.day <- as.numeric(mers$onset2-day0)
```

### Question 1.1 

Why do we use the function na.omit? What happens if we neglect this command?

If we were to take the min() of a vector with missing values, the returned minimum would be missing as well. Using na.omit() tells the computer to ignore the missing values which is then passed to min() as a complete vector. 

### Question 1.2 

What purpose does the command as.numeric serve?

That function tells R to treat the calculated values as numeric, continuous data, rather than a difference in dates. 


### Exercise 1.1 

To produce this plot, type all the commands up to this point exactly as they appear. Particularly, note that as we "build" the plot in the last code snippet, we end each line with the addition symbol "+".


```r
ggplot(data=mers) + 
  geom_bar(mapping=aes(x=epi.day)) + 
  labs(x='Epidemic day', 
       y='Case count', 
       title='Global count of MERS cases by date of symptom onset', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## Warning: Removed 535 rows containing non-finite values (stat_count).
```

![](Writeup_CAD_files/figure-html/plot-1.png)<!-- -->

```r
ggplot(data=mers) + 
  geom_bar(mapping=aes(x=epi.day, fill=country)) + 
  labs(x='Epidemic day', 
       y='Case count', 
       title='Global count of MERS cases by date of symptom onset', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## Warning: Removed 535 rows containing non-finite values (stat_count).
```

```
## Warning: position_stack requires non-overlapping x intervals
```

![](Writeup_CAD_files/figure-html/plot-2.png)<!-- -->

#### Question: What happens if we don't use this convention (+ between functions)?

Without the +, R treats the script as separate commands when they are needed together to create the plot. 


### Exercise 1.2 

Modify the epidemic curve using the argument position="fill".


```r
ggplot(data=mers) + 
  geom_bar(mapping=aes(x=epi.day, fill=country), position='fill') + 
  labs(x='Epidemic day', 
       y='Case count', 
       title='Global count of MERS cases by date of symptom onset', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## Warning: Removed 535 rows containing non-finite values (stat_count).
```

```
## Warning: position_stack requires non-overlapping x intervals
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-1-1.png)<!-- -->





#### Question: What does this plot show?

Shows individual cases both with time attached and a country (time and space). 


### Exercise 1.3 

Another way to modify a bar plot is to change the coordinates. This can be done by "adding" coord_flip() and coord_polar() to the plot. 






```r
ggplot(data=mers) + 
  geom_bar(mapping=aes(x=epi.day)) + 
  labs(x='Epidemic day', 
       y='Case count', 
       title='Global count of MERS cases by date of symptom onset', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv') +
  coord_flip()
```

```
## Warning: Removed 535 rows containing non-finite values (stat_count).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

```r
ggplot(data=mers) + 
  geom_bar(mapping=aes(x=epi.day)) + 
  labs(x='Epidemic day', 
       y='Case count', 
       title='Global count of MERS cases by date of symptom onset', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv') +
  coord_polar()
```

```
## Warning: Removed 535 rows containing non-finite values (stat_count).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-2-2.png)<!-- -->

#### Question: What does this plot show?

Flips x and y axes and then shows x-axis as a 360degree axis. 





```r
mers$infectious.period <- mers$hospitalized2 - mers$onset2

mers$infectious.period <- as.numeric(mers$infectious.period, units='days')

ggplot(data=mers) +
  geom_histogram(aes(x=infectious.period)) +
  labs(x='Infectious period', 
       y='Frequency', 
       title='Distribution of calculated MERS infectious period', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 727 rows containing non-finite values (stat_bin).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
mers$infectious.period2 <- ifelse(mers$infectious.period<0, 0, mers$infectious.period)

ggplot(data=mers) +
  geom_histogram(aes(x=infectious.period2)) +
  labs(x='Infectious period', 
       y='Frequency', 
       title='Distribution of calculated MERS infectious period (positive values only)', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 727 rows containing non-finite values (stat_bin).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-3-2.png)<!-- -->


### Exercise 1.4 

Investigate the frequency of hospital-acquired infections of MERS.


```r
mers$HAI <- ifelse(mers$infectious.period<0, "HAI", "not HAI")
table(mers$HAI)
```

```
## 
##     HAI not HAI 
##     165     848
```


```r
ggplot(data=mers) +
  geom_density(aes(x=infectious.period2)) +
  labs(x='Infectious period', 
       y='Frequency', 
       title='Probability density for MERS infectious period (positive values only)', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## Warning: Removed 727 rows containing non-finite values (stat_density).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
ggplot(data=mers) +
  geom_area(stat='bin', aes(x=infectious.period2)) +
  labs(x='Infectious period', 
       y='Frequency', 
       title='Area plot for MERS infectious period (positive values only)', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 727 rows containing non-finite values (stat_bin).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-5-2.png)<!-- -->


### Exercise 1.5 

Use the infectious period data calculated in mers$infectious.period2 to experiment with other univariate plot types like geom_dotplot and geom_bar.



```r
ggplot(data=mers) +
  geom_dotplot(aes(x=infectious.period2)) +
  labs(x='Infectious period', 
       y='Frequency', 
       title='Dotplot for MERS infectious period (positive values only)', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## `stat_bindot()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 727 rows containing non-finite values (stat_bindot).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

```r
ggplot(data=mers) +
  geom_bar(aes(x=infectious.period2)) +
  labs(x='Infectious period', 
       y='Frequency', 
       title='Bar plot for MERS infectious period (positive values only)', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## Warning: Removed 727 rows containing non-finite values (stat_count).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-6-2.png)<!-- -->




### Exercise 1.6 

Use our corrected infectious period variable (infectious.period2) to study the change in the infectious period over the course of the MERS epidemic.


```r
ggplot(data=mers) +
  geom_point(aes(x=onset2, y=infectious.period2)) +
  labs(x='Date', 
       y='Infectious period', 
       title='Plot for MERS infectious period on date', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## Warning: Removed 727 rows containing missing values (geom_point).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

```r
ggplot(data=mers) +
  geom_smooth(aes(x=onset2, y=infectious.period2)) +
  labs(x='Date', 
       y='Infectious period', 
       title='Plot for MERS infectious period on date', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
```

```
## Warning: Removed 727 rows containing non-finite values (stat_smooth).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-7-2.png)<!-- -->


### Exercise 1.7 

In data from many outbreaks it can be seen that there is a kind of societal learning. When the infection first emerges it is not quickly recognized, public health resources have not been mobilized, it is not known what symptoms are diagnostic, how to treat, etc. But, quickly, this information is collected and the outbreak is contained. Is there evidence of this kind of societal learning in the mers data? Add a curve fit using geom_smooth to explore this question. Hint: We solved using the loess method because the default smoother (gam) failed. 


### Exercise 1.8 

Plot infectious.period2 against time, as before, but this time add a separate smooth fit for each country.


```r
ggplot(data=mers) +
  geom_point(aes(x=onset2, y=infectious.period2)) +
  geom_smooth(aes(x=onset2, y=infectious.period2)) +
  labs(x='Date', 
       y='Infectious period', 
       title='Plot for MERS infectious period on date', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv') +
  facet_wrap(~country)
```

```
## `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
```

```
## Warning: Removed 727 rows containing non-finite values (stat_smooth).
```

```
## Warning: Computation failed in `stat_smooth()`:
## x has insufficient unique values to support 10 knots: reduce k.

## Warning: Computation failed in `stat_smooth()`:
## x has insufficient unique values to support 10 knots: reduce k.

## Warning: Computation failed in `stat_smooth()`:
## x has insufficient unique values to support 10 knots: reduce k.
```

```
## Warning: Removed 727 rows containing missing values (geom_point).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-8-1.png)<!-- -->




```r
ggplot(data=mers, mapping=aes(x=epi.day, y=infectious.period2)) + 
  geom_point(mapping=aes(color=country)) +
  facet_wrap(~ country) +
  scale_y_continuous(limits=c(0,50)) +
  labs(x='Epidemic day',
       y='Infectious period',
       title='MERS infectious period (positive values only) over time', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## Warning: Removed 728 rows containing missing values (geom_point).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-9-1.png)<!-- -->





```r
ggplot(data=subset(mers, gender %in% c('M', 'F') & country %in% c('KSA', 'Oman', 'Iran', 'Jordan', 'Qatar', 'South Korea', 'UAE')), mapping=aes(x=epi.day, y=infectious.period2)) +
  geom_point(mapping=aes(color=country)) + 
  facet_grid(gender~country) + 
  scale_y_continuous(limits=c(0,50)) +
  labs(x='Epidemic day',
       y='Infectious period',
       title='MERS infectious period by gender and country', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
```

```
## Warning: Removed 692 rows containing missing values (geom_point).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-10-1.png)<!-- -->




### Exercise 1.9 

Study variation in the case fatality rate (the fraction of cases that end in death) over time and across countries.


```r
mers$epi.month <- month(mers$onset2)
mers$epi.year <- year(mers$onset2)


mers$count <- 1 
mers$death.indicator <- ifelse(mers$outcome=="fatal", 1, 0)

cfr <- data.frame(
cases.count = rowsum(mers$count, group=mers$epi.year),
fatalities.count = rowsum(mers$death.indicator, group=mers$epi.year)
)
```

```
## Warning in rowsum.default(mers$count, group = mers$epi.year): missing
## values for 'group'
```

```
## Warning in rowsum.default(mers$death.indicator, group = mers$epi.year):
## missing values for 'group'
```

```r
cfr$cfr <- cfr$fatalities.count / cfr$cases.count
cfr$group <- rownames(cfr)



cfr2 <- data.frame(
cases.count = rowsum(mers$count, group=mers$country),
fatalities.count = rowsum(mers$death.indicator, group=mers$country)
)

cfr2$cfr <- cfr2$fatalities.count / cfr2$cases.count
cfr2$group <- rownames(cfr2)



mers$cy <- paste0(mers$country, " ", mers$epi.year)

cfr3 <- data.frame(
cases.count = rowsum(mers$count, group=mers$cy),
fatalities.count = rowsum(mers$death.indicator, group=mers$cy)
)

cfr3$cfr <- cfr3$fatalities.count / cfr3$cases.count
cfr3$group <- rownames(cfr3)
```



```r
ggplot(data=cfr) +
  geom_point(mapping=aes(x=group, y=cfr)) +
  labs(x="Year", 
       y="Case Fatality Rate", 
       title="Case Fatality Rates across time")
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

```r
ggplot(data=cfr2) +
  geom_point(mapping=aes(x=group, y=cfr)) +
  labs(x="Country", 
       y="Case Fatality Rate", 
       title="Case Fatality Rates across countries")
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-12-2.png)<!-- -->

```r
ggplot(data=cfr3) +
  geom_point(mapping=aes(x=group, y=cfr)) +
  labs(x="Country Year", 
       y="Case Fatality Rate", 
       title="Case Fatality Rates across time by country")
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-12-3.png)<!-- -->




### Exercise 1.10 

Download and install the ggplot extension. Modify your plot with one or more new geoms. 










```r
epi.curve <- ggplot(data=mers) +
  geom_bar(mapping=aes(x=epi.day)) +
  labs(x='Epidemic day',
       y='Case count',
       title='Global count of MERS cases by date of symptom onset', 
       caption='Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv')
ggplotly(epi.curve)
```

```
## Warning: Removed 535 rows containing non-finite values (stat_count).
```

<!--html_preserve--><div id="htmlwidget-2587275e2e18003cfaeb" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-2587275e2e18003cfaeb">{"x":{"data":[{"orientation":"v","width":[0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.900000000000006,0.900000000000006,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.899999999999977,0.900000000000034,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091,0.900000000000091],"base":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"x":[0,9,12,21,22,23,24,25,28,29,36,77,166,198,202,205,217,226,227,309,321,322,329,340,346,352,381,383,386,389,390,392,393,394,395,397,399,400,402,404,405,406,407,412,413,415,416,417,422,423,424,425,429,432,433,434,436,442,472,483,489,491,498,505,512,514,518,520,529,558,559,573,581,583,584,585,588,593,596,598,601,604,609,632,646,648,650,669,670,673,683,684,686,693,696,698,704,705,709,710,714,715,716,718,719,720,723,725,726,730,731,733,734,737,739,741,744,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,790,791,792,793,796,797,805,807,812,814,816,817,818,822,824,825,826,827,829,832,834,835,837,910,915,917,918,923,924,926,930,931,936,937,941,951,952,954,956,957,962,964,966,969,971,972,974,976,978,980,981,985,993,994,996,1004,1007,1010,1011,1012,1013,1015,1017,1019,1020,1023,1026,1027,1029,1031,1033,1034,1036,1039,1040,1041,1043,1044,1045,1046,1047,1048,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1073,1075,1076,1077,1078,1079,1080,1081,1082,1083,1085,1086,1087,1088,1089,1092,1093,1094,1095,1096,1097,1100,1101,1102,1108,1111,1114,1116,1118,1121,1130,1132,1133,1135,1136,1138,1139,1144,1145,1146,1147,1148,1149,1150,1152,1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1187,1188,1189,1190,1193,1194,1196,1198,1201,1206,1208,1209,1211,1212,1213,1216,1217,1218,1219,1220,1221,1223,1225,1226,1227,1228,1229,1230,1231,1232,1233,1234,1235,1236,1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1266,1267,1268,1269,1270,1271,1273,1274,1275,1276,1278,1279,1281,1284,1289,1291,1295,1296,1298,1299,1301,1302,1303,1306,1308,1310,1311,1312,1316,1318,1323,1341,1344,1359,1362,1363,1367,1374,1383,1391,1392,1394,1401,1404,1411,1412,1414,1417,1419,1421,1422,1424,1425,1426,1428,1429,1430,1431,1433,1434,1436,1437,1439,1440,1441,1442,1443,1444,1445,1446,1448,1449,1450,1451,1453,1454,1455,1456,1458,1459,1460,1462,1466,1469,1473,1474,1475,1477,1480,1481,1485,1486,1487,1497,1509,1528,1533,1536,1539,1540,1541,1543,1546,1547,1548,1549,1550,1553,1554,1555,1556,1557,1558,1560,1562,1566,1567,1570,1578,1579,1581,1586,1587,1593,1597,1604,1605,1608,1614,1622,1627,1630,1742],"y":[1,1,2,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,2,1,1,1,2,2,1,2,2,1,1,1,1,1,1,2,1,1,3,2,1,1,1,1,1,1,1,2,2,1,1,1,2,1,1,1,1,2,1,1,2,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,2,1,1,1,1,1,1,1,2,1,1,2,1,2,2,3,2,1,1,1,3,2,2,1,1,4,4,5,1,1,3,10,8,8,5,10,10,5,7,3,3,8,10,7,5,4,5,8,3,2,8,3,3,12,1,3,1,1,3,1,3,2,1,1,3,2,1,2,2,1,2,2,1,1,1,1,1,1,1,2,1,1,1,1,1,1,2,1,1,2,3,1,1,1,2,2,3,2,1,1,1,2,2,1,2,1,2,1,1,1,2,1,1,1,1,1,2,1,3,1,1,1,1,1,2,1,1,1,1,2,2,1,2,1,1,1,1,4,1,3,2,8,3,2,6,3,4,3,5,3,4,2,1,5,3,2,1,2,6,5,4,3,3,2,1,3,4,4,1,1,5,3,1,1,1,1,1,1,2,1,1,2,1,1,2,1,2,1,1,1,1,1,1,1,1,2,1,3,2,5,1,2,2,1,1,1,2,1,1,1,9,7,4,7,3,4,5,7,3,3,11,12,23,15,8,12,13,8,5,7,3,8,6,3,3,1,4,7,1,1,1,2,1,2,1,1,2,2,1,1,1,2,1,1,1,1,2,1,2,1,1,1,1,4,4,2,2,1,1,2,5,4,3,6,6,4,6,7,5,4,8,8,7,11,6,1,3,7,2,4,7,8,7,3,8,5,3,5,5,2,1,2,1,1,4,1,2,1,2,1,1,1,1,1,1,2,1,1,1,1,1,3,1,4,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,2,1,2,1,1,1,3,1,1,3,2,2,1,1,3,2,1,4,4,4,3,1,2,1,1,4,2,3,1,1,1,2,1,2,1,1,1,1,2,1,1,2,1,1,1,1,2,1,1,1,1,1,1,2,1,2,1,3,1,1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1],"text":["epi.day:    0<br />count:  1","epi.day:    9<br />count:  1","epi.day:   12<br />count:  2","epi.day:   21<br />count:  1","epi.day:   22<br />count:  1","epi.day:   23<br />count:  1","epi.day:   24<br />count:  1","epi.day:   25<br />count:  2","epi.day:   28<br />count:  1","epi.day:   29<br />count:  1","epi.day:   36<br />count:  1","epi.day:   77<br />count:  1","epi.day:  166<br />count:  1","epi.day:  198<br />count:  1","epi.day:  202<br />count:  1","epi.day:  205<br />count:  1","epi.day:  217<br />count:  1","epi.day:  226<br />count:  1","epi.day:  227<br />count:  1","epi.day:  309<br />count:  1","epi.day:  321<br />count:  1","epi.day:  322<br />count:  1","epi.day:  329<br />count:  1","epi.day:  340<br />count:  1","epi.day:  346<br />count:  1","epi.day:  352<br />count:  1","epi.day:  381<br />count:  1","epi.day:  383<br />count:  1","epi.day:  386<br />count:  1","epi.day:  389<br />count:  1","epi.day:  390<br />count:  1","epi.day:  392<br />count:  1","epi.day:  393<br />count:  1","epi.day:  394<br />count:  1","epi.day:  395<br />count:  1","epi.day:  397<br />count:  4","epi.day:  399<br />count:  1","epi.day:  400<br />count:  2","epi.day:  402<br />count:  1","epi.day:  404<br />count:  1","epi.day:  405<br />count:  1","epi.day:  406<br />count:  2","epi.day:  407<br />count:  2","epi.day:  412<br />count:  1","epi.day:  413<br />count:  2","epi.day:  415<br />count:  2","epi.day:  416<br />count:  1","epi.day:  417<br />count:  1","epi.day:  422<br />count:  1","epi.day:  423<br />count:  1","epi.day:  424<br />count:  1","epi.day:  425<br />count:  1","epi.day:  429<br />count:  2","epi.day:  432<br />count:  1","epi.day:  433<br />count:  1","epi.day:  434<br />count:  3","epi.day:  436<br />count:  2","epi.day:  442<br />count:  1","epi.day:  472<br />count:  1","epi.day:  483<br />count:  1","epi.day:  489<br />count:  1","epi.day:  491<br />count:  1","epi.day:  498<br />count:  1","epi.day:  505<br />count:  1","epi.day:  512<br />count:  2","epi.day:  514<br />count:  2","epi.day:  518<br />count:  1","epi.day:  520<br />count:  1","epi.day:  529<br />count:  1","epi.day:  558<br />count:  2","epi.day:  559<br />count:  1","epi.day:  573<br />count:  1","epi.day:  581<br />count:  1","epi.day:  583<br />count:  1","epi.day:  584<br />count:  2","epi.day:  585<br />count:  1","epi.day:  588<br />count:  1","epi.day:  593<br />count:  2","epi.day:  596<br />count:  1","epi.day:  598<br />count:  1","epi.day:  601<br />count:  1","epi.day:  604<br />count:  3","epi.day:  609<br />count:  1","epi.day:  632<br />count:  1","epi.day:  646<br />count:  1","epi.day:  648<br />count:  1","epi.day:  650<br />count:  1","epi.day:  669<br />count:  1","epi.day:  670<br />count:  1","epi.day:  673<br />count:  1","epi.day:  683<br />count:  1","epi.day:  684<br />count:  1","epi.day:  686<br />count:  1","epi.day:  693<br />count:  1","epi.day:  696<br />count:  1","epi.day:  698<br />count:  1","epi.day:  704<br />count:  1","epi.day:  705<br />count:  2","epi.day:  709<br />count:  1","epi.day:  710<br />count:  2","epi.day:  714<br />count:  1","epi.day:  715<br />count:  1","epi.day:  716<br />count:  1","epi.day:  718<br />count:  1","epi.day:  719<br />count:  1","epi.day:  720<br />count:  1","epi.day:  723<br />count:  1","epi.day:  725<br />count:  2","epi.day:  726<br />count:  1","epi.day:  730<br />count:  1","epi.day:  731<br />count:  2","epi.day:  733<br />count:  1","epi.day:  734<br />count:  2","epi.day:  737<br />count:  2","epi.day:  739<br />count:  3","epi.day:  741<br />count:  2","epi.day:  744<br />count:  1","epi.day:  746<br />count:  1","epi.day:  747<br />count:  1","epi.day:  748<br />count:  3","epi.day:  749<br />count:  2","epi.day:  750<br />count:  2","epi.day:  751<br />count:  1","epi.day:  752<br />count:  1","epi.day:  753<br />count:  4","epi.day:  754<br />count:  4","epi.day:  755<br />count:  5","epi.day:  756<br />count:  1","epi.day:  757<br />count:  1","epi.day:  758<br />count:  3","epi.day:  759<br />count: 10","epi.day:  760<br />count:  8","epi.day:  761<br />count:  8","epi.day:  762<br />count:  5","epi.day:  763<br />count: 10","epi.day:  764<br />count: 10","epi.day:  765<br />count:  5","epi.day:  766<br />count:  7","epi.day:  767<br />count:  3","epi.day:  768<br />count:  3","epi.day:  769<br />count:  8","epi.day:  770<br />count: 10","epi.day:  771<br />count:  7","epi.day:  772<br />count:  5","epi.day:  773<br />count:  4","epi.day:  774<br />count:  5","epi.day:  775<br />count:  8","epi.day:  776<br />count:  3","epi.day:  777<br />count:  2","epi.day:  778<br />count:  8","epi.day:  779<br />count:  3","epi.day:  780<br />count:  3","epi.day:  781<br />count: 12","epi.day:  782<br />count:  1","epi.day:  783<br />count:  3","epi.day:  784<br />count:  1","epi.day:  785<br />count:  1","epi.day:  786<br />count:  3","epi.day:  787<br />count:  1","epi.day:  788<br />count:  3","epi.day:  790<br />count:  2","epi.day:  791<br />count:  1","epi.day:  792<br />count:  1","epi.day:  793<br />count:  3","epi.day:  796<br />count:  2","epi.day:  797<br />count:  1","epi.day:  805<br />count:  2","epi.day:  807<br />count:  2","epi.day:  812<br />count:  1","epi.day:  814<br />count:  2","epi.day:  816<br />count:  2","epi.day:  817<br />count:  1","epi.day:  818<br />count:  1","epi.day:  822<br />count:  1","epi.day:  824<br />count:  1","epi.day:  825<br />count:  1","epi.day:  826<br />count:  1","epi.day:  827<br />count:  1","epi.day:  829<br />count:  2","epi.day:  832<br />count:  1","epi.day:  834<br />count:  1","epi.day:  835<br />count:  1","epi.day:  837<br />count:  1","epi.day:  910<br />count:  1","epi.day:  915<br />count:  1","epi.day:  917<br />count:  2","epi.day:  918<br />count:  1","epi.day:  923<br />count:  1","epi.day:  924<br />count:  2","epi.day:  926<br />count:  3","epi.day:  930<br />count:  1","epi.day:  931<br />count:  1","epi.day:  936<br />count:  1","epi.day:  937<br />count:  2","epi.day:  941<br />count:  2","epi.day:  951<br />count:  3","epi.day:  952<br />count:  2","epi.day:  954<br />count:  1","epi.day:  956<br />count:  1","epi.day:  957<br />count:  1","epi.day:  962<br />count:  2","epi.day:  964<br />count:  2","epi.day:  966<br />count:  1","epi.day:  969<br />count:  2","epi.day:  971<br />count:  1","epi.day:  972<br />count:  2","epi.day:  974<br />count:  1","epi.day:  976<br />count:  1","epi.day:  978<br />count:  1","epi.day:  980<br />count:  2","epi.day:  981<br />count:  1","epi.day:  985<br />count:  1","epi.day:  993<br />count:  1","epi.day:  994<br />count:  1","epi.day:  996<br />count:  1","epi.day: 1004<br />count:  2","epi.day: 1007<br />count:  1","epi.day: 1010<br />count:  3","epi.day: 1011<br />count:  1","epi.day: 1012<br />count:  1","epi.day: 1013<br />count:  1","epi.day: 1015<br />count:  1","epi.day: 1017<br />count:  1","epi.day: 1019<br />count:  2","epi.day: 1020<br />count:  1","epi.day: 1023<br />count:  1","epi.day: 1026<br />count:  1","epi.day: 1027<br />count:  1","epi.day: 1029<br />count:  2","epi.day: 1031<br />count:  2","epi.day: 1033<br />count:  1","epi.day: 1034<br />count:  2","epi.day: 1036<br />count:  1","epi.day: 1039<br />count:  1","epi.day: 1040<br />count:  1","epi.day: 1041<br />count:  1","epi.day: 1043<br />count:  4","epi.day: 1044<br />count:  1","epi.day: 1045<br />count:  3","epi.day: 1046<br />count:  2","epi.day: 1047<br />count:  8","epi.day: 1048<br />count:  3","epi.day: 1052<br />count:  2","epi.day: 1053<br />count:  6","epi.day: 1054<br />count:  3","epi.day: 1055<br />count:  4","epi.day: 1056<br />count:  3","epi.day: 1057<br />count:  5","epi.day: 1058<br />count:  3","epi.day: 1059<br />count:  4","epi.day: 1060<br />count:  2","epi.day: 1061<br />count:  1","epi.day: 1062<br />count:  5","epi.day: 1063<br />count:  3","epi.day: 1064<br />count:  2","epi.day: 1065<br />count:  1","epi.day: 1066<br />count:  2","epi.day: 1067<br />count:  6","epi.day: 1068<br />count:  5","epi.day: 1069<br />count:  4","epi.day: 1070<br />count:  3","epi.day: 1071<br />count:  3","epi.day: 1073<br />count:  2","epi.day: 1075<br />count:  1","epi.day: 1076<br />count:  3","epi.day: 1077<br />count:  4","epi.day: 1078<br />count:  4","epi.day: 1079<br />count:  1","epi.day: 1080<br />count:  1","epi.day: 1081<br />count:  5","epi.day: 1082<br />count:  3","epi.day: 1083<br />count:  1","epi.day: 1085<br />count:  1","epi.day: 1086<br />count:  1","epi.day: 1087<br />count:  1","epi.day: 1088<br />count:  1","epi.day: 1089<br />count:  1","epi.day: 1092<br />count:  2","epi.day: 1093<br />count:  1","epi.day: 1094<br />count:  1","epi.day: 1095<br />count:  2","epi.day: 1096<br />count:  1","epi.day: 1097<br />count:  1","epi.day: 1100<br />count:  2","epi.day: 1101<br />count:  1","epi.day: 1102<br />count:  2","epi.day: 1108<br />count:  1","epi.day: 1111<br />count:  1","epi.day: 1114<br />count:  1","epi.day: 1116<br />count:  1","epi.day: 1118<br />count:  1","epi.day: 1121<br />count:  1","epi.day: 1130<br />count:  1","epi.day: 1132<br />count:  1","epi.day: 1133<br />count:  2","epi.day: 1135<br />count:  1","epi.day: 1136<br />count:  3","epi.day: 1138<br />count:  2","epi.day: 1139<br />count:  5","epi.day: 1144<br />count:  1","epi.day: 1145<br />count:  2","epi.day: 1146<br />count:  2","epi.day: 1147<br />count:  1","epi.day: 1148<br />count:  1","epi.day: 1149<br />count:  1","epi.day: 1150<br />count:  2","epi.day: 1152<br />count:  1","epi.day: 1153<br />count:  1","epi.day: 1154<br />count:  1","epi.day: 1155<br />count:  9","epi.day: 1156<br />count:  7","epi.day: 1157<br />count:  4","epi.day: 1158<br />count:  7","epi.day: 1159<br />count:  3","epi.day: 1160<br />count:  4","epi.day: 1161<br />count:  5","epi.day: 1162<br />count:  7","epi.day: 1163<br />count:  3","epi.day: 1164<br />count:  3","epi.day: 1165<br />count: 11","epi.day: 1166<br />count: 12","epi.day: 1167<br />count: 23","epi.day: 1168<br />count: 15","epi.day: 1169<br />count:  8","epi.day: 1170<br />count: 12","epi.day: 1171<br />count: 13","epi.day: 1172<br />count:  8","epi.day: 1173<br />count:  5","epi.day: 1174<br />count:  7","epi.day: 1175<br />count:  3","epi.day: 1176<br />count:  8","epi.day: 1177<br />count:  6","epi.day: 1178<br />count:  3","epi.day: 1179<br />count:  3","epi.day: 1180<br />count:  1","epi.day: 1181<br />count:  4","epi.day: 1182<br />count:  7","epi.day: 1183<br />count:  1","epi.day: 1184<br />count:  1","epi.day: 1185<br />count:  1","epi.day: 1187<br />count:  2","epi.day: 1188<br />count:  1","epi.day: 1189<br />count:  2","epi.day: 1190<br />count:  1","epi.day: 1193<br />count:  1","epi.day: 1194<br />count:  2","epi.day: 1196<br />count:  2","epi.day: 1198<br />count:  1","epi.day: 1201<br />count:  1","epi.day: 1206<br />count:  1","epi.day: 1208<br />count:  2","epi.day: 1209<br />count:  1","epi.day: 1211<br />count:  1","epi.day: 1212<br />count:  1","epi.day: 1213<br />count:  1","epi.day: 1216<br />count:  2","epi.day: 1217<br />count:  1","epi.day: 1218<br />count:  2","epi.day: 1219<br />count:  1","epi.day: 1220<br />count:  1","epi.day: 1221<br />count:  1","epi.day: 1223<br />count:  1","epi.day: 1225<br />count:  4","epi.day: 1226<br />count:  4","epi.day: 1227<br />count:  2","epi.day: 1228<br />count:  2","epi.day: 1229<br />count:  1","epi.day: 1230<br />count:  1","epi.day: 1231<br />count:  2","epi.day: 1232<br />count:  5","epi.day: 1233<br />count:  4","epi.day: 1234<br />count:  3","epi.day: 1235<br />count:  6","epi.day: 1236<br />count:  6","epi.day: 1238<br />count:  4","epi.day: 1239<br />count:  6","epi.day: 1240<br />count:  7","epi.day: 1241<br />count:  5","epi.day: 1242<br />count:  4","epi.day: 1243<br />count:  8","epi.day: 1244<br />count:  8","epi.day: 1245<br />count:  7","epi.day: 1246<br />count: 11","epi.day: 1247<br />count:  6","epi.day: 1248<br />count:  1","epi.day: 1250<br />count:  3","epi.day: 1251<br />count:  7","epi.day: 1252<br />count:  2","epi.day: 1253<br />count:  4","epi.day: 1254<br />count:  7","epi.day: 1255<br />count:  8","epi.day: 1256<br />count:  7","epi.day: 1257<br />count:  3","epi.day: 1258<br />count:  8","epi.day: 1259<br />count:  5","epi.day: 1260<br />count:  3","epi.day: 1261<br />count:  5","epi.day: 1262<br />count:  5","epi.day: 1263<br />count:  2","epi.day: 1264<br />count:  1","epi.day: 1266<br />count:  2","epi.day: 1267<br />count:  1","epi.day: 1268<br />count:  1","epi.day: 1269<br />count:  4","epi.day: 1270<br />count:  1","epi.day: 1271<br />count:  2","epi.day: 1273<br />count:  1","epi.day: 1274<br />count:  2","epi.day: 1275<br />count:  1","epi.day: 1276<br />count:  1","epi.day: 1278<br />count:  1","epi.day: 1279<br />count:  1","epi.day: 1281<br />count:  1","epi.day: 1284<br />count:  1","epi.day: 1289<br />count:  2","epi.day: 1291<br />count:  1","epi.day: 1295<br />count:  1","epi.day: 1296<br />count:  1","epi.day: 1298<br />count:  1","epi.day: 1299<br />count:  1","epi.day: 1301<br />count:  3","epi.day: 1302<br />count:  1","epi.day: 1303<br />count:  4","epi.day: 1306<br />count:  1","epi.day: 1308<br />count:  2","epi.day: 1310<br />count:  1","epi.day: 1311<br />count:  1","epi.day: 1312<br />count:  1","epi.day: 1316<br />count:  1","epi.day: 1318<br />count:  1","epi.day: 1323<br />count:  1","epi.day: 1341<br />count:  1","epi.day: 1344<br />count:  1","epi.day: 1359<br />count:  1","epi.day: 1362<br />count:  1","epi.day: 1363<br />count:  1","epi.day: 1367<br />count:  1","epi.day: 1374<br />count:  1","epi.day: 1383<br />count:  2","epi.day: 1391<br />count:  1","epi.day: 1392<br />count:  1","epi.day: 1394<br />count:  1","epi.day: 1401<br />count:  1","epi.day: 1404<br />count:  1","epi.day: 1411<br />count:  1","epi.day: 1412<br />count:  1","epi.day: 1414<br />count:  1","epi.day: 1417<br />count:  2","epi.day: 1419<br />count:  1","epi.day: 1421<br />count:  2","epi.day: 1422<br />count:  1","epi.day: 1424<br />count:  1","epi.day: 1425<br />count:  1","epi.day: 1426<br />count:  3","epi.day: 1428<br />count:  1","epi.day: 1429<br />count:  1","epi.day: 1430<br />count:  3","epi.day: 1431<br />count:  2","epi.day: 1433<br />count:  2","epi.day: 1434<br />count:  1","epi.day: 1436<br />count:  1","epi.day: 1437<br />count:  3","epi.day: 1439<br />count:  2","epi.day: 1440<br />count:  1","epi.day: 1441<br />count:  4","epi.day: 1442<br />count:  4","epi.day: 1443<br />count:  4","epi.day: 1444<br />count:  3","epi.day: 1445<br />count:  1","epi.day: 1446<br />count:  2","epi.day: 1448<br />count:  1","epi.day: 1449<br />count:  1","epi.day: 1450<br />count:  4","epi.day: 1451<br />count:  2","epi.day: 1453<br />count:  3","epi.day: 1454<br />count:  1","epi.day: 1455<br />count:  1","epi.day: 1456<br />count:  1","epi.day: 1458<br />count:  2","epi.day: 1459<br />count:  1","epi.day: 1460<br />count:  2","epi.day: 1462<br />count:  1","epi.day: 1466<br />count:  1","epi.day: 1469<br />count:  1","epi.day: 1473<br />count:  1","epi.day: 1474<br />count:  2","epi.day: 1475<br />count:  1","epi.day: 1477<br />count:  1","epi.day: 1480<br />count:  2","epi.day: 1481<br />count:  1","epi.day: 1485<br />count:  1","epi.day: 1486<br />count:  1","epi.day: 1487<br />count:  1","epi.day: 1497<br />count:  2","epi.day: 1509<br />count:  1","epi.day: 1528<br />count:  1","epi.day: 1533<br />count:  1","epi.day: 1536<br />count:  1","epi.day: 1539<br />count:  1","epi.day: 1540<br />count:  1","epi.day: 1541<br />count:  2","epi.day: 1543<br />count:  1","epi.day: 1546<br />count:  2","epi.day: 1547<br />count:  1","epi.day: 1548<br />count:  3","epi.day: 1549<br />count:  1","epi.day: 1550<br />count:  1","epi.day: 1553<br />count:  1","epi.day: 1554<br />count:  1","epi.day: 1555<br />count:  2","epi.day: 1556<br />count:  2","epi.day: 1557<br />count:  1","epi.day: 1558<br />count:  1","epi.day: 1560<br />count:  1","epi.day: 1562<br />count:  1","epi.day: 1566<br />count:  1","epi.day: 1567<br />count:  1","epi.day: 1570<br />count:  1","epi.day: 1578<br />count:  1","epi.day: 1579<br />count:  1","epi.day: 1581<br />count:  1","epi.day: 1586<br />count:  1","epi.day: 1587<br />count:  1","epi.day: 1593<br />count:  2","epi.day: 1597<br />count:  1","epi.day: 1604<br />count:  1","epi.day: 1605<br />count:  1","epi.day: 1608<br />count:  1","epi.day: 1614<br />count:  1","epi.day: 1622<br />count:  1","epi.day: 1627<br />count:  1","epi.day: 1630<br />count:  1","epi.day: 1742<br />count:  1"],"type":"bar","marker":{"autocolorscale":false,"color":"rgba(89,89,89,1)","line":{"width":1.88976377952756,"color":"transparent"}},"showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":43.7625570776256,"r":7.30593607305936,"b":40.1826484018265,"l":37.2602739726027},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"title":{"text":"Global count of MERS cases by date of symptom onset","font":{"color":"rgba(0,0,0,1)","family":"","size":17.5342465753425},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-87.595,1829.595],"tickmode":"array","ticktext":["0","500","1000","1500"],"tickvals":[0,500,1000,1500],"categoryorder":"array","categoryarray":["0","500","1000","1500"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"Epidemic day","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-1.15,24.15],"tickmode":"array","ticktext":["0","5","10","15","20"],"tickvals":[0,5,10,15,20],"categoryorder":"array","categoryarray":["0","5","10","15","20"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"Case count","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"3d307edda5b":{"x":{},"type":"bar"}},"cur_data":"3d307edda5b","visdat":{"3d307edda5b":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


### Exercise 1.11 

Make one of your case fatality plots an interactive graphic. 


```r
cfrs.plot <- ggplot(data=cfr3) +
  geom_point(mapping=aes(x=group, y=cfr)) +
  labs(x="Country Year", 
       y="Case Fatality Rate", 
       title="Case Fatality Rates across time by country")

ggplotly(cfrs.plot)
```

<!--html_preserve--><div id="htmlwidget-02cf9373db0a2df07752" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-02cf9373db0a2df07752">{"x":{"data":[{"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41],"y":[0,0,0,0,0.666666666666667,0,0.153846153846154,0.5,0.5,0.416666666666667,0,0.5,0.629032258064516,0.216117216117216,0.419642857142857,0.440298507462687,0.181619256017505,0,1,1,0,1,1,0,0,0.5,0.5,0.75,0,0.25,0.2,0.210526315789474,0.0666666666666667,0,0.75,0.0967741935483871,0.666666666666667,0.5,0,0.5,0],"text":["cfr: 0.00000000","cfr: 0.00000000","cfr: 0.00000000","cfr: 0.00000000","cfr: 0.66666667","cfr: 0.00000000","cfr: 0.15384615","cfr: 0.50000000","cfr: 0.50000000","cfr: 0.41666667","cfr: 0.00000000","cfr: 0.50000000","cfr: 0.62903226","cfr: 0.21611722","cfr: 0.41964286","cfr: 0.44029851","cfr: 0.18161926","cfr: 0.00000000","cfr: 1.00000000","cfr: 1.00000000","cfr: 0.00000000","cfr: 1.00000000","cfr: 1.00000000","cfr: 0.00000000","cfr: 0.00000000","cfr: 0.50000000","cfr: 0.50000000","cfr: 0.75000000","cfr: 0.00000000","cfr: 0.25000000","cfr: 0.20000000","cfr: 0.21052632","cfr: 0.06666667","cfr: 0.00000000","cfr: 0.75000000","cfr: 0.09677419","cfr: 0.66666667","cfr: 0.50000000","cfr: 0.00000000","cfr: 0.50000000","cfr: 0.00000000"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,0,0,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":43.7625570776256,"r":7.30593607305936,"b":40.1826484018265,"l":48.9497716894977},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"title":{"text":"Case Fatality Rates across time by country","font":{"color":"rgba(0,0,0,1)","family":"","size":17.5342465753425},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,41.6],"tickmode":"array","ticktext":[" NA","France 2013","Iran 2014","Iran 2015","Iran NA","Italy 2013","Jordan 2012","Jordan 2013","Jordan 2014","Jordan 2015","Jordan NA","KSA 2012","KSA 2013","KSA 2014","KSA 2015","KSA 2016","KSA NA","Kuwait 2013","Kuwait 2015","Kuwait NA","Lebanon 2014","Oman 2013","Oman 2014","Oman 2015","Oman 2016","Oman NA","Qatar 2012","Qatar 2013","Qatar 2014","Qatar 2015","Qatar NA","South Korea 2015","South Korea NA","Tunisia 2013","UAE 2013","UAE 2014","UAE 2015","UAE 2016","UAE NA","UK 2013","Yemen 2014"],"tickvals":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41],"categoryorder":"array","categoryarray":[" NA","France 2013","Iran 2014","Iran 2015","Iran NA","Italy 2013","Jordan 2012","Jordan 2013","Jordan 2014","Jordan 2015","Jordan NA","KSA 2012","KSA 2013","KSA 2014","KSA 2015","KSA 2016","KSA NA","Kuwait 2013","Kuwait 2015","Kuwait NA","Lebanon 2014","Oman 2013","Oman 2014","Oman 2015","Oman 2016","Oman NA","Qatar 2012","Qatar 2013","Qatar 2014","Qatar 2015","Qatar NA","South Korea 2015","South Korea NA","Tunisia 2013","UAE 2013","UAE 2014","UAE 2015","UAE 2016","UAE NA","UK 2013","Yemen 2014"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"Country Year","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-0.05,1.05],"tickmode":"array","ticktext":["0.00","0.25","0.50","0.75","1.00"],"tickvals":[0,0.25,0.5,0.75,1],"categoryorder":"array","categoryarray":["0.00","0.25","0.50","0.75","1.00"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"Case Fatality Rate","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"3d3039175994":{"x":{},"y":{},"type":"scatter"}},"cur_data":"3d3039175994","visdat":{"3d3039175994":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->










## Programming

### Exercise 1.12 

Write a script to load the West Nile virus data and use ggplot to create a histogram for the total number of cases in each state in each year. Follow the format of the prototypical script advocated in the presentation: Header, Load Packages, Declare Functions, Load Data, Perform Analysis.


```r
wnv <- read.csv("https://raw.githubusercontent.com/jdrakephd/ideas-workshop/master/wnv.csv")

ggplot(data=wnv) +
  geom_histogram(mapping=aes(x=Total)) +
  labs(x="WNV Case Counts", 
       y="Frequency", 
       title="Histogram of WNV Case Counts, Annual, State-specific", 
       caption="Data from: https://raw.githubusercontent.com/jdrakephd/ideas-workshop/master/wnv.csv")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-16-1.png)<!-- -->


### Exercise 1.13 

The state-level and case burden is evidently highly skewed. Plot a histogram for the logarithm of the number of cases. Do this two different ways.


```r
wnv$log.total <- log(wnv$Total)

ggplot(data=wnv) +
  geom_histogram(mapping=aes(x=log.total)) +
  labs(x="WNV Case Counts, log transformed", 
       y="Frequency", 
       title="Histogram of log(WNV Case Counts), Annual, State-specific [Method 1]", 
       caption="Data from: https://raw.githubusercontent.com/jdrakephd/ideas-workshop/master/wnv.csv")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

```r
ggplot(data=wnv) +
  geom_histogram(mapping=aes(x=log(Total))) +
  labs(x="WNV Case Counts, log transformed", 
       y="Frequency", 
       title="Histogram of log(WNV Case Counts), Annual, State-specific [Method 2]", 
       caption="Data from: https://raw.githubusercontent.com/jdrakephd/ideas-workshop/master/wnv.csv")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-17-2.png)<!-- -->

### Exercise 1.14 

Use arithmetic operators to calculate the raw case fatality rate (CFR) in each state in each year. Plot a histogram of the calcated CFRs.


```r
wnv$cfr <- wnv$Fatal/wnv$Total

ggplot(data=wnv) +
  geom_histogram(mapping=aes(x=cfr)) +
  labs(x="WNV Case Fatality Rate", 
       y="Frequency", 
       title="Histogram of WNV Case Fatality Rate, Annual, State-specific", 
       caption="Data from: https://raw.githubusercontent.com/jdrakephd/ideas-workshop/master/wnv.csv")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-18-1.png)<!-- -->





### Exercise 1.15 

Use arithmetic operators, logical operators, and the function sum to verify that the variable Total is simply the sum of the number of febrile cases, neuroinvasive cases, and other cases.



```r
if(sum({wnv$EncephMen + wnv$Fever + wnv$Other} != wnv$Total)==0){
  print("Sum confirmed!")
}else{"Sum not confirmed!"}
```

```
## [1] "Sum confirmed!"
```

### Exercise 1.16 

Use modular arithmetic to provide an annual case count for each state rounded (down) to the nearest dozen. Use modular arithmetic to extract the rounding errors associated with this calculate, then add the errors to obtain the total error.


```r
wnv$cc.dozens <- floor(wnv$Total/12)*12
wnv$rounding.error <- wnv$Total-wnv$cc.dozens

print(paste0("By rounding down to the nearest multiple of 12, there is a discrepancy of ", sum(wnv$rounding.error)," cases being lost."))
```

```
## [1] "By rounding down to the nearest multiple of 12, there is a discrepancy of 1241 cases being lost."
```


### Exercise 1.17 

Write a function to calculate the mean and standard error (standard deviation divided by the square root of the sample size) of the neuroinvasive disease rate for all the states in a given list and given set of years. Follow the Google R style and remember to place the function near the top of your script. Use your function to calculate the average severe disease rate in California, Colorado, and New York.


```r
exfunc <- function(states){
  .data <- wnv[wnv$State%in%states,]
  .mean <- mean(.data$EncephMen/.data$Total)
  .se <- sd(.data$EncephMen/.data$Total)/sqrt(nrow(.data))
  
  calcd <- cbind(.mean,.se)
}

test <- exfunc(states=c("California", "Colorado", "New York"))
```





```r
severe.cases.proportion <- function(STATE, YEAR){
  print(paste0("In ", STATE, " for the year ", YEAR, ", ", round(wnv[wnv$State%in%STATE & wnv$Year%in%YEAR,]$EncephMen/wnv[wnv$State==STATE & wnv$Year==YEAR,]$Total*100,2), "% of all WNV cases presented with neuroinvasive disease."))
}

severe.cases.proportion("Georgia", 2007)
```

```
## [1] "In Georgia for the year 2007, 46% of all WNV cases presented with neuroinvasive disease."
```

```r
severe.cases.proportion("California", 2007)
```

```
## [1] "In California for the year 2007, 40.53% of all WNV cases presented with neuroinvasive disease."
```




```r
sdr <- function(states, years){
  .data <- wnv
  .data$nidr <- .data$EncephMen/.data$Total
  
  # print(.data[{.data$State%in%states & .data$Year%in%years},c("State", "Year", "nidr")])
  .values <- data.frame(State=c(NA), Mean.NIDR=c(NA), SE.NIDR=c(NA))
  for (.i in 1:length(states)){
    .n <- nrow(.data[.data$State==states[.i],])
    .mean <- mean(.data[.data$State==states[.i],]$nidr)
    .sd <- sd(.data[.data$State==states[.i],]$nidr)
    .se <- .sd / sqrt(.n)
    
    print(paste0("The mean NIDR for ", states[.i], " in the given years is ", round(.mean, 3), " and the standard error is ", round(.se,3)))
    .values[.i,"State"]<-states[.i]
    .values[.i,"Mean.NIDR"]<-.mean
    .values[.i,"SE.NIDR"]<-.se
  }
  rm(.i)
  
  values <- .values
}

testing <- sdr(states=c("California", "Colorado", "New York"), years=c(2002:2007))
```

```
## [1] "The mean NIDR for California in the given years is 0.512 and the standard error is 0.111"
## [1] "The mean NIDR for Colorado in the given years is 0.224 and the standard error is 0.042"
## [1] "The mean NIDR for New York in the given years is 0.815 and the standard error is 0.037"
```

```r
#ndr <- sdr(states=c("California", "Colorado", "New York"), years=c(2002:2007))
```


### Exercise 1.18 

Use ggplot to show the neurovinvasive disease rate for these states as a bar graph with error bars to show the standard deviation.


```r
ggplot(data=testing, mapping=aes(x=State, y=Mean.NIDR))+
  geom_bar(stat='identity') +
  geom_errorbar(aes(ymin=Mean.NIDR-SE.NIDR, ymax=Mean.NIDR+SE.NIDR), size=.3, width=.2)
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-24-1.png)<!-- -->





### Exercise 1.19 

Use your function and ggplot to show the neurovinvasive disease rate for all states.


```r
testing2 <- sdr(states=levels(wnv$State), years=c(2002:2007))
```

```
## [1] "The mean NIDR for Alabama in the given years is 0.802 and the standard error is 0.064"
## [1] "The mean NIDR for Arizona in the given years is 0.495 and the standard error is 0.024"
## [1] "The mean NIDR for Arkansas in the given years is 0.702 and the standard error is 0.067"
## [1] "The mean NIDR for California in the given years is 0.512 and the standard error is 0.111"
## [1] "The mean NIDR for Colorado in the given years is 0.224 and the standard error is 0.042"
## [1] "The mean NIDR for Connecticut in the given years is 0.53 and the standard error is 0.127"
## [1] "The mean NIDR for Delaware in the given years is 0.551 and the standard error is 0.211"
## [1] "The mean NIDR for District of Columbia in the given years is 0.502 and the standard error is 0.161"
## [1] "The mean NIDR for Florida in the given years is 0.847 and the standard error is 0.08"
## [1] "The mean NIDR for Georgia in the given years is 0.572 and the standard error is 0.088"
## [1] "The mean NIDR for Idaho in the given years is 0.151 and the standard error is 0.059"
## [1] "The mean NIDR for Illinois in the given years is 0.555 and the standard error is 0.019"
## [1] "The mean NIDR for Indiana in the given years is 0.484 and the standard error is 0.056"
## [1] "The mean NIDR for Iowa in the given years is 0.494 and the standard error is 0.035"
## [1] "The mean NIDR for Kansas in the given years is 0.666 and the standard error is 0.113"
## [1] "The mean NIDR for Kentucky in the given years is 0.745 and the standard error is 0.13"
## [1] "The mean NIDR for Louisiana in the given years is 0.726 and the standard error is 0.06"
## [1] "The mean NIDR for Maryland in the given years is 0.732 and the standard error is 0.056"
## [1] "The mean NIDR for Massachusetts in the given years is 0.728 and the standard error is 0.069"
## [1] "The mean NIDR for Michigan in the given years is 0.817 and the standard error is 0.023"
## [1] "The mean NIDR for Minnesota in the given years is 0.392 and the standard error is 0.024"
## [1] "The mean NIDR for Mississippi in the given years is 0.542 and the standard error is 0.071"
## [1] "The mean NIDR for Missouri in the given years is 0.712 and the standard error is 0.041"
## [1] "The mean NIDR for Montana in the given years is 0.421 and the standard error is 0.118"
## [1] "The mean NIDR for Nebraska in the given years is 0.229 and the standard error is 0.07"
## [1] "The mean NIDR for Nevada in the given years is 0.492 and the standard error is 0.145"
## [1] "The mean NIDR for New Hampshire in the given years is 0.667 and the standard error is NA"
## [1] "The mean NIDR for New Jersey in the given years is 0.752 and the standard error is 0.085"
## [1] "The mean NIDR for New Mexico in the given years is 0.467 and the standard error is 0.066"
## [1] "The mean NIDR for New York in the given years is 0.815 and the standard error is 0.037"
## [1] "The mean NIDR for North Carolina in the given years is 0.778 and the standard error is 0.102"
## [1] "The mean NIDR for North Dakota in the given years is 0.141 and the standard error is 0.01"
## [1] "The mean NIDR for Ohio in the given years is 0.744 and the standard error is 0.046"
## [1] "The mean NIDR for Oklahoma in the given years is 0.64 and the standard error is 0.042"
## [1] "The mean NIDR for Oregon in the given years is 0.128 and the standard error is 0.056"
## [1] "The mean NIDR for Pennsylvania in the given years is 0.691 and the standard error is 0.07"
## [1] "The mean NIDR for Rhode Island in the given years is 0.679 and the standard error is 0.236"
## [1] "The mean NIDR for South Carolina in the given years is 0.683 and the standard error is 0.164"
## [1] "The mean NIDR for South Dakota in the given years is 0.24 and the standard error is 0.054"
## [1] "The mean NIDR for Tennessee in the given years is 0.765 and the standard error is 0.067"
## [1] "The mean NIDR for Texas in the given years is 0.707 and the standard error is 0.06"
## [1] "The mean NIDR for Utah in the given years is 0.341 and the standard error is 0.091"
## [1] "The mean NIDR for Vermont in the given years is 0 and the standard error is 0"
## [1] "The mean NIDR for Virginia in the given years is 0.447 and the standard error is 0.146"
## [1] "The mean NIDR for Washington in the given years is 0 and the standard error is NA"
## [1] "The mean NIDR for West Virginia in the given years is 0.833 and the standard error is 0.167"
## [1] "The mean NIDR for Wisconsin in the given years is 0.493 and the standard error is 0.038"
## [1] "The mean NIDR for Wyoming in the given years is 0.216 and the standard error is 0.068"
```

```r
ggplot(data=testing2, mapping=aes(x=State, y=Mean.NIDR))+
  geom_bar(stat='identity') +
  geom_errorbar(aes(ymin=Mean.NIDR-SE.NIDR, ymax=Mean.NIDR+SE.NIDR), size=.3, width=.2)
```

```
## Warning: Removed 2 rows containing missing values (geom_errorbar).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-25-1.png)<!-- -->

### Exercise 1.20 

Use pipes to produce the same plots without using your function.


```r
print('No.')
```

```
## [1] "No."
```

### Exercise 1.21 

Choose a longitude to designate the "center" of the country. Use the function ifelse to assign each state to an "Eastern" region or a "Western" region.


```r
wnv$ew <- ifelse(wnv$Longitude>-98, "Eastern", "Western")
```

### Exercise 1.22 

Analyse your data to compare case fatality rates in the Eastern vs. Weestern United States.


```r
t.test(wnv[wnv$ew=="Eastern",]$cfr, wnv[wnv$ew=="Western",]$cfr)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  wnv[wnv$ew == "Eastern", ]$cfr and wnv[wnv$ew == "Western", ]$cfr
## t = 5.5612, df = 267.27, p-value = 6.494e-08
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  0.02631474 0.05516013
## sample estimates:
##  mean of x  mean of y 
## 0.07035600 0.02961857
```


### Exercise 1.23 

Is there evidence for a latitudinal gradient in case fatality rate? 


```r
wnv$ns <- ifelse(wnv$Latitude<39, "South", "North")

t.test(wnv[wnv$ns=="South",]$cfr, wnv[wnv$ns=="North",]$cfr)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  wnv[wnv$ns == "South", ]$cfr and wnv[wnv$ns == "North", ]$cfr
## t = 1.9566, df = 188.66, p-value = 0.05188
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.0001592466  0.0389417719
## sample estimates:
##  mean of x  mean of y 
## 0.06911066 0.04971939
```


### Exercise 1.24 

Loop over all the years in the WNV data set (1999-2007) and compute the following statistics: Total number of states reporting cases, total number of reported cases, total number of fatalities, and case fatality rate. Produce some plots to explore how these quantities change over and with respect to each other. Explain what you have learned or suspect based on these plots.



```r
years <- 1999:2007
year.reports <- c()
year.totals <- c()
year.fatals <- c()
year.cfrs <- c()

for(i in years){
  year.reports <- c(year.reports,nrow(wnv[wnv$Year==i,]))
  year.totals <- c(year.totals, sum(wnv[wnv$Year==i,]$Total))
  year.fatals <- c(year.fatals, sum(wnv[wnv$Year==i,]$Fatal))
  year.cfrs <- c(year.cfrs, sum(wnv[wnv$Year==i,]$Total)/sum(wnv[wnv$Year==i,]$Fatal))
}
rm(i)

data <- as.data.frame(cbind(years, year.reports, year.totals, year.fatals, year.cfrs))

par(mfrow=c(2,2))
for(i in 2:length(names(data))){
  plot(data[,names(data)[i]]~data$years, xlab="Year", ylab=paste0(names(data)[i]))
}
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-30-1.png)<!-- -->



### Exercise 1.25 

How does your choice of longitudinal breakpoint matter to the evidence for a geographic difference in case fatality rate? Combine conditional execution and looping to study the difference in case fatality rate over a range of breakpoints. What is the "best" longitude for separating case fatality rate in the East vs. West?


```r
longs <- -72:-110
ps <- c()
diffs <- c()

for(i in 1:length(longs)){
  .ew <- ifelse(wnv$Longitude>longs[i], "Eastern", "Western")

  tts<-t.test(wnv[.ew=="Eastern",]$cfr, wnv[.ew=="Western",]$cfr)
  ps <- c(ps, tts$p.value)
  diffs <- c(diffs,as.numeric(diff(tts$estimate)))
}

data <- as.data.frame(cbind(longs, ps, diffs))
print(data)
```

```
##    longs           ps         diffs
## 1    -72 5.835349e-01 -0.0186247426
## 2    -73 8.759395e-01 -0.0032653472
## 3    -74 8.759395e-01 -0.0032653472
## 4    -75 8.875387e-01  0.0023424803
## 5    -76 9.805049e-01  0.0003015125
## 6    -77 9.805049e-01  0.0003015125
## 7    -78 3.848398e-01 -0.0103532238
## 8    -79 4.335042e-01 -0.0089251675
## 9    -80 7.470150e-01 -0.0035082614
## 10   -81 3.384981e-01 -0.0124297250
## 11   -82 4.514869e-01 -0.0093237391
## 12   -83 1.989020e-01 -0.0146483823
## 13   -84 8.401637e-02 -0.0188158463
## 14   -85 8.401637e-02 -0.0188158463
## 15   -86 1.637804e-02 -0.0245599788
## 16   -87 5.915710e-04 -0.0323473348
## 17   -88 5.915710e-04 -0.0323473348
## 18   -89 5.915710e-04 -0.0323473348
## 19   -90 1.531881e-04 -0.0334860432
## 20   -91 9.022295e-05 -0.0337112887
## 21   -92 1.744484e-05 -0.0350597667
## 22   -93 2.267188e-06 -0.0377123140
## 23   -94 1.050821e-06 -0.0382559889
## 24   -95 1.473155e-06 -0.0373326331
## 25   -96 1.473155e-06 -0.0373326331
## 26   -97 1.473155e-06 -0.0373326331
## 27   -98 6.493597e-08 -0.0407374313
## 28   -99 1.550357e-08 -0.0419237418
## 29  -100 3.408246e-08 -0.0408867115
## 30  -101 3.408246e-08 -0.0408867115
## 31  -102 3.408246e-08 -0.0408867115
## 32  -103 3.408246e-08 -0.0408867115
## 33  -104 3.408246e-08 -0.0408867115
## 34  -105 3.408246e-08 -0.0408867115
## 35  -106 6.505983e-07 -0.0381825772
## 36  -107 3.821744e-08 -0.0420045554
## 37  -108 3.293121e-10 -0.0439983459
## 38  -109 3.293121e-10 -0.0439983459
## 39  -110 3.293121e-10 -0.0439983459
```

```r
plot(data$diffs~data$longs, xlab="Longitude Dividing Line", ylab="Eastern CFR - Western CFR")
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-31-1.png)<!-- -->

### Exercise 1.26 

We may interpret raw case fatality rate (i.e. ratio of the number of deaths, x, to number of infections, n) as a realization from a binomial process with n trials and x "successes" generated by an unknown rate parameter p. This p may be the quantity truly of interest (for instance, if we wish to ask if the case fatality rate in California is significantly different from the case fatality rate in Colorado. In R, the estimated rate and its confidence interval can be obtained using the function prop.test for testing equal proportions. Use the help to determine the proper usage of prop.test and calculate confidence intervals for the case fatality rates in all states for which there have been reported cases of WNV.




```r
Colorado <- wnv[wnv$State=="Colorado",c("State", "Fatal", "Total")]
CO.fatals <- sum(Colorado$Fatal)
CO.totals <- sum(Colorado$Total)
California <- wnv[wnv$State=="California",c("State", "Fatal", "Total")]
CA.fatals <- sum(California$Fatal)
CA.totals <- sum(California$Total)


data <- as.data.frame(t(cbind(rbind(CO.fatals,CO.totals),rbind(CA.fatals,CA.totals))))
names(data) <- c("Fatals", "Totals")
data$State <- c("CO", "CA")

prop.test(x=data$Fatals, n=data$Totals)
```

```
## 
## 	2-sample test for equality of proportions with continuity
## 	correction
## 
## data:  data$Fatals out of data$Totals
## X-squared = 9.5714, df = 1, p-value = 0.001976
## alternative hypothesis: two.sided
## 95 percent confidence interval:
##  -0.021074074 -0.003897433
## sample estimates:
##     prop 1     prop 2 
## 0.01939706 0.03188281
```

```r
Colorado <- wnv[wnv$State=="Colorado",c("State", "Fatal", "Total")]
CO.fatals <- sum(Colorado$Fatal)
CO.totals <- sum(Colorado$Total)
California <- wnv[wnv$State=="California",c("State", "Fatal", "Total")]
CA.fatals <- sum(California$Fatal)
CA.totals <- sum(California$Total)
Georgia <- wnv[wnv$State=="Georgia",c("State", "Fatal", "Total")]
GA.fatals <- sum(Georgia$Fatal)
GA.totals <- sum(Georgia$Total)

data <- as.data.frame(t(cbind(rbind(CO.fatals,CO.totals),rbind(CA.fatals,CA.totals),rbind(GA.fatals,GA.totals))))
names(data) <- c("Fatals", "Totals")
data$State <- c("CO", "CA", "GA")

prop.test(x=data$Fatals, n=data$Totals)
```

```
## 
## 	3-sample test for equality of proportions without continuity
## 	correction
## 
## data:  data$Fatals out of data$Totals
## X-squared = 38.839, df = 2, p-value = 3.683e-09
## alternative hypothesis: two.sided
## sample estimates:
##     prop 1     prop 2     prop 3 
## 0.01939706 0.03188281 0.08542714
```





```r
wnv$State1 <- relevel(wnv$State, ref="Colorado")
summary(glm(cbind(wnv$Fatal, {wnv$Total-wnv$Fatal})~wnv$State1, family=binomial))
```

```
## 
## Call:
## glm(formula = cbind(wnv$Fatal, {
##     wnv$Total - wnv$Fatal
## }) ~ wnv$State1, family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -3.2570  -0.7117  -0.2464   0.5852   2.5001  
## 
## Coefficients:
##                                  Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                      -3.92305    0.11084 -35.392  < 2e-16 ***
## wnv$State1Alabama                 1.51011    0.32106   4.703 2.56e-06 ***
## wnv$State1Arizona                 1.00044    0.19826   5.046 4.51e-07 ***
## wnv$State1Arkansas                1.32655    0.31911   4.157 3.22e-05 ***
## wnv$State1California              0.50976    0.16200   3.147 0.001652 ** 
## wnv$State1Connecticut             0.96122    0.60238   1.596 0.110556    
## wnv$State1Delaware                1.67176    0.75161   2.224 0.026133 *  
## wnv$State1District of Columbia    0.11638    1.01711   0.114 0.908900    
## wnv$State1Florida                 1.16093    0.31762   3.655 0.000257 ***
## wnv$State1Georgia                 1.55225    0.27677   5.608 2.04e-08 ***
## wnv$State1Idaho                  -0.00967    0.24214  -0.040 0.968144    
## wnv$State1Illinois                1.19438    0.15292   7.811 5.69e-15 ***
## wnv$State1Indiana                 0.93386    0.24073   3.879 0.000105 ***
## wnv$State1Iowa                    0.88489    0.28662   3.087 0.002019 ** 
## wnv$State1Kansas                  1.01572    0.30563   3.323 0.000889 ***
## wnv$State1Kentucky                1.36776    0.38340   3.567 0.000360 ***
## wnv$State1Louisiana               1.25672    0.17186   7.312 2.63e-13 ***
## wnv$State1Maryland                1.87894    0.27393   6.859 6.92e-12 ***
## wnv$State1Massachusetts           1.76356    0.44518   3.961 7.45e-05 ***
## wnv$State1Michigan                1.57027    0.16850   9.319  < 2e-16 ***
## wnv$State1Minnesota               0.50532    0.29335   1.723 0.084969 .  
## wnv$State1Mississippi             1.11747    0.19532   5.721 1.06e-08 ***
## wnv$State1Missouri                1.31543    0.21926   5.999 1.98e-09 ***
## wnv$State1Montana                -0.17753    0.37330  -0.476 0.634389    
## wnv$State1Nebraska               -0.15523    0.18546  -0.837 0.402589    
## wnv$State1Nevada                 -0.32545    0.59193  -0.550 0.582450    
## wnv$State1New Hampshire         -13.23644 1863.92124  -0.007 0.994334    
## wnv$State1New Jersey              1.10167    0.47349   2.327 0.019981 *  
## wnv$State1New Mexico              0.61146    0.29380   2.081 0.037415 *  
## wnv$State1New York                1.82685    0.20648   8.847  < 2e-16 ***
## wnv$State1North Carolina          0.92731    0.73300   1.265 0.205836    
## wnv$State1North Dakota           -0.62921    0.30003  -2.097 0.035982 *  
## wnv$State1Ohio                    1.36892    0.18396   7.441 9.96e-14 ***
## wnv$State1Oklahoma                1.25582    0.25644   4.897 9.72e-07 ***
## wnv$State1Oregon                 -0.01853    0.72249  -0.026 0.979533    
## wnv$State1Pennsylvania            1.13862    0.25069   4.542 5.57e-06 ***
## wnv$State1Rhode Island            1.72582    1.05991   1.628 0.103465    
## wnv$State1South Carolina          0.97861    1.03195   0.948 0.342972    
## wnv$State1South Dakota           -0.22799    0.22661  -1.006 0.314373    
## wnv$State1Tennessee               1.40829    0.33249   4.236 2.28e-05 ***
## wnv$State1Texas                   1.19525    0.14626   8.172 3.03e-16 ***
## wnv$State1Utah                    0.35351    0.37524   0.942 0.346146    
## wnv$State1Vermont               -13.01623 1445.90709  -0.009 0.992817    
## wnv$State1Virginia                1.10465    0.52651   2.098 0.035900 *  
## wnv$State1Washington            -13.23644 1863.92124  -0.007 0.994334    
## wnv$State1West Virginia           3.22990    0.87309   3.699 0.000216 ***
## wnv$State1Wisconsin               1.30809    0.36267   3.607 0.000310 ***
## wnv$State1Wyoming                 0.18538    0.28380   0.653 0.513625    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 684.57  on 271  degrees of freedom
## Residual deviance: 252.41  on 224  degrees of freedom
## AIC: 906.68
## 
## Number of Fisher Scoring iterations: 15
```

### Exercise 1.27 

The "See Also" section of the help for prop.test states that a different function might be useful for an exact test of our hypotheses. Use the help to identify what this function is, learn how to use it, and compare the differences.



# Module 2



```r
if(require(tidyverse)){library(tidyverse)}else{install.packages("tidyverse");library(tidyverse)}
if(require(magrittr)){library(magrittr)}else{install.packages("magrittr");library(magrittr)}
if(require(dplyr)){library(dplyr)}else{install.packages("dplyr");library(dplyr)}
if(require(stringr)){library(stringr)}else{install.packages("stringr");library(stringr)}
if(require(GGally)){library(GGally)}else{install.packages("GGally");library(GGally)}
if(require(maptools)){library(maptools)}else{install.packages("maptools");library(maptools)}
if(require(ggmap)){library(ggmap)}else{install.packages("ggmap");library(ggmap)}
if(require(maps)){library(maps)}else{install.packages("maps");library(maps)}
```

## Wrangling


### Task 1

Read in all three csv files as tibble data frames. For consistency with these notes, we'll assign their dataframes to be called "ld", "pop", and "prism", respectively. 


```r
ld <- read_csv("./Workshop I/Data/lyme.csv")
pop <- read_csv("./Workshop I/Data/pop.csv")
prism <- read_csv("./Workshop I/Data/climate.csv")
```

### Task 2

By inspecting the 'pop' data, and talking with your neighbors and instructors, articulate in which way(s) these data fail to conform to the tidy data format?



### Task 3 

Before running the code, read it to see if you can work out or guess what each line is doing. Before running a line of code, remind yourself of the current format of pop by typing it's name in the console window and hitting return. Then run each line, one by one, and after each line has been executed, look again at pop to see what it did. Once you're clear about what each line is doing, add a comment line above each code line
to remind you, in your own words, what the code does.


```r
pop %<>% select(fips,starts_with("pop2"))
pop %<>% gather(starts_with("pop2"),key="str_year",value="size") %>% na.omit
pop %<>% mutate(year=str_replace_all(str_year,"pop",""))
pop %<>% mutate(year=as.integer(year))
#pop %<>% mutate(fips=str_replace_all(fips,"^0",""))
pop %<>% mutate(fips=as.integer(fips)) %>% select(-str_year)
```


### Task 4

Write a code chunk to convert the Lyme disease data to tidy data format. 



```r
ld$FIPS.county <- ifelse(ld$CTYCODE<10, paste0("00", ld$CTYCODE), 
                          ifelse(ld$CTYCODE<100, paste0("0", ld$CTYCODE), paste0(ld$CTYCODE)))
ld$fips <- paste0(ld$STCODE, ld$FIPS.county)



ld %<>% select(state=STNAME, county=CTYNAME, fips,starts_with("Cases2"))
ld %<>% gather(starts_with("Cases2"),key="str_year",value="count") %>% na.omit
ld %<>% mutate(year=str_replace_all(str_year,"Cases",""))
ld %<>% mutate(year=as.integer(year))
#ld %<>% mutate(fips=str_replace_all(fips,"^0",""))
ld %<>% mutate(fips=as.integer(fips)) %>% select(-str_year)
```


### Task 5

Join the Lyme disease data frame and PRISM data frame together to form a new data frame, and in such a way that it retains county-year combinations for which we have both disease and climate data.


```r
data <- inner_join(ld, prism)
```

```
## Joining, by = c("fips", "year")
```



### Task 6

Write a line of code to additionally combine the demographic data with the Lyme disease and climate data.


```r
data <- left_join(data, pop)
```

```
## Joining, by = c("fips", "year")
```


### Task 7

Write two lines of code that create two new data frames: (1) to determine how many cases of Lyme disease were reported each year, (2) the average number of cases in each state - averaged across county and year. What was the worst year? Which three states have been most impacted on average?


```r
annual.reports <- rowsum(data$count, group=data$year)

data %>% group_by(year) %>% summarize(Total.cases = sum(count)) %>% arrange(desc(Total.cases))
```

```
## # A tibble: 16 x 2
##     year Total.cases
##    <dbl>       <dbl>
##  1  2015       37574
##  2  2009       36098
##  3  2013       35060
##  4  2014       33044
##  5  2008       32813
##  6  2011       30996
##  7  2012       28739
##  8  2010       27730
##  9  2007       26432
## 10  2002       23463
## 11  2005       23170
## 12  2003       21180
## 13  2006       19845
## 14  2004       19662
## 15  2000       17568
## 16  2001       16862
```

```r
data %>% group_by(state) %>% summarize(Average.cases = mean(count)) %>% arrange(desc(Average.cases))
```

```
## # A tibble: 49 x 2
##    state         Average.cases
##    <chr>                 <dbl>
##  1 Connecticut           290. 
##  2 Massachusetts         202. 
##  3 Delaware              163. 
##  4 New Jersey            158. 
##  5 Rhode Island           85.0
##  6 New Hampshire          79.0
##  7 New York               76.3
##  8 Pennsylvania           71.2
##  9 Maryland               56.8
## 10 Maine                  41.5
## # ... with 39 more rows
```



### Task 8

use save to create an Rda file of the data frame and use write_csv to create a csv file of the same (remember to try ?save and ?write_csv in the console if you're not sure how these functions work).



```r
save(data, file="./Workshop I/Data/lymedata_clean.rdata")

write.csv(data, file="./Workshop I/Data/lymedata_clean.csv")
```



### Task 9

Add annotations to the following lines of code with comment lines to explain what they are achieving. Note: in the code line with "group_by(ld.prism.pop)" you need to replace the data frame in parentheses with the name of your data frame in which you combined Lyme disease, climate and demography data (Task 6)



```r
county_map <- map_data("county") # geo-data for US counties
state_map <- map_data("state") # geo-data for US states
ag.fips <- group_by(data,fips) # order by fips
ld.16y<-summarize(ag.fips,all.cases=sum(count)) # total case counts per county across all years
ld.16y<-left_join(select(data,c(state,county,fips)),ld.16y) # put total case counts with fips and state and county identifiers
```

```
## Joining, by = "fips"
```

```r
ld.16y<-distinct(ld.16y) # remove duplicates?
ld.16y %<>% rename(region=state,subregion=county) # rename vars
ld.16y$subregion<-str_replace_all(ld.16y$subregion," County","") # create var and strip following string
ld.16y$region<-tolower(ld.16y$region) # lowercase
ld.16y$subregion<-tolower(ld.16y$subregion) # lowercase
ld.16y$subregion<-str_replace_all(ld.16y$subregion," parish","") # drop parish suffix
ld.16y %<>% mutate(log10cases=log10(1+all.cases)) # log transformation with continuity correction
map.ld.16y<-left_join(county_map,ld.16y) # case data with geo-data
```

```
## Joining, by = c("region", "subregion")
```

```r
ggplot(map.ld.16y)+
  geom_polygon(aes(long,lat,group=group,fill=log10cases),
               color="gray",lwd=0.2) +
scale_fill_gradientn(colours=rev(heat.colors(10))) # map making
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-41-1.png)<!-- -->












## Modeling


### Task 1

Using either read_csv (note: the underscore version, not read.csv) or load, import the data set you put together in the module on 'Data wrangling in R'



```r
load("./Workshop I/Data/lymedata_clean.rdata")
```


### Task 2

Use the ggpairs function to obtain a 4x4 summary plot of precipitation (prcp), average temperature (avtemp), population size (size), number of Lyme disease cases (cases). Note: it may take several seconds for this plot to appear as there are nearly 50,000 data points.



```r
ggpairs(data, columns = c(4,6:8))
```

```
## Warning in (function (data, mapping, alignPercent = 0.6, method =
## "pearson", : Removed 3114 rows containing missing values
```

```
## Warning in (function (data, mapping, alignPercent = 0.6, method =
## "pearson", : Removed 3114 rows containing missing values
```

```
## Warning in (function (data, mapping, alignPercent = 0.6, method =
## "pearson", : Removed 3114 rows containing missing values
```

```
## Warning: Removed 3114 rows containing missing values (geom_point).

## Warning: Removed 3114 rows containing missing values (geom_point).

## Warning: Removed 3114 rows containing missing values (geom_point).
```

```
## Warning: Removed 3114 rows containing non-finite values (stat_density).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-43-1.png)<!-- -->


### Task 3

Create two new columns for log10(size) and log10(cases+1) and substitute these for the original size and cases supplied when you recreate the ggpairs plot. Why do we add 1 to the number of cases?


```r
data %<>% mutate(log10.size=log10(size), log10.cases=log10(count+1))

ggpairs(data, columns = c(6:7,9:10))
```

```
## Warning in (function (data, mapping, alignPercent = 0.6, method =
## "pearson", : Removed 3114 rows containing missing values
```

```
## Warning in (function (data, mapping, alignPercent = 0.6, method =
## "pearson", : Removed 3114 rows containing missing values
```

```
## Warning: Removed 3114 rows containing missing values (geom_point).

## Warning: Removed 3114 rows containing missing values (geom_point).
```

```
## Warning: Removed 3114 rows containing non-finite values (stat_density).
```

```
## Warning in (function (data, mapping, alignPercent = 0.6, method =
## "pearson", : Removed 3114 rows containing missing values
```

```
## Warning: Removed 3114 rows containing missing values (geom_point).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-44-1.png)<!-- -->


### Task 4

Using set.seed(222) for reproducibility, create a new data frame to be a random sample (n=100 rows) of the full data frame and plot precipitation (x-axis) vs average temperature (y-axis).



```r
set.seed(222)

sample_n(data, 100) %>% ggplot()+geom_point(aes(y=avtemp,x=prcp))
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-45-1.png)<!-- -->




### Task 5

Add the best straight line to the plot using geom_smooth.

```r
set.seed(222)
sample_n(data, 100) %>% ggplot()+geom_point(aes(y=avtemp,x=prcp))+geom_smooth(aes(y=avtemp, x=prcp), method=lm)
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-46-1.png)<!-- -->

### Task 6

Create a linear model (lm) object with a call like myModel <- lm(y ~ x, data = myData) for the subsetted data, where y=avtemp and x=prcp. In addition, view the summary with a call along the lines of summary(myModel)



```r
summary(lm(avtemp~prcp, data=data))
```

```
## 
## Call:
## lm(formula = avtemp ~ prcp, data = data)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -13.3881  -3.0529  -0.3453   2.9748  15.3787 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 8.870e+00  5.084e-02  174.48   <2e-16 ***
## prcp        3.749e-03  4.663e-05   80.41   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.259 on 49742 degrees of freedom
## Multiple R-squared:  0.115,	Adjusted R-squared:  0.115 
## F-statistic:  6465 on 1 and 49742 DF,  p-value: < 2.2e-16
```



### Task 7

What is the slope of the line you plotted in Task 5, and is the slope significantly different from 0 (p<0.05)?

The slope of the line is 0.0037 and, yes it is statistically significantly different from 0 (t=80.41, p=0).


### Task 8

Write a single line of code to generate a ggplot of total population size by year.


```r
data %>% group_by(year) %>% summarize(Total.pop = sum(size)) %>% ggplot()+geom_line(aes(y=Total.pop, x=year))
```

```
## Warning: Removed 6 rows containing missing values (geom_path).
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-48-1.png)<!-- -->

```r
data %>% group_by(year) %>% summarize(Total.pop = sum(size, na.rm=TRUE)) %>% ggplot()+geom_line(aes(y=Total.pop, x=year))
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-48-2.png)<!-- -->

### Task 9

Create a data frame called "by_state" from the main data frame, that groups by state, and inspect it.


```r
by_state <- data %>% group_by(state)
```



### Task 10

Next, update this new data frame so that it is nested (simply pass it to nest). Again, inspect the data frame by typing its name in the console so see how things changed.


```r
by_state %<>% nest()
```



### Task 11

Display the Georgia data in the console window.


```r
by_state$data[[10]]
```

```
## # A tibble: 2,544 x 9
##    county        fips count  year  prcp avtemp  size log10.size log10.cases
##    <chr>        <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl>      <dbl>       <dbl>
##  1 Appling Cou~ 13001     0  2000  965.   18.6 17408       4.24           0
##  2 Atkinson Co~ 13003     0  2000 1055.   18.7  7610       3.88           0
##  3 Bacon County 13005     0  2000 1054.   18.8 10122       4.01           0
##  4 Baker County 13007     0  2000  963.   18.9  4053       3.61           0
##  5 Baldwin Cou~ 13009     0  2000  866.   17.3 44738       4.65           0
##  6 Banks County 13011     0  2000  993.   15.6 14504       4.16           0
##  7 Barrow Coun~ 13013     0  2000  979.   15.9 46561       4.67           0
##  8 Bartow Coun~ 13015     0  2000 1104.   15.6 76703       4.88           0
##  9 Ben Hill Co~ 13017     0  2000 1102.   18.4 17473       4.24           0
## 10 Berrien Cou~ 13019     0  2000 1083.   18.7 16250       4.21           0
## # ... with 2,534 more rows
```

### Task 12

Write a function that takes a data frame as its argument and returns a linear model object that predicts size by year.


```r
sby <- function(data){
  lm(size~year, data)
}
```


### Task 13

Add a column to the by_state dataframe, where each row (state) has its own model object.


```r
models <- list()

for(i in 1:nrow(by_state)){
models[[i]] <- sby(by_state$data[[i]])
}

by_state$models <- models


#by_state$mods <- purrr::map(by_state$data, sby)
```



### Task 14

Run these commands and inspect "resids". What is the structure of "resids"?


```r
by_state$residuals <- purrr::map(by_state$models, residuals)
```



### Task 15

Write a function that accepts an object of the type in the resids list, and returns a sum of the absolute values, i.e. ignoring sign: abs(3)+abs(-2)=5. Use the function to add a column called totalResid to by_state that provides the total size of residuals summed over counties and years.


```r
resid.sum <- function(raw.resids){
  sum(abs(raw.resids))
}

by_state$residual.sum <- purrr::map(by_state$residuals, resid.sum)
```


### Task 16

Write a function that accepts a linear model and returns the slope (model M has slope M$coefficients[2]) and then use this function to create a new column called slope in the by_state data frame, that is the slope for each state.


```r
get.slope <- function(model){
  summary(model)$coefficients[2]
}

by_state$slope <- purrr::map(by_state$models, get.slope)
```


### Task 17

Plot the growth rate (slope value) for all states.


```r
plot(y=unlist(by_state$slope),x=as.factor(unlist(by_state$state)))
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-57-1.png)<!-- -->

```r
ggplot(data=by_state, mapping=aes(x=as.factor(unlist(state)), y=unlist(slope)))+geom_point()+theme(axis.text.x=element_text(angle=90, hjust=1))
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-57-2.png)<!-- -->


### Task 18

Plot the total resisduals for all states.

```r
plot(y=unlist(by_state$residual.sum),x=as.factor(unlist(by_state$state)))
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-58-1.png)<!-- -->

### Task 19

Repeat Tasks 9 and 10 using a different data frame name, by_state2.


```r
by_state2 <- data %>% group_by(state)

by_state2 %<>% nest()
```


### Task 20

Write a function that accepts an element of the by_state2$data list-column and returns the spearman correlation coefficient between Lyme disease cases and precipitation



```r
correlate.spearman <- function(.data){
  cor.test(.data$count, .data$prcp, method="spearman")$estimate
}


by_state2$spcc <- purrr::map(by_state2$data, correlate.spearman)
```

















# Module 3

## Project management


### Exercise 1

Copy the MERS data file cases.csv and paste it into your working directory.


### Exercise 2 

Create a new script following the prototype we introduced. Your script should load the MERS data and make a plot.




### Exercise 3 

To commit a change, navigate to the "Git" tab in the top right explorer window. You will see a list of files in your work directory. Select the files that need to be pushed to Github and click on "Commit". A dialog box will open. In the top right there is an editing window where you can register a comment describing the nature of the commit.

### Exercise 4 

Once you have committed one or more changes (and documented with comments), you need to push the changes to the archived version. To do this, click on "Push". You will need to enter your Github credentials in the dialog box that pops up. Now refresh the website for your project. The latest versions of your files should appear.




### Exercise 5 

Create a basic R Markdown document. Go to File -> New File -> R Markdown. Enter a title and author into the dialog box. Select the desired default output format. Save the resulting, automatically generated file. To compile the document, click on "Knit" in the R Studio editor. Study the code and the resulting report.





### Exercise 6 

Visit the R Markdown website and look around. Especially, read through the Authoring Basics. 



### Exercise 7 


Borrowing from your earlier exercises, prepare an analysis of the WNV or MERS data as a reproducible document using R/Markdown. Compile to a pdf (if your desktop in class is not compiling in PDF compile in HTML.



### Exercise 8 

Add an interactive plotly graph to your reproducible document. Compile to HTML.




## Deterministic Models






```r
if(require(deSolve)){library(deSolve)}else{install.packages("deSolve");library(deSolve)}
```

```
## Loading required package: deSolve
```

```r
sir.model.closed <- function (t, x, params) {    #here we begin a function with three arguments
  S <- x[1]                               #create local variable S, the first element of x
  I <- x[2]                               #create local variable I
  R <- x[3]                               #create local variable R
  with(                                   #we can simplify code using "with"
       as.list(params),                   #this argument to "with" lets us use the variable names
       {                                  #the system of rate equations
         dS <- -beta*S*I
         dI <- beta*S*I-gamma*I
         dR <- gamma*I
         dx <- c(dS,dI,dR)                #combine results into a single vector dx
         list(dx)                         #return result as a list
       }
       )
}


times <- seq(0,120,by=5)                    #function seq returns a sequence
params <- c(beta=0.3,gamma=1/7)             #function c "c"ombines values into a vector
xstart <- c(S=9999/10000,I=1/10000,R=0)     #initial conditions


out <- as.data.frame(ode(xstart,times,sir.model.closed,params))  #result stored in dataframe


op <- par(fig=c(0,0.5,0,1),mar=c(4,4,1,1))                  #set graphical parameters
plot(I~time,data=out,type='b')                              #plot the I variable against time
par(fig=c(0.5,1,0,1),mar=c(4,1,1,1),new=T)                  #re-set graphical parameters
plot(I~S,data=out,type='b',yaxt='n',xlab='S')               #plot phase portrait
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-61-1.png)<!-- -->

```r
par(op)                                                     #re-set graphical parameters
```





### Exercise 1

Explore the dynamics of the system for different values of the $\beta$ and $\gamma$ parameters by simulating and plotting trajectories as time series and in phase space (e.g. *I* vs. *S*).


```r
betas <- seq(0.2, 0.6, 0.2)
gammas <- 1/c(3,7,9,11)

sim.params <- expand.grid(beta=betas, gamma=gammas)

for(i in 1:nrow(sim.params)){
  params <- sim.params[i,]
  
  out <- as.data.frame(ode(xstart,times,sir.model.closed,params)) 


op <- par(fig=c(0,0.5,0,1),mar=c(4,4,1,1))            
plot(I~time,data=out,type='b')
text(x=50,y=0, label=paste0("Beta=",round(params[1],2)," and Gamma=", round(params[2],2)))
par(fig=c(0.5,1,0,1),mar=c(4,1,1,1),new=T)       
plot(I~S,data=out,type='b',yaxt='n',xlab='S')   

par(op)                                    

}
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-62-1.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-2.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-3.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-4.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-5.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-6.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-7.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-8.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-9.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-10.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-11.png)<!-- -->![](Writeup_CAD_files/figure-html/unnamed-chunk-62-12.png)<!-- -->

### Exercise 2

Explore the dynamics of the system for one set of $\beta$ and $\gamma$ at different initial conditions. What happens if there is pre-existing immunity in the population?


```r
params <- c(beta=0.3,gamma=1/7)             #function c "c"ombines values into a vector
xstart <- c(S=9999/10000,I=1/10000,R=0)     #initial conditions
xstart <- c(S=1000/10000,I=1/10000,R=8999) 

out <- as.data.frame(ode(xstart,times,sir.model.closed,params))  #result stored in dataframe


op <- par(fig=c(0,0.5,0,1),mar=c(4,4,1,1))                  #set graphical parameters
plot(I~time,data=out,type='b')                              #plot the I variable against time
par(fig=c(0.5,1,0,1),mar=c(4,1,1,1),new=T)                  #re-set graphical parameters
plot(I~S,data=out,type='b',yaxt='n',xlab='S')               #plot phase portrait
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-63-1.png)<!-- -->

```r
par(op)  
```


### Exercise 3

Modify the codes given to study the dynamics of a demographically open *SIR* model.





```r
if(require(deSolve)){library(deSolve)}else{install.packages("deSolve");library(deSolve)}


sir.model.closed <- function (t, x, params) {    #here we begin a function with three arguments
  S <- x[1]                               #create local variable S, the first element of x
  I <- x[2]                               #create local variable I
  R <- x[3]                               #create local variable R
  with(                                   #we can simplify code using "with"
       as.list(params),                   #this argument to "with" lets us use the variable names
       {                                  #the system of rate equations
         dS <- births-beta*S*I-mu*S
         dI <- beta*S*I-gamma*I-mu*I
         dR <- gamma*I-mu*R
         dx <- c(dS,dI,dR)                #combine results into a single vector dx
         list(dx)                         #return result as a list
       }
       )
}


times <- seq(0,120,by=5)                    #function seq returns a sequence
params <- c(beta=0.3,gamma=1/7, births=1/(365), mu=1/(365))             #function c "c"ombines values into a vector
xstart <- c(S=9999/10000,I=1/10000,R=0)     #initial conditions


out <- as.data.frame(ode(xstart,times,sir.model.closed,params))  #result stored in dataframe


op <- par(fig=c(0,0.5,0,1),mar=c(4,4,1,1))                  #set graphical parameters
plot(I~time,data=out,type='b')                              #plot the I variable against time
par(fig=c(0.5,1,0,1),mar=c(4,1,1,1),new=T)                  #re-set graphical parameters
plot(I~S,data=out,type='b',yaxt='n',xlab='S')               #plot phase portrait
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-64-1.png)<!-- -->

```r
par(op)                                                     #re-set graphical parameters
```


### Exercise 4

Modify the codes given to study the dynamics of an *SEIR* model. 



```r
if(require(deSolve)){library(deSolve)}else{install.packages("deSolve");library(deSolve)}


sir.model.closed <- function (t, x, params) {    #here we begin a function with three arguments
  S <- x[1]                               #create local variable S, the first element of x
  E <- x[2]
  I <- x[3]                               #create local variable I
  R <- x[4]                               #create local variable R
  with(                                   #we can simplify code using "with"
       as.list(params),                   #this argument to "with" lets us use the variable names
       {                                  #the system of rate equations
         dS <- births-beta*S*I-mu*S
         dE <- beta*S*I-lambda*E
         dI <- lambda*E-gamma*I-mu*I
         dR <- gamma*I-mu*R
         dx <- c(dS,dE,dI,dR)                #combine results into a single vector dx
         list(dx)                         #return result as a list
       }
       )
}


times <- seq(0,200,by=5)                    #function seq returns a sequence
params <- c(beta=0.3,gamma=1/7, births=1/(365), mu=1/(365), lambda=1/3)             #function c "c"ombines values into a vector
xstart <- c(S=9999/10000, E=0, I=1/10000, R=0)     #initial conditions


out <- as.data.frame(ode(xstart,times,sir.model.closed,params))  #result stored in dataframe
out1 <- as.data.frame(lsoda(xstart,times,sir.model.closed,params))

op <- par(fig=c(0,0.5,0,1),mar=c(4,4,1,1))                  #set graphical parameters
plot(I~time,data=out,type='b')                              #plot the I variable against time
par(fig=c(0.5,1,0,1),mar=c(4,1,1,1),new=T)                  #re-set graphical parameters
plot(I~S,data=out,type='b',yaxt='n',xlab='S')               #plot phase portrait
```

![](Writeup_CAD_files/figure-html/unnamed-chunk-65-1.png)<!-- -->

```r
par(op)                                                     #re-set graphical parameters
```






