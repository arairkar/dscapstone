# load required packages
options(java.parameters = "-Xmx8g")

require(stringi)
require(quanteda)
require(data.table)

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

# read english language files and remove non-ASCII characters
en_us_twtr_txt <- 
        readLines("./final/en_US/en_US.twitter.txt",encoding = "UTF-8")
#en_us_twtr_txt <- iconv(en_us_twtr_txt, from = "UTF-8", to = "ASCII", sub = "")

en_us_blogs_txt <- 
        readLines("./final/en_US/en_US.blogs.txt",encoding = "UTF-8")
#en_us_blogs_txt <- 
#        iconv(en_us_blogs_txt, from = "UTF-8", to = "ASCII", sub = "")

en_us_news_txt <-
        readLines("./final/en_US/en_US.news.txt",encoding = "UTF-8")
#en_us_news_txt <- iconv(en_us_news_txt, from = "UTF-8", to = "ASCII", sub = "")

set.seed(1234)
sample_size <- .05

blogs_sample <- en_us_blogs_txt[sample(1:length(en_us_blogs_txt),
                                length(en_us_blogs_txt)*sample_size)]
news_sample <- en_us_news_txt[sample(1:length(en_us_news_txt),
                                length(en_us_news_txt)*sample_size)]
twtr_sample <- en_us_twtr_txt[sample(1:length(en_us_twtr_txt),
                                length(en_us_twtr_txt)*sample_size)]

txt_file <- c(blogs_sample,news_sample,twtr_sample)
txt_file <- iconv(txt_file,from = "UTF-8", to = "ASCII", sub = "")


rm(en_us_blogs_txt,en_us_news_txt,en_us_twtr_txt,
  blogs_sample,news_sample,twtr_sample)


toks <- tokens_tolower(tokens(txt_file,remove_numbers = TRUE, 
                                        remove_punct = TRUE,
                         remove_separators = TRUE,remove_url = TRUE,
                         remove_symbols = TRUE, remove_twitter = TRUE))

rm(txt_file)

fivegrams <- unlist(quanteda::tokens_ngrams(toks,n=5:5,concatenator=" "),
                    use.names = FALSE)
fivegrams_dt <- setDT(data.frame(table(
        fivegrams)))[,by = "fivegrams"][Freq>1][order(-Freq)]

droplevels(fivegrams_dt$fivegrams)
saveRDS(fivegrams_dt,file=
                paste0("fivegrams",as.character(sample_size*100),".rds"))
rm(fivegrams,fivegrams_dt)


# fourgrams <- unlist(quanteda::tokens_ngrams(toks,n=4:4,concatenator=" "),
#                     use.names = FALSE)
# fourgrams_dt <- setDT(data.frame(table(
#                         fourgrams)))[,by = "fourgrams"][Freq>1][order(-Freq)]
# 
# droplevels(fourgrams_dt$fourgrams)
# saveRDS(fourgrams_dt,file=
#         paste0("fourgrams",as.character(sample_size*100),".rds"))
# rm(fourgrams,fourgrams_dt)

# threegrams <- unlist(quanteda::tokens_ngrams(toks,n=3:3,concatenator=" "),
#                      use.names = FALSE)
# threegrams_dt <- setDT(data.frame(table(
#         threegrams)))[,by = "threegrams"][Freq>1][order(-Freq)]
# droplevels(threegrams_dt$threegrams)
# 
# saveRDS(threegrams_dt,file=
#                 paste0("threegrams",as.character(sample_size*100),".rds"))
# rm(threegrams,threegrams_dt)


rm(toks)





# twograms <- unlist(quanteda::tokens_ngrams(toks,n=2:2,concatenator = " "),
#                    use.names = FALSE)
# twograms_dt <- setDT(data.frame(table(
#         twograms)))[,by = "twograms"][Freq>1][order(-Freq)]
# droplevels(twograms_dt$twograms)
# saveRDS(twograms_dt,file=
#                 paste0("twograms",as.character(sample_size*100),".rds"))        
# rm(twograms,twograms_dt)
#head(fourgrams[grep("^would mean the", fourgrams[,1]),], 4)



