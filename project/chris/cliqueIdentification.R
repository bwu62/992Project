setwd("project/chris/")
# check pacman is installed
if(!require(pacman)) install.packages("pacman")

# use pacman to install/load most packages
pacman::p_load(Matrix,igraph,tidyverse,ggplot2,scales)

# use older (forked) version of vsp due to bug in most recent version
#pacman::p_load_gh("bwu62/vsp")

# load the compressed binary file
load("../eng_principals2+names.Rdata")

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
ATA = t(imdb.incidence.eng) %*% imdb.incidence.eng

#Create graph from actor adjacency matrix
actor.graph = graph_from_adjacency_matrix(ATA, mode = c("directed", "undirected",
                                                             "max", "min", "upper", "lower", "plus"), weighted = NULL,
                                         diag = TRUE, add.colnames = NULL, add.rownames = NA)

#Every actor's degrees of seperation of every actor from Eric Roberts (nm0000616)
degrees.from.roberts<-as.data.frame(t(distances(actor.graph, v = "nm0000616")))

#Change column name
colnames(degrees.from.roberts)<-c("DegreesFromRoberts")

#Create graph from movie adjacency matrix
movie.graph = graph_from_adjacency_matrix(AAT, mode = c("directed", "undirected",
                                                       "max", "min", "upper", "lower", "plus"), weighted = NULL,
                                         diag = TRUE, add.colnames = NULL, add.rownames = NA)

#Every actor's degrees of seperation of every actor from 12 Angry Men (tt0050083)
degrees.from.tam<-as.data.frame(distances(movie.graph, v = "tt0050083"))

#Every actor's degrees
actor.degrees<-as.data.frame(degree(actor.graph, v = V(actor.graph), mode = c("all", "out", "in", "total"),
       loops = TRUE, normalized = FALSE))

colnames(actor.degrees)<-c("degrees")
actor.degrees$degress.from.roberts <- degrees.from.roberts$DegreesFromRoberts

#Ever actor's coreness
actor.coreness<- as.data.frame(coreness(actor.graph, mode = "all"))
colnames(actor.coreness)<-c("coreness")

actor.degrees$coreness <- actor.coreness$coreness



