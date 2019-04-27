library('ggplot2')
library('reshape')
library('Cairo')
library("grid")
library("plyr")
library("dostats")
library("abind")

plottitle <- "Szó keresése szövegben"
xlabel <- "Megvizsgált bájtok (tízezer)"
ylabel <- "Idő(s)"

files <- list.files(path = "results/", pattern = "*.dat")
data <- NULL

for (i in seq_along(files)) {
    temp <- read.table(paste("results/", files[i], sep=""))

    if (i == 1) {
        data <- cbind(data, "00"=temp$V2)
    }

    data <- cbind(data, temp$V1)

    coln <- tools::file_path_sans_ext(files[i])
    if (nchar(coln) == 1) {
        coln <- paste("0", coln, sep="")
    }

    colnames(data)[i+1] <- coln
}

data <- data[,order(colnames(data))]
colnames(data)[1] = "bytes"

plotlabels <- paste(colnames(data[,-1]), "szál")

data <- data.frame(data)
data <- melt(data, id='bytes', variable_name='series')

cairo_ps("graph.eps", width=20, height=8)  
p<-ggplot(data, 
  aes_string(x=names(data)[1], y=names(data)[3], colour=names(data)[2]), 
  labeller=label_parsed) + 
  geom_point(size=4) + 
  geom_line(size=1.5) + 
  labs(title=plottitle) + 
  xlab(xlabel) + 
  ylab(ylabel) + 
  scale_colour_manual(values=rainbow(length(files)), name="", labels=plotlabels, guide=guide_legend(keyheight=unit(2, "line"), keywidth=unit(5, "line"))) +
  theme_gray(24) +
  scale_x_continuous(breaks=seq(0, max(data$bytes), max(data$bytes)/20), labels=c(round(seq(0, max(data$bytes)/10000, max(data$bytes)/200000)))) +
  scale_y_continuous(breaks=sort(c(round(seq(0, max(data$value)+1, by=0.5), 1)))) +
  theme(legend.position="bottom")

print(p)
dev.off()