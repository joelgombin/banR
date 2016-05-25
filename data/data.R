#' Adresses des électeurs parisiens en 2012
#'
#' Jeu de données contenant toutes les adresses de la liste électorale parisienne en 2012, ainsi que l'arrondissement et le bureau de vote correspondant.
#'
#' @format dataframe de 72107 lignes et 6 variables :
#' \describe{
#'   \item{arrondissement}{Arrondissement}
#'   \item{bureau}{bureau de vote}
#'   \item{numero}{numéro dans la voie}
#'   \item{voie}{type de voie}
#'   \item{nom}{nom de la voie}
#'   \item{nb}{nombre d'électeurs domiciliés à cette adresse}
#'   \item{ID}{identifiant unique du bureau de vote}
#' }
#' @source Ville de Paris. Merci à Baptiste Coulmont qui m'a communiqué ces données anonymisées.
"paris2012"
