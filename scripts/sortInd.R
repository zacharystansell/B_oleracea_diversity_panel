sortInd <- function(dframe=NULL,grplab=NA,selgrp=NA,ordergrp=FALSE,sortind=NA,grplabpos=NA,linepos=NA,corder=NA)
{
  if(is.null(dframe)) stop("sortInd: Argument 'dframe' is empty.")
  if(!all(is.na(grplab))) 
  {
    if(is.na(selgrp)) selgrp <- names(grplab)[1]
    if(!is.character(selgrp)) stop("sortInd: Argument 'selgrp' must be a character datatype.")
    if(length(selgrp)>1) stop("sortInd: Argument 'selgrp' must be a character datatype of length 1.")
    if(!any(selgrp %in% names(grplab))) stop(paste0("sortInd: Argument 'selgrp' contains (",selgrp,") which is not in the 'grplab' titles (",paste0(names(grpla),collapse=", "),")."))
  }
  if(all(!is.na(sortind)))
  {
    if(length(sortind) > 1) stop("sortInd: Argument 'sortind' must be of length 1. Use 'all','label' or a cluster name like 'Cluster1'.")
    #if(sortind != "all" && sortind != "label" && !grepl("Cluster[0-9+]",sortind)) stop("sortInd: Argument 'sortind' must be set to 'all', 'label' or a cluster like 'Cluster1'.")
  }
  if(is.na(grplabpos)) grplabpos <- 0.25
  if(is.na(linepos)) linepos <- 0.75
  
  # get original order
  if(any(is.na(corder))) corder <- 1:nrow(dframe)
  if(length(corder)!=nrow(dframe)) stop("grpLabels: Length of 'corder' not equal to number of individuals.")
  # sorting without grplab
  if(any(is.na(grplab)))
  {
    if(!is.na(sortind))
    {
      if(sortind=="all")
      {
        dftemp <- dframe
        dftemp$maxval <- as.numeric(apply(dframe,1,max))
        dftemp$matchval <- as.numeric(apply(dframe,1,FUN=function(x) match(max(x),x)))
        dframe$corder <- corder
        dframe <- dframe[with(dftemp,order(matchval,-maxval)),,drop=FALSE]
        corder <- dframe$corder
        dframe$corder <- NULL
        rm(dftemp)
      }
      
      if(sortind=="label")
      {
        dframe$corder <- corder
        dframe <- dframe[order(rownames(dframe)),,drop=FALSE]
        corder <- dframe$corder
        dframe$corder <- NULL
      }
      
      if(sortind!="all" && sortind!="label")
      {
        if(!(sortind %in% colnames(dframe))) stop(paste0("sortInd: 'sortind' value (",sortind,") not found in file header (",paste0(colnames(dframe),collapse=", "),")."))
        dframe$corder <- corder
        dframe <- dframe[order(dframe[[sortind]]),,drop=FALSE]
        corder <- dframe$corder
        dframe$corder <- NULL
      }
      
    }
    label_position <- NA
    marker_position <- NA
  }
  
  # sorting with grplab
  if(!all(is.na(grplab)))
  {
    gnames <- names(grplab)
    onames <- setdiff(gnames,selgrp)
    
    if(!is.na(sortind))
    {
      # sort by all
      if(sortind=="all")
      {
        dftemp <- dframe
        # find the max value for each individual
        dftemp$maxval <- as.numeric(apply(dframe,1,max))
        # pick cluster with max value
        dftemp$matchval <- as.numeric(apply(dframe,1,FUN=function(x) match(max(x),x)))
        dftemp$corder <- corder
        
        if(length(intersect(colnames(dftemp),colnames(grplab)))!=0) stop(paste0("sortInd: One or more header labels in the run file are duplicated in grplab header. Change labels to be unique. Following are the duplicate label(s): (",paste0(intersect(colnames(dftemp),colnames(grplab)),collapse=", "),")."))
        dftemp <- cbind(dftemp,grplab)
        
        if(ordergrp)
        {
          sort_asc <- c(selgrp,onames,"matchval")
          sort_desc <- "maxval"
          dframe <- dftemp[do.call(order,c(as.list(dftemp[sort_asc]),lapply(dftemp[sort_desc],function(x) -xtfrm(x)))),]
        }else{
          rle1 <- rle(as.character(unlist(grplab[selgrp])))
          grplabnames <- rle1$values
          tovec <- cumsum(rle1$lengths)
          fromvec <- (tovec - rle1$lengths)+1
          dftemplist <- vector("list",length=length(grplabnames))
          for(k in 1:length(tovec))
          {
            dftemp1 <- dftemp[fromvec[k]:tovec[k],,drop=FALSE]
            dftemp1$grp <- NULL
            dftemplist[[k]] <- dftemp1[with(dftemp1,order(matchval,-maxval)),,drop=FALSE]
          }
          dframe <- do.call("rbind",dftemplist)
        }
        
        corder <- dframe$corder
        dframe$corder <- NULL
        grplab <- dframe[,gnames,drop=FALSE]
        dframe[,gnames] <- NULL
        dframe$maxval <- NULL
        dframe$matchval <- NULL
      }
      
      # sort by label
      if(sortind=="label")
      {
        if(length(intersect(colnames(dframe),colnames(grplab)))!=0) stop(paste0("sortInd: One or more header labels in the run file are duplicated in grplab header. Change labels to be unique. Following are the duplicate label(s): (",paste0(intersect(colnames(dframe),colnames(grplab)),collapse=", "),")."))
        dftemp <- cbind(dframe,grplab)
        dftemp$corder <- corder
        
        if(ordergrp)
        {
          dftemp$label <- rownames(dftemp)
          sort_asc <- c(selgrp,onames,"label")
          dframe <- dftemp[do.call(order,dftemp[,sort_asc]),]
          dframe$label <- NULL
        }else{
          rle1 <- rle(as.character(unlist(grplab[selgrp])))
          grplabnames <- rle1$values
          tovec <- cumsum(rle1$lengths)
          fromvec <- (tovec - rle1$lengths)+1
          dftemplist <- vector("list",length=length(grplabnames))
          for(k in 1:length(tovec))
          {
            dftemp1 <- dftemp[fromvec[k]:tovec[k],,drop=FALSE]
            dftemp1$grp <- NULL
            dftemplist[[k]] <- dftemp1[order(rownames(dftemp1)),,drop=FALSE]
          }
          dframe <- do.call("rbind",dftemplist)
        }
        
        corder <- dframe$corder
        dframe$corder <- NULL
        grplab <- dframe[,gnames,drop=FALSE]
        dframe[,gnames] <- NULL
      }
      
      # sort by cluster
      if(sortind!="all" && sortind!="label")
      {
        if(!(sortind %in% colnames(dframe))) stop(paste0("sortInd: 'sortind' value (",sortind,") not found in file header (",paste0(colnames(dframe),collapse=", "),")."))
        # checks if sortind variable is a column in dframe
        if(length(intersect(colnames(dframe),colnames(grplab)))!=0) stop(paste0("sortInd: One or more header labels in the run file are duplicated in grplab header. Change labels to be unique. Following are the duplicate label(s): (",paste0(intersect(colnames(dframe),colnames(grplab)),collapse=", "),")."))
        dftemp <- cbind(dframe,grplab)
        dftemp$corder <- corder
        
        if(ordergrp)
        {
          sort_asc <- c(selgrp,onames,sortind)
          dframe <- dftemp[do.call(order,dftemp[,sort_asc]),]
        }else{
          rle1 <- rle(as.character(unlist(grplab[selgrp])))
          grplabnames <- rle1$values
          tovec <- cumsum(rle1$lengths)
          fromvec <- (tovec - rle1$lengths)+1
          dftemplist <- vector("list",length=length(grplabnames))
          for(k in 1:length(tovec))
          {
            dftemp1 <- dftemp[fromvec[k]:tovec[k],,drop=FALSE]
            dftemp1$grp <- NULL
            dftemplist[[k]] <- dftemp1[order(dftemp1[[sortind]]),,drop=FALSE]
          }
          dframe <- do.call("rbind",dftemplist)
        }
        
        corder <- dframe$corder
        dframe$corder <- NULL
        grplab <- dframe[,gnames,drop=FALSE]
        dframe[,gnames] <- NULL
      }
    }
    
    # create label_position and marker_position
    gnames <- names(grplab)
    marker_position_list <- vector("list",length=length(gnames))
    label_position_list <- vector("list",length=length(gnames))
    intlablist <- vector("list",length=length(gnames))
    for(k in seq_along(gnames))
    {
      rlegrp <- rle(unlist(grplab[gnames[k]]))
      label_position_df <- data.frame(label=rlegrp$values,freq=rlegrp$lengths,stringsAsFactors=FALSE)
      marker_position_df <- data.frame(markerxpos=c(0,cumsum(label_position_df$freq)),stringsAsFactors=FALSE)
      label_position_df$labxpos <- round((diff(marker_position_df$markerxpos)/2)+marker_position_df$markerxpos[1:length(marker_position_df$markerxpos)-1],1)
      label_position_df$labypos <- rep(grplabpos,nrow(label_position_df))
      #marker_position_df$temp <- factor(rep(1,nrow(marker_position_df)))
      marker_position_df$markerypos <- rep(linepos,nrow(marker_position_df))
      
      marker_position_df$count <- gnames[k]
      marker_position_list[[k]] <- marker_position_df
      label_position_df$count <- gnames[k]
      label_position_list[[k]] <- label_position_df
    }
    
    marker_position <- do.call("rbind",marker_position_list)
    marker_position$count <- factor(marker_position$count,levels=gnames)
    label_position <- do.call("rbind",label_position_list)
    label_position$count <- factor(label_position$count,levels=gnames)
    
    rownames(marker_position) <- 1:nrow(marker_position)
    rownames(label_position) <- 1:nrow(label_position)
    
    #adjust divider position
    marker_position$divxpos <- marker_position$markerxpos+0.5
  }
  
  
  
  return(list(dframe=dframe,grplab=grplab,label_position=label_position,
              marker_position=marker_position,corder=corder))
}