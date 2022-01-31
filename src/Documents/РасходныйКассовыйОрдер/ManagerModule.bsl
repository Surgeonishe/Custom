
Функция Проведение ( Данные ) Экспорт
	
	получитьДанные ( Данные );
	сформироватьДенежныеСредства ( Данные );
	сформироватьДвиженияДенежныхСредств ( Данные );
	Если ( Данные.Шапка.ВидОперации = Перечисления.ВидОперацииРасходныйКассовыйОрдер.Оплата ) Тогда
		сформироватьВзаиморасчеты ( Данные );
		сформироватьДоходыРасходы ( Данные );
	ИначеЕсли ( Данные.Шапка.ВидОперации = Перечисления.ВидОперацииРасходныйКассовыйОрдер.ВыдачаВПодотчет ) Тогда
		Если ( НЕ Данные.Шапка.НеУчитыватьПодотчет ) Тогда
			сформироватьПодотчет ( Данные );	
		КонецЕсли;		
	ИначеЕсли ( Данные.Шапка.ВидОперации = Перечисления.ВидОперацииРасходныйКассовыйОрдер.Прочее ) Тогда
		сформироватьВзаиморасчеты ( Данные );
		сформироватьДоходыРасходы ( Данные );
	КонецЕсли; 
	установитьФлагиЗаписи ( Данные );
	Возврат ИСТИНА;
	
КонецФункции

Процедура получитьДанные ( Данные )
	
	текст = "
	|// ~Шапка
	|выбрать 
	|	Ссылка как Ссылка, Номер как Номер, Дата как Дата, ДатаОперации как ДатаОперации,
	|	Касса как Касса, Контрагент как Контрагент, НазначениеПлатежа как НазначениеПлатежа,
	|	НомерКвитанции как НомерКвитанции, Основание как Основание, Пост как Пост, Сумма как Сумма, 
	|	Валюта как Валюта, Организация как Организация, СуммаПлатежа как СуммаПлатежа, 
	|	СуммаКомиссии как СуммаКомиссии, Сотрудник как Сотрудник, ВидОперации как ВидОперации,
	|	НеУчитыватьПодотчет как НеУчитыватьПодотчет, СтатьяДДС как СтатьяДДС,
	|	ДолгПоВалютам как ДолгПоВалютам 
	|из 
	|	Документ.РасходныйКассовыйОрдер
	|где 
	|	Ссылка = &Ссылка
	|;
	|выбрать
	|	Валюта как Валюта,
	|	Сумма как Сумма
	|из
	|	Документ.РасходныйКассовыйОрдер.Оплаты
	|где
	|	Ссылка = &Ссылка  
	|";
	запрос = Новый Запрос ( текст );
	запрос.УстановитьПараметр ( "Ссылка", Данные.Ссылка );
	результат = запрос.ВыполнитьПакет ();
	выборкаШапка = результат [ 0 ].Выбрать ();
	выборкаШапка.Следующий ();
	Данные.Вставить ( "Шапка", выборкаШапка );
	Данные.Вставить ( "Оплаты", результат [ 1 ].Выгрузить () );

КонецПроцедуры

Процедура сформироватьВзаиморасчеты ( Данные )
	
	п = Данные.Шапка;
	Если ( п.ДолгПоВалютам ) Тогда
		Для Каждого строкаТЗ Из Данные.Оплаты Цикл
			движение = Данные.Движения.Взаиморасчеты.ДобавитьПриход ();
			движение.Период = п.Дата;
			движение.Контрагент = п.Контрагент;
			движение.Валюта = строкаТЗ.Валюта;
			движение.Заявка = Документы.Заявка.ПустаяСсылка ();
			движение.Организация = п.Организация;
			движение.Сумма = строкаТЗ.Сумма;
		КонецЦикла;		
	Иначе
		Если ( п.Сумма <> 0 ) Тогда
			движение = Данные.Движения.Взаиморасчеты.ДобавитьПриход ();
			движение.Период = п.Дата;
			движение.Контрагент = п.Контрагент;
			движение.Валюта = п.Валюта;
			движение.Заявка = Документы.Заявка.ПустаяСсылка ();
			движение.Организация = п.Организация;
			движение.Сумма = п.Сумма;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура сформироватьДоходыРасходы ( Данные )
	
	п = Данные.Шапка;
	Если ( Данные.Шапка.СуммаКомиссии = 0 ) Тогда
		Возврат;
	КонецЕсли; 
	движение = Данные.Движения.ДоходыРасходы.Добавить ();
	движение.Период = п.Дата;
	// движение.Заявка = Данные.Шапка.Заявка;
	движение.Валюта = п.Валюта;
	движение.Номенклатура = Справочники.Номенклатура.КомиссияКасса;
	движение.СуммаРасход = Данные.Шапка.СуммаКомиссии;
	
КонецПроцедуры

Процедура сформироватьДенежныеСредства ( Данные )
	
	п = Данные.Шапка;
	Если ( Данные.Шапка.ВидОперации = Перечисления.ВидОперацииРасходныйКассовыйОрдер.ПеремещениеВКассу ) Тогда
		движение = Данные.Движения.ДенежныеСредства.ДобавитьРасход ();
		движение.Период = п.Дата;
		движение.Казна = п.Касса;
		движение.Валюта = п.Валюта;
		движение.Сумма = п.Сумма;
	Иначе
		Для Каждого строкаТЗ Из Данные.Оплаты Цикл
			движение = Данные.Движения.ДенежныеСредства.ДобавитьРасход ();
			движение.Период = п.Дата;
			движение.Казна = п.Касса;
			движение.Валюта = строкаТЗ.Валюта;
			движение.Сумма = строкаТЗ.Сумма;	
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура сформироватьДвиженияДенежныхСредств ( Данные )
	
	п = Данные.Шапка;
	Если ( Данные.Шапка.ВидОперации = Перечисления.ВидОперацииРасходныйКассовыйОрдер.ПеремещениеВКассу ) Тогда
		движение = Данные.Движения.ДвиженияДенежныхСредств.Добавить ();
		движение.Период = п.Дата;
		движение.Казна = п.Касса;
		движение.Валюта = п.Валюта;
		движение.Организация = п.Организация;
		движение.СтатьяДДС = п.СтатьяДДС;
		движение.Контрагент = п.Контрагент;
		движение.СуммаПриход = 0;
		движение.СуммаРасход = п.Сумма;	
	Иначе
		Для Каждого строкаТЗ Из Данные.Оплаты Цикл
			движение = Данные.Движения.ДвиженияДенежныхСредств.Добавить ();
			движение.Период = п.Дата;
			движение.Казна = п.Касса;
			движение.Валюта = строкаТЗ.Валюта;
			движение.Организация = п.Организация;
			движение.СтатьяДДС = п.СтатьяДДС;
			движение.Контрагент = п.Контрагент;
			движение.СуммаПриход = 0;
			движение.СуммаРасход = строкаТЗ.Сумма;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура сформироватьПодотчет ( Данные )
	
	движение = Данные.Движения.Подотчет.ДобавитьПриход ();
	движение.Период = Данные.Шапка.Дата;
	движение.Сотрудник = Данные.Шапка.Сотрудник;
	движение.Валюта = Данные.Шапка.Валюта;
	движение.Сумма = Данные.Шапка.Сумма;
	
КонецПроцедуры

Процедура установитьФлагиЗаписи ( Данные )
	
	Данные.Движения.Взаиморасчеты.Записывать = ИСТИНА;
	Данные.Движения.ДенежныеСредства.Записывать = ИСТИНА;
	Данные.Движения.ДвиженияДенежныхСредств.Записывать = ИСТИНА;
	Данные.Движения.ДоходыРасходы.Записывать = ИСТИНА;
	Данные.Движения.Подотчет.Записывать = ИСТИНА;
	
КонецПроцедуры