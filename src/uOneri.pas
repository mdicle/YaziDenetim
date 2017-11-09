unit uOneri;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics,
   uTools,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
   System.ImageList, Vcl.ImgList, FireDAC.Stan.Intf, FireDAC.Stan.Option,
   FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
   FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
   FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
   FireDAC.Comp.Client;

type
   TfrmOneri = class(TForm)
      Label1: TLabel;
      Label3: TLabel;
      edtSozcuk: TEdit;
      Memo1: TMemo;
      Button1: TButton;
      il: TImageList;
      Button2: TButton;
      Label2: TLabel;
      ds: TDataSource;
      conn: TFDConnection;
      lcb: TDBLookupComboBox;
      Button3: TButton;
      Label4: TLabel;
      edtKapsam: TEdit;
      Button4: TButton;
      procedure FormCreate(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure lcbCloseUp(Sender: TObject);
      procedure Button4Click(Sender: TObject);
    procedure edtKapsamKeyPress(Sender: TObject; var Key: Char);
      private
         { Private declarations }
      public
         { Public declarations }
         q: TFDQuery;
   end;

var
   frmOneri: TfrmOneri;

implementation

{$R *.dfm}

procedure TfrmOneri.Button3Click(Sender: TObject);
begin
   lcb.KeyValue := null;
   lcbCloseUp(nil);
end;

procedure TfrmOneri.Button4Click(Sender: TObject);
begin
   ShowMessage('Diyelim ki þuanda ABÝLERDE sözðüðü için bir öneri ' +
      'gireceksiniz... Yüklediðiniz yazýda ABÝ köküyle yazýlmýi çok sözcük ' +
      'olduðunu farkettiniz. Tek tek onlara öneri girmek zor olacaktýr. ' +
      'Ýþte bu kutucuða ABÝ yazarsanýz, A-B-Ý harfleriyle ' +
      'baþlayan tüm sözcükleri bu öneriye otomatik olarak baðlamýþ olursunuz.');
end;

procedure TfrmOneri.edtKapsamKeyPress(Sender: TObject; var Key: Char);
begin
   Key := UCaseTR(Key)[1];
end;

procedure TfrmOneri.FormCreate(Sender: TObject);
begin
   q := TFDQuery.Create(self);
   q.Connection := conn;
   ds.DataSet := q;
end;

procedure TfrmOneri.lcbCloseUp(Sender: TObject);
begin
   Memo1.Enabled := lcb.KeyValue = null;
   Label3.Visible := Memo1.Enabled;
   Memo1.Visible := Memo1.Enabled;
   Label4.Visible := lcb.KeyValue = null;
   edtKapsam.Visible := lcb.KeyValue = null;
   Button4.Visible := lcb.KeyValue = null;
   if Memo1.Enabled then
      Height := 425
   else
      Height := 190;
end;

end.
