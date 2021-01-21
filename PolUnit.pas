unit PolUnit;

interface

const
  // �������� ��������� � ����� ����� � ��������� �������
  POL_UNIT_EPSILON = 0.0001;

type
  // �������� ����������� ������, � ������ �������� ������ 3 ����:
  // Coef   - ����������� ��� ����� ������� Degree
  // Degree - ������� �����
  // Next   - ��������� �� ��������� ������� ������
  TPtr = ^TList;
  TList = record
    Coef: Double;
    Degree: Integer;
    Next: TPtr;
  end;

  // ��������� �� ��������� ������� ������ � �����������
  TPolynomial = TPtr;

// ������� ������� �������������� ������ stringWithPol � ��������� pol
// ���������� True, ���� �������������� �������
// ���������� False � �������� ������
function TryStrToPol(stringWithPol: string; var pol: TPolynomial): Boolean;

// ������� �������������� ���������� pol � ������
// ���������� ������ � �����������
function PolToStr(pol: TPolynomial): string;

// ������� ����������� ������ � ����������� polToCopy
// ���������� ��������� �� ��������� ������� ������ �� ������������� �����������
function PolCopy(polToCopy: TPolynomial): TPolynomial;

// ��������� ������� �������� ������ � ����������� polToDestroy
procedure PolDestroy(var polToDestroy: TPolynomial);

// ��� ����������� ������� ���������� ��������� �� ��������� ������� ������ � �������������� �����������

// ������� ��������� ���������� pol �� ����� number
function PolMultByNumber(pol: TPolynomial; number: Double): TPolynomial;

// ������� �������� ��������� p1 � p2
function PolSum(p1, p2: TPolynomial): TPolynomial;

// ������� ��������� �������� p2 �� �������� p1
function PolSub(p1, p2: TPolynomial): TPolynomial;

// ������� ������������ ��������� p1 � p2
function PolMult(p1, p2: TPolynomial): TPolynomial;

// ������� ������� ���������� pol �� ����� number
function PolDivByNumber(pol: TPolynomial; number: Double): TPolynomial;

// ������� ������� �������� p1 �� ������� p2 � �������� remainder
function PolDiv(p1, p2: TPolynomial; var remainder: TPolynomial): TPolynomial;

implementation

uses
  SysUtils, StrUtils;

// ������� ������� �������� � �������� ������������� cf � �������� dg � ������
// p - ��������� �� ��������� ������� ������ ����� ������������
// ���������� ��������� �� ����������� ������� ������
function AddNode(var p: TPtr; cf: Double; dg: Integer): TPtr;
begin
  New(Result);
  Result^.Coef := cf;
  Result^.Degree := dg;
  Result^.Next := p;
  p := Result;
end;

// ��������� �������� �������� �� ������
// p - ��������� �� ��������� ������� ������
// �������������� ��������� p �� ��������� �� ��������� ������� ������
procedure DelNode(var p: TPtr);
var
  del: TPtr;
begin
  del := p;
  p := p^.Next;
  Dispose(del);
end;

// ��������� ������� ������ polToClear
// (�������� ���� ���������, ����� ����������)
procedure PolClear(var polToClear: TPolynomial);
begin
  while polToClear^.Next <> nil do
    DelNode(polToClear^.Next);
end;

// ��������� ������� �������� ������ polToDestroy �� ������
procedure PolDestroy(var polToDestroy: TPolynomial);
begin
  PolClear(polToDestroy);
  Dispose(polToDestroy);
  polToDestroy := nil;
end;

// ������� ������������� ������ polToInit
// ���������� ��������� �� ��������� ������� ������ � ������������� cf � �������� dg
function PolInit(var polToInit: TPolynomial; cf: Double = 0; dg: Integer = 0): TPolynomial;
begin
  New(polToInit);
  polToInit^.Coef := cf;
  polToInit^.Degree := dg;
  polToInit^.Next := nil;
  Result := polToInit;
end;

// ������� �������������� ������ stringWithPol � ��������� pol
// ���������� True, ���� �������������� �������
// ���������� False � �������� ������
function TryStrToPol(stringWithPol: string; var pol: TPolynomial): Boolean;
var
  spaceIndex, dg, i: Integer;
  cf: Double;
  t: TPtr;
begin
  Result := True;
  stringWithPol := Trim(stringWithPol);

  // ���� �������� ������ ������, ���������� ������� ���������
  if Length(stringWithPol) = 0 then
    PolInit(pol)
  else
    begin
      dg := -1;
      i := 1;

      // ������� ������� ���������� dg �� ���������� ��������, ����������� ���������
      while i <> 0 do
        if stringWithPol[i] = ' ' then
          i := i + 1
        else
          begin
            Inc(dg);
            i := PosEx(' ', stringWithPol, i);
          end;

      t := PolInit(pol);

      // ���� ��� ������ � ����� � �� ������� ��� ������������
      while Result and (Length(stringWithPol) <> 0) do
        begin
          // ������� ������ � ������,
          // ��������������� ������� ������� ����� ���������� ������������
          spaceIndex := Pos(' ', stringWithPol);
          if spaceIndex = 0 then
            spaceIndex := Length(stringWithPol);

          // �������� ������������� ��������� ����������� � ����� � ��������� ������
          Result := TryStrToFloat(Copy(stringWithPol, 1, spaceIndex), cf);

          if Result then
            begin
              // ���� ������� �������� - ��������� �� ��������� ���������� ����� ����
              if Abs(cf) > POL_UNIT_EPSILON then
                t := AddNode(t^.next, cf, dg);

              // ��������� ������� ����� ��� ���������� ������������
              dg := dg - 1;

              // ������� ��������� ����������� �� ������
              Delete(stringWithPol, 1, spaceIndex);
              stringWithPol := Trim(stringWithPol);
            end;
        end;

      if not Result then
        PolDestroy(pol)
      else
        // �������� �������, �������� �������� ������
        if pol^.Next <> nil then
          DelNode(pol)
    end;
end;

// ������� �������������� ���������� pol � ������
// ���������� ������ � �����������
function PolToStr(pol: TPolynomial): string;
var
  p: Integer;
begin
  Result := '';

  // ����������� ��������� � ������ ��� ��������������
  while pol^.next <> nil do
    begin
      Result := Result + FloatToStrF(pol^.Coef, ffGeneral, 3, 5) + 'x^' + IntToStr(pol^.Degree) + ' + ';
      pol := pol^.Next;
    end;
  Result := Result + FloatToStrF(pol^.Coef, ffGeneral, 3, 5) + 'x^' + IntToStr(pol^.Degree);

  // �������� ���������� ������ � ����������� � ���������� �������
  Result := StringReplace(Result, '+ -', '� ', [rfReplaceAll]);

  if AnsiEndsStr('x^0', Result) then
    Delete(Result, Length(Result) - 2, 3);

  p := LastDelimiter('^', Result);
  if (p <> 0) and (Result[p + 1] = '1') and ((p + 1 = Length(Result)) or (Result[p + 2] = ' ')) then
    Delete(Result, p, 2);

  Result := StringReplace(Result, ' 1x', ' x', [rfReplaceAll]);

  if AnsiStartsStr('1x', Result) then
    Delete(Result, 1, 1);
  if AnsiStartsStr('-1x', Result) then
    Delete(Result, 2, 1);
  if AnsiStartsStr('-', Result) then
    Result := StringReplace(Result, '-', '� ', []);
end;

// ������� ����������� ������ � ����������� polToCopy
// ���������� ��������� �� ��������� ������� ������ �� ������������� �����������
function PolCopy(polToCopy: TPolynomial): TPolynomial;
var
  t: TPtr;
begin
  t := PolInit(Result, polToCopy^.Coef, polToCopy^.Degree);
  polToCopy := polToCopy^.Next;
  while polToCopy <> nil do
    begin
      t := AddNode(t^.Next, polToCopy^.Coef, polToCopy^.Degree);
      polToCopy := polToCopy^.Next;
    end;
end;

// ��������������� ������� �������� ����������� p1 � p2, sign �������� �� ��������/���������
// ���������� ��������� �� ��������� ������� ������ � �������������� �����������
function PolSumHelp(p1, p2: TPolynomial; sign: Integer = 1): TPolynomial;
var
  t: TPtr;
  cf: Double;
begin
  t := PolInit(Result);

  // ���� �� ���������� ���� �� ���������, ������������ ����������� ��������
  while (p1 <> nil) and (p2 <> nil) do
    if p1^.Degree = p2^.Degree then
      begin
        cf := p1^.Coef + sign * p2^.Coef;
        if Abs(cf) > POL_UNIT_EPSILON then
          t := AddNode(t^.Next, cf, p1^.Degree);

        p1 := p1^.Next;
        p2 := p2^.Next;
      end
    else
      if p1^.Degree > p2^.Degree then
        begin
          t := AddNode(t^.Next, p1^.Coef, p1^.Degree);
          p1 := p1^.Next;
        end
      else
        begin
          t := AddNode(t^.Next, sign * p2^.Coef, p2^.Degree);
          p2 := p2^.Next;
        end;

  // ����� �������� ���� �� �����������, ���������� ������� �������
  while p1 <> nil do
    begin
      t := AddNode(t^.Next, p1^.Coef, p1^.Degree);
      p1 := p1^.Next;
    end;

  while p2 <> nil do
    begin
      t := AddNode(t^.Next, sign * p2^.Coef, p2^.Degree);
      p2 := p2^.Next;
    end;

  // �������� �������, �������� �������� ������
  if Result^.next <> nil then
    DelNode(Result);

end;

// ������� ��������� ���������� pol �� ����� number
// ���������� ��������� �� ��������� ������� ������ � �������������� �����������
function PolMultByNumber(pol: TPolynomial; number: Double): TPolynomial;
var
  t: TPtr;
begin
  if Abs(number) < POL_UNIT_EPSILON then
    PolInit(Result)
  else
    begin
      Result := PolCopy(pol);
      if Abs(Number - 1) > POL_UNIT_EPSILON then
        begin
          t := Result;
          while t <> nil do
            begin
              t^.Coef := t^.Coef * Number;
              t := t^.Next;
            end;
        end;
    end;
end;

// ������� �������� ��������� p1 � p2
// ���������� ��������� �� ��������� ������� ������ � �������������� �����������
function PolSum(p1, p2: TPolynomial): TPolynomial;
begin
  if Abs(p1^.Coef) < POL_UNIT_EPSILON then
    Result := p2
  else
    if Abs(p2^.Coef) < POL_UNIT_EPSILON then
      Result := p1
    else
      Result := PolSumHelp(p1, p2);
end;

// ������� ��������� �������� p2 �� �������� p1
// ���������� ��������� �� ��������� ������� ������ � �������������� �����������
function PolSub(p1, p2: TPolynomial): TPolynomial;
begin
  if Abs(p1^.Coef) < POL_UNIT_EPSILON then
    Result := PolMultByNumber(p2, -1)
  else
    if Abs(p2^.Coef) < POL_UNIT_EPSILON then
      Result := p1
    else
      Result := PolSumHelp(p1, p2, -1);
end;

// ������� ��������� ���������� pol �� �������� � ������������� cf � �������� dg
// ���������� ��������� �� ��������� ������� ������ � �������������� �����������
function PolMultByMonomial(pol: TPolynomial; cf: Double; dg: Integer): TPolynomial;
var
  t: TPtr;
begin
  Result := PolMultByNumber(pol, cf);

  if dg <> 0 then
    begin
      t := Result;
      while t <> nil do
        begin
          t^.Degree := t^.Degree + dg;
          t := t^.Next;
        end;
    end;
end;

// ������� ������������ ��������� p1 � p2
// ���������� ��������� �� ��������� ������� ������ � �������������� �����������
function PolMult(p1, p2: TPolynomial): TPolynomial;
begin
  Result := PolMultByMonomial(p1, p2^.Coef, p2^.Degree);

  p2 := p2^.Next;
  while p2 <> nil do
    begin
      Result := PolSum(Result, PolMultByMonomial(p1, p2^.Coef, p2^.Degree));
      p2 := p2^.Next;
    end;
end;

// ������� ������� ���������� pol �� ����� number
function PolDivByNumber(pol: TPolynomial; number: Double): TPolynomial;
var
  t: TPtr;
begin
  if Abs(number) < POL_UNIT_EPSILON then
    Result := nil
  else
    begin
      Result := PolCopy(pol);
      if Abs(Number - 1) > POL_UNIT_EPSILON then
        begin
          t := Result;
          while t <> nil do
            begin
              t^.Coef := t^.Coef / Number;
              t := t^.Next;
            end;
        end;
    end;
end;

// ������� ������� �������� p1 �� ������� p2 � �������� remainder
// ���������� ��������� �� ��������� ������� ������ � �������������� �����������
function PolDiv(p1, p2: TPolynomial; var remainder: TPolynomial): TPolynomial;
var
  numerator, t: TPtr;
  cf: Double;
  dg: Integer;
begin
  // �������� ������� �� ����
  if Abs(p2^.Coef) < POL_UNIT_EPSILON then
    begin
      remainder := nil;
      Result := nil;
    end
  else
    // �������� ������� ����
    if Abs(p1^.Coef) < POL_UNIT_EPSILON then
      begin
        remainder := nil;
        PolInit(Result);
      end
    else
      // �������� ������� ���������� � ������� �������� �� ��������� � �������
      if p1^.Degree < p2^.Degree then
        begin
          remainder := PolCopy(p1);
          PolInit(Result);
        end
      else
        // �������� ������� ���������� �� �����
        if p2.Degree = 0 then
          begin
            remainder := nil;
            Result := PolDivByNumber(p1, p2.Coef)
          end
        else
          begin
            numerator := PolCopy(p1);
            t := PolInit(Result);

            // ���� �� ������� 0 � ������� ���� ���� �� ������� � ������� ��������� �� �������� �������, ��� � ��������
            while (Abs(numerator^.Coef) > POL_UNIT_EPSILON) and (numerator^.Degree >= p2^.Degree) do
              begin
                // ����� ��������� ���� �������� �� ��������� ���� ��������
                cf := numerator^.Coef / p2^.Coef;
                dg := numerator^.Degree - p2^.Degree;

                // ��������� ������������ �������� � ��������������� ����������
                t := AddNode(t^.next, cf, dg);

                // �������� �� �������� ��������, ���������� �� ��������� ��������
                numerator := PolSub(numerator, PolMultByMonomial(p2, cf, dg));
              end;

            // �������� �������, �������� �������� ������
            DelNode(Result);
            remainder := numerator;
          end;
end;

end.
