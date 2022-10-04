//+------------------------------------------------------------------+
//|                                             CheckSystem1Exit.mq5 |
//|                              Spencer Luck and Thiyagan Marimuthu |
//+------------------------------------------------------------------+

// Trading strategy 1 exit signals

string CheckSystem1Exit()
{
   string Sys1ExitSignal = "";


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
   // Buy conditions
   bool Aroon_buy_signal = (BearsAroonArray[0] > BullsAroonArray[0] && BearsAroonArray[1] < BullsAroonArray[1]);
   bool JMA_buy_signal = (CloseArray[0] > JMAArray[0] && CloseArray[1] < JMAArray[1]);


   // Sell conditions
   bool Aroon_sell_signal = (BearsAroonArray[0] < BullsAroonArray[0] && BearsAroonArray[1] > BullsAroonArray[1]);
   bool JMA_sell_signal = (CloseArray[0] < JMAArray[0] && CloseArray[1] > JMAArray[1]);
   

   // Trade exit entry signals //
   // Sell exit signal
   if(Aroon_buy_signal || JMA_buy_signal)
   {
      Print("System 1 Sell Exit Signal");
      Sys1ExitSignal = "Sell Exit";
   }
   
   // Buy exit signal
   if(Aroon_sell_signal || JMA_sell_signal)
   {
      Print("System 1 Buy Exit Signal");
      Sys1ExitSignal = "Buy Exit";
   }
   

   return (Sys1ExitSignal);

   
}
