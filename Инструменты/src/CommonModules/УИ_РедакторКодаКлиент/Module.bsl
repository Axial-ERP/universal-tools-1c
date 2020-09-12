Функция ТекстHTMLРедактораКода(Язык = "bsl") Экспорт
	КаталогСохраненияБибилиотеки=КаталогСохраненияРедактора();

	ТекЯзык=НРег(Язык);
	Если ТекЯзык = "bsl" Тогда
		ТекЯзык="_1c";
	КонецЕсли;
	ТекстHTML= "<!DOCTYPE html>
			   |<html lang=""ru"">
			   |<head>
			   |<title>ACE in Action</title>
			   |<style type=""text/css"" media=""screen"">
			   |    #editor { 
			   |        position: absolute;
			   |        top: 0;
			   |        right: 0;
			   |        bottom: 0;
			   |        left: 0;
			   |    }
			   |</style>
			   |</head>
			   |<body>
			   |
			   |<div id=""editor""></div>
			   |    
			   |<script src="""+КаталогСохраненияБибилиотеки+"/ace/ace.js"" type=""text/javascript"" charset=""utf-8""></script>
			   |<script src="""+КаталогСохраненияБибилиотеки+"/ace/ext-language_tools.js"" type=""text/javascript"" charset=""utf-8""></script>
			   |<script>
			   |    // trigger extension
			   |    ace.require(""ace/ext/language_tools"");
			   |    var editor = ace.edit(""editor"");
			   |    editor.session.setMode(""ace/mode/" + ТекЯзык + """);
																	|    editor.setTheme(""ace/theme/ones"");
																	|    // enable autocompletion and snippets
																	|    editor.setOptions({
																	|        selectionStyle: 'line',
																	|        highlightSelectedWord: true,
																	|        showLineNumbers: true,
																	|        enableBasicAutocompletion: true,
																	|        enableSnippets: true,
																	|        enableLiveAutocompletion: true
																	|    });
																	|</script>
																	|
																	|</body>
																	|</html>";

	Возврат ТекстHTML;
КонецФункции

Функция КаталогСохраненияРедактора() Экспорт
	СтруктураФайловыхПеременных=УИ_ОбщегоНазначенияКлиент.СтруктураФайловыхПеременныхСеанса();
	Если Не СтруктураФайловыхПеременных.Свойство("КаталогВременныхФайлов") Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СтруктураФайловыхПеременных.КаталогВременныхФайлов + "tools_ui_1c" + ПолучитьРазделительПути()
		+ УИ_ОбщегоНазначенияКлиент.НомерСеанса() + ПолучитьРазделительПути()+"ace";
КонецФункции

Процедура СохранитьБиблиотекуРедактораНаДиск(АдресБиблиотеки) Экспорт
	КаталогСохраненияБибилиотеки=КаталогСохраненияРедактора();
	ФайлРедактора=Новый Файл(КаталогСохраненияБибилиотеки);
	Если ФайлРедактора.Существует() Тогда
		Возврат;
	КонецЕсли;

	СоздатьКаталог(КаталогСохраненияБибилиотеки);

	СоответствиеФайловБиблиотеки=ПолучитьИзВременногоХранилища(АдресБиблиотеки);
	Для Каждого КлючЗначение Из СоответствиеФайловБиблиотеки Цикл
		ИмяФайла=КаталогСохраненияБибилиотеки + ПолучитьРазделительПути() + КлючЗначение.Ключ;

		КлючЗначение.Значение.Записать(ИмяФайла);
	КонецЦикла;
КонецПроцедуры

Функция ТекстРедактораИзПоляРедактора(ЭлементПоляHTML) Экспорт
	ДокументHTML=ЭлементПоляHTML.Документ;
	Если ДокументHTML.parentWindow = Неопределено Тогда
		СтруктураДокументаДОМ = ДокументHTML.defaultView;
	Иначе
		СтруктураДокументаДОМ = ДокументHTML.parentWindow;
	КонецЕсли;
	Возврат СокрЛП(СтруктураДокументаДОМ.editor.getValue());
КонецФункции

Процедура УстановитьТекстРедактораЭлемента(ЭлементПоляРедактора, ТекстУстановки) Экспорт
	ДокументHTML=ЭлементПоляРедактора.Документ;
	Если ДокументHTML.parentWindow = Неопределено Тогда
		СтруктураДокументаДОМ = ДокументHTML.defaultView;
	Иначе
		СтруктураДокументаДОМ = ДокументHTML.parentWindow;
	КонецЕсли;
	СтруктураДокументаДОМ.editor.setValue(ТекстУстановки, -1);

КонецПроцедуры

Процедура УдалитьБибилиотекуРедактораКодаСДиска() Экспорт
	КаталогСохраненияБибилиотеки=КаталогСохраненияРедактора();
	
	Если Не ЗначениеЗаполнено(КаталогСохраненияБибилиотеки) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		УдалитьФайлы(КаталогСохраненияБибилиотеки);
	Исключение
		// TODO:
	КонецПопытки;
	
КонецПроцедуры