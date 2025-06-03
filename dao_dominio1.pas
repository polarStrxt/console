unit dao_dominio;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZDataset, model_conexao, vo_dominio, fpjson, jsonparser, Contnrs;

type
  TDaoDominio = class(TDataModule)
    QryDominio: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FVoDominio: TVoDominio;
    procedure SetVoDominio(AValue: TVoDominio);
    procedure ConfigurarAberturaQuery(pWhere: string); overload;
    procedure ConfigurarAberturaQuery; overload;
    function AtribuirResultSetToVoDominio(pLista: TObjectList): TObjectList;
  public
    function ObterListaDominio: string;
    function ObterListaDominioJson: TJsonArray;
    function ObterDominioById(pID: string): TJsonArray;
    function GravarDominio(pVoDominio: TVoDominio): TJsonArray;

    property VoDominio: TVoDominio read FVoDominio write SetVoDominio;
  end;

implementation

{$R *.lfm}

{ TDaoDominio }

procedure TDaoDominio.DataModuleCreate(Sender: TObject);
begin
  ModelConexao := TModelConexao.Create(nil);
  QryDominio.Connection := ModelConexao.Conexao;
end;

procedure TDaoDominio.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(ModelConexao);
end;

procedure TDaoDominio.SetVoDominio(AValue: TVoDominio);
begin
  FVoDominio := AValue;
end;

procedure TDaoDominio.ConfigurarAberturaQuery;
begin
  with QryDominio do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM DOMINIO');
  end;
end;

procedure TDaoDominio.ConfigurarAberturaQuery(pWhere: string);
begin
  ConfigurarAberturaQuery;
  if pWhere <> '' then
    QryDominio.SQL.Add(' WHERE ' + pWhere);
end;

function TDaoDominio.AtribuirResultSetToVoDominio(pLista: TObjectList): TObjectList;
var
  vo: TVoDominio;
begin
  Result := pLista;
  QryDominio.First;
  while not QryDominio.Eof do
  begin
    vo := TVoDominio.Create;
    vo.Id := QryDominio.FieldByName('ID').AsString;
    vo.Nome := QryDominio.FieldByName('NOME').AsString;
    vo.DT_Create := QryDominio.FieldByName('DT_CREATE').AsDateTime;
    vo.User_Create := QryDominio.FieldByName('USER_CREATE').AsString;
    vo.DT_Update := QryDominio.FieldByName('DT_UPDATE').AsDateTime;
    vo.User_Update := QryDominio.FieldByName('USER_UPDATE').AsString;
    vo.DT_Deleted := QryDominio.FieldByName('DT_DELETE').AsDateTime;
    vo.User_Deleted := QryDominio.FieldByName('USER_DELETE').AsString;
    vo.Deleted := QryDominio.FieldByName('DELETED').AsInteger;
    vo.Ativo := QryDominio.FieldByName('ATIVO').AsInteger;
    vo.Tipo_Dominio := QryDominio.FieldByName('TIPO_DOMINIO').AsInteger;
    vo.Tamanho := QryDominio.FieldByName('TAMANHO').AsInteger;
    vo.Casa_Decimais := QryDominio.FieldByName('CASAS_DECIMAIS').AsInteger;

    pLista.Add(vo);
    QryDominio.Next;
  end;
end;

function TDaoDominio.ObterListaDominio: string;
var
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery;
    QryDominio.Open;
    AtribuirResultSetToVoDominio(LListaVo);
    LJsonArray := TVoDominio.ToJSONArray(LListaVo);
    Result := LJsonArray.AsJSON;
  finally
    LListaVo.Free;
    if Assigned(LJsonArray) then
      LJsonArray.Free;
  end;
end;

function TDaoDominio.ObterListaDominioJson: TJsonArray;
var
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery;
    QryDominio.Open;
    AtribuirResultSetToVoDominio(LListaVo);
    LJsonArray := TVoDominio.ToJSONArray(LListaVo);
    Result := LJsonArray;
  finally
    LListaVo.Free;
  end;
end;

function TDaoDominio.ObterDominioById(pID: string): TJsonArray;
var
  LListaVo: TObjectList;
  LJsonArray: TJSONArray;
begin
  LListaVo := TObjectList.Create;
  LListaVo.OwnsObjects := True;

  try
    ConfigurarAberturaQuery('ID = :pId');
    QryDominio.ParamByName('pId').AsString := pID;
    QryDominio.Open;

    AtribuirResultSetToVoDominio(LListaVo);
    LJsonArray := TVoDominio.ToJSONArray(LListaVo);
    Result := LJsonArray;
  finally
    LListaVo.Free;
  end;
end;

function TDaoDominio.GravarDominio(pVoDominio: TVoDominio): TJsonArray;
begin
  Result := nil;
  try
    ConfigurarAberturaQuery('ID = :pId');
    QryDominio.ParamByName('pId').AsString := pVoDominio.Id;
    QryDominio.Open;

    if QryDominio.IsEmpty then
    begin
      QryDominio.Append;
      QryDominio.FieldByName('ID').AsString := pVoDominio.Id;
    end
    else
      QryDominio.Edit;

    QryDominio.FieldByName('NOME').AsString := pVoDominio.Nome;
    QryDominio.FieldByName('USER_CREATE').AsString := pVoDominio.User_Create;
    QryDominio.FieldByName('USER_DELETE').AsString := pVoDominio.User_Deleted;
    QryDominio.FieldByName('USER_UPDATE').AsString := pVoDominio.User_Update;
    QryDominio.FieldByName('ATIVO').AsInteger := pVoDominio.Ativo;
    QryDominio.FieldByName('DELETED').AsInteger := pVoDominio.Deleted;
    QryDominio.FieldByName('TIPO_DOMINIO').AsInteger := pVoDominio.Tipo_Dominio;
    QryDominio.FieldByName('TAMANHO').AsInteger := pVoDominio.Tamanho;
    QryDominio.FieldByName('CASAS_DECIMAIS').AsInteger := pVoDominio.Casa_Decimais;
    QryDominio.Post;

    Result := ObterDominioById(QryDominio.FieldByName('ID').AsString);
  except
    on E: Exception do
      raise Exception.Create('Erro ao gravar dados na tabela DOMINIO. Mensagem: ' + E.Message);
  end;
end;

end.

