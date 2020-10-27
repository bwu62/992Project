if(!require(pacman)){
  install.packages("pacman")
} else pacman::p_load(tidyverse,igraph,ggplot2,scales)

# load data
load("data/principals+names.Rdata.xz")

# make graph (this should just be the largest connected component now)
imdb = full_join(principals,principals,c('tconst'='tconst'))[,c(2,3,1)] %>%
  filter(nconst.x!=nconst.y) %>%
  graph_from_data_frame(directed=F)

# get bacon's id and degrees and tabulate
bacon = actor.names[actor.names=="Kevin Bacon"]
bacon.degrees = distances(imdb, v=names(bacon))[1,] %>% sort(decreasing=F)
bacon.table = 
  bacon.degrees %>% 
  table %>% 
  enframe(name="degree",value="count") %>% 
  mutate(degree=as.numeric(degree)) %>% 
  filter(degree>0)

# disable scientific notation
options(scipen=1e9)

# plot degrees
ggplot(bacon.table, aes(x=degree,y=count)) + geom_col(width=.95) + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=","))) + 
  scale_x_continuous(breaks=1:11) + 
  labs(title="Distribution of Bacon numbers",x="Degrees away from Kevin Bacon",y="Frequency")
ggsave("plots/bacon.png",width=6,height=4)

# get nearby actors to check for lower means
neighbors = names(bacon.degrees[bacon.degrees<=2])

# check mean degrees of these neighbors
getMeanDegrees = function(person){
  mean(distances(imdb,v=person))
}

# neighbors.degrees = sapply(neighbors,getMeanDegrees)

# # evaluate mean degrees in parallel for all actors <= 2 away
# library(parallel)
# library(benchmarkme)
# library(pryr)
# 
# gc()
# cores = min( detectCores(), as.numeric(floor(0.55*get_ram() / mem_used())) ) - 1
# cl = makeCluster(cores)
# clusterEvalQ(cl,library(igraph))
# clusterExport(cl,list("imdb","neighbors","getMeanDegrees"))
# system.time({
#   neighbors.degrees = 
#     parSapply(cl,neighbors,getMeanDegrees) %>% 
#     sort %>% 
#     enframe(name="actor.id",value="mean.degree") %>%
#     mutate(actor.name=actor.names[actor.id]) %>%
#     select(mean.degree,actor.name,actor.id)
# })
# stopCluster(cl)
# gc()
# save(neighbors.degrees,file="data/neighbors.Rdata.xz",compression_level=9)

load("data/neighbors.Rdata.xz")
neighbors.degrees

# highest so far is Eric Roberts (nm0000616, NOT nm0731082 (less famous guy of same name))

roberts = 
  neighbors.degrees %>% 
  slice_min(mean.degree,n=1) %>% 
  pull(actor.name,name=actor.id)

roberts.degrees = distances(graph=imdb,v=names(roberts))[1,]
roberts.table = 
  roberts.degrees %>% table %>% 
  enframe(name="degree",value="count") %>% 
  mutate(degree=as.numeric(degree)) %>% 
  filter(degree>0)

ggplot(roberts.table,aes(x=degree,y=count)) + geom_col(width=.95) + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=","))) + 
  scale_x_continuous(breaks=1:11) + 
  labs(title=paste0("Distribution of ",sub(".* ","",names(central.actor))," numbers"),
       x=paste0("Degrees away from ",names(central.actor)),y="Frequency")

ggsave(paste0("plots/",sub(".* ","",tolower(names(central.actor))),".png"),width=6,height=4)

cbind(bacon.table %>% rename(Bacon=count),
      roberts.table %>% rename(Roberts=count) %>% select(Roberts)) %>% 
  gather(key="Actor",value="Frequency",2:3) %>% 
  ggplot(aes(x=degree,y=Frequency,fill=Actor)) + geom_col(position="dodge",width=.75) + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=","))) + 
  scale_x_continuous(breaks=1:11) + scale_fill_manual(values=c('#e66101','#5e3c99')) + 
  labs(title="Mean degree comparison of Kevin Bacon and Eric Roberts",x="Degrees away",y="Frequency")
ggsave("plots/bacon-roberts.png",width=6,height=4)

