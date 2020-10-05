library(tidyverse)

# # read in data and convert columns
# principals =
#   read_tsv("data/title.principals.tsv.gz",na="\\N",quote="") %>% 
#   select(-c(ordering,job,characters)) %>% 
#   filter(category %in% c("self","actor","actress")) %>% 
#   mutate_if(is_character,as_factor) %>% 
#   select(-category)
# 
# # save result ot be easily loaded
# save(principals,file="data/principals.Rdata.xz",compress="xz",compression_level=9)

# load file
load("data/principals.Rdata.xz")

# check size
print(object.size(principals),units="Mb")
