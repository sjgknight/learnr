#pacman::p_load_gh("psyteachr/reprores-v2")


#reprores/book/ggplot.html


# And fork of excellent inteactives
download.file("https://github.com/sjgknight/cu-sipps-ggplot-aes/archive/refs/heads/main.zip", destfile = here::here("ex-eda/ggplot-learnr.zip"))

unzip(zipfile = here::here("ex-eda/ggplot-learnr.zip"), exdir = here::here("ex-eda/"))



download.file("https://github.com/rjknell-zz/exploratory/archive/refs/heads/master.zip", destfile = here::here("ex-eda/explor-learnr.zip"))

unzip(zipfile = here::here("ex-eda/explor-learnr.zip"), exdir = here::here("ex-eda/"))

