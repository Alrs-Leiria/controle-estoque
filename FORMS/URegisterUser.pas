unit URegisteruser;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FMX.Controls.Presentation, FMX.Menus, FMX.TabControl,
  FMX.Edit, FMX.DateTimeCtrls, FMX.ListBox, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TUser = record
    id, grupo, departamento: Integer;
    nome, email, telefone, senha : string;
    data_cadastro, data_excluido : TDate;
    ativo : Boolean;
  end;

  TfrmRegisterUser = class(TfrmRegister)
    edtId: TEdit;
    ID: TLabel;
    Nome: TLabel;
    edtNome: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtEmail: TEdit;
    edtSenha: TEdit;
    cbGrupo: TComboBox;
    dData: TDateEdit;
    checkAtivo: TCheckBox;
    ListBoxItem1: TListBoxItem;
    Label6: TLabel;
    edtTelefone: TEdit;
    lvUsuarios: TListView;
    cbxDepartamento: TComboBox;
    ListBoxItem2: TListBoxItem;
    DEPARTAMENTO: TLabel;
    procedure btnSaveRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvUsuariosItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure tcControleChange(Sender: TObject);
    procedure btnNewRegisterClick(Sender: TObject);
    procedure btnDeleteRegisterClick(Sender: TObject);
  private
    { Private declarations }
    function  preencherObjetoUsario(usuario : TUser) : TUser;

    function  buscarUsuarioNoBanco( user : TUser) : TUser;
    procedure inserirUsuarioNoBanco( usuario : TUser);
    procedure editarUsuarioNoBanco( usuario : TUser);
    procedure removerUsuarioNoBanco(id_user : Integer);
    procedure listarUsuario();

    procedure inserirUsuarionaLista( user : TUser);


    var operacao : string;
  public
    { Public declarations }
  end;

var
  frmRegisterUser: TfrmRegisterUser;

implementation

{$R *.fmx}

procedure TfrmRegisterUser.btnDeleteRegisterClick(Sender: TObject);
begin
  inherited;
  removerUsuarioNoBanco(StrToInt(edtId.Text));
end;

procedure TfrmRegisterUser.btnNewRegisterClick(Sender: TObject);
begin
  inherited;
  operacao := 'inserir';
  tcControle.TabIndex := 1;
end;

procedure TfrmRegisterUser.btnSaveRegisterClick(Sender: TObject);
var vUsuario : TUser;
begin
  inherited;
  vUsuario := preencherObjetoUsario(vUsuario);

  if operacao = 'editar' then
  begin
    vUsuario.id := StrToInt(edtId.Text);
    editarUsuarioNoBanco(vUsuario);

  end
  else if operacao = 'inserir' then
  begin
    inserirUsuarioNoBanco(vUsuario);
  end;


end;

function TfrmRegisterUser.buscarUsuarioNoBanco(user: TUser) : TUser;
var vUser : TUser;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM usuario');
  FDQueryRegister.SQL.Add('WHERE id = :id');
  FDQueryRegister.ParamByName('id').AsInteger := user.id;

  FDQueryRegister.Open();

  vUser.id := FDQueryRegister.FieldByName('id').AsInteger;
  vUser.nome := FDQueryRegister.FieldByName('nome').AsString;
  vUser.email := FDQueryRegister.FieldByName('email').AsString;
  vUser.telefone := FDQueryRegister.FieldByName('telefone').AsString;
  vUser.grupo := FDQueryRegister.FieldByName('grupo').AsInteger;
  vUser.departamento := FDQueryRegister.FieldByName('departamento').AsInteger;

  Result := vUser;
end;

procedure TfrmRegisterUser.editarUsuarioNoBanco(usuario: TUser);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('UPDATE usuario SET');
  FDQueryRegister.SQL.Add('nome = :nome,');
  FDQueryRegister.SQL.Add('email = :email,');
  FDQueryRegister.SQL.Add('telefone = :telefone,');
  FDQueryRegister.SQL.Add('senha = :senha,');
  FDQueryRegister.SQL.Add('grupo = :grupo,');
  FDQueryRegister.SQL.Add('data_cadastro = :data_cadastro,');
  FDQueryRegister.SQL.Add('data_excluido = :data_excluido,');
  FDQueryRegister.SQL.Add('ativo = :ativo,');
  FDQueryRegister.SQL.Add('departamento = :departamento');
  FDQueryRegister.SQL.Add('WHERE id = :id');

  FDQueryRegister.ParamByName('id').AsInteger := usuario.id;
  FDQueryRegister.ParamByName('grupo').AsInteger := 1;
  FDQueryRegister.ParamByName('departamento').AsInteger := 1;
  FDQueryRegister.ParamByName('nome').AsString := usuario.nome;
  FDQueryRegister.ParamByName('email').AsString := usuario.email;
  FDQueryRegister.ParamByName('telefone').AsString := usuario.telefone;
  FDQueryRegister.ParamByName('senha').AsString := usuario.senha;
  FDQueryRegister.ParamByName('data_cadastro').AsDate := usuario.data_cadastro;
  FDQueryRegister.ParamByName('data_excluido').AsDate := usuario.data_excluido;
  FDQueryRegister.ParamByName('ativo').AsBoolean := usuario.ativo;

  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterUser.FormCreate(Sender: TObject);
begin
  inherited;
  listarUsuario;
end;

procedure TfrmRegisterUser.inserirUsuarionaLista(user: TUser);
begin
  with lvUsuarios.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtId')).Text := IntToStr(user.id);
    TListItemText(Objects.FindDrawable('txtNome')).Text := user.nome;
    TListItemText(Objects.FindDrawable('txtEmail')).Text := user.email;
    TListItemText(Objects.FindDrawable('txtTelefone')).Text := user.telefone;
    TListItemText(Objects.FindDrawable('txtGrupo')).Text := IntToStr(user.grupo);
    TListItemText(Objects.FindDrawable('txtDepartamento')).Text := IntToStr(user.departamento);
  end;
end;

procedure TfrmRegisterUser.inserirUsuarioNoBanco(usuario: TUser);
begin

  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('INSERT INTO usuario(nome, email, telefone, senha, grupo, data_cadastro, data_excluido, ativo, departamento)');
  FDQueryRegister.SQL.Add('VALUES (:nome, :email, :telefone, :senha, :grupo, :data_cadastro, :data_excluido, :ativo, :departamento)');

  FDQueryRegister.ParamByName('nome').AsString := usuario.nome;
  FDQueryRegister.ParamByName('email').AsString := usuario.email;
  FDQueryRegister.ParamByName('telefone').AsString := usuario.telefone;
  FDQueryRegister.ParamByName('senha').AsString := usuario.senha;
  FDQueryRegister.ParamByName('grupo').AsInteger := 1;
  FDQueryRegister.ParamByName('departamento').AsInteger := 1;
  FDQueryRegister.ParamByName('data_cadastro').AsDate := usuario.data_cadastro;
  FDQueryRegister.ParamByName('data_excluido').AsDate := usuario.data_excluido;
  FDQueryRegister.ParamByName('ativo').Asfloat := 1;

  FDQueryRegister.ExecSQL;
end;


procedure TfrmRegisterUser.listarUsuario();
var vUser : TUser;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM usuario');

  FDQueryRegister.Open();

  FDQueryRegister.First;

  lvUsuarios.Items.Clear;

  while not FDQueryRegister.Eof do
  begin
    vUser.id := FDQueryRegister.FieldByName('id').AsInteger;
    vUser.nome := FDQueryRegister.FieldByName('nome').AsString;
    vUser.email := FDQueryRegister.FieldByName('email').AsString;
    vUser.telefone := FDQueryRegister.FieldByName('telefone').AsString;
    vUser.grupo := FDQueryRegister.FieldByName('grupo').AsInteger;
    vUser.departamento := FDQueryRegister.FieldByName('departamento').AsInteger;
    vUser.senha := FDQueryRegister.FieldByName('senha').AsString;

    inserirUsuarionaLista(vUser);

    FDQueryRegister.Next;
  end;


end;

procedure TfrmRegisterUser.lvUsuariosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var vUser : TUser;
    id_user : Integer;
begin
  inherited;

  vUser.id := StrToInt(TListItemText(lvUsuarios.Items[ItemIndex].Objects.FindDrawable('txtId')).Text);

  vUser := buscarUsuarioNoBanco(vUser);

  edtId.Text := IntToStr(vUser.id);
  edtNome.Text := vUser.nome;
  edtEmail.Text := vUser.email;
  edtSenha.Text := vUser.senha;
  edtTelefone.Text := vUser.telefone;
  cbGrupo.ItemIndex := vUser.grupo;
  dData.Date := vUser.data_cadastro;
  dData.Date := vUser.data_excluido;
  {checkAtivo := True;}
  operacao := 'editar';
  tcControle.TabIndex := 1;


end;

function TfrmRegisterUser.preencherObjetoUsario(usuario: TUser): TUser;
begin

  usuario.nome := edtNome.Text;
  usuario.email := edtEmail.Text;
  usuario.senha := edtSenha.Text;
  usuario.telefone := edtTelefone.Text;
  usuario.grupo := cbGrupo.ItemIndex;
  usuario.data_cadastro := dData.Date;
  usuario.data_excluido := dData.Date;
  usuario.ativo := true;
  usuario.departamento := cbxDepartamento.ItemIndex;

  Result := usuario;
end;

procedure TfrmRegisterUser.removerUsuarioNoBanco(id_user: Integer);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('DELETE FROM usuario');
  FDQueryRegister.SQL.Add('WHERE id = :id');

  FDQueryRegister.ParamByName('id').AsInteger := id_user;

  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterUser.tcControleChange(Sender: TObject);
begin
  inherited;
  if (tcControle.TabIndex = 1) and (operacao = '') then
  begin
    tcControle.TabIndex := 0;

    ShowMessage('Selecione o usuario');
  end;
end;

end.
