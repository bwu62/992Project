if(!require(pacman)){
  install.packages("pacman")
} else pacman::p_load(tidyverse,igraph,ggplot2,scales)

# load data
load("data/principals+names.Rdata.xz")

# make graph (this should just be the largest connected component now)
imdb = full_join(principals,principals,c('tconst'='tconst'))[,c(2,3,1)] %>%
  filter(nconst.x!=nconst.y) %>%
  graph_from_data_frame(directed=F)

# also get simplified version (no multiple edges, no attributes)
imdb.simple = simplify(imdb)

imdb.cliques = largest.cliques(imdb.simple)

