class ToolIdentityString extends Tool
{
  HashMap<String, LetterDiff> listLetterDiff;
  ArrayList<LetterDiff> listLetterDiffString;

  String strCurrent="";
  RGroup groupLetterDiffPolygon;

  PGraphics pgExport;
  boolean isExport = false;

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  ToolIdentityString(PApplet p)
  {
    super(p);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public String getId()
  {
    return "__ToolIdentityString__";
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void initControls()
  {
    String tabIdentityString = "Identite / Mot";
    tabName = tabIdentityString;

    cp5.tab(tabIdentityString).activateEvent(true);
    cp5.tab(tabIdentityString).setHeight(20);
    cp5.tab(tabIdentityString).setId(id);
    cp5.tab(tabIdentityString).captionLabel().style().marginTop = 2;

    int x = 2;
    int y = 22;

    int toggleMarginLeft = 24;
    int toggleMarginTop = -18;

    controlP5.Button btnExport = cp5.addButton("exportWord", 0, x, y, 46, 20).addListener(this);
    btnExport.setLabel("Exporter").linebreak();
    btnExport.moveTo(tabIdentityString);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  public void controlEvent(ControlEvent theEvent)
  {
    String nameSource = theEvent.name();
    if ( nameSource.equals("exportWord"))
    {
      isExport = true;
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void setup()
  {
    strCurrent = "";
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  RShape drawString(PGraphics g, RFont theFont)
  {
    if (theFont != null)
    {
      RCommand.setSegmentLength(30); // distance entre deux points sur le texte
      RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

      RShape shape = theFont.toShape(strCurrent);
      shape = RG.centerIn(shape, g, 20);


      g.pushMatrix();
      g.translate(g.width/2, g.height/2);
      if (shape.children!=null)
      {
        RShape child;        

        g.noStroke();
        for (int i=0;i<shape.children.length;i++)
        {
          child = shape.children[i];

          float w = child.getWidth();
          float wL = listLetterDiffString.get(i).polygonLetterOriginal.getWidth();
          float s = w/wL;

          g.pushMatrix();
          g.translate(child.getX()+0.5*child.getWidth(), child.getY()+0.5*child.getHeight());
          g.scale(s);
          LetterDiff letterDiff = listLetterDiffString.get(i);
          if ( letterDiff!=null && letterDiff.group()!=null)
            letterDiff.group().draw(g); // CRASH inside polygon draw sometimes...
          g.popMatrix();
        }
      }
      g.popMatrix();
      
      return shape;
    }
    
    return null;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void draw()
  {
    if (listLetterDiffString == null) return;   
    if (listLetterDiff == null)
    {
      listLetterDiff = toolIdentity.listLetterDiff;
    }

    // Background
    RFont theFont = toolIdentity.getFontCurrent();

    background(colorBg);
    RShape shapeScreen = drawString(applet.g,theFont);
      
    if (isExport)
    {
      int fZoom = 10;
      pgExport = createGraphics(int(shapeScreen.getWidth()*fZoom), int(shapeScreen.getHeight()*fZoom), JAVA2D);

      pgExport.background(255,0);
      drawString(pgExport,theFont);
      pgExport.save("exports/"+timestamp()+"_export_bitmap_"+strCurrent+".png");
      isExport = false;
    }
    
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void updatePolygonString()
  {
    listLetterDiffString = new ArrayList<LetterDiff>();

    String strChar;
    for (int i=0;i<strCurrent.length();i++)
    {
      strChar = ""+strCurrent.charAt(i);
      LetterDiff letterDiff = listLetterDiff.get(strChar);
      if (letterDiff != null)
      {
        LetterDiff letterDiffCopy = new LetterDiff(letterDiff); 
        listLetterDiffString.add( letterDiffCopy );
      }
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void keyPressed()
  {
    boolean doUpdate = false;
//    if ((key>='a' && key<='z') || (key>='A' && key<='Z') || key == BACKSPACE)
    {
      if (key == BACKSPACE)
      {
        if (strCurrent.length()>0) {
          strCurrent = strCurrent.substring(0, strCurrent.length()-1);
          doUpdate = true;
        }
      }
      else
      {
        String strc = ""+key;      
        if (listLetterDiff.containsKey(strc)) {
          strCurrent += key;
          doUpdate = true;
        }
      }
    }
    if (doUpdate)
      updatePolygonString();
  }
}

