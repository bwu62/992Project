library(tidyverse)
library(igraph)

# read in titles' metadata
title.basics = read_tsv("data/title.basics.tsv.gz",na="\\N",quote="")

# filter out just movies
keep.titles =
  title.basics %>%
  filter(titleType %in% c("movie","tvMovie") & !isAdult) %>%
  pull(tconst)

# get title names
title.names =
  title.basics %>% 
  pull(primaryTitle,name=tconst)

# remove since no longer needed
rm(title.basics)

# read in actors' metadata and get actor names
actor.names = 
  read_tsv("data/name.basics.tsv.gz",na="\\N",quote="")[,1:2] %>% 
  pull(primaryName,name=nconst)

# read in principals data and convert columns
principals =
  read_tsv("data/title.principals.tsv.gz",na="\\N",quote="") %>% 
  select(-c(ordering,job,characters)) %>% 
  filter(category %in% c("self","actor","actress") & tconst %in% keep.titles) %>% 
  select(-category) %>% 
  distinct

# save previous objects to be easily loaded
save(ls(),file="data/savedObjects.Rdata.xz",compress="xz",compression_level=9)

# load file and check size
load("data/principals.Rdata.xz")
print(object.size(principals),units="Mb")

# get title and actor counts (how many actors/titles were associated with a particular title/actor)
actor.counts = principals %>% group_by(tconst) %>% summarise(n=n()) %>% pull(n,name=tconst)
title.counts = principals %>% group_by(nconst) %>% summarise(n=n()) %>% pull(n,name=nconst)

# karl said this makes a very dense graph and we might be able to work with
# just principals and create a bipartite graph (see readme and meeting post)
# create graph using naive (i.e. slow) method since I can't figure out how to optimize it
imdb = full_join(principals,principals,c('tconst'='tconst'))[,c(2,3,1)] %>%
  filter(nconst.x!=nconst.y) %>%
  graph_from_data_frame(directed=F)

# get k-coreness from graph
coreness(imdb) %>% 
  enframe %>% 
  slice_max(value,n=10)

# is graph connected?
is_connected(imdb)

# show connected components, ordered by size
imdb.comp = components(imdb)
head(sort(imdb.comp$csize,decreasing=T),10)

# subset the largest connected component
imdb.comp$membership[imdb.comp$membership == 1]
imdb2 = induced_subgraph(imdb,names(imdb.comp$membership[imdb.comp$membership == 1]))

