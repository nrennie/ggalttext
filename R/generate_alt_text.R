#' Generate Alt Text
#'
#' This function generates alternative text for ggplot objects.
#'
#' @param g A ggplot object.
#' @return A character string containing alternative text describing the input ggplot object.
#' @examples
#' library(ggplot2)
#' g1 <- ggplot(data = mtcars,
#'              mapping = aes(x = mpg,
#'                            y = disp)) +
#'   geom_point()
#' generate_alt_text(g1)
#' @export

generate_alt_text <- function(g) {
  if (!any(class(g) %in% c("gg", "ggplot"))) {
    stop("Input must an object of class 'gg' or 'ggplot'.")
  }
  # get list of geoms
  all_geoms <- sapply(g$layers, function(x) class(x$geom)[1])
  all_geoms <- tolower(stringr::str_remove(all_geoms, pattern = "Geom"))
  # what geoms are used
  if (length(all_geoms) == 0) {
    stop("No geoms have been added to the plot. Alt text cannot be generated.")
  } else {
    if (length(all_geoms) == 1) {
      geom_list <- paste0(all_geoms, "s")
    } else {
      x1 <- stringr::str_flatten(paste0(all_geoms[1:(length(all_geoms) - 1)], "s, "))
      geom_list <- paste0(x1, "and ", all_geoms[length(all_geoms)], "s")
    }
    # what's on each axis
    x_axis <- g$labels$x
    if (is.null(x_axis)) {
      x_axis <- stringr::str_remove(sub(".*-> ", "", g$mapping[1]),
                                    pattern = "~")
    }
    y_axis <- g$labels$y
    if (is.null(y_axis)) {
      y_axis <- stringr::str_remove(sub(".*-> ", "", g$mapping[2]),
                                    pattern = "~")
    }
    # create alt text
    alt_text <- glue::glue(ifelse(is.null(g$labels$title), "", paste0(g$labels$title, ". ")),
                           ifelse(is.null(g$labels$subtitle), "", g$labels$subtitle), " ",
                           "A plot with ",
                           x_axis,
                           " on the x-axis and ",
                           y_axis,
                           " on the y-axis. The data is displayed using ",
                           geom_list,
                           ". ",
                           ggplot2::get_alt_text(g) # stick extra alt text on the end if it exists
    )
    alt_text <- stringr::str_trim(alt_text)
    return(alt_text)
  }
}
