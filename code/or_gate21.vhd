																				  
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;
 -------------------------------------------
 ENTITY or_gate21 IS
 PORT ( 
 a : IN STD_LOGIC;
 b : IN STD_LOGIC;
 y : OUT STD_LOGIC);
 END or_gate21;
 -------------------------------------------
 ARCHITECTURE or_gate211 OF or_gate21 IS
 
 BEGIN
	 
 y <= a or b;
	  
 END or_gate211;
 -------------------------------------------
