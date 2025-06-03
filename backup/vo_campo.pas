unit vo_campo;

{$mode Delphi}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, Contnrs, DateUtils;

type

  { TVoCampo }

  TVoCampo = class
  private
    FID: string;
    FDT_Create: TDateTime;
    FUser_Create: string;
    FDT_Update: TDateTime;
    FUser_Update: string;
    FDT_Deleted: TDateTime;
    FUser_Delete: string;
    FDeleted: integer;
    FAtivo: integer;
    FID_Tbl0001: string;
    FID_Tbl0003: string;
    FNome_Campo: string;
    FDescricao_Campo: string;
    FValor_Default: integer;

  public
    property ID: string read FID write FID;
    property DT_Create: TDateTime read FDT_Create write FDT_Create;
    property User_Create: string read FUser_Create write FUser_Create;
    property DT_Update: TDateTime read FDT_Update write FDT_Update;
    property User_Update: string read FUser_Update write FUser_Update;
    property DT_Deleted: TDateTime read FDT_Deleted write FDT_Deleted;
    property User_Delete: string read FUser_Delete write FUser_Delete;
    property Deleted: integer read FDeleted write FDeleted;
    property Ativo: integer read FAtivo write FAtivo;
    property ID_Tbl0001: string read FID_Tbl0001 write FID_Tbl0001;
    property ID_Tbl0003: string read FID_Tbl0003 write FID_Tbl0003;
    property Nome_Campo: string read FNome_Campo write FNome_Campo;
    property Descricao_Campo: string read FDescricao_Campo write FDescricao_Campo;
    property Valor_Default: integer read FValor_Default write FValor_Default;

    function ToJSON: TJSONObject;
    procedure FromJSON(const AJson: TJSONObject);
    procedure LoadFromJsonString(const pJsonString: String);
    class function ToJSONArray(VOs: TObjectList): TJSONArray;

  end;

implementation

function TVoCampo.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('ID', FID);
  Result.Add('DT_Create', DateTimeToStr(FDT_Create));
  Result.Add('User_Create', FUser_Create);
  Result.Add('DT_Update', DateTimeToStr(FDT_Update));
  Result.Add('User_Update', FUser_Update);
  Result.Add('DT_Delete', DateTimeToStr(FDT_Deleted));
  Result.Add('User_Delete', FUser_Delete);
  Result.Add('Deleted', FDeleted);
  Result.Add('Ativo', FAtivo);
  Result.Add('ID_Tbl0001', FID_Tbl0001);
  Result.Add('ID_Tbl0003', FID_Tbl0003);
  Result.Add('Nome_Campo', FNome_Campo);
  Result.Add('Descricao_Campo', FDescricao_Campo);
  Result.Add('Valor_Default', FValor_Default);
end;

procedure TVoCampo.FromJSON(const AJson: TJSONObject);
begin
  ID := AJson.Get('ID', '');
  DT_Create := StrToDateTimeDef(AJson.Get('DT_Create', ''), 0);
  User_Create := AJson.Get('User_Create', '');
  DT_Update := StrToDateTimeDef(AJson.Get('DT_Update', ''), 0);
  User_Update := AJson.Get('User_Update', '');
  dDT_Deleted := StrToDateTimeDef(AJson.Get('DT_Deleted', ''), 0);
  User_Delete := AJson.Get('User_Delete', '');
  Deleted := AJson.Get('Deleted', 0);
  Ativo := AJson.Get('Ativo', 0);
  ID_Tbl0001 := AJson.Get('ID_Tbl0001', '');
  ID_Tbl0003 := AJson.Get('ID_Tbl0003', '');
  Nome_Campo := AJson.Get('Nome_Campo', '');
  Descricao_Campo := AJson.Get('Descricao_Campo', '');
  Valor_Default := AJson.Get('Valor_Default', 0);
end;

procedure TVoCampo.LoadFromJsonString(const pJsonString: string);
var
  JSONData: TJSONData;
  JSONObject: TJSONObject;
begin
  JSONData := GetJSON(pJsonString);
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

class function TVoCampo.ToJSONArray(VOs: TObjectList): TJSONArray;
var
  JSONArray: TJSONArray;
  VO: TVoCampo;
  i: Integer;
begin
  JSONArray := TJSONArray.Create;
  for i := 0 to VOs.Count - 1 do
  begin
    VO := TVoCampo(VOs[i]);
    JSONArray.Add(VO.ToJSON);
  end;
  Result := JSONArray;
end;

end.

