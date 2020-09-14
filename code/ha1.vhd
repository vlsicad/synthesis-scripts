-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : ha1
-- Author      : Microsoft
-- Company     : Microsoft
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\tpg_bist\ha1\compile\ha1.vhd
-- Generated   : Sat Feb  6 23:53:07 2016
-- From        : c:\My_Designs\tpg_bist\ha1\src\ha1.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;


-- other libraries declarations
--library AND_GATE21;
--library XOR_GATE21;

entity ha1 is
  port(
       A : in STD_LOGIC;
       B : in STD_LOGIC;
       cout : out STD_LOGIC;
       sum : out STD_LOGIC
  );
end ha1;

architecture ha1 of ha1 is

---- Component declarations -----

component and_gate21
  port (
       a : in STD_LOGIC;
       b : in STD_LOGIC;
       y : out STD_LOGIC
  );
end component;
component xor_gate21
  port (
       a : in STD_LOGIC;
       b : in STD_LOGIC;
       y : out STD_LOGIC
  );
end component;

begin

----  Component instantiations  ----

U1 : xor_gate21
  port map(
       a => A,
       b => B,
       y => sum
  );

U2 : and_gate21
  port map(
       a => A,
       b => B,
       y => cout
  );


end ha1;
