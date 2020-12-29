module tbMips();
logic clk, reset;
logic [31:0] pc, instr;
logic memwrite;
logic [31:0] aluout, writedata, readdata;

mips UT (clk, reset, pc, instr, memwrite, aluout, writedata, readdata);

initial
begin
#0 clk=1; reset=1; readdata=32'd54;

#5 clk=0; reset=0; instr=32'h2010000a;  //addi $s0,$0,10  
#5 clk=1; 

#5 clk=0; instr=32'h2011000f;  //addi $s1,$0,15  
#5 clk=1;

#5 clk=0; instr=32'h02114020; //add $t0, $s0,$s1
#5 clk=1; 

#5 clk=0; instr=32'h02304022; //sub $t0,$s1,$s0
#5 clk=1; 

#5 clk=0; instr=32'h02114024; //and $t0, $s0,$s1
#5 clk=1; 

#5 clk=0; instr=32'h02114025; //or $t0, $s0,$s1
#5 clk=1; 

#5 clk=0; instr=32'h8e09000a; //back: lw $t1, 10($s0) 100011,10000,01001,0000000000001010
#5 clk=1; 

#5 clk=0; instr=32'hae29000a; //next: sw $t1, 10($s1)
#5 clk=1; 

#5 clk=0; instr=32'h1211fffd; //beq $s0,$s1,back
#5 clk=1; 

#5 clk=0; instr=32'h2010000f; //addi $s0, $0,15
#5 clk=1; 

#5 clk=0; instr=32'h1211fffd; //beq $s0,$s1,back
#5 clk=1;

#5 clk=0; 
#5 clk=1; 

#5 clk=0; instr=32'h08100007; //j next
#5 clk=1;

#5 clk=0; 
#5 clk=1; 

end
endmodule
