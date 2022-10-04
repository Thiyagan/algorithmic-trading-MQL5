//+------------------------------------------------------------------+
//|                                                 CheckSystem7.mq5 |
//|                              Spencer Luck and Thiyagan Marimuthu |
//+------------------------------------------------------------------+

// Trading strategy 7 entry signals

string CheckSys7()
{
string Sys7Signal ="";
      // ATR
      static int HandleAtr = iATR(_Symbol,PERIOD_CURRENT,14);
      double AtrArray[];
      CopyBuffer(HandleAtr,0,1,2,AtrArray);
      ArraySetAsSeries(AtrArray,true);
      //DiDi Index 
      static int handleDiDi = iCustom(_Symbol,PERIOD_CURRENT,"DidiIndex",0,2,0,0,3,9,15);
      //DiDi Fast line
      double FastDiDiArray[];
      CopyBuffer(handleDiDi,0,1,2,FastDiDiArray);
      ArraySetAsSeries(FastDiDiArray,true);
      //DiDi Slow Line
      double SlowDiDiArray[];
      CopyBuffer(handleDiDi,2,1,2,SlowDiDiArray);
      ArraySetAsSeries(SlowDiDiArray,true); 
      // ASA
      static int HandleASA = iCustom(_Symbol,PERIOD_CURRENT,"absolute_strength_-_averages",0,14,5,5,0,5); 
      double BullsArray[];
      double BearsArray[];
      CopyBuffer(HandleASA,0,1,2,BullsArray);
      CopyBuffer(HandleASA,1,1,2,BearsArray);
      ArraySetAsSeries(BullsArray,true);
      ArraySetAsSeries(BearsArray,true);
      // Getting the close price of candle
      double CloseArray[];
      CopyClose(_Symbol,PERIOD_CURRENT,1,2,CloseArray);
      ArraySetAsSeries(CloseArray,true);
      //Modified Explosion 
      static int handleWAD = iCustom(_Symbol,PERIOD_CURRENT,"Modified_Explosion",3,90,15,30,15,2,0);
      //waddah - MACD
      double MACDWADarray[];
      CopyBuffer(handleWAD,0,1,2,MACDWADarray);
      ArraySetAsSeries(MACDWADarray,true);      
      //waddah - Signal Line
      double SLWADarray[];
      CopyBuffer(handleWAD,2,1,2,SLWADarray);
      ArraySetAsSeries(SLWADarray,true);  
      //waddah - Dead Zone Pip
      double DZPWADarray[];
      CopyBuffer(handleWAD,3,1,2,DZPWADarray);
      ArraySetAsSeries(DZPWADarray,true);
      //iAnchmom
      static int HandleIANCH = iCustom(_Symbol,PERIOD_CURRENT,"ianchmom",34,20,0,0); 
      double IANCHArray[];
      CopyBuffer(HandleIANCH,0,1,2,IANCHArray);
      ArraySetAsSeries(IANCHArray,true);
      
     //Conditins
     bool WaddahVol = (MACDWADarray[0] > SLWADarray[0] && MACDWADarray [0] > DZPWADarray[0]);
     bool ASA_buy = (BullsArray[0] > BearsArray[0] && BullsArray[1] < BearsArray[1]);
     bool ASA_sell = (BullsArray[0] < BearsArray[0] && BullsArray[1] > BearsArray[1]);
     bool AnotherComboBuy = ((FastDiDiArray[0] > SlowDiDiArray[0] && FastDiDiArray[1] < SlowDiDiArray[1]) && ASA_buy && IANCHArray[0] > 0);
     bool AnotherComboSell = ((FastDiDiArray[0] < SlowDiDiArray[0] && FastDiDiArray[1] > SlowDiDiArray[1]) && ASA_sell && IANCHArray[0] < 0); 
     
      if (AnotherComboBuy && WaddahVol)
      {
      Print("System 7 is now long");
      Sys7Signal="Buy";
      }
      
      if (AnotherComboSell && WaddahVol)
      {
      Print("System 7 is now short");
      Sys7Signal="Sell";
      }
      
      return(Sys7Signal);
     
     

}
