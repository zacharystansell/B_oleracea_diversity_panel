addImg <- function(
  obj, # an image file imported as an array (e.g. png::readPNG, jpeg::readJPEG)
  x = NULL, # mid x coordinate for image
  y = NULL, # mid y coordinate for image
  HEIth = NULL, # HEIth of image (in x coordinate units)
  interpolate = TRUE # (passed to graphics::rasterImage) A logical vector (or scalar) indicating whether to apply linear interpolation to the image when drawing. 
){
  if(is.null(x) | is.null(y) | is.null(HEIth)){stop("Must provide args 'x', 'y', and 'HEIth'")}
  USR <- par()$usr # A vector of the form c(x1, x2, y1, y2) giving the extremes of the user coordinates of the plotting region
  PIN <- par()$pin # The current plot dimensions, (HEIth, WEIght), in inches
  DIM <- dim(obj) # number of x-y pixels for the image
  ARp <- DIM[2]/DIM[1] # pixel aspect ratio (y/x)
  HEIi <- HEIth/(USR[4]-USR[3])*PIN[1] # convert HEIth units to inches
  WEIi <- HEIi * ARp # WEIght in inches
  WEIu <- WEIi/PIN[1]*(USR[2]-USR[1]) # WEIght in units
  rasterImage(image = obj, 
    ybottom = x-(HEIth/2), ytop = x+(HEIth/2),
    xleft = y-(WEIu/2), xright = y+(WEIu/2), 
    interpolate = interpolate)
}

