# Main object to store all the session objects
dl.session <- new.env()

# Config
dl.config <- list(device = 'default')
class(dl.config) <- 'dl_config'
dl.session$dl.config <- dl.config


identify_system <- function(){
  sys.info <- as.list(Sys.info())
  sys.info$sysname
}

#' @title Show devices available to run DL
#' @name show_devices
#' @description Aim of this function is to show full list of devices, that
#' may be used to run functions from this package
show_devices <- function(){
  
  devices <- data.frame()
  
  # Get available CPUs
  if(identify_system() == 'Linux'){
    identifiers <- paste0('CPU', system('cat /proc/cpuinfo | grep processor', intern = TRUE))
    model.names <- system('cat /proc/cpuinfo | grep "model name"', intern = TRUE)
    devices <- rbind(devices, list(model.name = model.names, id = identifiers))
  }
  
  # Get available GPUs 
  # Not implemented yet
  
  
}