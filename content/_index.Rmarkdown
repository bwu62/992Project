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

One of the first questions we were interested in answering
