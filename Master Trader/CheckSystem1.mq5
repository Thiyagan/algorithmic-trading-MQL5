//+------------------------------------------------------------------+
//|                                                 CheckSystem1.mq5 |
//|                              Spencer Luck and Thiyagan Marimuthu |
//+------------------------------------------------------------------+

// Trading strategy 1 entry signals

string CheckSystem1()
{
   string Sys1Signal = "";


   // Indicators //
   // ATR
   static int HandleAtr = iATR(_Symbol, PERIOD_CURRENT,14);
      double AtrArray[];
      CopyBuffer(HandleAtr,0,1,2,AtrArray);
      ArraySetAsSeries(AtrArray,true);


   // Aroon
   static int HandleAroon = iCustom(_Symbol,PERIOD_CURRENT,"aroon",9,0);
      double BearsAroonArray[];
      double BullsAroonArray[];
      CopyBuffer(HandleAroon,0,1,2,BearsAroonArray);
      CopyBuffer(HandleAroon,1,1,2,BullsAroonArray);
      ArraySetAsSeries(BearsAroonArray,true);
      ArraySetAsSeries(BullsAroonArray,true);

   // FVE
   static int HandleFVE = iCustom(_Symbol,PERIOD_CURRENT,"FVE",22,0,22,0);
      double FVEArray[];
      double SignalArray[];
      CopyBuffer(HandleFVE,0,1,2,FVEArray);
      CopyBuffer(HandleFVE,1,1,2,SignalArray);
      ArraySetAsSeries(FVEArray,true);
      ArraySetAsSeries(SignalArray,true);

   //Waddah Attar Explosion
   static int handleWAD = iCustom(_Symbol,PERIOD_CURRENT,"waddah_attar_explosion",20,40,20,2,150,3000,15,15,false,500,false,false,false,false);
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
      // waddah - color   
      double ColorArray[];
      CopyBuffer(handleWAD,1,1,2,ColorArray);
      ArraySetAsSeries(ColorArray,true);
      

   // Universal Oscillator
   static int HandleUO = iCustom(_Symbol,PERIOD_CURRENT,"universaloscillator",3,14);
      double Value1Array[];
      double Value2Array[];
      CopyBuffer(HandleUO,0,1,2,Value1Array);
      CopyBuffer(HandleUO,1,1,2,Value2Array);
      ArraySetAsSeries(Value1Array,true);
      ArraySetAsSeries(Value2Array,true);

   // JMA
   static int HandleJMA = iCustom(_Symbol,PERIOD_CURRENT,"ATR adaptive JMA",14,0,PRICE_CLOSE);
      double JMAArray[];
      CopyBuffer(HandleJMA,0,1,2,JMAArray);
      ArraySetAsSeries(JMAArray,true);
      

   // Getting the close price of candle
   double CloseArray[];
   CopyClose(_Symbol,PERIOD_CURRENT,1,2,CloseArray);
   ArraySetAsSeries(CloseArray,true);


   // Buy conditions
   bool Aroon_buy_signal = (BearsAroonArray[0] > BullsAroonArray[0] && BearsAroonArray[1] < BullsAroonArray[1]);
   bool FVE_buy = (FVEArray[0] > SignalArray[0]);
   bool UO_buy = (Value1Array[0] > Value2Array[0]);
   bool JMA_buy = (CloseArray[0] > JMAArray[0]);

   // Volume condition
   bool Wad_vol = (MACDWADarray[0] > SLWADarray[0] && MACDWADarray [0] > DZPWADarray[0]);

   // Sell conditions
   bool Aroon_sell_signal = (BearsAroonArray[0] < BullsAroonArray[0] && BearsAroonArray[1] > BullsAroonArray[1]);
   bool FVE_sell = (FVEArray[0] < SignalArray[0]);
   bool UO_sell = (Value1Array[0] < Value2Array[0]);
   bool JMA_sell = (CloseArray[0] < JMAArray[0]);
   

   // Trade entry signals //
   // Buy signal
   if(Aroon_buy_signal && FVE_buy && Wad_vol && UO_buy && JMA_buy)
   {
      Print("System 1 Buy Signal");
      Sys1Signal = "Buy";
   }
   
   // Sell signal
   if(Aroon_sell_signal && FVE_sell && Wad_vol && UO_sell && JMA_sell)
   {
      Print("System 1 Sell Signal");
      Sys1Signal = "Sell";
   }
   

   return (Sys1Signal);

   
}