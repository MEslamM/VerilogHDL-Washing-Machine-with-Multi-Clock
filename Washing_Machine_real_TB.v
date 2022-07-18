`timescale 1ns/1ns

module Washing_Machine_real_tb();

  reg rst_n,clk,coin_in,double_wash,timer_pause;
  reg [1:0]clk_freq;

  wire wash_done;

  integer k; // its used as due to limit of the # which is 32bit

  integer x=0; // used for looping on bits of clk_freq to simulate four cases
  integer y=0; // used for looping on bits of clk_freq to simulate four cases
  

  Washing_Machine_real J1(clk,rst_n,clk_freq,coin_in,double_wash,timer_pause,wash_done);


///////////////////////////////clock generation////////////////////////////////////////////////

  initial begin

    clk = 0;
    clk_freq='b00;

    forever begin

      if (clk_freq=='b00) begin //1MHz
        #500 clk = ~clk;
      end
      else if (clk_freq=='b01) begin //2MHz
        #250 clk = ~clk;
      end
      else if (clk_freq=='b10) begin //4MHz
        #125 clk = ~clk;
      end
      else if (clk_freq=='b11) begin //8MHz
        #62.5 clk = ~clk;

      end

    end

  end

////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////testing////////////////////////////////////////////////////////

initial begin
rst_n=0;
coin_in=0;
double_wash=0;
timer_pause=0;
clk_freq='b00;
#500

/////////////////////////////////////////the time for each operation///////////////////////////////////////////

for (x = 0; x < 2; x=x+1) begin // the following nested loops to cover all cases of clk_freq

  for (y = 0; y < 2; y=y+1) begin

      clk_freq[1]=x;
      clk_freq[0]=y;

      rst_n='b1;
      coin_in='b1;
      double_wash='b0;
      timer_pause='b0; 
      
      for (k=0;k<10000;k=k+1) begin // for 10 mins
        #65000010; //Total number of delays  (60min_to_sec)*(10^6Hz)*(10min)*(2)*(500clk)
      end

    
/////////////////////////////////////////the double wash case///////////////////////////////////////////
    
    rst_n=0;
    coin_in=0;
    #500

    rst_n='b1;
    coin_in='b1;
    double_wash='b1;

    for (k=0;k<100000;k=k+1) begin //for 17 mins 
      #12200010;
    end
 
 ///////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////timer pause/////////////////////////////////////////////////////
    rst_n=0;
    coin_in=0;
    double_wash=0;
    #500 

    rst_n='b1;
    coin_in='b1;
    timer_pause='b0;

    for (k=0;k<10000;k=k+1) begin //9.5 mins timerpasue=0
      #57000010;
    end

    timer_pause='b1; //timerpause=1

    for (k=0;k<10000;k=k+1) begin // timerpause=1 and stays for 2min
      #12000000;
    end

    timer_pause='b0;//timerpause=0

    for (k=0;k<10000;k=k+1) begin
      #6000000;
    end

  end

end
//////////////////////////////////////////////////////////////////////////////////////////////////

end
////////////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule