---
title: Home
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

<img src="assets/img/icon.png" style="max-width:20%;min-width:40px;float:right;border-radius:50%;margin:5px;" alt="Github repo" />

# IMDB Center/Factor Analysis

_Authors: Bi Wu & Chris Kardatzke_

## Intro

We examined actors/movies data from IMDB ([`data download`](https://datasets.imdbws.com/) | [`data description`](https://www.imdb.com/interfaces/)). In particular, we were interested in 2 topics:

1. Degree centrality
2. Factor analysis

For sake of clarity, we omit directly quoting code. Readers interested in getting into the weeds should consult the [Github repo](https://github.com/bwu62/992Project).

## Preprocessing

Before we jump into the analyses, we first discuss the preprocessing done. We were primarily interested in movies typically played in theaters or streamed online, not television shows, web shorts, or adult content (all of which is included in the IMDB data download), so these were filtered out.

Basically all actors and movies (>99.9%) were in one large connected component, with a small smattering of other niche/amateur/independent content in numerous smaller disconnected components. These were filtered out too.

Our final dataset contains ~605k actors and 463k movies.

## Centrality

[Frigyes Karithny](https://en.wikipedia.org/wiki/Frigyes_Karinthy) is widely credited as the originator of the [six degrees of separation](https://en.wikipedia.org/wiki/Six_degrees_of_separation) hypothesis that in social networks, any two arbitrary persons can be connected by 6 edge traversals in the network. This was influential in popular culture, inspiring popular [films](https://en.wikipedia.org/wiki/Six_Degrees_of_Separation_(film)), [shows](https://en.wikipedia.org/wiki/Six_Degrees_(TV_series)), and [music](https://www.youtube.com/watch?v=FCT6Mu-pOeE).

One popular spinoff conjecture known was that everyone in Hollywood can be linked to [Kevin Bacon](https://en.wikipedia.org/wiki/Kevin_Bacon) in [six or fewer film roles](https://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon). This inspired us to use degrees as a centrality measure and try to identify the "center" of our IMDB network.

Using [`igraph`](https://igraph.org/), we constructed a graph from our edge list data frame based on costar relationships. First, we decided to see how connected people are to Bacon by computing everyone's distance to him in the network, referred to as their bacon numbers. We found a mean degrees of separation of **4.301**. Below is a histogram of these distances.

<p><img class="plots" src="assets/img/bacon.svg" alt="Bacon numbers"/></p>

Next, we wanted to see if we could find a better center of the network. We setup parallelized jobs to traverse the top 5000 most-connected actors in the network (below this number, actors have so few connections that it's inconceivable they could be the most central) and computed their distance to everyone else in the network.

Using this as our measure of centrality, we found [Eric Roberts](https://en.wikipedia.org/wiki/Eric_Roberts) (brother of [Julia Roberts](https://en.wikipedia.org/wiki/Julia_Roberts) and father of [Emma Roberts](https://en.wikipedia.org/wiki/Emma_Roberts)) to be the most connected, with a mean degrees of separation of just **3.905**. Below is a histogram of these distances.

<p><img class="plots" src="assets/img/roberts.svg" alt="Roberts numbers"/></p>

Here is a side by side plot for comparison.

<p><img class="plots" src="assets/img/bacon-roberts.svg" alt="Comparison of Bacon and Roberts numbers"/></p>

## Factor Analysis

The second thing we were interested in was whether we could use factor analysis to identify genre clusters in an unsupervised way simply by examining costar relationships, without any kind of external genre data or sentiment analysis. We decided to use [Karl Rohe](http://pages.stat.wisc.edu/~karlrohe/)'s [`vsp`](https://github.com/RoheLab/vsp) package due to its speed and ease of use.

We constructed a very sparse (99.999% sparsity) incidence matrix from our edge list and used the `vsp` function with `k=100` as an initial trial. After checking the scree plot, `k=20` was determined to be a suitable size. Using the `bff` function to pick out the 10 best features in each cluster, we get the following groups (a few groups were omitted to reduce verbosity):

<br/>



<code>

 > Group 1:
[Jin shang tian hua](https://www.imdb.com/title/tt3590664), [Jigong Huofo](https://www.imdb.com/title/tt3471862), [Wangfu Shan](https://www.imdb.com/title/tt3554940), [Xin Qingnian](https://www.imdb.com/title/tt3298660), [Romance of the Pearl River](https://www.imdb.com/title/tt3362794), [Zhuang Zi Shi Qi](https://www.imdb.com/title/tt3433664), [Zhoushi Fanjia](https://www.imdb.com/title/tt3407004), [Pipa Xing](https://www.imdb.com/title/tt3407058), [Duanchang Hua](https://www.imdb.com/title/tt3590638), [The Swordswoman of the Wild River: Against the Han Clan](https://www.imdb.com/title/tt3477954)

 > Group 2:
[Ushiwakamarû](https://www.imdb.com/title/tt1050218), [Sûmidagawa no adauchi](https://www.imdb.com/title/tt1109638), [Aizu no Kotetsu](https://www.imdb.com/title/tt1089609), [Ôokubo hikozaemon](https://www.imdb.com/title/tt1121068), [Setta naoshi Chôgorô](https://www.imdb.com/title/tt1062963), [Owari daihachi](https://www.imdb.com/title/tt1075372), [Ôniwaka kurô edojô arashi](https://www.imdb.com/title/tt1075100), [Kana tehon chûsinghura](https://www.imdb.com/title/tt1089695), [Araki mataemon](https://www.imdb.com/title/tt1106741), [Sendai hagi](https://www.imdb.com/title/tt1116825)

 > Group 3:
[Takip](https://www.imdb.com/title/tt0183858), [The Sugar Almonds](https://www.imdb.com/title/tt0263094), [Kafkas kartali](https://www.imdb.com/title/tt0345475), [The Armless Hero](https://www.imdb.com/title/tt0418802), [Ölüm görevi](https://www.imdb.com/title/tt0183598), [Babanin suçu](https://www.imdb.com/title/tt0182754), [Cehennem arkadaslari](https://www.imdb.com/title/tt0398841), [The Endless Struggle](https://www.imdb.com/title/tt0306557), [Bitter Love](https://www.imdb.com/title/tt0263030), [Silahli pasazade](https://www.imdb.com/title/tt0431400)

 > Group 4:
[O Caso do Senhor Vestido de Violeta](https://www.imdb.com/title/tt6977646), [As Alegres Comadres de Windsor](https://www.imdb.com/title/tt6760116), [O Camões do Rossio](https://www.imdb.com/title/tt6557304), [Sinos de Natal](https://www.imdb.com/title/tt6897332), [A Janela Fechada](https://www.imdb.com/title/tt6553802), [Uma Noite de Paz](https://www.imdb.com/title/tt6549890), [Chocolate á Espanhola](https://www.imdb.com/title/tt6550862), [O Feitiço da Vovó](https://www.imdb.com/title/tt6583714), [Os Terríveis](https://www.imdb.com/title/tt6997866), [Música no Andar de Cima](https://www.imdb.com/title/tt6865766)

 > Group 5:
[Naya Bakra](https://www.imdb.com/title/tt0328177), [Dhoti Lota Aur Chowpatty](https://www.imdb.com/title/tt0315487), [Aap Beati](https://www.imdb.com/title/tt0178194), [Pyar Ki Rahen](https://www.imdb.com/title/tt0381521), [Shareef Budmaash](https://www.imdb.com/title/tt0232626), [Hunterwali 77](https://www.imdb.com/title/tt2679238), [Lootmaar](https://www.imdb.com/title/tt0154788), [Angaare](https://www.imdb.com/title/tt0376483), [Laakho Vanzaro](https://www.imdb.com/title/tt9556410), [Bedard Zamana Kya Jane](https://www.imdb.com/title/tt0242307)

 > Group 6:
[Koi no Tsumako](https://www.imdb.com/title/tt3730290), [Kyôenrokû](https://www.imdb.com/title/tt3722818), [Ryôen Rokû](https://www.imdb.com/title/tt3722918), [Kuroshio](https://www.imdb.com/title/tt0183375), [Akînosuke to ôsumi](https://www.imdb.com/title/tt1180716), [Aki no koe sannin shoi](https://www.imdb.com/title/tt1178086), [Kobonno](https://www.imdb.com/title/tt3724656), [Koi no Gisei](https://www.imdb.com/title/tt3730244), [Chichiyâ No Mûsume](https://www.imdb.com/title/tt3724520), [Onna no chikai](https://www.imdb.com/title/tt1047508)

 > Group 7:
[Insaan Ik Tamasha](https://www.imdb.com/title/tt2956242), [Khandan](https://www.imdb.com/title/tt1332538), [Dil Da Jani](https://www.imdb.com/title/tt1538255), [Aakhri Dao](https://www.imdb.com/title/tt1407130), [Angara](https://www.imdb.com/title/tt1207626), [Bhai Bhai](https://www.imdb.com/title/tt2956176), [Eid Da Chann](https://www.imdb.com/title/tt2956008), [Taj Mahal](https://www.imdb.com/title/tt1702607), [Imam Din Gohavia](https://www.imdb.com/title/tt1538307), [Jigri Yaar](https://www.imdb.com/title/tt1538314)

 > Group 8:
[Konkurrencen](https://www.imdb.com/title/tt2372288), [John Redmond, the Evangelist](https://www.imdb.com/title/tt0127544), [Hvorledes jeg kom til Filmen](https://www.imdb.com/title/tt2276404), [Pigen fra Klubben](https://www.imdb.com/title/tt2414986), [Den Æreløse](https://www.imdb.com/title/tt2275782), [Mit Fædreland, min Kærlighed](https://www.imdb.com/title/tt2371328), [The Great Circus Catastrophe](https://www.imdb.com/title/tt0002153), [Den sidste Nat](https://www.imdb.com/title/tt2369654), [Manden med de ni Fingre IV](https://www.imdb.com/title/tt2412162), [Cowboymillionæren](https://www.imdb.com/title/tt0127494)

 > Group 9:
[Dui Bari](https://www.imdb.com/title/tt1593671), [Asamapta](https://www.imdb.com/title/tt1582470), [Adarsha Hindu Hotel](https://www.imdb.com/title/tt0321079), [Agnisikha](https://www.imdb.com/title/tt1584007), [Surya Toran](https://www.imdb.com/title/tt0152702), [Kancha-Mithey](https://www.imdb.com/title/tt1582520), [Khela Bhangar Khela](https://www.imdb.com/title/tt1593710), [High Heel](https://www.imdb.com/title/tt1565019), [Ogo Shunchho](https://www.imdb.com/title/tt1534479), [Rani Rashmoni](https://www.imdb.com/title/tt0215115)

 > Group 10:
[Wenn du Geld hast](https://www.imdb.com/title/tt11650350), [Willems Vermächtnis](https://www.imdb.com/title/tt0190147), [Die Königin von Honolulu](https://www.imdb.com/title/tt0339272), [Tratsch im Treppenhaus](https://www.imdb.com/title/tt0219362), [Mutter steht ihren Mann](https://www.imdb.com/title/tt1495879), [Strandräuber](https://www.imdb.com/title/tt1508341), [Das Herrschaftskind](https://www.imdb.com/title/tt0183161), [Der Winkeladvokat](https://www.imdb.com/title/tt1346326), [Und oben wohnen Engels](https://www.imdb.com/title/tt1516139), [Nichts gegen Frauen](https://www.imdb.com/title/tt0352637)

 > Group 11:
[Anbalipu](https://www.imdb.com/title/tt0290415), [Anjal Petty 520](https://www.imdb.com/title/tt1440120), [Thiruvarutselvar](https://www.imdb.com/title/tt0246985), [Gurudakshinai](https://www.imdb.com/title/tt0246666), [Enga Ooru Raja](https://www.imdb.com/title/tt1440165), [Thayin Madiyil](https://www.imdb.com/title/tt1475421), [Kumkumam](https://www.imdb.com/title/tt0234061), [En Kadamai](https://www.imdb.com/title/tt1475358), [Paladai](https://www.imdb.com/title/tt0156863), [Thaye Unakkaga](https://www.imdb.com/title/tt0256431)

 > Group 12:
[Chhota Bheem and the Broken Amulet](https://www.imdb.com/title/tt6417816), [Chhota Bheem and the ShiNobi Secret](https://www.imdb.com/title/tt6417830), [Chhota Bheem aur Hanuman](https://www.imdb.com/title/tt6417854), [Chhota Bheem Aur Mayavi Gorgan](https://www.imdb.com/title/tt6417868), [Chhota Bheem Banjara Masti](https://www.imdb.com/title/tt6417876), [Chhota Bheem Krishna vs Zimbara](https://www.imdb.com/title/tt6417984), [Bheem vs Aliens](https://www.imdb.com/title/tt6442436), [Chhota Bheem Neeli Pahaadi](https://www.imdb.com/title/tt6442694), [Chhota Bheem Paanch Ajoobe](https://www.imdb.com/title/tt6442758), [Chhota Bheem the Crown of Valhalla](https://www.imdb.com/title/tt6442766)

 > Group 13:
[Ta tria paidia Voliotika](https://www.imdb.com/title/tt0135688), [Alygisti sti zoi](https://www.imdb.com/title/tt0252842), [To megalo amartima](https://www.imdb.com/title/tt0232075), [They Can't Keep Us Apart](https://www.imdb.com/title/tt0255101), [Einai megalos o kaimos](https://www.imdb.com/title/tt0135409), [Thimios in the Land of Striptease](https://www.imdb.com/title/tt0237825), [Maria Pentagiotissa](https://www.imdb.com/title/tt0135540), [Apokliroi tis koinonias](https://www.imdb.com/title/tt0231167), [Prodomeni](https://www.imdb.com/title/tt0288766), [Klapse, ftohi mou kardia](https://www.imdb.com/title/tt0263574)

</code><br/>

The code is clearly picking out films purely based on language/country of origin. Following the instructor's suggestion, we decided to subset the data further to select only titles made in the US and with in no language other than English. Running `vsp`, choosing `k=8` based on the scree plot, and then rerunning `vsp` followed by `bff` gives the following clusters.

<br/><code class="fa-links">

 > Group 1:
[The Last Hour](https://www.imdb.com/title/tt0014187), [Free and Equal](https://www.imdb.com/title/tt0015839), [This Hero Stuff](https://www.imdb.com/title/tt0010772), [His Last Race](https://www.imdb.com/title/tt0014135), [Danger, Go Slow](https://www.imdb.com/title/tt0008993), [The Thundering Herd](https://www.imdb.com/title/tt0016430), [Murder Will Out](https://www.imdb.com/title/tt0021163), [Flesh and Blood](https://www.imdb.com/title/tt0013134), [The Daredevil](https://www.imdb.com/title/tt0010046), [Peg o' My Heart](https://www.imdb.com/title/tt0338339)

 > Group 2:
[H20: Hustlemania](https://www.imdb.com/title/tt11975170), [H20: Opportunity Knocks](https://www.imdb.com/title/tt11975316), [H20: Hardcore Kingdom 2](https://www.imdb.com/title/tt11975086), [H20: The Best of Subterranean Violence: Volumes 1-666](https://www.imdb.com/title/tt12137914), [H20: Hustlepalooza](https://www.imdb.com/title/tt10675494), [H20: Sweet Dreams](https://www.imdb.com/title/tt11975122), [H20: Written in Blood](https://www.imdb.com/title/tt11975686), [CZW: Tournament of Death XV](https://www.imdb.com/title/tt12375684), [CZW: Tournament of Death 16](https://www.imdb.com/title/tt12375698), [H20: Blood Money](https://www.imdb.com/title/tt11974892)

 > Group 3:
[Blondie's Lucky Day](https://www.imdb.com/title/tt0038368), [Blondie's Anniversary](https://www.imdb.com/title/tt0039201), [Blondie's Secret](https://www.imdb.com/title/tt0040174), [Blondie](https://www.imdb.com/title/tt0029927), [Blondie Brings Up Baby](https://www.imdb.com/title/tt0031106), [Blondie Takes a Vacation](https://www.imdb.com/title/tt0031108), [Blondie Has Servant Trouble](https://www.imdb.com/title/tt0032261), [Blondie Plays Cupid](https://www.imdb.com/title/tt0032262), [Blondie on a Budget](https://www.imdb.com/title/tt0032263), [Blondie Goes Latin](https://www.imdb.com/title/tt0033403)

 > Group 4:
[Bells of Rosarita](https://www.imdb.com/title/tt0037535), [Song of Arizona](https://www.imdb.com/title/tt0038968), [Man from Oklahoma](https://www.imdb.com/title/tt0037894), [Heart of the Golden West](https://www.imdb.com/title/tt0034832), [Along the Navajo Trail](https://www.imdb.com/title/tt0037509), [Bandits of Dark Canyon](https://www.imdb.com/title/tt0039173), [Home in Oklahoma](https://www.imdb.com/title/tt0038611), [Lights of Old Santa Fe](https://www.imdb.com/title/tt0037018), [Rainbow Over Texas](https://www.imdb.com/title/tt0038869), [Sunset in El Dorado](https://www.imdb.com/title/tt0038136)

 > Group 5:
[Before the Movies](https://www.imdb.com/title/tt2839014), [The Amulet](https://www.imdb.com/title/tt1915606), [The Best Movie Ever](https://www.imdb.com/title/tt2111444), [ASRM: The Show](https://www.imdb.com/title/tt2122269), [ASRM: Short Films](https://www.imdb.com/title/tt2145535), [GoldenEar](https://www.imdb.com/title/tt2195939), [The Man-Hunt](https://www.imdb.com/title/tt2407870), [Two Missions](https://www.imdb.com/title/tt3154890), [The Last Magic Act](https://www.imdb.com/title/tt3179284), [Artwork](https://www.imdb.com/title/tt4557668)

 > Group 6:
[Prank Calls: Video Collection](https://www.imdb.com/title/tt1929348), [Prank Calls: 50th Call Anniversary](https://www.imdb.com/title/tt3303148), [Prank Calls: Return of the King](https://www.imdb.com/title/tt4513078), [Phillip: The Movie](https://www.imdb.com/title/tt4042020), [Take Me Back: Greatest So Far...](https://www.imdb.com/title/tt5886236), [The Virgins](https://www.imdb.com/title/tt3496286), [Forgotten Hero](https://www.imdb.com/title/tt2672326), [Ten Dollar Bill](https://www.imdb.com/title/tt3247852), [Camp Harlow](https://www.imdb.com/title/tt3184648), [The Pastor and the Pro](https://www.imdb.com/title/tt7952840)

 > Group 7:
[RiffTrax Live: Night of the Shorts IV - SF Sketchfest 2016](https://www.imdb.com/title/tt6740544), [RiffTrax Live: Night of the Shorts SF Sketchfest 2013](https://www.imdb.com/title/tt3154342), [RiffTrax Live: Night of the Shorts, A Good Day to Riff Hard - SF Sketchfest 2015](https://www.imdb.com/title/tt6745170), [RiffTrax Live: House on Haunted Hill](https://www.imdb.com/title/tt2027202), [RiffTrax Live: Plan 9 from Outer Space](https://www.imdb.com/title/tt2145853), [Rifftrax: Order in the Shorts](https://www.imdb.com/title/tt6361584), [RiffTrax: High School Musical](https://www.imdb.com/title/tt10263222), [RiffTrax: The Hunger Games](https://www.imdb.com/title/tt10321126), [RiffTrax: Star Wars: The Force Awakens](https://www.imdb.com/title/tt10321138), [RiffTrax: Captain America: The First Avenger](https://www.imdb.com/title/tt10322272)

 > Group 8:
[The Days of Noah Part 3: The Valley of Decision](https://www.imdb.com/title/tt10887266), [The Days of Noah Part 4: Ark of Fire](https://www.imdb.com/title/tt10887286), [The Days of Noah: Judgment Hour](https://www.imdb.com/title/tt9647732), [The Days of Noah: The Flood](https://www.imdb.com/title/tt9647706), [Kingdoms in Time](https://www.imdb.com/title/tt8362562), [Is Genesis History?](https://www.imdb.com/title/tt6360332), [The Creation: Faith, Science, Intelligent Design](https://www.imdb.com/title/tt1832487), [Charmed by Darkness](https://www.imdb.com/title/tt11898048), [Genesis: Paradise Lost](https://www.imdb.com/title/tt7522002), [All Aboard](https://www.imdb.com/title/tt10555608)

</code><br/>

Now, we seem to be getting clusters around genres/topics. Here is a list of cursory guesses of the topics based on glancing at the highlighted titles:

1. Mystery/drama?
1. Wrestling ([`Twitter`](https://twitter.com/h_2_0wrestling)|[`YouTube`](https://www.youtube.com/channel/UCFmWdHVzsf1aTl8X6vZbRTg)).
1. [Blondie movies](https://en.wikipedia.org/wiki/Blondie_(film_series)).
1. Westerns.
1. Various independent movies all written & directed by and starring [Ryan Konig](https://www.imdb.com/name/nm4344986) and [Sean Konig](https://www.imdb.com/name/nm4345041).
1. Various comedies involving [Chris Rex](https://www.imdb.com/name/nm3979912), [Cody Burns](https://www.imdb.com/name/nm3979887), and some other people.
1. [RiffTrax](https://en.wikipedia.org/wiki/RiffTrax) releases ("humorous audio commentary tracks" played over other movies/shows).
1. Christian "documentaries".

It seems like certain niche groups tend to release a lot of titles involving the exact same group of cast/crew, and these are easily picked up by `vsp`. However, entire genres involve too many different people, so they're not as easily identified.

Even though we weren't able to identify genres, the results of this analysis (to me at least) are still pretty fascinating. A lot of these topics/titles I've honestly never heard of before, and it's cool to see `vsp` identifying them and grouping them all together.

## What's next?

We are in the process of developing a plan for further analysis to improve the quality of the clusters. See our project proposal [here](https://bwu62.github.io/992Project/proposal).

### Acknowledgement

We'd like to thank the instructor Karl Rohe for providing us with valuable feedback throughout the course of this investigation.


