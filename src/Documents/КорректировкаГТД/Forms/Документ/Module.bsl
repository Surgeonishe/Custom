
&НаСервере
Процедура ПриСозданииНаСервере ( Отказ, СтандартнаяОбработка )
	
	Если ( Объект.Ссылка.Пустая () ) Тогда
		Объект.Организация = Константы.ОсновнаяОрганизация.Получить ();
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь; 
	КонецЕсли;  
	
КонецПроцедуры
