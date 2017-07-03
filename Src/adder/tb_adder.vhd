--! @file tb_adder.vhd
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
use ieee.numeric_std.all;
-- use ieee.std_logic_misc.all;
--! @endcond

entity tb_adder is
end tb_adder;
 
architecture behavior of tb_adder is 
 
	component adder is
		generic (	nbits 		: 		natural := 32;
					use_custom 	:		boolean := false);
		port (		add1 		: in	std_logic_vector(nbits-1 downto 0);
					add2 		: in	std_logic_vector(nbits-1 downto 0);
					sum			: out	std_logic_vector(nbits-1 downto 0);
					overflow	: out	std_logic);
	end component;
 
	constant nbits 		: natural := 12;
	constant use_custom : boolean := true;
	signal add1 		: std_logic_vector(nbits-1 downto 0) := (others => '0');
	signal add2 		: std_logic_vector(nbits-1 downto 0) := (others => '0');
	signal sum			: std_logic_vector(nbits-1 downto 0) := (others => '0');
	signal overflow		: std_logic := '0';
 
begin

	uut: adder
		generic map (	nbits 		=> nbits,
						use_custom 	=> use_custom)
		port map (		add1 		=> add1,
						add2 		=> add2,
						sum			=> sum,
						overflow	=> overflow);
						
	stim_proc: process
		variable test_sum : integer;
		variable test_ovfl : std_logic;
		variable error_count : integer := 0;
	begin		
		for i in 0 to 2**nbits-1 loop
			add1 <= std_logic_vector(to_signed(i, nbits));
			for j in 0 to 2**nbits-1 loop
				add2 <= std_logic_vector(to_signed(j, nbits));
				test_sum := i + j;
				if	(to_signed(i, nbits) > 0 and to_signed(j, nbits) > 0 and to_signed(test_sum, nbits) < 0) or
					(to_signed(i, nbits) < 0 and to_signed(j, nbits) < 0 and to_signed(test_sum, nbits) > 0) then
					test_ovfl := '1';
				else
					test_ovfl := '0';
				end if;
				
				wait for 2 ns;
				
				assert sum = std_logic_vector(to_signed(test_sum, nbits))
					report "Errore di somma : i=" & integer'image(i) & " j=" & integer'image(j)
					severity error;
				
				assert overflow =  test_ovfl
					report "Errore di overflow : i=" & integer'image(i) & " j=" & integer'image(j)
					severity error;
					
				if sum /= std_logic_vector(to_unsigned(test_sum, 8)) or  overflow /=test_ovfl then
					error_count := error_count + 1;
				end if;
				
			end loop;
		end loop;
				
		assert (1 = 2)
		report "Si sono verificati " & integer'image(error_count) & " errori durante il test";

		wait;
	end process;

end;
