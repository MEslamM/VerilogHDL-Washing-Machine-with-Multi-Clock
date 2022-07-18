///NOTE: its more preferable to view this code in "sublime text" application for more organized and comfortable look to the eye:)
//for the sake of time i decreased values of frequancy,Fillig Water time,Washing time,Rinsing time,Spinning time;
//so that i can test code and assure its correct functionality

module Washing_Machine(clk,rst_n,clk_freq,coin_in,double_wash,timer_pause,wash_done); 

	input clk,rst_n,coin_in,double_wash,timer_pause; 
	input [1:0] clk_freq;

	output reg wash_done ;

///states///

	parameter Idle=3'b000; 
	parameter Fillig_Water=3'b001; 
	parameter Washing=3'b010; 
	parameter Rinsing=3'b011; 
	parameter Spinning=3'b100; 
	

	reg[2:0] cs,ns;

	reg[34:0] Fillig_Water_time,Washing_time,Rinsing_time,Spinning_time,freq; //noumber of cycles for each state (filling water,washing,rising,spining)
	
	reg[34:0] count; //for delay in each cycle

	reg[34:0] count2; //for timerpause spin cycle
	
	reg[4:0] double_cycle = 5'b00000; //for the getway from looping between washing and rinsing more than 2 times (doublewash)

	reg outtpspin=0;



		always@(cs or coin_in or double_wash or timer_pause or clk_freq or count or double_cycle or count2) 

			begin 

///////////////////////determining number of cycles of each operation according to clk_freq input by user/////////////////////////

				if (clk_freq == 2'b00)  //for the sake of time i decreased values of frequancy,Fillig Water time,Washing time,Rinsing time,Spinning time;
										//so that i can test code and assure its correct functionality.

					begin
						freq=1;
						Fillig_Water_time=5*freq;
						Washing_time=4*freq;
						Rinsing_time=3*freq;
						Spinning_time=2*freq;
					end

				else if(clk_freq == 2'b01)

					begin
						freq=2*(10^6);
						Fillig_Water_time=120*freq;
						Washing_time=300*freq;
						Rinsing_time=120*freq;
						Spinning_time=60*freq;
					end

				else if(clk_freq == 2'b10)

					begin
						freq=4*(10^6);
						Fillig_Water_time=120*freq;
						Washing_time=300*freq;
						Rinsing_time=120*freq;
						Spinning_time=60*freq;
					end

				else if(clk_freq == 2'b11)

					begin
						freq=8*(10^6);
						Fillig_Water_time=120*freq;
						Washing_time=300*freq;
						Rinsing_time=120*freq;
						Spinning_time=60*freq;
					end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////next state and output logic//////////////////////////////////////////////////

				case(cs)

					Idle:

						if(coin_in==1 && timer_pause==0 && count<Spinning_time && count2==0) //for normal flow

							begin 
								ns=Fillig_Water; 
								wash_done=0;
							end 
//-------------------------------------------------------------------------------------------------------------------------------------------------//
						else if(coin_in==1 && timer_pause==0 && count==(Spinning_time+1) && count2==0) //3=2spin+1 //for output after spin 

							begin 
								ns=cs; 
								wash_done=1;
							end 
//-------------------------------------------------------------------------------------------------------------------------------------------------//
						else if(coin_in==1 && timer_pause==0 && count==(Spinning_time+1) && outtpspin==1) //3=2spin+1 //for output for timerpause

							begin 
								ns=cs; 
								wash_done=1;
							end 
//-------------------------------------------------------------------------------------------------------------------------------------------------//
						else if(coin_in==1 && timer_pause==1) //wait for timerpause flag to deassert

							begin 
								ns=cs; 
								wash_done=0;
							end 

						else if(coin_in==1 && timer_pause==0 && count2>1 && outtpspin==0) //timerpause flag is deassert

							begin 
								ns=Spinning; 
								wash_done=0;
								count2=0;
								count=count-1;
							end
//-------------------------------------------------------------------------------------------------------------------------------------------------//
						else if (coin_in==0) //no input by user

							begin 
								ns=cs; 
								wash_done=0;
							end 

					Fillig_Water: 

						if (coin_in==1 && count==(Fillig_Water_time+1)) //6=5fill+1 as counter shifted

							begin
								ns<=Washing;
								wash_done=0;
								count=0;
							end

						else if (coin_in==1 && count<(Fillig_Water_time+1))//6=5fill+1 as counter shifted //for time duration of filling water time state

							begin
								ns<=cs;
								wash_done=0;
							end

					Washing:

						if(coin_in==1 && double_wash==0 && count==Washing_time) //no double wash

							begin 
								ns<=Rinsing;
								wash_done=0;
								count=0;
							end
//--------------------------------------------------------------------------------------------------------------------------------------------//
						else if(coin_in==1 && double_wash==1 && count==Washing_time) //for doublewash

							begin
								ns<=Rinsing;
								wash_done=0;
								double_cycle=double_cycle+1;
								count=0;
							end 
//--------------------------------------------------------------------------------------------------------------------------------------------//
						else if(coin_in==1 && count<Washing_time) //for time duration of washing time state

							begin
								ns<=cs;
								wash_done=0;
							end

					Rinsing: 

						if(coin_in==1 && double_wash==0 && count==Rinsing_time) //no double wash 

							begin 
								ns<=Spinning;
								wash_done=0;
								count=0;
							end
//--------------------------------------------------------------------------------------------------------------------------------------------//
						else if (coin_in==1 && double_wash==1 && count==Rinsing_time && double_cycle!=3) //for doublewash

							begin
								ns<=Washing;
								wash_done=0;
								double_cycle=double_cycle+1;
								count=0;
							end 

						else if (coin_in==1 && double_wash==1 && count==Rinsing_time && double_cycle==3) //move to spin after double wash is done

							begin
								ns<=Spinning;
								wash_done=0;
								count=0;
							end
//-------------------------------------------------------------------------------------------------------------------------------------------------//
						else if(coin_in==1 && count<Rinsing_time) //for time duration of rinsing time state

							begin 
								ns=cs; 
								wash_done=0; 
							end 
 

					Spinning: 

						if(coin_in==1 && timer_pause==0 && count==Spinning_time) //go to idle and then dispaly output
							 
							begin 
								ns=Idle;
								wash_done=0;
							end

						else if (coin_in==1 && timer_pause==0 && count<Spinning_time) //for time duration of spining time state

							begin 
								ns=cs; 
								wash_done=0; 
								outtpspin=1;
							end 
//-------------------------------------------------------------------------------------------------------------------------------------------------//
						else if (coin_in==1 && timer_pause==1) //timepause flag is asserted so,machine stops working and go to idle 

							begin
								ns=Idle;
								wash_done=0;
							end

//-------------------------------------------------------------------------------------------------------------------------------------------------//

					default: ns=Idle; 
						

				endcase
			end 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////state memory/////////////////////////////////////////////////////////

		always@(posedge clk or negedge rst_n) 

			begin 

				if (~rst_n) 
					cs<=Idle; 

				else
					cs<=ns;	
						
			end 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////Counter for delay in cycles(operation time for filling,washing,rinsing,spin)////////////////////

		always@(posedge clk)

			begin

	  			if (~rst_n) 
	  				count <=0;

	    		else if (timer_pause==0 && rst_n==1) begin
	    			count <= count + 1;	
	    		end 

	    		else if (timer_pause==1 && rst_n==1) begin
	    			count <= count;	
	    		end

    		end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////Counter2 for delay in cycles(operation time for spin when timerpause is asserted)////////////////////

		always@(posedge clk)

			begin

	  			if (~rst_n && timer_pause==0) 
	  				count2 <=0;

	    		else 
	    			count2 <= count2 + 1;

    		end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule