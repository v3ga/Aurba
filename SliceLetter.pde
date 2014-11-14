class LetterDiff
{
  // List of polygon
  ArrayList<RPolygon> listSliceDiff;

  // Original letter polygon
  // from which the slices are made
  RPolygon polygonLetterOriginal;

  // Used in the letter editor
  PVector tCenterNorm = new PVector();
  float scaleLetter = 1.0f;
  float scaleAurba = 1.0f;

  // Group
  RGroup rg;

  // Texte
  String txt = "";

  // Scale
  float scaleFactor = 0.5f;

  // Position
  float x = 0.0f;
  // --------------------------------------------------------------------
  // Constructeurs
  // --------------------------------------------------------------------
  LetterDiff(String s)
  {
    txt = s;
  }

  LetterDiff(LetterDiff otherLetter)
  {
    this.set(otherLetter.listSliceDiff, otherLetter.polygonLetterOriginal);
    this.txt = otherLetter.txt;
    this.scaleFactor = otherLetter.scaleFactor;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  PVector getBoundingGroup()
  {
    return getRRectangleDim( rg.getBoundsPoints() );
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void applyScaleToGroup()
  {
    rg.scale(scaleFactor);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void translateGroup(float x, float y)
  {
    rg.translate(x, y);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  // Make a copy
  // And create a group
  void set(ArrayList<RPolygon> listPolygon, RPolygon polygonLetterOriginal) 
  {
    rg = new RGroup();
    listSliceDiff = new ArrayList<RPolygon>();
    for (RPolygon p:listPolygon) 
    {
      RPolygon pCopy = new RPolygon(p);
      listSliceDiff.add(pCopy);
      RMesh mesh = p.toMesh();
      if (mesh != null){ // otherwise may crash in the group drawing
        rg.addElement(pCopy);
      }
    }

    this.polygonLetterOriginal = new RPolygon(polygonLetterOriginal);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  RGroup group()
  {
    return rg;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void addToRGroup(RGroup rg)
  {
    for (RPolygon slice:listSliceDiff)
    {
      rg.addElement(slice);
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  String toXML()
  {
    return "\t<letterDiff value=\""+txt+"\" tx=\""+tCenterNorm.x+"\" ty=\""+tCenterNorm.y+"\" scaleLetter=\""+scaleLetter+"\" scaleAurba=\""+scaleAurba+"\" />\n";
  }
};

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
LetterDiff makeInstanceLetterDiffFromXML(XMLElement xmlLetterDiff)
{
  String value = xmlLetterDiff.getString("value");
  
  LetterDiff letterDiff = new LetterDiff(value);
  letterDiff.tCenterNorm.x = xmlLetterDiff.getFloat("tx");
  letterDiff.tCenterNorm.y = xmlLetterDiff.getFloat("ty");
  letterDiff.scaleLetter = xmlLetterDiff.getFloat("scaleLetter");
  letterDiff.scaleAurba = xmlLetterDiff.getFloat("scaleAurba");

  return letterDiff;
}





