unit PolUnit;

interface

const
  // Точность сравнения с нулем чисел с плавающей запятой
  POL_UNIT_EPSILON = 0.0001;

type
  // Линейный односвязный список, в каждом элементе списка 3 поля:
  // Coef   - Коэффициент при члене степени Degree
  // Degree - Степень члена
  // Next   - Указатель на следующий элемент списка
  TPtr = ^TList;
  TList = record
    Coef: Double;
    Degree: Integer;
    Next: TPtr;
  end;

  // Указатель на заглавный элемент списка с многочленом
  TPolynomial = TPtr;

// Функция попытки преобразования строки stringWithPol в многочлен pol
// Возвращает True, если преобразование удалось
// Возвращает False в обратном случае
function TryStrToPol(stringWithPol: string; var pol: TPolynomial): Boolean;

// Функция преобразования многочлена pol в строку
// Возвращает строку с многочленом
function PolToStr(pol: TPolynomial): string;

// Функция копирования списка с многочленом polToCopy
// Возвращает указатель на заглавный элемент списка со скопированным многочленом
function PolCopy(polToCopy: TPolynomial): TPolynomial;

// Процедура полного удаления списка с многочленом polToDestroy
procedure PolDestroy(var polToDestroy: TPolynomial);

// Все последующие функции возвращают указатель на заглавный элемент списка с результирующим многочленом

// Функция умножения многочлена pol на число number
function PolMultByNumber(pol: TPolynomial; number: Double): TPolynomial;

// Функция сложения полиномов p1 и p2
function PolSum(p1, p2: TPolynomial): TPolynomial;

// Функция вычитания полинома p2 из полинома p1
function PolSub(p1, p2: TPolynomial): TPolynomial;

// Функция произведения полиномов p1 и p2
function PolMult(p1, p2: TPolynomial): TPolynomial;

// Функция деления многочлена pol на число number
function PolDivByNumber(pol: TPolynomial; number: Double): TPolynomial;

// Функция деления полинома p1 на полином p2 с остатком remainder
function PolDiv(p1, p2: TPolynomial; var remainder: TPolynomial): TPolynomial;

implementation

uses
  SysUtils, StrUtils;

// Функция вставки элемента с заданным коэффициентом cf и степенью dg в список
// p - указатель на следующий элемент списка после вставляемого
// Возвращает указатель на вставленный элемент списка
function AddNode(var p: TPtr; cf: Double; dg: Integer): TPtr;
begin
  New(Result);
  Result^.Coef := cf;
  Result^.Degree := dg;
  Result^.Next := p;
  p := Result;
end;

// Процедура удаления элемента из списка
// p - указатель на удаляемый элемент списка
// Перенаправляет указатель p на следующий за удаляемым элемент списка
procedure DelNode(var p: TPtr);
var
  del: TPtr;
begin
  del := p;
  p := p^.Next;
  Dispose(del);
end;

// Процедура очистки списка polToClear
// (удаление всех элементов, кроме заглавного)
procedure PolClear(var polToClear: TPolynomial);
begin
  while polToClear^.Next <> nil do
    DelNode(polToClear^.Next);
end;

// Процедура полного удаления списка polToDestroy из памяти
procedure PolDestroy(var polToDestroy: TPolynomial);
begin
  PolClear(polToDestroy);
  Dispose(polToDestroy);
  polToDestroy := nil;
end;

// Функция инициализации списка polToInit
// Возвращает указатель на заглавный элемент списка с коэффициентом cf и степенью dg
function PolInit(var polToInit: TPolynomial; cf: Double = 0; dg: Integer = 0): TPolynomial;
begin
  New(polToInit);
  polToInit^.Coef := cf;
  polToInit^.Degree := dg;
  polToInit^.Next := nil;
  Result := polToInit;
end;

// Функция преобразования строки stringWithPol в многочлен pol
// Возвращает True, если преобразование удалось
// Возвращает False в обратном случае
function TryStrToPol(stringWithPol: string; var pol: TPolynomial): Boolean;
var
  spaceIndex, dg, i: Integer;
  cf: Double;
  t: TPtr;
begin
  Result := True;
  stringWithPol := Trim(stringWithPol);

  // Если передана пустая строка, возвращаем нулевой многочлен
  if Length(stringWithPol) = 0 then
    PolInit(pol)
  else
    begin
      dg := -1;
      i := 1;

      // Считаем степень многочлена dg по количеству символов, разделенных пробелами
      while i <> 0 do
        if stringWithPol[i] = ' ' then
          i := i + 1
        else
          begin
            Inc(dg);
            i := PosEx(' ', stringWithPol, i);
          end;

      t := PolInit(pol);

      // Пока нет ошибок в вводе и не считали все коэффициенты
      while Result and (Length(stringWithPol) <> 0) do
        begin
          // Находим индекс в строке,
          // соответствующий первому символу после очередного коэффициента
          spaceIndex := Pos(' ', stringWithPol);
          if spaceIndex = 0 then
            spaceIndex := Length(stringWithPol);

          // Пытаемся преобразовать очередной коэффициент к числу с плавающей точкой
          Result := TryStrToFloat(Copy(stringWithPol, 1, spaceIndex), cf);

          if Result then
            begin
              // Если попытка успешная - проверяем на равенство считанного числа нулю
              if Abs(cf) > POL_UNIT_EPSILON then
                t := AddNode(t^.next, cf, dg);

              // Уменьшаем степень члена для следующего коэффициента
              dg := dg - 1;

              // Удаляем считанный коэффициент из строки
              Delete(stringWithPol, 1, spaceIndex);
              stringWithPol := Trim(stringWithPol);
            end;
        end;

      if not Result then
        PolDestroy(pol)
      else
        // Удаление первого, нулевого элемента списка
        if pol^.Next <> nil then
          DelNode(pol)
    end;
end;

// Функция преобразования многочлена pol в строку
// Возвращает строку с многочленом
function PolToStr(pol: TPolynomial): string;
var
  p: Integer;
begin
  Result := '';

  // Преобразуем многочлен в строку без форматирования
  while pol^.next <> nil do
    begin
      Result := Result + FloatToStrF(pol^.Coef, ffGeneral, 3, 5) + 'x^' + IntToStr(pol^.Degree) + ' + ';
      pol := pol^.Next;
    end;
  Result := Result + FloatToStrF(pol^.Coef, ffGeneral, 3, 5) + 'x^' + IntToStr(pol^.Degree);

  // Приводим полученную строку с многочленом к привычному формату
  Result := StringReplace(Result, '+ -', '– ', [rfReplaceAll]);

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
    Result := StringReplace(Result, '-', '– ', []);
end;

// Функция копирования списка с многочленом polToCopy
// Возвращает указатель на заглавный элемент списка со скопированным многочленом
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

// Вспомогательная функция сложения многочленов p1 и p2, sign отвечает за сложение/вычитание
// Возвращает указатель на заглавный элемент списка с результирующим многочленом
function PolSumHelp(p1, p2: TPolynomial; sign: Integer = 1): TPolynomial;
var
  t: TPtr;
  cf: Double;
begin
  t := PolInit(Result);

  // Пока не закончился один из полиномов, осуществляем складывание почленно
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

  // Когда кончился один из многочленов, дописываем остаток другого
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

  // Удаление первого, нулевого элемента списка
  if Result^.next <> nil then
    DelNode(Result);

end;

// Функция умножения многочлена pol на число number
// Возвращает указатель на заглавный элемент списка с результирующим многочленом
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

// Функция сложения полиномов p1 и p2
// Возвращает указатель на заглавный элемент списка с результирующим многочленом
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

// Функция вычитания полинома p2 из полинома p1
// Возвращает указатель на заглавный элемент списка с результирующим многочленом
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

// Функция умножения многочлена pol на одночлен с коэффициентом cf и степенью dg
// Возвращает указатель на заглавный элемент списка с результирующим многочленом
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

// Функция произведения полиномов p1 и p2
// Возвращает указатель на заглавный элемент списка с результирующим многочленом
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

// Функция деления многочлена pol на число number
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

// Функция деления полинома p1 на полином p2 с остатком remainder
// Возвращает указатель на заглавный элемент списка с результирующим многочленом
function PolDiv(p1, p2: TPolynomial; var remainder: TPolynomial): TPolynomial;
var
  numerator, t: TPtr;
  cf: Double;
  dg: Integer;
begin
  // Проверка деления на ноль
  if Abs(p2^.Coef) < POL_UNIT_EPSILON then
    begin
      remainder := nil;
      Result := nil;
    end
  else
    // Проверка деления нуля
    if Abs(p1^.Coef) < POL_UNIT_EPSILON then
      begin
        remainder := nil;
        PolInit(Result);
      end
    else
      // Проверка деления многочлена с меньшей степенью на многочлен с большей
      if p1^.Degree < p2^.Degree then
        begin
          remainder := PolCopy(p1);
          PolInit(Result);
        end
      else
        // Проверка деления многочлена на число
        if p2.Degree = 0 then
          begin
            remainder := nil;
            Result := PolDivByNumber(p1, p2.Coef)
          end
        else
          begin
            numerator := PolCopy(p1);
            t := PolInit(Result);

            // Пока не получим 0 в остатке либо пока не получим в остатке многочлен со степенью меньшей, чем у делителя
            while (Abs(numerator^.Coef) > POL_UNIT_EPSILON) and (numerator^.Degree >= p2^.Degree) do
              begin
                // Делим заглавный член делимого на заглавный член делителя
                cf := numerator^.Coef / p2^.Coef;
                dg := numerator^.Degree - p2^.Degree;

                // Добавляем получившийся одночлен к результирующему многочлену
                t := AddNode(t^.next, cf, dg);

                // Вычитаем из делимого делитель, умноженный на найденный одночлен
                numerator := PolSub(numerator, PolMultByMonomial(p2, cf, dg));
              end;

            // Удаление первого, нулевого элемента списка
            DelNode(Result);
            remainder := numerator;
          end;
end;

end.
