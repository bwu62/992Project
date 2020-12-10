# Chris's task

Look at various statistics of each node to try to distinguish the ones in small cliques from ones in the main graph. Emphasis should be placed on fast to compute ones such as:

 - coreness
 - degree
 - distance away from a fixed node (i.e. Eric Roberts)
 - etc.

Something Karl and I talked about is maybe taking a small subset of nodes, some of which are known to be cliques and some non-cliques (you can look at the output of the blog page and use for example the Westerns group as non-cliques, and the RiffTrax and Blondie movies as cliques), create a clique flag column, running logistic regression, and maybe using the fit to predict the "clique-ness" of the rest of the nodes.

Alternatively, you can also look into some machine learning techniques if you are interested (maybe some kind of forest?). If you go this route, try to generate as many features as you can for each node; that should help you get better performance. Also, remember to use an appropriate train-test split (or train-validate-test split).


