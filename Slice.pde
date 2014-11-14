int SLICE_COULEURS_DEGRADE = 0;
int SLICE_COULEURS_VILLES = 1;

int sliceCouleurMode = SLICE_COULEURS_DEGRADE;

class Slice
{
  Agence agence, agenceNext;

  PVector c;
  PVector p0_, p0; // _ is for interior (close to center)
  PVector p1_, p1;
  PVector middle_, middle;
  color couleur;


  ArrayList<PVector> listp_;
  ArrayList<PVector> listp;

  float radius0, radius1;
  float radius0_, radius1_;
  float angle0, angle1;

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  Slice(Agence agence_, Agence agenceNext_)
  {
    agence = agence_;
    agenceNext = agenceNext_;

    c = new PVector();

    p0_ = new PVector();
    p0  = new PVector();
    p1_ = new PVector();
    p1  = new PVector();

    middle  = new PVector();
    middle_ = new PVector();
    
    couleur = color(255);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void update()
  {
    float a0 = angle0;
    float a1 = angle1;
    float r0 = radius0;
    float r0_ = radius0_;
    float r1 = radius1;
    float r1_ = radius1_;

    p0_.x = 0.5*r0_*cos(radians(a0));
    p0_.y = 0.5*r0_*sin(radians(a0));
    p0.x = 0.5*r0*cos(radians(a0));
    p0.y = 0.5*r0*sin(radians(a0));

    p1_.x = 0.5*r1_*cos(radians(a1));
    p1_.y = 0.5*r1_*sin(radians(a1));
    p1.x = 0.5*r1*cos(radians(a1));
    p1.y = 0.5*r1*sin(radians(a1));

    listp = new ArrayList<PVector>();
    listp_ = new ArrayList<PVector>();


    float dAngle = a1-a0;
    if (abs(dAngle) >=4.0f) 
    {

      int nbSubdiv = int(map(dAngle, 0, 45, 1, 20));

      float step = dAngle/float(nbSubdiv);
      for (int j=0;j<=nbSubdiv;j++) 
      {
        float rr0 = (r1-r0)*float(j)/float(nbSubdiv) + r0; 
        float rr0_ = (r1_-r0_)*float(j)/float(nbSubdiv) + r0_; 

        float xx0 = 0.5f*rr0*cos(radians(a0+j*step));
        float yy0 = 0.5f*rr0*sin(radians(a0+j*step));

        float xx0_ = 0.5f*rr0_*cos(radians(a0+j*step));
        float yy0_ = 0.5f*rr0_*sin(radians(a0+j*step));

        listp.add( new PVector(xx0, yy0, 0) );
        listp_.add( new PVector(xx0_, yy0_, 0) );

        //        line(xx0, yy0, xx1, yy1);
      }
    }
    else
    {
      listp_.add( p0_ );
      listp_.add( p1_ );

      listp.add( p0 );
      listp.add( p1 );
    }

    int middleIndex = int(listp.size()/2)-1;

    PVector A = listp_.get(middleIndex);
    PVector B = listp_.get(middleIndex+1);

    middle_.x = 0.5*(A.x+B.x);
    middle_.y = 0.5*(A.y+B.y);
    
  }
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setRadiusIntern(float r_)
  {
    radius0_ = r_;
    radius1_ = r_;
    update();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setRadiusExtern(float r0, float r1) 
  {

    radius0 = r0;
    radius1 = r1;
    update();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void set(float x, float y, float a0, float r0_, float r0, float a1, float r1_, float r1)
  {
    c.x = x;
    c.y = y;

    radius0 = r0;
    radius0_ = r0_;
    radius1 = r1;
    radius1_ = r1_;
    angle0 = a0;
    angle1 = a1;

    update();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    pushMatrix();
    translate(c.x, c.y);

    // --------------------
    // Inner
    // --------------------
    if (toolVisualisation.config().isDrawSubdiv && !toolVisualisation.doExport) {
      stroke(200);
      strokeWeight(1);
      if (listp_!=null && listp!=null) {
        int nb = listp_.size();
        for (int i=1;i<nb-1;i++) {
          PVector A = listp_.get(i);
          PVector B = listp.get(i);
          line(A.x, A.y, B.x, B.y);
        }
      }
    }

    // --------------------
    // Couleurs
    // --------------------
    noStroke();
    float densRel = map(agence.densification, agenceManager.densMin,agenceManager.densMax, 0.0,1.0);
    
     if (sliceCouleurMode == SLICE_COULEURS_DEGRADE)
     {
       float rmin = red(toolVisualisation.config().colorDensMin);
       float gmin = green(toolVisualisation.config().colorDensMin);
       float bmin = blue(toolVisualisation.config().colorDensMin);

       float dr = red(toolVisualisation.config().colorDensMax)-rmin;
       float dg = green(toolVisualisation.config().colorDensMax)-gmin;
       float db = blue(toolVisualisation.config().colorDensMax)-bmin;

       couleur = color(rmin+densRel*dr, gmin+densRel*dg, bmin+densRel*db);
     }
     else
     if (sliceCouleurMode == SLICE_COULEURS_VILLES)
     {
       float rmin = toolVisualisation.config().percentColorDensMin/100.0*red(agence.rgb);
       float gmin = toolVisualisation.config().percentColorDensMin/100.0*green(agence.rgb);
       float bmin = toolVisualisation.config().percentColorDensMin/100.0*blue(agence.rgb);

       float rmax = toolVisualisation.config().percentColorDensMax/100.0*red(agence.rgb);
       float gmax = toolVisualisation.config().percentColorDensMax/100.0*green(agence.rgb);
       float bmax = toolVisualisation.config().percentColorDensMax/100.0*blue(agence.rgb);
       
      couleur = color(rmin + densRel*(rmax-rmin), gmin + densRel*(gmax-gmin), bmin + densRel*(bmax-bmin));
     }

    fill(couleur);
    if (toolVisualisation.config().isDrawCouleurs) {

      if (listp_!=null && listp!=null) {
        int nb = listp_.size();
        for (int i=0;i<nb-1;i++) {
          PVector A = listp_.get(i);
          PVector B = listp.get(i);
          PVector C = listp.get(i+1);
          PVector D = listp_.get(i+1);
          quad(A.x,A.y,B.x,B.y,C.x,C.y,D.x,D.y);
        }
      }
    }    

    // --------------------
    // Extremités
    // --------------------
    if (toolVisualisation.config().isDrawLines){
      stroke(0);
      strokeWeight(1);
      line(p0_.x, p0_.y, p0.x, p0.y);
      line(p1_.x, p1_.y, p1.x, p1.y);

      // --------------------
      // Liens
      // --------------------
      if (listp_!=null) {
        int nb = listp_.size();
        for (int i=0;i<nb-1;i++) {
          PVector A = listp_.get(i);
          PVector B = listp_.get((i+1)%nb);
          line(A.x, A.y, B.x, B.y);
        }
      }
    }

    if (listp!=null) {
      int nb = listp.size();
      for (int i=0;i<nb-1;i++) {
        PVector A = listp.get(i);
        PVector B = listp.get((i+1)%nb);
        line(A.x, A.y, B.x, B.y);
      }
    }

    // --------------------
    // Ville
    // --------------------
    if (toolVisualisation.config().isDrawVilles) {
      pushMatrix();
      rotate(radians(angle0));
      fill(0);
      text(agence.name, 0.5*radius0+10, 5);
      popMatrix();
    }

    // Middle
    if (toolVisualisation.config().isDrawLinesInner && !toolVisualisation.doExport) 
    {
      PVector u = new PVector(-middle_.x, -middle_.y, 0);
      u.normalize();
      float distRatio = agence.distanceBordeaux/agenceManager.distanceTotale*5;
      float r = dist(middle_.x, middle_.y, 0, 0);
      float rr = r-toolVisualisation.sliderRadiusOeil.value()/2;
      PVector P = new PVector(u.x*rr*distRatio, u.y*rr*distRatio);


      noStroke();
      fill(200, 0, 0);
      ellipse(middle_.x, middle_.y, 2, 2);
      stroke(200, 0, 0);
      strokeWeight(1);
      line(middle_.x+P.x, middle_.y+P.y, middle_.x, middle_.y);
    }
    popMatrix();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  RPolygon toRPolygon()
  {
    RContour contour = new RContour();
    contour.addPoint(0,0);

      if (listp!=null) {
        int nb = listp.size();
        for (int i=0;i<nb;i++) {
          PVector P = listp.get(i);
          //line(A.x, A.y, B.x, B.y);
          contour.addPoint(P.x,P.y);
        }
      }
      contour.addPoint(0,0);
  
    RPolygon rp = new RPolygon(contour);
    rp.setFill(couleur);

    return rp;
  }

}

class SliceGraph
{
  ArrayList<Slice> listSlices;  

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  SliceGraph()
  {
    listSlices = new ArrayList<Slice>();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void add(Agence a, Agence b, float x, float y, float a0, float r0_, float r0, float a1, float r1_, float r1) 
  {  
    Slice s = new Slice(a, b);
    s.set(x, y, a0, r0_, r0, a1, r1_, r1);
    listSlices.add(s);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  Slice getSlice(int index)
  {
    return listSlices.get(index);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    for (Slice slice:listSlices)
      slice.draw();
  }
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  RPolygon toRPolygon()
  {
    RContour contourExtern = new RContour();
    for (Slice slice:listSlices){
      contourExtern.addPoint( slice.p0.x, slice.p0.y);
    }
    RPolygon polygon = new RPolygon(contourExtern);


    return polygon;
  }
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ArrayList<RPolygon> toRPolygonSlices()
  {
    ArrayList<RPolygon> listSlicePolygons = new ArrayList<RPolygon>();
    for (Slice slice:listSlices)
    {
      listSlicePolygons.add( slice.toRPolygon() );
    }
    return listSlicePolygons;
  }
}

