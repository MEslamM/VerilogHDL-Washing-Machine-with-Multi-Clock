module Washing_Machine_tb();
	reg clk,rst_n,coin_in,double_wash,timer_pause;
	reg [1:0] clk_freq;

	wire wash_done;

	Washing_Machine V1(clk,rst_n,clk_freq,coin_in,double_wash,timer_pause,wash_done);

///////////////////////////////////////clock generation/////////////////////////////////////////

  initial begin
    clk = 0;
    clk_freq = 2'b00;
    forever begin
    	if(clk_freq == 2'b00) begin
    		#1 clk=~clk;   //simple case for test insted of #500 (1MHz) that is required in PDF
    	end

   	 else if(clk_freq == 2'b01) begin
    		#250 clk=~clk;
			end

    else if(clk_freq == 2'b10) begin
    		#125 clk=~clk;
    	end

    else if(clk_freq == 2'b11) begin
    		#62.5 clk=~clk;
    	end
    end  
  end
/////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////reset and initial values for inputs////////////////////////////////////

  initial begin //here i tested that 1)each operation takes its specifed time 2)double wash is on 3)timer pause is on
	    rst_n = 0;
	    coin_in = 0;
	    double_wash = 0;
	    timer_pause = 0;
	    clk_freq = 2'b00;

    #9
    rst_n = 1 ; coin_in = 1;double_wash = 1; 

    #40
    timer_pause = 1;

    #6
    timer_pause = 0;

    $stop;
  end

/////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////Test monitor and results//////////////////////////////////////////////
	  initial begin

	    $monitor(" clk = %b,rst_n = %b, coin_in = %b, double_wash = %b, timer_pause = %b,clk_freq = %b, wash_done = %b"
	    	, clk, rst_n, coin_in, double_wash, timer_pause, clk_freq, wash_done);

	  end

/////////////////////////////////////////////////////////////////////////////////////////////////

endmodule