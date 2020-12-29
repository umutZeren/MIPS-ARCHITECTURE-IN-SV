module controller(
input logic [5:0] op, funct, 
input logic zero, 
output logic memtoreg, memwrite, 
output logic pcsrc, alusrc,
output logic regdst, regwrite,
output logic jump,
output logic [2:0] alucontrol);

logic [1:0] aluop;
logic branch;

module maindec(input logic [5:0] op,
output logic memtoreg, memwrite,
output logic branch, alusrc,
output logic regdst, regwrite,
output logic jump,
output logic [1:0] aluop);

logic [8:0] controls;

assign {regwrite, regdst, alusrc, branch, memwrite,memtoreg, jump, aluop} = controls;

always_comb
case(op)
6'b000000: controls <= 9'b110000010; // RTYPE
6'b100011: controls <= 9'b101001000; // LW
6'b101011: controls <= 9'b001010000; // SW
6'b000100: controls <= 9'b000100001; // BEQ
6'b001000: controls <= 9'b101000000; // ADDI
6'b000010: controls <= 9'b000000100; // J
default: controls <= 9'bxxxxxxxxx; // illegal op
endcase
endmodule


module aludec(input logic [5:0] funct,
input logic [1:0] aluop,
output logic [2:0] alucontrol);
always_comb
case(aluop)
2'b00: alucontrol <= 3'b010; // add (for lw/sw/addi)
2'b01: alucontrol <= 3'b110; // sub (for beq)
default: case(funct) // R-type instructions
6'b100000: alucontrol <= 3'b010; // add
6'b100010: alucontrol <= 3'b110; // sub
6'b100100: alucontrol <= 3'b000; // and
6'b100101: alucontrol <= 3'b001; // or
6'b101010: alucontrol <= 3'b111; // slt
default: alucontrol <= 3'bxxx; // ???
endcase
endcase
endmodule

maindec md(op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump, aluop);

aludec ad(funct, aluop, alucontrol);

assign pcsrc = branch & zero;

endmodule

