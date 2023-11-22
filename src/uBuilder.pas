unit uBuilder;

interface

type
  TLogEvent = procedure(Txt: string) of object;

var
  onErrorLog: TLogEvent;
  onDebugLog: TLogEvent;
  onLog: TLogEvent;

function BuildTextFromTemplate(AVideoCode: integer; ATubeCode: integer): string;

implementation

uses
  System.DateUtils,
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  System.StrUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uDB;

function BuildTextFromTemplate(AVideoCode: integer; ATubeCode: integer): string;
var
  Source, Destination, PrecedentFichier: string;
  PosCurseur, PosMarqueur: integer;
  Marqueur: string;
  Listes: TDictionary<string, string>;
  ListePrecedentePosListe: tstack<integer>;
  PosListe: integer;
  PremierElementListesPrecedentes: tstack<boolean>;
  PremierElementListeEnCours: boolean;
  ListePrecedenteAvaitElem: tstack<boolean>;
  ListeAvaitElem: boolean;
  AfficheBlocsPrecedents: tstack<boolean>;
  AfficheBlocEnCours: boolean;
  ListeNomTable: string;
  QryList: TObjectDictionary<string, TFDQuery>;

  /// <param name="Marqueur">
  /// Le marqueur est en format "Table_Field" avec éventuellement plusieurs oulignés au niveau de la table, mais la dernière partie est forcément le champ.
  /// </param>
  function GetValue(Marqueur: string): string;
  var
    QRY: TFDQuery;
    Table, Field: string;
  begin
    Field := Marqueur.Substring(Marqueur.LastIndexOf('_') + 1);
    Table := Marqueur.Substring(0, Marqueur.Length - Field.Length - 1);
    if (not QryList.TryGetValue(Table, QRY)) then
      raise exception.Create('Unknown table "' + Table + '" for keyword "' +
        Marqueur + '".');
    if QRY.Active and (not QRY.bof) and (not QRY.Eof) then
      try
        result := QRY.FieldByName(Field).asstring
      except
        raise exception.Create('Unknown field "' + Field + '" in the table "' +
          Table + '" for keyword "' + Marqueur + '".');
      end
    else
      result := '';
  end;

  function RemplaceMarqueur(Marqueur: string): string;
  begin
    // onDebugLog('Tag : ' + Marqueur);
    result := '';
    if Marqueur = 'livre_code' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.id.tostring;
    end
    else if Marqueur = 'livre_titre' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.title;
    end
    else if Marqueur = 'livre_titre-xml' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.title.Replace('&', 'and');
    end
    else if Marqueur = 'livre_isbn10' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.isbn10;
    end
    else if Marqueur = 'livre_gencod' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.isbn13;
    end
    else if Marqueur = 'livre_anneedesortie' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.PublishedDateYYYY;
    end
    else if Marqueur = 'livre_datedesortie' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := Date8ToString(QRY.AsBook.PublishedDateYYYYMMDD);
    end
    else if Marqueur = 'livre_datedesortie-iso' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := Date8ToStringISO(QRY.AsBook.PublishedDateYYYYMMDD);
    end
    else if Marqueur = 'livre_datedesortie-rfc822' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := Date8ToStringRFC822(QRY.AsBook.PublishedDateYYYYMMDD);
    end
    else if Marqueur = 'livre_url_site' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.WebSiteURL;
    end
    else if Marqueur = 'livre_nom_page' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.PageName;
    end
    else if Marqueur = 'livre_langue_libelle' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsBook.LanguageISOCode).Text;
    end
    else if Marqueur = 'livre_langue_nom_page' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsBook.LanguageISOCode).PageName;
    end
    else if Marqueur = 'livre_langue_code_iso' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.LanguageISOCode;
    end
    else if Marqueur = 'livre_photo' then
    begin
      QRY := GetQry('livres');
      if (not QRY.Eof) then
        result := QRY.AsBook.PageName.Replace('.html',
          TDelphiBooksDatabase.CThumbExtension);
    end
    {
      //
      // Readers and there comments are not available in this release
      //
      else if Marqueur = 'livre_commentaire' then
      begin
      qry := GetQry('livre_commentaires');
      if (not qry.EOF) then
      result := qry.FieldByName('commentaire').asstring;
      end
      else if Marqueur = 'livre_commentaire_langue_libelle' then
      begin
      qry := GetQry('livre_commentaires');
      if (not qry.EOF) then
      result := qry.FieldByName('langue_libelle').asstring;
      end
      else if Marqueur = 'livre_commentaire_langue_code_iso' then
      begin
      qry := GetQry('livre_commentaires');
      if (not qry.EOF) then
      result := qry.FieldByName('langue_code_iso').asstring;
      end
      else if Marqueur = 'livre_commentaire_langue_nom_page' then
      begin
      qry := GetQry('livre_commentaires');
      if (not qry.EOF) then
      result := qry.FieldByName('langue_nom_page').asstring;
      end
      else if Marqueur = 'livre_commentaire_date' then
      begin
      qry := GetQry('livre_commentaires');
      if (not qry.EOF) then
      result := Date8ToString(qry.FieldByName('dateducommentaire').asstring);
      end
      else if Marqueur = 'livre_commentaire_pseudo' then
      begin
      qry := GetQry('livre_commentaires');
      if (not qry.EOF) then
      result := qry.FieldByName('pseudo').asstring;
      end
      else if Marqueur = 'livre_commentaire_nom_page' then
      begin
      qry := GetQry('livre_commentaires');
      if (not qry.EOF) then
      result := qry.FieldByName('nom_page').asstring;
      end
    }
    else if Marqueur = 'livre_tabledesmatieres' then
    begin
      QRY := GetQry('livre_tablesdesmatieres');
      if (not QRY.Eof) then
        result := QRY.AsTOC.Text;
    end
    else if Marqueur = 'livre_tabledesmatieres_langue_libelle' then
    begin
      QRY := GetQry('livre_tablesdesmatieres');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsTOC.LanguageISOCode).Text;
    end
    else if Marqueur = 'livre_tabledesmatieres_langue_code_iso' then
    begin
      QRY := GetQry('livre_tablesdesmatieres');
      if (not QRY.Eof) then
        result := QRY.AsTOC.LanguageISOCode;
    end
    else if Marqueur = 'livre_tabledesmatieres_langue_nom_page' then
    begin
      QRY := GetQry('livre_tablesdesmatieres');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsTOC.LanguageISOCode).PageName;
    end
    else if Marqueur = 'livre_description' then
    begin
      QRY := GetQry('livre_descriptions');
      if (not QRY.Eof) then
        result := QRY.AsDescription.Text;
    end
    else if Marqueur = 'livre_description_langue_libelle' then
    begin
      QRY := GetQry('livre_descriptions');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsDescription.LanguageISOCode).Text;
    end
    else if Marqueur = 'livre_description_langue_code_iso' then
    begin
      QRY := GetQry('livre_descriptions');
      if (not QRY.Eof) then
        result := QRY.AsDescription.LanguageISOCode;
    end
    else if Marqueur = 'livre_description_langue_nom_page' then
    begin
      QRY := GetQry('livre_descriptions');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsDescription.LanguageISOCode).PageName;
    end
    else if Marqueur = 'motcle_libelle' then
    begin
      QRY := GetQry('motscles');
      if (not QRY.Eof) then
        result := QRY.AsKeyword.Text;
    end
    else if Marqueur = 'motcle_nom_page' then
    begin
      QRY := GetQry('motscles');
      if (not QRY.Eof) then
        result := QRY.AsKeyword.PageName;
    end
    {
      //
      // Readers are not available in this release
      //

      else if Marqueur = 'lecteur_pseudo' then
      begin
      qry := GetQry('lecteurs');
      if (not qry.EOF) then
      result := qry.FieldByName('pseudo').asstring;
      end
      else if Marqueur = 'lecteur_url_site' then
      begin
      qry := GetQry('lecteurs');
      if (not qry.EOF) then
      result := qry.FieldByName('url_site').asstring;
      end
      else if Marqueur = 'lecteur_nom_page' then
      begin
      qry := GetQry('lecteurs');
      if (not qry.EOF) then
      result := qry.FieldByName('nom_page').asstring;
      end
      else if Marqueur = 'lecteur_photo' then
      begin
      qry := GetQry('lecteurs');
      if (not qry.EOF) then
      result := qry.FieldByName('nom_page').asstring.Replace('.html',
      CImageExtension);
      end
    }
    else if Marqueur = 'langue_libelle' then
    begin
      QRY := GetQry('langues');
      if (not QRY.Eof) then
        result := QRY.AsLanguage.Text;
    end
    else if Marqueur = 'langue_code_iso' then
    begin
      QRY := GetQry('langues');
      if (not QRY.Eof) then
        result := QRY.AsLanguage.LanguageISOCode;
    end
    else if Marqueur = 'langue_nom_page' then
    begin
      QRY := GetQry('langues');
      if (not QRY.Eof) then
        result := QRY.AsLanguage.PageName;
    end
    else if Marqueur = 'langue_photo' then
    begin
      QRY := GetQry('langues');
      if (not QRY.Eof) then
        result := QRY.AsLanguage.PageName.Replace('.html',
          TDelphiBooksDatabase.CThumbExtension);
    end
    else if Marqueur = 'page_langue_libelle' then
    begin
      result := ALang.Text;
    end
    else if Marqueur = 'page_langue_code_iso' then
    begin
      result := ALang.LanguageISOCode;
    end
    else if Marqueur = 'page_langue_nom_page' then
    begin
      result := ALang.PageName;
    end
    else if Marqueur = 'page_langue_photo' then
    begin
      result := ALang.PageName.Replace('.html',
        TDelphiBooksDatabase.CThumbExtension);
    end
    else if Marqueur = 'page_copyright_annees' then
    begin
      if yearof(now) > 2020 then
        result := '2020-' + yearof(now).tostring
      else
        result := '2020';
    end
    else if Marqueur = 'page_filename' then
    begin
      result := tpath.GetFileName(ADestFile);
    end
    else if Marqueur = 'page_url' then
    begin
      result := 'https://delphi-books.com/' + ALang.LanguageISOCode + '/' +
        tpath.GetFileName(ADestFile);
    end
    else if Marqueur = 'editeur_code' then
    begin
      QRY := GetQry('editeurs');
      if (not QRY.Eof) then
        result := QRY.AsPublisher.id.tostring;
    end
    else if Marqueur = 'editeur_raison_sociale' then
    begin
      QRY := GetQry('editeurs');
      if (not QRY.Eof) then
        result := QRY.AsPublisher.CompanyName;
    end
    else if Marqueur = 'editeur_url_site' then
    begin
      QRY := GetQry('editeurs');
      if (not QRY.Eof) then
        result := QRY.AsPublisher.WebSiteURL;
    end
    else if Marqueur = 'editeur_nom_page' then
    begin
      QRY := GetQry('editeurs');
      if (not QRY.Eof) then
        result := QRY.AsPublisher.PageName;
    end
    else if Marqueur = 'editeur_photo' then
    begin
      QRY := GetQry('editeurs');
      if (not QRY.Eof) then
        result := QRY.AsPublisher.PageName.Replace('.html',
          TDelphiBooksDatabase.CThumbExtension);
    end
    else if Marqueur = 'editeur_description' then
    begin
      QRY := GetQry('editeur_descriptions');
      if (not QRY.Eof) then
        result := QRY.AsDescription.Text;
    end
    else if Marqueur = 'editeur_description_langue_libelle' then
    begin
      QRY := GetQry('editeur_descriptions');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsDescription.LanguageISOCode).Text;
    end
    else if Marqueur = 'editeur_description_langue_code_iso' then
    begin
      QRY := GetQry('editeur_descriptions');
      if (not QRY.Eof) then
        result := QRY.AsDescription.LanguageISOCode;
    end
    else if Marqueur = 'editeur_description_langue_nom_page' then
    begin
      QRY := GetQry('editeur_descriptions');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsDescription.LanguageISOCode).PageName;
    end
    else if Marqueur = 'auteur_code' then
    begin
      QRY := GetQry('auteurs');
      if (not QRY.Eof) then
        result := QRY.AsAuthor.id.tostring;
    end
    else if Marqueur = 'auteur_nom' then
    begin
      QRY := GetQry('auteurs');
      if (not QRY.Eof) then
        result := QRY.AsAuthor.LastName;
    end
    else if Marqueur = 'auteur_prenom' then
    begin
      QRY := GetQry('auteurs');
      if (not QRY.Eof) then
        result := QRY.AsAuthor.FirstName;
    end
    else if Marqueur = 'auteur_pseudo' then
    begin
      QRY := GetQry('auteurs');
      if (not QRY.Eof) then
        result := QRY.AsAuthor.Pseudo;
    end
    else if Marqueur = 'auteur_libelle' then
    begin
      QRY := GetQry('auteurs');
      if (not QRY.Eof) then
        result := QRY.AsAuthor.PublicName;
    end
    else if Marqueur = 'auteur_url_site' then
    begin
      QRY := GetQry('auteurs');
      if (not QRY.Eof) then
        result := QRY.AsAuthor.WebSiteURL;
    end
    else if Marqueur = 'auteur_nom_page' then
    begin
      QRY := GetQry('auteurs');
      if (not QRY.Eof) then
        result := QRY.AsAuthor.PageName;
    end
    else if Marqueur = 'auteur_photo' then
    begin
      QRY := GetQry('auteurs');
      if (not QRY.Eof) then
        result := QRY.AsAuthor.PageName.Replace('.html',
          TDelphiBooksDatabase.CThumbExtension);
    end
    else if Marqueur = 'auteur_description' then
    begin
      QRY := GetQry('auteur_descriptions');
      if (not QRY.Eof) then
        result := QRY.AsDescription.Text;
    end
    else if Marqueur = 'auteur_description_langue_libelle' then
    begin
      QRY := GetQry('auteur_descriptions');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsDescription.LanguageISOCode).Text;
    end
    else if Marqueur = 'auteur_description_langue_code_iso' then
    begin
      QRY := GetQry('auteur_descriptions');
      if (not QRY.Eof) then
        result := QRY.AsDescription.LanguageISOCode;
    end
    else if Marqueur = 'auteur_description_langue_nom_page' then
    begin
      QRY := GetQry('auteur_descriptions');
      if (not QRY.Eof) then
        result := ADB.Languages.GetItemByLanguage
          (QRY.AsDescription.LanguageISOCode).Text;
    end
    else if Marqueur = 'date' then
    begin
      result := Date8ToString(DateToString8(now));
    end
    else if Marqueur = 'date-iso' then
    begin
      result := Date8ToStringISO(DateToString8(now));
    end
    else if Marqueur = 'date-rfc822' then
    begin
      result := Date8ToStringRFC822(DateToString8(now));
    end
    else
      raise exception.Create('Unknown tag "' + Marqueur + '" in template "' +
        ATemplateFile + '".');
  end;

begin
  onDebugLog('Template : ' + tpath.GetFileNameWithoutExtension(ATemplateFile));

  if assigned(AItem) then
    onDebugLog('Item "' + AItem.tostring + '" from "' + ADataName + '".');

  if not tfile.Exists(ATemplateFile) then
    raise exception.Create('Template file "' + ATemplateFile + '" not found.');
  try
    Source := tfile.ReadAllText(ATemplateFile, tencoding.UTF8);
  except
    raise exception.Create('Can''t load "' + ATemplateFile + '".');
  end;

  if ADestFile.IsEmpty then
    raise exception.Create('Empty page name for "' + AItem.tostring + '" from "'
      + ADataName + '".');

      // TODO : transférer propriété des QRY au dictionnaire
        QryList:= TObjectDictionary<string, TFDQuery>.create();
        // TODO : créer les QRY et les stocker pour les différents niveaux de l'arborescence
    // QRY := TFDQuery.Create(nil);
    // QRY.Connection := DB.FDConnection1;
    // QRY.Open('select * from ' + Table);
    // QryList.Add(Table, QRY);

  try
    Listes := TDictionary<string, string>.Create;
    try
      PremierElementListeEnCours := false;
      PremierElementListesPrecedentes := tstack<boolean>.Create;
      try
        ListeAvaitElem := false;
        ListePrecedenteAvaitElem := tstack<boolean>.Create;
        try
          AfficheBlocEnCours := true;
          AfficheBlocsPrecedents := tstack<boolean>.Create;
          try
            PosListe := Length(Source);
            ListePrecedentePosListe := tstack<integer>.Create;
            try
              Destination := '';
              PosCurseur := 0;
              try
                while (PosCurseur < Length(Source)) do
                begin
                  PosMarqueur := Source.IndexOf('!$', PosCurseur);
                  if (PosMarqueur >= 0) then
                  begin // tag trouvé, on le traite
                    if AfficheBlocEnCours then
                      Destination := Destination + Source.Substring(PosCurseur,
                        PosMarqueur - PosCurseur);
                    Marqueur := Source.Substring(PosMarqueur + 2,
                      Source.IndexOf('$!', PosMarqueur + 2) - PosMarqueur -
                      2).ToLower;
                    if Marqueur.StartsWith('liste_') then
                    begin
                      // ne traite pas de listes imbriquées
{$REGION 'listes gérées par le logiciel'}
                      if Marqueur = 'liste_livres' then
                      begin
                        ListeNomTable := 'livres';
                        ADB.Books.SortByTitle;
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectBooks(ADB.Books);
                      end
                      else if Marqueur = 'liste_livres-par_date' then
                      begin
                        ListeNomTable := 'livres';
                        ADB.Books.SortByPublishedDateDesc;
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectBooks(ADB.Books);
                      end
                      else if Marqueur = 'liste_livres_recents' then
                      begin
                        // que les livres édités depuis 1 an (année glissante)
                        ListeNomTable := 'livres';
                        ADB.Books.SortByPublishedDateDesc;
                        var
                        OneYearAgo := DateToString8(incyear(now, -1));
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectBooks(ADB.Books,
                          function(ABook: TDelphiBooksBook): boolean
                          begin
                            result := ABook.PublishedDateYYYYMMDD > OneYearAgo;
                          end);
                      end
                      else if Marqueur = 'liste_livres_derniers_ajouts' then
                      begin
                        // que les 14 derniers (7 par ligne dans le design classique du site, donc 2 lignes)
                        ListeNomTable := 'livres';
                        ADB.Books.SortByIdDesc;
                        var
                          nb: byte := 0;
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectBooks(ADB.Books,
                          function(ABook: TDelphiBooksBook): boolean
                          begin
                            if (nb < 14) then
                            begin
                              result := true;
                              inc(nb);
                            end
                            else
                              result := false;
                          end);
                      end
                      else if Marqueur = 'liste_livres_par_editeur' then
                      begin
                        ADB.Books.SortByTitle;
                        QRY := GetQry('editeurs');
                        try
                          LShortBooksList := QRY.AsPublisher.Books;
                        except
                          LShortBooksList := nil;
                        end;
                        ListeNomTable := 'livres';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectBooks(ADB.Books,
                          function(ABook: TDelphiBooksBook): boolean
                          begin
                            result := assigned(LShortBooksList) and
                              assigned(LShortBooksList.GetItemByID(ABook.id));
                          end);
                      end
                      else if Marqueur = 'liste_livres_par_auteur' then
                      begin
                        ADB.Books.SortByTitle;
                        QRY := GetQry('auteurs');
                        try
                          LShortBooksList := QRY.AsAuthor.Books;
                        except
                          LShortBooksList := nil;
                        end;
                        ListeNomTable := 'livres';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectBooks(ADB.Books,
                          function(ABook: TDelphiBooksBook): boolean
                          begin
                            result := assigned(LShortBooksList) and
                              assigned(LShortBooksList.GetItemByID(ABook.id));
                          end);
                      end
                      else if Marqueur = 'liste_livres_par_motcle' then
                      begin
                        raise exception.Create
                          ('"liste_livres_par_motcle" is not available in this release');
                      end
                      else if Marqueur = 'liste_livres_par_langue' then
                      begin
                        ADB.Books.SortByTitle;
                        QRY := GetQry('langues');
                        var
                        ISO := QRY.AsLanguage.LanguageISOCode;
                        ListeNomTable := 'livres';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectBooks(ADB.Books,
                          function(ABook: TDelphiBooksBook): boolean
                          begin
                            result := (ABook.LanguageISOCode = ISO);
                          end);
                      end
                      {
                        else if Marqueur = 'liste_commentaires_par_livre' then
                        begin
                        raise exception.Create
                        ('"liste_commentaires_par_livre" is not available in this release');
                        end
                      }
                      else if Marqueur = 'liste_tabledesmatieres_par_livre' then
                      begin
                        QRY := GetQry('livres');
                        try
                          LTOCsList := QRY.AsBook.TOCs;
                        except
                          LTOCsList := nil;
                        end;
                        ListeNomTable := 'livre_tablesdesmatieres';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectTableOfContents(LTOCsList);
                      end
                      else if Marqueur = 'liste_descriptions_par_livre' then
                      begin
                        QRY := GetQry('livres');
                        try
                          LDescriptionsList := QRY.AsBook.Descriptions;
                        except
                          LDescriptionsList := nil;
                        end;
                        ListeNomTable := 'livre_descriptions';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectDescriptions(LDescriptionsList);
                      end
                      { else if Marqueur = 'liste_motscles' then
                        begin
                        raise exception.Create
                        ('not implemented in this release');
                        ListeNomTable := 'motscles';
                        end
                      }
                      else if Marqueur = 'liste_motscles_par_livre' then
                      begin
                        QRY := GetQry('livres');
                        try
                          LKeywordsList := QRY.AsBook.Keywords;
                        except
                          LKeywordsList := nil;
                        end;
                        ListeNomTable := 'motscles';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectKeywords(LKeywordsList);
                      end
                      {
                        // "readers" not implemented in this release
                        else if Marqueur = 'liste_lecteurs' then
                        begin
                        sql := 'select * from lecteurs order by pseudo';
                        ListeNomTable := 'lecteurs';
                        end
                      }
                      else if Marqueur = 'liste_langues' then
                      begin
                        ADB.Languages.SortByText;
                        ListeNomTable := 'langues';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectLanguages(ADB.Languages);
                      end
                      else if Marqueur = 'liste_editeurs' then
                      begin
                        ADB.Publishers.SortByCompanyName;
                        ListeNomTable := 'editeurs';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectPublishers(ADB.Publishers);
                      end
                      else if Marqueur = 'liste_editeurs_par_livre' then
                      begin
                        ADB.Publishers.SortByCompanyName;
                        QRY := GetQry('livres');
                        try
                          LShortPublishersList := QRY.AsBook.Publishers;
                        except
                          LShortPublishersList := nil;
                        end;
                        ListeNomTable := 'editeurs';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectPublishers(ADB.Publishers,
                          function(APublisher: TDelphiBooksPublisher): boolean
                          begin
                            result := assigned(LShortPublishersList) and
                              assigned(LShortPublishersList.GetItemByID
                              (APublisher.id));
                          end);
                      end
                      else if Marqueur = 'liste_descriptions_par_editeur' then
                      begin
                        QRY := GetQry('editeurs');
                        try
                          LDescriptionsList := QRY.AsPublisher.Descriptions;
                        except
                          LDescriptionsList := nil;
                        end;
                        ListeNomTable := 'editeur_descriptions';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectDescriptions(LDescriptionsList);
                      end
                      else if Marqueur = 'liste_auteurs' then
                      begin
                        ADB.Authors.SortByName;
                        ListeNomTable := 'auteurs';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectAuthors(ADB.Authors);
                      end
                      else if Marqueur = 'liste_auteurs_par_livre' then
                      begin
                        ADB.Authors.SortByName;
                        QRY := GetQry('livres');
                        try
                          LShortAuthorsList := QRY.AsBook.Authors;
                        except
                          LShortAuthorsList := nil;
                        end;
                        ListeNomTable := 'auteurs';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectAuthors(ADB.Authors,
                          function(AAuthors: TDelphiBooksAuthor): boolean
                          begin
                            result := assigned(LShortAuthorsList) and
                              assigned(LShortAuthorsList.GetItemByID
                              (AAuthors.id));
                          end);
                      end
                      else if Marqueur = 'liste_descriptions_par_auteur' then
                      begin
                        QRY := GetQry('auteurs');
                        try
                          LDescriptionsList := QRY.AsAuthor.Descriptions;
                        except
                          LDescriptionsList := nil;
                        end;
                        ListeNomTable := 'auteur_descriptions';
                        QRY := GetQry(ListeNomTable);
                        QRY.SelectDescriptions(LDescriptionsList);
                      end
                      else
                        raise exception.Create('Unknown tag "' + Marqueur +
                          '" in template "' + ATemplateFile + '".');
{$ENDREGION}
                      if assigned(QRY) and (not ListeNomTable.IsEmpty) then
                      begin
                        Listes.tryAdd(Marqueur, ListeNomTable);
                        PremierElementListesPrecedentes.Push
                          (PremierElementListeEnCours);
                        PremierElementListeEnCours := true;
                        AfficheBlocsPrecedents.Push(AfficheBlocEnCours);
                        AfficheBlocEnCours := AfficheBlocEnCours and
                          (not QRY.Eof);
                        ListePrecedenteAvaitElem.Push(not QRY.Eof);
                        ListeAvaitElem := false;
                        // ListeAvaitElem ne s'alimente qu'en fin de liste
                        ListePrecedentePosListe.Push(PosListe);
                        PosListe := PosMarqueur + Marqueur.Length + 4;
                        PosCurseur := PosListe;
                      end
                      else
                        // Liste non gérée ou problème
                        raise exception.Create('Unknown tag "' + Marqueur +
                          '" in template "' + ATemplateFile + '".');
                    end
                    else if Marqueur.StartsWith('/liste_') then
                    begin
                      // retourne en tête de liste ou continue si dernier enregistrement passé
                      PosCurseur := PosMarqueur + Marqueur.Length + 4;
                      if Listes.TryGetValue(Marqueur.Substring(1), ListeNomTable)
                      then
                      begin
                        QRY := GetQry(ListeNomTable);
                        if not QRY.Eof then
                        begin
                          QRY.Next;
                          if not QRY.Eof then
                          begin // on boucle
                            PosCurseur := PosListe;
                            PremierElementListeEnCours := false;
                          end
                          else
                          begin
                            // liste terminée
                            PosListe := ListePrecedentePosListe.Pop;
                            PremierElementListeEnCours :=
                              PremierElementListesPrecedentes.Pop;
                            AfficheBlocEnCours := AfficheBlocsPrecedents.Pop;
                            ListeAvaitElem := ListePrecedenteAvaitElem.Pop;
                          end;
                        end
                        else
                        begin
                          // liste vide donc terminée
                          PosListe := ListePrecedentePosListe.Pop;
                          PremierElementListeEnCours :=
                            PremierElementListesPrecedentes.Pop;
                          AfficheBlocEnCours := AfficheBlocsPrecedents.Pop;
                          ListeAvaitElem := ListePrecedenteAvaitElem.Pop;
                        end;
                      end
                    end
                    else if Marqueur.StartsWith('if ') then
                    begin
                      AfficheBlocsPrecedents.Push(AfficheBlocEnCours);
{$REGION 'traitement des conditions'}
                      if (Marqueur = 'if liste_premier_element') then
                      begin
                        AfficheBlocEnCours := PremierElementListeEnCours;
                      end
                      else if (Marqueur = 'if liste_precedente_affichee') then
                      begin
                        AfficheBlocEnCours := ListeAvaitElem;
                      end
                      else if (Marqueur = 'if livre_a_isbn10') then
                      begin
                        QRY := GetQry('livres');
                        AfficheBlocEnCours := (not QRY.Eof) and
                          (not QRY.AsBook.isbn10.IsEmpty);
                      end
                      else if (Marqueur = 'if livre_a_gencod') then
                      begin
                        QRY := GetQry('livres');
                        AfficheBlocEnCours := (not QRY.Eof) and
                          (not QRY.AsBook.isbn13.IsEmpty);
                      end
                      else if (Marqueur = 'if livre_a_url_site') then
                      begin
                        QRY := GetQry('livres');
                        AfficheBlocEnCours := (not QRY.Eof) and
                          (not QRY.AsBook.WebSiteURL.IsEmpty);
                      end
                      else if (Marqueur = 'if livre_a_photo') then
                      begin
                        QRY := GetQry('livres');
                        AfficheBlocEnCours := (not QRY.Eof) and
                          tfile.Exists(tpath.Combine(DBFolder,
                          QRY.AsBook.GetImageFileName));
                      end
                      {
                        // Readers are not implemented

                        else if (Marqueur = 'if lecteur_a_url_site') then
                        begin
                        qry := GetQry('lecteurs');
                        AfficheBlocEnCours := (not qry.EOF) and
                        (not qry.FieldByName('url_site').asstring.IsEmpty);
                        end
                        else if (Marqueur = 'if lecteur_a_photo') then
                        begin
                        qry := GetQry('lecteurs');
                        AfficheBlocEnCours := (not qry.EOF) and
                        tfile.Exists(getCheminDeLaPhoto('lecteurs',
                        qry.FieldByName('code').AsInteger));
                        end
                      }
                      else if (Marqueur = 'if editeur_a_url_site') then
                      begin
                        QRY := GetQry('editeurs');
                        AfficheBlocEnCours := (not QRY.Eof) and
                          (not QRY.AsPublisher.WebSiteURL.IsEmpty);
                      end
                      else if (Marqueur = 'if editeur_a_photo') then
                      begin
                        QRY := GetQry('editeurs');
                        AfficheBlocEnCours := (not QRY.Eof) and
                          tfile.Exists(tpath.Combine(DBFolder,
                          QRY.AsPublisher.GetImageFileName));
                      end
                      else if (Marqueur = 'if auteur_a_url_site') then
                      begin
                        QRY := GetQry('auteurs');
                        AfficheBlocEnCours := (not QRY.Eof) and
                          (not QRY.AsAuthor.WebSiteURL.IsEmpty);
                      end
                      else if (Marqueur = 'if auteur_a_photo') then
                      begin
                        QRY := GetQry('auteurs');
                        AfficheBlocEnCours := (not QRY.Eof) and
                          tfile.Exists(tpath.Combine(DBFolder,
                          QRY.AsAuthor.GetImageFileName));
                      end
                      else
                        raise exception.Create('Unknown tag "' + Marqueur +
                          '" in template "' + ATemplateFile + '".');
{$ENDREGION}
                      // On n'accepte l'affichage que si le bloc précédent (donc celui dans lequel on se trouve) était déjà affichable
                      AfficheBlocEnCours := AfficheBlocsPrecedents.Peek and
                        AfficheBlocEnCours;
                      PosCurseur := PosMarqueur + Marqueur.Length + 4;
                    end
                    else if Marqueur = 'else' then
                    begin
                      AfficheBlocEnCours := AfficheBlocsPrecedents.Peek and
                        (not AfficheBlocEnCours);
                      PosCurseur := PosMarqueur + Marqueur.Length + 4;
                    end
                    else if Marqueur = '/if' then
                    begin
                      AfficheBlocEnCours := AfficheBlocsPrecedents.Pop;
                      PosCurseur := PosMarqueur + Marqueur.Length + 4;
                    end
                    else
                    begin
                      if AfficheBlocEnCours then
                        Destination := Destination + RemplaceMarqueur(Marqueur);
                      PosCurseur := PosMarqueur + Marqueur.Length + 4;
                    end;
                  end
                  else
                  begin
                    // pas de tag trouvé, on termine l'envoi du source
                    if AfficheBlocEnCours then
                      Destination := Destination + Source.Substring(PosCurseur);
                    PosCurseur := Length(Source);
                  end;
                end;
              finally
                if tfile.Exists(ADestFile) then
                  PrecedentFichier := tfile.ReadAllText(ADestFile,
                    tencoding.UTF8)
                else
                  PrecedentFichier := '';
                if PrecedentFichier <> Destination then
                begin
                  tfile.WriteAllText(ADestFile, Destination, tencoding.UTF8);
                  onLog('Updated file (' + ALang.LanguageISOCode + ') : ' +
                    tpath.GetFileName(ADestFile));
                end;
              end;
            finally
              ListePrecedentePosListe.free;
            end;
          finally
            AfficheBlocsPrecedents.free;
          end;
        finally
          ListePrecedenteAvaitElem.free;
        end;
      finally
        PremierElementListesPrecedentes.free;
      end;
    finally
      Listes.free;
    end;
  finally
    for var list in DelphiBooksItemsLists.Values do
      list.free;
    QryList.free;
  end;
end;

end.
