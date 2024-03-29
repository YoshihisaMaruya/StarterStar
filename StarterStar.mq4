//+------------------------------------------------------------------+
//|                                                  StarterStar.mq4 |
//|              Copyright 2014,MaruyaIndustry Cop, Finance Departmen|
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, , MaruyaIndustry Cop, Finance Departmen"
#property link        "http://maruyaindustry.com"

input double Lots          =1;
input double TrailingStop  =30;
input double MACDOpenLevel =3;
input double MACDCloseLevel=2;
input int    MATrendPeriod =26;
input double TakeProfitSpan = 5;
input double StopLossSpan = 3;

int GordenCross = 1;
int DeadCross = 2;

int ID = 1111;

int MACD_Cross(void){
   double MacdCurrent,MacdPrevious;
   double SignalCurrent,SignalPrevious;
   double MaCurrent,MaPrevious;
   
   MacdCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   MacdPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   SignalCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   SignalPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   MaCurrent=iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,0);
   MaPrevious=iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,1);
   
         if(MacdCurrent<0 && MacdCurrent>SignalCurrent && MacdPrevious<SignalPrevious && 
         MathAbs(MacdCurrent)>(MACDOpenLevel*Point) && MaCurrent>MaPrevious)
         {
            return GordenCross;
         }
         
   else if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious && 
         MacdCurrent>(MACDOpenLevel*Point) && MaCurrent<MaPrevious)
         {
            return DeadCross;
         }
         else {
            return 0;
         }
}

void start(void)
  {
   int    cnt,ticket,total;
   int    cross_type;
//---
// initial data checks
// it is important to make sure that the expert works with a normal
// chart and the user did not make any mistakes setting external 
// variables (Lots, StopLoss, TakeProfit, 
// TrailingStop) in our case, we check TakeProfit
// on a chart of less than 100 bars
//---
   if(Bars<100)
     {
      Print("bars less than 100");
      return;
     }

  
   total=OrdersTotal();
   if(total<1)
     {
      //--- no opened orders identified
      if(AccountFreeMargin()<(1000*Lots))
        {
         Print("We have no money. Free Margin = ",AccountFreeMargin());
         return;
        }
        
        
      cross_type = MACD_Cross();

      //ORDER ROUTINE
      //IFDEF
      if(cross_type == GordenCross)
        {
         Print("Ask",Ask);
         double point = Ask - Bid;
         ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Bid-StopLossSpan*point,Bid+TakeProfitSpan*point,"StarterStar",ID,0,Green);
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
               Print("BUY order opened : ",OrderOpenPrice());
           }
         else
            Print("Error opening BUY order : ",GetLastError());
         return;
        }
      //--- check for short position (SELL) possibility
      if(cross_type == DeadCross)
        {
         
         ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Ask+StopLossSpan*point,Bid-TakeProfitSpan*point,"macd sample",ID,0,Red);
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
               Print("SELL order opened : ",OrderOpenPrice());
           }
         else
            Print("Error opening SELL order : ",GetLastError());
        }*/
      //--- exit from the "no opened orders" block
      return;
     }
//---
  }
//+------------------------------------------------------------------+
