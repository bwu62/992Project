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

# get bacon's id and degrees and tabulate
bacon = actor.names[actor.names=="Kevin Bacon"]
bacon.degrees = distances(imdb, v=names(bacon))[1,] %>% sort(decreasing=F)
bacon.table = 
  bacon.degrees %>% 
  table %>% 
  enframe(name="degree",value="count") %>% 
  mutate(degree=as.numeric(degree))

# disable scientific notation
options(scipen=1e9)

# plot degrees
ggplot(bacon.table %>% filter(degree>0), aes(x=degree,y=count)) + geom_col(width=.95) + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=","))) + 
  scale_x_continuous(breaks=1:11) + 
  labs(title="Distribution of Bacon numbers",x="Degrees away from Kevin Bacon",y="Frequency")
# ggsave("plots/bacon.png",width=6,height=4)



# # check other actors; take top 5000 most-titled actors
# top.names = 
#   title.counts %>% 
#   sort(decreasing=T) %>% 
#   head(n=5000) %>% 
#   names
# 
# # check mean degrees of these top actors
# getMeanDegrees = function(person){
#   mean(distances(imdb.simple,v=person))
# }
# 
# # evaluate mean degrees in parallel for all actors <= 2 away
# library(parallel)
# 
# gc()
# cores = detectCores()-1
# cl = makeCluster(cores)
# clusterEvalQ(cl,library(igraph))
# clusterExport(cl,list("imdb.simple","top.names","getMeanDegrees"))
# top.means = parSapply(cl,top.names,getMeanDegrees)
# stopCluster(cl)
# gc()
# 
# top.means = top.means %>% 
#   sort %>% 
#   enframe(name="actor.id",value="mean.degree") %>% 
#   mutate(actor.name=actor.names[actor.id]) %>% 
#   select(mean.degree,actor.name,actor.id)
# 
# save(top.means,file="data/top.means.Rdata.xz",compression_level=9)



load("data/top.means.Rdata.xz")
top.means

# highest so far is Eric Roberts (nm0000616, NOT nm0731082 (less famous guy of same name))
roberts = 
  top.means %>% 
  slice_min(mean.degree,n=1) %>% 
  pull(actor.name,name=actor.id)

roberts.degrees = distances(graph=imdb,v=names(roberts))[1,]
roberts.table = 
  roberts.degrees %>% table %>% 
  enframe(name="degree",value="count") %>% 
  mutate(degree=as.numeric(degree))

ggplot(roberts.table %>% filter(degree>0),aes(x=degree,y=count)) + geom_col(width=.95) + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=","))) + 
  scale_x_continuous(breaks=1:11) + 
  labs(title="Distribution of Roberts numbers",
       x="Degrees away from Eric Roberts",y="Frequency")
# ggsave(paste0("plots/roberts.png"),width=6,height=4)

cbind(bacon.table %>% rename(Bacon=count),
      roberts.table %>% rename(Roberts=count) %>% select(Roberts)) %>% 
  filter(degree>0) %>% 
  gather(key="Actor",value="Frequency",2:3) %>% 
  ggplot(aes(x=degree,y=Frequency,fill=Actor)) + geom_col(position="dodge",width=.75) + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=","))) + 
  scale_x_continuous(breaks=1:11) + scale_fill_manual(values=c('#e66101','#5e3c99')) + 
  labs(title="Mean degree comparison of Kevin Bacon and Eric Roberts",x="Degrees away",y="Frequency")
# ggsave("plots/bacon-roberts.png",width=6,height=4)

