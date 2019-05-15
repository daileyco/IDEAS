mers <- read.csv("cases.csv")

hist(as.numeric(mers$age), xlab="Age", main="Histogram of Age in MERS Cases Dataset")


library(ggplot2)

ggplot(data=mers, mapping=aes(x=as.numeric(age)))+geom_histogram(binwidth = 5)+labs(x="Age", y="Frequency", title="Histogram of Age in MERS Cases Dataset", caption="Data from: https://github.com/rambaut/MERS-Cases/blob/gh-pages/data/cases.csv")
