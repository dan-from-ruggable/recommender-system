# reads sql
getSQL <- function (filepath) {
  con = file(filepath, "r")
  sql.string <- ""
  while (TRUE){
    line <- readLines(con, n = 1)
    if ( length(line) == 0 ){
      break
    }
    line <- gsub("\\t", " ", line)
    if(grepl("--",line) == TRUE){
      line <- paste(sub("--","/*",line),"*/")
    }
    sql.string <- paste(sql.string, line)
  }
  close(con)
  return(sql.string)
}
# converts df to transactions
makeTransaction <- function (df) {
    items <- strsplit(as.character(df$products_purchased), ", ")
    transactions <- as(items, "transactions")
    return(transactions)
}