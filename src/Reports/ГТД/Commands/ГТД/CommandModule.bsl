
&НаКлиенте
Процедура ОбработкаКоманды ( ПараметрКоманды, ПараметрыВыполненияКоманды )
	
	ПараметрыФормы = Новый Структура ();
	ОткрытьФорму ( "Отчет.ГТД.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ВариантОткрытияОкна.ОтдельноеОкно, ПараметрыВыполненияКоманды.НавигационнаяСсылка );
	
КонецПроцедуры