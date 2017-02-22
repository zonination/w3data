# Load libraries, Set working directory, load dataset
# setwd("C:/Path/To/Folder")
library(readr)
library(reshape2)
library(ggplot2)
library(RColorBrewer)
library(scales)
os <- read_csv("os.csv")

# Add "date" to columns
os$date<-as.Date(paste(os$month,os$year, 1),"%B %Y %e")

# Put OS into columnar format. Create column for family.
os<-melt(os, id=c("month","year","date"))
os$family<-NA

# Assign family to each variable
os[os$variable=="Win10",]$family<-"Windows PC"
os[os$variable=="Win8",]$family<-"Windows PC"
os[os$variable=="Win7",]$family<-"Windows PC"
os[os$variable=="Vista",]$family<-"Windows PC"
os[os$variable=="WinXP",]$family<-"Windows PC"
os[os$variable=="NT",]$family<-"Windows Server"
os[os$variable=="Linux",]$family<-"Linux"
os[os$variable=="Mac",]$family<-"Apple"
os[os$variable=="Chrome OS",]$family<-"Linux"
os[os$variable=="Mobile",]$family<-"Other";
os[os$variable=="W2000",]$family<-"Windows PC"
os[os$variable=="W2003",]$family<-"Windows Server"
os[os$variable=="Win98",]$family<-"Windows PC"
os[os$variable=="Win95",]$family<-"Windows PC"

# Order factors
os$variable<-factor(os$variable, levels =
                      c("Win10", "Win8", "Win7", "Vista",
                        "WinXP", "W2000", "Win98", "Win95",
                        "W2003", "NT",
                        "Mac", "Linux", "Chrome OS", "Mobile"))

# Final plot of all data
ggplot(os,aes(date,value))+
  geom_area(position="fill",aes(fill=variable),color="black")+
  scale_fill_manual("Operating\nSystem",values=c(
        # Windows PCs
        rev(brewer.pal(8,"Blues")),
        # Windows Servers
        rev(brewer.pal(3,"Greens")[2:3]),
        # Apple
        brewer.pal(3,"Purples")[3],
        # Linux family
        rev(brewer.pal(3,"Oranges")[2:3]),
        # Other
        brewer.pal(3,"Greys")[2]),
    labels=c("Windows 10", "Windows 8", "Windows 7", "Windows Vista",
             "Windows XP", "Windows 2000", "Windows 98", "Windows 95",
             "Windows 2003", "Windows NT*",
             "Macintosh", "Linux", "Chrome OS", "Mobile"))+
  scale_y_continuous(labels=scales::percent)+
  labs(title="Operating System Market Share",
       subtitle="As reported by w3schools.com",
       x="",
       y="Market Share",
       caption="* after 2012, \"Windows NT\" indicates all Windows Server operating systems (e.g. NT, 2000, 2003, and 2008)")+
  theme_bw()
ggsave("OS Share.png",height=9,width=16,dpi=120,type="cairo-png")