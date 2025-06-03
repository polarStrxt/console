unit dao_tabela;

{$mode Delphi}

interface

uses
  Classes, SysUtils, ZDataset, model_conexao, vo_tabela, fpjson,
  jsonparser, Contnrs, vo_campo, dao_campo;

type

  { TDaoTabela }

  TDaoTabela = class(TDataModule)
    QryTabela: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FModelConexao: TModelConexao;
    FVoTabela: TVoTabela;
    procedure SetModelConexao(AValue: TModelConexao);
    procedure SetVoTabela(AValue: TVoTabela);
    procedure ConfigurarAberturaQuery(pWhere: string); overload;
    procedure ConfigurarAberturaQuery; overload;
    function AtribuirResultSetToVoTabela(pLista: TObjectList): TObjectList;
  public

    function ObterListaTabelas: string;
    function ObterListaTabelasJson: TJsonArray;
    function ObterTabelaByCodigoTabela(pCodigoTabela: string): TJsonArray;
    function ObterTabelaById(pId: string): TJsonArray;
    function ObterListaTabelaByCodigoTabela(pCodigoTabela: string): TJsonArray;
    function GravarTabela(pVoTabela: TVoTabela): TJsonArray;

    property VoTabela: TVoTabela read FVoTabela write SetVoTabela;
    property ModelConexao :TModelConexao read FModelConexao write SetModelConexao;

  end;

implementation

{$R *.lfm}

{ TDaoTabela }

procedure TDaoTabela.DataModuleCreate(Sender: TObject);
begin
  FModelConexao := TModelConexao.Create(nil);
  QryTabela.Connection := FModelConexao.Conexao;

end;

procedure TDaoTabela.DataModuleDestroy(Sender: TObject);
begin
  ModelConexao.Free;

  if Assigned(FVoTabela) then
    FVoTabela.Free;
end;

procedure TDaoTabela.SetVoTabela(AValue: TVoTabela);
begin
  if FVoTabela = AValue then Exit;
  FVoTabela := AValue;
end;

procedure TDaoTabela.SetModelConexao(AValue: TModelConexao);
begin
  if FModelConexao=AValue then Exit;
  FModelConexao:=AValue;
end;

procedure TDaoTabela.ConfigurarAberturaQuery(pWhere: string);
begin
  ConfigurarAberturaQuery;
  QryTabela.SQL.Text := QryTabela.SQL.Text + pWhere;
end;

procedure TDaoTabela.ConfigurarAberturaQuery;
begin
  QryTabela.Close;
  QryTabela.SQL.Text := 'SELECT * FROM TBL0001  T0001';
end;

function TDaoTabela.AtribuirResultSetToVoTabela(pLista: TObjectList): TObjectList;
var
  voTabela: TVoTabela;
begin
  QryTabela.First;
  while not QryTabela.EOF do
  begin
    VoTabela := TVoTAbela.Create;
    VoTabela.Id := QryTabela.FieldByName('ID').AsString;
    VoTabela.DtCreate := QryTabela.FieldByName('DT_CREATE').AsDateTime;
    VoTabela.DtDeleted := QryTabela.FieldByName('DT_DELETED').AsDateTime;
    VoTabela.DtUpdate := QryTabela.FieldByName('DT_UPDATE').AsDateTime;
    VoTabela.UserCreate := QryTabela.FieldByName('USER_CREATE').AsString;
    VoTabela.UserDelete := QryTabela.FieldByName('USER_DELETE').AsString;
    VoTabela.UserUpdate := QryTabela.FieldByName('USER_UPDATE').AsString;
    VoTabela.Ativo := QryTabela.FieldByName('ATIVO').AsInteger;
    VoTabela.Deleted := QryTabela.FieldByName('DELETED').AsInteger;
    VoTabela.Nome := QryTabela.FieldByName('NOME').AsString;
    VoTabela.CodigoTabela := QryTabela.FieldByName('CODIGO_TABELA').AsString;
    VoTabela.DescricaoTabela := QryTabela.FieldByName('DESCRICAO_TABELA').AsString;
    pLista.Add(VoTabela);
    QryTabela.Next;
  end;
end;

function TDaoTabela.ObterListaTabelas: string;
var
  VoTabela: TVoTabela;
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery;
    QryTabela.Open;
    AtribuirResultSetToVoTabela(LListaVo);
    LJsonArray := TVoTabela.ToJSONArray(LListaVo);
  finally
    LListaVo.Free;
  end;
  Result := LJsonArray.AsJSON;

  if Assigned(LJsonArray) then
    LJsonArray.Free;

end;

function TDaoTabela.ObterListaTabelasJson: TJsonArray;
var
  VoTabela: TVoTabela;
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery;

    QryTabela.Open;
    AtribuirResultSetToVoTabela(LListaVo);

    LJsonArray := TVoTabela.ToJSONArray(LListaVo);

  finally
    LListaVo.Free;
  end;
  Result := LJsonArray;
end;

function TDaoTabela.ObterTabelaByCodigoTabela(pCodigoTabela: string): TJsonArray;
var
  VoTabela: TVoTabela;
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
  LjsonArrayCampo: TJSONArray;
  LQry: TZQuery;
  LJsonObject: TJSonObject;
  LDaoCampo: TDaoCampo;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;
  LDaoCampo := nil;

  try
    ConfigurarAberturaQuery(' WHERE T0001.CODIGO_TABELA = :pCodigoTabela');
    QryTabela.ParamByName('pCodigoTabela').AsString := pCodigoTabela;
    QryTabela.Open;

    AtribuirResultSetToVoTabela(LListaVo);
    VoTabela := TVoTabela(LListaVo.Items[0]);

    // Criar o Dao dos Campos
    LDaoCampo := TDaoCampo.Create(nil);
    if Assigned(VoTabela.ListaCampos) then
      VoTabela.ListaCampos.Free;

    VoTabela.ListaCampos := LDaoCampo.ObterListaPeloIdTabela(VoTabela.Id);

    LJsonArray := TVoTabela.ToJSONArray(LListaVo);

  finally
    LListaVo.Free;
    LDaoCampo.free;
  end;
  Result := LJsonArray;

end;

function TDaoTabela.ObterListaTabelaByCodigoTabela(pCodigoTabela: string): TJsonArray;
var
  VoTabela: TVoTabela;
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
  LjsonArrayCampo: TJSONArray;
  LQry: TZQuery;
  LJsonObject: TJSonObject;
  LDaoCampo: TDaoCampo;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;
  LDaoCampo := nil;

  try
     ConfigurarAberturaQuery(' WHERE T0001.CODIGO_TABELA LIKE :pCodigoTabela');
    QryTabela.ParamByName('pCodigoTabela').AsString := pCodigoTabela + '%';
    QryTabela.Open;

    AtribuirResultSetToVoTabela(LListaVo);
    VoTabela := TVoTabela(LListaVo.Items[0]);

    // Criar o Dao dos Campos
    LDaoCampo := TDaoCampo.Create(nil);
    if Assigned(VoTabela.ListaCampos) then
      VoTabela.ListaCampos.Free;

    VoTabela.ListaCampos := LDaoCampo.ObterListaPeloIdTabela(VoTabela.Id);

    LJsonArray := TVoTabela.ToJSONArray(LListaVo);

  finally
    LListaVo.Free;
    LDaoCampo.free;
  end;
  Result := LJsonArray;

end;

function TDaoTabela.ObterTabelaById(pId: string): TJsonArray;
var
  VoTabela: TVoTabela;
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery(' WHERE T0001.ID = :pId');
    QryTabela.ParamByName('pId').AsString := pId;
    QryTabela.Open;

    AtribuirResultSetToVoTabela(LListaVo);

    LJsonArray := TVoTabela.ToJSONArray(LListaVo);

  finally
    LListaVo.Free;
  end;
  Result := LJsonArray;
end;

function TDaoTabela.GravarTabela(pVoTabela: TVoTabela): TJsonArray;
begin
  Result := nil;
  try

    ConfigurarAberturaQuery(' WHERE T0001.ID = :pId');

    QryTabela.ParamByName('pId').AsString := pVoTabela.Id;
    QryTabela.Open;

    if QryTabela.IsEmpty then
    begin
      QryTabela.Append;
      QryTabela.FieldByName('ID').AsString := pVoTabela.ID;
    end
    else
    begin
      QryTabela.Edit;
    end;

    QryTabela.FieldByName('USER_CREATE').AsString := pVoTabela.UserCreate;
    QryTabela.FieldByName('USER_DELETE').AsString := pVoTabela.UserDelete;
    QryTabela.FieldByName('USER_UPDATE').AsString := pVoTabela.UserUpdate;
    QryTabela.FieldByName('ATIVO').AsInteger := pVoTabela.Ativo;
    QryTabela.FieldByName('DELETED').AsInteger := pVoTabela.Deleted;
    QryTabela.FieldByName('NOME').AsString := pVoTabela.Nome;
    QryTabela.FieldByName('CODIGO_TABELA').AsString := pVoTabela.CodigoTabela;
    QryTabela.FieldByName('DESCRICAO_TABELA').AsString := pVoTabela.DescricaoTabela;
    QryTabela.Post;

    Result := ObterTabelaById(QryTabela.FieldByName('ID').AsString);

  except
    on e: Exception do
    begin
      raise Exception.Create('Erro ao gravar dados na tabela TBL0001. Mensagem ' +
        e.Message);
    end;
  end;
end;

end.
