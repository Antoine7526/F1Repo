library(Rcpp)

cppFunction('int add(int x, int y, int z) {
  int sum = x + y + z;
  return sum;
}')

cppFunction('int nb_elt(CharacterVector cv){
  int total = 0;
  int n = cv.size();
  for(int i=0; i<n; i++){
    total += 1;
  }
  return total;
}')


