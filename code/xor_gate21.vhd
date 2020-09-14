
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;
 -------------------------------------------
 ENTITY xor_gate21 IS
 PORT ( 
 a : IN STD_LOGIC;
 b : IN STD_LOGIC;
 y : OUT STD_LOGIC);
 END xor_gate21;
 -------------------------------------------
 ARCHITECTURE xor_gate211 OF xor_gate21 IS
 
 BEGIN
	 
 y <= a xor b;
	  
 END xor_gate211;
 -------------------------------------------
