--! @file subtractor.vhd
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

--! @addtogroup Subtractor
--! @{
--! @brief Subtractor per la sottrazione di due espressi con numero di bit variabile.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Sottrattore di due numeri.
--!
--! Il sottrattore permette di effettuare una differenza di due numeri espressi su un certo numero di bit.
--! La differenza dei due valori viene espressa sullo stesso numero di bit.
entity subtractor is
	generic (	nbits 		: 		natural := 32);	--! Numero di bit su cui sottraendo e minuendo sono espressi.  
				--! La differenza sarà espressa sul medesimo numero di bit
	port (		sub1 		: in	std_logic_vector(nbits-1 downto 0);		--! minuendo
				sub2 		: in	std_logic_vector(nbits-1 downto 0);		--! sottraendo
				diff		: out	std_logic_vector(nbits-1 downto 0));	--! differenza dei valori: diff = sub1-sub2
end subtractor;

architecture structural of subtractor is
	
begin
	diff <=	std_logic_vector(signed(sub1) - signed(sub2));
end structural;
--! @}

