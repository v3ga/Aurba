class Agence
{
  String name = "";
  Location geoloc;
  float[] xy;
  float angleBordeaux = 0.0;
  float distanceBordeaux = 0.0;
  float densification = 0.0;
  color rgb;

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  Agence(String name_, String lat_, String lon_,String dens_,String rgb_)
  {
    this.name = name_;
    float lat = float(lat_.replace('_', '-'));
    float lon = float(lon_.replace('_', '-'));
    this.geoloc = new Location(lat,lon);  
    this.densification = float(dens_);
    
    String[] c = split(rgb_,',');
    rgb = color(int(c[0]),int(c[1]),int(c[2]));
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void update()
  {
    if (carte != null) 
      xy = carte.getScreenPositionFromLocation(geoloc);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    if (carte != null && xy !=null){
      ellipse(xy[0],xy[1],8,8);  
    }
  }
}

class AgenceManager extends ArrayList<Agence>
{
  Agence agenceBordeaux=null;
  float distanceTotale=0.0;
  float distanceMax=0.0;
  float densMin = 0.0;
  float densMax = 0.0;
  ArrayList<Agence> listSorted;
  
  int SORT_DOCUMENT = 0;
  int SORT_ANGLE = 1;
  int SORT_DISTANCE = 2;
  int SORT_RANDOM = 3;
    
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setup()
  {
    // Extract from document
    DocumentExcel docGPS = loadDocumentExcel(fichierAgence);
    for (int i=2;i<docGPS.nbLignes;i++)
    {
      Agence agence = new Agence( docGPS.getCellContent(0,i), docGPS.getCellContent(3,i), docGPS.getCellContent(5,i), docGPS.getCellContent(7,i), docGPS.getCellContent(6,i) );
      add(agence);

      if (agence.densification < densMin) densMin = agence.densification;
      else
      if (agence.densification > densMax) densMax = agence.densification;
    }
    
    // Infos
    println(" - nbAgences="+size());
    println(" - densification min = "+densMin+" / densification max ="+densMax);
    
    // Bordeaux
    agenceBordeaux = get(45);
    agenceBordeaux.update();

    // Angle with Bordeaux
    distanceTotale = 0;
    for (int i=0;i<size();i++)
    {
       Agence agence = get(i);
       agence.update();
       if (agence != agenceBordeaux){
         float dx = agence.xy[0] - agenceBordeaux.xy[0];
         float dy = agence.xy[1] - agenceBordeaux.xy[1];
         
         agence.angleBordeaux = degrees(atan2(dy,dx));
         agence.distanceBordeaux = (float)GeoUtils.getDistance(agence.geoloc, agenceBordeaux.geoloc);
         distanceTotale += agence.distanceBordeaux;
         if (agence.distanceBordeaux>distanceMax)
           distanceMax = agence.distanceBordeaux;
         println("- "+agence.name+" angle="+agence.angleBordeaux+" / distance="+agence.distanceBordeaux);
       }      
    }
    println("- distanceTotale="+distanceTotale);

    sort(SORT_DOCUMENT);
    
  }  

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ArrayList<Agence> getListSorted()
  {
    return listSorted;
  }


  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void sort(int method)
  {
    listSorted = new ArrayList<Agence>();
    if (method == SORT_DOCUMENT)
    {
      for (Agence a:this)
        listSorted.add(a);
    }  
    else
    if (method == SORT_ANGLE)
    {
      listSorted = bubbleSort(this, method);
    }  
    else
    if (method == SORT_DISTANCE)
    {
      listSorted = bubbleSort(this, method);
    }  
    else
    if (method == SORT_RANDOM){
      sort(SORT_DOCUMENT);
      Collections.shuffle(listSorted);    
    }
  }
}
