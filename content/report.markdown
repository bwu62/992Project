---
title: Report
---

<style>
.plots{
  max-width: 80%;
  text-align: center;
  margin-top: 15px !important;
}
pre{
    white-space: pre-wrap;      /* Since CSS 2.1 */
    white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
    white-space: -pre-wrap;     /* Opera 4-6 */
    white-space: -o-pre-wrap;   /* Opera 7 */
    word-wrap: break-word;      /* Internet Explorer 5.5+ */
    margin: 40px 0 !important;
}
</style>

<img src="../assets/img/icon.png" style="max-width:20%;min-width:40px;float:right;border-radius:50%;margin:5px;" alt="Github repo" />

# IMDB Genre Identification

_Authors: Bi Wu & Chris Kardatzke_

## Links

This is a continuation of our previous works:

 - [Blog page](..)
 - [Proposal](../proposal)
 - [Presentation](../presentation.pdf)

## Background

We were previously interested in clustering IMDB movies by genre. We filtered out undesired content (i.e. television shows, web shorts, adult content, non-English titles) and applied `vsp` but found the method was highly sensitive to small densely-connected cliques of nodes (e.g. RiffTrax releases, Blondies movies; see [blog](..) for more). This was evidenced by observing that the sizes of the resultant clusters were wildly imbalanced:

![](../assets/img/cliques_orig.svg)

In this current project, we explore methods of mitigating the influence of these cliques. We hope this would lead to better identification of larger-scale genre info.

## Analysis

### Method 1: Predicting Node Cliquishness by Logistic Regression

In our first attempt at improving our clustering, we tried to contract our graph to exclude nodes which we predicted to belong to cliques. Our motivation for doing this was to get rid of some of the clusters that were too specific to be considered any sort of genre, for instance the director-specific clusters.

To predict which nodes belonged to cliques, we generated a number of node statistics on all of the title nodes. Included among these statistics were degree and coreness, to measure a nodes connectedness, and the number of triangles at each node and degree distribution to other nodes, to measure the connectedness of the nodes’ neighbors.

Using a list of “IMDB top movies” and our previous attempt at clustering, we built a training dataset of around 1200 titles that we individually labeled as either belonging to a clique or not. From there, we fit a logistic regression model to predict which of the remaining ~90,000 nodes belonged to cliques.

We then removed all of these "cliquish" nodes from our graph, and performed clustering using VSP once again. We found that with this subsetting, using 12 clusters worked better than 8. With this change in place, the Gini index of our cluster sizes fell to .867. Most importantly, our clusters looked much better. We no longer saw as many cliquish clusters like the cluster of Blondie movies we saw in our initial attempt.

![Cluster plot after subsetting](../assets/img/cliques_chris.svg)


