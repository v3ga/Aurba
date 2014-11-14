// --------------------------------------------------------------------
// loadDocumentExcel
// --------------------------------------------------------------------
DocumentExcel loadDocumentExcel(String nom)
{
  DocumentExcel document = new DocumentExcel(nom);
  document.load();
  return document;
}

// --------------------------------------------------------------------
// class DocumentExcel
// --------------------------------------------------------------------
class DocumentExcel
{
  String nom;
  String chemin;
  Workbook document;
  Sheet page;
  int nbColonnes = 0;
  int nbLignes = 0;

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  DocumentExcel(String nom_)
  {
    nom = nom_;
    chemin = dataPath(nom_);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  void load()
  {
    println("Chargement de "+nom);
    println(" - chemin :  "+chemin);

    // Chargement du document
    try {
      document = Workbook.getWorkbook(new File(chemin));
    }
    catch(BiffException e)
    {
      println(" - ERREUR : "+e);
    }
    catch(IOException e)
    {
      println("- ERREUR : "+e);
    }

    // Chargement de la première page
    if (document != null) {
      page = document.getSheet(0);
      if (page!=null)
      {
        nbColonnes = page.getColumns();
        nbLignes = page.getRows();

        println(" - nombre de colonnes : "+nbColonnes);
        println(" - nombre de lignes : "+nbLignes);
      }
    }
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------------------------
  String getCellContent(int colonne, int ligne)
  {
    String s="";

    if (page!=null && ligne<nbLignes && colonne<nbColonnes)
    {
      Cell cellule = page.getCell(colonne, ligne);
      if (cellule.getType() == CellType.LABEL) 
      { 
        LabelCell lc = (LabelCell) cellule; 
        s = lc.getString();
      } 

      if (cellule.getType() == CellType.NUMBER) 
      { 
        NumberCell nc = (NumberCell) cellule; 
        s = ""+nc.getValue();
      } 
    }
    else
    {
      println("ERREUR : la ligne ou la colonne n'existe pas...");
    }

    return s;
  }
}

