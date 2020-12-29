module datapath(
input logic clk, reset,
input logic memtoreg, pcsrc,
input logic alusrc, regdst,
input logic regwrite, jump,
input logic [2:0] alucontrol,
output logic zero,
output logic [31:0] pc,
input logic [31:0] instr,
output logic [31:0] aluout, writedata,
input logic [31:0] readdata);

logic [4:0] writereg;
logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
logic [31:0] signimm, signimmsh;
logic [31:0] srca, srcb;
logic [31:0] result;

// next PC logic
flopr #(32) pcreg(clk, reset, pcnext, pc);

adder pcadd1(pc, 32'b100, pcplus4);

sl2 immsh(signimm, signimmsh);

adder pcadd2(pcplus4, signimmsh, pcbranch);

mux2 #(32) pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);

mux2 #(32) pcmux(pcnextbr, {pcplus4[31:28], instr[25:0], 2'b00}, jump, pcnext);

// register file logic
regfile rf(clk, regwrite, instr[25:21], instr[20:16], writereg, result, srca, writedata);

mux2 #(5) wrmux(instr[20:16], instr[15:11], regdst, writereg);

mux2 #(32) resmux(aluout, readdata, memtoreg, result);

signext se(instr[15:0], signimm);

// ALU logic
mux2 #(32) srcbmux(writedata, signimm, alusrc, srcb);

alu alu(srca, srcb, alucontrol, aluout, zero);

module flopr #(parameter WIDTH = 8)
(input logic clk, reset,
input logic [WIDTH-1:0] d,
output logic [WIDTH-1:0] q);

always_ff @(posedge clk, posedge reset)
	if (reset) q <= 0;
	else q <= d;
endmodule



module mux2 #(parameter WIDTH = 8)
(input logic [WIDTH-1:0] d0, d1,
input logic s,
output logic [WIDTH-1:0] y);

	assign y = s ? d1 : d0;

endmodule

module signext(
input logic [15:0] a,
output logic [31:0] y);
	
	assign y = {{16{a[15]}}, a};

endmodule


module sl2(
input logic [31:0] a,
output logic [31:0] y);

	// shift left by 2
	assign y = {a[29:0], 2'b00};

endmodule


module adder(
input logic [31:0] a, b,
output logic [31:0] y);

	assign y = a + b;

endmodule


module alu(
input logic [31:0] srca, srcb,
input logic [2:0] alucontrol,
output logic [31:0] aluout,
output logic zero);

	
always_comb
	case(alucontrol)
		3'b000: aluout<=srca & srcb; 
		3'b001: aluout<=srca | srcb;
		3'b010: aluout<=srca+srcb;
		3'b110: aluout<=srca-srcb;
		default: aluout<=32'hxxxxxxxx;
	endcase

	assign zero=aluout?0:1;

endmodule


module regfile(
input logic clk,
input logic we3,
input logic [4:0] ra1, ra2, wa3,
input logic [31:0] wd3,
output logic [31:0] rd1, rd2);

logic [31:0] rf[31:0];
// three ported register file
// read two ports combinationally
// write third port on rising edge of clk
// register 0 hardwired to 0
always_ff @(posedge clk)
	if (we3) rf[wa3] <= wd3;

assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule



endmodule


