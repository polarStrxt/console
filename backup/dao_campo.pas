unit dao_campo;

{$mode Delphi}

interface

uses
  Classes, SysUtils, ZDataset, model_conexao, vo_campo, fpjson, jsonparser, Contnrs;

type

  { TDaoCampo }

  TDaoCampo = class(TDataModule)

    QryCampo: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FModelConexao: TModelConexao;
    FVoCampo: TVoCampo;
    procedure SetModelConexao(AValue: TModelConexao);
    procedure SetVoCampo(AValue: TVoCampo);
    procedure ConfigurarAberturaQuery(pWhere: string); overload;
    procedure ConfigurarAberturaQuery; overload;
    function AtribuirResultSetToVoCampo(pLista: TObjectList): TObjectList;
  public
    function ObterListaCampos: string;
    function ObterListaCamposJson: TJsonArray;
    function ObterCampoByNomeCampo(pNomeCampo: string): TJsonArray;
    function ObterCampoById(pId: string): TJsonArray;
    function ObterListaPeloIdTabela(pIdTabela: string): TObjectList;
    function GravarCampo(pVoCampo: TVoCampo): TJsonArray;

    property VoCampo: TVoCampo read FVoCampo write SetVoCampo;
    property ModelConexao : TModelConexao read FModelConexao write SetModelConexao;
  end;

implementation

{$R *.lfm}

{ TDaoCampo }

procedure TDaoCampo.DataModuleCreate(Sender: TObject);
begin
  ModelConexao := TModelConexao.Create(nil);
  QryCampo.Connection := ModelConexao.Conexao;
end;

procedure TDaoCampo.DataModuleDestroy(Sender: TObject);
begin
  ModelConexao.Free;
  if Assigned(FVoCampo) then
    FVoCampo.Free;
end;

procedure TDaoCampo.SetVoCampo(AValue: TVoCampo);
begin
  if FVoCampo = AValue then Exit;
  FVoCampo := AValue;
end;

procedure TDaoCampo.SetModelConexao(AValue: TModelConexao);
begin
  if FModelConexao=AValue then Exit;
  FModelConexao:=AValue;
end;

procedure TDaoCampo.ConfigurarAberturaQuery(pWhere: string);
begin
  ConfigurarAberturaQuery;
  QryCampo.SQL.Text := QryCampo.SQL.Text + pWhere;
end;

procedure TDaoCampo.ConfigurarAberturaQuery;
begin
  QryCampo.Close;
  QryCampo.SQL.Text := 'SELECT * FROM TBL0002 T0002';
end;

function TDaoCampo.AtribuirResultSetToVoCampo(pLista: TObjectList): TObjectList;
var
  voCampo: TVoCampo;
begin
  QryCampo.First;
  while not QryCampo.EOF do
  begin
    VoCampo := TVoCampo.Create;
    VoCampo.Id := QryCampo.FieldByName('ID').AsString;
    VoCampo.DT_Create := QryCampo.FieldByName('DT_CREATE').AsDateTime;
    VoCampo.DT_Deleted := QryCampo.FieldByName('DT_DELETED').AsDateTime;
    VoCampo.DT_Update := QryCampo.FieldByName('DT_UPDATE').AsDateTime;
    VoCampo.User_Create := QryCampo.FieldByName('USER_CREATE').AsString;
    VoCampo.User_Delete := QryCampo.FieldByName('USER_DELETE').AsString;
    VoCampo.User_Update := QryCampo.FieldByName('USER_UPDATE').AsString;
    VoCampo.Ativo := QryCampo.FieldByName('ATIVO').AsInteger;
    VoCampo.Deleted := QryCampo.FieldByName('DELETED').AsInteger;
 //   VoCampo.Nome := QryCampo.FieldByName('NOME').AsString;
    VoCampo.Nome_Campo := QryCampo.FieldByName('NOME_CAMPO').AsString;
    VoCampo.Descricao_Campo := QryCampo.FieldByName('DESCRICAO_CAMPO').AsString;
    pLista.Add(VoCampo);
    QryCampo.Next;
  end;
end;

function TDaoCampo.ObterListaCampos: string;
var
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery;
    QryCampo.Open;
    AtribuirResultSetToVoCampo(LListaVo);
    LJsonArray := TVoCampo.ToJSONArray(LListaVo);
  finally
    LListaVo.Free;
  end;
  Result := LJsonArray.AsJSON;
  if Assigned(LJsonArray) then
    LJsonArray.Free;
end;

function TDaoCampo.ObterListaCamposJson: TJsonArray;
var
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery;
    QryCampo.Open;
    AtribuirResultSetToVoCampo(LListaVo);
    LJsonArray := TVoCampo.ToJSONArray(LListaVo);
  finally
    LListaVo.Free;
  end;
  Result := LJsonArray;
end;

function TDaoCampo.ObterCampoByNomeCampo(pNomeCampo: string): TJsonArray;
var
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
  LQry : TZQuery;
  VoCampo: TVoCampo;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery(' WHERE T0002.NOME_CAMPO = :pNomeCampo ');
    QryCampo.ParamByName('pNomeCampo').AsString := pNomeCampo;
    QryCampo.Open;
    AtribuirResultSetToVoCampo(LListaVo);
    LJsonArray := TVoCampo.ToJSONArray(LListaVo);
  finally
    LListaVo.Free;
  end;
  Result := LJsonArray;
end;

function TDaoCampo.ObterCampoById(pId: string): TJsonArray;
var
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery(' WHERE T0002.ID = :pId');
    QryCampo.ParamByName('pId').AsString := pId;
    QryCampo.Open;
    AtribuirResultSetToVoCampo(LListaVo);
    LJsonArray := TVoCampo.ToJSONArray(LListaVo);
  finally
    LListaVo.Free;
  end;
  Result := LJsonArray;
end;

function TDaoCampo.ObterListaPeloIdTabela(pIdTabela: string): TObjectList;
var
  VoCampo: TVoCampo;
begin
  result := TObjectList.Create;
  result.OwnsObjects := True;

  try
    ConfigurarAberturaQuery(' WHERE T0002.ID_TBL0001 = :pIdTabela ');
    QryCampo.ParamByName('pIdTabela').AsString := pIdTabela;
    QryCampo.Open;
    AtribuirResultSetToVoCampo(result);
  finally

  end;

end;

function TDaoCampo.GravarCampo(pVoCampo: TVoCampo): TJsonArray;
begin
  Result := nil;
  try
    ConfigurarAberturaQuery(' WHERE T0002.ID = :pId');
    QryCampo.ParamByName('pId').AsString := pVoCampo.Id;
    QryCampo.Open;

    if QryCampo.IsEmpty then
    begin
      QryCampo.Append;
      QryCampo.FieldByName('ID').AsString := pVoCampo.ID;
    end
    else
    begin
      QryCampo.Edit;
    end;

    QryCampo.FieldByName('USER_CREATE').AsString := pVoCampo.User_Create;
    QryCampo.FieldByName('USER_DELETE').AsString := pVoCampo.User_Delete;
    QryCampo.FieldByName('USER_UPDATE').AsString := pVoCampo.User_Update;
    QryCampo.FieldByName('ATIVO').AsInteger := pVoCampo.Ativo;
    QryCampo.FieldByName('DELETED').AsInteger := pVoCampo.Deleted;
  //QryCampo.FieldByName('NOME').AsString := pVoCampo.Nome;
    QryCampo.FieldByName('NOME_CAMPO').AsString := pVoCampo.Nome_Campo;
    QryCampo.FieldByName('DESCRICAO_CAMPO').AsString := pVoCampo.Descricao_Campo;
    QryCampo.Post;
  finally
    Result := ObterCampoById(pVoCampo.ID);
  end;
end;

end.


