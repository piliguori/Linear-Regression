--! @file tb_LinearRegression.vhd
--!
--! @authors	Salvatore Barone <salvator.barone@gmail.com> <br>
--!				Alfonso Di Martino <alfonsodimartino160989@gmail.com> <br>
--!				Sossio Fiorillo <fsossio@gmail.com> <br>
--!				Pietro Liguori <pie.liguori@gmail.com> <br>
--!
--! @date 03 07 2017
--! 
--! @copyright
--! Copyright 2017	Salvatore Barone <salvator.barone@gmail.com> <br>
--!					Alfonso Di Martino <alfonsodimartino160989@gmail.com> <br>
--!					Sossio Fiorillo <fsossio@gmail.com> <br>
--!					Pietro Liguori <pie.liguori@gmail.com> <br>
--!
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_LinearRegression is
-- Port();
end tb_LinearRegression;

architecture Behavioral of tb_LinearRegression is
component LinearRegression 
    Port ( prim : in STD_LOGIC_VECTOR (5 downto 0);		
           Sum2 : in STD_LOGIC_VECTOR (23 downto 0);	
		   B 	: in STD_LOGIC_VECTOR (23 downto 0);	
		   Sum1 : in STD_LOGIC_VECTOR (23 downto 0);	
		   C 	: in STD_LOGIC_VECTOR (23 downto 0);	
		   A 	: in STD_LOGIC_VECTOR (23 downto 0);	
		   m 	: out STD_LOGIC_VECTOR (23 downto 0);	
		   q 	: out STD_LOGIC_VECTOR (23 downto 0));	

end component;

signal prim : STD_LOGIC_VECTOR (5 downto 0)	:= (others => '0');
signal Sum2 : STD_LOGIC_VECTOR (23 downto 0):= (others => '0');
signal B 	: STD_LOGIC_VECTOR (23 downto 0):= (others => '0');
signal Sum1 : STD_LOGIC_VECTOR (23 downto 0):= (others => '0');
signal C 	: STD_LOGIC_VECTOR (23 downto 0):= (others => '0');
signal A 	: STD_LOGIC_VECTOR (23 downto 0):= (others => '0');
signal m 	: STD_LOGIC_VECTOR (23 downto 0):= (others => '0');
signal q 	: STD_LOGIC_VECTOR (23 downto 0):= (others => '0');


begin

uut: LinearRegression 
    Port map ( 	prim 	=> prim,
           		Sum2 	=> Sum2,
		   		B 		=> B,
		   		Sum1 	=> Sum1,
		  		C 		=> C,
		   		A 		=> A,
		   		m 		=> m,
		   		q 		=> q);
		   		
stim_proc: process
begin
	-- Test 1
	prim	<=	b"011001";						-- 25
	Sum2	<= 	b"001101011110110111001111";	--
	Sum1 	<=	b"011010001110111000110011";	--
	B 		<=  b"010011001100110011001100";	--
	C 		<=  b"010100000100100000010110";	--
	A 		<=	b"011110110001001110110001";	--
	 
wait;
end process;		   		


end Behavioral;