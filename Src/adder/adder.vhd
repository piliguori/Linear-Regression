--! @file adder.vhd
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
--! @brief Adder per la somma di due addendi con numero di bit variabile.
--! @cond
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--! @endcond

--! Sommatore a due addendi.
--!
--! Il sommatore permette di effettuare una somma di due addendi espressi su un certo numero di bit.
--! La somma dei due addendi viene espressa sullo stesso numero di bit.
--! Quando il risultato prodotto dalla somma degli addendi non è correttamente rappresentato su tale numero di bit,
--! un flag indica la condizione di overflow.
entity adder is
	generic (	nbits 		: 		natural := 32;	--! Numero di bit su cui gli addendi sono espressi. La somma sarà
				--! espressa sul medesimo numero di bit
				use_custom 	:		boolean := false);	--! Se impostato a "true" verrà sintetizzato un sommatore custom
				--! generic_cla_adder. Impostando il parametro a "false", invece, la somma viene effettuata tramite
				--! l'operatore "+", previa conversione degli addendi in un numero signed, per cui l'implementazione
				--! verrà lasciata al particolare sintetizzatore.
	port (		add1 		: in	std_logic_vector(nbits-1 downto 0);		--! addendo 1
				add2 		: in	std_logic_vector(nbits-1 downto 0);		--! addendo 2
				sum			: out	std_logic_vector(nbits-1 downto 0);		--! somma degli addendi
				overflow	: out	std_logic);	--! flag di overflow; è '1' quando il risultato prodotto dalla somma degli
												--! addendi non è rappresentabile su 4*nibbles bit: si verifica overflow se,
												--! sommando due numeri dello stesso segno, si ottiene un numero di segno
												--! opposto.
end adder;

--! Implementazione mista structural per l'entity adder.
--!
--! A seconda del valore del parametro use_custom, verrà istanziato
--!  - un sommatore full-custom generic_cla_adder, se use_custom = true;
--!  - un sommatore la cui implementazione è stabilita dal sintetizzatore, se use_custom = false;
--! Nel caso in cui venga istanziato il sommatore custom, è richiesto che il numero di bit con il quale sono espressi gli
--! addendi, e di conseguenza quello in vui verrà espressa la loro somma, sia multiplo di quattro.
architecture structural of adder is

	component generic_cla_adder is
		generic (	nibbles 	: 		natural := 2);	
		port (		carry_in 	: in  	std_logic;
					addendum1 	: in 	std_logic_vector ((nibbles * 4)-1 downto 0);
					addendum2 	: in 	std_logic_vector ((nibbles * 4)-1 downto 0);
					sum 		: out	std_logic_vector ((nibbles * 4)-1 downto 0);
					carry_out 	: out	std_logic;
					overflow	: out	std_logic);
	end component;
	
	signal sum_tmp : std_logic_vector (nbits-1 downto 0); --! segnale temporaneo nel quale viene posto il
	--! risultato della somma per effettuare il calcolo della condizione di overflow

begin

	sum <= sum_tmp;

	assert use_custom = false or ((use_custom = true) and (nbits mod 4 = 0))
		report "L'utilizzo di un addizionatore custom richiede che gli addendi abbiano lunghezza multipla intera di 4 bit"
		severity error;

	builtin_adder : if use_custom = false generate
		assert false report "Viene sintetizzato il sommatore built-in" severity warning;
		sum_tmp		<=	std_logic_vector(signed(add1) + signed(add2));
		overflow	<= 	(add1(nbits-1) and add2(nbits-1) and (not sum_tmp(nbits-1))) or 
						((not add1(nbits-1)) and (not add2(nbits-1)) and sum_tmp(nbits-1));
	end generate;
	
	custom_adder : if use_custom = true generate
		assert false report "Viene sintetizzato il sommatore custom" severity warning;
		cla_adder : generic_cla_adder
			generic map (	nibbles 	=> nbits/4)	
			port map (		carry_in 	=> '0',
							addendum1 	=> add1,
							addendum2 	=> add2,
							sum 		=> sum_tmp,
							carry_out 	=> open,
							overflow	=> overflow);
	end generate;
end structural;
