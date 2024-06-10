unit uResgusterEquipament;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Param, FireDAC.Phys.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TabControl, FMX.Controls.Presentation, FMX.Edit,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.DateTimeCtrls, FMX.ListBox;

type
  TEquipamento = record
    codigo, departamento, tipo : Integer;
    descricao, patrimonio, marca, modelo, serie, observacao : string;
    data_cadastro, data_excluido : TDate;
    valor : Double;
    ativo : Boolean;
  end;
  TfrmRegisterEquipament = class(TfrmRegister)
    edtPatrimonio: TEdit;
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    edtSenha: TEdit;
    edtTelefone: TEdit;
    ID: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtSerie: TLabel;
    Nome: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    cbxMarca: TComboBox;
    cbxModelo: TComboBox;
    cbxDepartamento: TComboBox;
    dData: TDateEdit;
    CheckBox1: TCheckBox;
    memoObservacao: TMemo;
    Label3: TLabel;
    cbxTipo: TComboBox;
    procedure btnSaveRegisterClick(Sender: TObject);
  private
    { Private declarations }
    procedure inserirEquipamentoNoBanco( equipamento : TEquipamento);
  public
    { Public declarations }
  end;

var
  frmRegisterEquipament: TfrmRegisterEquipament;

implementation

{$R *.fmx}

procedure TfrmRegisterEquipament.btnSaveRegisterClick(Sender: TObject);
var vEquipamento : TEquipamento;
begin
  inherited;


end;



procedure TfrmRegisterEquipament.inserirEquipamentoNoBanco(equipamento: TEquipamento);
var vEquipamento : TEquipamento;
begin
  vEquipamento.codigo := StrToInt(edtCodigo.Text);
  vEquipamento.departamento := cbxDepartamento.ItemIndex;
  vEquipamento.tipo := cbxTipo.ItemIndex;
  vEquipamento.descricao := edtDescricao.Text;
  vEquipamento.patrimonio := edtPatrimonio.Text;
  vEquipamento.marca := cbxMarca.ItemIndex;
  vEquipamento.modelo := cbxModelo.ItemIndex;
  vEquipamento.serie := edtSerie.Text;
  vEquipamento.observacao := memoObservacao.Text;
  vEquipamento.data_cadastro := dData.Date;
  vEquipamento.data_excluido := dData.Date;
  vEquipamento.valor := StrToFloat(edtValor.Text);
  vEquipamento.ativo := cbAtivo.Checked;

  inserirEquipamentoNoBanco(vEquipamento);
end;

end.
