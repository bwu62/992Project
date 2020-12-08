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
[The Beast Beneath](https://www.imdb.com/title/tt12395290)
[Arachnado](https://www.imdb.com/title/tt12429968)
[Ghosthouse](https://www.imdb.com/title/tt8633640)
[RoboWoman 2](https://www.imdb.com/title/tt10079052)
[Celluloid Slaughter](https://www.imdb.com/title/tt10079028)
[Tales from the Campfire 3](https://www.imdb.com/title/tt11724312)
[Los Angeles Shark Attack](https://www.imdb.com/title/tt10078904)
[With Child](https://www.imdb.com/title/tt12401036)
[With Child](https://www.imdb.com/title/tt12401536)
[House of Pain](https://www.imdb.com/title/tt9200668) 

Group  3 :
[Dark Cupid](https://www.imdb.com/title/tt3695684)
[Snare](https://www.imdb.com/title/tt3713392)
[Dark Moon Rising](https://www.imdb.com/title/tt3155734)
[Beyond the Game](https://www.imdb.com/title/tt3546678)
[Terror of the Soul](https://www.imdb.com/title/tt3831118)
[Hunting Season](https://www.imdb.com/title/tt4946336)
[Black Wake](https://www.imdb.com/title/tt4839118)
[7 Deadly Sins](https://www.imdb.com/title/tt5478746)
[Exposure](https://www.imdb.com/title/tt11075800)
[The Immortal Wars](https://www.imdb.com/title/tt5259598) 

Group  4 :
[Pharaoh's Bread](https://www.imdb.com/title/tt6744796)
[Spending Thanksgiving with the Moretti's](https://www.imdb.com/title/tt6083734)
[The Impact Factor](https://www.imdb.com/title/tt6234136)
[The Unholy Disciple](https://www.imdb.com/title/tt7406852)
[Mulatto](https://www.imdb.com/title/tt9486080)
[Against All Odds](https://www.imdb.com/title/tt3781588)
[The Philly Mob](https://www.imdb.com/title/tt12102882)
[Proximity to Power](https://www.imdb.com/title/tt4352370)
[What They Let In](https://www.imdb.com/title/tt4701402)
[The Jealous Mirror on My Wall](https://www.imdb.com/title/tt10992238) 

Group  5 :
[Blondie's Lucky Day](https://www.imdb.com/title/tt0038368)
[Blondie's Anniversary](https://www.imdb.com/title/tt0039201)
[Blondie's Secret](https://www.imdb.com/title/tt0040174)
[Blondie](https://www.imdb.com/title/tt0029927)
[Blondie Brings Up Baby](https://www.imdb.com/title/tt0031106)
[Blondie Takes a Vacation](https://www.imdb.com/title/tt0031108)
[Blondie Has Servant Trouble](https://www.imdb.com/title/tt0032261)
[Blondie Plays Cupid](https://www.imdb.com/title/tt0032262)
[Blondie on a Budget](https://www.imdb.com/title/tt0032263)
[Blondie Goes Latin](https://www.imdb.com/title/tt0033403) 

Group  6 :
[Bandits of Dark Canyon](https://www.imdb.com/title/tt0039173)
[Frontier Investigator](https://www.imdb.com/title/tt0041392)
[Desperadoes of Dodge City](https://www.imdb.com/title/tt0040286)
[Heart of the Golden West](https://www.imdb.com/title/tt0034832)
[Bells of Rosarita](https://www.imdb.com/title/tt0037535)
[Marshal of Cedar Rock](https://www.imdb.com/title/tt0046049)
[Marshal of Amarillo](https://www.imdb.com/title/tt0040574)
[Oklahoma Badlands](https://www.imdb.com/title/tt0040659)
[Sundown in Santa Fe](https://www.imdb.com/title/tt0040850)
[The Bold Frontiersman](https://www.imdb.com/title/tt0040180) 

Group  7 :
[Ole Bryce](https://www.imdb.com/title/tt6953036)
[Terror of the Soul](https://www.imdb.com/title/tt3831118)
[Hunting Season](https://www.imdb.com/title/tt4946336)
[The Immortal Wars](https://www.imdb.com/title/tt5259598)
[Black Wake](https://www.imdb.com/title/tt4839118)
[7 Deadly Sins](https://www.imdb.com/title/tt5478746)
[When the Devil Rides Out](https://www.imdb.com/title/tt2464990)
[The Acquirer](https://www.imdb.com/title/tt3709472)
[Welcome to America](https://www.imdb.com/title/tt0318176)
[The Banksters, Madoff with America](https://www.imdb.com/title/tt1639081) 

Group  8 :
[Aconite](https://www.imdb.com/title/tt0426629)
[Killer Babes and the Frightening Film Fiasco](https://www.imdb.com/title/tt10012002)
[Dinner with Leatherface](https://www.imdb.com/title/tt5862740)
[VampireS](https://www.imdb.com/title/tt12799846)
[Slumber Party Slaughter Party 2](https://www.imdb.com/title/tt9169200)
[Greetings from Tromaville](https://www.imdb.com/title/tt7677184)
[Terror Toons 4](https://www.imdb.com/title/tt4130510)
[The Legend of Six Fingers](https://www.imdb.com/title/tt2989580)
[Meltdown](https://www.imdb.com/title/tt1637641)
[One Month Out](https://www.imdb.com/title/tt6149768) 
