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

If you wanted to project $AA^\text{T}$ or $A^\text{T}A$, you can transpose and multiply like a normal `R` matrix.

```r
# get title by title projected adjacency matrix
AAT = imdb.incidence.eng %*% t(imdb.incidence.eng)

# get actor by actor projected adjacency matrix
ATA = t(imdb.incidence.eng) %*% imdb.incidence.eng
```

## Other notes

Some other random notes:

 - If you're running `vsp( )`, Karl recommends using a high `k` first (e.g. 100), then looking at the scree plot (i.e. plot of eigenvalues, which are accessible by running `$d` on the output) and choosing an appropriate lower `k` before a large 'jump'.
 - The scree plot eigenvalues don't necessarily correlate to cluster sizes
 - Make sure to check these to see if your method is working:
   - output of `bff( )` to see 'best features' (see "Illustration" section of [course site](http://pages.stat.wisc.edu/~karlrohe/992/lectureNotes.html) for demos of this)
   - the cluster group sizes

## Good luck!

I think this should be enough to get you started. Let me know if you have other questions.

Other resources:

 - igraph documentation for [R](https://igraph.org/r/) and [python](https://igraph.org/python/) packages
 - Karl's [notes on PPR](http://pages.stat.wisc.edu/~karlrohe/992/tutorials/directedEdges.pdf)
