--! @file nibble_adder.vhd
--!
--! @authors	Salvatore Barone <salvator.barone@gmail.com> <br>
--!				Alfonso Di Martino <alfonsodimartino160989@gmail.com> <br>
--!				Sossio Fiorillo <fsossio@gmail.com> <br>
--!				Pietro Liguori <pie.liguori@gmail.com> <br>
--!
--! @date 01 07 2017
--! 
--! @copyright
--! Copyright 2017	Salvatore Barone <salvator.barone@gmail.com> <br>
--!					Alfonso Di Martino <alfonsodimartino160989@gmail.com> <br>
--!					Sossio Fiorillo <fsossio@gmail.com> <br>
--!					Pietro Liguori <pie.liguori@gmail.com> <br>
--! 
--! This file is part of Linear-Regression.
--! 
--! Linear-Regression is free software; you can redistribute it and/or modify it under the terms of
--! the GNU General Public License as published by the Free Software Foundation; either version 3 of
--! the License, or any later version.
--! 
--! Linear-Regression is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
--! without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
--! GNU General Public License for more details.
--! 
--! You should have received a copy of the GNU General Public License along with this program; if not,
--! write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
--! USA.
--! 

--! @cond
library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- use ieee.std_logic_misc.all;
--! @endcond

-- adder con carry-lookahead
-- la rete di carry e' porzionata su quattro bit (nibble)
entity nibble_adder is
    Port ( adderA : in  STD_LOGIC_VECTOR (3 downto 0);	-- nibble dell'addendo A
           adderB : in  STD_LOGIC_VECTOR (3 downto 0);	-- nibble dell'addendo B
           carryIn : in  STD_LOGIC;						-- carry in ingresso
           propIn : in  STD_LOGIC;						-- segnale "propagate" in ingresso (dal blocco precedente)
           genIn : in  STD_LOGIC;						-- segnale "generate" in ingresso (dal blocco precedente)
           propOut : out  STD_LOGIC;					-- segnale "propagate" in uscita (per il blocco successivo)
           genOut : out  STD_LOGIC;						-- segnale "generate" in uscita (per il blocco successivo)
           sum : out  STD_LOGIC_VECTOR (3 downto 0));	-- nibble somma
end nibble_adder;

architecture structural of nibble_adder is
	
	-- rete di calcolo dei carry
	component cla_carry_net
		port (	prop, gen : in std_logic_vector(3 downto 0);
				carryin, propin, genin : in std_logic;
				carryout : out std_logic_vector(3 downto 0);
				propout, genout : out std_logic); 
	end component;
	
	-- cella elementare di somma
	component cla_adder_cell
		port (	add1, add2, carryin: in std_logic;
			prop, gen, sum: out std_logic);
	end component;
	
	-- segnali "propagate" e "generate" prodotti dalle singole celle adder
	-- segnale "carry" prodotto dalla rete di carry-lookahead
	signal p, g, carryGenerati : std_logic_vector(3 downto 0);
	
begin
	
	-- istanza di rete di calcolo dei carry
	cla_net:	cla_carry_net
				port map (p, g, carryIn, propIn, genIn, carryGenerati, propOut, genOut);
		
	-- istanziazione delle celle elementari di somma
	adders : for i in 0 to 3 generate		
		adder :	cla_adder_cell
				port map (adderA(i), adderB(i), carryGenerati(i), p(i), g(i), sum(i));
	end generate;

end structural;

