#' Daily observations data set
#'
#' @description
#' This is the data set described in the paper "Spatio-temporal modelling of PM10 daily concentrations in Italy using the SPDE approach"
#'
#' @usage
#' pm10
#'
#' @encoding UTF-8
#'
#' @format A tibble with 16 columns and 180675 rows
#' \describe{
#'  \item{pm10}{Daily pm10 observations in \eqn{\mu g/m^3}}
#'  \item{id_centralina}{Station code}
#'  \item{yymmdd}{Date of observations}
#'  \item{x}{Coordinates of the observation point (epsg: 32632)}
#'  \item{y}{Coordinates of the observation point (epsg: 32632)}
#'  \item{q_dem}{Elevation (metres) of the observation  point}
#'  \item{d_a1}{Linear distance to the nearest highway (metres)}
#'  \item{dust}{Saharan dust (0/1)}
#'  \item{sp}{Surface Pressure (hPa)}
#'  \item{aod550}{Aerosol Optical Depth at 550 nm}
#'  \item{tp}{Total precipitation (mm)}
#'  \item{t2m}{Average temperature at 2 meters (°C)}
#'  \item{pbl00}{Planet Boundary Layer at 00:00 in metres}
#'  \item{pbl12}{Planet Boundary Layer at 12:00 in metres}
#' }
"pm10"
