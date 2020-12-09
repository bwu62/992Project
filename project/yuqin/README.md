# Yuqin's task

Try running Personalized Page Rank (PPR) on projected actor by actor adjacency matrix to identify highly connected cliques of actors to either contract or remove. I (Bi) don't really have any other suggestions of advice, since I haven't really done anything with PPR before. Please feel free to reach out to either me or Chris for help, or just talk to Karl in his office hours (Mon 3-4, Tue & Thu after class).

## PPR help

First, load the data using the [quickstart guide](https://github.com/bwu62/992Project/blob/master/project/README.md). Next, make the graph using this:

```r
imdb.titles = full_join(principals2.eng,principals2.eng,c('nconst'='nconst'))[c(1,3,2)] %>% 
  filter(tconst.x!=tconst.y) %>%
  graph_from_data_frame(directed=F)
```

## Page Rank

See this [man page](https://igraph.org/r/doc/page_rank.html) for instructions on running page rank. If you can't figure out how to run personalized page rank for each node, just run one page rank for the entire graph maybe?
