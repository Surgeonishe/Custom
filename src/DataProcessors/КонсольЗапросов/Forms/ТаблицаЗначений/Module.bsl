&НаКлиенте
Перем ИмяКолонкиПоУмолчанию;

#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Считывание параметров передачи.
	ПараметрыПередачи 	= ПолучитьИзВременногоХранилища(Параметры.АдресХранилища);
	Объект.Запросы.Загрузить(ПараметрыПередачи.Запросы);	
	Объект.Параметры.Загрузить(ПараметрыПередачи.Параметры);
	Объект.ИмяФайла 	= ПараметрыПередачи.ИмяФайла;
	ИдентификаторТекущегоЗапроса 	= ПараметрыПередачи.ИдентификаторТекущегоЗапроса;
	ИдентификаторТекущегоПараметра	= ПараметрыПередачи.ИдентификаторТекущегоПараметра;
	
	Объект.ДоступныеТипыДанных	= ОбъектОбработки().Метаданные().Реквизиты.ДоступныеТипыДанных.Тип;
	ОбъектОбработки().СформироватьСписокТипов(СписокТипов);
	
	ЗаполнитьТаблицыПриОткрытии();
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТаблицыЗначенийТипКолонкиПриИзменении(Элемент)
	// Определение наименования колонки.
	ПервыйТип = "";
	                                                                              
	ТекущаяКолонка 	= Элементы.НастройкиТаблицыЗначений.ТекущиеДанные;
	ТипКолонки      = ТекущаяКолонка.ТипКолонки;
	СтароеИмяКолонки= ТекущаяКолонка.НаименованиеКолонки;
	
	ДоступныеТипы 	= ТекущаяКолонка.ТипКолонки.Типы();
	Количество 		= ДоступныеТипы.Количество();
	Если Количество > 0 Тогда 
		Флаг = Ложь;
		Для каждого ЭлементСписка из СписокТипов Цикл 
			Если ЭлементСписка.Представление = Строка(ДоступныеТипы.Получить(0)) Тогда 
				Флаг = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		Если Флаг Тогда 
			ПервыйТип = Строка(ДоступныеТипы.Получить(0)); // для примитивных типов.
		Иначе
			ПервыйТип = Новый(ДоступныеТипы.Получить(0));
			ПервыйТип = ИмяТипаПоЗначению(ПервыйТип);
		КонецЕсли;	
	КонецЕсли;	
	
	ИдентификаторСтроки 	= ТекущаяКолонка.ПолучитьИдентификатор();
	Если Найти(ВРег(СтароеИмяКолонки), Врег(ИмяКолонкиПоУмолчанию)) <> 0 Тогда 
		НовоеИмяКолонки 	= СформироватьИмяКолонки(ПервыйТип, ИдентификаторСтроки);
	Иначе	
		НовоеИмяКолонки		= СтароеИмяКолонки;
	КонецЕсли;	
	ТекущаяКолонка.НаименованиеКолонки = НовоеИмяКолонки;
	
	ТекущаяСтрока = Элементы.НастройкиТаблицыЗначений.ТекущаяСтрока;
	
	ИнициализацияКолонкиВТЗКлиент(СтароеИмяКолонки, НовоеИмяКолонки, ТипКолонки);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТаблицыЗначенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	
	ИдентификаторСтроки 					= Новый УникальныйИдентификатор;
	ИмяКолонки 								= СформироватьИмяКолонки(ИмяКолонкиПоУмолчанию, ИдентификаторСтроки);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Строка"));
	ТипКолонки								= Новый ОписаниеТипов(МассивТипов);
	
    ЭлементНастройки 						= НастройкиТаблицыЗначений.Добавить();
	ЭлементНастройки.НаименованиеКолонки    = ИмяКолонки;
	ЭлементНастройки.ТипКолонки    			= ТипКолонки;
	
	ИнициализацияКолонкиВТЗКлиент("", ИмяКолонки, ТипКолонки)
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТаблицыЗначенийНаименованиеКолонкиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ТекущаяКолонкаТЗ 	= Элементы.НастройкиТаблицыЗначений.ТекущиеДанные;
	СтароеИмя 			= ТекущаяКолонкаТЗ.НаименованиеКолонки;
	ТипКолонки          = ТекущаяКолонкаТЗ.ТипКолонки;
	ИдентификаторСтроки	= ТекущаяКолонкаТЗ.ПолучитьИдентификатор();
	
	Текст = УбратьСимволыИзТекста(Текст);
	
	Если Не ПустаяСтрока(Текст) Тогда 	
		НовоеИмя	= СформироватьИмяКолонки(Текст, ИдентификаторСтроки);
	Иначе
		НовоеИмя 	= СформироватьИмяКолонки(ИмяКолонкиПоУмолчанию, ИдентификаторСтроки);
		
		ПоказатьСообщениеПользователю(НСтр("ru = 'Наименование колонки не может быть пустым.'"), "Объект");
	КонецЕсли;
	
	ТекущаяКолонкаТЗ.НаименованиеКолонки = НовоеИмя;
	
	Если ТипКолонки.Типы().Количество() <> 0 Тогда 
		ИзменитьИмяРеквизитаИКолонкиСервер(СтароеИмя, НовоеИмя, ТипКолонки);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТаблицыЗначенийПередУдалением(Элемент, Отказ)
	ТекущаяСтрока 		= Элементы.НастройкиТаблицыЗначений.ТекущаяСтрока;
	ТекущаяКолонкаТЗ 	= Элементы.НастройкиТаблицыЗначений.ТекущиеДанные;
	ИмяКолонки 			= ТекущаяКолонкаТЗ.НаименованиеКолонки;
	ТипКолонки          = ТекущаяКолонкаТЗ.ТипКолонки;
	
	Если ТипКолонки.Типы().Количество() <> 0 Тогда 
		УдалитьКолонкуСервер(ИмяКолонки);
	КонецЕсли;	
	
	ЭлементКоллекции = НастройкиТаблицыЗначений.НайтиПоИдентификатору(ТекущаяСтрока);
	ИндексЭлементаКоллекции = НастройкиТаблицыЗначений.Индекс(ЭлементКоллекции);
	НастройкиТаблицыЗначений.Удалить(ИндексЭлементаКоллекции);
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// КОМАНДЫ

&НаКлиенте
Процедура ВыгрузитьТаблицуЗначений(Команда)
	ВыгрузитьТаблицуЗначенийСервер();	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

// Формирует колонки для Таблицы значений из Настроек таблицы значений.
//
// Изменяет реквизиты текущего параметра.
//
&НаКлиенте
Процедура ВыгрузитьТаблицуЗначенийСервер()
	ПараметрыПередачи = ПоместитьЗапросыВСтруктуру(ИдентификаторТекущегоЗапроса, ИдентификаторТекущегоПараметра);
	
	Закрыть(); 
	Владелец					= ЭтотОбъект.ВладелецФормы;
	Владелец.Модифицированность = Истина;
	
	Оповестить("ВыгрузитьЗапросыВРеквизиты", ПараметрыПередачи);
КонецПроцедуры	

&НаСервере
Функция ВнутрЗначениеОбъектаТЗ()
	ТЗ = РеквизитФормыВЗначение("ТаблицаЗначенийПараметр");
	Возврат ЗначениеВСтрокуВнутр(ТЗ);
КонецФункции

&НаСервере
Функция ПоместитьЗапросыВСтруктуру(ИдентификаторЗапроса,ИдентификаторПараметра)
	ПараметрыФормы = Объект.Параметры;
	
	ПредставлениеТЗ = СформироватьПредставлениеТаблицыЗначений(ПредставлениеТЗ);
	
	Для каждого Стр из ПараметрыФормы Цикл
		Если Стр.Идентификатор = ИдентификаторТекущегоПараметра Тогда
			Стр.Тип		 		= "ТаблицаЗначений";
			Стр.Значение 		= ВнутрЗначениеОбъектаТЗ();
			Стр.ТипВФорме		= НСтр("ru = 'Таблица значений'");
			Стр.ЗначениеВФорме	= ПредставлениеТЗ;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("АдресХранилища", ОбъектОбработки().ПоместитьЗапросыВоВременноеХранилище(Объект, ИдентификаторЗапроса, ИдентификаторПараметра));
	
	Возврат ПараметрыПередачи;
КонецФункции	

// Заполняет таблицы значений в форме по загружаемой таблице значений.
//
&НаСервере
Процедура ЗаполнитьТаблицыПриОткрытии()
	ПараметрыФормы = Объект.Параметры;
	Для каждого ТекущийПараметр из ПараметрыФормы Цикл 
		Если ТекущийПараметр.Идентификатор = ИдентификаторТекущегоПараметра Тогда 
			Значение = ТекущийПараметр.Значение;
			Если ПустаяСтрока(Значение) Тогда 
				Возврат;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;	
	
	// Формирование таблицы "Настройки".
	ТЗ = ЗначениеИзСтрокиВнутр(Значение);
	Если ТипЗнч(ТЗ) <> Тип("ТаблицаЗначений") тогда
		Возврат;
	КонецЕсли;	
	
	Колонки = ТЗ.Колонки;
	Для Индекс = 0 по Колонки.Количество() - 1 Цикл 
		ТекущаяКолонка = Колонки.Получить(Индекс);
		
		ИмяКолонки = ТекущаяКолонка.Имя;
		ТипКолонки = ТекущаяКолонка.ТипЗначения;
		
		Настройка 						= НастройкиТаблицыЗначений.Добавить();
		Настройка.НаименованиеКолонки 	= ИмяКолонки;
		Настройка.ТипКолонки 			= ТипКолонки;
		
		ИнициализацияКолонкиВТЗСервер("", ИмяКолонки, ТипКолонки, "");
	КонецЦикла;	
	
	// Заполнение таблицы значений.
	Для каждого Строка из ТЗ Цикл
		ЭлементТЗ 				= ТаблицаЗначенийПараметр.Добавить();
		Для каждого Колонка из ТЗ.Колонки Цикл
			ЭлементТЗ[Колонка.Имя]  = Строка[Колонка.Имя];
		КонецЦикла;
	КонецЦикла;	
КонецПроцедуры	

&НаСервере
Функция СформироватьПредставлениеТаблицыЗначений(Представление)
	ТЗ = РеквизитФормыВЗначение("ТаблицаЗначенийПараметр");
	Представление = ОбъектОбработки().ФормированиеПредставленияЗначения(ТЗ);
	
	Возврат Представление;
КонецФункции	

// Формирует имя добавляемой колонки.
// Оно не должно совпадать с именем реквизита формы 
// и с именем колонки.
//
// Параметры:
//	Имя - передаваемое имя.
//
&НаКлиенте
Функция СформироватьИмяКолонки(знач ИмяКолонки, ИДТекСтроки)
	НТЗ = НастройкиТаблицыЗначений;
	Флаг = Истина;
	Индекс = 0;
	
	ИмяКолонки = СокрЛП(ИмяКолонки);
	
	Пока Флаг Цикл
		Имя = ИмяКолонки + Строка(Формат(Индекс, "ЧН=-"));
		Имя = СтрЗаменить(Имя, "-", "");
		
		// Если нет строки с таким именем.
		Фильтр = Новый Структура("НаименованиеКолонки", Имя);
		ОтфильтрованныеСтроки = НТЗ.НайтиСтроки(Фильтр);
		Если ОтфильтрованныеСтроки.Количество() = 0 Тогда
			Флаг = Ложь;
		Иначе
			Если ОтфильтрованныеСтроки.Получить(0).ПолучитьИдентификатор() <> ИДТекСтроки Тогда 
				Флаг = Истина;
			Иначе
				Флаг = Ложь;
			КонецЕсли;	
		КонецЕсли;
		
		// Если нет колонки с таким именем.
		Колонки = Элементы.ТаблицаЗначенийПараметр.ПодчиненныеЭлементы;
		КолКолонок = Колонки.Количество();
		Для Индекс = 0 по КолКолонок - 1 Цикл 
			Если Колонки.Получить(Индекс).Имя = Имя Тогда 
				Флаг = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		ВозврЗнач = ?(Флаг, "", Имя);
		
		Индекс = Индекс + 1;
	КонецЦикла; 
	
	Возврат ВозврЗнач;
КонецФункции

&НаКлиенте
Процедура ИнициализацияКолонкиВТЗКлиент(СтароеИмяКолонки, НовоеИмяКолонки, ТипКолонки)
	СообщениеСистемы = "";
	ИнициализацияКолонкиВТЗСервер(СтароеИмяКолонки, НовоеИмяКолонки, ТипКолонки, СообщениеСистемы);
	Если не ПустаяСтрока(СообщениеСистемы) Тогда
		ПоказатьСообщениеПользователю(СообщениеСистемы, "Объект");
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ИнициализацияКолонкиВТЗСервер(СтароеИмяКолонки, НовоеИмяКолонки, ТипКолонки, Сообщение = "");
	НачатьТранзакцию();
	
	ИмяУдаляемогоРеквизита = ИмяРодителя + "." + СтароеИмяКолонки;
	
	// Заполнение массива удаляемыми реквизитами.
	МассивУдаляемыхРеквизитов = Новый Массив;
	РекРодителя		= ПолучитьРеквизиты(ИмяРодителя);
	Для каждого ТекРек из РекРодителя Цикл
		Если ТекРек.Имя = СтароеИмяКолонки Тогда 
			МассивУдаляемыхРеквизитов.Добавить(ИмяУдаляемогоРеквизита);
		КонецЕсли;	
	КонецЦикла;	
	
	// Выгрузка значений в таблицу значений.
	Если Не ПустаяСтрока(СтароеИмяКолонки) Тогда
		ТЗЗначений = ТаблицаЗначенийПараметр.Выгрузить(, СтароеИмяКолонки);
	Иначе	
		ТЗЗначений = Неопределено;
	КонецЕсли;	
	
	// Добавление нового реквизита в объект.
	ДобавляемыеРеквизиты = Новый Массив;
	
	НовыйРеквизит 	= Новый РеквизитФормы(НовоеИмяКолонки, ТипКолонки, ИмяРодителя, НовоеИмяКолонки, Ложь);
	ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
	ИзменитьРеквизиты(ДобавляемыеРеквизиты, МассивУдаляемыхРеквизитов);
	
	// Поиск колонки в "ТаблицаЗначенийПараметр" с условием ПутьКДанным=ПутьКНовомуРеквизиту.
	ИмяДобавляемогоРеквизита = ИмяРодителя + "." + НовоеИмяКолонки;
	НомерКолонки = ПоискКолонокВТЗСЗаданнымПутемКДанным(ИмяДобавляемогоРеквизита);
	Если ТЗЗначений <> Неопределено Тогда 
		Если НомерКолонки <> Неопределено Тогда 
			ИмяПервойКолонки = ТЗЗначений.Колонки.Получить(0).Имя;
			Индекс = 0;
			Для Каждого Стр из ТЗЗначений Цикл 
				ТаблицаЗначенийПараметр.Получить(Индекс)[НовоеИмяКолонки] = Стр[ИмяПервойКолонки];
				Индекс = Индекс + 1;
			КонецЦикла;
		КонецЕсли;
	Иначе
		НоваяКолонкаТаблицы = Элементы.Добавить(НовоеИмяКолонки, Тип("ПолеФормы"), Элементы.ТаблицаЗначенийПараметр);
		НоваяКолонкаТаблицы.ПутьКДанным = ИмяДобавляемогоРеквизита;
		НоваяКолонкаТаблицы.Вид			= ВидПоляФормы.ПолеВвода;
	КонецЕсли;	
	
	ЗафиксироватьТранзакцию();
КонецПроцедуры

// Изменяет имя реквизита и колонки по идентификатору строки.
//
// Параметры:
//	ИДСтроки - идентификатор строки таблицы значений настроек.
//	Имя - новое передаваемое имя для реквизита и колонки.
//
&НаСервере
Процедура ИзменитьИмяРеквизитаИКолонкиСервер(СтароеИмя, НовоеИмя, ТипКолонки)
	НачатьТранзакцию();
	
	ИмяУдаляемогоРеквизита = ИмяРодителя + "." + СтароеИмя;
	
	// Заполнение массива удаляемыми реквизитами.
	МассивУдаляемыхРеквизитов = Новый Массив;
	РекРодителя		= ПолучитьРеквизиты(ИмяРодителя);
	Для каждого ТекРек из РекРодителя Цикл
		Если ТекРек.Имя = СтароеИмя Тогда 
			МассивУдаляемыхРеквизитов.Добавить(ИмяУдаляемогоРеквизита);
		КонецЕсли;	
	КонецЦикла;	
	
	// Выгрузка значений в таблицу значений.
	ТЗЗначений = ТаблицаЗначенийПараметр.Выгрузить(, СтароеИмя);
	
	// Добавление нового реквизита в объект.
	ДобавляемыеРеквизиты = Новый Массив;
	НовыйРеквизит 	= Новый РеквизитФормы(НовоеИмя, ТипКолонки, ИмяРодителя, НовоеИмя, Ложь);
	ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
	ИзменитьРеквизиты(ДобавляемыеРеквизиты, МассивУдаляемыхРеквизитов);
	
	// Поиск колонки в "ТаблицаЗначенийПараметр" с условием ПутьКДанным = ПутьКНовомуРеквизиту.
	ИмяДобавляемогоРеквизита = ИмяРодителя + "." + НовоеИмя;
	НомерКолонки = ПоискКолонокВТЗСЗаданнымПутемКДанным(ИмяДобавляемогоРеквизита);
	Если НомерКолонки <> Неопределено Тогда 
		ИмяПервойКолонки = ТЗЗначений.Колонки.Получить(0).Имя;
		Индекс = 0;
		Для Каждого СтарСтр из ТЗЗначений Цикл 
			ТаблицаЗначенийПараметр.Получить(Индекс)[НовоеИмя] = СтарСтр[ИмяПервойКолонки];
			Индекс = Индекс + 1;
		КонецЦикла;	
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
КонецПроцедуры	

// Возвращает номер колонки с заданным путем.
//
// Параметры:
//	ПутьКДанным - заданный путь.
//
//	Возвращаемое значение: номер колонки или Неопределено.
//
&НаСервере
Функция ПоискКолонокВТЗСЗаданнымПутемКДанным(ПутьКДанным)
	Колонки 			= Элементы.ТаблицаЗначенийПараметр.ПодчиненныеЭлементы;
	КоличествоКолонок 	= Колонки.Количество();
	Флаг				= Ложь;
	Для Индекс = 0 по КоличествоКолонок - 1 Цикл 
		ТекКолонка = Колонки.Получить(Индекс);
		Если ТекКолонка.ПутьКДанным = ПутьКДанным Тогда 
			Возврат Индекс;
		КонецЕсли;	
	КонецЦикла;	
    Возврат Неопределено;
КонецФункции

// Удаляет колонку по имени.
//
// Параметры:
//	ИмяКолонки - имя колонки.
//
&НаСервере
Процедура УдалитьКолонкуСервер(ИмяКолонки)
	ИмяУдаляемогоРеквизита = ИмяРодителя + "." + ИмяКолонки;
	
	// Заполнение массива удаляемыми реквизитами.
	МассивУдаляемыхРеквизитов = Новый Массив;
	РекРодителя		= ПолучитьРеквизиты(ИмяРодителя);
	Для каждого ТекРек из РекРодителя Цикл
		Если ТекРек.Имя = ИмяКолонки Тогда 
			МассивУдаляемыхРеквизитов.Добавить(ИмяУдаляемогоРеквизита);
		КонецЕсли;	
	КонецЦикла;	
	
	ИзменитьРеквизиты(, МассивУдаляемыхРеквизитов);
КонецПроцедуры	

&НаКлиенте
Процедура ПоказатьСообщениеПользователю(ТекстСообщения, ПутьКДанным)
	ОчиститьСообщения();
	Сообщение = Новый СообщениеПользователю(); 
    Сообщение.Текст = ТекстСообщения;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.УстановитьДанные(Объект); 
    Сообщение.Сообщить(); 	
КонецПроцедуры	

&НаКлиенте
Функция УбратьСимволыИзТекста(знач Текст)
	ВозврЗнач = "";
	
	ДлинаТекста = СтрДлина(Текст);
	
	Если ДлинаТекста = 0 Тогда 
		Возврат ВозврЗнач;
	КонецЕсли;	
	
	Для Индекс = 0 по ДлинаТекста - 1  Цикл 
		СимволТекста = Лев(Текст, 1);
		Если Не ЭтоСимвол(СимволТекста) Тогда 
			ВозврЗнач = ВозврЗнач + СимволТекста;
		КонецЕсли;	
		Текст = Сред(Текст, 2);
	КонецЦикла;	
	
	Возврат ВозврЗнач;
КонецФункции

&НаКлиенте
Функция ЭтоСимвол(Символ)
	// Символы между 1040 и 1103 - Русские буквы.
	// Символы между 48 и 57 - Цифры.
	// Символы между 65 и 122 - Английские буквы.
	
	Код = КодСимвола(Символ); 
	Если (Код >= 1040 и Код <= 1103) или (Код >= 48 и Код <= 57) или (Код >= 65 и Код <= 122) Тогда 
	  Возврат Ложь; 
	Иначе 
	  Возврат Истина; 
	КонецЕсли; 
КонецФункции	

&НаСервере
Функция ИмяТипаПоЗначению(Значение)
	
	Возврат Значение.Метаданные().Имя;
	
КонецФункции	

///////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ИмяРодителя 			= "ТаблицаЗначенийПараметр";
ИмяКолонкиПоУмолчанию 	= "Колонка";

#КонецОбласти
