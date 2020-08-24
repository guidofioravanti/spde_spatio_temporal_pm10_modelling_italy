# SPDE spatio-temporal PM10 modelling  in Italy

Supporting material for the paper "Spatio-temporal modelling of PM10 daily concentrations in Italy using the SPDE approach"


## Model description

### PC-priors

```r
#Unstructured random effects for the monitoring sites
list(theta = list(prior="pc.prec", param=c(1,0.01)))->prec_hyper

#AR1 component
list(prior="pc.cor1",param=c(0.8,0.318))->theta_hyper 
```

### Model formula (fixed effects)

```r
# ".s" for standardized
as.formula(lpm10~Intercept+
                 dust+ #Dust event 0/1
                 aod550.s+ #Aerosol optical depth
                 log.pbl00.s+ #Planet boundary layer at 00:00
                 log.pbl12.s+ #Planet boundary layer at 12:00
                 sp.s+ #Surface pressure
                 t2m.s+ #Temperature at 2 meters
                 tp.s+ #Total precipitation
                 ptp.s+ #Total precipitation (previous day)
                 q_dem.s+ #Digital elevation model (altitude)
                 i_surface.s+ #Imperviousness
                 d_a1.s-1)->myformula #Linear distance to the a1 roads
```

### Mesh

```r
      #terraferma: non-convex-hull for the 410 Italian monitoring sites, excluding Sardegna
      inla.nonconvex.hull(points =  puntiTerraferma,convex = 90)->terraferma
      #isola: non-convex-hull for the Sardegna monitoring sites
      inla.nonconvex.hull(points = puntiIsola,convex=90)->isola 
      #mesh triangulation for the study domain including Sardegna
      mesh<-inla.mesh.2d(boundary =list(list(terraferma,isola)), max.edge = c(30,150),cutoff=5,offset=c(10),min.angle = 25)
      
      inla.spde2.pcmatern(mesh=mesh,alpha=2,constr=FALSE,prior.range = c(150,0.8),prior.sigma = c(0.8,0.2))->spde
```

The spatial distribution of the 410 monitoring sites and the mesh for the study domain are illustrated [here](./docs/mesh.md)

### Model formula (including random effects)

```r
    update(myformula,.~.+f(id_centralina,model="iid",hyper=prec_hyper)+
                         f(i,model=spde,
                             group = i.group,
                             control.group = list(model="ar1",hyper=list(theta=theta_hyper))))->myformula
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

We used [gganimate](https://gganimate.com/) to create example GIF videos for the daily mean concentrations. 

* [GIF video for January 2015](./docs/video_january2015.md)
* [GIF video for July 2015](./docs/video_july2015.md)
