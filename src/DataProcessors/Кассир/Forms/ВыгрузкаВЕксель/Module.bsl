
&НаСервере
Процедура ПриСозданииНаСервере ( Отказ, СтандартнаяОбработка )
	
	Статус = "Все";
	Период.ДатаНачала = Параметры.ДатаНачала;
	Период.ДатаОкончания = Параметры.ДатаОкончания;
	Касса = Параметры.Касса;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК ( Команда )
	
	п = Новый Структура (); 
	п.Вставить ( "ДатаНачала", Период.ДатаНачала );
	п.Вставить ( "ДатаОкончания", Период.ДатаОкончания );
	п.Вставить ( "Статус", Статус );
	п.Вставить ( "Касса", Касса );
	Закрыть ( п );
	
КонецПроцедуры


