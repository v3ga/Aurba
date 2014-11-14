 // --------------------------------------------------------------------
// import
// --------------------------------------------------------------------
import processing.opengl.*;
import processing.pdf.*;
import codeanticode.glgraphics.*;
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import geomerative.*;
import controlP5.*;
import javax.xml.bind.*;
import javax.xml.bind.annotation.*;
import java.io.File; 
import java.util.Date; 
import jxl.*; 

// --------------------------------------------------------------------
// Variables
// --------------------------------------------------------------------
color colorBg;
color colorAgence;
de.fhpotsdam.unfolding.Map carte;
ControlP5 cp5;

AgenceManager agenceManager;
ToolManager toolManager;
ToolCarte toolCarte;
ToolVisualisation toolVisualisation;
ToolIdentity toolIdentity;
ToolIdentityString toolIdentityString;

String fichierAgence = "gps_dens_rgb_02.xls";

// --------------------------------------------------------------------
// setup()
// --------------------------------------------------------------------
void setup()
{
  // Window
  size(1024,768,GLConstants.GLGRAPHICS);
  smooth();
  
  // Tools
  toolManager = new ToolManager(this);
  toolCarte = new ToolCarte(this);
  toolVisualisation = new ToolVisualisation(this);
  toolIdentity = new ToolIdentity(this);
  toolIdentityString = new ToolIdentityString(this);
  
  toolManager.addTool ( (Tool) toolCarte ); 
  toolManager.addTool ( (Tool) toolVisualisation ); 
  toolManager.addTool ( (Tool) toolIdentity ); 
  toolManager.addTool ( (Tool) toolIdentityString ); 
  
  // Carte shortcut
  carte = toolCarte.carte;

  // Agences
  agenceManager = new AgenceManager();
  agenceManager.setup();

  // Controls
  toolManager.initControls(this);

  // Set up tools
  toolManager.setup();

  // Default tool open
  toolManager.select(toolVisualisation);
  
  // Variables
  colorBg = color(219,223,224);
  colorAgence = color(96,174,211);
}

// --------------------------------------------------------------------
// draw()
// --------------------------------------------------------------------
void draw()
{
  toolManager.draw();
}

// --------------------------------------------------------------------
// mousePressed()
// --------------------------------------------------------------------
void mousePressed()
{
  toolManager.mousePressed();
}


// --------------------------------------------------------------------
// keyPressed
// --------------------------------------------------------------------
void keyPressed()
{
  toolManager.keyPressed();
}

// --------------------------------------------------------------------
// controlEvent
// --------------------------------------------------------------------
void controlEvent(ControlEvent theEvent) 
{
  if (theEvent.isTab()){
    toolManager.select(theEvent.tab().id());
  }
}


