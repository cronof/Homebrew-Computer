
`timescale 1ns / 1ps

module Process(PC,out,clk, rst);
input  clk, rst;
output PC; // Output for test bench 
output reg [7:0] out;  


// our cpu core parameters
parameter im_size = 8; // Up to 2^8 Instrunctions (Code Memory)
parameter rf_size = 4; // Up to 2^4 Registers (R0 - R15: Data Memory)
parameter opcode_size = 4; // 4 Bits Opcode Size
 
// State types
parameter s_fetch = 3'b000; // fetch
parameter s_decode = 3'b001; // decode 
parameter s_execute = 3'b010; // execute 
parameter s_store = 3'b011; // store
parameter s_nostore = 3'b100; // no store

// Mnemonic Op Codes
parameter LOAD = 4'b0001; 
parameter ADD = 4'b0100;
parameter SUB = 4'b0101;
parameter OR = 4'b0110;
parameter XOR = 4'b0111;
parameter BRA = 4'b1000; // branch to address in RB
parameter BRAZ = 4'b1001; // branch to address in RB, if RA is zero
parameter BRAL = 4'b1010; // branch to RB
parameter BRALZ = 4'b1011; // branch to RB, if RA is zero
parameter CALL = 4'b1100; // call; store PC into RD and jump to address in RB
parameter IN = 4'b1101;
parameter HALT = 4'b1110;
parameter OUT = 4'b1111;

reg [7:0] REGFILE[0: 2 ** rf_size -1]; // 8 Bit Register File
reg [7:0] W; // Accumulator

// PC and IR
reg [im_size-1 : 0] PC;
reg [opcode_size + (rf_size*3) -1 : 0] IR;

// State controlling register 
reg [2:0] current_state;
reg [2:0] next_state;

// An instruction contains Opcode and 3-register
// reg [4:0] operand;
reg [opcode_size-1 : 0] OPCODE;
reg [rf_size-1 : 0] RA; // left operand register address
reg [rf_size-1 : 0] RB; // right operand register address
reg [rf_size-1 : 0] RD; // destination register

//////////////////////////////////////////////////////////////////////////////////

wire [opcode_size + (rf_size*3) -1 : 0] IMEM_OUT;
test_mem IMEM(.clka(clk), .addra(PC),  .douta(IMEM_OUT));  // IMEM (instructionmemory)

// State Machine 
always @(posedge clk or posedge rst)
begin 
	if(rst)
		begin
			PC <= 0;
			RA <= 0;
			RB <= 0;
			RD <= 0;
			IR <= 0;
			current_state <= s_fetch;
		end
	else
begin
case(current_state)
	s_fetch: // fetch instruction
	begin
		IR <= IMEM_OUT;
		next_state <= s_decode;
	end
	
	s_decode: // increment PC and extract value from IR
	begin
		PC <= PC + 1;
		next_state <= s_execute;
		OPCODE <= IR[opcode_size + (rf_size*3) -1 : (rf_size*3)];
		RA <= IR[(rf_size*3) -1 : (rf_size*2)];
		RB <= IR[(rf_size*2) -1 : (rf_size)];
		RD <= IR[(rf_size) -1 : 0];
	end
	s_execute: // Check opcode and execute
	begin
		case (OPCODE)

		LOAD:// RD <- RA:RB
		begin
			W <= {RA, RB};
			next_state <= s_store;
		end
		ADD: // R[RD] <- R[RA] + R[RB]
		begin
			W <= REGFILE[RA] + REGFILE[RB];
			next_state <= s_store;
		end
		SUB: // R[RD] <- R[RA] - R[RB]
		begin
			W <= REGFILE[RA] - REGFILE[RB];
			next_state <= s_store;
		end
		
		OR: // R[RD] <- R[RA] | R[RB]
		begin
			W <= REGFILE[RA] | REGFILE[RB];
			next_state <= s_store;
		end
		
		XOR: // R[RD] <- R[RA] ^ R[RB]
		begin
			W <= REGFILE[RA] ^ REGFILE[RB];
			next_state <= s_store;
		end
		HALT:// Infinite loops
		begin
			next_state <= s_execute;
		end
		BRA: // Branch to R[RB]
		begin
			PC <= REGFILE[RB];
			next_state <= s_nostore;
		end
		BRAL:// Branch to RB
		begin
			PC <= RB;
			next_state <= s_nostore;
		end
		BRAZ:// Branch to R[RB], if R[RA] is zero
		begin
			if(REGFILE[RA] == 8'd0)
				PC <= REGFILE[RB];
				next_state <= s_nostore;
		end
		BRALZ: // Branch to RB if R[RA] is zero
		begin
			if(REGFILE[RA] == 8'd0) 
				PC <= RB;
				next_state <= s_nostore;
		end
		CALL:// store PC to RD and jump to RB
		begin
			W <= PC;
			PC <= RB;
			next_state <= s_store;
		end
		OUT: // out <- R[RA]
		begin
			out <= REGFILE[RA];
			next_state <= s_store;
		end
						
	// Bad instruction, DO NOTHING
	default: begin end
	endcase 
	end
////////////////////////////////////////////////////////////////////////////////////////

	s_store: // Store Accumulator W into R[RD]
	begin
		REGFILE[RD] <= W; 
		next_state  <= s_fetch;
	end
	s_nostore: // Don't need to store?, skip to fetch again
	begin
		next_state <= s_fetch;
	end
	// Bad state, DO NOTHING
	default: begin end
	endcase
	// Finally, go to next state
	current_state <= next_state;
	end
end
endmodule
