setwd(dirname(rstudioapi::getSourceEditorContext()$path))

if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse,igraph,ggplot2,scales,Matrix,vsp,magrittr)

# load data
load("data/principals+names.Rdata")

# make graph (this should just be the largest connected component now)
imdb = full_join(principals,principals,c('tconst'='tconst'))[,c(2,3,1)] %>%
  filter(nconst.x!=nconst.y) %>%
  graph_from_data_frame(directed=F)

# also get simplified version (no multiple edges, no attributes)
imdb.simple = simplify(imdb)

# convert multiple edges to weights
imdb.simple.weighted = imdb
E(imdb.simple.weighted)$weight = 1
imdb.simple.weighted = simplify(imdb.simple.weighted,
                                edge.attr.comb=list(weight="sum",tconst="ignore"))

# imdb.cliques = largest.cliques(imdb.simple)

t.names = unique(principals$tconst)
n.names = unique(principals$nconst)
imdb.incidence = 
  principals %>% 
  mutate(tconst=as.numeric(factor(tconst,ordered=T,levels=t.names)),
         nconst=as.numeric(factor(nconst,ordered=T,levels=n.names)),
         value=1) %>% 
  with(.,sparseMatrix(i=tconst,j=nconst,x=value,dimnames=list(t.names,n.names)))

str(imdb.incidence)
setNames(dim(imdb.incidence),c("titles","actors"))

fa = vsp(imdb.incidence,k=20)

# fa$Z %>% 
#   apply(2, function(x)title.names[t.names[which(rank(-x,ties.method="random") <= 10)]])

fa1.bff = bff(fa$Y,t(imdb.incidence),10)

fa1.titles = fa1.bff %>% 
  apply(2, function(x)sapply(x,function(i)title.names[which(i==names(title.names))]))

fa1.links = fa1.bff %>% 
  apply(2, function(x)sapply(x,function(i){
    sprintf("[%s](https://www.imdb.com/title/%s)",title.names[which(i==names(title.names))],i)
  }))

# save(fa1.titles,file="content/assets/data/fa1.titles.Rdata",compression_level=9)

# bff(fa$Z,imdb.incidence,10) %>% 
#   apply(2, function(x)sapply(x,function(i)actor.names[which(i==names(actor.names))]))



# load country/language data
load("data/region.Rdata")
# eng.titles = CL[which(!is.na(str_match(CL[[2]],"USA")) | !is.na(str_match(CL[[3]],"English"))),1]
eng.titles = CL %>% filter(grepl("USA",country) & (is.na(language) | language=="English")) %>% pull(tconst)

# # also remove tvmovies, since seems like a lot of junk
# keep.titles.2 = read_tsv("data/title.basics.tsv.gz",na="\\N",quote="",
#                          col_types=cols(
#                            tconst = col_character(),
#                            titleType = col_character(),
#                            primaryTitle = col_character(),
#                            originalTitle = col_character(),
#                            isAdult = col_double(),
#                            startYear = col_double(),
#                            endYear = col_double(),
#                            runtimeMinutes = col_double(),
#                            genres = col_character()
#                          )) %>%
#   filter(titleType=="movie" & !isAdult) %>%
#   pull(tconst)
# 
# principals2.eng = principals %>% filter(tconst %in% eng.titles & tconst %in% keep.titles.2)
# save(principals2.eng,file="data/principals2.eng.Rdata",compression_level=9)

load("data/principals2.eng.Rdata")

# use new filter from above
principals2.eng %<>% filter(tconst %in% eng.titles)

t.names.eng = unique(principals2.eng$tconst)
n.names.eng = unique(principals2.eng$nconst)
imdb.incidence.eng = 
  principals2.eng %>% 
  mutate(tconst=as.numeric(factor(tconst,ordered=T,levels=t.names.eng)),
         nconst=as.numeric(factor(nconst,ordered=T,levels=n.names.eng)),
         value=1) %>% 
  with(.,sparseMatrix(i=tconst,j=nconst,x=value,dimnames=list(t.names.eng,n.names.eng)))

str(imdb.incidence.eng)
setNames(dim(imdb.incidence.eng),c("titles","actors"))

# big jumps after k=2,5,8 small jump after k=12,19
fa.eng = vsp(imdb.incidence.eng,k=100)
plot(fa.eng$d)

fa.eng = vsp(imdb.incidence.eng,k=8)

# fa.eng$Z %>% 
#   apply(2, function(x)title.names[t.names[which(rank(-x,ties.method="random") <= 10)]])

apply(fa.eng$Y,1,which.max) %>% 
  table %>% 
  enframe(name="Cluster",value="Count") %>% 
  mutate(Cluster=as.numeric(Cluster)) %>% 
  ggplot(aes(x=Cluster,y=Count)) + geom_col(position="dodge",width=0.9,fill="darkorange1") + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=",")),expand=c(0,0)) + 
  scale_x_continuous(breaks=1:8,expand=c(0,0)) + labs(title="Cluster sizes") +
  theme_minimal() + theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color="black",size=.05),
    panel.grid.minor.y = element_line(color="black",size=.03),
    panel.background = element_rect(fill="transparent",colour=NA),
    plot.background = element_rect(fill="transparent",colour=NA)
  )
ggsave("../docs/cliques.svg",width=5.5,height=4,bg="transparent")

fa2.bff = bff(fa.eng$Y,t(imdb.incidence.eng),10)

fa2.titles = fa2.bff %>% 
  apply(2, function(x)sapply(x,function(i)title.names[which(i==names(title.names))]))

fa2.links = fa2.bff %>% 
  apply(2, function(x)sapply(x,function(i){
    sprintf("[%s](https://www.imdb.com/title/%s)",title.names[which(i==names(title.names))],i)
  }))

# bff(fa.eng$Z,imdb.incidence.eng,10) %>% 
#   apply(2, function(x)sapply(x,function(i)actor.names[which(i==names(actor.names))]))

fa1.list = lapply(fa1.links%>%data.frame, .%>%paste(.,collapse=", "))
fa2.list = lapply(fa2.links%>%data.frame, .%>%paste(.,collapse=", "))

save(fa1.list,fa2.list,file="content/assets/data/fa.lists.Rdata")
