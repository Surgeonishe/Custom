
&НаКлиенте
Процедура ОбработкаКоманды ( ПараметрКоманды, ПараметрыВыполненияКоманды )
	
	ПараметрыФормы = Новый Структура ();
	ОткрытьФорму ( "Отчет.ОстаткиДенежныхСредств.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ВариантОткрытияОкна.ОтдельноеОкно, ПараметрыВыполненияКоманды.НавигационнаяСсылка );
	
КонецПроцедуры