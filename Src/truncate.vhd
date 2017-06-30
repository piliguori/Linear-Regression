--! @file truncate.vhd
--!
--! @author Salvatore Barone <salvator.barone@gmail.com>
--!			Alfonso Di Martino <alfonsodimartino160989@gmail.com>
--!			Pietro Liguori <pie.liguori@gmail.com>
--!
--! @date 29 06 2017
--! 
--! @copyright
--! Copyright 2017	Salvatore Barone <salvator.barone@gmail.com>,
--!					Alfonso Di Martino <alfonsodimartino160989@gmail.com>
--!					Pietro Liguori <pie.liguori@gmail.com>
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
-- use ieee.numeric_std.all;
-- use ieee.std_logic_misc.all;

--! @addtogroup BasicFixedPointOperation
--! @{
--! @brief Operazioni fixed-point basilari
--! @addtogroup Truncation
--! @{
--! @brief Operazione di troncamento

--! @brief Tronca un segnale di ingresso, espresso in uno specifico formato
--! 
entity truncate is
	generic (	s_in_dim : integer;		--! numero di bit totali su cui e' espresso il segnale di ingresso
				s_in_int : integer;		--! numero di bit su cui e' espressa la parte frazionaria del segnale di ingresso
				s_out_dim : integer;	--! numero di bit totali su cui e' espresso il segnale di uscita
				s_out_int : integer);	--! numero di bit su cui e' espressa la parte frazionaria del segnale di uscita
	port	(	s_in : in std_logic_vector(s_in_dim-1 downto 0);	--! segnale di ingresso
				s_out : out std_logic_vector(s_out_dim downto 0));	--! segnale di uscita, troncato
end truncate;

architecture dataflow of truncate is
	constant x : integer := s_in_int - s_out_int;	--! differenza, in termini di numero di bit usati per la rappresentazione della parte intera, tra formato di
													--! partenza e formato di arrivo
													
	signal padding_pos : std_logic_vector (x-1 downto 0) := (others => '0'); --! segnale di zero-padding,
	signal padding_neg : std_logic_vector (s_out_dim - 2 - (s_in_dim - x) downto 0) := (others => '0'); --! segnale di zero padding,
	
begin
	--! @details
	--! <h4>Controllo dell'input</h4>
	--! Viene controllato che 
	--! 	- il numero totale di bit su cui e' espresso il segnale di ingresso non sia inferiore al numero di bit con cui viene espressa la parte frazionaria;
	--!		- il numero totale di bit su cui verra' espresso il segnale di uscita non sia inferiore al numero di bit con cui verra' espressa la parte frazionaria;
	--!		- il numero di bit totali su cui e' espresso il segnale di ingresso sia maggiore o uguale di quello sul quale verra' espresso il segnale di uscita;
	--!		- il numero di bit su cui e' espressa la parte intera del segnale di ingresso non puo' essere minore di quella sul quale verra' espressa quella del segnale di uscita;
	assert s_in_dim >= s_in_int
		report "s_in_dim non puo' essere minore di s_in_int"
		severity error;
	assert s_out_dim >= s_out_int
		report "s_out_dim non puo' essere minore di s_out_int"
		severity error;
	assert s_in_dim >= s_out_dim
		report "s_in_dim non puo' essere minore di s_out_dim (stai facendo il troncamento"
		severity error;
	assert s_in_int >= s_out_int
		report "s_in_int non puo' essere minore di s_out_int (stai facendo il troncamento"
		severity error;
	
		
	--! <h4>Troncamento</h4>
	--! E' possibile distinguere due casi:
	--! <b>Caso 1</b>: il formato di destinazione ha numero di bit per esprimere la parte intera maggiore uguale di zero.<br>
	--!
	trunc_case_1 : if s_out_int >= 0 generate 
		s_out <= s_in(s_in_dim-1) & s_in((s_in_dim - 2 - x) downto (s_in_dim - s_out_dim - 1 - x)) & padding_pos;
	end generate;
	
	--! <b>Caso 1</b>: il formato di destinazione ha numero di bit per esprimere la parte intera minore di zero.<br>
	--!
	trunc_case_2 : if s_out_int <= 0 generate
		s_out <= s_in(s_in_dim-1) & s_in((s_in_dim - x - 1) downto 0) & padding_neg;
	end generate;
	
	
		
end dataflow;


--! @}
--! @}