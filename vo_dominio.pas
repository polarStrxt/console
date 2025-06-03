unit vo_dominio;

{$mode Delphi}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, Contnrs, DateUtils;

type

  { TVoDominio }

  TVoDominio = class
  private
    FID: string;
    FNome: string;
    FDT_Create: TDateTime;
    FUser_Create: string;
    FDT_Update: TDateTime;
    FUser_Update: string;
    FDT_Deleted: TDateTime;
    FUser_Deleted: string;
    FDeleted: integer;
    FAtivo: integer;
    FTipo_Dominio: integer;
    FTamanho: integer;
    FCasa_Decimais: integer;

  public
    property ID: string read FID write FID;
    property Nome: string read FNome write FNome;
    property DT_Create: TDateTime read FDT_Create write FDT_Create;
    property User_Create: string read FUser_Create write FUser_Create;
    property DT_Update: TDateTime read FDT_Update write FDT_Update;
    property User_Update: string read FUser_Update write FUser_Update;
    property DT_Deleted: TDateTime read FDT_Deleted write FDT_Deleted;
    property User_Deleted: string read FUser_Deleted write FUser_Deleted;
    property Deleted: integer read FDeleted write FDeleted;
    property Ativo: integer read FAtivo write FAtivo;
    property Tipo_Dominio: integer read FTipo_Dominio write FTipo_Dominio;
    property Tamanho: integer read FTamanho write FTamanho;
    property Casa_Decimais: integer read FCasa_Decimais write FCasa_Decimais;

    function ToJSON: TJSONObject;
    procedure FromJSON(const AJson: TJSONObject);
    procedure LoadFromJsonString (const pJsonString : String);
    class function ToJSONArray(VOs: TObjectList): TJSONArray;

  end;


implementation

function  TVoDominio.ToJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('ID', FID);
  Result.Add('Nome', FNome);
  Result.Add('DT_Create', DateTimeToStr(FDT_Create));
  Result.Add('User_Create', FUser_Create);
  Result.Add('DT_Update', DateTimeToStr(FDT_Update));
  Result.Add('User_Update', FUser_Update);
  Result.Add('DT_Deleted', DateTimeToStr(FDT_Deleted));
  Result.Add('User_Deleted', FUser_Deleted);
  Result.Add('Deleted', FDeleted);
  Result.Add('Ativo', FAtivo);
  Result.Add('Tipo_Dominio', FTipo_Dominio);
  Result.Add('Tamanho', FTamanho);
  Result.Add('Casa_Decimais', FCasa_Decimais);
end;

procedure TVoDominio.FromJson(const AJson: TJSONObject);
begin
  ID :=AJson.Get('ID', '');
  Nome :=Ajson.Get('Nome','');
  DT_Create := StrToDateTimeDef(AJson.Get('DT_Create', ''), 0);
  User_Create := AJson.Get('User_Create', '');
  DT_Update := StrToDateTimeDef(AJson.Get('DT_Update', ''), 0);
  User_Update :=AJson.Get('User_Update', '');
  DT_Deleted :=StrToDateTimeDef(Ajson.Get('DT_Deleted', ''), 0);
  User_Deleted :=AJson.Get('User_Deleted', '');
  Deleted := AJson.Get('Deleted', 0);
  Ativo := AJson.Get('Ativo', 0);
  Tipo_Dominio := AJson.Get('Tipo_Dominio', 0);
  Tamanho:= AJson.Get('Tamanho', 0);
  Casa_Decimais:= AJson.get('Casa_Decimais', 0);
end;

procedure TVoDominio.LoadFromJsonString(const pJsonString: string);
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

class function TVoDominio.ToJSONArray(VOs: TObjectList): TJSONArray;
var
  JSONArray: TJSONArray;
  VO: TVoDominio;
  i : Integer;
begin
  JSONArray := TJSONArray.Create;
  For i := 0 To Vos.Count - 1 do
  begin
        Vo := TVoDominio(VOs[i]);
	JSONArray.Add(VO.ToJSON);
  end;
  Result := JSONArray;
end;

end.

