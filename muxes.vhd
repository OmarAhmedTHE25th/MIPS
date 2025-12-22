--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package muxes is

 component mux2to1
		port(
			a,b: in STD_LOGIC_VECTOR (31 downto 0);
			sel: in STD_LOGIC ;
			y: out STD_LOGIC_VECTOR (31 downto 0));
		end component;
		
		component mux4to1
		port(a,b,c,d: in STD_LOGIC_VECTOR (31 downto 0); sel: in STD_LOGIC_VECTOR (1 downto 0) ; y: out STD_LOGIC_VECTOR (31 downto 0));
		end component;
		
		component mux2to1_5bits
			port(
				a,b: in STD_LOGIC_VECTOR (4 downto 0);
				sel: in STD_LOGIC ;
				y: out STD_LOGIC_VECTOR (4 downto 0));
		end component;
end muxes;

package body muxes is
 
end muxes;

