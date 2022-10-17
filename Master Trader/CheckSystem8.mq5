//+------------------------------------------------------------------+
//|                                                 CheckSystem8.mq5 |
//|                              Spencer Luck and Thiyagan Marimuthu |
//+------------------------------------------------------------------+

// Trading strategy 8 entry signals

string CheckSystem8()
{

   string Sys8Signal="";

         // ATR
      static int HandleAtr = iATR(_Symbol, PERIOD_CURRENT,14);
         double AtrArray[];
         CopyBuffer(HandleAtr,0,1,2,AtrArray);
         ArraySetAsSeries(AtrArray,true);

      // SSL
      static int HandleSSL = iCustom(_Symbol,PERIOD_CURRENT,"SSL_Channel_Chart",3,20); 
         double SSLBearArray[];
         double SSLBullArray[];
         double SSLArray[];
         CopyBuffer(HandleSSL,0,1,2,SSLBearArray);
         CopyBuffer(HandleSSL,1,1,2,SSLBullArray);
         CopyBuffer(HandleSSL,2,1,2,SSLArray);
         ArraySetAsSeries(SSLBearArray,true);
         ArraySetAsSeries(SSLBullArray,true);
         ArraySetAsSeries(SSLArray,true);
         
         
      // FVE
      static int HandleFVE = iCustom(_Symbol,PERIOD_CURRENT,"FVE",22,0,22,0); 
         double FVEArray[];
         double SignalArray[];
         CopyBuffer(HandleFVE,0,1,2,FVEArray);
         CopyBuffer(HandleFVE,1,1,2,SignalArray);
         ArraySetAsSeries(FVEArray,true);
         ArraySetAsSeries(SignalArray,true);
         
         
      // ROC
      static int HandleROC = iCustom(_Symbol,PERIOD_CURRENT,"ROC",18);
         double ROCArray[];
         CopyBuffer(HandleROC,0,1,2,ROCArray);
         ArraySetAsSeries(ROCArray,true);
      
      // ASA
      static int HandleASA = iCustom(_Symbol,PERIOD_CURRENT,"absolute_strength_-_averages",0,14,5,5,0,0); 
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
   
         // Buy conditions
      bool SSL_buy_signal = (SSLArray[0] > 0 && SSLArray[1] < 0);
      bool FVE_buy = (FVEArray[0] > SignalArray[0]);
      bool ROC_buy = (ROCArray[0] > 0);
      bool ASA_buy = (BullsArray[0] > BearsArray[0]);

      
      // Sell conditions
      bool SSL_sell_signal = (SSLArray[0] < 0 && SSLArray[1] > 0);
      bool FVE_sell = (FVEArray[0] < SignalArray[0]);
      bool ROC_sell = (ROCArray[0] < 0);
      bool ASA_sell = (BullsArray[0] < BearsArray[0]);
      
      if (SSL_buy_signal && FVE_buy && ROC_buy && ASA_buy)
      {
      Print("System 8 is now long");
      Sys8Signal="Buy";
      }
      
      if (SSL_sell_signal && FVE_sell && ROC_sell && ASA_sell)
      {
      Print("System 8 is now short");
      Sys8Signal="Sell";
      }
      
      return(Sys8Signal);
      
      
}
