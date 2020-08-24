# SPDE spatio-temporal PM10 modelling  in Italy

Supporting material for the paper "Spatio-temporal modelling of PM10 daily concentrations in Italy using the SPDE approach"


## Model description

### Mesh

```r
      inla.nonconvex.hull(points =  puntiTerraferma,convex = 90)->terraferma
      inla.nonconvex.hull(points = puntiIsola,convex=90)->isola 
      mesh<-inla.mesh.2d(boundary =list(list(terraferma,isola)), max.edge = c(30,150),cutoff=5,offset=c(10),min.angle = 25)
```

[Mesh for the study domain](./docs/mesh.md)

## Model output

* [GIF video for January 2015](./docs/video_january2015.md)
* [GIF video for July 2015](./docs/video_july2015.md)
