unit uTools;

///
/// Türkçe Sözcük Denetleme Uygulaması
/// v1.0
/// (Ticari amaçla kullanılamaz!)
///
/// M. Murat Dicle
/// 2017
///

interface

const
   OzelAdEkleri           = 'IN İN NİN LA LE LI Lİ LAR LER';
   Ekler: array of string = ['', '', ''];

function isWordDelimiter(c: char): boolean;
function UCaseTR(s: string): string;
function LCaseTR(s: string): string;

implementation

uses System.SysUtils;

function Hecele(sozcuk: string): string;
var
   hn: Integer;
   hc: boolean;
   function Sesli(Harf: char): boolean;
   begin
      Result := Pos(Harf, 'ÂÎAEIİOÖUÜ') > 0;
   end;

begin
   Result := '';
   hn := length(sozcuk);
   hc := false;
   while hn > 0 do
      begin
         Result := sozcuk[hn] + Result;
         if Sesli(sozcuk[hn]) then
            begin
               if hc then
                  hc := (hn = 1) or not Sesli(sozcuk[hn - 1])
               else
                  hc := true
            end
         else
            begin
               if hc then
                  hc := not Sesli(sozcuk[hn + 1])
               else
                  hc := true;
            end;
         if not hc and (hn > 1) then
            Result := '-' + Result;

         hn := hn - 1;
      end;
end;

function isWordDelimiter(c: char): boolean;
begin
   Result := Pos(c,
      #9#13#10#32'”‘’“…˵˶–’̶̒̓̔̕1234567890!҅҆''"ʺ˝˗^+-˵˶˗̶%&/()=?*,;.:`') <> 0;
end;

function UCaseTR(s: string): string;
var
   i: integer;
begin
   for i := 1 to length(s) do
      case s[i] of
         'i':
            s[i] := 'İ';
         'ı':
            s[i] := 'I';
         'ğ':
            s[i] := 'Ğ';
         'ü':
            s[i] := 'Ü';
         'ş':
            s[i] := 'Ş';
         'ö':
            s[i] := 'Ö';
         'ç':
            s[i] := 'Ç';
         'â':
            s[i] := 'Â';
         'ê':
            s[i] := 'Ê';
         'ô':
            s[i] := 'Ô';
         'î':
            s[i] := 'Î';
      end;
   UCaseTR := UpperCase(s);
end;

function LCaseTR(s: string): string;
var
   i: integer;
begin
   for i := 1 to length(s) do
      case s[i] of
         'İ':
            s[i] := 'i';
         'I':
            s[i] := 'ı';
         'Ğ':
            s[i] := 'ğ';
         'Ü':
            s[i] := 'ü';
         'Ş':
            s[i] := 'ş';
         'Ö':
            s[i] := 'ö';
         'Ç':
            s[i] := 'ç';
         'Â':
            s[i] := 'â';
         'Ê':
            s[i] := 'ê';
         'Î':
            s[i] := 'î';
         'Ô':
            s[i] := 'ô';
      end;
   LCaseTR := LowerCase(s);
end;

end.
