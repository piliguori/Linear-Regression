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

--! 
entity adder is
	generic (	nbits 	: 		natural := 8);							--!
	port (		add1 	: in	std_logic_vector(nbits-1 downto 0);		--!
				add2 	: in	std_logic_vector(nbits-1 downto 0);		--!
				sum		: out	std_logic_vector(nbits-1 downto 0));	--!
end adder;

architecture structural of adder is
begin
	sum <= std_logic_vector(signed(add1) + signed(add2));
end structural;
