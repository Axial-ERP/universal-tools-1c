
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КопироватьДанныеФормы(Параметры.Объект, Объект);
	
	Заголовок = Параметры.Заголовок;
	ИмяЗапроса = Параметры.ИмяЗапроса;
	ПараметрыЗапроса = Параметры.ПараметрыЗапроса;
	ПолученныйТекстЗапроса = Параметры.ТекстЗапроса;
	ПолученныйТекстЗапроса = СтрЗаменить(ПолученныйТекстЗапроса, Символ(34), Символ(34) + Символ(34));
	Параметры.Свойство("ТекстАлгоритма", УИ_ТекстАлгоритма);
	Параметры.Свойство("МетодИсполненияКода", УИ_МетодИсполненияКода);
	ТекстЗапроса.УстановитьТекст(ПолученныйТекстЗапроса);	
	УстановитьЗначенияПараметров = РеквизитФормыВЗначение("Объект").СохраняемыеСостояния_Получить("УстановитьЗначенияПараметров", Истина);
	
	СоздатьКодСПараметрами();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЛитералСсылки(НазваниеМенеджера, НазваниеВЗапросе, Значение)
	
	ИмяМетаданных = Значение.Метаданные().Имя;
	
	Если НазваниеМенеджера <> "Документы" И НазваниеМенеджера <> "БизнесПроцессы" И НазваниеМенеджера <> "Задачи"
		И НазваниеМенеджера <> "ПланыОбмена" Тогда
		
		зПредопределенные = Новый Запрос(СтрШаблон(
			"ВЫБРАТЬ
			|	Таблица.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
			|ИЗ
			|	%1.%2 КАК Таблица
			|ГДЕ
			|	Таблица.Ссылка = &Значение
			|	И Таблица.Предопределенный", НазваниеВЗапросе, ИмяМетаданных));
		зПредопределенные.УстановитьПараметр("Значение", Значение);
		
		рзПредопределенные = зПредопределенные.Выполнить();
		Если НЕ рзПредопределенные.Пустой() Тогда
			выбПредопределенные = рзПредопределенные.Выбрать();
			выбПредопределенные.Следующий();
			Возврат СтрШаблон("%1.%2.%3", НазваниеМенеджера, ИмяМетаданных, выбПредопределенные.ИмяПредопределенныхДанных); 
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрШаблон(
		"%1.%2.ПолучитьСсылку(Новый УникальныйИдентификатор(""%3""))",
		НазваниеМенеджера,
		ИмяМетаданных,
		Значение.УникальныйИдентификатор());
	
КонецФункции

&НаСервере
Процедура ПолучитьКодСпискаЗначений(Значение, ИмяПараметра, Литерал, Комментарий, КодСоздания)
	
	Комментарий = Неопределено;
	
	маСтрокиДобавления = Новый Массив;
	Для Каждого эсз Из Значение Цикл
		маСтрокиДобавления.Добавить(СтрШаблон("	%1.Добавить(%2);", ИмяПараметра, ПолучитьЛитералЗначения(эсз.Значение).Литерал));
	КонецЦикла;
	
	КодСоздания = СтрШаблон(
		"	%1 = Новый СписокЗначений;
		|%2",
		ИмяПараметра,
		СтрСоединить(маСтрокиДобавления, "
		|"));
	
	Литерал = ИмяПараметра;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьКодМассива(Значение, ИмяПараметра, Литерал, Комментарий = Неопределено, КодСоздания = Неопределено)
	
	Комментарий = Неопределено;
	
	маСтрокиДобавления = Новый Массив;
	Для Каждого ЗначениеМассива Из Значение Цикл
		маСтрокиДобавления.Добавить(СтрШаблон("	%1.Добавить(%2);", ИмяПараметра, ПолучитьЛитералЗначения(ЗначениеМассива).Литерал));
	КонецЦикла;
	
	КодСоздания = СтрШаблон(
		"	%1 = Новый Массив;
		|%2",
		ИмяПараметра,
		СтрСоединить(маСтрокиДобавления, "
		|"));
	
	Литерал = ИмяПараметра;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЛитералЧастиДаты(ЗначениеЧастиДаты)
	Если ЗначениеЧастиДаты = ЧастиДаты.Время Тогда
		Возврат "ЧастиДаты.Время";
	ИначеЕсли ЗначениеЧастиДаты = ЧастиДаты.Дата Тогда
		Возврат "ЧастиДаты.Дата";
	ИначеЕсли ЗначениеЧастиДаты = ЧастиДаты.ДатаВремя Тогда
		Возврат "ЧастиДаты.ДатаВремя";
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЛитералДопустимаяДлина(ЗначениеДопустимаяДлина)
	Если ЗначениеДопустимаяДлина = ДопустимаяДлина.Переменная Тогда
		Возврат "ДопустимаяДлина.Переменная";
	ИначеЕсли ЗначениеДопустимаяДлина = ДопустимаяДлина.Фиксированная Тогда
		Возврат "ДопустимаяДлина.Фиксированная";
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЛитералДопустимыйЗнак(ЗначениеДопустимыйЗнак)
	Если ЗначениеДопустимыйЗнак = ДопустимыйЗнак.Любой Тогда
		Возврат "ДопустимыйЗнак.Любой";
	ИначеЕсли ЗначениеДопустимыйЗнак = ДопустимыйЗнак.Неотрицательный Тогда
		Возврат "ДопустимыйЗнак.Неотрицательный";
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ПолучитьЛитералОписанияТипов(ОписаниеТиповЗначения, Литерал, КодСоздания)
	
	Литерал = Неопределено;
	КодСоздания = Неопределено;
	
	маТипы = ОписаниеТиповЗначения.Типы();
	Если маТипы.Количество() = 0 Тогда
		Литерал = "Новый ОписаниеТипов()";
		Возврат;
	КонецЕсли;
	
	Обработка = РеквизитФормыВЗначение("Объект");
	
	Если ОписаниеТиповЗначения.СодержитТип(Тип("Дата")) Тогда
		КодКвалификаторы = СтрШаблон(
			", Новый КвалификаторыДаты(%1)",
			ПолучитьЛитералЧастиДаты(ОписаниеТиповЗначения.КвалификаторыДаты.ЧастиДаты));
	Иначе
		КодКвалификаторы = "";
	КонецЕсли;
		
	Если ОписаниеТиповЗначения.СодержитТип(Тип("Строка")) Тогда
		КодКвалификаторы = СтрШаблон(
			", Новый КвалификаторыСтроки(%1, %2)%3",
			ОписаниеТиповЗначения.КвалификаторыСтроки.Длина,
			ПолучитьЛитералДопустимаяДлина(ОписаниеТиповЗначения.КвалификаторыСтроки.ДопустимаяДлина),
			КодКвалификаторы);
	Иначе
		Если ЗначениеЗаполнено(КодКвалификаторы) Тогда
			КодКвалификаторы = ", " + КодКвалификаторы;
		КонецЕсли;
	КонецЕсли;
		
	Если ОписаниеТиповЗначения.СодержитТип(Тип("Число")) Тогда
		КодКвалификаторы = СтрШаблон(
			", Новый КвалификаторыЧисла(%1, %2, %3)%4",
			ОписаниеТиповЗначения.КвалификаторыЧисла.Разрядность,
			ОписаниеТиповЗначения.КвалификаторыЧисла.РазрядностьДробнойЧасти,
			ПолучитьЛитералДопустимыйЗнак(ОписаниеТиповЗначения.КвалификаторыЧисла.ДопустимыйЗнак),
			КодКвалификаторы);
	Иначе
		Если ЗначениеЗаполнено(КодКвалификаторы) Тогда
			КодКвалификаторы = ", " + КодКвалификаторы;
		КонецЕсли;
	КонецЕсли;
	
	Если маТипы.Количество() = 1 Тогда
		Литерал = СтрШаблон(
			"Новый ОписаниеТипов(""%1""%2)",
			Обработка.ПолучитьИмяТипа(маТипы[0]),
			КодКвалификаторы);
		Возврат;
	КонецЕсли;

	маСозданиеТипа = Новый Массив;
	маСозданиеТипа.Добавить("	ТипыКолонки = Новый Массив;");
	Для Каждого Т Из маТипы Цикл
		маСозданиеТипа.Добавить(СтрШаблон("	ТипыКолонки.Добавить(Тип(""%1""));", Обработка.ПолучитьИмяТипа(Т)));
	КонецЦикла;
	
	Литерал = СтрШаблон(
		"Новый ОписаниеТипов(ТипыКолонки%1)",
		КодКвалификаторы);
		
	КодСоздания = СтрСоединить(маСозданиеТипа, "
	|");
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьКодСозданияКолонки(маКодСоздания, ИмяПараметра, Колонка)
	Перем ЛитералТипа, КодСоздания;
	
	ПолучитьЛитералОписанияТипов(Колонка.ТипЗначения, ЛитералТипа, КодСоздания);
	
	Если ЗначениеЗаполнено(КодСоздания) Тогда
		маКодСоздания.Добавить(КодСоздания);
	КонецЕсли;
	
	маКодСоздания.Добавить(СтрШаблон("	%1.Колонки.Добавить(""%2"", %3);", ИмяПараметра, Колонка.Имя, ЛитералТипа));
		
КонецПроцедуры

&НаСервере
Процедура ПолучитьКодТаблицыЗначений(Значение, ИмяПараметра, Литерал, Комментарий, КодСоздания)
	
	Комментарий = Неопределено;
	
	маСтрокиДобавления = Новый Массив;
	Для Каждого ЗначениеМассива Из Значение Цикл
		маСтрокиДобавления.Добавить(СтрШаблон("	%1.Добавить(%2);", ИмяПараметра, ПолучитьЛитералЗначения(ЗначениеМассива).Литерал));
	КонецЦикла;
	
	маКодСоздания = Новый Массив;
	маКодСоздания.Добавить(СтрШаблон("	%1 = Новый ТаблицаЗначений;", ИмяПараметра));
	Для Каждого Колонка Из Значение.Колонки Цикл
		ДобавитьКодСозданияКолонки(маКодСоздания, ИмяПараметра, Колонка);
	КонецЦикла;
	
	Для Каждого Строка Из Значение Цикл
		
		маКодСоздания.Добавить(СтрШаблон("	СтрокаТаблицы = %1.Добавить();", ИмяПараметра));
		
		Для Каждого Колонка Из Значение.Колонки Цикл
			
			стЛитерал = ПолучитьЛитералЗначения(Строка[Колонка.Имя]);
			КодПрисвоения = СтрШаблон("	СтрокаТаблицы.%1 = %2;", Колонка.Имя, стЛитерал.Литерал);
			
			Если ЗначениеЗаполнено(стЛитерал.Комментарий) Тогда
				КодПрисвоения = СтрШаблон("%1 // %2", КодПрисвоения, стЛитерал.Комментарий);
			КонецЕсли;
			
			маКодСоздания.Добавить(КодПрисвоения);
			
		КонецЦикла;
		
	КонецЦикла;
	
	КодСоздания = СтрСоединить(маКодСоздания, "
	|");
	
	Литерал = ИмяПараметра;
	
КонецПроцедуры
		
&НаСервере
Функция ПолучитьЛитералЗначения(Значение, ИмяПараметра = Неопределено)
	
	Литерал = Неопределено;
	Комментарий = Неопределено;
	КодСоздания = Неопределено;
	
	ТипЗначения = ТипЗнч(Значение);
	Если ТипЗначения = Тип("Строка") Тогда
		Литерал = СтрШаблон("""%1""", Значение);
	ИначеЕсли ТипЗначения = Тип("Число") Тогда
		Литерал = Формат(Значение, "ЧГ=");
	ИначеЕсли ТипЗначения = Тип("Дата") Тогда
		
		Г = Год(Значение);
		М = Месяц(Значение);
		Д = День(Значение);
		Ч = Час(Значение);
		Мин = Минута(Значение);
		Сек = Секунда(Значение);
		
		КодЗначения = Формат(Г, "ЧЦ=4; ЧВН=; ЧГ=") + Формат(М, "ЧЦ=2; ЧВН=; ЧГ=") + Формат(Д, "ЧЦ=2; ЧВН=; ЧГ=");
		Если Ч <> 0 ИЛИ Мин <> 0 И Сек <> 0 Тогда
			КодЗначения = КодЗначения + Формат(Ч, "ЧЦ=2; ЧВН=; ЧГ=") + Формат(Мин, "ЧЦ=2; ЧВН=; ЧГ=") + Формат(Сек, "ЧЦ=2; ЧВН=; ЧГ=");
		КонецЕсли;
		
		Литерал = СтрШаблон("'%1'", КодЗначения);
		
	ИначеЕсли ТипЗначения = Тип("Null") Тогда
		Литерал = "Null";
	ИначеЕсли ТипЗначения = Тип("Неопределено") Тогда
		Литерал = "Неопределено";
	ИначеЕсли ТипЗначения = Тип("УникальныйИдентификатор") Тогда
		Литерал = СтрШаблон("Новый УникальныйИдентификатор(""%1"")", Строка(Значение));
	ИначеЕсли ТипЗначения = Тип("Булево") Тогда
		Литерал = ?(Значение, "Истина", "Ложь");
	ИначеЕсли ТипЗначения = Тип("Граница") Тогда
		стЛитералЗначенияГраницы = ПолучитьЛитералЗначения(Значение.Значение);
		Литерал = СтрШаблон("Новый Граница(%1, %2)",
			стЛитералЗначенияГраницы.Литерал,
			СтрШаблон("ВидГраницы.%1", Значение.ВидГраницы));
	ИначеЕсли ТипЗначения = Тип("МоментВремени") Тогда
		стЛитералДаты = ПолучитьЛитералЗначения(Значение.Дата);
		стЛитералСсылки = ПолучитьЛитералЗначения(Значение.Ссылка);
		Литерал = СтрШаблон("Новый МоментВремени(%1, %2)",
			стЛитералДаты.Литерал, стЛитералСсылки.Литерал);
			Комментарий = стЛитералСсылки.Комментарий;
	ИначеЕсли ТипЗначения = Тип("ВидДвиженияНакопления") Тогда
		Литерал = СтрШаблон("ВидДвиженияНакопления.%1", Значение);
	ИначеЕсли ТипЗначения = Тип("ВидДвиженияБухгалтерии") Тогда
		Литерал = СтрШаблон("ВидДвиженияБухгалтерии.%1", Значение);
	ИначеЕсли ТипЗначения = Тип("ВидСчета") Тогда
		Литерал = СтрШаблон("ВидСчета.%1", Значение);
	ИначеЕсли ТипЗначения = Тип("Тип") Тогда
		Литерал = СтрШаблон("Тип(""%1"")", РеквизитФормыВЗначение("Объект").ПолучитьИмяТипа(Значение));
	ИначеЕсли Справочники.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Литерал = ПолучитьЛитералСсылки("Справочники", "Справочник", Значение);
		Комментарий = СтрШаблон("%1 %2", Значение.Код, Значение.Наименование);
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Литерал = ПолучитьЛитералСсылки("Документы", "Документ", Значение);
		Комментарий = Строка(Значение);
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		МетаданныеПеречисления = Значение.Метаданные();
		Менеджер = Перечисления[МетаданныеПеречисления.Имя];
		ИдентификаторПеречисления = МетаданныеПеречисления.ЗначенияПеречисления.Получить(Менеджер.Индекс(Значение)).Имя;
		Литерал = СтрШаблон("Перечисления.%1.%2", Значение.Метаданные().Имя, ИдентификаторПеречисления);
	ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Литерал = ПолучитьЛитералСсылки("ПланыВидовХарактеристик", "ПланВидовХарактеристик", Значение);
		Комментарий = СтрШаблон("%1 %2", Значение.Код, Значение.Наименование);
	ИначеЕсли ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Литерал = ПолучитьЛитералСсылки("ПланыВидовРасчета", "ПланВидовРасчета", Значение);
		Комментарий = СтрШаблон("%1 %2", Значение.Код, Значение.Наименование);
	ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Литерал = ПолучитьЛитералСсылки("ПланыСчетов", "ПланСчетов", Значение);
		Комментарий = Значение.Код;
	ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Литерал = ПолучитьЛитералСсылки("БизнесПроцессы", "БизнесПроцесс", Значение);
		Комментарий = Строка(Значение);
	ИначеЕсли Задачи.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Литерал = ПолучитьЛитералСсылки("Задачи", "Задача", Значение);
		Комментарий = Строка(Значение);
	ИначеЕсли ПланыОбмена.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Литерал = ПолучитьЛитералСсылки("ПланыОбмена", "ПланОбмена", Значение);
		Комментарий = СтрШаблон("%1 %2", Значение.Код, Значение.Наименование);
	ИначеЕсли ТипЗначения = Тип("СписокЗначений") Тогда
		ПолучитьКодСпискаЗначений(Значение, ИмяПараметра, Литерал, Комментарий, КодСоздания);
	ИначеЕсли ТипЗначения = Тип("Массив") Тогда
		ПолучитьКодМассива(Значение, ИмяПараметра, Литерал, Комментарий, КодСоздания);
	ИначеЕсли ТипЗначения = Тип("ТаблицаЗначений") Тогда
		ПолучитьКодТаблицыЗначений(Значение, ИмяПараметра, Литерал, Комментарий, КодСоздания);
	КонецЕсли;
	
	Если Литерал = Неопределено Тогда
		Возврат Новый Структура("Литерал, Комментарий, КодСоздания", "???");
	КонецЕсли;
	
	Возврат Новый Структура("Литерал, Комментарий, КодСоздания", Литерал, Комментарий, КодСоздания);
	
КонецФункции

&НаСервере
Процедура СоздатьКодСПараметрами()
	
	Текст = Новый ТекстовыйДокумент;
	Текст.ДобавитьСтроку(СтрШаблон("%1 = Новый Запрос;", ИмяЗапроса));
	Текст.ДобавитьСтроку(СтрШаблон("%1.Текст = """, ИмяЗапроса));
	
	Для й = 1 По ТекстЗапроса.КоличествоСтрок() Цикл
		Строка = ТекстЗапроса.ПолучитьСтроку(й);
		Текст.ДобавитьСтроку(СтрШаблон("|%1", Строка));
	КонецЦикла;
	
	Текст.ЗаменитьСтроку(Текст.КоличествоСтрок(), Текст.ПолучитьСтроку(Текст.КоличествоСтрок()) + """;
	|");
	
	тзПараметрыЗапроса = РеквизитФормыВЗначение("Объект").СтрокаВЗначение(ПараметрыЗапроса);
	
	Для Каждого СтрокаПараметра Из тзПараметрыЗапроса Цикл
		
		ИмяПараметра = СтрокаПараметра.Имя;
		Значение = СтрокаПараметра.Значение;
		
		Если УстановитьЗначенияПараметров Тогда
			
			стЛитерал = ПолучитьЛитералЗначения(Значение, ИмяПараметра);
			
			Если ЗначениеЗаполнено(стЛитерал.КодСоздания) Тогда
				Если ЗначениеЗаполнено(Текст.ПолучитьСтроку(Текст.КоличествоСтрок())) Тогда
					Текст.ДобавитьСтроку("");
				КонецЕсли;
				Текст.ДобавитьСтроку(стЛитерал.КодСоздания);
			КонецЕсли;
			
			КодУстановкиПараметра = СтрШаблон("%1.УстановитьПараметр(""%2"", %3);", ИмяЗапроса, ИмяПараметра, стЛитерал.Литерал);
			
			Если ЗначениеЗаполнено(стЛитерал.Комментарий) Тогда
				КодУстановкиПараметра = СтрШаблон("%1 //%2", КодУстановкиПараметра, стЛитерал.Комментарий);
			КонецЕсли;
			
			Текст.ДобавитьСтроку(КодУстановкиПараметра);
			
			Если ЗначениеЗаполнено(стЛитерал.КодСоздания) Тогда
				Текст.ДобавитьСтроку("");
			КонецЕсли;
			
		Иначе
			Текст.ДобавитьСтроку(СтрШаблон("%1.УстановитьПараметр(""%2"", );", ИмяЗапроса, ИмяПараметра));
		КонецЕсли;
		
	КонецЦикла;
	
	Текст.ДобавитьСтроку("");
	Текст.ДобавитьСтроку(СтрШаблон("РезультатЗапроса = %1.Выполнить();", ИмяЗапроса));
	Текст.ДобавитьСтроку("Выборка = РезультатЗапроса.Выбрать();");
	Если ЗначениеЗаполнено(УИ_ТекстАлгоритма) Тогда
		Если УИ_МетодИсполненияКода = 0 Тогда
			Для Счетчик = 1 По СтрЧислоСтрок(УИ_ТекстАлгоритма) Цикл
				Текст.ДобавитьСтроку("" + СтрПолучитьСтроку(УИ_ТекстАлгоритма, Счетчик));
			КонецЦикла;
		Иначе
			Текст.ДобавитьСтроку("Пока Выборка.Следующий() Цикл");
			Для Счетчик = 1 По СтрЧислоСтрок(УИ_ТекстАлгоритма) Цикл
				Текст.ДобавитьСтроку("	" + СтрПолучитьСтроку(УИ_ТекстАлгоритма, Счетчик));
			КонецЦикла;
			Текст.ДобавитьСтроку("КонецЦикла;"); 
		КонецЕсли;
	Иначе
		Текст.ДобавитьСтроку("Пока Выборка.Следующий() Цикл");
		Текст.ДобавитьСтроку("");
		Текст.ДобавитьСтроку("КонецЦикла;");
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	СоздатьКодСПараметрами();
КонецПроцедуры

&НаКлиенте
Процедура Команда_Обновить(Команда)
	ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ВладелецФормы.СохраняемыеСостояния_Сохранить("УстановитьЗначенияПараметров", УстановитьЗначенияПараметров);
КонецПроцедуры

