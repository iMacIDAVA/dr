import 'package:fl_chart/fl_chart.dart';

//ignore: must_be_immutable
class InitializareIncasariWidget {

  InitializareIncasariWidget();
    
  final List<double> yValues = [
    
    1.2,
    1.4,
    1.9,
    1.6,
    2.3,
    2.7,
    3.6,
    1.9,
    2.0,
    3.2,
    2.4,   
    1.3,
    1,
    1.8,
    1.5,
    2.2,
    1.8,
    4,
    2.8,
    2.4,
    3.5,
    1.6,
    
  ];

  List<FlSpot> listaPuncte = [];
  List<PunctItem> listaPuncteData = [];
  List<PunctItem> initList () {

    int lungimeDate = yValues.length;
    listaPuncteData =  
      yValues.asMap().entries.map((e) {
         return PunctItem(dataSuma: DateTime.now().subtract(Duration(days: lungimeDate - e.key)), suma:e.value);
      }).toList();
    
    return listaPuncteData;

  }

  List<PunctItem> filterListByIndex()
  {
    List<PunctItem> listResult = [];
    for(int index = 0; index <listaPuncteData.length; index++){
      if (index < 2)
      {
        listResult.add(listaPuncteData[index]);
      }
    }  
    return listResult; 
  }  
  
  List<PunctItem> filterListByLowerData(DateTime higherThresholdData)
  {
    List<PunctItem> listResult = [];
    for(int index = 0; index < listaPuncteData.length; index++){
      var dataSumaItem = listaPuncteData[index].dataSuma;
      
      if (dataSumaItem.year < higherThresholdData.year)
      {
        listResult.add(listaPuncteData[index]);
      }
      else if ((dataSumaItem.year == higherThresholdData.year) && (dataSumaItem.month < higherThresholdData.month))
      {
        listResult.add(listaPuncteData[index]);
      }
      else if (((dataSumaItem.year == higherThresholdData.year) && (dataSumaItem.month == higherThresholdData.month))
             && (dataSumaItem.day < higherThresholdData.day))
      {
        listResult.add(listaPuncteData[index]);
      }
      
    } 
    return listResult; 
  }

  List<PunctItem> filterListByHigherData(DateTime lowerThresholdData)
  {

    List<PunctItem> listResult = [];
    for(int index = 0; index <listaPuncteData.length; index++){
      var dataSumaItem = listaPuncteData[index].dataSuma;
      if (dataSumaItem.year > lowerThresholdData.year)
      {
        listResult.add(listaPuncteData[index]);
      }
      else if (dataSumaItem.year == lowerThresholdData.year && dataSumaItem.month > lowerThresholdData.month)
      {
        listResult.add(listaPuncteData[index]);
      }
      else if (dataSumaItem.year == lowerThresholdData.year && dataSumaItem.month == lowerThresholdData.month
             && dataSumaItem.day > lowerThresholdData.day)
      {
        listResult.add(listaPuncteData[index]);
      }
    }  
    return listResult;

  }

  List<PunctItem> filterListByIntervalData(DateTime lowerThresholdData, DateTime higherThresholdData)
  {
    List<PunctItem> listResult = [];
    if (lowerThresholdData.isAfter(higherThresholdData))
    {
      return listResult;
    }
    
    for(int index = 0; index <listaPuncteData.length; index++){
    
      var dataSumaItem = listaPuncteData[index].dataSuma;    

      if ((dataSumaItem.year > lowerThresholdData.year) 
                && ((dataSumaItem.year < higherThresholdData.year)
                  || (dataSumaItem.year == higherThresholdData.year && dataSumaItem.month < higherThresholdData.month)
                  || (dataSumaItem.year == higherThresholdData.year && dataSumaItem.month == higherThresholdData.month && dataSumaItem.day <= higherThresholdData.day)))
      {
        listResult.add(listaPuncteData[index]);
      }
      else if (((dataSumaItem.year == lowerThresholdData.year) && (dataSumaItem.month > lowerThresholdData.month))
                && ((dataSumaItem.year < higherThresholdData.year) 
                  || (dataSumaItem.year == higherThresholdData.year && dataSumaItem.month < higherThresholdData.month)
                  || (dataSumaItem.year == higherThresholdData.year && dataSumaItem.month == higherThresholdData.month && dataSumaItem.day <= higherThresholdData.day)))
      {
        listResult.add(listaPuncteData[index]);
      }
      else if (((dataSumaItem.year == lowerThresholdData.year) && (dataSumaItem.month == lowerThresholdData.month) && (dataSumaItem.day >= lowerThresholdData.day))
      && ((dataSumaItem.year < higherThresholdData.year) 
                  || (dataSumaItem.year == higherThresholdData.year && dataSumaItem.month < higherThresholdData.month)
                  || (dataSumaItem.year == higherThresholdData.year && dataSumaItem.month == higherThresholdData.month  && dataSumaItem.day <= higherThresholdData.day)))
      {
        listResult.add(listaPuncteData[index]);
      }
    }  

    return listResult; 
  }
}

class PunctItem {
  
  final double suma;
  final DateTime dataSuma;
  
  PunctItem({required this.suma, required this.dataSuma});

}