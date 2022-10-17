//+------------------------------------------------------------------+
//|                                             CheckSystem4Exit.mq5 |
//|                              Spencer Luck and Thiyagan Marimuthu |
//+------------------------------------------------------------------+

// Trading strategy 4 exit signals 

string CheckSystem4Exit()
{

   string Sys4ExitSignal = "";
        
   // Indicators // 
   // ATR
   static int HandleAtr = iATR(_Symbol, PERIOD_CURRENT,14);
      double AtrArray[];
      CopyBuffer(HandleAtr,0,1,2,AtrArray);
      ArraySetAsSeries(AtrArray,true);

   // QQE
   static int HandleQQE = iCustom(_Symbol,PERIOD_CURRENT,"QQE",5,50,false,false,false);
      double RSIArray[];
      double SmoothArray[];
      CopyBuffer(HandleQQE,0,1,2,RSIArray);
      CopyBuffer(HandleQQE,1,1,2,SmoothArray);
      ArraySetAsSeries(RSIArray,true);
      ArraySetAsSeries(SmoothArray,true);
     
              
   // Trinity Impulse
   static int HandleTrinity = iCustom(_Symbol,PERIOD_CURRENT,"trinity-impulse",30,34,MODE_LWMA,PRICE_WEIGHTED,VOLUME_TICK);
      double TrinityArray[];
      CopyBuffer(HandleTrinity,0,1,2,TrinityArray);
      ArraySetAsSeries(TrinityArray,true);
         
         
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
      //waddah - color
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
         
   // AML
   static int HandleAML = iCustom(_Symbol,PERIOD_CURRENT,"AML",7,6,0);
      double AMLArray[];
      CopyBuffer(HandleAML,0,1,2,AMLArray);
      ArraySetAsSeries(AMLArray,true);
         
   // Close price
   double CloseArray[];
   CopyClose(_Symbol,PERIOD_CURRENT,1,3,CloseArray);
   ArraySetAsSeries(CloseArray,true);

   
    // Buy conditions
    bool QQE_buy_signal = (RSIArray[0] > SmoothArray[0] && RSIArray[1] < SmoothArray[1]);

            
    // Sell conditions
    bool QQE_sell_signal = (RSIArray[0] < SmoothArray[0] && RSIArray[1] > SmoothArray[1]);

    

   // Trade exit signals //
   // Buy exit
   if(QQE_sell_signal)
   {
      Print("System 4 Buy Exit Signal");
      Sys4ExitSignal = "Buy Exit";
   }
   
   // Sell exit
   if(QQE_buy_signal)
   {
      Print("System 4 Sell Exit Signal");
      Sys4ExitSignal = "Sell Exit";
   }

   return (Sys4ExitSignal);
   
}