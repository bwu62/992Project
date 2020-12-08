# Chris's task

Look at various statistics of each node to try to distinguish the ones in small cliques from ones in the main graph. Emphasis should be placed on fast to compute ones such as:

 - coreness
 - degree
 - distance away from a fixed node (i.e. Eric Roberts)
 - etc.

Something Karl and I talked about is maybe taking a small subset of nodes, some of which are known to be cliques and some non-cliques (you can look at the output of the blog page and use for example the Westerns group as non-cliques, and the RiffTrax and Blondie movies as cliques), create a clique flag column, running logistic regression, and maybe using the fit to predict the "clique-ness" of the rest of the nodes.

Alternatively, you can also look into some machine learning techniques if you are interested (maybe some kind of forest?). If you go this route, try to generate as many features as you can for each node; that should help you get better performance. Also, remember to use an appropriate train-test split (or train-validate-test split).

## Results

Group  1 :
[The Last Hour](https://www.imdb.com/title/tt0014187)
[Free and Equal](https://www.imdb.com/title/tt0015839)
[This Hero Stuff](https://www.imdb.com/title/tt0010772)
[His Last Race](https://www.imdb.com/title/tt0014135)
[Danger, Go Slow](https://www.imdb.com/title/tt0008993)
[Murder Will Out](https://www.imdb.com/title/tt0021163)
[The Thundering Herd](https://www.imdb.com/title/tt0016430)
[Flesh and Blood](https://www.imdb.com/title/tt0013134)
[The Daredevil](https://www.imdb.com/title/tt0010046)
[Peg o' My Heart](https://www.imdb.com/title/tt0338339) 

Group  2 :
[The Last Hour](https://www.imdb.com/title/tt0014187)
[Free and Equal](https://www.imdb.com/title/tt0015839)
[This Hero Stuff](https://www.imdb.com/title/tt0010772)
[His Last Race](https://www.imdb.com/title/tt0014135)
[Danger, Go Slow](https://www.imdb.com/title/tt0008993)
[Murder Will Out](https://www.imdb.com/title/tt0021163)
[The Thundering Herd](https://www.imdb.com/title/tt0016430)
[Flesh and Blood](https://www.imdb.com/title/tt0013134)
[The Daredevil](https://www.imdb.com/title/tt0010046)
[Peg o' My Heart](https://www.imdb.com/title/tt0338339) 

Group  3 :
[The Last Hour](https://www.imdb.com/title/tt0014187)
[Free and Equal](https://www.imdb.com/title/tt0015839)
[This Hero Stuff](https://www.imdb.com/title/tt0010772)
[His Last Race](https://www.imdb.com/title/tt0014135)
[Danger, Go Slow](https://www.imdb.com/title/tt0008993)
[Murder Will Out](https://www.imdb.com/title/tt0021163)
[The Thundering Herd](https://www.imdb.com/title/tt0016430)
[Flesh and Blood](https://www.imdb.com/title/tt0013134)
[The Daredevil](https://www.imdb.com/title/tt0010046)
[Peg o' My Heart](https://www.imdb.com/title/tt0338339) 

Group  4 :
[The Last Hour](https://www.imdb.com/title/tt0014187)
[Free and Equal](https://www.imdb.com/title/tt0015839)
[This Hero Stuff](https://www.imdb.com/title/tt0010772)
[His Last Race](https://www.imdb.com/title/tt0014135)
[Danger, Go Slow](https://www.imdb.com/title/tt0008993)
[Murder Will Out](https://www.imdb.com/title/tt0021163)
[The Thundering Herd](https://www.imdb.com/title/tt0016430)
[Flesh and Blood](https://www.imdb.com/title/tt0013134)
[The Daredevil](https://www.imdb.com/title/tt0010046)
[Peg o' My Heart](https://www.imdb.com/title/tt0338339) 

Group  5 :
[The Last Hour](https://www.imdb.com/title/tt0014187)
[Free and Equal](https://www.imdb.com/title/tt0015839)
[This Hero Stuff](https://www.imdb.com/title/tt0010772)
[His Last Race](https://www.imdb.com/title/tt0014135)
[Danger, Go Slow](https://www.imdb.com/title/tt0008993)
[Murder Will Out](https://www.imdb.com/title/tt0021163)
[The Thundering Herd](https://www.imdb.com/title/tt0016430)
[Flesh and Blood](https://www.imdb.com/title/tt0013134)
[The Daredevil](https://www.imdb.com/title/tt0010046)
[Peg o' My Heart](https://www.imdb.com/title/tt0338339) 

Group  6 :
[The Last Hour](https://www.imdb.com/title/tt0014187)
[Free and Equal](https://www.imdb.com/title/tt0015839)
[This Hero Stuff](https://www.imdb.com/title/tt0010772)
[His Last Race](https://www.imdb.com/title/tt0014135)
[Danger, Go Slow](https://www.imdb.com/title/tt0008993)
[Murder Will Out](https://www.imdb.com/title/tt0021163)
[The Thundering Herd](https://www.imdb.com/title/tt0016430)
[Flesh and Blood](https://www.imdb.com/title/tt0013134)
[The Daredevil](https://www.imdb.com/title/tt0010046)
[Peg o' My Heart](https://www.imdb.com/title/tt0338339) 

Group  7 :
[The Last Hour](https://www.imdb.com/title/tt0014187)
[Free and Equal](https://www.imdb.com/title/tt0015839)
[This Hero Stuff](https://www.imdb.com/title/tt0010772)
[His Last Race](https://www.imdb.com/title/tt0014135)
[Danger, Go Slow](https://www.imdb.com/title/tt0008993)
[Murder Will Out](https://www.imdb.com/title/tt0021163)
[The Thundering Herd](https://www.imdb.com/title/tt0016430)
[Flesh and Blood](https://www.imdb.com/title/tt0013134)
[The Daredevil](https://www.imdb.com/title/tt0010046)
[Peg o' My Heart](https://www.imdb.com/title/tt0338339) 

Group  8 :
[The Last Hour](https://www.imdb.com/title/tt0014187)
[Free and Equal](https://www.imdb.com/title/tt0015839)
[This Hero Stuff](https://www.imdb.com/title/tt0010772)
[His Last Race](https://www.imdb.com/title/tt0014135)
[Danger, Go Slow](https://www.imdb.com/title/tt0008993)
[Murder Will Out](https://www.imdb.com/title/tt0021163)
[The Thundering Herd](https://www.imdb.com/title/tt0016430)
[Flesh and Blood](https://www.imdb.com/title/tt0013134)
[The Daredevil](https://www.imdb.com/title/tt0010046)
[Peg o' My Heart](https://www.imdb.com/title/tt0338339) 
