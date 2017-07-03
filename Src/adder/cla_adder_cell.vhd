--! @file cla_adder_cell.vhd
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
--! @addtogroup CarryLoockahead
--! @{
--! @addtogroup BaseCell
--! @{
--! @brief Implementazione della cella base di un adder.

--! @cond
library ieee;
use ieee.std_logic_1164.all;
--! @endcond

--! Cella base di un addizionatore con carry-lookahead.
--!
--! La cella somma tra loro due addendi ed un carry in ingresso, tutti espressi su un solo bit. Oltre a generare la somma,
--! genera le funzioni "propagazione" e "generazione" del carry.
entity cla_adder_cell is
	port (	add1	: in	std_logic;	--! addendo 1
			add2	: in	std_logic;	--! addendo 2
			carryin	: in	std_logic;	--! carry in ingresso
			prop	: out	std_logic;	--! funzione "propagazione”, vale 1 quando, sulla base degli ingressi, un adder
										--! propaghera' un eventuale carry in ingresso; prop = add1 OR add2
			gen		: out	std_logic;	--! funzione "generazione”, vale 1 quando, sulla base degli ingressi, un adder
										--! generera' riporto; gen = add1 AND add2;
			sum		: out	std_logic);	--! funzione "somma", rappresenta la somma tra gli addendi ed il carry in ingresso
										--! alla cella; sum = add1 XOR add2 XOR carryin;
end cla_adder_cell;

architecture dataflow of cla_adder_cell is
begin
	prop <= add1 or add2;
	gen <= add1 and add2;
	sum <= add1 xor add2 xor carryin;
end dataflow;

--! @}
--! @}
--! @}


