################################################################################
library(dplyr)
library(lubridate)
library(readxl)
library(ggplot2)
library(verification)
library(gridExtra)

setwd('C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo')

SPI <- read_excel("Verificacion.xlsx", sheet = 'SPI')
RCT <- read_excel("Verificacion.xlsx", sheet = 'RCS')
STW <- read_excel("Verificacion.xlsx", sheet = 'STW')
ACC <- read_excel("Verificacion.xlsx", sheet = 'ACC')
GLM <- read_excel("Verificacion.xlsx", sheet = 'GLM')

SPIV <- SPI
RCTV <- RCT
STWV <- STW
ACCV <- ACC
GLMV <- GLM

for (h in 1:ncol(SPI)) {
  SPIV[which(SPIV[,h] > 0.99),h] <- 3
  SPIV[which(SPIV[,h] >= -0.99 & SPIV[,h] <= 0.99),h] <- 2
  SPIV[which(SPIV[,h] < -0.99),h] <- 1
  
  RCTV[which(RCTV[,h] > 0.99),h] <- 3
  RCTV[which(RCTV[,h] >= -0.99 & RCTV[,h] <= 0.99),h] <- 2
  RCTV[which(RCTV[,h] < -0.99),h] <- 1
  
  STWV[which(STWV[,h] > 0.99),h] <- 3
  STWV[which(STWV[,h] >= -0.99 & STWV[,h] <= 0.99),h] <- 2
  STWV[which(STWV[,h] < -0.99),h] <- 1
  
  ACCV[which(ACCV[,h] > 0.99),h] <- 3
  ACCV[which(ACCV[,h] >= -0.99 & ACCV[,h] <= 0.99),h] <- 2
  ACCV[which(ACCV[,h] < -0.99),h] <- 1

}

SPIG <- SPI
for (h in 1:ncol(SPI)) {
  SPIG[which(SPIG[,h] > 0),h] <- 1
  SPIG[which(SPIG[,h] <= 0),h] <- 0
  
  GLMV[which(GLMV[,h] > 0),h] <- 1
  GLMV[which(GLMV[,h] <= 0),h] <- 0
}




HSS <- data.frame(hss = matrix(nrow = ncol(SPI), ncol = 5, byrow = TRUE))
PCT <- data.frame(pc = matrix(nrow = ncol(SPI), ncol = 5, byrow = TRUE))
PCC <- data.frame(pc = matrix(nrow = ncol(SPI), ncol = 8, byrow = TRUE))
FAR <- data.frame(far = matrix(nrow = ncol(SPI), ncol = 9, byrow = TRUE))

##  SPI components
for (i in 1:ncol(SPI)) {
  obs = unlist(SPIV[,i])
  obs3 = unlist(SPIG[,i])
  prd1 = unlist(STWV[,i])
  HSS[i,1] <- verify(obs, prd1, frcst.type = "cat", obs.type = "cat" )$hss
  PCT[i,1] <- verify(obs, prd1, frcst.type = "cat", obs.type = "cat" )$pc
  PCC[i,1:3] <- verify(obs, prd1, frcst.type = "cat", obs.type = "cat" )$pc2
  FAR[i,1:3] <- verify(obs, prd1, frcst.type = "cat", obs.type = "cat" )$false.alarm.ratio
  
  prd2 = unlist(ACCV[,i])
  HSS[i,2] <- verify(obs, prd2, frcst.type = "cat", obs.type = "cat" )$hss
  PCT[i,2] <- verify(obs, prd2, frcst.type = "cat", obs.type = "cat" )$pc
  PCC[i,4:6] <- verify(obs, prd2, frcst.type = "cat", obs.type = "cat" )$pc2
  FAR[i,4:6] <- verify(obs, prd2, frcst.type = "cat", obs.type = "cat" )$false.alarm.ratio
  
  prd3 = unlist(GLMV[,i])
  HSS[i,3] <- verify(obs3, prd3, frcst.type = "binary", obs.type = "binary" )$HSS
  PCT[i,3] <- verify(obs3, prd3, frcst.type = "binary", obs.type = "binary" )$PC
  #PCC[i,7:9] <- verify(obs3, prd3, frcst.type = "binary", obs.type = "binary" )$pc2
  FAR[i,7] <- verify(obs3, prd3, frcst.type = "binary", obs.type = "binary" )$FAR
}

MHSS <- colMeans(HSS[,1:3])
MPCT <- colMeans(PCT[,1:3])
MPCC <- colMeans(PCC[,1:6])
MFAR <- colMeans(FAR[,1:7])

Coor = read.csv("Coord_SPI_SSR82.csv", stringsAsFactors = F,sep=";", 
               header = TRUE, check.names = FALSE)

HSS[,4:5] <- Coor[,c(3,11)]
PCT[,4:5] <- Coor[,c(3,11)]
PCC[,7:8] <- Coor[,c(3,11)]
FAR[,8:9] <- Coor[,c(3,11)]

colnames(HSS) <- c('STP','ACC', 'GLM', 'Est', 'SUB')
colnames(PCT) <- c('STP','ACC', 'GLM', 'Est', 'SUB')
colnames(PCC) <- c('STP3','STP2','STP1','ACC3','ACC2','ACC1', 'Est', 'SUB')
colnames(FAR) <- c('STP3','STP2','STP1','ACC3','ACC2','ACC1', 'GLM', 'Est', 'SUB')


HSS <- HSS[order(HSS$SUB, HSS$Est),]
PCT <- PCT[order(PCT$SUB, PCT$Est),]
PCC <- PCC[order(PCC$SUB, PCC$Est),]
FAR <- FAR[order(FAR$SUB, FAR$Est),]

HSS$Fix <- factor(HSS$Est, level = unique(HSS$Est))
PCT$Fix <- factor(PCT$Est, level = unique(PCT$Est))
PCC$Fix <- factor(PCC$Est, level = unique(PCC$Est))
FAR$Fix <- factor(FAR$Est, level = unique(FAR$Est))

#############################################################################################
# PARTE GRAFICA

p1 =  ggplot() +
  geom_line(data = HSS, aes(x = Fix, y = STP, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = HSS, aes(x = Fix, y = ACC, colour = 'ACC'), group = 1, linetype="longdash") +
  geom_line(data = HSS, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash") +
  
  geom_hline(yintercept = MHSS[1], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MHSS[2], color = "green4", size = 1.5) +
  geom_hline(yintercept = MHSS[3], color = "firebrick1", size = 1.5) +
  
  scale_color_manual('Leyenda',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4',
                                          'GLM' = 'firebrick1')) +
  
  labs(title = "Heidke Skill Score",
       y = "HSS",
       x = "Estaciones") + theme_bw(base_size = 11)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.x = element_text(color="black", size=17, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.text.x = element_text(angle = 90))
p1

ggsave('HSS_Prono.png', plot = p1, 
       path = 'C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo/Resct',
       width=3.5, height=2, units= "in",dpi= 300,scale=3.5)

p2 =  ggplot() +
  geom_line(data = PCT, aes(x = Fix, y = STP, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = PCT, aes(x = Fix, y = ACC, colour = 'ACC'), group = 1, linetype="longdash") +
  geom_line(data = PCT, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash") +
  geom_hline(yintercept = MPCT[1], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MPCT[2], color = "green4", size = 1.5) +
  geom_hline(yintercept = MPCT[3], color = "firebrick1", size = 1.5) +
  
  scale_color_manual('Leyenda',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4',
                                          'GLM' = 'firebrick1')) +
  labs(title = "Proporción correcta",
       y = "PC",
       x = "Estaciones") + theme_bw(base_size = 11)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.x = element_text(color="black", size=17, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.text.x = element_text(angle = 90))
p2

ggsave('PCT_Prono.png', plot = p2, 
       path = 'C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo/Resct',
       width=3.5, height=2, units= "in",dpi= 300,scale=3.5)
######################################################################################################

p31 =  ggplot() +
  geom_line(data = PCC, aes(x = Fix, y = STP3, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = PCC, aes(x = Fix, y = ACC3, colour = 'ACC'), group = 1, linetype="longdash") +

  geom_hline(yintercept = MPCC[1], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MPCC[4], color = "green4", size = 1.5) +
  
  scale_color_manual('Sobre',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4')) +
  labs(title = "Proporción correcta",
       y = "PC") + theme_bw(base_size = 11)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank())
p31


p32 =  ggplot() +
  geom_line(data = PCC, aes(x = Fix, y = STP2, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = PCC, aes(x = Fix, y = ACC2, colour = 'ACC'), group = 1, linetype="longdash") +
  
  geom_hline(yintercept = MPCC[2], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MPCC[5], color = "green4", size = 1.5) +
  
  scale_color_manual(' Normal',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4')) +
  labs(y = "PC") + theme_bw(base_size = 11)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank())
p32

p33 =  ggplot() +
  geom_line(data = PCC, aes(x = Fix, y = STP1, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = PCC, aes(x = Fix, y = ACC1, colour = 'ACC'), group = 1, linetype="longdash") +
  
  geom_hline(yintercept = MPCC[3], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MPCC[6], color = "green4", size = 1.5) +
  
  scale_color_manual('Bajo',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4')) +
  labs(y = "PC",
       x = "Estaciones") + theme_bw(base_size = 11)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.x = element_text(color="black", size=17, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.text.x = element_text(angle = 90))
p33

p3 = grid.arrange(p31, p32, p33, heights = c(1.1, 0.9, 1.5), nrow = 3)

ggsave('PCC_Prono.png', plot = p3, 
       path = 'C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo/Resct',
       width=3.5, height=2, units= "in",dpi= 300,scale=3.5)
########################################################################################################
########################################################################################################

p41 =  ggplot() +
  geom_line(data = FAR, aes(x = Fix, y = STP3, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = ACC3, colour = 'ACC'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash") +
  
  geom_hline(yintercept = MFAR[1], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MFAR[4], color = "green4", size = 1.5) +
  geom_hline(yintercept = MFAR[7], color = 'firebrick1', size = 1.5) +
  
  scale_color_manual('Sobre',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4',
                                          'GLM' = 'firebrick1')) +
  labs(title = "Falsa alarma",
       y = "FAR") + theme_bw(base_size = 11)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank())

p42 =  ggplot() +
  geom_line(data = FAR, aes(x = Fix, y = STP2, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = ACC2, colour = 'ACC'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash") +
  
  geom_hline(yintercept = MFAR[2], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MFAR[5], color = "green4", size = 1.5) +
  geom_hline(yintercept = MFAR[7], color = 'firebrick1', size = 1.5) +
  
  scale_color_manual('Normal',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4',
                                          'GLM' = 'firebrick1')) +
  labs(y = "FAR") + theme_bw(base_size = 11)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank())

p43 =  ggplot() +
  geom_line(data = FAR, aes(x = Fix, y = STP1, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = ACC1, colour = 'ACC'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash") +
  
  geom_hline(yintercept = MFAR[3], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MFAR[6], color = "green4", size = 1.5) +
  geom_hline(yintercept = MFAR[7], color = 'firebrick1', size = 1.5) +
  
  scale_color_manual('Bajo',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4',
                                          'GLM' = 'firebrick1')) +
  labs(y = "FAR",
       x = "Estaciones") + theme_bw(base_size = 11)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.x = element_text(color="black", size=17, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.text.x = element_text(angle = 90))

p4 = grid.arrange(p41, p42, p43, heights = c(1.1, 0.9, 1.5), nrow = 3)

ggsave('FAR_Prono.png', plot = p4, 
       path = 'C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo/Resct',
       width=3.5, height=2, units= "in",dpi= 300,scale=3.5)

########################################################################################################
########################################################################################################


#ggsave(filename = paste("Serie_",names[j],".png",sep=""))




