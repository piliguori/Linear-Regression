--! @file cla_carry_net.vhd
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

--! @addtogroup Adder
--! @{
--! @brief Implementazione di un adder per la somma di due addendo con numero di bit variabile.
--! @addtogroup CarryLoockahead
--! @{
--! @brief Implementazione VHDL di un adder con carry-lookahead custom
--! @addtogroup CarryNetwork
--! @brief Rete di generazione dei segnali di carry per l'adder
--! @{
--! @cond
library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- use ieee.std_logic_misc.all;
--! @endcond

entity cla_carry_net is
	port (	prop, gen : in std_logic_vector(3 downto 0);
			carryin, propin, genin : in std_logic;
			carryout : out std_logic_vector(3 downto 0);
			propout, genout : out std_logic); 
end cla_carry_net;

architecture dataflow of cla_carry_net is

begin
	carryout(0) <= genin or (propin and carryin);
	
	carryout(1) <= 	gen(0) or
					(prop(0) and genin) or 
					(prop(0) and propin and carryin);
	
	carryout(2) <= 	gen(1) or 
					(prop(1) and gen(0)) or
					(prop(1) and prop(0) and genin) or
					(prop(1) and prop(0) and propin and carryin);
					
	carryout(3) <= 	gen(2) or
					(prop(2) and gen(1)) or 
					(prop(2) and prop(1) and gen(0)) or
					(prop(2) and prop(1) and prop(0) and genin) or
					(prop(2) and prop(1) and prop(0) and propin and carryin);
	
	genout <=	gen(3) or
				(prop(3) and gen(2)) or
				(prop(3) and prop(2) and gen(1)) or 
				(prop(3) and prop(2) and prop(1) and gen(0)) or
				(prop(3) and prop(2) and prop(1) and prop(0) and genin);
					
	propout <=	prop(3) and prop(2) and prop(1) and prop(0) and propin;
	
end dataflow;

