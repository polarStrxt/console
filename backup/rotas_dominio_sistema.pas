unit rotas_dominio_sistema;

{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils, Horse,fpjson, jsonparser, dao_dominio;

procedure Registry;

implementation

procedure GetDominio(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  res.Send('Operante')
end;

procedure Registry;
begin
  THorse.Get('/Dominio', GetDominio);

end;

end.
