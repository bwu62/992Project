library(tidyverse)
library(igraph)

# # read in titles' metadata
# keep.titles = 
#   read_tsv("data/title.basics.tsv.gz",na="\\N",quote="") %>% 
#   filter(titleType %in% c("movie","tvMovie") & !isAdult) %>% 
#   pull(tconst)
# 
# # read in data and convert columns
# principals =
#   read_tsv("data/title.principals.tsv.gz",na="\\N",quote="") %>%
#   select(-c(ordering,job,characters)) %>%
#   filter(category %in% c("self","actor","actress") & tconst %in% keep.titles) %>%
#   select(-category) %>%
#   distinct
# 
# # save result ot be easily loaded
# save(principals,file="data/principals.Rdata.xz",compress="xz",compression_level=9)

# load file
load("data/principals.Rdata.xz")

# check size
print(object.size(principals),units="Mb")

# # create graph using naive (i.e. slow) method since I can't figure out how to optimize it
# imdb = full_join(principals,principals,c('tconst'='tconst'))[,c(2,3,1)] %>%
#   filter(nconst.x!=nconst.y) %>%
#   graph_from_data_frame(directed=F)

