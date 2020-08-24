# SPDE spatio-temporal PM10 modelling  in Italy

Supporting material for the paper "Spatio-temporal modelling of PM10 daily concentrations in Italy using the SPDE approach"


## Model description

### PC-priors

```r
list(theta = list(prior="pc.prec", param=c(1,0.1)))->prec_hyper #all'inizio era 0.01
#AR1 component
list(prior="pc.cor1",param=c(0.8,0.318))->theta_hyper 
```

### Model formula (fixed effects)

```r
as.formula(lpm10~Intercept+dust+aod550.s+log.pbl00.s+log.pbl12.s+sp.s+t2m.s+tp.s+ptp.s+q_dem.s+i_surface.s+d_a1.s-1)->myformula
```

### Mesh

```r
      #terraferma: non-convex-hull for the 410 Italian monitoring sites, excluding Sardinia
      inla.nonconvex.hull(points =  puntiTerraferma,convex = 90)->terraferma
      #isola: non-convex-hull for the Sardegna monitoring sites
      inla.nonconvex.hull(points = puntiIsola,convex=90)->isola 
      #mesh triangulation for the study domain including Sardegna
      mesh<-inla.mesh.2d(boundary =list(list(terraferma,isola)), max.edge = c(30,150),cutoff=5,offset=c(10),min.angle = 25)
```

[Mesh for the study domain](./docs/mesh.md)

### Model formula (including random effects)

```r
    update(myformula,.~.+f(id_centralina,model="iid")+
                         f(i,model=spde,group = i.group,control.group = list(model="ar1",hyper=list(theta=theta_hyper))))->myformula
```

### Run INLA

```r
    inla(myformula,
         data=inla.stack.data(mystack,spde=spde),
         family ="gaussian",
         verbose=TRUE,
         control.compute = list(openmp.strategy="pardiso.parallel",cpo=TRUE,waic=TRUE,dic=TRUE,config=TRUE),
         control.fixed = list(prec.intercept = 0.001, prec=1,mean.intercept=0),
         control.predictor =list(A=inla.stack.A(mystack),compute=TRUE) )->>inla.out
```


## Model output

* [GIF video for January 2015](./docs/video_january2015.md)
* [GIF video for July 2015](./docs/video_july2015.md)
