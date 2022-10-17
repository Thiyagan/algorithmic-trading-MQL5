//+------------------------------------------------------------------+
//|                                             CheckSystem2Exit.mq5 |
//|                              Spencer Luck and Thiyagan Marimuthu |
//+------------------------------------------------------------------+

// Trading strategy 2 exit signals 

string CheckSystem2Exit()
{
   string Sys2ExitSignal = "";


   // Indicators //
   // ATR
   static int HandleAtr = iATR(_Symbol, PERIOD_CURRENT,14);
      double AtrArray[];
      CopyBuffer(HandleAtr,0,1,2,AtrArray);
      ArraySetAsSeries(AtrArray,true);

   // Std Dev
   static int HandleSTD = iStdDev(_Symbol,PERIOD_CURRENT,7,0,MODE_SMA,PRICE_CLOSE);
      double STDArray[];
      CopyBuffer(HandleSTD,0,1,2,STDArray);
      ArraySetAsSeries(STDArray,true);
         
         
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
         
         
   // FVE
   static int HandleFVE = iCustom(_Symbol,PERIOD_CURRENT,"FVE",20,0,20,0); 
      double FVEArray[];
      double FSignalArray[];
      CopyBuffer(HandleFVE,0,1,2,FVEArray);
      CopyBuffer(HandleFVE,1,1,2,FSignalArray);
      ArraySetAsSeries(FVEArray,true);
      ArraySetAsSeries(FSignalArray,true);
         
         
   // Solar winds
   static int HandleSolar = iCustom(_Symbol,PERIOD_CURRENT,"Solar Winds",1,0,15,15); 
      double SolarArray[];
      CopyBuffer(HandleSolar,0,1,2,SolarArray);
      ArraySetAsSeries(SolarArray,true);
               
    
   // Getting the close price of candle
   double CloseArray[];
   CopyClose(_Symbol,PERIOD_CURRENT,1,2,CloseArray);
   ArraySetAsSeries(CloseArray,true);


   // Buy conditions
   bool Trinity_buy = (TrinityArray[0] > 0 && TrinityArray[1] < 0);


   // Sell conditions
   bool Trinity_sell = (TrinityArray[0] < 0 && TrinityArray[1] > 0);


   // Trade Exit signals //
   // Buy exit signal
   if(Trinity_sell)
   {
      Print("System 2 Buy Exit Signal");
      Sys2ExitSignal = "Buy Exit";
   }
   
   // Sell exit signal
   if(Trinity_buy)
   {
      Print("System 2 Sell Exit Signal");
      Sys2ExitSignal = "Sell Exit";
   }
   
   
   return (Sys2ExitSignal);

}
