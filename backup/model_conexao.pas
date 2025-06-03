unit model_conexao;

{$mode Delphi}

interface

uses
  Classes, SysUtils, ZConnection;

type

  { TModelConexao }

  TModelConexao = class(TDataModule)
    Conexao: TZConnection;
  private

  public

  end;

implementation

{$R *.lfm}

end.

