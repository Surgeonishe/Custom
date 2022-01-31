
Процедура ПередЗаписью ( Отказ )
	
	Если ( ЭтоНовый () И ПустаяСтрока ( Наименование ) ) Тогда
		заполнитьНаименование ();
	КонецЕсли;	
	
КонецПроцедуры

Процедура заполнитьНаименование ()
	
	Если ( ЗначениеЗаполнено ( Фамилия ) ) Тогда
		Наименование = СокрЛП ( Фамилия );
		Если ( ЗначениеЗаполнено ( Имя ) ) Тогда
			Наименование = Наименование + " " + Лев ( СокрЛП ( Имя ), 1 ) + ".";
			Если ( ЗначениеЗаполнено ( Отчество ) ) Тогда
				Наименование = Наименование + " " + Лев ( СокрЛП ( Отчество ), 1 ) + ".";
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры 