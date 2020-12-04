setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# check pacman is installed
if(!require(pacman)) install.packages("pacman")

# use pacman to install/load most packages
pacman::p_load(Matrix,igraph,tidyverse,ggplot2,scales,DescTools)

# use older (forked) version of vsp due to bug in most recent version
pacman::p_load_gh("bwu62/vsp")

load("../eng_principals2+names.Rdata")

imdb.incidence.eng = 
  principals2.eng %>% 
  mutate(tconst=as.numeric(factor(tconst,ordered=T,levels=names(title.names.eng))),
         nconst=as.numeric(factor(nconst,ordered=T,levels=names(actor.names.eng))),
         value=1) %>% 
  with(.,sparseMatrix(i=tconst,j=nconst,x=value,dimnames=list(names(title.names.eng),names(actor.names.eng))))

# get projected matrix
AAT = imdb.incidence.eng %*% t(imdb.incidence.eng)

# get upper triangular (without diagonal) for exploration
AAT.diag = triu(AAT,1)

# plot adjacency matrix
AAT.diag@x %>% 
  table %>% 
  enframe(name="Adjacency",value="Count") %>% 
  mutate(Adjacency = as.numeric(Adjacency),Count=Count+0.1) %>% 
  ggplot(aes(x=Adjacency,y=Count)) + geom_col(position="dodge",width=0.9,fill="darkorange1") + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=",")),
                limits=c(1,3e6),expand=c(0,0)) + 
  scale_x_continuous(breaks=1:10,labels=1:10,expand=c(.02,0)) + 
  labs(title="Title-title adjacency values distribution") + 
  theme_minimal() + theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color="black",size=.05),
    panel.grid.minor.y = element_blank(),
    panel.background = element_rect(fill="transparent",colour=NA),
    plot.background = element_rect(fill="transparent",colour=NA)
  ) + annotation_logticks(sides="l")

# tried 2 different transformations at first: log2(x+1) and sqrt(x)
# but it turns out they're almost equal on 1:10 so the results are almost the same,
# so just do log2(x+1). also, base shouldn't matter, but 2 used so that 1 maps to 1
# first duplicate the objects from AAT, then apply function
AAT.log = AAT
AAT.log@x  = log(AAT.log@x+1,base=2)


# fa.log = vsp(AAT.log,k=100)
# plot(fa.log$d)
fa.log = vsp(AAT.log,k=8)

apply(fa.log$Z,1,which.max) %>% 
  table %>% 
  enframe(name="Cluster",value="Count") %>% 
  mutate(Cluster=as.numeric(Cluster)) %>% 
  ggplot(aes(x=Cluster,y=Count)) + geom_col(position="dodge",width=0.9,fill="darkorange1") + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=",")),
                limits=c(1,1e5),expand=c(0,0)) + 
  annotation_logticks(sides="l") + 
  scale_x_continuous(breaks=1:10,labels=1:10,expand=c(.025,0)) + 
  labs(title="Cluster sizes after log transform") + 
  theme_minimal() + theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color="black",size=.05),
    panel.grid.minor.y = element_blank(),
    panel.background = element_rect(fill="transparent",colour=NA),
    plot.background = element_rect(fill="transparent",colour=NA)
  )

Gini(table(apply(fa.log$Z,1,which.max)))

fa.log.bff = bff(fa.log$Z,AAT,20)
fa.log.titles = fa.log.bff %>% 
  apply(2, function(x)sapply(x,function(i)title.names.eng[which(i==names(title.names.eng))]))
fa.log.links = fa.log.bff %>% 
  apply(2, function(x){
    sapply(x,function(i){
      sprintf("[%s](https://www.imdb.com/title/%s)",title.names.eng[which(i==names(title.names.eng))],i)
    })
  })
fa.log.list = lapply(fa.log.links%>%data.frame, .%>%paste(.,collapse=", "))
save(fa.log.list,file="./fa.log.list.Rdata",compression_level=9)
