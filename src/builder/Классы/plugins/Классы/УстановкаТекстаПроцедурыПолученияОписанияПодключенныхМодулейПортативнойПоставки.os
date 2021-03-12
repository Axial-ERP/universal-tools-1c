// BSLLS-off

// Этот плагин выполняет переименование переменных если это возможно.
// При возникновении конфликтов регистрирует ошибку, которая указывает на конфликтную переменную.

// Пример ожидаемой структуры параметров (json):
// {"СтароеИмя1": "НовоеИмя1", "СтароеИмя2": "НовоеИмя2"}

Перем Токены;
Перем Типы;
Перем ТаблицаОшибок;
Перем ТаблицаЗамен;
Перем Директивы;

Перем Результат;

Перем МассивМетодов;
Перем ПрефиксПеременныхИПроцедур;
Перем УспешноСобранныеИнструменты;
Перем ОписаниеКонфигурации;

Процедура Открыть(Парсер, Параметры) Экспорт
	Типы = Парсер.Типы();
	ТаблицаОшибок = Парсер.ТаблицаОшибок();
	ТаблицаЗамен = Парсер.ТаблицаЗамен();
	Директивы = Парсер.Директивы();
	Токены = Парсер.Токены();
	
	Результат = Новый Массив;

	ПрефиксПеременныхИПроцедур=Параметры.ПрефиксПеременныхИПроцедур;
	УспешноСобранныеИнструменты=Параметры.УспешноСобранныеИнструменты;
	ОписаниеКонфигурации=Параметры.ОписаниеКонфигурации;
КонецПроцедуры // Открыть()

Функция Закрыть() Экспорт
	Возврат СтрСоединить(Результат);
КонецФункции // Закрыть()

Функция Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Подписки.Добавить("ПосетитьОбъявлениеМетода");
	Возврат Подписки;
КонецФункции // Подписки()

#Область РеализацияПодписок

Процедура ПосетитьОбъявлениеМетода(Описание) Экспорт
	Если НРег(Описание.Сигнатура.Имя)<>"описаниемодулейинструментовдляподключения" Тогда
		Возврат;
	КонецЕсли;

	ТекстПроцедуры="
	|	//МЕТОД СГЕНЕРИРОВАН АВТОМАТИЧЕСКИ ПРИ СБОРКЕ ПОРТАТИВНОЙ ПОСТАВКИ ИНСТРУМЕНТОВ
	|
	|Описания=Новый Структура;
	|
	|";
	
	Для Каждого ТекОбработка ИЗ ОписаниеКонфигурации.Обработки Цикл
		Если УспешноСобранныеИнструменты.Найти(ТекОбработка.Имя)=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ТекстПроцедуры=ТекстПроцедуры+"
		|ОписаниеИнструмента=НовыйОписаниеМодуля();
		|ОписаниеИнструмента.Имя="""+ТекОбработка.Имя+""";
		|Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
		|";

		Если ТекОбработка.МодульМенеджера Тогда
			ТекстПроцедуры=ТекстПроцедуры+"
			|ОписаниеИнструмента=НовыйОписаниеМодуля();
			|ОписаниеИнструмента.Имя="""+ТекОбработка.Имя+"_МодульМенеджера"";
			|ОписаниеИнструмента.Тип=""ОбщийМодуль"";
			|Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
			|";

		КонецЕсли;
	КонецЦикла;
	Для Каждого ТекОбработка ИЗ ОписаниеКонфигурации.Отчеты Цикл
		Если УспешноСобранныеИнструменты.Найти(ТекОбработка.Имя)=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ТекстПроцедуры=ТекстПроцедуры+"
		|ОписаниеИнструмента=НовыйОписаниеМодуля();
		|ОписаниеИнструмента.Имя="""+ТекОбработка.Имя+""";
		|ОписаниеИнструмента.Вид=""Отчет"";
		|Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
		|";

		Если ТекОбработка.МодульМенеджера Тогда
			ТекстПроцедуры=ТекстПроцедуры+"
			|ОписаниеИнструмента=НовыйОписаниеМодуля();
			|ОписаниеИнструмента.Имя="""+ТекОбработка.Имя+"_МодульМенеджера"";
			|ОписаниеИнструмента.Тип=""ОбщийМодуль"";
			|Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
			|";
	
		КонецЕсли;
	КонецЦикла;
	Для Каждого ТекМодуль Из ОписаниеКонфигурации.ОбщиеМодули Цикл
		ТекстПроцедуры=ТекстПроцедуры+"
		|ОписаниеИнструмента=НовыйОписаниеМодуля();
		|ОписаниеИнструмента.Имя="""+ТекМодуль.Имя+""";
		|ОписаниеИнструмента.Тип=""ОбщийМодуль"";
		|Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
		|";
	КонецЦикла;	
	Для Каждого ТекОбъект Из ОписаниеКонфигурации.ОбщиеКартинки Цикл
		ТекстПроцедуры=ТекстПроцедуры+"
		|ОписаниеИнструмента=НовыйОписаниеМодуля();
		|ОписаниеИнструмента.Имя="""+ТекОбъект.Имя+""";
		|ОписаниеИнструмента.Тип=""ОбщаяКартинка"";
		|ОписаниеИнструмента.ИмяФайла="""+ТекОбъект.Имя+ТекОбъект.РасширениеКартинки+""";
		|Описания.Вставить(ОписаниеИнструмента.Имя,ОписаниеИнструмента);
		|";
	КонецЦикла;
	
	ТекстПроцедуры=ТекстПроцедуры+"
	|
	|Возврат Описания;";
	

	Замена(ТекстПроцедуры, Описание.Операторы[0].Начало,Описание.Операторы[Описание.Операторы.Количество()-1].Конец);
КонецПроцедуры

#КонецОбласти // РеализацияПодписок

Процедура Ошибка(Текст, Начало, Конец = Неопределено, ЕстьЗамена = Ложь)
	Ошибка = ТаблицаОшибок.Добавить();
	Ошибка.Источник = "ЗаменаВызоваПроцедурВызовСервера";
	Ошибка.Текст = Текст;
	Ошибка.ПозицияНачала = Начало.Позиция;
	Ошибка.НомерСтрокиНачала = Начало.НомерСтроки;
	Ошибка.НомерКолонкиНачала = Начало.НомерКолонки;
	Если Конец = Неопределено Или Конец = Начало Тогда
		Ошибка.ПозицияКонца = Начало.Позиция + Начало.Длина;
		Ошибка.НомерСтрокиКонца = Начало.НомерСтроки;
		Ошибка.НомерКолонкиКонца = Начало.НомерКолонки + Начало.Длина;
	Иначе
		Ошибка.ПозицияКонца = Конец.Позиция + Конец.Длина;
		Ошибка.НомерСтрокиКонца = Конец.НомерСтроки;
		Ошибка.НомерКолонкиКонца = Конец.НомерКолонки + Конец.Длина;
	КонецЕсли;
	Ошибка.ЕстьЗамена = ЕстьЗамена;
КонецПроцедуры

Процедура Замена(Текст, Начало, Конец = Неопределено)
	НоваяЗамена = ТаблицаЗамен.Добавить();
	НоваяЗамена.Источник = "ЗаменаВызоваПроцедурВызовСервера";
	НоваяЗамена.Текст = Текст;
	НоваяЗамена.Позиция = Начало.Позиция;
	Если Конец = Неопределено Тогда
		НоваяЗамена.Длина = Начало.Длина;
	Иначе
		НоваяЗамена.Длина = Конец.Позиция + Конец.Длина - Начало.Позиция;
	КонецЕсли;
КонецПроцедуры

Процедура Вставка(Текст, Позиция)
	НоваяЗамена = ТаблицаЗамен.Добавить();
	НоваяЗамена.Источник = "ЗаменаВызоваПроцедурВызовСервера";
	НоваяЗамена.Текст = Текст;
	НоваяЗамена.Позиция = Позиция;
	НоваяЗамена.Длина = 0;
КонецПроцедуры