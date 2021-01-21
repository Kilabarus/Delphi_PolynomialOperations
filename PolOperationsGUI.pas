unit PolOperationsGUI;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  PolUnit;

const
  OPERATIONS_SYMBOLS: array[0..3] of char = ('+', 'Ц', 'Х', ':');

type
  TMainForm = class(TForm)
    lblTitle: TLabel;
    pnlInput: TPanel;
    lblLeftPol: TLabel;
    edtLeftPol: TEdit;
    lblLeftPolInputError: TLabel;
    lblRightPol: TLabel;
    edtRightPol: TEdit;
    lblRightPolInputError: TLabel;
    lblOptions: TLabel;
    cbbOptions: TComboBox;
    btnCalculate: TButton;
    pnlOutput: TPanel;
    lblTask: TLabel;
    mmoTask: TMemo;
    lblResult: TLabel;
    mmoResult: TMemo;
    procedure edtLeftPolKeyPress(Sender: TObject; var Key: Char);
    procedure edtRightPolKeyPress(Sender: TObject; var Key: Char);
    procedure edtLeftPolExit(Sender: TObject);
    procedure edtRightPolEnter(Sender: TObject);
    procedure edtRightPolExit(Sender: TObject);
    procedure btnCalculateClick(Sender: TObject);
    procedure cbbOptionsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  end;

var
  MainForm: TMainForm;
  leftPol, rightPol: TPolynomial;
  leftPolString, rightPolString: string;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TryStrToPol('1 0 1 0 -3 -3 8 2 -5', leftPol);
  TryStrToPol('3 0 5 0 -4 -9 21', rightPol);
  leftPolString := '(x^8 + x^6 Ц 3x^4 Ц 3x^2 + 8x^2 + 2x Ц 5)';
  rightPolString := '(3x^6 + 5x^4 Ц 4x^2 Ц 9x + 21)';
  mmoTask.Lines[0] := leftPolString + ' + ' + rightPolString;
  mmoResult.Lines[0] := 'x^8 + 4x^6 + 2x^4 Ц 3x^3 + 4x^2 Ц 7x + 16';
end;

function IsKeyValid(Key: Char): Boolean;
begin
  Result := Key in ['0'..'9', '-', '.', #8, #32];
end;

procedure TMainForm.edtLeftPolKeyPress(Sender: TObject; var Key: Char);
begin
  if IsKeyValid(Key) then
    lblLeftPolInputError.Caption := ''
  else
    begin
      lblLeftPolInputError.Caption := '—имвол "' + Key + '" не входит в список допустимых символов';
      Key := #0;
    end
end;

procedure TMainForm.edtRightPolKeyPress(Sender: TObject; var Key: Char);
begin
  if IsKeyValid(Key) then
    lblRightPolInputError.Caption := ''
  else
    begin
      lblRightPolInputError.Caption := '—имвол "' + Key + '" не входит в список допустимых символов';
      Key := #0;
    end
end;

procedure TMainForm.edtLeftPolExit(Sender: TObject);
begin
  if TryStrToPol(edtLeftPol.Text, leftPol) then
    begin
      leftPolString := PolToStr(leftPol);
      if Pos(' ', leftPolString) <> 0 then
        leftPolString := '(' + leftPolString + ')';
      mmoTask.Clear();
      mmoTask.Lines[0] := leftPolString;
      if rightPolString <> '' then
        mmoTask.Lines[0] := mmoTask.Lines[0] + ' ' + OPERATIONS_SYMBOLS[cbbOptions.ItemIndex] + ' ' + rightPolString;
      lblLeftPolInputError.Caption := '';
    end
  else
    begin
      leftPolString := '';
      mmoTask.Lines[0] := rightPolString;
      lblLeftPolInputError.Caption := 'ќшибка, проверьте правильность ввода данных'
    end;
end;

procedure TMainForm.edtRightPolEnter(Sender: TObject);
begin
  btnCalculate.Enabled := True;
end;

procedure TMainForm.edtRightPolExit(Sender: TObject);
begin
  if TryStrToPol(edtRightPol.Text, rightPol) then
    begin
      rightPolString := PolToStr(rightPol);
      if Pos(' ', rightPolString) <> 0 then
        rightPolString := '(' + rightPolString + ')';
      mmoTask.Clear();
      mmoTask.Lines[0] := rightPolString;
      if leftPolString <> '' then
        mmoTask.Lines[0] := leftPolString + ' ' + OPERATIONS_SYMBOLS[cbbOptions.ItemIndex] + ' ' + mmoTask.Lines[0];
      lblRightPolInputError.Caption := '';
    end
  else
    begin
      rightPolString := '';
      mmoTask.Lines[0] := leftPolString;
      lblRightPolInputError.Caption := 'ќшибка, проверьте правильность ввода данных'
    end;
end;

procedure TMainForm.cbbOptionsChange(Sender: TObject);
begin
  if (leftPolString <> '') and (rightPolString <> '') then
    mmoTask.Lines[0] := leftPolString + ' ' + OPERATIONS_SYMBOLS[cbbOptions.ItemIndex] + ' ' + rightPolString;
end;

procedure TMainForm.btnCalculateClick(Sender: TObject);
var
  quotient, remainder: TPolynomial;
begin
  if (leftPolString <> '') and (rightPolString <> '') then
    begin
      mmoResult.Clear();
      case cbbOptions.ItemIndex of
        0:  mmoResult.Lines[0] := PolToStr(PolSum(leftPol, rightPol));
        1:  mmoResult.Lines[0] := PolToStr(PolSub(leftPol, rightPol));
        2:  mmoResult.Lines[0] := PolToStr(PolMult(leftPol, rightPol));
      else
        begin
          quotient := PolDiv(leftPol, rightPol, remainder);
          if remainder = nil then
            if quotient = nil then
              mmoResult.Lines[0] := 'ќшибка: ƒеление на 0 невозможно'
            else
              mmoResult.Lines[0] := '÷ела€ часть: ' + PolToStr(quotient) + #13#10 + 'ќстаток: 0'
          else
            mmoResult.Lines[0] := '÷ела€ часть: ' + PolToStr(quotient) + #13#10 + 'ќстаток: ' + PolToStr(remainder);
        end;
      end;
    end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if leftPol <> nil then
    PolDestroy(leftPol);
  if rightPol <> nil then
    PolDestroy(rightPol);
end;

end.
