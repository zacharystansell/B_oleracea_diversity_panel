# Function to apply powerfunction to normalize data; if it violates shapiro.test
normalizingFun <- function(vec) {
  ST <- shapiro.test(vec)
  if (ST$p.value < 0.05) {
    LAMDA <- powerTransform(vec, family = "yjPower")
    return(yjPower(vec, LAMDA$lambda))
    print("NOT NORMAL")
  } else {
    return(vec)
    print("NORMAL")
  }
}