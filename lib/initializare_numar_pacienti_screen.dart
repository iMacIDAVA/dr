
//ignore: must_be_immutable
class InitializareNumarPacientiWidget {

  InitializareNumarPacientiWidget();

  List<NumarPacientiItem> listaNumarPacienti = [NumarPacientiItem(textNume: "Cristina Mihalache", textOras: "București", textDurata: '10:00 AM - 10:30 AM (30 min)', iconPath: './assets/images/pacient_cristina_mihalache.png', 
                                              dataStart: DateTime.utc(2022, 11, 9)),
                                            NumarPacientiItem(textNume: "Irina Brănescu", textOras: "București", textDurata: '10:00 AM - 10:30 AM (30 min)', iconPath: './assets/images/pacient_irina_branescu.png', 
                                              dataStart: DateTime.utc(2021, 11, 9)),
                                            NumarPacientiItem(textNume: "Cristina Mihalache", textOras: "București", textDurata: '10:00 AM - 10:30 AM (30 min)', iconPath: './assets/images/pacient_cristina_mihalache.png', 
                                              dataStart: DateTime.utc(2022, 11, 9)),
                                            NumarPacientiItem(textNume: "Irina Brănescu", textOras: "București", textDurata: '10:00 AM - 10:30 AM (30 min)', iconPath: './assets/images/pacient_irina_branescu.png', 
                                              dataStart: DateTime.utc(2023, 1, 9)),
                                            NumarPacientiItem(textNume: "Irina Brănescu", textOras: "București", textDurata: '10:00 AM - 10:30 AM (30 min)', iconPath: './assets/images/pacient_irina_branescu.png', 
                                              dataStart: DateTime.utc(2023, 2, 19)),
                                            NumarPacientiItem(textNume: "Irina Brănescu", textOras: "București", textDurata: '10:00 AM - 10:30 AM (30 min)', iconPath: './assets/images/pacient_irina_branescu.png', 
                                              dataStart: DateTime.utc(2023, 2, 10)),
                                          ];

  List<NumarPacientiItem> initList () {
    return listaNumarPacienti;
  }

  List<NumarPacientiItem> filterListByIndex()
  {
    List<NumarPacientiItem> listResult = [];
    for(int index = 0; index <listaNumarPacienti.length; index++){
      if (index < 2)
      {
        listResult.add(listaNumarPacienti[index]);
      }
    }  
    return listResult; 
  }
  
  List<NumarPacientiItem> filterListByLowerData(DateTime higherThresholdData)
  {
    List<NumarPacientiItem> listResult = [];
    for(int index = 0; index < listaNumarPacienti.length; index++){
      var dataStartItem = listaNumarPacienti[index].dataStart;
      
      if (dataStartItem.year < higherThresholdData.year)
      {
        listResult.add(listaNumarPacienti[index]);
      }
      else if ((dataStartItem.year == higherThresholdData.year) && (dataStartItem.month < higherThresholdData.month))
      {
        listResult.add(listaNumarPacienti[index]);
      }
      else if (((dataStartItem.year == higherThresholdData.year) && (dataStartItem.month == higherThresholdData.month))
             && (dataStartItem.day < higherThresholdData.day))
      {
        listResult.add(listaNumarPacienti[index]);
      }
      
    } 
    return listResult; 
  }
  
  List<NumarPacientiItem> filterListByHigherData(DateTime lowerThresholdData)
  {
    List<NumarPacientiItem> listResult = [];
    for(int index = 0; index <listaNumarPacienti.length; index++){
      var dataStartItem = listaNumarPacienti[index].dataStart;
      if (dataStartItem.year > lowerThresholdData.year)
      {
        listResult.add(listaNumarPacienti[index]);
      }
      else if (dataStartItem.year == lowerThresholdData.year && dataStartItem.month > lowerThresholdData.month)
      {
        listResult.add(listaNumarPacienti[index]);
      }
      else if (dataStartItem.year == lowerThresholdData.year && dataStartItem.month == lowerThresholdData.month
             && dataStartItem.day > lowerThresholdData.day)
      {
        listResult.add(listaNumarPacienti[index]);
      }
    }  
    return listResult; 
  }
  
  List<NumarPacientiItem> filterListByIntervalData(DateTime lowerThresholdData, DateTime higherThresholdData)
  {
    List<NumarPacientiItem> listResult = [];
    if (lowerThresholdData.isAfter(higherThresholdData))
    {
      return listResult;
    }
    
    for(int index = 0; index <listaNumarPacienti.length; index++){
      
      var dataStartItem = listaNumarPacienti[index].dataStart;    

      if ((dataStartItem.year > lowerThresholdData.year) 
                && ((dataStartItem.year < higherThresholdData.year)
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month < higherThresholdData.month)
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month == higherThresholdData.month && dataStartItem.day <= higherThresholdData.day)))
      {
        listResult.add(listaNumarPacienti[index]);
      }
      else if (((dataStartItem.year == lowerThresholdData.year) && (dataStartItem.month > lowerThresholdData.month))
                && ((dataStartItem.year < higherThresholdData.year) 
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month < higherThresholdData.month)
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month == higherThresholdData.month && dataStartItem.day <= higherThresholdData.day)))
      {
        listResult.add(listaNumarPacienti[index]);
      }
      else if (((dataStartItem.year == lowerThresholdData.year) && (dataStartItem.month == lowerThresholdData.month) && (dataStartItem.day >= lowerThresholdData.day))
      && ((dataStartItem.year < higherThresholdData.year) 
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month < higherThresholdData.month)
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month == higherThresholdData.month  && dataStartItem.day <= higherThresholdData.day)))
      {
        listResult.add(listaNumarPacienti[index]);
      }
    }  

    return listResult; 
  }

}

class NumarPacientiItem {
  String textNume;
  String textOras;
  String iconPath;
  String textDurata;
  DateTime dataStart;
  
  NumarPacientiItem({required this.textNume, required this.textOras, required this.iconPath, required this.textDurata, required this.dataStart});

}
