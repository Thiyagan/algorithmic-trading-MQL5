//+------------------------------------------------------------------+
//|                                             Trading System 1.mq5 |
//+------------------------------------------------------------------+

// Importing files to use methods
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include "TradingSys1Conditions.mq5"

int OnInit()
  {

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {

   
  }

void OnTick()
  {
// Restrict code to process only once per bar
   static datetime timestamp;
   datetime time = iTime(_Symbol,PERIOD_CURRENT,0); // Time of current candle
   if(timestamp != time)
     {
      timestamp = time;
   
// Do we have positions open already
      bool Buy_opened=false;  // variable to hold the result of Buy opened position
      bool Sell_opened=false; // variables to hold the result of Sell opened position

      if(PositionSelect(_Symbol)==true)
        {
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
            Buy_opened=true;  //It is a Buy
           }
         else
            if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
              {
               Sell_opened=true; // It is a Sell
              }
        }
// Managing positions, modifying second trade (moving SL)
// Checking how many positions are open

      int current_open_positions = PositionsTotal(); 
       
      if (current_open_positions == 0 && positionmodifiercount == 1)
      {
      positionmodifiercount -= 1 ;
      }
       
      if(Buy_opened && current_open_positions == 1)
        {
         double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
         CheckTrailingStopBuy(Ask,20);
        }

      if(Sell_opened && current_open_positions == 1)
        {
         double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
         CheckTrailingStopSell(Bid,20);
        }        
//Exiting Positions 
      if(Buy_opened && (WaddahExit || RocBuyExit) )
        {
         if(pos_info.Symbol()==Symbol())
            CloseAllPositions();
        }
      if(Sell_opened && (WaddahExit || RocSellExit) )
        {
         if(pos_info.Symbol()==Symbol())
            CloseAllPositions();
        }                        
//Placing Buy Orders                          
                  if (BuyCounterTotal >=2 && BuyVolConditions && BuyParabolic)
                  {
                     Print("Trading System 1 indicates a Buy signal");
                  // Closing open sell positions
                           if(Sell_opened)
                             {
                              if(pos_info.Symbol()==Symbol())
                                 trade.PositionClose(pos_info.Ticket());
                             }
                           double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
                           double AtrFactorSl = AtrArray[0] * 1.3;
                           double AtrFactorTP = AtrArray[0] * 1.3;
                           double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
                           double Volume = Acc_risk/(AtrFactorSl/Point());
                           double Lots = NormalizeDouble(Volume,2);
                           double sl = ask - AtrFactorSl;
                           double tp = ask + AtrFactorTP;
                           trade.Buy(Lots,_Symbol,ask,sl,tp,"Buy1");
                           trade.Buy(Lots,_Symbol,ask,sl,NULL,"Buy2");
                  }
//Placing Sell Orders                  
                  if (SellCounterTotal >=2 && SellVolConditions && SellParabolic)
                  {
                     Print("Trading System 1 indicates a Sell signal");
                  // Closing open buy positions
                           if(Buy_opened)
                             {
                              if(pos_info.Symbol()==Symbol())
                                 trade.PositionClose(pos_info.Ticket());
                             }
                  
                           double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
                           double AtrFactorSl = AtrArray[0] * 1.3;
                           double AtrFactorTP = AtrArray[0] * 1.3;
                           double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
                           double Volume = Acc_risk/(AtrFactorSl/Point());
                           double Lots = NormalizeDouble(Volume,2);
                           double sl = bid + AtrFactorSl;
                           double tp = bid - AtrFactorTP;
                           trade.Sell(Lots,_Symbol,bid,sl,tp,"Sell1");
                           trade.Sell(Lots,_Symbol,bid,sl,NULL,"Sell2");
                  }
             
   
   }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTrailingStopBuy(double ask, double Pips)
  {

// set the stop loss to 150 points
   double Pip = Pips * _Point * 10;
   double SL=NormalizeDouble(ask-Pip,_Digits);

// go through all positions
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      string symbol=PositionGetSymbol(i); // get the symbol of the position


      if(_Symbol == symbol) // if the current symbol of the pair is equal
        {
         if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY)
           {
            // get the ticket number
            ulong PositionTicket = PositionGetInteger(POSITION_TICKET);

            // get position open price
            double PositionOpen = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),_Digits);

            // calculate the current stop loss
            double CurrentStopLoss = PositionGetDouble(POSITION_SL);
            
            // Assume a min of 2pips. Run SymbolInfoInteger(SYMBOL_TRADE_STOPS_LEVEL) other brokers 
            double MinTradeStops = 20*_Point;
               
   
            // Check if stop loss is too close to price or if price has moved back past the open price
            if((ask - PositionOpen) <= MinTradeStops || ask < PositionOpen)
              {
               CloseAllPositions();
              }  
               
               
            else
               {
                  // move stop loss to open price, therefore zero loss
                  if(CurrentStopLoss < PositionOpen && positionmodifiercount == 0)
                    {
                     trade.PositionModify(PositionTicket,PositionOpen,NULL);
                     
                    }
                  // if current stop loss is more than 150 points
                  if(CurrentStopLoss < SL && positionmodifiercount == 1)
                    {
                     // move the stop loss
                     trade.PositionModify(PositionTicket,SL,NULL);
                    }
                    
                  if(positionmodifiercount == 0){
                     positionmodifiercount += 1;
                    }

               }
               
           }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTrailingStopSell(double bid, double Pips)
  {

// set the stop loss to ATR points
   double Pip = Pips * _Point * 10;
   double SL=NormalizeDouble(bid+Pip,_Digits);

// go through all positions
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      string symbol=PositionGetSymbol(i); // get the symbol of the position


      if(_Symbol == symbol) // if the current symbol of the pair is equal
        {

         if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL)
           {
            // get the ticket number
            ulong PositionTicket = PositionGetInteger(POSITION_TICKET);

            // get position open price
            double PositionOpen = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),_Digits);

            // calculate the current stop loss
            double CurrentStopLoss = PositionGetDouble(POSITION_SL); //works
            
            // Assume a min of 2pips. Run SymbolInfoInteger(SYMBOL_TRADE_STOPS_LEVEL) other brokers 
             double MinTradeStops = 20*_Point;
               
   
            // Check if stop loss is too close to price or if price has moved back past the open price
            if((PositionOpen - bid) <= MinTradeStops || bid > PositionOpen)
              {
                  CloseAllPositions();
              }

            
            else
               {
            
               // move stop loss to open price, therefore zero loss
               if(CurrentStopLoss > PositionOpen && positionmodifiercount == 0)
                 {
                 //Print(CurrentStopLoss);
                  trade.PositionModify(PositionTicket,PositionOpen,NULL);
                  
                 }
               // if current stop loss is more than ATR points
               if(CurrentStopLoss > SL && positionmodifiercount == 1)
                 {
                  // move the stop loss
                  trade.PositionModify(PositionTicket,SL,NULL);
                 }
                 
               if(positionmodifiercount == 0){
                 positionmodifiercount += 1;
                 }

               }
 
           }
        }
     }
  }


     
void CloseAllPositions()
  {

// Count down until there are no positions left
   for(int i = PositionsTotal()-1; i>=0; i--)
     {
     string symbol=PositionGetSymbol(i); // get the symbol of the position
     if(_Symbol == symbol)
     
     { 
      // Get the position number
      ulong ticket = PositionGetTicket(i);

      // Close the position
      trade.PositionClose(ticket);
      }
     }


  }
       


  }

//+------------------------------------------------------------------+