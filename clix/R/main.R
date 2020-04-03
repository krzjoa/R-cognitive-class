#!/usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
cat(paste0(args[1], " trolo"))

renv::init()
renv::install("data.table")
renv::install("infer")
renv::install("tidyselect")
renv::snapshot()
renv::install(normalizePath("../dlr/"))
dlr::graph()
