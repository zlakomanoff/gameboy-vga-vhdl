-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

library ieee;
use ieee.std_logic_1164.all;
library altera;
use altera.altera_syn_attributes.all;

entity gameboy_vga is
	port
	(
-- {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!

		VinClock : in std_logic;
		VinData : in std_logic_vector(1 downto 0);
		VinHSunc : in std_logic;
		VinVSunc : in std_logic;
		VoutClock : in std_logic;
		VoutData : out std_logic_vector(1 downto 0);
		VoutHSunc : out std_logic;
		VoutVSunc : out std_logic
-- {ALTERA_IO_END} DO NOT REMOVE THIS LINE!

	);

-- {ALTERA_ATTRIBUTE_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_ATTRIBUTE_END} DO NOT REMOVE THIS LINE!
end gameboy_vga;

architecture ppl_type of gameboy_vga is

-- {ALTERA_COMPONENTS_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_COMPONENTS_END} DO NOT REMOVE THIS LINE!
begin
-- {ALTERA_INSTANTIATION_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_INSTANTIATION_END} DO NOT REMOVE THIS LINE!

end;
