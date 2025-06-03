unit rotas_campos_sistema;

{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils, Horse,fpjson, jsonparser, dao_dominio, vo_campo, dao_campo;

procedure Registry;

implementation

procedure GetCampos(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  res.Send('Campos Ok :)')
end;

procedure ObterCamposByIdCampo(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
  var
     DaoCampo: TDaoCampo;
     erro : String;
     LJsonArray : TJsonArray;
     LId : String;
  begin
    begin
      LId := Req.Params['Id'];
      erro := '';
      DaoCampo := TDaoCampo.Create(nil);

       try
         try
           LJsonArray := DaoCampo.ObterCampoById(LId);
           except
             on e: Exception do
             begin
                 erro := 'Erro ao tentar obter a tabela ['+ LId +']. Mensagem do banco de dados '+e.Message;
             end;
           end;
         if erro <> '' then
            begin
            res.Status(400);
            res.Send(erro)
            end
         else
             begin
             res.Status(200);
             res.Send<TJSONArray>(LJsonArray);
             end;
       finally
         DaoCampo.Free;
       end;
    end;
end;

procedure ObterCamposByNomeCampo(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
  var
     DaoCampo: TDaoCampo;
     erro : String;
     LJsonArray : TJsonArray;
     LNomeCampo : String;
begin
  begin
    LNomeCampo := Req.Params['NomeCampo'];
    erro := '';
    DaoCampo := TDaoCampo.Create(nil);

    try
      try
        LJsonArray := DaoCampo.ObterCampoByNomeCampo(LNomeCampo);
      except
        on e: Exception do
        begin
            erro := 'Erro ao tentar obter a tabela ['+LNomeCampo+']. Mensagem do banco de dados '+e.Message;
        end;
      end;
      if erro <> '' then
         begin
         res.Status(400);
         res.Send(erro);
      end
      else begin
          res.Status(200);
          res.Send<TJSONArray>(LJsonArray);
      end;
    finally
      DaoCampo.Free;
    end;
  end;

end;

procedure Registry;
begin
  THorse.Get('/Campo', GetCampos);
  THorse.Get('/ObterCamposByNomeCampo/:NomeCampo', ObterCamposByNomeCampo);
  THorse.Get('/ObterCamposById/:Id', ObterCamposByIdCampo);
end;

end.
