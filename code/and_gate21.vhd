
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;
 -------------------------------------------
 ENTITY and_gate21 IS
 PORT ( 
 a : IN STD_LOGIC;
 b : IN STD_LOGIC;
 y : OUT STD_LOGIC);
 END and_gate21;
 -------------------------------------------
 ARCHITECTURE and_gate211 OF and_gate21 IS
 
 BEGIN
	 
 y <= a and b;
	  
 END and_gate211;
 -------------------------------------------