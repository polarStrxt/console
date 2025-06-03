unit rotas_tabelas_sistema;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Horse, dao_tabela, fpjson, jsonparser, vo_Tabela, dao_dominio;

procedure Registry;


implementation

procedure getTabelas(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  res.Send('Tabelas Ok :)');
end;





procedure PostarTabela(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  DaoTabela: TDaoTabela;
  erro: string;
  LJsonArray: TJsonArray;
  LId: string;
  vo: TVoTabela;
  s: string;
begin
  LId := '';

  if Req.Params.ContainsKey('Id') then
    LId := Req.Params['Id'];

  erro := '';
  DaoTabela := TDaoTabela.Create(nil);
  vo := TVoTabela.Create;
  vo.FromJSON(Req.Body<TJSONObject>);
  try
    try
      LJsonArray := DaoTabela.GravarTabela(vo);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar gravar a tabela [' + LId +
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
    DaoTabela.Free;
  end;

end;

procedure ObterTabelasByCodigoTabela(Req: THorseRequest;
  Res: THorseResponse; Next: TNextProc);
var
  DaoTabela: TDaoTabela;
  erro: string;
  LJsonArray: TJsonArray;
  LCodTabela: string;
begin
  LCodTabela := Req.Params['CodTabela'];
  erro := '';
  DaoTabela := TDaoTabela.Create(nil);

  try
    try
      LJsonArray := DaoTabela.ObterTabelaByCodigoTabela(LCodTabela);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar obter a tabela [' + LCodTabela +
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
    DaoTabela.Free;
  end;

end;

procedure ObterListaTabelasByCodigoTabela(Req: THorseRequest;
  Res: THorseResponse; Next: TNextProc);
var
  DaoTabela: TDaoTabela;
  erro: string;
  LJsonArray: TJsonArray;
  LCodTabela: string;
begin
  LCodTabela := Req.Params['CodTabela'];
  erro := '';
  DaoTabela := TDaoTabela.Create(nil);

  try
    try
      LJsonArray := DaoTabela.ObterListaTabelaByCodigoTabela(LCodTabela);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar obter a tabela [' + LCodTabela +
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
    DaoTabela.Free;
  end;

end;


procedure Registry;
begin

  THorse.Get('/Tabela', GetTabelas);
  //THorse.Get('/ObterListaTabelasByNome/:NomeTabela', ObterListaTabelasByNome);
  THorse.Get('/ObterTabelasByCodigoTabela/:CodTabela', ObterTabelaByCodigoTabela);
  THorse.Get('/ObterListaTabelasByCodigoTabela/:CodTabela', ObterListaTabelasByCodigoTabela);
  THorse.Post('/GravarTabela/:Id', PostarTabela);

end;

end.
