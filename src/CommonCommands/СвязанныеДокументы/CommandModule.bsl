
&НаКлиенте
Процедура ОбработкаКоманды ( ПараметрКоманды, ПараметрыВыполненияКоманды )
	
	Если ЗначениеЗаполнено ( ПараметрКоманды ) Тогда
		ОткрытьФорму ( "КритерийОтбора.СвязанныеДокументы.Форма.Список", 
						Новый Структура ( "ОбъектОтбора", ПараметрКоманды ),
						ПараметрыВыполненияКоманды.Источник,
						ПараметрыВыполненияКоманды.Источник.КлючУникальности,
						ПараметрыВыполненияКоманды.Окно );
	КонецЕсли;

КонецПроцедуры