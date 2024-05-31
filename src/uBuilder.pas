unit uBuilder;

interface

function GetTextFromTemplate(Const AVideoCode, ATubeCode: integer): string;

implementation

uses
  System.DateUtils,
  System.SysUtils,
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
  FireDAC.Comp.Client,
  uDB,
  DelphiBooks.Tools;

type
  TFDQueryDictionary = TObjectDictionary<string, TFDQuery>;

function BuildTextFromTemplate(Const AQryList: TFDQueryDictionary;
  Const ATemplate: string): string;

/// <param name="Marqueur">
/// Le marqueur est en format "Table_Field" avec �ventuellement plusieurs oulign�s au niveau de la table, mais la derni�re partie est forc�ment le champ.
/// </param>
  function GetValue(Const Marqueur: string): string;
  var
    QRY: TFDQuery;
    Table, Field: string;
  begin
    Field := Marqueur.Substring(Marqueur.LastIndexOf('_') + 1);
    Table := Marqueur.Substring(0, Marqueur.Length - Field.Length - 1);
    if (not AQryList.TryGetValue(Table, QRY)) then
      raise exception.Create('Unknown table "' + Table + '" for keyword "' +
        Marqueur + '".');
    if assigned(QRY) and QRY.Active and (not QRY.Eof) then
      try
        result := QRY.FieldByName(Field).asstring
      except
        raise exception.Create('Unknown field "' + Field + '" in the table "' +
          Table + '" for keyword "' + Marqueur + '".');
      end
    else
      result := '';

    // traite les marqueurs, listes et conditions dans le champ r�cup�r�
    result := BuildTextFromTemplate(AQryList, result);
  end;

  function RemplaceMarqueur(Const Marqueur: string): string;
  begin
    result := '';
    // mots cl�s en dur
    if Marqueur = 'date' then
      result := Date8ToString(DateToString8(now))
    else if Marqueur = 'date-iso' then
      result := Date8ToStringISO(DateToString8(now))
    else if Marqueur = 'date-rfc822' then
      result := Date8ToStringRFC822(DateToString8(now))
    else
      // mots cl�s li�s � la base de donn�es
      try
        result := GetValue(Marqueur).Trim;
      except
        raise exception.Create('Unknown tag "' + Marqueur + '".');
      end;
  end;

var
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
begin
  if ATemplate.Trim.IsEmpty then
  begin
    result := '';
    exit;
  end;

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
          PosListe := Length(ATemplate);
          ListePrecedentePosListe := tstack<integer>.Create;
          try
            result := '';
            PosCurseur := 0;
            try
              while (PosCurseur < Length(ATemplate)) do
              begin
                PosMarqueur := ATemplate.IndexOf('!$', PosCurseur);
                if (PosMarqueur >= 0) then
                begin // tag trouv�, on le traite
                  if AfficheBlocEnCours then
                    result := result + ATemplate.Substring(PosCurseur,
                      PosMarqueur - PosCurseur);
                  Marqueur := ATemplate.Substring(PosMarqueur + 2,
                    ATemplate.IndexOf('$!', PosMarqueur + 2) - PosMarqueur -
                    2).ToLower;
{$REGION 'listes g�r�es par le logiciel'}
                  (*
                    // D�but du traitement des listes
                    if Marqueur.StartsWith('liste_') then
                    begin
                    // ne traite pas de listes imbriqu�es
                    {$REGION 'marqueurs pris en charge'}
                    if Marqueur = 'liste_livres' then
                    begin
                    ListeNomTable := 'livres';
                    ADB.Books.SortByTitle;
                    QRY := GetQry(ListeNomTable);
                    QRY.SelectBooks(ADB.Books);
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
                    // Liste non g�r�e ou probl�me
                    raise exception.Create('Unknown tag "' + Marqueur +
                    '" in template "' + ATemplateFile + '".');
                    end
                    else if Marqueur.StartsWith('/liste_') then
                    begin
                    // retourne en t�te de liste ou continue si dernier enregistrement pass�
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
                    // liste termin�e
                    PosListe := ListePrecedentePosListe.Pop;
                    PremierElementListeEnCours :=
                    PremierElementListesPrecedentes.Pop;
                    AfficheBlocEnCours := AfficheBlocsPrecedents.Pop;
                    ListeAvaitElem := ListePrecedenteAvaitElem.Pop;
                    end;
                    end
                    else
                    begin
                    // liste vide donc termin�e
                    PosListe := ListePrecedentePosListe.Pop;
                    PremierElementListeEnCours :=
                    PremierElementListesPrecedentes.Pop;
                    AfficheBlocEnCours := AfficheBlocsPrecedents.Pop;
                    ListeAvaitElem := ListePrecedenteAvaitElem.Pop;
                    end;
                    end
                    end
                    else
                    // Fin du traitement des listes
                  *)
{$ENDREGION}
                  if Marqueur.StartsWith('if ') then
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
                    else if (Marqueur.StartsWith('if exists_')) then
                    begin
                      var
                        TableOrTableField: string :=
                          Marqueur.Substring('if exists_'.Length);
                      var
                        QRY: TFDQuery;
                      try
                        AfficheBlocEnCours :=
                          (AQryList.TryGetValue(TableOrTableField, QRY) and
                          assigned(QRY)) or
                          (not GetValue(TableOrTableField).IsEmpty);
                      except
                        AfficheBlocEnCours := false;
                      end;
                    end
                    else
                      raise exception.Create('Unknown tag "' + Marqueur + '"');
{$ENDREGION}
                    // On n'accepte l'affichage que si le bloc pr�c�dent (donc celui dans lequel on se trouve) �tait d�j� affichable
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
                      result := result + RemplaceMarqueur(Marqueur);
                    PosCurseur := PosMarqueur + Marqueur.Length + 4;
                  end;
                end
                else
                begin
                  // pas de tag trouv�, on termine l'envoi du source
                  if AfficheBlocEnCours then
                    result := result + ATemplate.Substring(PosCurseur);
                  PosCurseur := Length(ATemplate);
                end;
              end;
            finally
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
end;

function GetTextFromTemplate(Const AVideoCode, ATubeCode: integer): string;
  function GetQuery(ASQL: string): TFDQuery;
  begin
    result := TFDQuery.Create(nil);
    try
      result.Connection := DB.FDConnection1;
      result.Open(ASQL);
      result.First;
      if result.Eof then
        freeandnil(result);
    except
      freeandnil(result);
    end;
  end;

var
  QryList: TFDQueryDictionary;
  QryVideo: TFDQuery;
  QryTube: TFDQuery;
begin
  result := '';
  QryList := TFDQueryDictionary.Create([doOwnsValues]);
  try

    QryVideo := GetQuery('select * from video where code=' +
      AVideoCode.ToString);
    if not assigned(QryVideo) then
      raise exception('Can''t find the video n�' + AVideoCode.ToString +
        ' in the database.');
    QryList.Add('video', QryVideo);

    QryTube := GetQuery('select * from tube where code=' + ATubeCode.ToString);
    if not assigned(QryVideo) then
      raise exception('Can''t find the tube n�' + ATubeCode.ToString +
        ' in the database.');
    QryList.Add('tube', QryTube);

    QryList.Add('video_tube',
      GetQuery('select * from video_tube where tube_code=' + ATubeCode.ToString
      + ' and video_code=' + AVideoCode.ToString));

    QryList.Add('season', GetQuery('select * from season where code=' +
      QryVideo.FieldByName('season_code').asstring));

    QryList.Add('season_tube',
      GetQuery('select * from season_tube where tube_code=' + ATubeCode.ToString
      + ' and season_code=' + QryVideo.FieldByName('season_code').asstring));

    QryList.Add('serial', GetQuery('select * from serial where code=' +
      QryVideo.FieldByName('serial_code').asstring));

    QryList.Add('serial_tube',
      GetQuery('select * from serial_tube where tube_code=' + ATubeCode.ToString
      + ' and serial_code=' + QryVideo.FieldByName('serial_code').asstring));

    // ajout du texte pour le titre
    result := BuildTextFromTemplate(QryList, QryTube.FieldByName('tpl_label')
      .asstring).Trim.Replace(#10, '').Replace(#13, '') + sLineBreak +
      '----------' + sLineBreak;

    // ajout du texte pour le descriptif
    result := result + BuildTextFromTemplate(QryList,
      QryTube.FieldByName('tpl_comment').asstring).Trim + sLineBreak +
      '----------' + sLineBreak;

    // ajout du texte pour les mots-cl�s
    result := result + BuildTextFromTemplate(QryList,
      QryTube.FieldByName('tpl_keyword').asstring).Trim.Replace(#10, '')
      .Replace(#13, '') + sLineBreak + '----------' + sLineBreak;
  finally
    QryList.free;
  end;
end;

end.
