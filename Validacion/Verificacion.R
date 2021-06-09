################################################################################
library(dplyr)
library(lubridate)
library(readxl)
library(ggplot2)
library(verification)
library(gridExtra)

setwd('C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo')

VER = read.csv('VER_ultimo.csv', stringsAsFactors = F,sep=";", header = TRUE,
               check.names = FALSE)

SPIV <- data.frame(val = VER[,16])
SPIG <- data.frame(val = VER[,16])
STWV <- VER[,4:7]
ACCV <- VER[,8:11]
GLMV <- VER[,12:15]

SPIV[which(SPIV[,1] > 0.99),1] <- 3
SPIV[which(SPIV[,1] >= -0.99 & SPIV[,1] <= 0.99),1] <- 2
SPIV[which(SPIV[,1] < -0.99),1] <- 1

SPIG[which(SPIG[,1] > 0),1] <- 1
SPIG[which(SPIG[,1] <= 0),1] <- 0

for (h in 1:ncol(STWV)) {

  
  STWV[which(STWV[,h] > 0.99),h] <- 3
  STWV[which(STWV[,h] >= -0.99 & STWV[,h] <= 0.99),h] <- 2
  STWV[which(STWV[,h] < -0.99),h] <- 1
  
  ACCV[which(ACCV[,h] > 0.99),h] <- 3
  ACCV[which(ACCV[,h] >= -0.99 & ACCV[,h] <= 0.99),h] <- 2
  ACCV[which(ACCV[,h] < -0.99),h] <- 1
  
}

########################################################################################################
########################################################################################################

HSS <- data.frame(hss = matrix(nrow = ncol(STWV), ncol = 4, byrow = TRUE))
PCT <- data.frame(pc = matrix(nrow = ncol(STWV), ncol = 4, byrow = TRUE))
PCC <- data.frame(pc = matrix(nrow = ncol(STWV), ncol = 7, byrow = TRUE))
FAR <- data.frame(far = matrix(nrow = ncol(STWV), ncol = 8, byrow = TRUE))

##  SPI components
for (i in 1:ncol(STWV)) {
  obs  = unlist(SPIV[,1])
  obs3 = unlist(SPIG[,1])
  
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
  FAR[i,7] <- verify(obs3, prd3, frcst.type = "binary", obs.type = "binary" )$FAR
}



MHSS <- colMeans(HSS[,1:3])
MPCT <- colMeans(PCT[,1:3])
MPCC <- colMeans(PCC[,1:6])
MFAR <- colMeans(FAR[,1:7])

Modl <- c('CFSv2','	CanCM4I','GENNEMO','CANSIPv2')

HSS[,4] <- Modl
PCT[,4] <- Modl
PCC[,7] <- Modl
FAR[,8] <- Modl

colnames(HSS) <- c('STP','ACC', 'GLM', 'Mdl')
colnames(PCT) <- c('STP','ACC', 'GLM', 'Mdl')
colnames(PCC) <- c('STP3','STP2','STP1','ACC3','ACC2','ACC1', 'Mdl')
colnames(FAR) <- c('STP3','STP2','STP1','ACC3','ACC2','ACC1', 'GLM', 'Mdl')


HSS$Fix <- factor(HSS$Mdl, level = unique(HSS$Mdl))
PCT$Fix <- factor(PCT$Mdl, level = unique(PCT$Mdl))
PCC$Fix <- factor(PCC$Mdl, level = unique(PCC$Mdl))
FAR$Fix <- factor(FAR$Mdl, level = unique(FAR$Mdl))

#############################################################################################
# PARTE GRAFICA

p1 =  ggplot() +
  geom_line(data = HSS, aes(x = Fix, y = STP, colour = 'STW'), group = 1, linetype="longdash", size = 0.75) +
  geom_line(data = HSS, aes(x = Fix, y = ACC, colour = 'ACC'), group = 1, linetype="longdash", size = 0.75) +
  geom_line(data = HSS, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash", size = 0.75) +
  
  geom_point(data = HSS, aes(x = Fix, y = STP, colour = 'STW'), group = 1, size = 4) +
  geom_point(data = HSS, aes(x = Fix, y = ACC, colour = 'ACC'), group = 1, size = 4) +
  geom_point(data = HSS, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, size = 4) +
  
  geom_hline(yintercept = MHSS[1], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MHSS[2], color = "green4", size = 1.5) +
  geom_hline(yintercept = MHSS[3], color = "firebrick1", size = 1.5) +
  
  scale_color_manual('Leyenda',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4',
                                          'GLM' = 'firebrick1')) +
  
  labs(title = "Heidke Skill Score",
       y = "HSS",
       x = "Estaciones") + theme_bw(base_size = 20)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.x = element_text(color="black", size=17, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"))
p1

ggsave('HSS_EFM21.png', plot = p1, 
       path = 'C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo/Resct',
       width=3.5, height=2, units= "in",dpi= 300,scale=3.5)

p2 =  ggplot() +
  geom_line(data = PCT, aes(x = Fix, y = STP, colour = 'STW'), group = 1, linetype="longdash", size = 0.75) +
  geom_line(data = PCT, aes(x = Fix, y = ACC, colour = 'ACC'), group = 1, linetype="longdash", size = 0.75) +
  geom_line(data = PCT, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash", size = 0.75) +
  
  geom_point(data = PCT, aes(x = Fix, y = STP, colour = 'STW'), group = 1, size = 4) +
  geom_point(data = PCT, aes(x = Fix, y = ACC, colour = 'ACC'), group = 1, size = 4) +
  geom_point(data = PCT, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, size = 4) +
  
  geom_hline(yintercept = MPCT[1], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MPCT[2], color = "green4", size = 1.5) +
  geom_hline(yintercept = MPCT[3], color = "firebrick1", size = 1.5) +
  
  scale_color_manual('Leyenda',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4',
                                          'GLM' = 'firebrick1')) +
  labs(title = "Proporción correcta",
       y = "PC",
       x = "Estaciones") + theme_bw(base_size = 20)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.x = element_text(color="black", size=17, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"))
p2

ggsave('PCT_EFM21.png', plot = p2, 
       path = 'C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo/Resct',
       width=3.5, height=2, units= "in",dpi= 300,scale=3.5)
######################################################################################################

p31 =  ggplot() +
  geom_line(data = PCC, aes(x = Fix, y = STP3, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = PCC, aes(x = Fix, y = ACC3, colour = 'ACC'), group = 1, linetype="longdash") +
  
  geom_point(data = PCC, aes(x = Fix, y = STP3, colour = 'STW'), group = 1, size = 3) +
  geom_point(data = PCC, aes(x = Fix, y = ACC3, colour = 'ACC'), group = 1, size = 3) +

  geom_hline(yintercept = MPCC[1], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MPCC[4], color = "green4", size = 1.5) +
  
  scale_color_manual('Sobre',values = c('STW' = 'dodgerblue', 
                                        'ACC' = 'green4')) +
  labs(title = "Proporción correcta",
       y = "PC") + theme_bw(base_size = 17)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank())

p32 =  ggplot() +
  geom_line(data = PCC, aes(x = Fix, y = STP2, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = PCC, aes(x = Fix, y = ACC2, colour = 'ACC'), group = 1, linetype="longdash") +
  
  geom_point(data = PCC, aes(x = Fix, y = STP2, colour = 'STW'), group = 1, size = 3) +
  geom_point(data = PCC, aes(x = Fix, y = ACC2, colour = 'ACC'), group = 1, size = 3) +
  
  geom_hline(yintercept = MPCC[2], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MPCC[5], color = "green4", size = 1.5) +
  
  scale_color_manual(' Normal',values = c('STW' = 'dodgerblue', 
                                          'ACC' = 'green4')) +
  labs(y = "PC") + theme_bw(base_size = 17)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank())

p33 =  ggplot() +
  geom_line(data = PCC, aes(x = Fix, y = STP1, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = PCC, aes(x = Fix, y = ACC1, colour = 'ACC'), group = 1, linetype="longdash") +
  
  geom_point(data = PCC, aes(x = Fix, y = STP1, colour = 'STW'), group = 1, size = 3) +
  geom_point(data = PCC, aes(x = Fix, y = ACC1, colour = 'ACC'), group = 1, size = 3) +
  
  geom_hline(yintercept = MPCC[3], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MPCC[6], color = "green4", size = 1.5) +
  
  scale_color_manual('Bajo',values = c('STW' = 'dodgerblue', 
                                       'ACC' = 'green4')) +
  labs(y = "PC",
       x = "Estaciones") + theme_bw(base_size = 17)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.x = element_text(color="black", size=17, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"))


p3 = grid.arrange(p31, p32, p33, heights = c(1.1, 1, 1.3), nrow = 3)

ggsave('PCC_EFM21.png', plot = p3, 
       path = 'C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo/Resct',
       width=3.5, height=2, units= "in",dpi= 300,scale=3.5)
########################################################################################################
########################################################################################################

p41 =  ggplot() +
  geom_line(data = FAR, aes(x = Fix, y = STP3, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = ACC3, colour = 'ACC'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash") +
  
  geom_point(data = FAR, aes(x = Fix, y = STP3, colour = 'STW'), group = 1, size = 4) +
  geom_point(data = FAR, aes(x = Fix, y = ACC3, colour = 'ACC'), group = 1, size = 4) +
  geom_point(data = FAR, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, size = 4) +
  
  geom_hline(yintercept = MFAR[1], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MFAR[4], color = "green4", size = 1.5) +
  geom_hline(yintercept = MFAR[7], color = 'firebrick1', size = 1.5) +
  
  scale_color_manual('Sobre',values = c('STW' = 'dodgerblue', 
                                        'ACC' = 'green4',
                                        'GLM' = 'firebrick1')) +
  labs(title = "Falsa alarma",
       y = "FAR") + theme_bw(base_size = 17)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank())

p42 =  ggplot() +
  geom_line(data = FAR, aes(x = Fix, y = STP2, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = ACC2, colour = 'ACC'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash") +
  
  geom_point(data = FAR, aes(x = Fix, y = STP2, colour = 'STW'), group = 1, size = 4) +
  geom_point(data = FAR, aes(x = Fix, y = ACC2, colour = 'ACC'), group = 1, size = 4) +
  geom_point(data = FAR, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, size = 4) +
  
  geom_hline(yintercept = MFAR[2], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MFAR[5], color = "green4", size = 1.5) +
  geom_hline(yintercept = MFAR[7], color = 'firebrick1', size = 1.5) +
  
  scale_color_manual('Normal',values = c('STW' = 'dodgerblue', 
                                         'ACC' = 'green4',
                                         'GLM' = 'firebrick1')) +
  labs(y = "FAR") + theme_bw(base_size = 17)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank())

p43 =  ggplot() +
  geom_line(data = FAR, aes(x = Fix, y = STP1, colour = 'STW'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = ACC1, colour = 'ACC'), group = 1, linetype="longdash") +
  geom_line(data = FAR, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, linetype="longdash") +
  
  geom_point(data = FAR, aes(x = Fix, y = STP1, colour = 'STW'), group = 1, size = 4) +
  geom_point(data = FAR, aes(x = Fix, y = ACC1, colour = 'ACC'), group = 1, size = 4) +
  geom_point(data = FAR, aes(x = Fix, y = GLM, colour = 'GLM'), group = 1, size = 4) +
  
  geom_hline(yintercept = MFAR[3], color = "dodgerblue", size = 1.5) + 
  geom_hline(yintercept = MFAR[6], color = "green4", size = 1.5) +
  geom_hline(yintercept = MFAR[7], color = 'firebrick1', size = 1.5) +
  
  scale_color_manual('Bajo',values = c('STW' = 'dodgerblue', 
                                       'ACC' = 'green4',
                                       'GLM' = 'firebrick1')) +
  labs(y = "FAR",
       x = "Estaciones") + theme_bw(base_size = 17)+ 
  theme(
    plot.title = element_text(color="black", size=24, face="bold"),
    axis.title.x = element_text(color="black", size=17, face="bold"),
    axis.title.y = element_text(color="black", size=17, face="bold"))

p4 = grid.arrange(p41, p42, p43, heights = c(1.1, 1, 1.2), nrow = 3)

ggsave('FAR_EFM21.png', plot = p4, 
       path = 'C:/Users/PATRICIA/Documents/AA-SENAMHI/AA_PRNOSTICO/Trabajo/Resct',
       width=3.5, height=2, units= "in",dpi= 300,scale=3.5)

########################################################################################################
########################################################################################################


#ggsave(filename = paste("Serie_",names[j],".png",sep=""))




