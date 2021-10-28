#include <Rcpp.h>

// [[Rcpp::export]]
double moyenne(double tableau[], int tailleTableau)
{
  double moyenne(0);
  for(int i(0); i<tailleTableau; ++i)
  {
    moyenne += tableau[i];
  }
  moyenne /= tailleTableau;

  return moyenne;
}
