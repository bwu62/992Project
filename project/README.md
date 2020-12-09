# Data quick-start guide

## Install packages

First make sure you have the necessary packages. `Matrix`, `igraph`, and `vsp` are necessary; `tidyverse`, `ggplot2`, and `scales` are highly encouraged. It's also recommended to use the `pacman` package manager to automate installing/importing these.

```r
# check pacman is installed
if(!require(pacman)) install.packages("pacman")

# use pacman to install/load most packages
pacman::p_load(Matrix,igraph,tidyverse,ggplot2,scales)

# use older (forked) version of vsp due to bug in most recent version
pacman::p_load_gh("bwu62/vsp")
```

## Load data

Next, load the data (remember to set your own working directory, e.g. I'm running this from [`bi/`](https://github.com/bwu62/992Project/tree/master/project/bi)). If the `load( )` function desn't work for you, you may have a locale problem (email Bi for help).

```r
# load the compressed binary file
load("../eng_principals2+names.Rdata")

# check loaded files
ls()
```

You should have these objects:

 - `principals2.eng` : edge list of English-language titles and their cast (using IDs)
 - `actor.names.eng` , `title.names.eng` : real names of the movies and actors

## Basic processing

To construct the title by actor incidence matrix, you can do the following. This creates a `sparseMatrix` object (from the `Matrix` package).

```r
imdb.incidence.eng = 
  principals2.eng %>% 
  mutate(tconst=as.numeric(factor(tconst,ordered=T,levels=names(title.names.eng))),
         nconst=as.numeric(factor(nconst,ordered=T,levels=names(actor.names.eng))),
         value=1) %>% 
  with(.,sparseMatrix(i=tconst,j=nconst,x=value,dimnames=list(names(title.names.eng),names(actor.names.eng))))
```

If you wanted to project A(A^T) or (A^T)A, you can transpose and multiply like a normal `R` matrix.

```r
# get title by title projected adjacency matrix
AAT = imdb.incidence.eng %*% t(imdb.incidence.eng)

# get actor by actor projected adjacency matrix
ATA = t(imdb.incidence.eng) %*% imdb.incidence.eng
```

## Running VSP

Once clique nodes have been identified and filtered out, you're ready to run `vsp` again to check the results. Rerun the code above that was used to generate `imdb.incidence.eng` to generate your new incidence matrix.

Suppose your new clique-filtered incidence matrix is called `imdb.incidence.new` (and assume of course it's still titles as rows and actors as columns). Run `vsp` and save the output as following, starting with an extremely high value of `k` :

```r
fa.new = vsp(imdb.incidence.new,k=100)
```

Make the scree plot (i.e. plot of eigenvalues) just to see what it looks like.

```r
plot(fa.new$d)
```

Normally we would look for a 'jump' which would suggest a possible value to set as `k`, but since we are comparing our results to the previous analysis where `k=8`, we will set `k=8` regardless of the eigenvalues and rerun. (If you see something strange with the scree plot, mention it to your group mates!)

```r
fa.new = vsp(imdb.incidence.new,k=8)
```

The main outputs of `vsp` are `$Z`, which is the clustering on the rows; and `$Y`, which is the clustering on the columns. Since we have titles on rows, we want `$Z`. To quickly plot the cluster groups, I did this:

```r
apply(fa.new$Z,1,which.max) %>% 
  table %>% 
  enframe(name="Cluster",value="Count") %>% 
  mutate(Cluster=as.numeric(Cluster)) %>% 
  ggplot(aes(x=Cluster,y=Count)) + geom_col(position="dodge",width=0.9,fill="darkorange1") + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=",")),
                limits=c(1,1e5),expand=c(0,0)) + 
  annotation_logticks(sides="l") + 
  scale_x_continuous(breaks=1:10,labels=1:10,expand=c(.025,0)) + 
  labs(title="Title") + 
  theme_minimal() + theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color="black",size=.05),
    panel.grid.minor.y = element_blank(),
    panel.background = element_rect(fill="transparent",colour=NA),
    plot.background = element_rect(fill="transparent",colour=NA)
  )
```

If you want a dark mode version for the slides, install `ggdark` and run the following modified code:

```r
pacman::p_load(ggdark)

apply(fa.new$Z,1,which.max) %>% 
  table %>% 
  enframe(name="Cluster",value="Count") %>% 
  mutate(Cluster=as.numeric(Cluster)) %>% 
  ggplot(aes(x=Cluster,y=Count)) + geom_col(position="dodge",width=0.9,fill="darkorange1") + 
  scale_y_log10(breaks=trans_breaks("log10",function(x)10^x),
                labels=trans_format("log10",function(x)formatC(10^x,format="d",big.mark=",")),
                limits=c(1,1e5),expand=c(0,0)) + 
  annotation_logticks(sides="l") + 
  scale_x_continuous(breaks=1:10,labels=1:10,expand=c(.025,0)) + 
  labs(title="Title") + 
  ggdark::dark_mode(theme_minimal()) + theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color="grey",size=.05),
    panel.grid.minor.y = element_blank(),
    panel.background = element_rect(fill="transparent",colour=NA),
    plot.background = element_rect(fill="transparent",colour=NA)
  )
```

It's recommended to save them using these settings (using eps here for slide (eps works better with pdf than svg))

```r
ggsave("cliques.eps",width=5.5,height=4,bg="transparent")
```

Remember to change the following to your plot:
 - Change the title in `labs(title="Title")`
 - Change the y-limits (which were set manually for aesthetic purposes) in `limits=c(1,1e5)` inside `scale_y_log10`
 - If you want, you can also change the color (I just arbitrarily chose `"darkorange1"` cause I thought it looked nice)

You should also compute the [Gini index](https://en.wikipedia.org/wiki/Gini_coefficient) of your cluster sizes to measure how imbalanced the clusters are. You can use the `Gini` function in the `DescTools` package.

```r
pacman::p_load(DescTools)
Gini(table(apply(fa.new$Z,1,which.max)))
```

## Extra (checking cluster results)

You can also look at some of the top movies in your clusters using the `bff` tool from `vsp`. Here's some code I wrote to automatically generate [Markdown-formatted links](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#links) that you can then paste into a notebook (I used `num_best=10` to get the top 10 but you can change this).

Also, I'm not quite sure why, but `bff` seems to need to run on `$Y` to generate the top titles. It also needs the transpose of the incidence matrix as the second argument. The outputs look right though so I'm pretty sure this is fine.

```r
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
```

For Bi to add these to a GitHub page, run this to save results to a list (in your own directory).

```r
fa.new.list = lapply(fa.new.links %>% data.frame, . %>% paste(.,collapse=", "))
save(fa.new.list,file="fa.new.list.Rdata",compression_level=9)
```

## Other notes

Some other random notes:

 - If you're running `vsp( )`, Karl recommends using a high `k` first (e.g. 100), then looking at the scree plot (i.e. plot of eigenvalues, which are accessible by running `$d` on the output) and choosing an appropriate lower `k` before a large 'jump'.
 - The scree plot eigenvalues don't necessarily correlate to cluster sizes
 - Make sure to check these to see if your method is working:
   - output of `bff( )` to see 'best features' (see "Illustration" section of [course site](http://pages.stat.wisc.edu/~karlrohe/992/lectureNotes.html) for demos of this)
   - the cluster group sizes

## Good luck!

I think this should be enough to get you started. Let me know if you have other questions (and remember to commit and push your changes often!).

Other resources:

 - igraph documentation for [R](https://igraph.org/r/) and [python](https://igraph.org/python/) packages
 - Karl's [notes on PPR](http://pages.stat.wisc.edu/~karlrohe/992/tutorials/directedEdges.pdf)
