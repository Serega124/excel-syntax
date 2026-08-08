" Vim syntax file
" Language: Excel 365 Formulas
" Author: Gemini (Flash 3.6 Thinking)
" Description: Syntax highlighting for modern Excel formulas (including SPILL, Arrays, Structured Refs)

if exists("b:current_syntax")
  finish
endif

" Додаємо підтримку національних літер Unicode (у т.ч. українських) для меж слів
setlocal iskeyword+=@-@

" Excel не чутливий до регістру
syntax case ignore

" 1. Базові типи даних
" Рядки (враховує екранування подвійними лапками "")
syntax region excelString start=/"/ skip=/""/ end=/"/

" Числа (цілі, десяткові, експоненційний запис)
syntax match excelNumber /\<\d\+\(\.\d\+\)\?\([eE][+-]\?\d\+\)\?\>/

" Логічні значення
syntax keyword excelBoolean TRUE FALSE ІСТИНА ХИБНІСТЬ

" Помилки Excel
syntax match excelError /#N\/A\|#VALUE!\|#REF!\|#DIV\/0!\|#NUM!\|#NAME[?]\|#NULL!\|#SPILL!\|#CALC!/

" 2. Оператори та розділювачі
syntax match excelOperator /[-+*/^&=><]/

" Круглі дужки для групування та виклику функцій
syntax match excelParen /[()]/

" Розділювачі аргументів у функціях (; для укр. локалі, , для англ.)
syntax match excelArgSep /[;,]/

" 3. Функції (будь-яке слово перед відкритою дужкою, враховуючи І, Ї, Ґ, Є)
syntax match excelFunction /\<[A-Za-zА-Яа-яІіЇїҐґЄє_][A-Za-zА-Яа-яІіЇїҐґЄє0-9_.]*\ze(/

" 4. Посилання на комірки та діапазони
" Базові поодинокі комірки: A1, $A$1, C$4
syntax match excelCellRef /\$\?[A-Za-z]\+\$\?[0-9]\+\>/

" Стовпці: A:A, $A:$Z
syntax match excelColRef /\$\?[A-Za-z]\+:\$\?[A-Za-z]\+\>/

" Рядки: 1:10, $1:$10
syntax match excelRowRef /\$\?[0-9]\+:\$\?[0-9]\+\>/

" Діапазон комірок (A1:B10, $A$1:$Z$100) — оголошено нижче за excelCellRef для пріоритету
syntax match excelCellRangeRef /\$\?[A-Za-z]\+\$\?[0-9]\+:\$\?[A-Za-z]\+\$\?[0-9]\+\>/

" 5. Оператор розливу / динамічного масиву (A1#, B2:B10#)
syntax match excelSpillRef /\$\?[A-Za-z]\+\$\?[0-9]\+\(:\$\?[A-Za-z]\+\$\?[0-9]\+\)\?#/ contains=excelCellRef,excelCellRangeRef,excelSpillOp
syntax match excelSpillOp /#/ contained

" 6. Оператор неявного перетину (@)
syntax match excelImplicitIntersection /@/

" 7. Структуровані посилання на таблиці (Table1[@Column1])
syntax match excelTableName /\<[A-Za-zА-Яа-яІіЇїҐґЄє_][A-Za-zА-Яа-яІіЇїҐґЄє0-9_]*\ze\[/
syntax match excelTableSep /[;,:]/ contained
syntax match excelTableColumn /[A-Za-zА-Яа-яІіЇїҐґЄє0-9_][A-Za-zА-Яа-яІіЇїҐґЄє0-9_ ]*/ contained
syntax region excelStructuredRef matchgroup=Delimiter start=/\[/ end=/\]/ contains=excelTableKeyword,excelTableColumn,excelStructuredRef,excelImplicitIntersection,excelString,excelTableSep
syntax match excelTableKeyword /#Headers\|#Data\|#Totals\|#All\|#This Row/ contained
syntax match excelTableKeyword /#Заголовки\|#Дані\|#Підсумки\|#Усе\|#Цей рядок/ contained

" 8. SharePoint / OneDrive / Зовнішні та локальні посилання на аркуші
" Зовнішні посилання на файли/URL (містять URL, шлях або дужки '[File.xlsx]')
syntax region excelExternalLink matchgroup=String start=/'/ end=/'!/ contains=excelUrl
syntax match excelUrl /https\?:\/\/[^']\+/ contained

" Локальні посилання на аркуші без лапок (Sheet1!A1)
syntax match excelSheetRef /\<[A-Za-zА-Яа-яІіЇїҐґЄє0-9_]\+!\ze\$\?[A-Za-z0-9]/
" Локальні посилання на аркуші в лапках ('Аркуш 2'!A1) — виключають /, \, [ та ] для відрізнення від зовнішніх файлів
syntax match excelSheetRef /'[^'\/\\\[\]]\+'!\ze\$\?[A-Za-z0-9]/

" 9. Масиви-константи (={1\2; 3\4} укр. та ={1,2; 3,4} англ.)
syntax region excelArray matchgroup=Delimiter start=/{/ end=/}/ contains=excelNumber,excelString,excelBoolean,excelError,excelArraySep
syntax match excelArraySep /[\\;,]/ contained


" === Прив'язка до кольорових груп Neovim (адаптовано під onedark) ===
highlight default link excelString               String
highlight default link excelNumber               Number
highlight default link excelBoolean              Boolean
highlight default link excelError                ErrorMsg
highlight default link excelOperator             Operator
highlight default link excelParen                Delimiter
highlight default link excelArgSep               Delimiter

highlight default link excelFunction             Function

highlight default link excelCellRef              Identifier
highlight default link excelCellRangeRef         Identifier
highlight default link excelColRef               Identifier
highlight default link excelRowRef               Identifier

highlight default link excelSpillRef             Identifier
highlight default link excelSpillOp              Constant
highlight default link excelImplicitIntersection Constant

highlight default link excelTableName            Type
highlight default link excelStructuredRef        Normal
highlight default link excelTableKeyword         Keyword
highlight default link excelTableColumn          Identifier
highlight default link excelTableSep             Delimiter

highlight default link excelExternalLink         Underlined
highlight default link excelUrl                  QuickFixLine
highlight default link excelSheetRef             Type

highlight default link excelArray                Normal
highlight default link excelArraySep             Delimiter

let b:current_syntax = "excel"
