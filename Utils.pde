// ------------------------------------------------
// ------------------------------------------------
PVector getRRectangleDim(RPoint[] rp)
{
  return new PVector(abs(rp[2].x-rp[0].x), abs(rp[2].y-rp[0].y));
}

// ------------------------------------------------
// updateToggle
// ------------------------------------------------
void updateToggle(Toggle t, boolean v)
{
  t.setValue(v?1.0f:0.0f);
}

// ------------------------------------------------
// updateSliderZoom
// ------------------------------------------------
void updateSliderZoom()
{
  if (toolCarte.sliderZoom != null)
    toolCarte.sliderZoom.setValue( carte.getZoomFromScale(carte.mapDisplay.innerScale) );
}

// ------------------------------------------------
// cross
// ------------------------------------------------
void cross(float x, float y, float l)
{
  line(x,y-l,x,y+l);
  line(x-l,y,x+l,y);
}


// ------------------------------------------------
// timestamp
// ------------------------------------------------
String timestamp() 
{
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

// ------------------------------------------------
// ------------------------------------------------
void arc2(float x, float y, float radius0, float radius1, float angle0, float angle1)
{
  // Subdivide
  int nbSubdiv = 30;
  float dAngle = angle1-angle0;
  if (abs(dAngle) >=10.0f) {
    float step = dAngle/float(nbSubdiv);
    for (int j=0;j<nbSubdiv;j++) {
      float rr0 = (radius1-radius0)*float(j)/float(nbSubdiv) + radius0; 
      float rr1 = (radius1-radius0)*float(j+1)/float(nbSubdiv) + radius0; 

      float xx0 = x+0.5f*rr0*cos(radians(angle0+j*step));
      float yy0 = y+0.5f*rr0*sin(radians(angle0+j*step));
      float xx1 = x+0.5f*rr1*cos(radians(angle0+(j+1)*step));
      float yy1 = y+0.5f*rr1*sin(radians(angle0+(j+1)*step));

      line(xx0, yy0, xx1, yy1);
    }
  }
  else {
    float x0 = x + 0.5f*radius0*cos(radians(angle0));
    float y0 = y + 0.5f*radius0*sin(radians(angle0));
    float x1 = x + 0.5f*radius1*cos(radians(angle1));
    float y1 = y + 0.5f*radius1*sin(radians(angle1));

    line(x0, y0, x1, y1);
  }
}

// ------------------------------------------------
// bubbleSort
// 
// http://www.openprocessing.org/visuals/?visualID=27745
// ------------------------------------------------
ArrayList<Agence> bubbleSort(ArrayList<Agence> list, int method)
{
  ArrayList<Agence> listSorted = new ArrayList<Agence>();
  for (Agence a:list) listSorted.add(a); 

  int out, in;
  int nElems = list.size();
  int counts = 0;
  for (out=nElems-1; out>1; out--) {

    for (in=0; in<out; in++) {
      Agence A = listSorted.get(in);
      Agence B = listSorted.get(in+1);

      if (method == agenceManager.SORT_ANGLE) {
        if ( A.angleBordeaux > B.angleBordeaux ) {
          swap(listSorted, in, in+1);
        }
      }
      else
      if (method == agenceManager.SORT_DISTANCE){
        // TODO
      }
    }
  }

  return listSorted;
}

// ------------------------------------------------
// swap
// ------------------------------------------------
void swap(ArrayList<Agence> list, int one, int two)
{
  Agence temp = list.get(one);
  list.set(one, list.get(two));
  list.set(two, temp);
}

