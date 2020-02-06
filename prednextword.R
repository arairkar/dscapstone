library(quanteda)
library(stringi)
threegrams <-
        readRDS("data/threegrams30.rds")
fourgrams <-
        readRDS("data/fourgrams30.rds")
fivegrams <-
        readRDS("data/fivegrams30.rds")

prednextword <- function (inputtxt) {
        nextwords <- as.character("")
        srch <- unlist(tokens_tolower(
                        tokens(
                                inputtxt,
                                remove_numbers = TRUE,
                                remove_punct = TRUE,
                                remove_separators = TRUE,
                                remove_url = TRUE,
                                remove_symbols = TRUE,
                                remove_twitter = TRUE
                )))
        
        if (length(srch) > 1) {
                if (length(srch) > 2) {
                        if (length(srch) > 3) {
                                searchtxt4 <- paste0("^",
                                                     srch[length(srch) - 3],
                                                     " ",
                                                     srch[length(srch) - 2],
                                                     " ",
                                                     srch[length(srch) - 1],
                                                     " ",
                                                     srch[length(srch)],
                                                     " ")
                                
                        }
                        searchtxt3 <- paste0("^",
                                             srch[length(srch) - 2], " ",
                                             srch[length(srch) - 1], " ",
                                             srch[length(srch)], " ")
                }
                searchtxt2 <- paste0("^",
                                     srch[length(srch) - 1], " ",
                                     srch[length(srch)], " ")
        }
        
        
        
        
        if (exists("searchtxt4")) {
                fivepred <- fivegrams[grep(searchtxt4, fivegrams)][1, 1]
                fivepred <-
                        stri_extract_last_words(as.character(fivepred[[1]]))
                if (!is.na(fivepred)) {
                        nextwords <- fivepred
                        #cat(paste0(fivepred," "))
                }
        }
        if (exists("searchtxt3")) {
                fourpred <- fourgrams[grep(searchtxt3, fourgrams)][1, 1]
                fourpred <-
                        stri_extract_last_words(as.character(fourpred[[1]]))
                if (exists("searchtxt4") &&
                    identical(fourpred,fivepred)) {
                        fourpred <- fourgrams[grep(searchtxt3, fourgrams)][2, 1]
                        fourpred <-
                                stri_extract_last_words(as.character(
                                        fourpred[[1]]))
                }
                if (!is.na(fourpred)) {
                        
                        if(nextwords==""){nextwords <- fourpred}
                        else{nextwords <- paste0(nextwords,", ",fourpred)}
                }
        }
        if (exists("searchtxt2")) {
                threepred <- threegrams[grep(searchtxt2, threegrams)][1, 1]
                threepred <-
                        stri_extract_last_words(as.character(
                                threepred[[1]]))
                if (exists("searchtxt4") &&
                    identical(threepred,fivepred)) {
                        threepred <- threegrams[grep(
                                searchtxt2, threegrams)][2, 1]
                        threepred <-
                                stri_extract_last_words(as.character(
                                        threepred[[1]]))
                }
                if (exists("searchtxt3") &&
                    identical(threepred,fourpred)) {
                        threepred <- threegrams[grep(
                                searchtxt2, threegrams)][3, 1]
                        threepred <-
                                stri_extract_last_words(as.character(
                                        threepred[[1]]))  
                }
                
                if (!is.na(threepred)) {
                        if(nextwords=="") {nextwords <- threepred}
                        
                           else{nextwords <- paste0(nextwords,", ",threepred)}
                        
                }
                
        
        }
        
if(nextwords=="") {return("Please enter more words for better prediction")}
        else{return(nextwords)}
}

#print("threegrams")
#print(searchtxt3)
#head(threegrams[grep(searchtxt3,threegrams),1],1)
#print("twograms")
#print(searchtxt2)
#head(twograms[grep(searchtxt2,twograms),1],1)
#fourgrams[grep("^the end of ",fourgrams)][1,1]
#predtxt <- strsplit(as.character(fourgrams[grep("^the end of ",fourgrams)][[1,1]]),split=" ")[[1]]
#predtxt[length(predtxt)]