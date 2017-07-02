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

--! @addtogroup Adder
--! @{
--! @addtogroup CarryLoockahead
--! @{
--! @brief Addizionatore con carry-lookahead

--! @cond
library ieee;
use ieee.std_logic_1164.all;
--! @endcond

--! Adder custom con carry-lookahead
--!
--! generic_cla_adder somma tra loro due addendi ed un carry in ingresso; gli addendi sono espressi su multipli interi di
--! quattro bit. Oltre a generare la somma, genera il flag di carry ed il flag di overflow.
entity generic_cla_adder is
	generic (	nibbles 	: 		natural := 2);	--! numero di nibble in cui sono rappresentati gli addendi e nel quale
													--! sarà espressa la somma degli stessi
	port (		carry_in 	: in  	std_logic;	--! segnale di "carry-in", prodotto da un eventuale nibble_adder a monte;
												--! Può essere posto a '0' nel caso in cui non vi siano adder a monte.
				addendum1 	: in 	std_logic_vector ((nibbles * 4)-1 downto 0); --! addendo 1, espresso in complemento a due
				addendum2 	: in 	std_logic_vector ((nibbles * 4)-1 downto 0); --! addendo 2, espresso in complemento a due
				sum 		: out	std_logic_vector ((nibbles * 4)-1 downto 0); --! somma degli addendi, espressa in complemento a due
				carry_out 	: out	std_logic;	--! carry in uscita; viene calcolato come carry_out=gen(nibbles)+(prop(nibbles)*carry_in),
												--! dove gen(nibbles) e prop(nibbles) sono, rispettivamente, la funzione
												--! "generazione" e "propagazione" del carry prodotta dall'ultimo blocco
												--! nibble_adder, cioè quello che somma i nibble di peso massimo, e carry_in
												--! e' il carry in ingresso al sommatore.
				overflow	: out	std_logic);	--! flag di overflow; è '1' quando il risultato prodotto dalla somma degli
												--! addendi non è rappresentabile su 4*nibbles bit: si verifica overflow se,
												--! sommando due numeri dello stesso segno, si ottiene un numero di segno
												--! opposto.
end generic_cla_adder;

--! Implementazione structural di generic_cla_adder.
--!
--! Questa implementazione istanzia tanti blocchi nibble_adder quanti siano i nibble in cui sono rappresentati gli addendi.
--! La somma è espressa sullo stesso numero di bit. I diversi blocchi sono connessi tra loro come indicato nello schema
--! ricordato di seguito:
--! @htmlonly
--! <div align='center'>
--! <img src="../../Doc/schemes/cla_adder.jpg"/>
--! </div>
--! @endhtmlonly
architecture structural of generic_cla_adder is
	
	component nibble_adder
		port ( addera 	: in	std_logic_vector (3 downto 0);
			   adderb 	: in	std_logic_vector (3 downto 0);
			   carryin 	: in	std_logic;
			   propin 	: in	std_logic;
			   genin 	: in	std_logic;
			   propout 	: out	std_logic;
			   genout 	: out	std_logic;
			   sum 		: out	std_logic_vector (3 downto 0));
	end component;
	
	-- segnali "propagate" e "generate" scambiati tra i diversi nibble adder.
	signal prop : std_logic_vector (0 to nibbles); --! funzione "propagazione" del carry, prodotta dai diversi blocchi 
	--! nibble_adder; prop(i) vale 1 quando, sulla base degli ingressi, l'i-esimo nibble_adder propaghera' un eventuale
	--! carry in ingresso; prop(0) = '1';
	signal gen : std_logic_vector (0 1to nibbles); --! funzione "generazione" del carry, prodotta dai diversi blocchi 
	--! nibble_adder; gen(i) vale 1 quando, sulla base degli ingressi, l'i-esimo nibble_adder genera carry in uscita;
	--! gen(0) = '0';
	
begin
	
	prop(0) <= '1';
	gen(0) <= '0';
	carry_out <= gen(nibbles) or (prop(nibbles) and carry_in);
	overflow <= 	(addendum1(nibbles*4-1) and addendum2(nibbles*4-1) and (not sum(nibbles*4-1))) or 
					((not addendum1(nibbles*4-1)) and (not addendum2(nibbles*4-1)) and sum(nibbles*4-1));
	
	adder_chain : for i in 0 to nibbles-1 generate
		adder : nibble_adder
				port map (
					adderA => addendum1((i+1)*4-1 downto i*4),
					adderB => addendum2((i+1)*4-1 downto i*4),
					carryIn => carry_in,
					propIn => prop(i),
					genIn => gen(i),
					propOut => prop(i+1),
					genOut => gen(i+1),
					sum => sum((i+1)*4-1 downto i*4));
	end generate;
	
end structural;

--! @}
--! @}

