class ToolIdentity extends Tool
{
  String[] fontNames = 
  {
    "Replica-Bold.TTF", "Replica-BoldItalic.TTF", "Replica-Regular.TTF", "Replica-Light.TTF", "Replica-LightItalic.TTF", "Replica-Italic.TTF"
  };


  Slider sliderIdScaleLetter, sliderIdScaleAurba;
  Textfield tfTxt;
  Slider2D slider2Center;
  Textfield tfTypoName;

  PGraphics pgExportLetter;

  RFont fontCurrent = null;
  RShape forme = null;

  RPolygon polygonAurbaSlices = null;
  RPolygon polygonAurbaSlicesTransform = null;

  ArrayList<RPolygon> listPolygonSlices = null;
  ArrayList<RPolygon> listPolygonSlicesTransform = null;
  ArrayList<RPolygon> listPolygonSlicesDiff = null;
  ArrayList<RMesh> listMeshSlicesDiff = null;

  RMatrix mPolygonAurba;
  RMatrix mPolygonAurbaScale;
  RMatrix mPolygonAurbaTranslate;
  float scaleAurba = 1.0f;

  RPoint tCenterNorm = new RPoint(0, 0);

  RPolygon polygonLetter = null;
  RPolygon polygonLetterTransform = null;
  RMatrix mPolygonLetter;
  float scaleLetter = 1.0f;

  RPoint polygonLetterTransformCentroid = null;
  RPoint polygonLetterTransformCenter = null;
  RPoint[] polygonLetterTransformBoundingPoints;

  HashMap<String, LetterDiff> listLetterDiff;
  LetterDiff currentLetterDiff;

  boolean invalidateComposition = false;
  boolean export = false;
  boolean exportBitmap = false;
  String typoName="";

  String txt = "";

  boolean isDrawColors = true;

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ToolIdentity(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolIdentity__";
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setup()
  {
    RG.init(applet);
    loadFont(fontNames[0]);

    polygonLetterTransformCenter = new RPoint();
    listLetterDiff = new HashMap<String, LetterDiff>();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void initControls()
  {
    String tabIdentity = "Identite";
    tabName = tabIdentity;

    cp5.tab(tabIdentity).activateEvent(true);
    cp5.tab(tabIdentity).setHeight(20);
    cp5.tab(tabIdentity).setId(id);
    cp5.tab(tabIdentity).captionLabel().style().marginTop = 2;

    int x = 2;
    int y = 22;

    int toggleMarginLeft = 24;
    int toggleMarginTop = -18;

    tfTypoName = cp5.addTextfield("typoName", x, y, 150, 20).addListener(this);
    tfTypoName.setLabel("");
    tfTypoName.moveTo(tabIdentity);
    tfTypoName.setAutoClear(false);

    controlP5.Button btnTypoSave = cp5.addButton("typoSave", 0, x+150+4, y, 44, 20).addListener(this);
    btnTypoSave.setLabel("Sauver");
    btnTypoSave.moveTo(tabIdentity);

    controlP5.Button btnTypoLoad = cp5.addButton("typoLoad", 0, x+150+44+4+4, y, 44, 20).addListener(this);
    btnTypoLoad.setLabel("Charger");
    btnTypoLoad.moveTo(tabIdentity);

    y+=22;


    sliderIdScaleLetter = cp5.addSlider("scaleIdLetter", 0.5, 2, 0.65, x, y, 150, 20).addListener(this);
    sliderIdScaleLetter.setLabel("Echelle de la lettre");
    sliderIdScaleLetter.moveTo(tabIdentity);

    y+=22;
    sliderIdScaleAurba = cp5.addSlider("scaleIdAurba", 0.5, 2, 1, x, y, 150, 20).addListener(this);
    sliderIdScaleAurba.setLabel("Echelle du motif");
    sliderIdScaleAurba.moveTo(tabIdentity);

    y+=22;
    tfTxt = cp5.addTextfield("txtId", x, y, 150, 20).addListener(this);
    tfTxt.setLabel("");
    tfTxt.moveTo(tabIdentity);
    tfTxt.setFont(createFont("arial",11));
    tfTxt.setAutoClear(false);

    y+=22;
    slider2Center = cp5.addSlider2D("center").setPosition(x, y).setSize(150, 150).setMinX(-1).setMaxX(1).setMinY(-1).setMaxY(1).setArrayValue(new float[] {1, 1}).addListener(this);
    slider2Center.moveTo(tabIdentity);

    controlP5.Button btnReset = cp5.addButton("resetCenter", 0, x+150+4, y, 46, 20).addListener(this);
    btnReset.setLabel("Reset");
    btnReset.moveTo(tabIdentity);

    controlP5.Button btnExportLetter = cp5.addButton("exportLetter", 0, x+150+4, y+22, 46, 20).addListener(this);
    btnExportLetter.setLabel("Exporter");
    btnExportLetter.moveTo(tabIdentity);

    controlP5.Button btnExportBitmap = cp5.addButton("exportBitmap", 0, x+150+4, y+22*2, 82, 20).addListener(this);
    btnExportBitmap.setLabel("Exporter Bitmap");
    btnExportBitmap.moveTo(tabIdentity);
    
    Toggle toggleDrawColors = cp5.addToggle("couleurs", false, x+150+4, y+22*3, 20, 20).setValue(isDrawColors ? 1.0f:0.0f).addListener(this);  
    toggleDrawColors.moveTo(tabIdentity);
    toggleDrawColors.captionLabel().style().marginLeft = toggleMarginLeft;
    toggleDrawColors.captionLabel().style().marginTop = toggleMarginTop;

    y+=150+22;

    DropdownList dropdownFontes = cp5.addDropdownList("dropdownFontes", x, y, 150, 120).addListener(this);
    dropdownFontes.setLabel("Fontes");
    dropdownFontes.setBarHeight(20);
    dropdownFontes.setItemHeight(20);
    dropdownFontes.captionLabel().style().marginTop = 5;
    dropdownFontes.captionLabel().style().marginLeft = 3;
    for (int i=0;i<toolIdentity.fontNames.length;i++) {
      dropdownFontes.addItem(toolIdentity.fontNames[i], i);
    }
    dropdownFontes.moveTo(tabIdentity);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public void controlEvent(ControlEvent theEvent)
  {
    String nameSource = theEvent.name();

    if (theEvent.isGroup())
    {
      if ( nameSource.equals("dropdownFontes") )
      {
        this.setFont( int(theEvent.group().value()) );
      }
    }
    else
    {
      if ( nameSource.equals("couleurs") )
      { 
        isDrawColors = (theEvent.value() == 1.0f);        
      }
      else if ( nameSource.equals("scaleIdLetter") )
      { 
        this.setScaleLetter( sliderIdScaleLetter.value() );
      }
      else if ( nameSource.equals("scaleIdAurba") )
      {  
        this.setScaleAurba( sliderIdScaleAurba.value() );
      }
      else if ( nameSource.equals("txtId") )
      {  
        // HACK
        if (tfTxt.getText().length()>1){
          int code = (int)tfTxt.getText().charAt(0);
          if (code == 65535){ // ??
            String s = tfTxt.getText().substring(1);
            tfTxt.setText(s);
          }
        }
        this.setText(tfTxt.getText());
      }                                
      else if ( nameSource.equals("center"))
      {
        float[] xy = slider2Center.getArrayValue();
//        println("x="+xy[0]+";y="+xy[1]);
        this.setCenter(xy[0], xy[1]);
      }
      else if ( nameSource.equals("resetCenter"))
      {
        slider2Center.setArrayValue(new float[] {1,1});
      }
      else if ( nameSource.equals("exportLetter"))
      {
        this.export();
      }
      else if ( nameSource.equals("exportBitmap"))
      {
        this.exportBitmap();      
      }
      else if ( nameSource.equals("typoName"))
      {
        typoName = tfTypoName.getText();
      }
      else if ( nameSource.equals("typoLoad"))
      {
        String loadPath = selectInput("Choisir une configuration (.xml)");
        if (loadPath != null) 
        {
          this.loadTypo(loadPath);
        }
        
      }
      else if ( nameSource.equals("typoSave"))
      {
       saveTypo(); 
      }
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updateControls()
  {
      sliderIdScaleLetter.setValue(scaleLetter);
      sliderIdScaleAurba.setValue(scaleAurba);
      slider2Center.setArrayValue( new float[] {tCenterNorm.x+1, tCenterNorm.y+1} );
      tfTypoName.setText(typoName);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updateLetterForme()
  {
    RCommand.setSegmentLength(10);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

    forme = fontCurrent.toShape(txt);
    forme = RG.centerIn(forme, applet.g, 50);  

    polygonLetter = forme.toPolygon();
    polygonLetterTransform = new RPolygon(polygonLetter);
    polygonLetterTransform.transform(mPolygonLetter);

    polygonLetterTransformCentroid = polygonLetterTransform.getCentroid();
    polygonLetterTransformBoundingPoints = polygonLetterTransform.getBoundsPoints();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updateAurbaMatrix()
  {
    RPoint[] bp = polygonLetterTransformBoundingPoints; // set by updateLetterForme
    float boundingWidth = bp[2].x-bp[0].x;
    float boundingHeight = bp[2].y-bp[0].y;

    // Translate Polygon Aurba
    mPolygonAurbaTranslate = new RMatrix();           
    mPolygonAurbaTranslate.translate(polygonLetterTransformCenter.x+tCenterNorm.x*boundingWidth, polygonLetterTransformCenter.y+tCenterNorm.y*boundingHeight);

    // Scale Polygon Aurba
    mPolygonAurba = new RMatrix(mPolygonAurbaScale);
    mPolygonAurba.apply( mPolygonAurbaTranslate );
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updateAurbaSlicesForme()
  {
    RPoint[] bp = polygonLetterTransformBoundingPoints;
    polygonLetterTransformCenter.x = 0.5*(bp[2].x + bp[0].x);
    polygonLetterTransformCenter.y = 0.5*(bp[2].y + bp[0].y);

    listPolygonSlices = toolVisualisation.sliceDistance.toRPolygonSlices();
    listPolygonSlicesTransform = new ArrayList<RPolygon>();

    for (RPolygon p:listPolygonSlices)
    {
      RPolygon pTransform = new RPolygon(p);
      pTransform.transform( mPolygonAurba );    
      listPolygonSlicesTransform.add(pTransform);
    }
  }
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updateSlicesDiff()
  {
  
    listPolygonSlicesDiff = new ArrayList<RPolygon>();
    listMeshSlicesDiff = new ArrayList<RMesh>();

    for (RPolygon p : listPolygonSlicesTransform) 
    {
      try 
      {
        RPolygon pDiff = p.intersection(polygonLetterTransform);
        if (pDiff!=null)
          listPolygonSlicesDiff.add ( pDiff );
          listMeshSlicesDiff.add( pDiff.toMesh() );
      }
      catch (Exception e) {
      }
    }

    // Save letter in hashmap
    LetterDiff letter = new LetterDiff(txt);
    letter.set(listPolygonSlicesDiff, polygonLetterTransform);
    letter.tCenterNorm.set(tCenterNorm.x,tCenterNorm.y,0);
    letter.scaleLetter = scaleLetter;
    letter.scaleAurba = scaleAurba;

    listLetterDiff.put(txt, letter);
  }


  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updateToolIdentityString()
  {
    //toolIdentityString.setLetterDiff(txt, listPolygonSlicesDiff, polygonLetterTransform);  
    toolIdentityString.updatePolygonString();      
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updateComposition()
  {
    // Update Letter forme
    // Compute polygon + bounding box + centroid
    // Bounding box is needed because translation of Aurba slices are relative to the width of this bounding box
    updateLetterForme();

    // Compute the transformation matrix for the Aurba polygon / slices
    updateAurbaMatrix();

    // Update each slice with the transformation (scale + translate)
    updateAurbaSlicesForme();

    // Composition
    updateSlicesDiff();
    
    // Update alphabet in tool string
    updateToolIdentityString();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void select()
  {
    invalidateComposition = true;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    // Background
    background(colorBg);

    if (txt.equals("")) return;

    // Compose
    if (invalidateComposition) 
    {
      invalidateComposition = false;
      updateComposition();
    }


    // Export ? 
    if (export) 
    {
      beginRaw(PDF, "exports/"+timestamp()+"_export_"+txt+".pdf");
    }

    // Draw slices
    if (listPolygonSlicesDiff !=null && listMeshSlicesDiff!=null) 
    {
      pushMatrix();
      translate(width/2, height/2);

      int index=0;
      RMesh mesh=null;
      for (RPolygon pDiff:listPolygonSlicesDiff)
      {
        if (isDrawColors){
          fill(pDiff.getStyle().fillColor);
          noStroke();
        }else{
          noFill();
          stroke(0);
        }

        if (isDrawColors){
          mesh = listMeshSlicesDiff.get(index);
          if (mesh!=null)
              mesh.draw();
          else{
            RPoint[] points = pDiff.getPoints();
            if (points.length == 3){
              triangle(points[0].x,points[0].y,points[1].x,points[1].y,points[2].x,points[2].y);            
            }
            else{
              //print(pDiff.getPoints().length+".");
/*
              beginShape(TRIANGLE_STRIP);
              for (int i=0;i<points.length;i++) vertex(points[i].x,points[i].y);
              endShape();
*/

            }
          }
        }
        else
          pDiff.draw();

        index++;
      }

      if (!export) 
      {
        noStroke();
        fill(200, 0, 0);
        rectMode(CENTER);
        stroke(200,0,0);
        RPoint[] bp = polygonLetterTransformBoundingPoints;
        for (int i=0;i<bp.length;i++) {
          rect(bp[i].x, bp[i].y, 5, 5);
        }
      }

      popMatrix();
    }

    // Export end
    if (export) 
    {
      export = false;
        endRaw();
    }

    if (exportBitmap)
    {
      pgExportLetter.beginDraw();
      pgExportLetter.background(255,0);
      pgExportLetter.pushMatrix();
      pgExportLetter.translate(pgExportLetter.width/2, pgExportLetter.height/2);

      float s = 2*float(pgExportLetter.width)/float(width);
      pgExportLetter.scale(s);
      int index=0;
      RMesh mesh=null;
      for (RPolygon pDiff:listPolygonSlicesDiff)
      {
        pgExportLetter.fill(pDiff.getStyle().fillColor);
        pgExportLetter.noStroke();
        mesh = listMeshSlicesDiff.get(index);
        if (mesh!=null)
            mesh.draw(pgExportLetter);
        else
        {
            RPoint[] points = pDiff.getPoints();
            if (points.length == 3){
              pgExportLetter.triangle(points[0].x,points[0].y,points[1].x,points[1].y,points[2].x,points[2].y);            
            }
        }

        //pDiff.draw(pgExportLetter);
        index++;
      }
      
      pgExportLetter.popMatrix();
      pgExportLetter.endDraw();
      pgExportLetter.save("exports/"+timestamp()+"_export_bitmap_"+txt+".png");
    
      exportBitmap = false;
    }

  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void loadFont(String fontName)
  {
    fontCurrent = new RFont(fontName, 200, RFont.CENTER);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setText(String txt)
  {
    this.txt = txt;
    
    LetterDiff letterDiff = listLetterDiff.get(txt);
    // Letter already exists
    if (letterDiff != null)
    {
      setScaleLetter( letterDiff.scaleLetter );
      setScaleAurba( letterDiff.scaleAurba );
      setCenter(letterDiff.tCenterNorm.x,letterDiff.tCenterNorm.y);
      
      currentLetterDiff = letterDiff;
    }
    // Letter does not exit => default parameters
    else
    {
      setScaleLetter( 0.65f );
      setScaleAurba( 1.0f );
      setCenter(0,0);
    }
    
    updateControls();    
    updateComposition();
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setScaleLetter( float v )
  {
    mPolygonLetter = new RMatrix();
    mPolygonLetter.scale(v);
    scaleLetter = v;

    invalidateComposition = true;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setScaleAurba( float v )
  {
    mPolygonAurbaScale = new RMatrix();
    mPolygonAurbaScale.scale(v);
    scaleAurba = v;
    
    invalidateComposition = true;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setCenter(float dx, float dy)
  {  
    tCenterNorm.x = dx;
    tCenterNorm.y = dy;
    
    invalidateComposition = true;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setFont(int idFont)
  {
    loadFont(fontNames[idFont]);
    invalidateComposition = true;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  RFont getFontCurrent()
  {
    return fontCurrent;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void export()
  {
    export = true;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void exportBitmap()
  {
    exportBitmap = true;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void saveTypo()
  {
    if (trim(typoName).equals("")) return;
    
    String xml="<typo";
    if (!toolVisualisation.config().currentFilename.equals(""))
    {
          xml+=" visualisation=\""+toolVisualisation.config().currentFilename+"\"";
    }
    xml+=">\n";

    Iterator it = listLetterDiff.entrySet().iterator();
    while (it.hasNext ())
    {
      java.util.Map.Entry me = (java.util.Map.Entry)it.next();

      LetterDiff letterDiff = (LetterDiff) me.getValue();
      xml+=letterDiff.toXML();
    }
    xml += "</typo>\n"; 
  
    String[] s={xml};

    saveStrings("typos/"+typoName, s);
  }
  
  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void loadTypo(String path)
  {
    File f = new File(path);
    typoName = f.getName();
    
    XMLElement xml = new XMLElement(applet, path);
    
    String visualisation = xml.getString("visualisation");
    if (visualisation!=null && !visualisation.equals("")){
      println(sketchPath+"/configurations/"+visualisation+".xml");
      toolVisualisation.loadConfig(sketchPath+"/configurations/"+visualisation+".xml");
    }

    int numLetters = xml.getChildCount();
    if (numLetters>0)
    {
      listLetterDiff = new HashMap<String, LetterDiff>();
      for (int i = 0; i < numLetters; i++) 
      {
        XMLElement xmlLetterDiff = xml.getChild(i);
        String value = xmlLetterDiff.getString("value");
        LetterDiff letterDiff = makeInstanceLetterDiffFromXML(xmlLetterDiff);
        listLetterDiff.put(value, letterDiff);

        // Recreate the slices etc ... here
        setText(value);
      }

      // Set first letter by default
      Iterator it = listLetterDiff.entrySet().iterator();
      if (it.hasNext())
      {
        java.util.Map.Entry first = (java.util.Map.Entry)it.next();
        LetterDiff letterDiffFirst = (LetterDiff) first.getValue();
        setText(letterDiffFirst.txt);
      }
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void keyPressed()
  {
     saveTypo();
  }

}

