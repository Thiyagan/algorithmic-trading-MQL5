//+------------------------------------------------------------------+
//|                                                 CheckSystem5.mq5 |
//|                              Spencer Luck and Thiyagan Marimuthu |
//+------------------------------------------------------------------+

// Trading strategy 5 entry signals 

string CheckSystem5()
{
   string Sys5Signal = "";
   
   // Indicator inputs //
   int QQE_smooth_factor = 5;
   int Trinity_period = 30;
   int Trinity_smooth = 34;
   int Wad_fast_MA = 20;
   int Wad_slow_MA = 40;
   int Wad_bollinger = 20;
   int Wad_bollinger_dev = 2;
   int Wad_sens = 150;
   int Wad_DZP = 3000;
   int UO_Oscillator = 3;
   int UO_period = 14;

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


   // Buy conditions
   bool QQE_buy_signal = (RSIArray[0] > SmoothArray[0] && RSIArray[1] < SmoothArray[1]);
   bool Trinity_buy = (TrinityArray[0] > 0);
   bool UO_buy = (Value1Array[0] > Value2Array[0]);
      
      
   // Volume conditions
   bool Wad_vol_buy = (MACDWADarray[0] > SLWADarray[0] && MACDWADarray [0] > DZPWADarray[0] && ColorArray[0] == 1.0);
   bool Wad_vol_sell = (MACDWADarray[0] > SLWADarray[0] && MACDWADarray [0] > DZPWADarray[0] && ColorArray[0] == 2.0);

            
   // Sell conditions
   bool QQE_sell_signal = (RSIArray[0] < SmoothArray[0] && RSIArray[1] > SmoothArray[1]);
   bool Trinity_sell = (TrinityArray[0] < 0);
   bool UO_sell = (Value1Array[0] < Value2Array[0]);


   // Trade entry signals //
   // Buy signal
   if(QQE_buy_signal && Trinity_buy && Wad_vol_buy && UO_buy)
   {
      Print("System 5 Buy Signal");
      Sys5Signal = "Buy";
   }
   
   // Sell signal
   if(QQE_sell_signal && Trinity_sell && Wad_vol_sell && UO_sell)
   {
      Print("System 5 Sell Signal");
      Sys5Signal = "Sell";
   }
   

   return (Sys5Signal);

   
}