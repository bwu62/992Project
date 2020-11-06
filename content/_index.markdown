---
title: Home
---

<img src="assets/img/icon.png" style="max-width:20%;min-width:40px;float:right;border-radius:50%" alt="Github repo" />

# IMDB Center/Factor Analysis

We were interested in investigating actors/movies data from IMDB. The data is conveniently available for [download here](https://datasets.imdbws.com/) ([data description](https://www.imdb.com/interfaces/)).

For sake of clarity, we omit directly quoting code. Readers interested in getting into the weeks should consult the [Github](https://github.com/bwu62/992Project).

## Preprocessing

Before we jump into the analyses, we first discuss the preprocessing done. We were primarily interested in movies typically played in theaters or streamed online, not television shows, web shorts, or adult content (all of which is included in the IMDB data download), so these were filtered out.

Basically all actors and movies (>99.9%) were in one large connected component, with a small smattering of other niche/amateur/independent content in numerous smaller disconnected components. These were filtered out too.

Our final dataset contains ~605k actors and 463k movies.

## Centrality

[Frigyes Karithny](https://en.wikipedia.org/wiki/Frigyes_Karinthy) is widely credited as the originator of the [six degrees of separation](https://en.wikipedia.org/wiki/Six_degrees_of_separation) hypothesis that in social networks, any two arbitrary persons can be connected by 6 edge traversals in the network. This was influential in popular culture, inspiring popular [films](https://en.wikipedia.org/wiki/Six_Degrees_of_Separation_(film)), [shows](https://en.wikipedia.org/wiki/Six_Degrees_(TV_series)), and [music](https://www.youtube.com/watch?v=FCT6Mu-pOeE).

One popular spinoff conjecture known was that everyone in Hollywood can be linked to [Kevin Bacon](https://en.wikipedia.org/wiki/Kevin_Bacon) in [six or fewer film roles](https://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon). This inspired us to use degrees as a centrality measure and try to identify the "center" of our IMDB network.

Using [`igraph`](https://igraph.org/), we constructed a graph from our edge list data frame based on costar relationships. First, we decided to see how connected people are to Bacon by computing everyone's distance to him in the network, referred to as their bacon numbers. We found a mean degrees of separation of **4.301**. Below is a histogram of these distances.

![bacon numbers](assets/img/bacon.svg)

Next, we wanted to see if we could find a better center of the network. We setup parallelized jobs to traverse the top 5000 most-connected actors in the network (below this number, actors has so few connections that it's inconceivable they could be the most central) and computed their distance to everyone else in the network.

Using this as our measure of centrality, we found [Eric Roberts](https://en.wikipedia.org/wiki/Eric_Roberts) (brother of [Julia Roberts](https://en.wikipedia.org/wiki/Julia_Roberts) and father of [Emma Roberts](https://en.wikipedia.org/wiki/Emma_Roberts)) to be the most connected, with a mean degrees of separation of just **3.905**. Below is a histogram of these distances.

![roberts numbers](assets/img/roberts.svg)

Here is a side by side plot for comparison.

![comparison of bacon and roberts numbers](assets/img/bacon-roberts.svg)


