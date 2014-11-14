class ToolVisualisation extends Tool
{
  ToolVisualisationConfig config;
  SliceGraph sliceDistance;

  Slider sliderRadiusOeil;
  Slider sliderRadiusExternMin, sliderRadiusExternMax, sliderRadiusIntern;
  ColorPicker cpDensMin, cpDensMax;
  Textfield tfConfigName;
  Toggle toggleDrawVilles, toggleDrawSubdiv, toggleDrawInner, toggleDrawFilled, toggleDrawLines;
  Slider sliderDensMin, sliderDensMax;

  boolean doExport = false;

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ToolVisualisation(PApplet p)
  {
    super(p);
    config = new ToolVisualisationConfig();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ToolVisualisationConfig config()
  {
    return config;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setup()
  {
    sliceCouleurMode = SLICE_COULEURS_VILLES;
    update();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void initControls()
  {
    String tabVisualisation = "Visualisation";
    tabName = tabVisualisation;

    cp5.tab(tabVisualisation).activateEvent(true);
    cp5.tab(tabVisualisation).setHeight(20);
    cp5.tab(tabVisualisation).setId(id);
    cp5.tab(tabVisualisation).captionLabel().style().marginTop = 2;

    int x = 2;
    int y = 22;

    int toggleMarginLeft = 24;
    int toggleMarginTop = -18;

    tfConfigName = cp5.addTextfield("configName", x, y, 150, 20).addListener(this);
    tfConfigName.setLabel("");
    tfConfigName.moveTo(tabVisualisation);

    controlP5.Button btnConfigSave = cp5.addButton("configSave", 0, x+150+4, y, 44, 20).addListener(this);
    btnConfigSave.setLabel("Sauver");
    btnConfigSave.moveTo(tabVisualisation);

    controlP5.Button btnConfigLoad = cp5.addButton("configLoad", 0, x+150+44+4+4, y, 44, 20).addListener(this);
    btnConfigLoad.setLabel("Charger");
    btnConfigLoad.moveTo(tabVisualisation);

    controlP5.Button btnExport = cp5.addButton("Export", 0, x+150+44*2+4*3, y, 46, 20).addListener(this);
    btnExport.setLabel("Exporter");
    btnExport.moveTo(tabVisualisation);

    y+=22;


    toggleDrawVilles = cp5.addToggle("Villes", toolVisualisation.config().isDrawVilles, x, y, 20, 20).addListener(this);  
    toggleDrawVilles.moveTo(tabVisualisation);
    toggleDrawVilles.captionLabel().style().marginLeft = toggleMarginLeft;
    toggleDrawVilles.captionLabel().style().marginTop = toggleMarginTop;

    toggleDrawSubdiv = cp5.addToggle("Subdivisions", toolVisualisation.config().isDrawSubdiv, x+60, y, 20, 20).addListener(this);  
    toggleDrawSubdiv.moveTo(tabVisualisation);
    toggleDrawSubdiv.captionLabel().style().marginLeft = toggleMarginLeft;
    toggleDrawSubdiv.captionLabel().style().marginTop = toggleMarginTop;

    toggleDrawInner = cp5.addToggle("LignesInner", toolVisualisation.config().isDrawLinesInner, x+150, y, 20, 20).addListener(this);  
    toggleDrawInner.moveTo(tabVisualisation);
    toggleDrawInner.setLabel("Lignes internes");
    toggleDrawInner.captionLabel().style().marginLeft = toggleMarginLeft;
    toggleDrawInner.captionLabel().style().marginTop = toggleMarginTop;

    toggleDrawFilled = cp5.addToggle("Couleurs", toolVisualisation.config().isDrawCouleurs, x+250, y, 20, 20).addListener(this);  
    toggleDrawFilled.moveTo(tabVisualisation);
    toggleDrawFilled.setLabel("Couleurs");
    toggleDrawFilled.captionLabel().style().marginLeft = toggleMarginLeft;
    toggleDrawFilled.captionLabel().style().marginTop = toggleMarginTop;

    toggleDrawLines = cp5.addToggle("Contours", toolVisualisation.config().isDrawLines, x+320, y, 20, 20).addListener(this);  
    toggleDrawLines.moveTo(tabVisualisation);
    toggleDrawLines.setLabel("Contours");
    toggleDrawLines.captionLabel().style().marginLeft = toggleMarginLeft;
    toggleDrawLines.captionLabel().style().marginTop = toggleMarginTop;

    y+=22;

    sliderRadiusOeil = cp5.addSlider("RayonOeil", 10, 100, 50.0, x, y, 150, 20).addListener(this);
    sliderRadiusOeil.setLabel("Oeil");
    sliderRadiusOeil.moveTo(tabVisualisation);

    y+=22;
    sliderRadiusExternMin = cp5.addSlider("radiusExternMin", 200, 500, 400, x, y, 150, 20).addListener(this);
    sliderRadiusExternMin.setLabel("rayon externe min");
    sliderRadiusExternMin.moveTo(tabVisualisation);

    y+=22;
    sliderRadiusExternMax = cp5.addSlider("radiusExternMax", 300, 700, 500, x, y, 150, 20).addListener(this);
    sliderRadiusExternMax.setLabel("rayon externe max");
    sliderRadiusExternMax.moveTo(tabVisualisation);

    y+=22;
    sliderRadiusIntern = cp5.addSlider("radiusIntern", 50, 150, 100, x, y, 150, 20).addListener(this);
    sliderRadiusIntern.setLabel("rayon interne");
    sliderRadiusIntern.moveTo(tabVisualisation);

    y+=43;
    DropdownList dropdownClassement = cp5.addDropdownList("dropdownClassement", x, y, 150, 120).addListener(this);
    dropdownClassement.setLabel("Classement");
    dropdownClassement.setBarHeight(20);
    dropdownClassement.setItemHeight(20);
    dropdownClassement.captionLabel().style().marginTop = 5;
    dropdownClassement.captionLabel().style().marginLeft = 3;
    dropdownClassement.addItem("Document excel", agenceManager.SORT_DOCUMENT);
    dropdownClassement.addItem("Angle / Bordeaux", agenceManager.SORT_ANGLE);
    dropdownClassement.addItem("Au hasard", agenceManager.SORT_RANDOM);
    //  dropdownClassement.addItem("Distance / Bordeaux",agenceManager.SORT_DISTANCE);
    dropdownClassement.moveTo(tabVisualisation);


    DropdownList dropdownModeCouleurs = cp5.addDropdownList("dropdownModeCouleurs", x+154, y, 100, 120).addListener(this);
    dropdownModeCouleurs.setLabel("Couleurs");
    dropdownModeCouleurs.setBarHeight(20);
    dropdownModeCouleurs.setItemHeight(20);
    dropdownModeCouleurs.captionLabel().style().marginTop = 5;
    dropdownModeCouleurs.captionLabel().style().marginLeft = 3;
    dropdownModeCouleurs.addItem("Degrade", SLICE_COULEURS_DEGRADE);
    dropdownModeCouleurs.addItem("Couleurs villes", SLICE_COULEURS_VILLES);
    dropdownModeCouleurs.moveTo(tabVisualisation);


    cpDensMin = cp5.addColorPicker("cpDensMin", width/2-255-2, height-64, 255, 20).addListener(this);
    cpDensMin.setColorValue(color(146, 212, 0));
    cpDensMin.moveTo(tabVisualisation);

    cpDensMax = cp5.addColorPicker("cpDensMax", width/2+2, height-64, 255, 20).addListener(this);
    cpDensMax.setColorValue(color(213, 43, 30));
    cpDensMax.moveTo(tabVisualisation);

    cpDensMin.hide();
    cpDensMax.hide();

    //  sliderRadiusIntern = cp5.addSlider("radiusIntern", 50, 150, 100, x, y, 150, 20);
    sliderDensMin = cp5.addSlider("sliderDensMin", 0, 100, toolVisualisation.config().percentColorDensMin, width/2-150/2, height-64, 150, 20).addListener(this);
    sliderDensMin.setLabel("Pourcentage couleur densite min");
    sliderDensMin.moveTo(tabVisualisation);

    sliderDensMax = cp5.addSlider("sliderDensMax", 50, 100, toolVisualisation.config().percentColorDensMax, width/2-150/2, height-64+22, 150, 20).addListener(this);
    sliderDensMax.setLabel("Pourcentage couleur densite max");
    sliderDensMax.moveTo(tabVisualisation);

//    sliderDensMin.hide();
//    sliderDensMax.hide();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public void controlEvent(ControlEvent theEvent)
  {
    String nameSource = theEvent.name();

    if (theEvent.isGroup())
    {
      if (nameSource.equals("dropdownClassement")) 
      {
        int method = int(theEvent.group().value());
        agenceManager.sort(method);
        this.update();
      }
      else if (nameSource.equals("dropdownModeCouleurs")) 
      {
        sliceCouleurMode = int(theEvent.group().value());
        updateControls();
      }

      // TODO : not working ??
      if (nameSource.equals("cpDensMin") || nameSource.equals("cpDensMax"))
      {
        toolVisualisation.setColorDensMinMax( cpDensMin.getColorValue(), cpDensMax.getColorValue());
      }

    }
    else
    {
      if (nameSource.equals("Villes"))
      {
        this.config().isDrawVilles =  (theEvent.value() == 1.0f);
      } 
      else if (nameSource.equals("Subdivisions"))
      {
        this.config().isDrawSubdiv =  (theEvent.value() == 1.0f);
      } 
      else if (nameSource.equals("RayonOeil"))
      {
        this.setRadiusOeil(theEvent.value());
      } 
      else if (nameSource.equals("radiusExternMin") || nameSource.equals("radiusExternMax"))
      {
        this.setSliceRadiusExternMinMax(sliderRadiusExternMin.value(), sliderRadiusExternMax.value());
      } 
      else if (nameSource.equals("radiusIntern"))
      {
        this.setSliceRadiusIntern(theEvent.value());
      } 
      else if (nameSource.equals("LignesInner"))
      {
        this.config().isDrawLinesInner = (theEvent.value() == 1.0f);
      } 
      else if (nameSource.equals("Contours"))
      {
        this.config().isDrawLines = (theEvent.value() == 1.0f);
      } 
      else if (nameSource.equals("Couleurs"))
      {
        this.config().isDrawCouleurs = (theEvent.value() == 1.0f);
      } 
      else if (nameSource.equals("Export"))
      {
        this.export();
      } 
      else if (nameSource.equals("configSave"))
      {
        String filename = tfConfigName.getText();
        if (!filename.equals(""))
          this.saveConfig(filename+".xml");
      } 
      else if (nameSource.equals("configLoad"))
      {

        String loadPath = selectInput("Choisir une configuration (.xml)");
        if (loadPath != null) 
        {
          this.loadConfig(loadPath);
        }
      }
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void update()
  {
    sliceDistance = new SliceGraph();

    int nbAgences = agenceManager.getListSorted().size();
    float angle = 0.0;
    for (int i=0;i<=nbAgences;i++)
    {
      Agence agence = agenceManager.getListSorted().get(i%nbAgences);
      Agence agenceNext = agenceManager.getListSorted().get((i+1)%nbAgences);
      if (agence == agenceManager.agenceBordeaux) continue;

      float dAngle = 360.0*agence.distanceBordeaux/agenceManager.distanceTotale;
      float radius0 = map(agence.distanceBordeaux/agenceManager.distanceMax, 0, 1, 400, 500);
      float radius1 = map(agenceNext.distanceBordeaux/agenceManager.distanceMax, 0, 1, 400, 500);

      float radius_=150;

      sliceDistance.add(agence, agenceNext, 0, 0, angle, radius_, radius0, angle+dAngle, radius_, radius1);

      angle += dAngle;
    }

    setSliceRadiusIntern(config.radiusInner);
    setSliceRadiusExternMinMax(config.radiusExternMin, config.radiusExternMax);
    setRadiusOeil(config.radiusOeil);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updateControls()
  {
    updateToggle(toggleDrawVilles, config().isDrawVilles);
    updateToggle(toggleDrawSubdiv, config().isDrawSubdiv);
    updateToggle(toggleDrawInner, config().isDrawLinesInner);
    updateToggle(toggleDrawFilled, config().isDrawCouleurs);
    updateToggle(toggleDrawLines, config().isDrawLines);

    sliderRadiusIntern.setValue(config().radiusInner);
    sliderRadiusExternMin.setValue(config().radiusExternMin);
    sliderRadiusExternMax.setValue(config().radiusExternMax);
    sliderRadiusOeil.setValue(config().radiusOeil);

    cpDensMin.setColorValue(config().colorDensMin);
    cpDensMax.setColorValue(config().colorDensMax);

    tfConfigName.setText(config().currentFilename);

    if (sliceCouleurMode == SLICE_COULEURS_DEGRADE) 
    {
      cpDensMin.show();
      cpDensMax.show();

      sliderDensMin.hide();
      sliderDensMax.hide();
    }
    else if (sliceCouleurMode == SLICE_COULEURS_VILLES) 
    {
      cpDensMin.hide();
      cpDensMax.hide();

      sliderDensMin.show();
      sliderDensMax.show();
    }

    sliderDensMin.setValue(config().percentColorDensMin);
    sliderDensMax.setValue(config().percentColorDensMax);
  }


  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setColorDensMinMax(int min, int max)
  {
    config.colorDensMin = min;    
    config.colorDensMax = max;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setRadiusOeil(float v) 
  {
    config.radiusOeil = v;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setSliceRadiusIntern(float v)
  {
    config.radiusInner = v;

    int nbSlices = sliceDistance.listSlices.size();
    for (int i=0;i<nbSlices;i++)
    {
      Slice slice = sliceDistance.listSlices.get(i);
      slice.setRadiusIntern(config.radiusInner);
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setSliceRadiusExternMinMax(float min, float max)
  {
    config.radiusExternMin = min;
    config.radiusExternMax = max;

    int nbSlices = sliceDistance.listSlices.size();
    for (int i=0;i<nbSlices;i++)
    {
      Slice slice = sliceDistance.listSlices.get(i);

      float radius0 = map(slice.agence.distanceBordeaux/agenceManager.distanceMax, 0, 1, config.radiusExternMin, config.radiusExternMax);
      float radius1 = map(slice.agenceNext.distanceBordeaux/agenceManager.distanceMax, 0, 1, config.radiusExternMin, config.radiusExternMax);

      slice.setRadiusExtern(radius0, radius1);
    }
  }


  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    background(colorBg);

    if (doExport) {
      beginRecord(PDF, "exports/"+timestamp()+"_export.pdf");
    }

    pushMatrix();
    translate(width/2, height/2);

    noFill();
    stroke(0);
    sliceDistance.draw();

    // Oeil
    noStroke();
    fill(255);
    ellipse(0, 0, config.radiusOeil, config.radiusOeil);

    popMatrix();

    if (doExport) {
      endRecord();
      doExport = false;
    }

    // FIXME
    setColorDensMinMax( cpDensMin.getColorValue(), cpDensMax.getColorValue());
    config().percentColorDensMin = sliderDensMin.value();
    config().percentColorDensMax = sliderDensMax.value();

  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void export()
  {
    doExport = true;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void saveConfig(String filename)
  {
    String s = "<?xml version=\"1.0\"?>\n";      
    s += "<toolVisualisation>\n";    
    s += "<isDrawVilles>"+(config().isDrawVilles ? "true":"false")+"</isDrawVilles>\n";    
    s += "<isDrawSubdiv>"+(config().isDrawSubdiv ? "true":"false")+"</isDrawSubdiv>\n";    
    s += "<isDrawLines>"+(config().isDrawLines ? "true":"false")+"</isDrawLines>\n";    
    s += "<isDrawLinesInner>"+(config().isDrawLinesInner ? "true":"false")+"</isDrawLinesInner>\n";    
    s += "<isDrawCouleurs>"+(config().isDrawCouleurs ? "true":"false")+"</isDrawCouleurs>\n";    
    s += "<radiusInner>"+config().radiusInner+"</radiusInner>\n";    
    s += "<radiusExternMin>"+config().radiusExternMin+"</radiusExternMin>\n";    
    s += "<radiusExternMax>"+config().radiusExternMax+"</radiusExternMax>\n";    
    s += "<radiusOeil>"+config().radiusOeil+"</radiusOeil>\n";    
    s += "<colorDensMin>"+config().colorDensMin+"</colorDensMin>\n";    
    s += "<colorDensMax>"+config().colorDensMax+"</colorDensMax>\n";    
    s += "<percentColorDensMin>"+config().percentColorDensMin+"</percentColorDensMin>\n";    
    s += "<percentColorDensMax>"+config().percentColorDensMax+"</percentColorDensMax>\n";    
    s += "</toolVisualisation>\n";

    PrintWriter output = applet.createWriter("configurations/"+filename);
    output.println(s);
    output.close();
    output.flush();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void loadConfig(String filename)
  {
    // Read the config using JAXB
    try 
    {
      JAXBContext context = JAXBContext.newInstance(ToolVisualisationConfig.class);
      config = (ToolVisualisationConfig) context.createUnmarshaller().unmarshal(applet.createInput(filename));

      // Title
      File file = new File(filename);  
      config().currentFilename = file.getName().substring(0, file.getName().lastIndexOf('.'));
      frame.setTitle(config().currentFilename);

      // Update the graph
      update();

      // Apply to our class
      updateControls();
    } 
    catch(JAXBException e) {
      e.printStackTrace();
    }
  }
}

