class ToolCarte extends Tool implements MapEventListener
{
  de.fhpotsdam.unfolding.Map carte;
  EventDispatcher carteEventDispatcher;
  boolean eventsRegistered = false;

  // Controls
  Slider sliderZoom;


  // Properties
  boolean isDrawLinks = true;
  boolean isDrawIndexes = true;

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ToolCarte(PApplet p)
  {
    super(p);
    carte = new de.fhpotsdam.unfolding.Map(applet,new Microsoft.AerialProvider());
    carte.zoomAndPanTo(new Location(44.833f, -0.56f), 5);
    carteEventDispatcher = MapUtils.createDefaultEventDispatcher(applet, carte);
    carteEventDispatcher.register(this, ZoomMapEvent.TYPE_ZOOM, carte.getId());
    eventsRegistered = true;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolCarte__";
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void initControls()
  {
    String tabMap = "default";
    tabName = tabMap;

    // Tab Properties
    cp5.tab(tabMap).activateEvent(true);
    cp5.tab(tabMap).setHeight(20);
    cp5.tab(tabMap).captionLabel().style().marginTop = 2;
    cp5.tab(tabMap).setId(id);
    cp5.tab(tabMap).setLabel("Carte");

    // Controls
    int x = 2;
    int y = 22;

    int toggleMarginLeft = 24;
    int toggleMarginTop = -18;

    // Fichier xls


    // Zoom
    float zoomMin = 1.0;
    float zoomMax = 10.0;
    sliderZoom = cp5.addSlider("Zoom", zoomMin, zoomMax, 6.0, x, y, 150, 20).addListener(this);
    sliderZoom.setNumberOfTickMarks(int(zoomMax-zoomMin)+1);
    sliderZoom.moveTo(tabMap);

    // Links
    y+=32;  
    Toggle toggleDrawLinks = cp5.addToggle("Connexions", toolCarte.isDrawLinks, x, y, 20, 20).addListener(this);  
    toggleDrawLinks.moveTo(tabMap);
    toggleDrawLinks.captionLabel().style().marginLeft = toggleMarginLeft;
    toggleDrawLinks.captionLabel().style().marginTop = toggleMarginTop;

    // Indexes
    y+=22;  
    Toggle toggleDrawIndexes = cp5.addToggle("Index", toolCarte.isDrawIndexes, x, y, 20, 20).addListener(this);  
    toggleDrawIndexes.moveTo(tabMap);
    toggleDrawIndexes.captionLabel().style().marginLeft = toggleMarginLeft;
    toggleDrawIndexes.captionLabel().style().marginTop = toggleMarginTop;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public void controlEvent(ControlEvent theEvent)
  {
    String nameSource = theEvent.name();
    // Zoom
    if (nameSource.equals("Zoom"))
    {
      if (carte !=  null)
        carte.zoomToLevel(int(theEvent.value()));
    }
    // Links
    else if (nameSource.equals("Connexions"))
    {
      this.isDrawLinks =  (theEvent.value() == 1.0f);
    }
    else if (nameSource.equals("Index"))
    {
      this.isDrawIndexes =  (theEvent.value() == 1.0f);
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public void onManipulation(MapEvent event)
  {
    updateSliderZoom();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void registerEvents(boolean is)
  {
    if (is) {
      if (carteEventDispatcher != null) {   
        if (!eventsRegistered) {   
          carteEventDispatcher.register(carte, PanMapEvent.TYPE_PAN, carte.getId());
          carteEventDispatcher.register(carte, ZoomMapEvent.TYPE_ZOOM, carte.getId());
          carteEventDispatcher.register(this, ZoomMapEvent.TYPE_ZOOM, carte.getId());
          eventsRegistered = true;
        }
      }
    }
    else {
      if (carteEventDispatcher != null) {    
        carteEventDispatcher.unregister(carte, PanMapEvent.TYPE_PAN, carte.getId());
        carteEventDispatcher.unregister(carte, ZoomMapEvent.TYPE_ZOOM, carte.getId());
        carteEventDispatcher.unregister(this, ZoomMapEvent.TYPE_ZOOM, carte.getId());
        eventsRegistered = false;
      }
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    // Update first
    for (Agence agence:agenceManager.getListSorted())
      agence.update();

    // Draw
    carte.draw();  
    noStroke();
    fill(colorAgence);
    int index=0;
    for (Agence agence:agenceManager.getListSorted()) {
      agence.draw();
    }

    if (isDrawIndexes) {
      for (int i=0;i<agenceManager.getListSorted().size();i++) {
        Agence agence = agenceManager.getListSorted().get(i);
        text(""+i+" "+agence.name, agence.xy[0]+6, agence.xy[1]);
      }
    }


    // Links
    stroke(colorAgence);
    if (isDrawLinks) {
      Agence agenceBordeaux = agenceManager.agenceBordeaux;
      for (Agence agence:agenceManager.getListSorted()) {
        if (agence != agenceBordeaux)
          line(agence.xy[0], agence.xy[1], agenceBordeaux.xy[0], agenceBordeaux.xy[1]);
      }
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void mousePressed()
  {
    if (cp5.window(applet).isMouseOver())
      registerEvents(false);
    else
      registerEvents(true);
  }
}

