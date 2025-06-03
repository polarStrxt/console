unit rotas_dominios_sistema;

{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils, Horse, fpjson, jsonparser, dao_dominio, vo_dominio;

procedure Registry;

implementation

procedure GetDominio(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  res.Send('Dominio Ok :)');
end;

procedure ObterDominioByNome(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  DaoDominio: TDaoDominio;
  erro: string;
  LJsonArray: TJsonArray;
  LNomeDominio: string;
begin
  LNomeDominio := Req.Params['NomeDominio'];
  erro := '';
  DaoDominio := TDaoDominio.Create(nil);

  try
    try
      LJsonArray := DaoDominio.ObterDominioByNome(LNomeDominio);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar obter a Dominio [' + LNomeDominio +
          ']. Mensagem do banco de dados ' + e.Message;
      end;
    end;
    if erro <> '' then
    begin
      res.Status(400);
      res.Send(erro);
    end
    else
    begin
      res.Status(200);
      res.Send<TJSONArray>(LJsonArray);
    end;
  finally
    DaoDominio.Free;
  end;

end;


procedure ObterListaDominioByNome(Req: THorseRequest; Res: THorseResponse;
  Next: TNextProc);
var
  DaoDominio: TDaoDominio;
  erro: string;
  LJsonArray: TJsonArray;
  LNomeDominio: string;
begin
  LNomeDominio := Req.Params['NomeDominio'];
  erro := '';
  DaoDominio := TDaoDominio.Create(nil);

  try
    try
      LJsonArray := DaoDominio.ObterListaDominioByNome(LNomeDominio);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar obter a Dominio [' + LNomeDominio +
          ']. Mensagem do banco de dados ' + e.Message;
      end;
    end;
    if erro <> '' then
    begin
      res.Status(400);
      res.Send(erro);
    end
    else
    begin
      res.Status(200);
      res.Send<TJSONArray>(LJsonArray);
    end;
  finally
    DaoDominio.Free;
  end;

end;

procedure ObterListaDominioById(Req: THorseRequest; Res: THorseResponse;
  Next: TNextProc);
var
  DaoDominio: TDaoDominio;
  erro: string;
  LJsonArray: TJsonArray;
  LIdDominio: string;
begin
  LIdDominio := Req.Params['ID'];
  erro := '';
  DaoDominio := TDaoDominio.Create(nil);

  try
    try
      LJsonArray := DaoDominio.ObterListaDominioById(LIdDominio);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar obter a Dominio [' + LIDDominio +
          ']. Mensagem do banco de dados ' + e.Message;
      end;
    end;
    if erro <> '' then
    begin
      res.Status(400);
      res.Send(erro);
    end
    else
    begin
      res.Status(200);
      res.Send<TJSONArray>(LJsonArray);
    end;
  finally
    DaoDominio.Free;
  end;

end;

procedure PostarDominio(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  DaoDominio: TDaoDominio;
  erro: string;
  LJsonArray: TJsonArray;
  LId: string;
  vo: TVoDominio;
  s: string;
begin
  LId := '';

  LId := Req.Params['Id'];

  erro := '';
  DaoDominio := TDaoDominio.Create(nil);
  vo := TVoDominio.Create;
  vo.FromJSON(Req.Body<TJSONObject>);
  try
    try
      LJsonArray := DaoDominio.GravarDominio(vo);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar gravar a Dominio [' + LId +
          ']. Mensagem do banco de dados ' + e.Message;
      end;
    end;
    if erro <> '' then
    begin
      res.Status(400);
      res.Send(erro);
    end
    else
    begin
      res.Status(200);
      res.Send<TJSONArray>(LJsonArray);
    end;
  finally
    DaoDominio.Free;
  end;

end;

procedure Registry;
begin
  THorse.Get('/Dominio', GetDominio);
  Thorse.Get('/ObterDominioByNome/:NomeDominio', ObterDominioByNome);
  Thorse.Get('/ObterListaDominioByNome/:NomeDominio', ObterListaDominioByNome);
  Thorse.Get('/ObterListaDominioById/:Id', ObterListaDominioById);
  THorse.Post('/GravarDominio/:Id', PostarDominio);

end;

end.
