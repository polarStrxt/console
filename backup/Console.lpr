program Console;

{$MODE DELPHI}{$H+}

uses
  SysUtils,
  dateutils,
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Horse, Horse.Request, Horse.Jhonson, zcomponent, ZDbcFirebirdInterbase,
  rotas_tabelas_sistema, model_conexao, dao_tabela, vo_tabela, dao_dominio,
  rotas_dominios_sistema, rotas_campos_sistema, vo_campo, dao_campo;

  procedure GetPing(Req: THorseRequest; Res: THorseResponse);
  begin
    Res.Send('Pong ' + DateTimeToStr(now));
  end;

begin
   THorse.Use(Jhonson());
  THorse.Get('/ping', GetPing);
  rotas_tabelas_sistema.Registry;
  rotas_dominios_sistema.Registry;
  rotas_campos_sistema.Registry;
  THorse.Listen(9000);
end.
