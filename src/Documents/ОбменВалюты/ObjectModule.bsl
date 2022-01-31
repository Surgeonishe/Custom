
Процедура ПередЗаписью ( Отказ, РежимЗаписи, РежимПроведения )
	
	Если ( ОбменДанными.Загрузка ) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи ( Отказ )
	
	Если ( ОбменДанными.Загрузка ) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура заполнитьДополнительныеСвойства ()
	
	ДополнительныеСвойства.Вставить ( "Перепроведение", Проведен );
	ДополнительныеСвойства.Вставить ( "ОперативноеПроведение", ( ЭтоНовый () И НачалоДня ( Дата ) = НачалоДня ( ТекущаяДата () ) ) ); 
	
КонецПроцедуры 

Процедура ОбработкаПроведения ( Отказ, РежимПроведения )
	
	заполнитьДополнительныеСвойства	();
	данные = Новый Структура;
	данные.Вставить ( "Ссылка", Ссылка );
	данные.Вставить ( "Дата", Дата );
	данные.Вставить ( "Движения", Движения );
	данные.Вставить ( "МоментВремени", МоментВремени () );
	данные.Вставить ( "ДополнительныеСвойства", ДополнительныеСвойства );
	Отказ = НЕ Документы.ОбменВалюты.Проведение ( данные );
	
КонецПроцедуры