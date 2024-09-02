
//ignore: must_be_immutable
class InitializareRatingsWidget {

  InitializareRatingsWidget();

    List<RatingItem> listaRatings = [RatingItem(textNume: "Cristina Mihalache", 
                                      textComentariu: "Am discutat telefonic cu dna Dr. Pediatru și am avut o experiență foarte pozitivă. O consultație detaliată, mi s-a răspuns la toate întrebările.", 
                                      iconPath:'./assets/images/rating_cristina_mihalache.png', textData: '17 Februarie 2023', textRating: '', 
                                      dataStart: DateTime.utc(2022, 2, 17)),
                                    RatingItem(textNume: "Irina Brănescu", 
                                      textComentariu: "Am discutat pentru o a 2-a părere medicală, legată de rinichi. Mi-a răspuns la toate întrebările cu multă empatie și răbdare, mi-a explicat pe înțelesul meu, s-a uitat la istoricul meu medical și a fost foarte implicată.", 
                                      iconPath:'./assets/images/rating_irina_branescu.png', textData: '21 Februarie 2023', textRating: '',
                                      dataStart: DateTime.utc(2023, 2, 21)),
                                    RatingItem(textNume: "Florentina Buzea", 
                                      textComentariu: "Un medic extraordinar, care se dedică micilor pacienți! Pentru copilul meu, născut la doar 29 săptămâni, a făcut minuni!", 
                                      iconPath:'./assets/images/rating_florentina_buzea.png', textData: '22 Februarie 2023', textRating: '',
                                      dataStart: DateTime.utc(2023, 2, 22)),
                                    RatingItem(textNume: "Elena Tănase", 
                                      textComentariu: "O iubim pe doamna doctor! ❤️ Copilul meu nu putea avea un medic mai bun, un adevărat profesionist.", 
                                      iconPath:'./assets/images/rating_elena_tanase.png', textData: '22 Februarie 2023', textRating: '',
                                      dataStart: DateTime.utc(2023, 2, 22)),
                                  ];

  List<RatingItem> initList () {

    return listaRatings;
  }

  List<RatingItem> filterListByIndex()
  {
    List<RatingItem> listResult = [];
    for(int index = 0; index <listaRatings.length; index++){
      if (index < 2)
      {
        listResult.add(listaRatings[index]);
      }
    }  
    return listResult; 
  }
  
  List<RatingItem> filterListByLowerData(DateTime higherThresholdData)
  {
    List<RatingItem> listResult = [];
    for(int index = 0; index < listaRatings.length; index++){
      var dataStartItem = listaRatings[index].dataStart;
      
      if (dataStartItem.year < higherThresholdData.year)
      {
        listResult.add(listaRatings[index]);
      }
      else if ((dataStartItem.year == higherThresholdData.year) && (dataStartItem.month < higherThresholdData.month))
      {
        listResult.add(listaRatings[index]);
      }
      else if (((dataStartItem.year == higherThresholdData.year) && (dataStartItem.month == higherThresholdData.month))
             && (dataStartItem.day < higherThresholdData.day))
      {
        listResult.add(listaRatings[index]);
      }
      
    } 
    return listResult; 
  }
  
  List<RatingItem> filterListByHigherData(DateTime lowerThresholdData)
  {
    List<RatingItem> listResult = [];
    for(int index = 0; index <listaRatings.length; index++){
      var dataStartItem = listaRatings[index].dataStart;
      if (dataStartItem.year > lowerThresholdData.year)
      {
        listResult.add(listaRatings[index]);
      }
      else if (dataStartItem.year == lowerThresholdData.year && dataStartItem.month > lowerThresholdData.month)
      {
        listResult.add(listaRatings[index]);
      }
      else if (dataStartItem.year == lowerThresholdData.year && dataStartItem.month == lowerThresholdData.month
             && dataStartItem.day > lowerThresholdData.day)
      {
        listResult.add(listaRatings[index]);
      }
    }  
    return listResult; 
  }
  
  List<RatingItem> filterListRecenzieMobileByIntervalData(DateTime lowerThresholdData, DateTime higherThresholdData)
  {
    List<RatingItem> listResult = [];
    if (lowerThresholdData.isAfter(higherThresholdData))
    {
      return listResult;
    }
    
for(int index = 0; index <listaRatings.length; index++){
      
      var dataStartItem = listaRatings[index].dataStart;    

      if ((dataStartItem.year > lowerThresholdData.year) 
                && ((dataStartItem.year < higherThresholdData.year)
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month < higherThresholdData.month)
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month == higherThresholdData.month && dataStartItem.day <= higherThresholdData.day)))
      {
        listResult.add(listaRatings[index]);
      }
      else if (((dataStartItem.year == lowerThresholdData.year) && (dataStartItem.month > lowerThresholdData.month))
                && ((dataStartItem.year < higherThresholdData.year) 
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month < higherThresholdData.month)
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month == higherThresholdData.month && dataStartItem.day <= higherThresholdData.day)))
      {
        listResult.add(listaRatings[index]);
      }
      else if (((dataStartItem.year == lowerThresholdData.year) && (dataStartItem.month == lowerThresholdData.month) && (dataStartItem.day >= lowerThresholdData.day))
      && ((dataStartItem.year < higherThresholdData.year) 
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month < higherThresholdData.month)
                  || (dataStartItem.year == higherThresholdData.year && dataStartItem.month == higherThresholdData.month  && dataStartItem.day <= higherThresholdData.day)))
      {
        listResult.add(listaRatings[index]);
      }
    }  

    return listResult; 
  }
}

class RatingItem {
  final String iconPath;
  final String textNume;
  final String textRating;
  final String textComentariu;
  final String textData;
  DateTime dataStart;
  
  RatingItem({required this.textNume, required this.textRating, required this.iconPath, required this.textComentariu, required this.textData, required this.dataStart});

}
