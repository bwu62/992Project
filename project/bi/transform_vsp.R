setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# check pacman is installed
if(!require(pacman)) install.packages("pacman")

# use pacman to install/load most packages
pacman::p_load(Matrix,igraph,tidyverse,ggplot2,scales,DescTools,ggdark,magrittr,latex2exp,ggdark)

# use older (forked) version of vsp due to bug in most recent version
pacman::p_load_gh("bwu62/vsp")



# ################################################################
# # WAIT IT'S NOT CONNECTED NOW LOL need to fix
# load("../eng_principals2+names.Rdata")
# 
# imdb.titles = full_join(principals2.eng,principals2.eng,c('nconst'='nconst'))[c(1,3,2)] %>% 
#   filter(tconst.x!=tconst.y) %>%
#   graph_from_data_frame(directed=F)
# 
# # subset the largest connected component
# imdb.comp = components(imdb.titles)
# imdb.titles = induced_subgraph(imdb.titles,names(imdb.comp$membership[imdb.comp$membership == 1]))
# 
# # get titles in this component, to subset principals and names
# titles.keep2 = V(imdb.titles) %>% names
# principals2.eng %<>% filter(tconst %in% titles.keep2)
# actor.names.eng = actor.names.eng[names(actor.names.eng) %in% principals2.eng$nconst]
# title.names.eng = title.names.eng[names(title.names.eng) %in% principals2.eng$tconst]
# 
# save(principals2.eng,actor.names.eng,title.names.eng,
#      file="../eng_principals2+names.Rdata",compression_level=9)
# ################################################################



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
                limits=c(1,2.5e6),expand=c(0,0)) + 
  annotation_logticks(sides="l",color="grey") + 
  scale_x_continuous(breaks=1:10,labels=1:10,expand=c(.02,0)) + 
  labs(title="Projected adjacency values distribution") + 
  dark_mode(theme_minimal()) + theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color="grey",size=.05),
    panel.grid.minor.y = element_blank(),
    panel.background = element_rect(fill="transparent",colour=NA),
    plot.background = element_rect(fill="transparent",colour=NA)
  )
ggsave("./adjacency.eps",width=5.5,height=4,bg="transparent")

# tried 2 different transformations at first: log2(x+1) and sqrt(x)
# but it turns out they're almost equal on 1:10 so the results are almost the same,
# so just do log2(x+1). also, base shouldn't matter, but 2 used so that 1 maps to 1
# first duplicate the objects from AAT, then apply function
AAT.log = AAT
AAT.log@x = log2(AAT.log@x+1)
# AAT.log@x = AAT.log@x^(1/3)

# fa.log = vsp(AAT.log,k=100)
# plot(fa.log$d)
fa.log = vsp(AAT.log,k=13)

apply(fa.log$Z,1,which.max) %>% 
  table %>% 
  enframe(name="Cluster",value="Count") %>% 
  mutate(Cluster=as.numeric(Cluster)) %>% 
  ggplot(aes(x=Cluster,y=Count)) + geom_col(position="dodge",width=0.9,fill="darkorange1") + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=",")),
                limits=c(1,1e5),expand=c(0,0)) + 
  annotation_logticks(sides="l",color="grey") + 
  scale_x_continuous(breaks=1:13,labels=1:13,expand=c(.025,0)) + 
  labs(title=bquote(paste("Cluster sizes after ",log[2],"(A",A^{T},"+1)","   ",
                          "(Gini index: ",.(round(Gini(table(apply(fa.log$Z,1,which.max))),3)),")"
  ))) + 
  dark_mode(theme_minimal()) + theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color="grey",size=.05),
    panel.grid.minor.y = element_blank(),
    panel.background = element_rect(fill="transparent",colour=NA),
    plot.background = element_rect(fill="transparent",colour=NA)
  )
ggsave("cliques_bi.eps",width=5.5,height=4,bg="transparent")

Gini(table(apply(fa.log$Z,1,which.max)))

fa.log.bff = bff(fa.log$Z,AAT,10)
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






# # extra stuff for chris
# imdb.titles = full_join(principals2.eng,principals2.eng,c('nconst'='nconst'))[c(1,3,2)] %>%
#   filter(tconst.x!=tconst.y) %>%
#   graph_from_data_frame(directed=F)
# 
# triangles = setNames(count_triangles(imdb.titles,V(imdb.titles)),names(V(imdb.titles)))
# write.table(triangles,file="../chris/triangles.csv",sep=',',quote=F,col.names=FALSE)
# 
# # recompute centrality info but for titles
# getMeanDegrees = function(title){
#   D = distances(imdb.titles,v=title)[1,]
#   D_log = table(as.numeric(
#     with(data.frame(values=table(D)),rep(values.D,floor(log2(values.Freq))))
#   ))
#   return(setNames(c(Mode(D),mean(D),sd(D_log),Skew(D_log),Kurt(D_log)),
#                   c("mode","mean","logSD","logSkew","logKurt")))
# }
# 
# library(parallel)
# 
# gc()
# cores = detectCores()-1
# cl = makeCluster(cores)
# clusterEvalQ(cl,library(igraph))
# clusterEvalQ(cl,library(DescTools))
# clusterExport(cl,list("imdb.titles","getMeanDegrees","title.names.eng"))
# {
#   start=Sys.time()
#   nodeStats = parSapply(cl,names(title.names.eng),getMeanDegrees)
#   (elapsed=Sys.time()-start)
# }
# stopCluster(cl)
# gc()
# 
# write.csv(nodeStats,file="../chris/nodeStats.csv",quote=F,row.names=F)
