setwd(dirname(rstudioapi::getSourceEditorContext()$path))

library(tidyverse)
library(igraph)

# read in titles' metadata
title.basics = read_tsv("data/title.basics.tsv.gz",na="\\N",quote="")

# filter out just movies
# keep.titles =
#   title.basics %>%
#   # filter(titleType %in% c("movie","tvMovie") & !isAdult) %>%
#   filter(titleType=="movie" & !isAdult) %>%
#   pull(tconst)
# 
# # read in principals data and convert columns
# principals =
#   read_tsv("data/title.principals.tsv.gz",na="\\N",quote="") %>%
#   select(-c(ordering,job,characters)) %>%
#   filter(category %in% c("self","actor","actress") & tconst %in% keep.titles) %>%
#   select(-category) %>%
#   distinct
# 
# # get title names
# title.names =
#   title.basics %>%
#   filter(tconst %in% principals$tconst) %>%
#   pull(primaryTitle,name=tconst)
# 
# # read in actors' metadata and get actor names
# actor.names =
#   read_tsv("data/name.basics.tsv.gz",na="\\N",quote="")[,1:2] %>%
#   filter(nconst %in% principals$nconst) %>%
#   pull(primaryName,name=nconst)
# 
# # remove since no longer needed
# rm(title.basics,keep.titles)

# save objects to be easily loaded
save(list=ls(),file="data/principals+names.Rdata.xz",compress="xz",compression_level=9)

# load file and check size
load("data/principals+names.Rdata")

# get title and actor counts (how many actors/titles were associated with a particular title/actor)
actor.counts = principals %>% group_by(tconst) %>% summarise(n=n()) %>% pull(n,name=tconst)
title.counts = principals %>% group_by(nconst) %>% summarise(n=n()) %>% pull(n,name=nconst)

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

# get actors in this component, to subset principals
sub.names = V(imdb2) %>% names

principals = 
  principals %>% 
  filter(nconst %in% sub.names)

title.names %>% 
  enframe %>% 
  filter(name %in% principals$tconst) %>% 
  pull(value,name=name) ->
  title.names

actor.names %>% 
  enframe %>% 
  filter(name %in% principals$nconst) %>% 
  pull(value,name=name) ->
  actor.names

# save largest connected subcomponent
save(principals,actor.names,title.names,
     file="data/principals+names.Rdata.xz",compress="xz",compression_level=9)

# get title language information
title.akas = read_tsv("data/title.akas.tsv.gz",na="\\N",quote="")

title.akas %>%
  filter(titleId %in% names(title.names)) %>%
  group_by(titleId) %>%
  slice_max(isOriginalTitle,n=1)

# #Degrees of separation of every actor from Kevin Bacon (nm0000102)
# separation = distances(imdb2, v = "nm0000102")
# 
# # #Percent of actors who are connected with Kevin bacon
# # print(sum(is.finite(degrees_separation))/length(degrees_separation))
# 
# #See distribution of degrees of separation
# table(separation)
# 
# #Get all actors one degree away from Bacon
# oneAway = colnames(separation)[separation]
# 
# #Use this to look up someone's degrees of separation from Bacon
# #print(degrees_separation[which(colnames(degrees_separation)=="nm0000102")])
# 
# # 
# # actorList = list()
# # actorMean = list()
# # 
# # #Calculate every one of these actor's mean degrees of separation
# # 
# # for (i in 1:length(oneAway)) {
# #   deg_sep=distances(imdb, v = oneAway[i])
# #   actorList[[i]]=oneAway[i]
# #   # print(sum(is.finite(deg_sep))/length(deg_sep))
# #   #print(as.data.frame(table(deg_sep)))
# #   deg = deg_sep[is.finite(deg_sep)]
# #   actorMean[[i]]=mean(deg)
# # }
# # df = data.frame(matrix(unlist(actorMean), nrow=231, byrow=T),stringsAsFactors=FALSE)
# # df$actor = unlist(actorList)
# # colnames(df)[1] = "mean"
# # avgDegrees=df[order(df$mean),]
# 
# 
# # More efficient way of calculating above:
# getMeanSep = function(person){
#   mean(distances(imdb2, v=person))
# }
# 
# mean.degrees = sapply(oneAway,getMeanSep)
# mean.degrees %>% 
#   enframe(name="actor.id",value="mean.degree") %>% 
#   mutate(actor.name=actor.names[actor.id]) %>% 
#   select(mean.degree,actor.name,actor.id)
