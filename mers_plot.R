mers <- read.csv("cases.csv")

hist(as.numeric(mers$age), xlab="Age", main="Histogram of Age in MERS Cases Dataset")
