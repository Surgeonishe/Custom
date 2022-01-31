
&НаСервере
Процедура ПриСозданииНаСервере ( Отказ, СтандартнаяОбработка )
	
	Касса = Параметры.Касса;
	КассаПеремещение = Справочники.Кассы.НайтиПоКоду ( "000000004" );
	Дата = Параметры.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК ( Команда )
	
	отказ = Ложь;
	Если ( ЗначениеЗаполнено ( Валюта ) ) Тогда
		// код ...	
	Иначе
		Сообщить ( "Не заполнено поле ""Валюта""!", СтатусСообщения.Важное );   
		отказ = Истина;
	КонецЕсли;
	Если ( ЗначениеЗаполнено ( КассаПеремещение ) ) Тогда
		// код ...	
	Иначе
		Сообщить ( "Не заполнено поле ""Касса (куда)""!", СтатусСообщения.Важное );   
		отказ = Истина;
	КонецЕсли;
	Если ( ЗначениеЗаполнено ( Сумма ) ) Тогда
		// код ...	
	Иначе
		Сообщить ( "Не заполнено поле ""Сумма""!", СтатусСообщения.Важное );   
		отказ = Истина;
	КонецЕсли;
	Если ( отказ ) Тогда
		Возврат;
	КонецЕсли; 
	п = Новый Структура ();
	п.Вставить ( "Дата", Дата );
	п.Вставить ( "Валюта", Валюта );
	п.Вставить ( "Сумма", Сумма );
	п.Вставить ( "КассаПеремещение", КассаПеремещение );
	п.Вставить ( "Касса", Касса );
	Закрыть ( п );
	
КонецПроцедуры