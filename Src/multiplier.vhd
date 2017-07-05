--! @file multiplier.vhd
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

--! @addtogroup Multiplier
--! @{
--! @brief Multiplier per il prodotto di due fattori con numero di bit variabile.
--! @cond
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--! @endcond

--! Moltiplicatore a due fattori.
--!
--! Il moltiplicatore permette di effettuare un prodotto di due fattori espressi su un certo numero di bit.
--! I due fattori possono essere espressi anche su un numero di bit e rappresentazioni differenti tra loro.
--! Se nbit1 è il numero di bit su cui viene espresso il fattore 1, e nbit2 è il numero di bit su cui viene espresso
--! il fattore 2, allora l'uscita prod risulta essere espressa su nbit1+nbit2. <br>
--! Ad esempio, se il fattore 1 è rappresentato con mx.nx (con mx il peso del bit più significativo della parte intera ed
--! nx il peso del bit meno significativo della parte decimale) e il fattore 2 è rappresentato con my.ny, allora
--! l'uscita sarà rappresentata in mx+my+1.nx+ny

entity multiplier is
	Generic (nbits1	   : natural := 8; 	--! dimensione del primo fattore
			 nbits2	   : natural := 8); --! dimensione del secondo fattore
    Port ( factor1 : in STD_LOGIC_VECTOR (nbits1-1 downto 0);	--! fattore 1
           factor2 : in STD_LOGIC_VECTOR (nbits2-1 downto 0);	--! fattore 2
           prod : out STD_LOGIC_VECTOR (nbits1+nbits2-1 downto 0));	--! prodotto dei due fattori
end multiplier;

--! Per il prodotto viene utilizzato l'operatore *. La sintesi viene lasciata al particolare sintetizzatore.
architecture Structural of multiplier is

begin

prod <= std_logic_vector(signed(factor1)*signed(factor2));


end Structural;

--! @} 