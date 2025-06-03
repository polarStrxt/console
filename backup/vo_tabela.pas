unit vo_tabela;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, Contnrs, vo_campo;

type

  { TVoTabela }

  TVoTabela = class
  private
    FId: string;
    FListaCampos: TObjectList;
    FNome: string;
    FDtCreate: TDateTime;
    FUserCreate: string;
    FDtUpdate: TDateTime;
    FUserUpdate: string;
    FDtDeleted: TDateTime;
    FUserDelete: string;
    FDeleted: integer;
    FAtivo: integer;
    FCodigoTabela: string;
    FDescricaoTabela: string;
    procedure SetListaCampos(AValue: TObjectList);
  public

    constructor Create;
    destructor Destroy; override;


    property Id: string read FId write FId;
    property Nome: string read FNome write FNome;
    property DtCreate: TDateTime read FDtCreate write FDtCreate;
    property UserCreate: string read FUserCreate write FUserCreate;
    property DtUpdate: TDateTime read FDtUpdate write FDtUpdate;
    property UserUpdate: string read FUserUpdate write FUserUpdate;
    property DtDeleted: TDateTime read FDtDeleted write FDtDeleted;
    property UserDelete: string read FUserDelete write FUserDelete;
    property Deleted: integer read FDeleted write FDeleted;
    property Ativo: integer read FAtivo write FAtivo;
    property CodigoTabela: string read FCodigoTabela write FCodigoTabela;
    property DescricaoTabela: string read FDescricaoTabela write FDescricaoTabela;
    property ListaCampos: TObjectList read FListaCampos write SetListaCampos;

    function AdicionarCampo(pVoCampo: TVoCampo): integer;
    function RemoverCampo(pVoCampo: TVoCampo): integer;
    function ToJSON: TJSONObject;
    procedure FromJSON(JSON: TJSONObject);
    procedure LoadFromJsonString(const pJsonString: string);
    class function ToJSONArray(VOs: TObjectList): TJSONArray;
  end;

implementation

uses
  DateUtils;

procedure TVoTabela.SetListaCampos(AValue: TObjectList);
begin
  if FListaCampos = AValue then Exit;
  FListaCampos := AValue;
end;

constructor TVoTabela.Create;
begin
  inherited Create;
  FListaCampos := TObjectList.Create;
end;

destructor TVoTabela.Destroy;
begin
  inherited Destroy;
  FListaCampos.Free;
end;

function TVoTabela.AdicionarCampo(pVoCampo: TVoCampo): integer;
begin
  Result := FListaCampos.Add(pVoCampo);

end;

function TVoTabela.RemoverCampo(pVoCampo: TVoCampo): integer;
var
  i: integer;
begin
  for i := 0 to FListaCampos.Count - 1 do
  begin
    if TVoCampo(FListaCampos.Items[i]) = pVoCampo then
      break;
  end;
  FListaCampos.Delete(i);
end;

function TVoTabela.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('Id', FId);
  Result.Add('Nome', FNome);
  Result.Add('Dt_Create', DateToStr(FDtCreate));
  Result.Add('User_Create', FUserCreate);
  Result.Add('Dt_Update', DateToStr(FDtUpdate));
  Result.Add('User_Update', FUserUpdate);
  Result.Add('Dt_Deleted', DateToStr(FDtDeleted));
  Result.Add('User_Delete', FUserDelete);
  Result.Add('Deleted', FDeleted);
  Result.Add('Ativo', FAtivo);
  Result.Add('Codigo_Tabela', FCodigoTabela);
  Result.Add('Descricao_Tabela', FDescricaoTabela);

  // Serializar ListaCampos
  CamposArray := TJSONArray.Create;
  for i := 0 to FListaCampos.Count - 1 do
  begin
    CamposArray.Add(TVoCampo(FListaCampos[i]).ToJSON);
  end;
  Result.Add('ListaCampos', CamposArray);

end;

procedure TVoTabela.FromJSON(JSON: TJSONObject);
begin
  if JSON = nil then Exit;
  FId := JSON.Get('Id', '');
  FNome := JSON.Get('Nome', '');
  FUserCreate := JSON.Get('User_Create', '');
  FUserUpdate := JSON.Get('User_Update', '');
  FUserDelete := JSON.Get('User_Delete', '');
  FDeleted := JSON.Get('Deleted', 0);
  FAtivo := JSON.Get('Ativo', 0);
  FCodigoTabela := JSON.Get('Codigo_Tabela', '');
  FDescricaoTabela := JSON.Get('Descricao_Tabela', '');
end;

procedure TVoTabela.LoadFromJsonString(const pJsonString: string);
var
  JSONData: TJSONData;
  JSONObject: TJSONObject;
begin
  JSONData := GetJSON(pJSONString);
  try
    if JSONData.JSONType = jtObject then
    begin
      JSONObject := TJSONObject(JSONData);
      FromJSON(JSONObject);
    end;
  finally
    JSONData.Free;
  end;
end;

class function TVoTabela.ToJSONArray(VOs: TObjectList): TJSONArray;
var
  JSONArray: TJSONArray;
  VO: TVoTabela;
  i: integer;
begin
  JSONArray := TJSONArray.Create;
  for i := 0 to Vos.Count - 1 do
  begin
    Vo := TVoTabela(VOs[i]);
    JSONArray.Add(VO.ToJSON);
  end;
  Result := JSONArray;
end;

end.
