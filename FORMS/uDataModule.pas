unit uDataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, uConfigDatabase, uLibrary, FireDAC.VCLUI.Wait;

type
  TdmData = class(TDataModule)
    FDConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
  procedure loadDatabase();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmData: TdmData;

implementation

uses
  System.IOUtils, FMX.Dialogs;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TdmData }

procedure TdmData.DataModuleCreate(Sender: TObject);
begin
  loadDatabase;
end;

procedure TdmData.loadDatabase;
begin
  try
    FDConnection.Params.Database :=  getValorIni(ExtractFilePath(ParamStr(0)) + 'config.ini', 'CONFIGURACAO', 'LOCAL_DB');
    FDConnection.Connected := True;

    FDConnection.Open;

  except
    frmConfigDatabase.ShowModal;
  end;
end;

end.
