//+------------------------------------------------------------------+
//|                                           TradeControlScript.mq5 |
//|                              Spencer Luck and Thiyagan Marimuthu |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
// System 1
#include "CheckSystem1.mq5"
#include "CheckSystem1Exit.mq5"
// System 2
#include "CheckSystem2.mq5"
#include "CheckSystem2Exit.mq5"
// System 3
#include "CheckSystem3.mq5"
#include "CheckSystem3Exit.mq5"
// System 4
#include "CheckSystem4.mq5"
#include "CheckSystem4Exit.mq5"
#include "CheckSystem4AML.mq5"
// System 5
#include "CheckSystem5.mq5"
#include "CheckSystem5Exit.mq5"
// System 6
#include "CheckSystem6JMA.mq5"
// System 7
#include "CheckSys7.mq5"
// System 8
#include "CheckSystem8.mq5"

// Check symbol base
#include "CheckSymbolBase.mq5"
// Check symbol profit
#include "CheckSymbolProfit.mq5"


CTrade trade;
CPositionInfo pos_info;
CDealInfo m_deal; 

// Position modifier count
int positionmodifiercount = 0;

// Init position count
int initpositioncount = 0;

// Current symbol base pair
string SymbolBase = SymbolInfoString(_Symbol,SYMBOL_CURRENCY_BASE);

// Current symbol profit pair
string SymbolProfit = SymbolInfoString(_Symbol,SYMBOL_CURRENCY_PROFIT);

// Currency exposure risk
double ExposureLimit = 0.045;

// Optimization
input int Opt_allow = 1;

int OnInit()
{
      // Checking for open positions   
      double askp = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      
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
      
      if(Buy_opened || Sell_opened){
         Alert("Positions already open");
         Print("Positions already open, setting init_position_count == 1");
         initpositioncount += 1;   
      }

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{

}

void OnTick()
{

// Executed on tick
//---------------------------------------------------------------------------------------//
      // Checking for open positions by EA magic number (trade identifier)
      // System 1
      bool AS1_buy_opened=false;  
      bool AS1_sell_opened=false;
      // System 2
      bool AS2_buy_opened=false;  
      bool AS2_sell_opened=false;
      // System 3
      bool AS3_buy_opened=false;
      bool AS3_sell_opened=false;
      // System 4
      bool AS4_buy_opened=false;  
      bool AS4_sell_opened=false;
      // System5
      bool AS5_buy_opened=false;  
      bool AS5_sell_opened=false;
      // System6
      bool AS6_buy_opened=false;
      bool AS6_sell_opened=false;
      // System7
      bool AS7_buy_opened=false;
      bool AS7_sell_opened=false;
      // System8
      bool AS8_buy_opened=false;
      bool AS8_sell_opened=false;

      if(PositionSelect(_Symbol)==true){
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY){
         
            if(PositionGetInteger(POSITION_MAGIC)==001){
               AS1_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==002){
               AS2_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==003){
               AS3_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==004){
               AS4_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==005){
               AS5_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==006){
               AS6_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==007){
               AS7_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==008){
               AS8_buy_opened=true;
            } 
                       
         }
         else if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL){
         
            if(PositionGetInteger(POSITION_MAGIC)==001){
               AS1_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==002){
               AS2_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==003){
               AS3_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==004){
               AS4_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==005){
               AS5_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==006){
               AS6_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==007){
               AS7_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==008){
               AS8_sell_opened=true;
            } 
                                        
         }
      }

//---------------------------------------------------------------------------------------//
      
      // Checking trailing stops for systems with trailing stops (1, 3, 5, 6)
      
      // Average true range
      static int HandleATR = iATR(_Symbol, PERIOD_CURRENT,14);
      double ATRArray[];
      CopyBuffer(HandleATR,0,1,2,ATRArray);
      ArraySetAsSeries(ATRArray,true);
      
      // System 1. Current open positions1 relates to system 1's open positions.
      int current_open_positions1 = CountOpenPositions(001);

      if(AS1_buy_opened && current_open_positions1 == 1)
        {
         double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
         CheckTrailingStopBuyZero(Ask,001);
        }

      if(AS1_sell_opened && current_open_positions1 == 1)
        {
         double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
         CheckTrailingStopSellZero(Bid,001);
        }
      // System 3. Current open positions3 relates to system 3's open positions.
      int current_open_positions3 = CountOpenPositions(003);
          
      if (current_open_positions3 == 0 && positionmodifiercount == 1)
         {
            positionmodifiercount -= 1 ;
         }
             
      if(AS3_buy_opened && current_open_positions3 == 1)
        {
         double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
         double AtrFactor = NormalizeDouble(ATRArray[0] * 1,_Digits);
         CheckTrailingStopBuy(Ask,AtrFactor,003);
        }
      
      if(AS3_sell_opened && current_open_positions3 == 1)
        {
         double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
         double AtrFactor = NormalizeDouble(ATRArray[0] * 1,_Digits);
         CheckTrailingStopSell(Bid,AtrFactor,003);
        }      
      // System 5. Current open positions5 relates to system 5's open positions.
      int current_open_positions5 = CountOpenPositions(005);
          
      if (current_open_positions5 == 0 && positionmodifiercount == 1)
         {
            positionmodifiercount -= 1 ;
         }
             
      if(AS5_buy_opened && current_open_positions5 == 1)
        {
         double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
         double AtrFactor = NormalizeDouble(ATRArray[0] * 1,_Digits);
         CheckTrailingStopBuy(Ask,AtrFactor,005);
        }
      
      if(AS5_sell_opened && current_open_positions5 == 1)
        {
         double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
         double AtrFactor = NormalizeDouble(ATRArray[0] * 1,_Digits);
         CheckTrailingStopSell(Bid,AtrFactor,005);
        }

      int current_open_positions6 = CountOpenPositions(006);
      // System 6. Current open positions6 relates to system 6's open positions.
      if(AS6_buy_opened && current_open_positions6 == 1)
        {
         double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
         CheckTrailingStopBuyZero(Ask,006);
        }

      if(AS1_sell_opened && current_open_positions1 == 1)
        {
         double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
         CheckTrailingStopSellZero(Bid,006);
        }



// Executed on formation of a new bar
//---------------------------------------------------------------------------------------//


   // Restrict code to process only once per bar
   static datetime timestamp;
   datetime time = iTime(_Symbol,PERIOD_CURRENT,0); // Time of current candle
   if(timestamp != time)
   {
      timestamp = time;
      
      
     if(initpositioncount == 0)
     {
      
      CheckSystem1();
      CheckSystem1Exit();
      
      CheckSystem2();
      CheckSystem2Exit();
      
      CheckSystem3();
      CheckSystem3Exit();
      
      CheckSystem4();
      CheckSystem4Exit();
      CheckSystem4AML();
      
      CheckSystem6JMA();
      
      CheckSystem5();
      CheckSystem5Exit();
      
      CheckSys7();    
      CheckSystem8();
         
      
           
      // Average true range
      static int HandleAtr = iATR(_Symbol,PERIOD_CURRENT,14);
      double AtrArray[];
      CopyBuffer(HandleAtr,0,1,2,AtrArray);
      ArraySetAsSeries(AtrArray,true);

//---------------------------------------------------------------------------------------//

      // Checking for open positions by EA magic number
      // System 1
      bool S1_buy_opened=false;  
      bool S1_sell_opened=false;
      // System 2
      bool S2_buy_opened=false;  
      bool S2_sell_opened=false;
      // System 3
      bool S3_buy_opened=false;
      bool S3_sell_opened=false;
      // System 4
      bool S4_buy_opened=false;  
      bool S4_sell_opened=false;
      // System5
      bool S5_buy_opened=false;  
      bool S5_sell_opened=false;
      // System6
      bool S6_buy_opened=false;
      bool S6_sell_opened=false;
      // System7
      bool S7_buy_opened=false;
      bool S7_sell_opened=false;
      // System8
      bool S8_buy_opened=false;
      bool S8_sell_opened=false;

      if(PositionSelect(_Symbol)==true){
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY){
         
            if(PositionGetInteger(POSITION_MAGIC)==001){
               S1_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==002){
               S2_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==003){
               S3_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==004){
               S4_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==005){
               S5_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==006){
               S6_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==007){
               S7_buy_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==008){
               S8_buy_opened=true;
            } 
                       
         }
         else if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL){
         
            if(PositionGetInteger(POSITION_MAGIC)==001){
               S1_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==002){
               S2_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==003){
               S3_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==004){
               S4_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==005){
               S5_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==006){
               S6_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==007){
               S7_sell_opened=true;
            }
            if(PositionGetInteger(POSITION_MAGIC)==008){
               S8_sell_opened=true;
            } 
                                        
         }
      }
      
//---------------------------------------------------------------------------------------//      
      // Exiting positions
      // System 1
      if(S1_buy_opened && (CheckSystem1Exit()=="Buy Exit" || CheckSystem1()=="Sell"))
      {
         CloseAllPositions(001);
      }
      
      if(S1_sell_opened && (CheckSystem1Exit()=="Sell Exit" || CheckSystem1()=="Buy"))
      {
         CloseAllPositions(001);
      }
      
      // System 2
      if(S2_buy_opened && (CheckSystem2Exit()=="Buy Exit" || CheckSystem2()=="Sell"))
      {
         CloseAllPositions(002);
      }
      
      if(S2_sell_opened && (CheckSystem2Exit()=="Sell Exit" || CheckSystem2()=="Buy"))
      {
         CloseAllPositions(002);
      }
      
      // System 3
      if(S3_sell_opened && (CheckSystem3()=="Buy" || CheckSystem3Exit()=="Buy Exit"))
      {
         CloseAllPositions(003);
      }
      if(S3_buy_opened && (CheckSystem3()=="Sell" || CheckSystem3Exit()=="Sell Exit"))
      {
         CloseAllPositions(003);
      }
      
      // System 4   
      if(S4_buy_opened && (CheckSystem4Exit()=="Buy Exit" || CheckSystem4()=="Sell"))
      {
         CloseAllPositions(004);
      }
      
      if(S4_sell_opened && (CheckSystem4Exit()=="Sell Exit" || CheckSystem4()=="Buy"))
      {
         CloseAllPositions(004);
      }
      
      // System 5
      if(S5_buy_opened && (CheckSystem5Exit()=="Buy Exit" || CheckSystem5()=="Sell"))
      {
         CloseAllPositions(005);
      }
      
      if(S5_sell_opened && (CheckSystem5Exit()=="Sell Exit" || CheckSystem5()=="Buy"))
      {
         CloseAllPositions(005);
      }
      
      // System 6
      if(S6_buy_opened && (CheckSystem1Exit()=="Buy Exit" || CheckSystem6JMA()=="Sell"))
      {
         CloseAllPositions(006);
      }
      
      if(S6_sell_opened && (CheckSystem1Exit()=="Sell Exit" || CheckSystem6JMA()=="Buy"))
      {
         CloseAllPositions(006);
      }
      
      // System 7   
      if(S7_buy_opened && (CheckSys7()=="Sell"))
      {
         CloseAllPositions(007);
      }
      
      if(S7_sell_opened && (CheckSys7()=="Buy"))
      {
         CloseAllPositions(007);
      } 
      
      // System 8   
      if(S8_buy_opened && (CheckSystem8()=="Sell"))
      {
         CloseAllPositions(008);
      }
      
      if(S8_sell_opened && (CheckSystem8()=="Buy"))
      {
         CloseAllPositions(008);
      } 
                   
     
             
//---------------------------------------------------------------------------------------//

      // System 1
      // Buy orders
      if(CheckSystem1()=="Buy")
      {
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double AtrFactorSl = AtrArray[0] * 1;
         double AtrFactorTP = AtrArray[0] * 0.67;
         double AtrFactorTP2 = AtrArray[0] * 1;
         double sl = ask - AtrFactorSl;
         double tp = ask + AtrFactorTP;
         double tp2 = ask + AtrFactorTP2;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Acc_risk2 = AccountInfoDouble(ACCOUNT_BALANCE) * 0.005;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Volume2 = Acc_risk2/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         double Lots2 = NormalizeDouble(Volume2,2);
         // Exposure control
         double SystemRisk = 0.015;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_BUY);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         double SellProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + SellProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(001);
            trade.Buy(Lots,_Symbol,ask,sl,tp,"System 1 Buy: 1st Trade");
            trade.Buy(Lots2,_Symbol,ask,sl,tp2,"System 1 Buy: 2nd Trade");
         }  
      }
      
      
      
      
      // Sell orders
      if(CheckSystem1()=="Sell")
      {
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double AtrFactorSl = AtrArray[0] * 1;
         double AtrFactorTP = AtrArray[0] * 0.67;
         double AtrFactorTP2 = AtrArray[0] * 1;
         double sl = bid + AtrFactorSl;
         double tp = bid - AtrFactorTP;
         double tp2 = bid - AtrFactorTP2;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Acc_risk2 = AccountInfoDouble(ACCOUNT_BALANCE) * 0.005;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Volume2 = Acc_risk2/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         double Lots2 = NormalizeDouble(Volume2,2);
         // Exposure control
         double SystemRisk = 0.015;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_SELL);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         double BuyProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + BuyProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(001);
            trade.Sell(Lots,_Symbol,bid,sl,tp,"System 1 Sell: 1st Trade");
            trade.Sell(Lots2,_Symbol,bid,sl,tp2,"System 1 Sell: 2nd Trade");  
         } 
         
      }
      
 
       
//---------------------------------------------------------------------------------------//
      
      // System 2
      // Buy orders
      if(CheckSystem2()=="Buy")
      {
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = ask - AtrFactorSl; 
         double tp = ask + AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_BUY);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         double SellProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + SellProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(002);
            trade.Buy(Lots,_Symbol,ask,sl,tp,"System 2 Buy");  
         } 
         
      }
      
      // Sell orders
      if(CheckSystem2()=="Sell")
      {
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = bid + AtrFactorSl; 
         double tp = bid - AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_SELL);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         double BuyProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + BuyProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(002);
            trade.Sell(Lots,_Symbol,bid,sl,tp,"System 2 Sell");  
         } 
         
      }
//---------------------------------------------------------------------------------------//
      
      // System 3
      // Buy orders
      if(CheckSystem3()=="Buy")
      {
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = ask - AtrFactorSl; 
         double tp = ask + AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Acc_risk2 = AccountInfoDouble(ACCOUNT_BALANCE) * 0.005;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Volume2 = Acc_risk2/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         double Lots2 = NormalizeDouble(Volume2,2);
         // Exposure control
         double SystemRisk = 0.015;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_BUY);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         double SellProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + SellProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(003); 
            trade.Buy(Lots,_Symbol,ask,sl,tp,"System 3 Buy: 1st Trade");
            trade.Buy(Lots2,_Symbol,ask,sl,NULL,"System 3 Buy: 2nd Trade");  
         } 
         
      }
      
      // Sell orders
      if(CheckSystem3()=="Sell")
      {
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = bid + AtrFactorSl; 
         double tp = bid - AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Acc_risk2 = AccountInfoDouble(ACCOUNT_BALANCE) * 0.005;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Volume2 = Acc_risk2/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         double Lots2 = NormalizeDouble(Volume2,2);
         // Exposure control
         double SystemRisk = 0.015;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_SELL);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         double BuyProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + BuyProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(003);
            trade.Sell(Lots,_Symbol,bid,sl,tp,"System 3 Sell: 1st Trade");
            trade.Sell(Lots2,_Symbol,bid,sl,NULL,"System 3 Sell: 2nd Trade"); 
         } 
         
      }       
//---------------------------------------------------------------------------------------//
      
      // System 4
      // Buy orders AML
      if(CheckSystem4AML()=="AML Buy")
      {
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = ask - AtrFactorSl; 
         double tp = ask + AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_BUY);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         double SellProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + SellProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(004);
            trade.Buy(Lots,_Symbol,ask,sl,tp,"System 4 AML Buy"); 
         } 
         
      }

      // Sell orders AML
      if(CheckSystem4AML()=="AML Sell")
      {
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = bid + AtrFactorSl; 
         double tp = bid - AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_SELL);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         double BuyProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + BuyProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(004);
            trade.Sell(Lots,_Symbol,bid,sl,tp,"System 4 AML Sell");  
         } 
         
      }
      
//---------------------------------------------------------------------------------------//
      
      // System 5
      // Buy orders
      if(CheckSystem5()=="Buy")
      {
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = ask - AtrFactorSl; 
         double tp = ask + AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Acc_risk2 = AccountInfoDouble(ACCOUNT_BALANCE) * 0.005;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Volume2 = Acc_risk2/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         double Lots2 = NormalizeDouble(Volume2,2);
         // Exposure control
         double SystemRisk = 0.015;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_BUY);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         double SellProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + SellProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(005); 
            trade.Buy(Lots,_Symbol,ask,sl,tp,"System 5 Buy: 1st Trade");
            trade.Buy(Lots2,_Symbol,ask,sl,NULL,"System 5 Buy: 2nd Trade");  
         } 
         
      }
      
      // Sell orders
      if(CheckSystem5()=="Sell")
      {
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = bid + AtrFactorSl; 
         double tp = bid - AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Acc_risk2 = AccountInfoDouble(ACCOUNT_BALANCE) * 0.005;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Volume2 = Acc_risk2/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         double Lots2 = NormalizeDouble(Volume2,2);
         // Exposure control
         double SystemRisk = 0.015;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_SELL);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         double BuyProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + BuyProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(005);
            trade.Sell(Lots,_Symbol,bid,sl,tp,"System 5 Sell: 1st Trade");
            trade.Sell(Lots2,_Symbol,bid,sl,NULL,"System 5 Sell: 2nd Trade");  
         } 
         
      }


//---------------------------------------------------------------------------------------//      
      // System 6
      // Buy orders JMA
      if(CheckSystem6JMA()=="Buy")
      {
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double AtrFactorSl = AtrArray[0] * 1;
         double AtrFactorTP = AtrArray[0] * 0.67;
         double sl = ask - AtrFactorSl;
         double tp = ask + AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         
         double Lots = NormalizeDouble(Volume,2);
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_BUY);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         double SellProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + SellProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(006);
            trade.Buy(Lots,_Symbol,ask,sl,tp,"System 1 JMA Buy");
         } 
         
      }
      
      // Sell orders JMA
      if(CheckSystem6JMA()=="Sell")
      {
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double AtrFactorSl = AtrArray[0] * 1;
         double AtrFactorTP = AtrArray[0] * 0.67;
         double sl = bid + AtrFactorSl;
         double tp = bid - AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_SELL);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         double BuyProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + BuyProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(006);
            trade.Sell(Lots,_Symbol,bid,sl,tp,"System 1 JMA Sell");  
         } 
         
      } 

//---------------------------------------------------------------------------------------//
      
      // System 7
      // Buy orders
      if(CheckSys7()=="Buy")   
      {
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = ask - AtrFactorSl; 
         double tp = ask + AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_BUY);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         double SellProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + SellProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(007);
            trade.Buy(Lots,_Symbol,ask,sl,tp,"System 7 Buy");  
         }  
         
         
      }
      // Sell orders
      if(CheckSys7()=="Sell")
      {
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double AtrFactorSl = AtrArray[0] * 1.5;
         double AtrFactorTP = AtrArray[0] * 1;
         double sl = bid + AtrFactorSl; 
         double tp = bid - AtrFactorTP;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_SELL);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         double BuyProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + BuyProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
            trade.SetExpertMagicNumber(007);  
            trade.Sell(Lots,_Symbol,bid,sl,tp,"System 7 Sell"); 
         } 
       
      
      }
//---------------------------------------------------------------------------------------//
      
      // System 8
      // Buy orders
      if(CheckSystem8() == "Buy") 
      {
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double AtrFactorSl = AtrArray[0] * 1;
         double AtrFactorTP = AtrArray[0] * 0.67;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         double sl = ask - AtrFactorSl;
         double tp = ask + AtrFactorTP;
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_BUY);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
         double SellProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
          
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + SellProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
           trade.SetExpertMagicNumber(008);
           trade.Buy(Lots,_Symbol,ask,sl,tp,"System 8 Buy");   
         } 
       

                
      }
      // Sell orders
      if(CheckSystem8() == "Sell")
      {
         double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double AtrFactorSl = AtrArray[0] * 1;
         double AtrFactorTP = AtrArray[0] * 0.67;
         double Acc_risk = AccountInfoDouble(ACCOUNT_BALANCE) * 0.01;
         double Volume = Acc_risk/(AtrFactorSl/Point());
         double Lots = NormalizeDouble(Volume,2);
         double sl = bid + AtrFactorSl;
         double tp = bid - AtrFactorTP;
         // Exposure control
         double SystemRisk = 0.01;
         double BasePairExposure = CheckSymbolBase(SymbolBase, ORDER_TYPE_SELL);
         double TotalBasePairExposure = SystemRisk + BasePairExposure;
         double ProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_SELL);
         double BuyProfitPairExposure = CheckSymbolProfit(SymbolProfit, ORDER_TYPE_BUY);
          
         double TotalProfitPairExposure = SystemRisk + ProfitPairExposure;
         if((TotalProfitPairExposure + BuyProfitPairExposure) < ExposureLimit && TotalBasePairExposure < ExposureLimit)
         {
           trade.SetExpertMagicNumber(008);
           trade.Sell(Lots,_Symbol,bid,sl,tp,"System 8 Sell");    
         } 
       
      
      }
   
   }
   
  // If there are positions open, counter is reset and above code is not run   
   if(initpositioncount == 1)
      {
      Print("Counter reset");
      initpositioncount -= 1;
      }
        
  }
  
}
//---------------------------------------------------------------------------------------//

// FUNCTIONS //


//+------------------------------------------------------------------+
//| Close All Positions                                              |
//+------------------------------------------------------------------+

void CloseAllPositions(ulong Magic)
  {

// Count down until there are no positions left
   for(int i = PositionsTotal()-1; i>=0; i--)
     {
        string symbol=PositionGetSymbol(i); // get the symbol of the position
        if(_Symbol == symbol)
        {
            if(PositionGetInteger(POSITION_MAGIC)==Magic)
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
//| Count Open Positions                                             |
//+------------------------------------------------------------------+
int CountOpenPositions(ulong Magic)
   {
   
      int NumberOfOpenPositions = 0;
      
      for(int i = PositionsTotal()-1; i>=0; i--)
      {
         string CurrencyPair = PositionGetSymbol(i);
         
         if(Symbol()==CurrencyPair)
         {
            if(PositionGetInteger(POSITION_MAGIC)==Magic)
            {
               NumberOfOpenPositions = NumberOfOpenPositions + 1;
            }     
         }
      }

      return NumberOfOpenPositions;      

   } 


//+------------------------------------------------------------------+
//| Check Buy Trailing Stop                                                                |
//+------------------------------------------------------------------+
void CheckTrailingStopBuy(double ask, double AtrFactor, ulong Magic)
  {

// set the stop loss to 150 points
   double SL=NormalizeDouble(ask-AtrFactor,_Digits);

// go through all positions
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      string symbol=PositionGetSymbol(i); // get the symbol of the position


      if(_Symbol == symbol) // if the current symbol of the pair is equal
        {
         if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY)
           {
                  
               if(PositionGetInteger(POSITION_MAGIC)==Magic)
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
                     CloseAllPositions(Magic);
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
    }


//+------------------------------------------------------------------+
//| Check Sell Trailing Stop                                                                  |
//+------------------------------------------------------------------+
void CheckTrailingStopSell(double bid, double AtrFactor, ulong Magic)
  {

// set the stop loss to ATR points
   double SL=NormalizeDouble(bid+AtrFactor,_Digits);

// go through all positions
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      string symbol=PositionGetSymbol(i); // get the symbol of the position


      if(_Symbol == symbol) // if the current symbol of the pair is equal
        {
            
            if(PositionGetInteger(POSITION_MAGIC)==Magic)
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
                        CloseAllPositions(Magic);
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
  }


//+------------------------------------------------------------------+
//| Check Buy Trailing Stop to zero                                  |
//+------------------------------------------------------------------+
// Moving stop loss to a zero position only
void CheckTrailingStopBuyZero(double ask, ulong Magic)
  {


// go through all positions
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      string symbol=PositionGetSymbol(i); // get the symbol of the position


      if(_Symbol == symbol) // if the current symbol of the pair is equal
        {
         if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY)
           {
           
           if(PositionGetInteger(POSITION_MAGIC)==Magic)
            {
               // get the ticket number
               ulong PositionTicket = PositionGetInteger(POSITION_TICKET);
   
               // get position open price
               double PositionOpen = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),_Digits);
   
               // calculate the current stop loss
               double CurrentStopLoss = PositionGetDouble(POSITION_SL);
               
               double TP = PositionGetDouble(POSITION_TP);
               
               // Assume a min of 2pips. Run SymbolInfoInteger(SYMBOL_TRADE_STOPS_LEVEL) other brokers 
               double MinTradeStops = 20*_Point;
                  
      
               // Check if stop loss is too close to price or if price has moved back past the open price
               if((ask - PositionOpen) <= MinTradeStops || ask < PositionOpen)
                 {
                  CloseAllPositions(Magic);
                 }  
                  
                  
               else
                  {
                     // move stop loss to open price, therefore zero loss
                     if(CurrentStopLoss < PositionOpen)
                       {
                        trade.PositionModify(PositionTicket,PositionOpen,TP);
                        
                       }
   
                  }
                      
           }
         }
       }
     }
   }


//+------------------------------------------------------------------+
//| Check Sell Trailing Stop to Zero                                 |  
//+------------------------------------------------------------------+
// Moving the stop loss to a zero position only
void CheckTrailingStopSellZero(double bid, ulong Magic)
  {


// go through all positions
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      string symbol=PositionGetSymbol(i); // get the symbol of the position


      if(_Symbol == symbol) // if the current symbol of the pair is equal
        {

         if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL)
           {
           
           if(PositionGetInteger(POSITION_MAGIC)==Magic)
            {
               // get the ticket number
               ulong PositionTicket = PositionGetInteger(POSITION_TICKET);
   
               // get position open price
               double PositionOpen = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN),_Digits);
   
               // calculate the current stop loss
               double CurrentStopLoss = PositionGetDouble(POSITION_SL);
               
               double TP = PositionGetDouble(POSITION_TP);
               
               // Assume a min of 2pips. Run SymbolInfoInteger(SYMBOL_TRADE_STOPS_LEVEL) other brokers 
                double MinTradeStops = 20*_Point;
                  
      
               // Check if stop loss is too close to price or if price has moved back past the open price
               if((PositionOpen - bid) <= MinTradeStops || bid > PositionOpen)
                 {
                     CloseAllPositions(Magic);
                 }
   
               
               else
                  {
               
                  // move stop loss to open price, therefore zero loss
                  if(CurrentStopLoss > PositionOpen)
                    {
                    //Print(CurrentStopLoss);
                     trade.PositionModify(PositionTicket,PositionOpen,TP);
                     
                    }
   
                  }
 
           }
           
         }
       }
     }
   }


//+------------------------------------------------------------------+

