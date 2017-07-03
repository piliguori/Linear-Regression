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

--! @addtogroup Adder
--! @{
--! @addtogroup CarryLoockahead
--! @{
--! @addtogroup NibbleAdder
--! @brief Blocco elementare di somma a quattro bit. 
--! @{

--! @cond
library ieee;
use ieee.std_logic_1164.all;
--! @endcond

--! Addizionatore con carry-lookahead a quattro bit.
--! 
--! La cella somma tra loro due addendi ed un carry in ingresso; gli addendi sono espressi su quattro bit. Oltre a
--! generare la somma, genera le funzioni "propagazione" e "generazione" del carry per eventuali blocchi nibble_adder
--! posti a valle.
entity nibble_adder is
    port ( addendum1	: in	std_logic_vector (3 downto 0);	--! addendo 1
           addendum2	: in	std_logic_vector (3 downto 0);	--! addendo 2
           carryin		: in	std_logic;	--! segnale di "carry-in", prodotto da un eventuale nibble_adder a monte. 
           propin		: in	std_logic;	--! funzione "propagazione", prodotta da una eventuale nibble_adder a monte 
           genin		: in	std_logic;	--! funzione "generazione", prodotta da una eventuale nibble_adder a monte 
           propout		: out	std_logic;	--! funzione "propagazione" da porre in ingresso ad un eventuale blocco
											--! nibble_adder a valle
           genout		: out	std_logic;	--! funzione "generazione" da porre in ingresso ad un eventuale blocco
											--! nibble_adder a valle
           sum			: out	std_logic_vector (3 downto 0));	--! funzione "somma", rappresenta la somma tra gli
																--! addendi ed il carry in ingresso
end nibble_adder;

--! Implementazione structural dell'entità nibble_adder.
--! 
--! Questa architettura istanzia una entità cla_carry_net ed una entità cla_adder_cell per ogni bit su cui sono
--! espressi gli addendi, connettendoli tra loro secondo lo schema riportato di seguito:
--! @htmlonly
--! <div align='center'>
--! <img src="../../Doc/schemes/nibble_adder.jpg"/>
--! </div>
--! @endhtmlonly
architecture structural of nibble_adder is
	
	component cla_carry_net is
		port (	prop 		: in 	std_logic_vector(3 downto 0);
				gen 		: in 	std_logic_vector(3 downto 0);
				carryin 	: in 	std_logic;
				propin 		: in 	std_logic;
				genin 		: in 	std_logic;
				carryout	: out 	std_logic_vector(3 downto 0);
				propout 	: out 	std_logic;
				genout 		: out 	std_logic); 
	end component;
	
	component cla_adder_cell is
		port (	add1	: in	std_logic;
				add2	: in	std_logic;
				carryin	: in	std_logic;
				prop	: out	std_logic;
				gen		: out	std_logic;
				sum		: out	std_logic);
	end component;
	
	signal prop : std_logic_vector(3 downto 0);		--! funzione “propagazione” prodotta da cla_adder_cell;
	--! vale 1 quando, sulla base degli ingressi, un adder propaghera' un eventuale carry in ingresso; 
	--! prop(i) = add(i) OR add(i); in questo caso viene prodotta da quattro blocchi cla_adder_cell sulla base dei
	--! loro ingressi
	signal gen : std_logic_vector(3 downto 0);		--! funzione "generazione" prodotta da cla_adder_cell;
	--! vale 1 quando, sulla base degli ingressi, un adder generera' un carry in uscita; gen(i) = add(i) AND add(i);
	--! in questo caso viene prodotta da quattro blocchi cla_adder_cell sulla base dei loro ingressi
	signal carry : std_logic_vector(3 downto 0);	--! carry calcolati sulla base delle funzioni "propagazione"
	--! e "generazione" prodotti dai blocchi cla_adder_cell, e sulla base delle funzioni "carry-in", "propagazione"
	--! e "generazione" prodotti da eventuali blocchi a monte; ciascuno dei bit dovra' essere posto in ingresso ad
	--! un blocco cla_adder_cell differente, affinche' possa essere calcolata la somma degli addendi
	
begin
	
	cla_net : cla_carry_net
		port map (	prop 		=> prop,
					gen 		=> gen,
					carryin 	=> carryIn,
					propin 		=> propIn,
					genin 		=> genIn,
					carryout	=> carry,
					propout 	=> propOut,
					genout 		=> genOut); 
	
	adders : for i in 0 to 3 generate		
		adder :	cla_adder_cell
			port map (	add1	=> addendum1(i),
						add2	=> addendum2(i),
						carryin	=> carry(i),
						prop	=> prop(i),
						gen		=> gen(i),
						sum		=> sum(i));
	end generate;

end structural;

--! @}
--! @}
--! @}



