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

We were previously interested in clustering IMDB movies by genre. We filtered out undesired content (i.e. television shows, web shorts, adult content, non-English titles) and applied `vsp` but found the method was highly sensitive to small densely-connected cliques of nodes (e.g. RiffTrax releases, Blondies movies; see [blog](..) for more details). This was evidenced by observing that the sizes of the resultant clusters were wildly imbalanced:

<p><img class="plots" src="../assets/img/cliques_orig.svg" alt="plot of original clusters"/></p>

In this current project, we explore methods of mitigating the influence of these cliques. We hope this would lead to better identification of larger-scale genre info.

## Analysis

### Method 1 (Chris): Logistic Regression

In our first attempt at improving our clustering, we tried to contract our graph to exclude nodes which we predicted to belong to cliques. Our motivation for doing this was to get rid of some of the clusters that were too specific to be considered any sort of genre, for instance the director-specific clusters.

To predict which nodes belonged to cliques, we generated a number of node statistics on all of the title nodes. Included among these statistics were degree, a measure of the number of edges adjacent to a node, and coreness. The k-core of graph is a maximal subgraph in which each vertex has at least degree k. The coreness of a vertex is k if it belongs to the k-core but not to the (k+1)-core. We used these two measures to gauge a node's connectedness. We also calculated the number of triangles at each node and degree distribution to other nodes. Within degree distribution we looked at the mean, mode, standard deviation, skew, and kurtosis of the distribution of degrees from a node to each other node. This metric was used to measure the connectedness of the nodes' neighbors.

Using a list of "IMDB top movies" and our previous attempt at clustering, we built a training dataset of around 1200 titles. We assigned a label of 1 to titles that had been assigned to clusters 2, 3, 5, and 7, four director-specific clusters, in our previous attempt at clustering. We assigned a label of 0 to titles in the "IMDB top movies" list. From there, we fit a logistic regression model to predict which of the remaining ~90,000 nodes belonged to cliques.

We then contracted all of these "cliquish" nodes and performed clustering using `vsp` once again. We found that with this subsetting, using 12 clusters worked better than 8. With this change in place, the Gini index of our cluster sizes fell to .865. Most importantly, our clusters looked much better. We no longer saw as many cliquish clusters like the cluster of Blondie movies we saw in our initial attempt.

<p><img class="plots" src="../assets/img/cliques_chris.svg" alt="plot of chris's improved clusters"/></p>

Here are the top 10 best movies from each cluster selected using `bff`



1.  
2.  
3.  
4.  
5.  
6.  
7.  
8.  
9.  
10. 
11. 
12. 

<br/><code class="fa-links" style="white-space:normal;padding:2px 0">

 > Group 1:
[His Last Race](https://www.imdb.com/title/tt0014135), [This Hero Stuff](https://www.imdb.com/title/tt0010772), [Free and Equal](https://www.imdb.com/title/tt0015839), [Murder Will Out](https://www.imdb.com/title/tt0021163), [The Last Hour](https://www.imdb.com/title/tt0014187), [Peg o' My Heart](https://www.imdb.com/title/tt0338339), [Come Again Smith](https://www.imdb.com/title/tt0010014), [Danger, Go Slow](https://www.imdb.com/title/tt0008993), [The Son of His Father](https://www.imdb.com/title/tt0008603), [Flesh and Blood](https://www.imdb.com/title/tt0013134)

 > Group 2:
[Salt Lake Raiders](https://www.imdb.com/title/tt0042917), [Bandits of Dark Canyon](https://www.imdb.com/title/tt0039173), [Marshal of Amarillo](https://www.imdb.com/title/tt0040574), [Desperadoes of Dodge City](https://www.imdb.com/title/tt0040286), [Marshal of Cedar Rock](https://www.imdb.com/title/tt0046049), [Bandits of the West](https://www.imdb.com/title/tt0045540), [Frontier Investigator](https://www.imdb.com/title/tt0041392), [Oklahoma Badlands](https://www.imdb.com/title/tt0040659), [The Bold Frontiersman](https://www.imdb.com/title/tt0040180), [Sundown in Santa Fe](https://www.imdb.com/title/tt0040850)

 > Group 3:
[Hit Favorites: Trick Or Treat Tales](https://www.imdb.com/title/tt3384178), [Hit Favorites: Sweet Dreams](https://www.imdb.com/title/tt2181148), [Hit Favorites: Preschool Fun](https://www.imdb.com/title/tt2224990), [Bob the Builder: The Ultimate Can-Do Crew](https://www.imdb.com/title/tt2364846), [A Change of Seasons](https://www.imdb.com/title/tt0080515), [FM](https://www.imdb.com/title/tt0077532), [Promises in the Dark](https://www.imdb.com/title/tt0079757), [Try This One for Size](https://www.imdb.com/title/tt0098530), [King B: A Life in the Movies](https://www.imdb.com/title/tt0140313), [Wallace & Gromit: The Curse of the Were-Rabbit](https://www.imdb.com/title/tt0312004)

 > Group 4:
[Cleopatra](https://www.imdb.com/title/tt0260516), [****](https://www.imdb.com/title/tt0179184), [San Diego Surf](https://www.imdb.com/title/tt0218575), [Since](https://www.imdb.com/title/tt3335870), [The Nude Restaurant](https://www.imdb.com/title/tt0062055), [Imitation of Christ](https://www.imdb.com/title/tt0207531), [The Loves of Ondine](https://www.imdb.com/title/tt0061923), [Hedy](https://www.imdb.com/title/tt0218325), [The Velvet Underground Tarot Cards](https://www.imdb.com/title/tt3750328), [Camp](https://www.imdb.com/title/tt0173709)

 > Group 5:
[Sugar Shop](https://www.imdb.com/title/tt1999956), [La La](https://www.imdb.com/title/tt2418104), [The Anubis Tapes](https://www.imdb.com/title/tt6397950), [The Bridge to Nowhere](https://www.imdb.com/title/tt0973785), [Beyond](https://www.imdb.com/title/tt1800671), [Killer Under the Bed](https://www.imdb.com/title/tt9149982), [Friday I'm in Love](https://www.imdb.com/title/tt4500572), [King of the Open Mics](https://www.imdb.com/title/tt0229513), [JL Family Ranch 2](https://www.imdb.com/title/tt10302982), [JL Ranch](https://www.imdb.com/title/tt5321174)

 > Group 6:
[The 100 Best Black Movies (Ever)](https://www.imdb.com/title/tt1546668), [Sundance Skippy](https://www.imdb.com/title/tt1518293), [Time Warp: The Greatest Cult Films of All-Time- Vol. 1 Midnight Madness](https://www.imdb.com/title/tt12081026), [Luck, Trust & Ketchup: Robert Altman in Carver Country](https://www.imdb.com/title/tt0107455), [Ghosts of Mississippi](https://www.imdb.com/title/tt0116410), [Na Nai'a: Legend of the Dolphins](https://www.imdb.com/title/tt4151800), [Before Her Time: Decommissioning Enterprise](https://www.imdb.com/title/tt3668260), [Alan Pakula: Going for Truth](https://www.imdb.com/title/tt7742108), [The Getaway](https://www.imdb.com/title/tt0109890), [Platoon: Brothers in Arms](https://www.imdb.com/title/tt6111980)

 > Group 7:
[Monique, My Love](https://www.imdb.com/title/tt1043859), [Daughters of Lesbos](https://www.imdb.com/title/tt0217375), [She Came on the Bus](https://www.imdb.com/title/tt0064972), [Marcy](https://www.imdb.com/title/tt0064637), [Sin in the City](https://www.imdb.com/title/tt0174205), [Private Relations](https://www.imdb.com/title/tt0128422), [Only in My Dreams](https://www.imdb.com/title/tt0254630), [Unholy Matrimony](https://www.imdb.com/title/tt0153446), [Crazy Wild and Crazy](https://www.imdb.com/title/tt0059067), [The Good, the Bad and the Beautiful](https://www.imdb.com/title/tt0192081)

 > Group 8:
[Blood Mercury](https://www.imdb.com/title/tt2930426), [The King, The Swordsman, and the Sorceress](https://www.imdb.com/title/tt9810278), [Angel of Reckoning](https://www.imdb.com/title/tt3677840), [Hellcat's Revenge](https://www.imdb.com/title/tt5673828), [Arachnado](https://www.imdb.com/title/tt12429968), [Challenge of Five Gauntlets](https://www.imdb.com/title/tt7049448), [Meathook Massacre II](https://www.imdb.com/title/tt6137138), [Hellcat's Revenge II: Deadman's Hand](https://www.imdb.com/title/tt10060386), [Loose Luck](https://www.imdb.com/title/tt7542096), [The Beast Beneath](https://www.imdb.com/title/tt12395290)

 > Group 9:
[The Class Reunion](https://www.imdb.com/title/tt0065557), [The Snow Bunnies](https://www.imdb.com/title/tt0128550), [The French Love Secret](https://www.imdb.com/title/tt2480376), [Runaway Hormones](https://www.imdb.com/title/tt1187033), [Affair in the Air](https://www.imdb.com/title/tt1500683), [The Sexpert](https://www.imdb.com/title/tt0316584), [Lash of Lust](https://www.imdb.com/title/tt0056166), [Deep Love](https://www.imdb.com/title/tt3534536), [Lady Godiva Rides](https://www.imdb.com/title/tt0125332), [I Love You, I Love You Not](https://www.imdb.com/title/tt0071641)

 > Group 10:
[Ranchers and Rascals](https://www.imdb.com/title/tt0016260), [The Trouble Buster](https://www.imdb.com/title/tt0016456), [The Loser's End](https://www.imdb.com/title/tt0015082), [Not Built for Runnin'](https://www.imdb.com/title/tt0142702), [Win, Lose or Draw](https://www.imdb.com/title/tt0016539), [Border Vengeance](https://www.imdb.com/title/tt0015639), [Silent Sheldon](https://www.imdb.com/title/tt0016351), [The Blind Trail](https://www.imdb.com/title/tt0016659), [Without Orders](https://www.imdb.com/title/tt0017570), [The Man from Oklahoma](https://www.imdb.com/title/tt0017107)

 > Group 11:
[The New Frontier](https://www.imdb.com/title/tt12619898), [The Woman Who Robbed the Stagecoach](https://www.imdb.com/title/tt8452666), [Unearthed: The Curse of Nephthys](https://www.imdb.com/title/tt7836694), [Loaded Monday](https://www.imdb.com/title/tt2886732), [A Night of Hunt and Seek](https://www.imdb.com/title/tt11032454), [Love Gods from Planet Zero](https://www.imdb.com/title/tt6830356), [Counting Bullets](https://www.imdb.com/title/tt12079822), [Wrecking Ball](https://www.imdb.com/title/tt8928236), [You're All Gonna Die](https://www.imdb.com/title/tt7272192), [Kindness Matters](https://www.imdb.com/title/tt8470494)

 > Group 12:
[The Beast Beneath](https://www.imdb.com/title/tt12395290), [Arachnado](https://www.imdb.com/title/tt12429968), [Ghosthouse](https://www.imdb.com/title/tt8633640), [Angry Asian Murder Hornets](https://www.imdb.com/title/tt12304094), [Tales from the Campfire 3](https://www.imdb.com/title/tt11724312), [RoboWoman 2](https://www.imdb.com/title/tt10079052), [Moon of the Blood Beast](https://www.imdb.com/title/tt10078664), [Celluloid Slaughter](https://www.imdb.com/title/tt10079028), [Axegrinder 2](https://www.imdb.com/title/tt10983270), [Supernatural Assassins](https://www.imdb.com/title/tt10765798)

</code><br/>

### Method 2 (Bi): Projection Transformation

The second method involves directly transforming the projected (movies by movies) adjacency matrix. Note this is possible since the original IMDB graph is bipartite.

After projection, the weight of each edge represents the number of cast in common. Below is a histogram of the (non-zero) values in the projected adjacency matrix.

<p><img class="plots" src="../assets/img/adjacency.svg" alt="plot of projected adjacency matrix values"/></p>

Most pairs of movies share only a few actors in common, but a small percent are much more highly connected. These are believed to contribute to the poor genre clustering by `vsp`.

To decrease the influence of these cliquish nodes, we apply the transformation `\(\log_2(AA^T+2)\)`. A log-type transform seems appropriate since it more harshly penalizes higher adjacency values. The `\(+1\)` term and base `\(2\)` are chosen to preserve `\(0\)`s and `\(1\)`s in the matrix. Afterwards, we run `vsp` again (this time choosing `\(k=13\)` as an appropriate cutoff based on the scree plot) and obtain these clusters:

<p><img class="plots" src="../assets/img/cliques_bi.svg" alt="plot of bi's improved clusters"/></p>

This time, the Gini index is much lower (more than we would expect from the increased `\(k\)`), implying we obtained more balanced, larger-sized clusters, which should hopefully capture larger genre-level information.

Again, we use `bff` to select best features in each cluster for inspection:

<br/><code class="fa-links" style="white-space:normal;padding:2px 0;">

 > Group 1:
[His Last Race](https://www.imdb.com/title/tt0014135), [Murder Will Out](https://www.imdb.com/title/tt0021163), [Free and Equal](https://www.imdb.com/title/tt0015839), [This Hero Stuff](https://www.imdb.com/title/tt0010772), [The Last Hour](https://www.imdb.com/title/tt0014187), [The Marriage Ring](https://www.imdb.com/title/tt0009354), [Flesh and Blood](https://www.imdb.com/title/tt0013134), [The Thundering Herd](https://www.imdb.com/title/tt0016430), [The Daredevil](https://www.imdb.com/title/tt0010046), [Danger, Go Slow](https://www.imdb.com/title/tt0008993)

 > Group 2:
[Peach Cobbler](https://www.imdb.com/title/tt13057696), [Exposure](https://www.imdb.com/title/tt11075800), [The Matadors](https://www.imdb.com/title/tt4837090), [Stringer](https://www.imdb.com/title/tt9512094), [3 Bullets](https://www.imdb.com/title/tt5547188), [Dark Cupid](https://www.imdb.com/title/tt3695684), [Soul Pursuit](https://www.imdb.com/title/tt11182846), [After Masks](https://www.imdb.com/title/tt12221824), [Doctor Who Am I](https://www.imdb.com/title/tt12029866), [Days of Power](https://www.imdb.com/title/tt3068544)

 > Group 3:
[Laramie](https://www.imdb.com/title/tt0041577), [Junction City](https://www.imdb.com/title/tt0044775), [The Kid from Amarillo](https://www.imdb.com/title/tt0043708), [Texas Dynamo](https://www.imdb.com/title/tt0043036), [Trail of the Rustlers](https://www.imdb.com/title/tt0043062), [Phantom Valley](https://www.imdb.com/title/tt0040691), [The Stranger from Ponca City](https://www.imdb.com/title/tt0240045), [West of Dodge City](https://www.imdb.com/title/tt0039978), [Texas Stagecoach](https://www.imdb.com/title/tt0033142), [Across the Badlands](https://www.imdb.com/title/tt0042181)

 > Group 4:
[West Point of the Air](https://www.imdb.com/title/tt0027196), [Bureau of Missing Persons](https://www.imdb.com/title/tt0023856), [Sporting Blood](https://www.imdb.com/title/tt0033092), [The Border Legion](https://www.imdb.com/title/tt0020700), [The All-American](https://www.imdb.com/title/tt0022620), [The Front Page](https://www.imdb.com/title/tt0021890), [The Girl from Missouri](https://www.imdb.com/title/tt0025173), [Test Pilot](https://www.imdb.com/title/tt0030848), [Helldorado](https://www.imdb.com/title/tt0026462), [Guilty as Hell](https://www.imdb.com/title/tt0022967)

 > Group 5:
['Neath Brooklyn Bridge](https://www.imdb.com/title/tt0034420), [Let's Get Tough!](https://www.imdb.com/title/tt0034973), [Smart Alecks](https://www.imdb.com/title/tt0035345), [Kid Dynamite](https://www.imdb.com/title/tt0036073), [Mr. Hex](https://www.imdb.com/title/tt0038753), [Bowery Buckaroos](https://www.imdb.com/title/tt0039216), [Hard Boiled Mahoney](https://www.imdb.com/title/tt0039447), [News Hounds](https://www.imdb.com/title/tt0039656), [Mr. Muggs Steps Out](https://www.imdb.com/title/tt0036175), [Block Busters](https://www.imdb.com/title/tt0036650)

 > Group 6:
[Against All Odds](https://www.imdb.com/title/tt3781588), [Mulatto](https://www.imdb.com/title/tt9486080), [The Jealous Mirror on My Wall](https://www.imdb.com/title/tt10992238), [Mirror on My Wall](https://www.imdb.com/title/tt10992240), [The Unholy Disciple](https://www.imdb.com/title/tt7406852), [Sodfather Spagatoni](https://www.imdb.com/title/tt6603156), [Desert Dick](https://www.imdb.com/title/tt9041734), [Right Before Your Eyes](https://www.imdb.com/title/tt5723462), [Monster On](https://www.imdb.com/title/tt10155862), [The Philly Mob](https://www.imdb.com/title/tt12102882)

 > Group 7:
[Billy the Kid in Texas](https://www.imdb.com/title/tt0032253), [Billy the Kid's Fighting Pals](https://www.imdb.com/title/tt0033393), [Billy the Kid's Range War](https://www.imdb.com/title/tt0033394), [Billy the Kid Outlawed](https://www.imdb.com/title/tt0162197), [Billy the Kid in Santa Fe](https://www.imdb.com/title/tt0033392), [Billy the Kid's Gun Justice](https://www.imdb.com/title/tt0135805), [Powdersmoke Range](https://www.imdb.com/title/tt0026886), [The Land of Missing Men](https://www.imdb.com/title/tt0021046), [Last of the Warrens](https://www.imdb.com/title/tt0027870), [Thundering Gun Slingers](https://www.imdb.com/title/tt0037375)

 > Group 8:
[The Summoned](https://www.imdb.com/title/tt0307526), [Meltdown](https://www.imdb.com/title/tt1637641), [Toad Warrior](https://www.imdb.com/title/tt0117930), [Untitled Horror Comedy](https://www.imdb.com/title/tt1454705), [Hawk Warrior of the Wheelzone](https://www.imdb.com/title/tt10612336), [Max Hell the Frog Warrior A Zen Silent Flick](https://www.imdb.com/title/tt12102214), [Body Count](https://www.imdb.com/title/tt0306582), [High on the Hog](https://www.imdb.com/title/tt2386668), [Soultaker](https://www.imdb.com/title/tt0100665), [Point Dume](https://www.imdb.com/title/tt0114150)

 > Group 9:
[The Lost Trail](https://www.imdb.com/title/tt0037883), [Gun Smoke](https://www.imdb.com/title/tt0037757), [The Navajo Trail](https://www.imdb.com/title/tt0037940), [Trigger Fingers](https://www.imdb.com/title/tt0039048), [Frontier Feud](https://www.imdb.com/title/tt0037719), [West of the Rio Grande](https://www.imdb.com/title/tt0037454), [Partners of the Trail](https://www.imdb.com/title/tt0037165), [Under Arizona Skies](https://www.imdb.com/title/tt0039063), [Flashing Guns](https://www.imdb.com/title/tt0039387), [Sheriff of Medicine Bow](https://www.imdb.com/title/tt0041868)

 > Group 10:
[I'm Not Me](https://www.imdb.com/title/tt12077330), [Confiscated Police Video](https://www.imdb.com/title/tt1839436), [Daddy...](https://www.imdb.com/title/tt5782038), [Creepers 'R Us](https://www.imdb.com/title/tt10305228), [Deputy Small Town](https://www.imdb.com/title/tt6941912), [Dog Sick](https://www.imdb.com/title/tt9511384), [Crippled Heart](https://www.imdb.com/title/tt1314649), [Casey's Cleaning](https://www.imdb.com/title/tt11150726), [Fear Me: Cold Blooded](https://www.imdb.com/title/tt8042072), [Halloween Party](https://www.imdb.com/title/tt5153502)

 > Group 11:
[When the Devil Rides Out](https://www.imdb.com/title/tt2464990), [Joe's War](https://www.imdb.com/title/tt3147284), [Welcome to America](https://www.imdb.com/title/tt0318176), [The Banksters, Madoff with America](https://www.imdb.com/title/tt1639081), [Born2Race](https://www.imdb.com/title/tt9537428), [Vail of Justice](https://www.imdb.com/title/tt5421618), [Six Days in Paradise](https://www.imdb.com/title/tt1405414), [Cross Wars](https://www.imdb.com/title/tt3592904), [Peter Pan, Land of Forever](https://www.imdb.com/title/tt7409674), [Wish Man](https://www.imdb.com/title/tt3246874)

 > Group 12:
[Slumber Party Slaughter Party 2](https://www.imdb.com/title/tt9169200), [PUTA: People for the Upstanding Treatment of Animals](https://www.imdb.com/title/tt1922682), [Aconite](https://www.imdb.com/title/tt0426629), [Greetings from Tromaville](https://www.imdb.com/title/tt7677184), [Grizzled!](https://www.imdb.com/title/tt4745692), [Terror Toons 4](https://www.imdb.com/title/tt4130510), [The Ungovernable Force](https://www.imdb.com/title/tt3628704), [The Beast Beneath](https://www.imdb.com/title/tt12395290), [Joel D. Wynkoop's Beast Mode](https://www.imdb.com/title/tt12663406), [Nowhere Man](https://www.imdb.com/title/tt0338294)

 > Group 13:
[Bells of Rosarita](https://www.imdb.com/title/tt0037535), [Along the Navajo Trail](https://www.imdb.com/title/tt0037509), [Lights of Old Santa Fe](https://www.imdb.com/title/tt0037018), [Man from Oklahoma](https://www.imdb.com/title/tt0037894), [Rainbow Over Texas](https://www.imdb.com/title/tt0038869), [Home in Oklahoma](https://www.imdb.com/title/tt0038611), [Don't Fence Me In](https://www.imdb.com/title/tt0037656), [Utah](https://www.imdb.com/title/tt0038212), [Heldorado](https://www.imdb.com/title/tt0038593), [My Pal Trigger](https://www.imdb.com/title/tt0038764)

</code><br/>

These clusters, similar to Chris's results, seem to have clustered better by both genre and decade. Here are approximate descriptions of each cluster:

1.  1920's dramas
2.  late 2010's to 2021 (unreleased) movies (mix of genres)
3.  1940's westerns
4.  1930's comedies/dramas
5.  1940's comedies
6.  late 2010's to 2021 crime/mysteries
7.  Billy the Kid Westerns (1930's to 1940's)
8.  1990's to 2000's horrors/thrillers
9.  More 1940's westerns
10. 2010's horrors/thrillers
11. 2010's action dramas
12. Niche 21st century horrors (like [this](https://www.imdb.com/title/tt12395290/) and [this](https://www.imdb.com/title/tt12395290/))
13. 1940's musical





