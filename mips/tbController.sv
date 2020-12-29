module tbController();
logic [5:0] op, funct;
logic zero, memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump;
logic [2:0] alucontrol;

controller UT (op, funct, zero, memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump, alucontrol);
initial
begin
#0 {op,funct,zero}=13'b001000_001010_0; //32'h2010000a addi $s0,$0,10 
#10 {op,funct,zero}=13'b001000_001111_0; //32'h2011000f addi $s1,$0,15  
#10 {op,funct,zero}=13'b000000_100000_0; //32'h02114020 add $t0, $s0,$s1  
#10 {op,funct,zero}=13'b000000_100010_0; //32'h02304022 sub $t0,$s1,$s0
#10 {op,funct,zero}=13'b000000_100100_0; //32'h02114024 and $t0, $s0,$s1
#10 {op,funct,zero}=13'b000000_100101_0; //32'h02114025 or $t0, $s0,$s1
#10 {op,funct,zero}=13'b100011_001010_0; //32'h8e09000a lw $t1, 10($s0)
#10 {op,funct,zero}=13'b101011_001010_0; //32'hae29000a sw $t1, 10($s1)
#10 {op,funct,zero}=13'b000100_111101_0; //32'h1211fffd beq $s0,$s1,back
#10 {op,funct,zero}=13'b001000_001111_0; //32'h2010000f addi $s0, $0,15
#10 {op,funct,zero}=13'b000100_111101_1; //32'h1211fffd beq $s0,$s1,back
#10 {op,funct,zero}=13'b000010_000111_0; //32'h08100007 j next
end
endmodule
