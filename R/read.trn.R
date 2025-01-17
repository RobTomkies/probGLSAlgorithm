#' Read in data from BAS/Biotrack devices
#'
#' Transforms biotrack or BAS .trn files into a data frame with tFirst, tSecond and type.
#'
#' @param trnfile The name of a file downloaded from a BAS/Biotrack device
#'
#' @import GeoLight
#'
#'
#' @export

read.trn <- function(trnfile) {
  data <- read.table(trnfile, sep = ",")
  tFirst <- vector("numeric", length = (length(data[, 1]) - 1))
  tSecond <- vector("numeric", length = (length(data[, 1]) - 1))
  type <- vector("numeric", length = (length(data[, 1]) - 1))

  for (i in 1:(length(data[, 1]) - 1)) {
    date1 <- as.Date(substr(as.character(data$V1[i]), 1, 8), format = "%d/%m/%y")
    tFirst[i] <- as.POSIXct(paste(as.character(date1), prefix = substr(as.character(data$V1[i]), 10, 17)), tz = "UTC")
    date2 <- as.Date(substr(as.character(data$V1[i + 1]), 1, 8), format = "%d/%m/%y")
    tSecond[i] <- as.POSIXct(paste(as.character(date2), prefix = substr(as.character(data$V1[i + 1]), 10, 17)), tz = "UTC")
    if (as.character(data$V2[i]) == "Sunrise") {
      type[i] <- 1
    } else if (as.character(data$V2[i]) == "Sunset") {
      type[i] <- 2
    } else {
      stop("Data is an inconsistent format. The third column should only contain the values Sunrise and Sunset.")
    }
  }


  output <- data.frame(tFirst = as.POSIXlt(tFirst, origin = "1970-01-01", tz = "UTC"),
                       tSecond = as.POSIXlt(tSecond, origin = "1970-01-01", tz = "UTC"),
                       type = type)
  return(output)
}
