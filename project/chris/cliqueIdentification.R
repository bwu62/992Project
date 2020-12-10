setwd("project/chris/")
# check pacman is installed
if(!require(pacman)) install.packages("pacman")

# use pacman to install/load most packages
pacman::p_load(Matrix,igraph,tidyverse,ggplot2,scales)

# use older (forked) version of vsp due to bug in most recent version
pacman::p_load_gh("bwu62/vsp")

# load the compressed binary file
load("../eng_principals2+names.Rdata")
load("fa2.clusters.Rdata")
fa2.clusters<- as.data.frame(fa2.clusters)
# check loaded files
ls()



imdb.incidence.eng = 
  principals2.eng %>% 
  mutate(tconst=as.numeric(factor(tconst,ordered=T,levels=names(title.names.eng))),
         nconst=as.numeric(factor(nconst,ordered=T,levels=names(actor.names.eng))),
         value=1) %>% 
  with(.,sparseMatrix(i=tconst,j=nconst,x=value,dimnames=list(names(title.names.eng),names(actor.names.eng))))


# get title by title projected adjacency matrix
AAT = imdb.incidence.eng %*% t(imdb.incidence.eng)

# get actor by actor projected adjacency matrix
# ATA = t(imdb.incidence.eng) %*% imdb.incidence.eng

#Create graph from actor adjacency matrix
#actor.graph = graph_from_adjacency_matrix(ATA, mode = c("directed", "undirected",
                                                            # "max", "min", "upper", "lower", "plus"), weighted = NULL,
                                        # diag = TRUE, add.colnames = NULL, add.rownames = NA)

#Every actor's degrees of seperation of every actor from Eric Roberts (nm0000616)
#degrees.from.roberts<-as.data.frame(t(distances(actor.graph, v = "nm0000616")))

# #Change column name
# colnames(degrees.from.roberts)<-c("DegreesFromRoberts")

#Create graph from movie adjacency matrix
movie.graph = graph_from_adjacency_matrix(AAT, mode = c("directed", "undirected",
                                                       "max", "min", "upper", "lower", "plus"), weighted = NULL,
                                         diag = TRUE, add.colnames = NULL, add.rownames = NA)

#Every movie's degrees of seperation of every actor from 12 Angry Men (tt0050083)
degrees.from.tam<-as.data.frame(t(distances(movie.graph, v = "tt0050083")))
#Change column name
colnames(degrees.from.tam)<-c("DegreesFromTam")

#Every actor's degrees
actor.degrees<-as.data.frame(degree(actor.graph, v = V(actor.graph), mode = c("all", "out", "in", "total"),
       loops = TRUE, normalized = FALSE))

colnames(actor.degrees)<-c("degrees")
actor.degrees$degress.from.roberts <- degrees.from.roberts$DegreesFromRoberts

#Every actor's coreness
actor.coreness<- as.data.frame(coreness(actor.graph, mode = "all"))
colnames(actor.coreness)<-c("coreness")

actor.degrees$coreness <- actor.coreness$coreness

#Every movie's degrees
movie.degrees<-as.data.frame(degree(movie.graph, v = V(movie.graph), mode = c("all", "out", "in", "total"),
                                    loops = TRUE, normalized = FALSE))

colnames(movie.degrees)<-c("degrees")
movie.degrees$degress.from.tam <- degrees.from.tam$DegreesFromTam

#Every movie's coreness
movie.coreness<- as.data.frame(coreness(movie.graph, mode = "all"))
colnames(movie.coreness)<-c("coreness")

movie.degrees$coreness <- movie.coreness$coreness
movie.degrees$cluster <- fa2.clusters$cluster
movie.degrees$cluster.value <- fa2.clusters$value

write.csv(movie.degrees, "movie.statistics.csv")

#MODELING DONE IN PYTHON

non.cliques<-read.csv("pred_non_clique_titles.csv")[[2]]

imdb.incidence.new <- imdb.incidence.eng[non.cliques,]
fa.new = vsp(imdb.incidence.new,k=100)
plot(fa.new$d)
fa.new = vsp(imdb.incidence.new,k=12)

pacman::p_load(ggdark)

apply(fa.new$Z,1,which.max) %>% 
  table %>% 
  enframe(name="Cluster",value="Count") %>% 
  mutate(Cluster=as.numeric(Cluster)) %>% 
  ggplot(aes(x=Cluster,y=Count)) + geom_col(position="dodge",width=0.9,fill="darkorange1") + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=",")),
                limits=c(1,1e5),expand=c(0,0)) + 
  annotation_logticks(sides="l",color="grey") + 
  scale_x_continuous(breaks=1:10,labels=1:10,expand=c(.025,0)) + 
  labs(title=sprintf("Cluster sizes after subsetting (Gini index: %.3f)",
                     Gini(table(apply(fa.new$Z,1,which.max))))) +  
  ggdark::dark_mode(theme_minimal()) + theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color="grey",size=.05),
    panel.grid.minor.y = element_blank(),
    panel.background = element_rect(fill="transparent",colour=NA),
    plot.background = element_rect(fill="transparent",colour=NA)
  )
ggsave("cliques.eps",width=5.5,height=4,bg="transparent")

pacman::p_load(DescTools)
Gini(table(apply(fa.new$Z,1,which.max)))

# select best features
fa.new.bff = bff(fa.new$Y,t(imdb.incidence.new),num_best=10)
fa.new.bff

# view titles for these features
fa.new.titles = fa.new.bff %>% 
  apply(2, function(x)sapply(x,function(i)title.names.eng[which(i==names(title.names.eng))]))
fa.new.titles

# add Markdown-formatted links to titles so viewer can click on titles to get to movie page on imdb
# these must be saved in a .md file and viewed or converted with a tool that understands Markdown
# GitHub renders .md files natively (this page you're reading right now is actually written in .md)
# Rstudio will also knit .md to html for you if you want to test locally
fa.new.links = fa.new.bff %>% 
  apply(2, function(x){
    sapply(x,function(i){
      sprintf("[%s](https://www.imdb.com/title/%s)",title.names.eng[which(i==names(title.names.eng))],i)
    })
  })

# print links; the output of these lines can be copied into your .md files directly
for(i in 1:ncol(fa.new.links)){
  cat("Group ",i,":\n")
  cat(paste(fa.new.links[,i],collapse='\n'),'\n\n')
}

fa.new.list = lapply(fa.new.links %>% data.frame, . %>% paste(.,collapse=", "))
save(fa.new.list,file="fa.new.list.Rdata",compression_level=9)
