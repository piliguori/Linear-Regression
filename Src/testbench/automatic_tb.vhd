--! @file automatic_tb.vhd
--!
--! @authors	Salvatore Barone <salvator.barone@gmail.com> <br>
--!				Alfonso Di Martino <alfonsodimartino160989@gmail.com> <br>
--!				Sossio Fiorillo <fsossio@gmail.com> <br>
--!				Pietro Liguori <pie.liguori@gmail.com> <br>
--!
--! @date 05 07 2017
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- per le operazioni su file

entity automatic_tb is
end automatic_tb;

architecture behavioral of automatic_tb is
	component LinearRegression is
		port ( prim : in std_logic_vector (5 downto 0);
			   sum2 : in std_logic_vector (23 downto 0);
			   b 	: in std_logic_vector (23 downto 0);
			   sum1 : in std_logic_vector (23 downto 0);
			   c 	: in std_logic_vector (23 downto 0);
			   a 	: in std_logic_vector (23 downto 0);
			   m 	: out std_logic_vector (23 downto 0);
			   q 	: out std_logic_vector (23 downto 0));
	end component;
	
	constant clock_period : time := 10ns;
	
	-- segnali interni al testbench	
	signal prim : std_logic_vector (5 downto 0)  := b"011001";
	signal a 	: std_logic_vector (23 downto 0) := x"7B13B1";
	signal b 	: std_logic_vector (23 downto 0) := x"4CCCCC";
	signal c 	: std_logic_vector (23 downto 0) := x"504816";
	signal sum1 : std_logic_vector (23 downto 0) := (others=>'0');
	signal sum2 : std_logic_vector (23 downto 0) := (others=>'0');
	signal m 	: std_logic_vector (23 downto 0) := (others=>'0');
	signal q 	: std_logic_vector (23 downto 0) := (others=>'0');
	
	-- oggetti per lettura/scrittura su file
	file dataset : text;
	file results : text;

begin

	UUT : LinearRegression
		port map(	prim => prim,
					sum2 => sum2,
					b 	 => b,
					sum1 => sum1,
					c 	 => c,
					a 	 => a,
					m 	 => m,
					q 	 => q);
					
	stim_proc : process
		variable rline  : line;
		variable wline  : line;
		variable r_sum1 : std_logic_vector (23 downto 0) := (others=>'0');
		variable r_sum2 : std_logic_vector (23 downto 0) := (others=>'0');
		variable r_m 	: std_logic_vector (23 downto 0) := (others=>'0');
		variable r_q 	: std_logic_vector (23 downto 0) := (others=>'0');
		variable w_dm 	: std_logic_vector (23 downto 0) := (others=>'0');
		variable w_dq 	: std_logic_vector (23 downto 0) := (others=>'0');
		variable space  : character;
	begin
		file_open(dataset, "/home/ssaa/dataset.txt",  read_mode);
		file_open(results, "/home/ssaa/output.txt", write_mode);

		while not endfile(dataset) loop
			readline(dataset, rline);
			read(rline, r_sum1); read(rline, space);
			read(rline, r_sum2); read(rline, space);
			read(rline, r_m); read(rline, space);
			read(rline, r_q);
			sum1 <= r_sum1;
			sum2 <= r_sum2;
			wait for 3*clock_period;
			
			w_dm := std_logic_vector(signed(m)-signed(r_m));
			w_dq := std_logic_vector(signed(q)-signed(r_q));
			

			write(wline, w_dm, right, 24);
			write(wline, ' ', right, 1);
			write(wline, w_dq, right, 24);
			writeline(results, wline);
		end loop;

		file_close(dataset);
		file_close(results);
		wait;
	end process;

end behavioral;
