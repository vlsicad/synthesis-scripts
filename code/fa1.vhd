-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : fa1
-- Author      : Microsoft
-- Company     : Microsoft
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\tpg_bist\fa1\compile\fa1.vhd
-- Generated   : Sat Feb  6 23:53:09 2016
-- From        : c:\My_Designs\tpg_bist\fa1\src\fa1.bde
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
--library HA1;
--library OR_GATE21;

entity fa1 is
  port(
       A : in STD_LOGIC;
       B : in STD_LOGIC;
       C : in STD_LOGIC;
       carry : out STD_LOGIC;
       sum : out STD_LOGIC
  );
end fa1;

architecture fa1 of fa1 is

---- Component declarations -----

component ha1
  port (
       A : in STD_LOGIC;
       B : in STD_LOGIC;
       cout : out STD_LOGIC;
       sum : out STD_LOGIC
  );
end component;
component or_gate21
  port (
       a : in STD_LOGIC;
       b : in STD_LOGIC;
       y : out STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal NET108 : STD_LOGIC;
signal NET127 : STD_LOGIC;
signal NET45 : STD_LOGIC;

begin

----  Component instantiations  ----

U1 : ha1
  port map(
       A => A,
       B => B,
       cout => NET108,
       sum => NET45
  );

U2 : ha1
  port map(
       A => NET45,
       B => C,
       cout => NET127,
       sum => sum
  );

U3 : or_gate21
  port map(
       a => NET108,
       b => NET127,
       y => carry
  );


end fa1;
