--! @file generic_cla_adder.vhd
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

-- adder con carry-lookahead generico
entity generic_cla_adder is
	generic (nibbles : natural := 2);	-- l'adder va instanzializzato in nibble (4 bit)
										-- es. un adder cla a 16 bit va instanzializzato usado
										-- nibbles = 4
	port (	carry_in : in  STD_LOGIC;								-- carry in ingresso
			X : in  STD_LOGIC_VECTOR ((nibbles * 4)-1 downto 0);	-- primo addendo
			Y : in  STD_LOGIC_VECTOR ((nibbles * 4)-1 downto 0);	-- secondo addendo
			sum : out  STD_LOGIC_VECTOR ((nibbles * 4)-1 downto 0);	-- risultato della somma
			carry_out : out std_logic								-- carry in uscita
		);
end generic_cla_adder;

architecture structural of generic_cla_adder is
	
	component nibble_adder
		port ( adderA : in  STD_LOGIC_VECTOR (3 downto 0);
			   adderB : in  STD_LOGIC_VECTOR (3 downto 0);
			   carryIn : in  STD_LOGIC;
			   propIn : in  STD_LOGIC;
			   genIn : in  STD_LOGIC;
			   propOut : out  STD_LOGIC;
			   genOut : out  STD_LOGIC;
			   sum : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	-- segnali "propagate" e "generate" scambiati tra i diversi nibble adder.
	signal prop, gen : std_logic_vector (0 to nibbles);
	
begin
	
	prop(0) <= '1';						
	gen(0) <= '0';
									
	carry_out <= gen(nibbles) or ( prop(nibbles) and carry_in);
	
	-- generazione della "catena di addizionatori"
	adder_chain : for i in 0 to nibbles-1 generate
		adder : nibble_adder
				port map (
					adderA => X((i+1)*4-1 downto i*4),	-- nibble dell'addendo A di pertinenza al nibble adder i-esimo
					adderB => Y((i+1)*4-1 downto i*4),	-- nibble dell'addendo B di pertinenza al nibble adder i-esimo
					carryIn => carry_in,				-- il segnale di carry_in e' preso in ingresso da tutti i nibble-adder
					propIn => prop(i),					-- segnale propIn in ingresso al nibble-adder i-esimo, generato dal nibble-adder (i-1)-esimo
					genIn => gen(i),					-- segnale genIn in ingresso al nibble-adder i-esimo, generato dal nibble-adder (i-1)-esimo
					propOut => prop(i+1),				-- segnale propOut in uscita al nibble-adder i-esimo
					genOut => gen(i+1),					-- segnale genOut in uscita al nibble-adder i-esimo
					sum => sum((i+1)*4-1 downto i*4)	-- nibble della somma di pertinenza al nibble adder i-esimo
				);
	end generate;
	
end structural;

