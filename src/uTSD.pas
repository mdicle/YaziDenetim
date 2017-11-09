unit uTSD;

///
/// T�rk�e S�zc�k Denetleme Uygulamas�
/// v1.0
/// (Ticari ama�la kullan�lamaz!)
///
/// M. Murat Dicle
/// 2017
///

interface

uses System.Classes,
   System.SysUtils,
   System.StrUtils,
   Vcl.Forms,
   uTools,
   Vcl.StdCtrls,
   Vcl.ExtCtrls,
   Vcl.Controls,
   Vcl.ComCtrls;

type
   TSozcukContainer = record
      Sozcuk: PChar;
      Heceli: PChar;
      KullanimSayisi: integer;
      Turkce: Boolean;
      unluUyumu: Boolean;
   end;

   TSozcukArr = array of TSozcukContainer;

   // T�rk�e S�zc�k Denetim S�n�f�
   TTSD = class(TWinControl)
      private
         FParagrafSayisi: integer;
         FTumceSayisi: integer;
         FChecked: Boolean;
         FSozcukSayisi: integer;
      public
         docRaw: TRichEdit;
         SozcukArr: TSozcukArr;
         constructor Create(AOwner: TComponent); override;
         destructor Destroy; override;
         procedure LoadFromFile(const fn: string);
         procedure Reset;
         procedure Denetle;
         function docRawLen: integer;
         function Hecele(const s: string): string;
         function Hecesi(HeceNo: integer; HecelenmisSozcuk: string): string;
         function BuyukUnluUyumuVarM�(const s: string): Boolean;
         function TurkceMi(const s: string): boolean;
      published
         property ParagrafSayisi: integer read FParagrafSayisi;
         property TumceSayisi: integer read FTumceSayisi;
         property SozcukSayisi: integer read FSozcukSayisi;
         property Checked: Boolean read FChecked;
   end;

implementation

{ TTSD }

constructor TTSD.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   docRaw := TRichEdit.Create(AOwner);
   docRaw.Parent := TForm(AOwner);
   docRaw.Visible := False;
   docRaw.WordWrap := False;
   docRaw.PlainText := False;
   docRaw.MaxLength := $7FFFFFF0;
   Reset;
end;

procedure TTSD.Denetle;
var
   i: integer;
   n: integer;
   p: PChar;
   w: string;
   procedure lbl(const Name: string; const Caption: integer = 0);
   var
      l: TLabel;
   begin
      l := TLabel(Application.MainForm.FindComponent(name));
      if (not Assigned(l)) then
         exit;
      l.Caption := FloatToStrF(Caption, ffNumber, 18, 0);
   end;

begin
   if (FChecked) then
      exit;
   lbl('lblSozcukSayisi');
   lbl('lblTumceSayisi');
   lbl('lblParagraSayisi');
   lbl('lblKarakterSayisi');
   lbl('lblSozcukCesidi');
   lbl('lblKarakterSayisi', docRawLen);

   // Paragraf Say�s�
   FParagrafSayisi := 0;
   for i := 0 to docRaw.Lines.Count - 1 do
      begin
         if docRaw.Lines[i].Trim <> '' then
            inc(FParagrafSayisi);
      end;
   lbl('lblParagrafSayisi', FParagrafSayisi);
   Application.ProcessMessages;

   // T�mce Say�s� ve S�zc�klerin listesi olu�turuluyor
   FTumceSayisi := 0;
   p := docRaw.Lines.GetText;
   i := 0;
   FTumceSayisi := 0;
   FSozcukSayisi := 0;
   w := '';
   while ((p + i)^ <> #0) do
      begin
         if (not isWordDelimiter((p + i)^)) then
            w := w + (p + i)^
         else if (w <> '') then
            begin
               // w := UCaseTR(w);
               if ((w.Length > 1) and (Pos(w, OzelAdEkleri) = 0)) then
                  begin
                     Inc(FSozcukSayisi);
                     for n := low(SozcukArr) to high(SozcukArr) do
                        if (StrComp(PChar(w), SozcukArr[n].Sozcuk) = 0) then
                           begin
                              w := '';
                              Inc(SozcukArr[n].KullanimSayisi);
                              break;
                           end;
                     if (w <> '') then
                        begin
                           SetLength(SozcukArr, high(SozcukArr) + 2);
                           with SozcukArr[high(SozcukArr)] do
                              begin
                                 Sozcuk := StrNew(PChar(w));
                                 Heceli := StrNew(PChar(Hecele(w)));
                                 KullanimSayisi := 1;
                                 unluUyumu := BuyukUnluUyumuVarM�(w);
                                 Turkce := TurkceMi(w);
                              end;
                        end;
                  end;
               w := '';
            end;
         if CharInSet((p + i)^, ['.', '!', '?']) and
            (((p + i + 1)^ = #32) or ((p + i + 1)^ = #13)) then
            inc(FTumceSayisi);
         inc(i);
      end;
   StrDispose(p);
   lbl('lblTumceSayisi', FTumceSayisi);
   lbl('lblSozcukSayisi', FSozcukSayisi);
   lbl('lblSozcukCesidi', high(SozcukArr) + 1);
   Application.ProcessMessages;
end;

destructor TTSD.Destroy;
begin
   FreeAndNil(docRaw);
   inherited Destroy;
end;

function TTSD.docRawLen: integer;
begin
   Result := docRaw.Lines.Text.Length;
end;

function TTSD.Hecele(const s: string): string;
const
   c = '��AEI�O�U�';
var
   i: Integer;
   b: Boolean;
begin
   Result := '';
   i := Length(s);
   b := False;
   while i > 0 do
      begin
         Result := s[i] + Result;
         b := (((Pos(s[i], c) > 0) and b and ((i = 1) or not(Pos(s[i - 1],
            c) > 0)))) or
            ((not(Pos(s[i], c) > 0) and b and not(Pos(s[i + 1], c) > 0))
            or not b);
         if not b and (i > 1) then
            Result := '-' + Result;
         Dec(i);
      end;
end;

// Hece s�ras�n� iterken, 1'den ba�lar. S�f�rdan ba�lamad�m.
function TTSD.Hecesi(HeceNo: integer; HecelenmisSozcuk: string): string;
var
   r: TArray<string>;
begin
   Result := '';
   r := HecelenmisSozcuk.Split(['-']);
   if ((Heceno - 1) <= high(r)) then
      Result := r[HeceNo - 1];
end;

procedure TTSD.LoadFromFile(const fn: string);
begin
   Reset;
   docRaw.MaxLength := $7FFFFFF0;
   docRaw.Lines.LoadFromFile(fn);
   docRaw.Lines.Text := UCaseTr(docRaw.Lines.Text);
end;

procedure TTSD.Reset;
var
   i: integer;
begin
   docRaw.Clear;
   FChecked := False;
   FParagrafSayisi := -1;
   FTumceSayisi := -1;
   for i := low(SozcukArr) to high(SozcukArr) do
      begin
         if (SozcukArr[i].Sozcuk <> '') then
            StrDispose(SozcukArr[i].Sozcuk);
      end;
   SetLength(SozcukArr, 0);
end;

function TTSD.TurkceMi(const s: string): boolean;
   function sessiz(const c: string): boolean;
   begin
      Result := Pos(c, 'BC�DFG�HJKLMNPRS�TVYZ') > 0;
   end;

begin
   Result := (pos('�', s) = 0) and (pos('�', s) = 0) and (pos('�', s) = 0) and
      (pos('�', s) = 0) and (pos('�', s) = 0) and (pos('X', s) = 0) and
      (pos('W', s) = 0) and (pos('Q', s) = 0) and (pos('F', s) = 0) and
      (pos('J', s) = 0) and (pos('H', s) = 0) and
      ((Pos('O', s) < 3) or ((Pos('O', s) > 2) and (Pos('YOR', s) > 2))) and
      ((Pos('�', s) < 3) or ((Pos('�', s) > 2) and (Pos('YOR', s) > 2))) and
      (Pos(s[1], 'C�LMNRVZ') = 0) and (Pos(s[s.Length], 'BCDG�') = 0) and
      (not(sessiz(s[1]) and sessiz(s[2])));
end;

function TTSD.BuyukUnluUyumuVarM�(const s: string): Boolean;
var
   Kalin, Ince: Boolean;
   i: integer;
begin
   Kalin := False;
   Ince := False;
   Result := True;
   for i := 1 to s.Length do
      begin
         if Pos(s[i], 'AIOU') > 0 then
            Kalin := True
         else if Pos(s[i], 'E���') > 0 then
            Ince := True;
         if (Kalin and Ince) then
            begin
               Result := Pos('YOR', s, 4) > 0;
               break;
            end;
      end;
end;

end.
