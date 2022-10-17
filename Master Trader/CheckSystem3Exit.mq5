//+------------------------------------------------------------------+
//|                                             CheckSystem3Exit.mq5 |
//|                              Spencer Luck and Thiyagan Marimuthu |
//+------------------------------------------------------------------+

// Trading strategy 3 exit signals 

string CheckSystem3Exit()
{
   string Sys3ExitSignal = "";
   
   //Indicator Inputs
   // Inputs
    int FVE_period = 20;
    int FVE_method = 0;
    int Signal_line_period = 20;
    int Signal_line_method = 0;
    int Klinger_fast_period = 50;
    int Klinger_slow_period = 100;
    int Klinger_signal_period = 20;
    int Solar_npr = 1;
    int Solar_event = 0;
    int Solar_period = 15;
    int Solar_smooth = 15;
    
   // Indicators 
   // ATR
   static int HandleAtr = iATR(_Symbol, PERIOD_CURRENT,14);
      double AtrArray[];
      CopyBuffer(HandleAtr,0,1,2,AtrArray);
      ArraySetAsSeries(AtrArray,true);
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
   // FVE
   static int HandleFVE = iCustom(_Symbol,PERIOD_CURRENT,"FVE",FVE_period,FVE_method,Signal_line_period,Signal_line_method); 
      double FVEArray[];
      double FSignalArray[];
      CopyBuffer(HandleFVE,0,1,2,FVEArray);
      CopyBuffer(HandleFVE,1,1,2,FSignalArray);
      ArraySetAsSeries(FVEArray,true);
      ArraySetAsSeries(FSignalArray,true);
   // Klinger   
   static int HandleKlinger = iCustom(_Symbol,PERIOD_CURRENT,"Klinger Oscillator MT5 Indicator",Klinger_fast_period,Klinger_slow_period,Klinger_signal_period); 
      double KlingerArray[];
      double KSignalArray[];
      CopyBuffer(HandleKlinger,0,1,2,KlingerArray);
      CopyBuffer(HandleKlinger,1,1,2,KSignalArray);
      ArraySetAsSeries(KlingerArray,true);
      ArraySetAsSeries(KSignalArray,true);
   // Wajdyss
   static int HandleWaj = iCustom(_Symbol,PERIOD_CURRENT,"wajdyss_Ichimoku_Indicator",26,0);
      double WajArray[];
      CopyBuffer(HandleWaj,0,1,2,WajArray);
      ArraySetAsSeries(WajArray,true);
   // Solar winds
   static int HandleSolar = iCustom(_Symbol,PERIOD_CURRENT,"Solar Winds",Solar_npr,Solar_event,Solar_period,Solar_smooth); 
      double SolarArray[];
      CopyBuffer(HandleSolar,0,1,2,SolarArray);
      ArraySetAsSeries(SolarArray,true);
   // Getting the close price of candle
      double CloseArray[];
      CopyClose(_Symbol,PERIOD_CURRENT,1,2,CloseArray);
      ArraySetAsSeries(CloseArray,true);
      
   //Conditions
   bool Trinity_buy = (TrinityArray[0] > 0 && TrinityArray[1] < 0);
   bool Trinity_sell = (TrinityArray[0] < 0 && TrinityArray[1] > 0);
    
   bool Buy_Exit_Signal = Trinity_sell;
   bool Sell_Exit_Signal = Trinity_buy;
    
   //Trade Exit Signals
   // Buy exit signal
   if(Buy_Exit_Signal)
   {
      Print("System 3 Buy Exit Signal");
      Sys3ExitSignal = "Buy Exit";
   }
   
   // Sell exit signal
   if(Sell_Exit_Signal)
   {
      Print("System 3 Sell Exit Signal");
      Sys3ExitSignal = "Sell Exit";
   }


   return (Sys3ExitSignal);
}      