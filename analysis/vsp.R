if(!require(pacman)){
  install.packages("pacman")
} else pacman::p_load(tidyverse,igraph,ggplot2,scales)

# load data
load("data/principals+names.Rdata.xz")