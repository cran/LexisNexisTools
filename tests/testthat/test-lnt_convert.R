context("LNToutput Conversion")

test_that("Convert LNToutput to data.frame", {
  expect_equal({
    lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                to = "data.frame",
                what = "Articles",
                collapse = TRUE)
  }, readRDS("../files/df.RDS"))
})

# saveRDS(lnt_convert(x = readRDS("../files/LNToutput.RDS"),
#                     to = "data.frame", what = "Articles", collapse = TRUE), "../files/df.RDS")

test_that("Convert LNToutput to rDNA", {
  expect_equal({
    test <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                        to = "rDNA",
                        what = "Articles",
                        collapse = TRUE)
    c(class(test), nrow(test), ncol(test))
  }, c("data.frame", "10", "10"))
  expect_equal({
    test <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                        to = "rDNA",
                        what = "Paragraphs")
    test$notes
  }, readLines("../files/rDNA_ids"))
  expect_warning({
    test <- readRDS("../files/LNToutput.RDS")
    test@meta$Date[1] <- NA
    test <- lnt_convert(x = test,
                        to = "rDNA")
  }, "One or more (or all) dates could not be converted to POSIXct. NA entries in 'date' were filled with the system's time and date instead.",
  fixed = TRUE)
})

# saveRDS(lnt_convert(x = readRDS("../files/LNToutput.RDS"),
#                     to = "rDNA", what = "Articles", collapse = TRUE), "../files/rDNA.RDS")


test_that("Convert LNToutput to quanteda", {
  expect_equal({
    corpus <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                          to = "quanteda", what = "Articles",
                          collapse = FALSE)
    list(class(corpus)[1], quanteda::ndoc(corpus))
  }, list("corpus", 10L))
  expect_equal({
    corpus <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                          to = "quanteda", what = "Paragraphs",
                          collapse = FALSE)
    list(class(corpus)[1], quanteda::ndoc(corpus))
  }, list("corpus", 122L))
  expect_equal({
    corpus <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                          to = "quanteda", what = "Articles",
                          collapse = TRUE)
    length(gregexpr("\n\n", as.character(corpus))[[1]])
  }, 4L)
  expect_equal({
    corpus <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                          to = "quanteda", what = "Articles",
                          collapse = "%%")
    length(gregexpr("%%", as.character(corpus))[[1]])
  }, 4L)
})

# corpus <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
#                       to = "quanteda", what = "Articles")
# corpus$metadata$created <- "Mon Jul  8 10:34:12 2019"
# corpus
# saveRDS(corpus, "../files/quanteda_1.5.RDS")

test_that("Convert LNToutput to corpustools", {
  skip_if_not_installed("corpustools")
  expect_equal({
    cptools <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                           to = "corpustools", what = "Articles")
    out <- list()
    out[[1]] <- class(cptools)
    out[[2]] <- cptools$get()
    out[[3]] <- cptools$get_meta()
  }, readRDS("../files/corpustools.RDS"))
  expect_equal({
    cptools <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                           to = "corpustools", what = "Paragraphs")
    c(class(cptools), length(unique(cptools$get()$doc_id)))
  }, c("tCorpus", "R6", "122"))
})

# saveRDS({
#   cptools <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
#                          to = "corpustools", what = "Articles")
#   out <- list()
#   out[[1]] <- class(cptools)
#   out[[2]] <- cptools$get()
#   out[[3]] <- cptools$get_meta()
# }, "../files/corpustools.RDS")

test_that("Convert LNToutput to tidytext", {
  skip_if_not_installed("tidytext")
  expect_equal({
    test <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                        to = "tidytext", what = "Paragraphs")
    list(class(test), 
         length(unique(test)), 
         length(unique(test$Art_ID)),
         length(unique(test$Par_ID)))
  }, list(c("tbl_df", "tbl", "data.frame"), 12L, 10L, 122L))
})

# saveRDS(lnt_convert(x = readRDS("../files/LNToutput.RDS"),
#                     to = "tidytext", what = "Articles"), "../files/tidytext.RDS")

test_that("Convert LNToutput to tm", {
  skip_if_not_installed("tm")
  expect_equal({
    lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                to = "tm", what = "Articles")
  }, readRDS("../files/tm.RDS"))
  expect_equal({
    test <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                         to = "tm",
                         what = "Articles",
                         collapse = TRUE)
    length(gregexpr("\n\n", test[["1"]][["content"]])[[1]])
  }, 4L)
  expect_equal({
    test <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                        to = "tm",
                        what = "Articles",
                        collapse = "%%")
    length(gregexpr("%%", test[["1"]][["content"]])[[1]])
  }, 4L)
  expect_equal({
    test <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                        to = "tm",
                        what = "Paragraphs")
    length(test)
  }, 122L)
})

# saveRDS(lnt_convert(x = readRDS("../files/LNToutput.RDS"),
#                     to = "tm", what = "Articles"), "../files/tm.RDS")

test_that("Convert LNToutput to SQLite", {
  skip_if_not_installed("RSQLite")
  skip_on_cran()
  expect_equal({
    tempf <- paste0(tempdir(), "/LNT.sqlite")
    conn <- lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                        to = "SQLite", what = "Articles",
                        file = tempf)
    
    conn2 <- RSQLite::dbConnect(conn)
    
    out <- list(class(conn2), basename(conn2@dbname), 
                RSQLite::dbListTables(conn2),
                nrow(RSQLite::dbReadTable(conn2, "meta")),
                nrow(RSQLite::dbReadTable(conn2, "paragraphs")))
    
    RSQLite::dbDisconnect(conn2)
    unlink(tempf)
    
    out
  }, list(structure("SQLiteConnection", package = "RSQLite"), "LNT.sqlite", 
          c("articles", "meta", "paragraphs"), 10L, 122L))
})

test_that("Test error messages", {
  expect_error({
    lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                to = "rDNA", what = "Article")
  }, "Choose either \"articles\" or \"paragraphs\" as what argument.", fixed = TRUE)
  expect_error({
    lnt_convert(x = readRDS("../files/LNToutput.RDS"),
                to = "quanteda", what = "Paragraph")
  }, "Choose either \"articles\" or \"paragraphs\" as what argument.", fixed = TRUE)
})

# saveRDS(conn, "../files/SQLite.RDS")


test_that("Convert LNToutput to bibtex", {
  expect_equal({
    test <- lnt2bibtex(x = readRDS("../files/LNToutput.RDS"),
                       art_id = 1)
    test
  }, readRDS("../files/bibtex.RDS"))
})

# saveRDS(test, "../files/bibtex.RDS")

teardown(unlink("../files/LNT.sqlite"))
