# Load libraries, Set working directory, load dataset
# setwd("C:/Path/To/Folder")
library(readr)
library(reshape2)
library(ggplot2)
library(RColorBrewer)
library(scales)
browser <- read_csv("browser.csv")

# Add "date" to columns
browser$date<-as.Date(paste(browser$month,browser$year, 1),"%B %Y %e")

# Put browser into columnar format. Create column for family.
browser<-melt(browser, id=c("month","year","date"))
browser$family<-NA

# Assign family to each variable
browser[browser$variable=="Chrome",]$family<-"Google"#
browser[browser$variable=="IE",]$family<-"Microsoft"#
browser[browser$variable=="Firefox",]$family<-"Mozilla"#
browser[browser$variable=="Safari",]$family<-"Apple"
browser[browser$variable=="Opera",]$family<-"Opera"
browser[browser$variable=="Mozilla",]$family<-"Mozilla"#
browser[browser$variable=="Netscape",]$family<-"Mozilla"#
browser[browser$variable=="AOL",]$family<-"AOL"#

# Order factors
browser$variable<-factor(browser$variable, levels =
                      c("IE", "AOL", "Netscape", "Mozilla",
                        "Firefox", "Opera","Safari","Chrome"))

# Final plot of all data
ggplot(browser,aes(date,value))+
  geom_area(position="fill",aes(fill=variable),color="black",alpha=.75)+
  scale_fill_manual("Browser",values=c(
    # IE and AOL
    rev(brewer.pal(3,"Blues")[2:3]),
    # Firefox Family
    brewer.pal(3,"Greens"),
    # Opera et al.
    brewer.pal(9,"Set1")[c(1,5,6)]),
    labels=c("Internet Explorer", "AOL", "Netscape", "Mozilla",
               "Firefox", "Opera","Safari","Chrome"))+
  scale_y_continuous(labels=scales::percent)+
  labs(title="Operating System Market Share",
       subtitle="As reported by w3schools.com",
       x="",
       y="Market Share")+
  theme_bw()
ggsave("Browser Share.png",height=9,width=16,dpi=120,type="cairo-png")