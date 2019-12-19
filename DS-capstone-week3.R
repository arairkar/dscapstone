# load required packages


require(ggplot2)
require(stringi)
require(tm)
require(NLP)
require(RWeka)
options(java.parameters = "-Xmx8g")
#load the input files and remove non-english versions
#


setwd("~/coursera/dscapstone")
if (!file.exists("./NLP.zip")){
        
        
        fileurl <- 
                "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
        
        download.file(fileurl,destfile="./NLP.zip",method="curl")
        if(!file.exists("./final")){unzip("./NLP.zip")
                unlink("./final/ru_RU",recursive=TRUE)
                unlink("./final/fi_FI",recursive=TRUE)
                unlink("./final/de_DE",recursive=TRUE)
        }
}

# read english language files

en_us_twtr_txt <- 
        readLines("./final/en_US/en_US.twitter.txt",encoding = "UTF-8")
en_us_blogs_txt <- 
        readLines("./final/en_US/en_US.blogs.txt",encoding = "UTF-8")
en_us_news_txt <-
        readLines("./final/en_US/en_US.news.txt",encoding = "UTF-8")

set.seed(1234)
sample_size <- 10000

blogs_sample <- en_us_blogs_txt[sample(1:length(en_us_blogs_txt),sample_size)]
news_sample <- en_us_news_txt[sample(1:length(en_us_news_txt),sample_size)]
twtr_sample <- en_us_twtr_txt[sample(1:length(en_us_twtr_txt),sample_size)]

txt_file <- c(blogs_sample,news_sample,twtr_sample)


txt_corpus <- tm::Corpus(tm::VectorSource(txt_file))

rm(en_us_blogs_txt,en_us_news_txt,en_us_twtr_txt,
   blogs_sample,news_sample,twtr_sample)

subSpace <- tm::content_transformer(function(x, pattern) gsub(pattern, 
                                                              " ", x))
txt_corpus <- tm::tm_map(txt_corpus, subSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
txt_corpus <- tm::tm_map(txt_corpus,subSpace,"“|–|—|=|=")
txt_corpus <- tm::tm_map(txt_corpus,removePunctuation)
txt_corpus <- tm::tm_map(txt_corpus,removeNumbers)
txt_corpus <- tm::tm_map(txt_corpus,tolower)
txt_corpus <- tm::tm_map(txt_corpus,stripWhitespace)
txt_corpus <- tm_map(txt_corpus, PlainTextDocument)


fourgrams <- RWeka::NGramTokenizer(txt_corpus, Weka_control(min=4,max=4))
fourgrams <- data.frame(table(fourgrams))
fourgrams <- fourgrams[order(fourgrams$Freq,decreasing = TRUE),]
head(fourgrams,5)


