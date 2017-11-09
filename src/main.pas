unit main;

///
/// Türkçe Sözcük Denetleme Uygulaması
/// v1.0
/// (Ticari amaçla kullanılamaz!)
///
/// M. Murat Dicle
/// 2017
///

interface

uses
   Winapi.Windows,
   Winapi.Messages,
   System.SysUtils,
   System.Classes,
   System.UITypes,
   Vcl.Controls,
   Vcl.Forms,
   uTools,
   uTSD,
   uOneri,
   System.Actions,
   Vcl.ActnList,
   Vcl.ToolWin,
   Vcl.Tabs,
   Vcl.StdCtrls,
   Vcl.ExtCtrls,
   Vcl.ComCtrls,
   System.StrUtils,
   System.ImageList,
   System.Variants,
   Vcl.ImgList,
   Vcl.Graphics,
   Data.DB,
   Vcl.Grids,
   Vcl.DBGrids,
   Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
   FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
   FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageBin,
   FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
   FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.SQLite,
   FireDAC.Phys.SQLiteDef,
   FireDAC.Stan.ExprFuncs, FireDAC.DApt, Vcl.OleCtrls, SHDocVw, Vcl.Menus,
   Vcl.Imaging.pngimage, Vcl.MPlayer;

type

   TForm1 = class(TForm)
      il: TImageList;
      od: TOpenDialog;
      odoc: TRichEdit;
      DBGrid2: TDBGrid;
      Panel3: TPanel;
      ToolBar1: TToolBar;
      ToolButton1: TToolButton;
      ToolButton3: TToolButton;
      ToolButton6: TToolButton;
      pOzet: TPanel;
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      Label4: TLabel;
      Label9: TLabel;
      ACL: TActionList;
      aOpenFile: TAction;
      aNew: TAction;
      aCheck: TAction;
      aSummary: TAction;
      lblSozcukSayisi: TLabel;
      lblParagrafSayisi: TLabel;
      lblKarakterSayisi: TLabel;
      lblSozcukCesidi: TLabel;
      lblTumceSayisi: TLabel;
      Panel2: TPanel;
      Label7: TLabel;
      tblTSD: TFDMemTable;
      tblTSDSozcuk: TStringField;
      dsTSD: TDataSource;
      tblTSDKullanimSayisi: TIntegerField;
      tblTSDHeceli: TStringField;
      edFilter: TButtonedEdit;
      il2: TImageList;
      tblTSDunluUyumu: TBooleanField;
      sb: TStatusBar;
      tblTSDTurkce: TBooleanField;
      Panel1: TPanel;
      Label5: TLabel;
      Memo1: TMemo;
      Image1: TImage;
      pm: TPopupMenu;
      pmOneriSil: TMenuItem;
      pmOneriDuzenle: TMenuItem;
      pmOneriGir: TMenuItem;
      conn: TFDConnection;
      Label6: TLabel;
      tblTSDOneri: TBooleanField;
      il3: TImageList;
      Panel4: TPanel;
      Label8: TLabel;
      Image2: TImage;
      Image3: TImage;
      Image4: TImage;
      Label10: TLabel;
      Label11: TLabel;
      BalloonHint1: TBalloonHint;
      Panel5: TPanel;
      Label12: TLabel;
      Panel6: TPanel;
      Label13: TLabel;
      Panel7: TPanel;
      mp: TMediaPlayer;
      ToolButton5: TToolButton;
      ToolButton7: TToolButton;
      aTopOn: TAction;
      aHideText: TAction;
      procedure FormCreate(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure aOpenFileExecute(Sender: TObject);
      procedure aNewExecute(Sender: TObject);
      procedure Label7Click(Sender: TObject);
      procedure aSummaryExecute(Sender: TObject);
      procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer);
      procedure aCheckExecute(Sender: TObject);
      procedure DBGrid2DblClick(Sender: TObject);
      procedure DBGrid2MouseEnter(Sender: TObject);
      procedure odocMouseEnter(Sender: TObject);
      procedure DBGrid2TitleClick(Column: TColumn);
      procedure edFilterRightButtonClick(Sender: TObject);
      procedure edFilterKeyPress(Sender: TObject; var Key: Char);
      procedure edFilterKeyUp(Sender: TObject; var Key: Word;
         Shift: TShiftState);
      procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
         DataCol: Integer; Column: TColumn; State: TGridDrawState);
      procedure dsTSDDataChange(Sender: TObject; Field: TField);
      procedure pmPopup(Sender: TObject);
      procedure Label5MouseDown(Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer);
      procedure Label6Click(Sender: TObject);
      procedure pmOneriSilClick(Sender: TObject);
      procedure pmOneriGirClick(Sender: TObject);
      procedure aTopOnExecute(Sender: TObject);
      procedure aHideTextExecute(Sender: TObject);
      procedure pmOneriDuzenleClick(Sender: TObject);
      private
         LastStartPos: integer;
         LastSearchWord: string;
         LastFoundS: string;
         oneriID: integer;
         // procedure Denetle;
         procedure doStart(var m: TMessage); message WM_USER + 1;
         procedure doInsertTSDFromSozcukArr(var m: TMessage);
            message WM_USER + 2;
      public
         { Public declarations }
         tsd: TTSD;
   end;

var
   Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.aCheckExecute(Sender: TObject);
var
   c: Cardinal;
begin
   Screen.Cursor := crHourGlass;
   if (tblTSD.Active) then
      tblTSD.EmptyDataSet;
   tblTSD.Close;
   aCheck.Enabled := False;
   Panel7.Caption := '  Denetleniyor...';
   Label7.Visible := False;
   pOzet.Visible := True;
   c := GetTickCount;
   tsd.Denetle;
   Label7.Visible := True;
   PostMessage(Handle, WM_USER + 2, 0, 0);
   Application.ProcessMessages;
   aSummary.Enabled := True;
   Panel7.Caption := 'Denetleme bitti! ' + (GetTickCount - c).ToString + 'ms';
   Screen.Cursor := crDefault;
   if (mp.FileName = 'done.mp3') then
      mp.Play;
end;

procedure TForm1.aHideTextExecute(Sender: TObject);
begin
   if not ToolButton7.Down then
      begin
         odoc.Visible := True;
         width := 933;
         sb.Panels[0].Width := 275;
         sb.Panels[1].Width := 160;
      end
   else
      begin
         sb.Panels[0].Width := 0;
         sb.Panels[1].Width := 0;
         odoc.Visible := False;
         width := 378;
      end;
end;

procedure TForm1.aNewExecute(Sender: TObject);
begin
   tsd.Reset;
end;

procedure TForm1.aOpenFileExecute(Sender: TObject);
begin
   if (od.Execute) then
      begin
         Screen.Cursor := crHourGlass;
         odoc.Clear;
         odoc.Font.Size := 11;
         odoc.Font.Name := 'Verdana';
         odoc.MaxLength := $7FFFFFF0;
         odoc.Lines.LoadFromFile(od.FileName);
         Application.ProcessMessages;
         tsd.LoadFromFile(od.FileName);
         aCheck.Enabled := True;
         aSummary.Enabled := False;
         Screen.Cursor := crDefault;
         sb.Panels[2].Text := od.FileName;
      end;
end;

procedure TForm1.aSummaryExecute(Sender: TObject);
begin
   pOzet.Visible := not pOzet.Visible;
   pOzet.Left := 34;
   pOzet.Top := 74;
end;

procedure TForm1.aTopOnExecute(Sender: TObject);
var
   a: TAction;
begin
   a := TAction(Sender);
   if a.ImageIndex = 4 then
      begin
         Self.FormStyle := fsStayOnTop;
         a.ImageIndex := 5;
      end
   else
      begin
         Self.FormStyle := fsNormal;
         a.ImageIndex := 4;
      end;
end;

procedure TForm1.edFilterKeyPress(Sender: TObject; var Key: Char);
begin
   if (Key < #65) and (Key <> #8) and
      ((edFilter.Text <> '') and ((Key = '*') or (Key = '%'))) then
      Key := #0;
end;

procedure TForm1.edFilterKeyUp(Sender: TObject; var Key: Word;
   Shift: TShiftState);
begin
   if (edFilter.Text = '') then
      begin
         tblTSD.Filtered := False;
         exit;
      end;
   if (not tblTSD.Filtered) then
      tblTSD.Filtered := True;
   tblTSD.Filter := 'Sozcuk LIKE ''' + ReplaceStr(UCaseTR(edFilter.Text), '*',
      '%') + '%''';
end;

procedure TForm1.edFilterRightButtonClick(Sender: TObject);
begin
   tblTSD.Filtered := False;
   edFilter.Text := '';
end;

procedure TForm1.DBGrid2DblClick(Sender: TObject);
var
   s: string;
   n: integer;
   function ara: integer;
   begin
      n := odoc.FindText(s, n + 1, Length(odoc.Text) - n, [stWholeWord]);
      Result := n;
   end;

begin
   if not odoc.Visible then
      begin
         ShowMessage('Yazı bölümü görünür değil!');
         exit;
      end;
   s := LCaseTR(tblTSD.FieldByName('Sozcuk').AsString);
   if (LastSearchWord <> s) then
      begin
         LastSearchWord := s;
         n := -1;
      end
   else
      n := LastStartPos;

   if (n >= Length(odoc.Text)) then
      n := -1;
   if (s <> '') and (ara <> -1) then
      begin
         LastFoundS := s;
         odoc.SelStart := n;
         odoc.SelLength := s.Length;
         odoc.SetFocus;
         LastStartPos := n + 1;
      end;
   if (n = -1) then
      begin
         LastStartPos := -1;
         if (LastFoundS = s) then
            DBGrid2DblClick(Sender);
      end;
end;

procedure TForm1.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
   DataCol: Integer; Column: TColumn; State: TGridDrawState);
const
   renkler: array of TColor   = [clWhite, clSkyBlue];
   fontcolor: array of TColor = [clBlack, clNavy];
var
   l: integer;
   c: TCanvas;
begin
   if (gdSelected in State) then
      l := 1
   else
      l := 0;
   c := DBGrid2.Canvas;
   c.Brush.Color := renkler[l];
   c.Font.Color := fontcolor[l];
   DBGrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);
   if (DataCol in [3, 4, 5]) then
      begin
         c.Brush.Color := clBtnFace;
         c.FillRect(Rect);
         if (Column.Field.AsBoolean) then
            il3.Draw(c, Rect.Left, Rect.Top, DataCol - 3);
      end;
end;

procedure TForm1.DBGrid2MouseEnter(Sender: TObject);
begin
   DBGrid2.SetFocus;
end;

procedure TForm1.DBGrid2TitleClick(Column: TColumn);
var
   op: TFDSortOptions;
   inx: TFDIndex;
begin
   inx := tblTSD.Indexes.FindIndex(Column.FieldName);
   if (inx = nil) then
      exit;
   op := inx.Options;
   if (soDescending in op) then
      op := op - [soDescending]
   else
      op := op + [soDescending];
   inx.Options := op;
   tblTSD.IndexName := inx.Name;
   tblTSD.First;
end;

procedure TForm1.doInsertTSDFromSozcukArr(var m: TMessage);
var
   i: integer;
   q: TFDQuery;
   s: string;
begin
   tblTSD.Open;
   tblTSD.DisableControls;
   q := TFDQuery.Create(self);
   q.Connection := conn;
   for i := low(tsd.SozcukArr) to high(tsd.SozcukArr) do
      with tblTSD do
         begin
            Insert;
            s := StrPas(tsd.SozcukArr[i].Sozcuk);
            FieldByName('Sozcuk').Value := s;
            FieldByName('Heceli').Value := StrPas(tsd.SozcukArr[i].Heceli);
            FieldByName('KullanimSayisi').Value := tsd.SozcukArr[i]
               .KullanimSayisi;
            FieldByName('unluUyumu').Value := tsd.SozcukArr[i].unluUyumu;
            FieldByName('Turkce').Value := tsd.SozcukArr[i].Turkce;
            q.Open('select id from oneriler where sozcuk = ''' + s + '''');
            FieldByName('Oneri').Value := (q.RecordCount > 0);
            Post;
         end;
   FreeAndNil(q);
   tblTSD.First;
   tblTSD.EnableControls;
end;

procedure TForm1.doStart(var m: TMessage);
begin
   odoc.clear;
   odoc.WordWrap := True;
   odoc.PlainText := False;
   tsd := TTSD.create(self);
   if fileExists('done.mp3') then
      begin
         mp.FileName := 'done.mp3';
         mp.Open;
      end
   else
      mp.FileName := '';
end;

procedure TForm1.dsTSDDataChange(Sender: TObject; Field: TField);
var
   q: TFDQuery;
   s: string;
   i: integer;
begin
   Panel1.Visible := False;
   oneriID := 0;
   if (tblTSDSozcuk.Value <> '') then
      begin
         Memo1.Clear;
         q := TFDQuery.Create(self);
         q.Connection := conn;
         q.Open(format('select * from oneriler where sozcuk = ''%s''',
            [tblTSDSozcuk.Value]));
         if (q.RecordCount > 0) then
            begin
               i := q.FieldByName('releatedId').AsInteger;
               if i > 0 then
                  q.Open('select * from oneriler where id = :id', [i]);
               s := Label5.Caption;
               Delete(s, 1, Pos(' ', s));
               s := '<' + tblTSDSozcuk.asString + '> ' + s;
               Label5.Caption := s;
               Panel1.Left := 18;
               Panel1.Top := 254;
               Panel1.Visible := True;
               Memo1.Lines.Text := q.FieldByName('oneri').Value;
               oneriID := q.FieldByName('id').Value;
            end;
         FreeAndNil(q);
      end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   FreeAndNil(tsd);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   PostMessage(Handle, WM_USER + 1, 0, 0); // doStart
end;

procedure TForm1.Label5MouseDown(Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer);
const
   SC_DRAGMOVE = $F012;
begin
   if Button = mbLeft then
      begin
         ReleaseCapture;
         Panel1.Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
         Panel1.Repaint;
      end;
end;

procedure TForm1.Label6Click(Sender: TObject);
begin
   Panel1.Visible := False;
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
   pOzet.Visible := False;
end;

procedure TForm1.odocMouseEnter(Sender: TObject);
begin
   odoc.SetFocus;
end;

procedure TForm1.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer);
const
   SC_DRAGMOVE = $F012;
begin
   if Button = mbLeft then
      begin
         ReleaseCapture;
         pOzet.Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
         pOzet.Repaint;
      end;
end;

procedure TForm1.pmOneriDuzenleClick(Sender: TObject);
begin
   pmOneriGirClick(Sender);
end;

procedure TForm1.pmOneriGirClick(Sender: TObject);
var
   id, tg: integer;
   b: TBookmark;
begin
   tg := TMenuItem(Sender).Tag;
   with TfrmOneri.Create(self) do
      begin
         edtKapsam.Text := '';
         edtSozcuk.Text := tblTSDSozcuk.AsString;
         if (tg = 1) then
            begin
               q.Open('select * from oneriler where sozcuk = :sozuk',
                  [tblTSDSozcuk.AsString]);
               if q.FieldByName('releatedId').asInteger = 0 then
                  Memo1.Lines.Text := q.FieldByName('oneri').AsString
               else
                  begin
                     id := q.FieldByName('releatedId').asInteger;
                     q.Open('select * from oneriler where id = :id', [id]);
                     lcb.KeyValue := q.FieldByName('sozcuk').asString;
                     lcbCloseUp(nil);
                  end;
            end;

         q.Open('select * from oneriler where sozcuk like :sozuk and releatedId = 0',
            [Copy(edtSozcuk.Text, 1, 2) + '%']);
         if q.RecordCount = 0 then
            begin
               Height := 370;
               Label2.Visible := false;
               Button3.Visible := false;
               lcb.Visible := false;
            end;
         if ShowModal = mrOk then
            begin
               if (Memo1.Lines.Text <> '') or (lcb.KeyValue <> Null) then
                  begin
                     id := 0;
                     if lcb.KeyValue <> Null then
                        begin
                           q.Filter := 'sozcuk=''' + lcb.KeyValue + '''';
                           q.Filtered := true;
                           id := q.FieldByName('id').AsInteger;
                           Memo1.Clear;
                        end;
                     if (tg = 2) then
                        q.ExecSQL(
                           'insert into oneriler (sozcuk, oneri, releatedId) values (:sozcuk, :oneri, :releatedId)',
                           [tblTSDSozcuk.AsString, Memo1.Lines.Text, id])
                     else
                        q.ExecSQL(
                           'update oneriler set oneri = :oneri, releatedId = :releatedId where sozcuk = :sozcuk',
                           [Memo1.Lines.Text, id, tblTSDSozcuk.AsString]);
                     q.Open('select * from oneriler where sozcuk = :sozcuk',
                        [tblTSDSozcuk.AsString]);
                     id := q.FieldByName('id').AsInteger;
                     tblTSD.Edit;
                     tblTSD.FieldByName('Oneri').Value := True;
                     tblTSD.Post;
                     if (edtKapsam.Text <> '') and (lcb.KeyValue = Null) then
                        begin
                           q.ExecSQL(
                              'delete from oneriler where sozcuk <> :sozcuk and sozcuk like :kapsam',
                              [tblTSDSozcuk.AsString,
                              UCaseTR(Trim(edtKapsam.Text)) + '%']);
                           tblTSD.DisableControls;
                           b := tblTSD.GetBookmark;
                           tblTSD.Filter := 'sozcuk <> ''' +
                              tblTSDSozcuk.AsString + ''' and sozcuk like ''' +
                              UCaseTR(Trim(edtKapsam.Text)) + '%''';
                           tblTSD.Filtered := True;
                           tblTSD.First;
                           while not tblTSD.Eof do
                              begin
                                 q.ExecSQL(
                                    'insert into oneriler (sozcuk, oneri, releatedId) values (:sozcuk, :oneri, :releatedId)',
                                    [tblTSDSozcuk.AsString, '', id]);
                                 tblTSD.Edit;
                                 tblTSD.FieldByName('Oneri').Value := True;
                                 tblTSD.Post;
                                 tblTSD.Next;
                              end;
                           tblTSD.Filtered := False;
                           tblTSD.GotoBookmark(b);
                           tblTSD.EnableControls;
                        end;
                     DBGrid2.Refresh;
                  end
               else
                  ShowMessage
                     ('İlgili alanları doldurmadan kayıt yapamazsınız!');
            end;
         Free;
      end;
end;

procedure TForm1.pmOneriSilClick(Sender: TObject);
var
   q: TFDQuery;
   b: TBookmark;
begin
   if MessageDlg('<' + tblTSDSozcuk.AsString +
      '> sözcüğü için verilen öneri kayıtlardan silinecektir. Onaylıyor musunuz?',
      mtWarning, mbYesNo, 0) = mrYes then
      begin
         b := tblTSD.GetBookmark;
         tblTSD.DisableControls;
         q := TFDQuery.Create(Self);
         q.Connection := conn;
         q.Open('select * from oneriler where  id = :id or releatedId = :id',
            [oneriID]);
         q.First;
         while not q.Eof do
            begin
               if tblTSD.Locate('Sozcuk', q.FieldByName('sozcuk').AsString,
                  [loCaseInsensitive]) then
                  begin
                     tblTSD.Edit;
                     tblTSD.FieldByName('Oneri').Value := False;
                     tblTSD.Post;
                  end;
               q.Next;
            end;
         q.ExecSQL('delete from oneriler where id = :id or releatedId = :id',
            [oneriID]);
         FreeAndNil(q);
         tblTSD.GotoBookmark(b);
         tblTSD.EnableControls;
         DBGrid2.Refresh;
      end;
end;

procedure TForm1.pmPopup(Sender: TObject);
var
   i: integer;
   s: string;
begin
   if (tblTSDSozcuk.Value = '') then
      exit;
   for i := 0 to pm.Items.Count - 1 do
      begin
         s := pm.Items[i].Caption;
         Delete(s, 1, Pos(' ', s));
         s := '<' + tblTSDSozcuk.asString + '> ' + s;
         pm.Items[i].Caption := s;
      end;
   pmOneriSil.Visible := tblTSDOneri.Value;
   pmOneriDuzenle.Visible := tblTSDOneri.Value;
   pmOneriGir.Visible := not tblTSDOneri.Value;
end;

end.
