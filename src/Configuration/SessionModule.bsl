
Процедура УстановкаПараметровСеанса ( ТребуемыеПараметры )
	
	стр = "
	|ВЫБРАТЬ Пользователи.Ссылка КАК Ссылка, Пользователи.ОсновнаяОрганизация КАК ОсновнаяОрганизация
	|ИЗ 	 Справочник.Пользователи КАК Пользователи
	|ГДЕ	 Пользователи.Наименование = &Наименование	  
	|";
	запрос = Новый Запрос ( стр );
	запрос.УстановитьПараметр ( "Наименование", ПользователиИнформационнойБазы.ТекущийПользователь ().Имя );
	результат = запрос.Выполнить ();
	Если ( результат.Пустой () ) Тогда
		НовыйПользователь = Справочники.Пользователи.СоздатьЭлемент ();
		НовыйПользователь.Наименование = ПользователиИнформационнойБазы.ТекущийПользователь ().Имя;
		НовыйПользователь.Записать ();
		ПараметрыСеанса.ТекущийПользователь = НовыйПользователь.Ссылка;
	Иначе
		выборка = результат.Выбрать ();
		выборка.Следующий ();
		ПараметрыСеанса.ТекущийПользователь = выборка.Ссылка;
	КонецЕсли;
	
КонецПроцедуры