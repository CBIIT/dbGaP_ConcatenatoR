#!/usr/bin/env Rscript

#dbGaP_ConcatenatoR.R


##################
#
# USAGE
#
##################

#This script takes two directories of dbGaP submission files and combine them into one submission file packet.

#Run the following command in a terminal where R is installed for help.

#Rscript --vanilla dbGaP_ConcatenatoR.R --help

##################
#
# Env. Setup
#
##################

#List of needed packages
list_of_packages=c("readr","stringi","optparse","tools")

#Based on the packages that are present, install ones that are required.
new.packages <- list_of_packages[!(list_of_packages %in% installed.packages()[,"Package"])]
suppressMessages(if(length(new.packages)) install.packages(new.packages))

#Load libraries.
suppressMessages(library(readr,verbose = F))
suppressMessages(library(stringi,verbose = F))
suppressMessages(library(optparse,verbose = F))
suppressMessages(library(tools,verbose = F))

#remove objects that are no longer used.
rm(list_of_packages)
rm(new.packages)


##################
#
# Arg parse
#
##################

#Option list for arg parse
option_list = list(
  make_option(c("-d", "--directory_1"), type="character", default=NULL, 
              help="The first directory of dbGaP files.", metavar="character"),
  make_option(c("-i", "--directory_2"), type="character", default=NULL, 
              help="The second directory of dbGaP files.", metavar="character"),
  make_option(c("-o", "--output"), type="character", default=".", 
              help="The output directory the merge files will be written out. (This will create a directory if one does not exist.)", metavar="character")
)


#create list of options and values for file input
opt_parser = OptionParser(option_list=option_list, description = "\ndbGaP_ConcatenatoR.R v2.0.0\n\nSubmit two directories that contain the dbGaP submission files for SA, SSM and, SC_DS.")
opt = parse_args(opt_parser)

#If no options are presented, return --help, stop and print the following message.
if (is.null(opt$directory_1)|is.null(opt$directory_2)){
  print_help(opt_parser)
  cat("Please supply all directories that contain the dbGaP submission files.\n\n")
  suppressMessages(stop(call.=FALSE))
}

#directory_1 pathway
path1=file_path_as_absolute(opt$directory_1)

#directory_2 pathway
path2=file_path_as_absolute(opt$directory_2)

#Create directory if it does not exist.
if (opt$output!="."){
  if (!(opt$output %in% list.dirs(dirname(opt$output), full.names = FALSE))){
    dir.create(path = paste(dirname(opt$output),basename(opt$output),sep="/"))
  }
}


#output pathway
outpath=file_path_as_absolute(opt$output)

#A start message for the user that the validation is underway.
cat("The merged dbGaP submission templates are being created at this time.\n")

###############
#
# Read in files
#
###############

if (substr(x = path1,start = nchar(path1), stop = nchar(path1))!="/"){
  path1=paste(path1,"/",sep = "")
}

if (substr(x = path2,start = nchar(path2), stop = nchar(path2))!="/"){
  path2=paste(path2,"/",sep = "")
}

if (substr(x = outpath,start = nchar(outpath), stop = nchar(outpath))!="/"){
  outpath=paste(outpath,"/",sep = "")
}

  
outfile=paste("_Concat",
              stri_replace_all_fixed(
                str = Sys.Date(),
                pattern = "-",
                replacement = ""),
              ".txt",
              sep="")

paths=c(path1,path2)

####################
#
# Data rework
#
####################

file_list=c()
for (path in paths){
  file_list_in=list.files(path = path,full.names = TRUE)
  file_list=c(file_list, file_list_in)
}

file_list=file_list[!grepl(pattern = "DD", x = file_list)]
file_list=file_list[!grepl(pattern = "json", x = file_list)]


listed_files=list()
for (files in file_list){
  df=suppressMessages(read_tsv(file = files))
  file_name=basename(files)
  df_file_list=list(df)
  names(df_file_list)<-file_name
  listed_files=append(listed_files,df_file_list)
}

dbgap_files=c("SA_DS","SSM_DS","SC_DS")

for (dbfile in dbgap_files){
  loc=grep(pattern = dbfile, x = names(listed_files))
  df=unique(rbind(listed_files[[loc[1]]], listed_files[[loc[2]]]))
  write_tsv(x = df, file = paste(outpath,dbfile,outfile,sep = ""),na = "")
}

cat(paste("\n\nProcess Complete.\n\nThe output files can be found here: ",outpath,"\n\n",sep = "")) 
