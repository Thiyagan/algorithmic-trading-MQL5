//+------------------------------------------------------------------+
//|                                Trading System 1 - Conditions.mq5 |
//+------------------------------------------------------------------+

// Importing files to use methods
// Importing files to use methods
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>


// Object CTrade as trade
CTrade trade;
// Object CPositionInfo as pos_info
CPositionInfo pos_info;
input ENUM_MA_METHOD SSL_mode=MODE_EMA;
void OnTick()
  {
//ATR
      static int HandleAtr = iATR(_Symbol, PERIOD_CURRENT,14);
      double AtrArray[];
      CopyBuffer(HandleAtr,0,1,2,AtrArray);
      ArraySetAsSeries(AtrArray,true);    
//Volume and Volatility Indicators
//TDFI
      static int handleTDFI = iCustom(_Symbol,PERIOD_CURRENT,"Trend direction and force - DSEMA smoothed",6,0,0.3,0.3);
      double TDFIarray[];
      CopyBuffer(handleTDFI,0,1,2,TDFIarray);
      ArraySetAsSeries(TDFIarray,true);
//VQZL
      static int handleVQZL = iCustom(_Symbol,PERIOD_CURRENT,"Volatility quality zero line",10,3,7.5);
      double VQZLarray[];
      CopyBuffer(handleVQZL,0,1,2,VQZLarray);
      ArraySetAsSeries(VQZLarray,true);
//ROC
      static int handleROC = iCustom(_Symbol,PERIOD_CURRENT,"roc",12);
      double ROCarray[];
      CopyBuffer(handleROC,0,1,2,ROCarray);
      ArraySetAsSeries(ROCarray,true);
//Chaikin
      static int handleChaikin = iChaikin(_Symbol,PERIOD_CURRENT,3,9,MODE_LWMA,VOLUME_TICK);
      double ChaikinArray[];
      CopyBuffer(handleChaikin,0,1,2,ChaikinArray);
      ArraySetAsSeries(ChaikinArray,true);
//MFI
      static int handleMFI = iMFI(_Symbol,PERIOD_CURRENT,9,VOLUME_TICK);
      double MFIarray[];
      CopyBuffer(handleMFI,0,1,2,MFIarray);
      ArraySetAsSeries(MFIarray,true);              
//Waddah - not sure on the settings 
      //Waddah Attar Explosion
      static int handleWAD = iCustom(_Symbol,PERIOD_CURRENT,"waddah_attar_explosion",90,15,30,3,150,400,15,150,false,2,false,false,false,false);
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
//Entry Indicators 
//MACD
      static int handleMACD = iMACD(_Symbol,PERIOD_CURRENT,9,30,6,0);
      //MACD
      double MACDarray[];
      CopyBuffer(handleMACD,0,1,2,MACDarray);
      ArraySetAsSeries(MACDarray,true);
      //MACD - signal 
      double SignalMACDarray[];
      CopyBuffer(handleMACD,1,1,2,SignalMACDarray);
      ArraySetAsSeries(SignalMACDarray,true);   
//AROON
      static int handleAroon = iCustom(_Symbol,PERIOD_CURRENT,"aroon",9,0);
      //Bears Aroon
      double BearsAroonArray[];
      CopyBuffer(handleAroon,0,1,2,BearsAroonArray);
      ArraySetAsSeries(BearsAroonArray,true);
      //Bulls Aroon
      double BullsAroonArray[];
      CopyBuffer(handleAroon,1,1,2,BullsAroonArray);
      ArraySetAsSeries(BullsAroonArray,true);   
//RVI
      static int handleRVI = iRVI(_Symbol,PERIOD_CURRENT,15);
      //RVI line
      double RVIarray[];
      CopyBuffer(handleRVI,0,1,2,RVIarray);
      ArraySetAsSeries(RVIarray,true);
      //RVI Signal line
      double SignalRVIarray[];
      CopyBuffer(handleRVI,1,1,2,SignalRVIarray);
      ArraySetAsSeries(SignalRVIarray,true);      
//Vertex Index
      static int handleVertex = iCustom(_Symbol,PERIOD_CURRENT,"Vertex_mod",12);
      double Vertexarray[];
      CopyBuffer(handleVertex,0,1,2,Vertexarray);
      ArraySetAsSeries(Vertexarray,true);
//DiDi Index 
      static int handleDiDi = iCustom(_Symbol,PERIOD_CURRENT,"DidiIndex",0,0,0,0,3,9,15);
      //DiDi Fast line
      double FastDiDiArray[];
      CopyBuffer(handleDiDi,0,1,2,FastDiDiArray);
      ArraySetAsSeries(FastDiDiArray,true);
      //DiDi Slow Line
      double SlowDiDiArray[];
      CopyBuffer(handleDiDi,2,1,2,SlowDiDiArray);
      ArraySetAsSeries(SlowDiDiArray,true);      
//SSL Channel 
      static int HandleSSL = iCustom(_Symbol,PERIOD_CURRENT,"SSL_Channel_Chart",SSL_mode,20); 
      //Bear
      double SSLArrayBear[];
      CopyBuffer(HandleSSL,0,1,2,SSLArrayBear);
      ArraySetAsSeries(SSLArrayBear,true);
      //Bull
      double SSLArrayBull[];
      CopyBuffer(HandleSSL,1,1,2,SSLArrayBull);
      ArraySetAsSeries(SSLArrayBull,true);
//Parabolic SAR -  
      static int handlePSAR = iSAR(_Symbol,PERIOD_CURRENT,0.02,0.2);
      double PSARarray[];
      CopyBuffer(handlePSAR,0,1,2,PSARarray);
      ArraySetAsSeries(PSARarray,true);

//Baseline Indicator 
//Otrend Kijunsen 
      static int handleOtrend = iCustom(_Symbol,PERIOD_CURRENT,"Kijun-Sen_alerts21o",60);
      double OtrendArray[];
      CopyBuffer(handleOtrend,0,1,2,OtrendArray);
      ArraySetAsSeries(OtrendArray,true);
      
// Getting the close price of candle
      double CloseArray[];
      CopyClose(_Symbol,PERIOD_CURRENT,1,2,CloseArray);
      ArraySetAsSeries(CloseArray,true);
          
//Volume Buy Conditions - all 6 need to agree
   bool BuyVolConditions = ( TDFIarray[0]>0.3 && ROCarray[0]>0 && (VQZLarray[0]>(_Point*10)) && ChaikinArray[0]>0 && MFIarray[0]>50 && MACDWADarray[0] > SLWADarray[0] && MACDWADarray [0] > DZPWADarray[0]);
//Volume Sell Conditions - all 6 need to agree
   bool SellVolConditions = (TDFIarray[0]<-0.3 && ROCarray[0]<0 && (VQZLarray[0]<-(_Point*10)) && ChaikinArray[0]<0 && MFIarray[0]<50 && MACDWADarray[0] > SLWADarray[0] && MACDWADarray [0] > DZPWADarray[0]);
// Waddah Exit Conditions 
   bool WaddahExit = MACDWADarray[0]<SLWADarray[0] && MACDWADarray[1]>SLWADarray[1];
   bool RocSellExit = ROCarray[1]<0 && ROCarray[0]>0;
   bool RocBuyExit = ROCarray[1]>0 && ROCarray[0]<0;
//Entry Buy Conditions 
   bool Buy_MACD = (MACDarray[0]>SignalMACDarray[0]);
   bool Buy_Aroon = (BearsAroonArray[1]<BullsAroonArray[1] && BearsAroonArray[0]>BullsAroonArray[0]);
   bool Buy_RVI = (RVIarray[1]<SignalRVIarray[1] && RVIarray[0]>SignalRVIarray[0]); 
   bool Buy_Vertex = (Vertexarray[0]>0 && Vertexarray[1]<0);
   bool Buy_DiDi = (SlowDiDiArray[1]>FastDiDiArray[1] && SlowDiDiArray[0]<FastDiDiArray[0]);
   bool Buy_SSL = (SSLArrayBear[1]>SSLArrayBull[1] && SSLArrayBear[0]<SSLArrayBull[0]);
//Entry Sell Conditions
   bool Sell_MACD = (MACDarray[0]<SignalMACDarray[0]);
   bool Sell_Aroon = (BearsAroonArray[1]>BullsAroonArray[1] && BearsAroonArray[0]<BullsAroonArray[0]);
   bool Sell_RVI = (RVIarray[1]<SignalRVIarray[1] && RVIarray[0]>SignalRVIarray[0]); 
   bool Sell_Vertex = (Vertexarray[0]<0 && Vertexarray[1]>0);
   bool Sell_DiDi = (SlowDiDiArray[1]<FastDiDiArray[1] && SlowDiDiArray[0]>FastDiDiArray[0]);
   bool Sell_SSL = (SSLArrayBear[1]<SSLArrayBull[1] && SSLArrayBear[0]>SSLArrayBull[0]);   
//Parabolic and Baseline - not sure how to do this part
   bool BuyParabolic = CloseArray[0] > PSARarray[0];
   bool SellParabolic = CloseArray[0] < PSARarray[0];
   bool BuyKijun = OtrendArray[0] < CloseArray[0]; //not being used
   bool SellKijun = OtrendArray[0] > CloseArray[0]; //not being used 
//Buy Counter total - 2 out of 6 conditions need to be met
      int BuyCounterTotal = 0;
   if (Buy_MACD)
   {
      BuyCounterTotal=BuyCounterTotal+1;
   }
   if (Buy_Aroon)
   {
      BuyCounterTotal=BuyCounterTotal+1;
   }
   if (Buy_RVI)
   {
      BuyCounterTotal=BuyCounterTotal+1;
   }
   if (Buy_Vertex)
   {
      BuyCounterTotal=BuyCounterTotal+1;
   }
   if (Buy_SSL)
   {
      BuyCounterTotal=BuyCounterTotal+1;
   }
   if (Buy_DiDi)
   {
      BuyCounterTotal=BuyCounterTotal+1;
   }
//Sell Counter total - 2 out of 6 conditions need to be met
      int SellCounterTotal = 0;
   if (Sell_MACD)
   {
      SellCounterTotal=SellCounterTotal+1;
   }
   if (Sell_Aroon)
   {
        SellCounterTotal=SellCounterTotal+1;
   }
   if (Sell_RVI)
   {
        SellCounterTotal=SellCounterTotal+1;
   }
   if (Sell_Vertex)
   {
        SellCounterTotal=SellCounterTotal+1;
   }
   if (Sell_SSL)
   {
        SellCounterTotal=SellCounterTotal+1;
   }
   if (Sell_DiDi)
   {
        SellCounterTotal=SellCounterTotal+1;
   }

   
  }
