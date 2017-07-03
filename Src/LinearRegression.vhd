--! @file LinearRegression.vhd
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

--! Regressione Lineare.
--!
--! Il componente permette di effettuare la regressione lineare.
--! Prende 5 segnali in ingresso, e attraverso l'utilizzo di moltiplicatori e addizionatori / sottrattori, oltre 
--! all'opportuno troncamento dei valori intermedi calcolati, restituisce i parametri di uscita m ed q per la regressione.
--! La rappresentazione dei segnali è in signed fixed point.

entity LinearRegression is
    Port ( prim : in STD_LOGIC_VECTOR (4 downto 0);		--! costante in input, 5 bit di parte intera e 0 decimale (m.n = 4.0)
           Sum2 : in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 3 bit di parte intera e 21 decimale (m.n = 2.21)
		   B 	: in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 3 bit di parte intera e 21 decimale (m.n = 2.21)
		   Sum1 : in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 8 bit di parte intera e 16 decimale (m.n = 7.16)
		   C 	: in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, msb di peso -10  (m.n = -10.33)
		   A 	: in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 16 bit di parte intera e 8 decimale (m.n = 15.8)
		   m 	: out STD_LOGIC_VECTOR (23 downto 0);	--! segnali in output, 16 bit di parte intera e 8 decimale (m.n = 15.8)
		   q 	: out STD_LOGIC_VECTOR (23 downto 0));	--! segnali in output, 8 bit di parte intera e 16 decimale (m.n = 7.16)

end LinearRegression;


--! Per il calcolo dei parametri della regressione vengono utilizzati opportunamente dei moltiplicatori
--! e addizionatori/sottrattori. Per effettuare i calcoli in fixed point vengono adoperati opportuni troncamenti/
--! espansioni dei segnali. 
architecture Structural of LinearRegression is

component multiplier is
	Generic (nbits1	   : natural := 8; 	
			 nbits2	   : natural := 8); 
    Port ( factor1 : in STD_LOGIC_VECTOR (nbits1-1 downto 0);	
           factor2 : in STD_LOGIC_VECTOR (nbits2-1 downto 0);	
           prod : out STD_LOGIC_VECTOR (nbits1+nbits2-1 downto 0));	
end component;


component adder is
	generic (	nbits 		: 		natural := 32;
				use_custom 	:		boolean := false);	
	port (		add1 		: in	std_logic_vector(nbits-1 downto 0);		
				add2 		: in	std_logic_vector(nbits-1 downto 0);		
				sum			: out	std_logic_vector(nbits-1 downto 0);		
				overflow	: out	std_logic);	
end component;

signal mult1_out : std_logic_vector (28 downto 0):=(others=>'0'); --! Uscita di MULT1 espressa su 29 bit, di cui 8 per 
--! la parte intera e 21 per quella decimale (m.n = 7.21).
signal P3 : std_logic_vector (23 downto 0):=(others=>'0'); --!L'uscita di MULT1 deve essere espressa su 24 bit
--! di cui 5 sono per la parte intera, e 19 per quella decimale (m.n = 4.19).	



signal mult2_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULT2 espressa su 48 bit, di cui 6 per 
--! la parte intera e 42 per quella decimale (m.n = 5.42).
signal P2 : std_logic_vector (23 downto 0):=(others=>'0'); --!L'uscita di MULT2 deve essere espressa su 24 bit
--! in cui l'msb ha peso -3 (m.n = -3.26).		

signal mult3_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULT3 espressa su 48 bit, di cui 11 per 
--! la parte intera e 37 per quella decimale (m.n = 10.37).
signal P1 : std_logic_vector (23 downto 0):=(others=>'0'); --! L'uscita di MULT3 deve essere espressa su 24 bit,
--! di cui 5 bit per la parte intera e 19 per quella decimale ( m.n = 4.19 ).

signal mult4_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULT4 espressa su 48 bit, in cui l'msb ha
--! peso pari a -2  (m.n = -2.49).
signal P4 : std_logic_vector (23 downto 0):=(others=>'0'); --! L'uscita di MULT4 deve essere espressa su 24 bit,
--! in cui l'msb ha peso -3 ( m.n = -3.26 ).


signal S5 : std_logic_vector (23 downto 0):=(others=>'0'); --! L'uscita di ADD1 deve essere espressa su 24 bit,
--! di cui 5 per la parte intera  e 19 decimale ( m.n = 4.19 ).


signal add2_out : std_logic_vector (23 downto 0):=(others=>'0'); --! Uscita di ADD2 espressa su 48 bit, in cui l'msb ha
--! peso pari a -3  (m.n = -3.26).
signal S6 : std_logic_vector (23 downto 0):=(others=>'0'); --! L'uscita di ADD2 deve essere espressa su 24 bit,
--! in cui l'msb ha peso -3 ( m.n = -2.25 ).
				  
signal mult5_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULT2 espressa su 48 bit, di cui 21 per 
--! la parte intera e 27 per quella decimale (m.n = 20.27).

signal mult6_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULT2 espressa su 48 bit, di cui 15 per 
--! la parte intera e 33 per quella decimale (m.n = 14.330).

begin

MULT1: multiplier
	Generic map( nbits1 => 5,
				 nbits2 => 24)
	port map ( factor1 => prim,
			   factor2 => Sum2,
			   prod => mult1_out);
			   
P3<= mult1_out(25 downto 2);  --! Cambio di rappresentazione dell'uscita di MULT1 da 29 bit, di cui 8 per la parte intera 
--! (m.n = 7.21) a 24 bit, di cui 5 per la parte intera (m.n = 4.19). Quindi tronchiamo 3 bit in testa e 2 in coda.


MULT2: multiplier
	Generic map( nbits1 => 24,
				 nbits2 => 24)
	port map ( factor1 => Sum2,
			   factor2 => B,
			   prod => mult2_out);
			   
P2<= mult2_out(39 downto 16);  --! Cambio di rappresentazione dell'uscita di MULT2 da 48 bit, di cui 6 per la parte intera 
--! (m.n = 5.42) a 24 bit, in cui l'msb ha peso -3 (m.n = -3.26). Quindi tronchiamo 8 bit in testa e 16 in coda.


MULT3: multiplier
	Generic map( nbits1 => 24,
				 nbits2 => 24)
	port map ( factor1 => B,
			   factor2 => Sum1,
			   prod => mult3_out);
			   
P1<= mult3_out(41 downto 18);  --! Cambio di rappresentazione dell'uscita di MULT3 da 48 bit, di cui 11 per la parte intera 
--! (m.n = 10.37) a 24 bit, di cui 5 per la parte intera (m.n = 4.19). Quindi tronchiamo 6 bit in testa e 18 in coda.


MULT4: multiplier
	Generic map( nbits1 => 24,
				 nbits2 => 24)
	port map ( factor1 => Sum1,
			   factor2 => C,
			   prod => mult4_out);
			   
P4<= mult4_out(46 downto 23);  --! Cambio di rappresentazione dell'uscita di MULT4 da 48 bit, in cui l'msb ha peso -2 (m.n = -2.49),
--! a 24 bit, in cui l'msb ha peso -3 (m.n = -3.26). Quindi tronchiamo 1 bit in testa e 23 in coda.

ADD1: adder
	Generic map (nbits => 24,
				 use_custom => false)
	port map( add1 => P3,
			  add2 => P1,
			  sum => S5,
			  overflow => open);
			  
			  
ADD2: adder
	Generic map (nbits => 24,
				 use_custom => false)
	port map( add1 => P2,
			  add2 => P4,
			  sum => add2_out,
			  overflow => open);
			  
S6 <= add2_out(23) & add2_out (23 downto 1);  --! L'uscita di ADD2 deve essere portata da una rappresentazione a 24 bit con peso
--! dell'msb pari a -3 (m.n = -3.26) a una con 24 bit con peso dell'msb pari a -2 (m.n = -2.25). Quindi tronchiamo un bit in coda ed aggiungiamo
--! un bit in testa con estensione del segno.


MULT5: multiplier
	Generic map( nbits1 => 24,
				 nbits2 => 24)
	port map ( factor1 => S5,
			   factor2 => A,
			   prod => mult5_out);
			   
m <= mult5_out (42 downto 19); --! L'uscita di  MULT5 deve essere portata da una rappresentazione di 48 bit con
--! 21 bit di parte intera e 27 decimale (m.n = 20.27), ad una di 24 bit con 16 bit di parte intera e 8 decimale (m.n = 15.8). 
--! Qindi tronca 5 bit in testa e 19 in coda.		
			   
MULT6: multiplier
	Generic map( nbits1 => 24,
				 nbits2 => 24)
	port map ( factor1 => A,
			   factor2 => S6,
			   prod => mult6_out);	  			  
	
			  
q <= mult6_out(40 downto 17);	--! L'uscita di  MULT6 deve essere portata da una rappresentazione di 48 bit con
--! 15 bit di parte intera e 33 decimale (m.n = 14.33), ad una di 24 bit con 8 bit di parte intera e 16 decimale (m.n = 7.16). 
--! Qindi tronca 7 bit in testa e 17 in coda.

end Structural;

