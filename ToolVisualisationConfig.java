import java.util.*;
import javax.xml.bind.*;
import javax.xml.bind.annotation.*;
import processing.core.*;
import java.io.PrintWriter;
 
@XmlRootElement(name="toolVisualisation")
class ToolVisualisationConfig
{
  String currentFilename = "";
  
  @XmlElement
  boolean isDrawVilles = true;
  @XmlElement
  boolean isDrawSubdiv = false;
  @XmlElement
  boolean isDrawLines = false;
  @XmlElement
  boolean isDrawLinesInner = false;
  @XmlElement
  boolean isDrawCouleurs = true;
  @XmlElement
  float radiusInner = 100.0f;
  @XmlElement
  float radiusExternMin = 400.0f;
  @XmlElement
  float radiusExternMax = 500.0f;
  @XmlElement
  float radiusOeil = 50.0f;
  @XmlElement
  int colorDensMin = 0x000000;
  @XmlElement
  int colorDensMax = 0xffffff;
  @XmlElement
  float percentColorDensMin = 100.0f;
  @XmlElement
  float percentColorDensMax = 100.0f;
}


