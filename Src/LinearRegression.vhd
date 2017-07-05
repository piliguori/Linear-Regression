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

--! @addtogroup LinearRegression
--! @{
--! @brief Regressione Lineare in VHDL.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--! @mainpage
--! @brief Regressione Lineare.
--! @details
--! Il componente permette di effettuare la regressione lineare.
--! Prende 6 segnali in ingresso e attraverso l'utilizzo di moltiplicatori e sottrattori, oltre 
--! all'opportuno troncamento dei valori intermedi calcolati, restituisce i parametri di uscita m ed q per la regressione.
--! La rappresentazione dei segnali è in signed fixed point.
--! @htmlonly
--! <div align='center'>
--! <img src="../schemes/LinearRegressionBlackBox.jpg"/>
--! </div>
--! @endhtmlonly


entity LinearRegression is
    Port ( prim : in STD_LOGIC_VECTOR (5 downto 0);		--! costante in input, 6 bit di parte intera e 0 decimale (m.n = 5.0)
           Sum2 : in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 3 bit di parte intera e 21 decimale (m.n = 2.21)
		   B 	: in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, msb di peso -1 (m.n = -1.24)
		   Sum1 : in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 8 bit di parte intera e 16 decimale (m.n = 7.16)
		   C 	: in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, msb di peso -7  (m.n = -7.30)
		   A 	: in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 6 bit di parte intera e 18 decimale (m.n = 5.18)
		   m 	: out STD_LOGIC_VECTOR (23 downto 0);	--! segnale in output, 10 bit di parte intera e 14 decimale (m.n = 9.14)
		   q 	: out STD_LOGIC_VECTOR (23 downto 0));	--! segnaes in output, 1 bit di parte intera e 23 decimale (m.n = 0.23)
end LinearRegression;


--! Per il calcolo dei parametri della regressione vengono utilizzati opportunamente dei moltiplicatori
--! e addizionatori/sottrattori. Per effettuare i calcoli in fixed point vengono adoperati opportuni troncamenti/
--! espansioni dei segnali. 
--! @htmlonly
--! <div align='center'>
--! <img src="../schemes/LinearRegression.jpg"/>
--! </div>
--! @endhtmlonly
--!

architecture Structural of LinearRegression is

	component multiplier is
		Generic (nbits1	   : natural := 8; 	
				 nbits2	   : natural := 8); 
		Port ( factor1 : in STD_LOGIC_VECTOR (nbits1-1 downto 0);	
			   factor2 : in STD_LOGIC_VECTOR (nbits2-1 downto 0);	
			   prod : out STD_LOGIC_VECTOR (nbits1+nbits2-1 downto 0));	
	end component;


	component subtractor is
		generic (	nbits 		: 		natural := 32);
		port (		sub1 		: in	std_logic_vector(nbits-1 downto 0);		
					sub2 		: in	std_logic_vector(nbits-1 downto 0);		
					diff			: out	std_logic_vector(nbits-1 downto 0));
	end component;

-- MULT3 
	signal mult3_out : std_logic_vector (29 downto 0):=(others=>'0'); --! Uscita di MULT3 espressa su 30 bit, di cui 9 per 
	--! la parte intera e 21 per quella decimale (m.n = 8.21).
	signal P3 : std_logic_vector (23 downto 0):=(others=>'0'); --! L'uscita di MULT3 deve essere espressa su 24 bit
	--! di cui 7 sono per la parte intera, e 17 per quella decimale (m.n = 6.17).	

-- MULT2
	signal mult2_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULT2 espressa su 48 bit, di cui 3 per 
	--! la parte intera e 45 per quella decimale (m.n = 2.45).
	signal P2 : std_logic_vector (23 downto 0):=(others=>'0'); --!L'uscita di MULT2 deve essere espressa su 24 bit, di cui 
	--! 1 per la parte intera e 23 per quella decimale (m.n = 0.23).		

-- MULT1
	signal mult1_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULT1 espressa su 48 bit, di cui 8 per 
	--! la parte intera e 40 per quella decimale (m.n = 7.40).
	signal P1 : std_logic_vector (23 downto 0):=(others=>'0'); --! L'uscita di MULT1 deve essere espressa su 24 bit,
	--! di cui 7 bit per la parte intera e 17 per quella decimale ( m.n = 6.17 ). 
	--! NOTA : Probabilmente è necessario estendere i bit necessari per la parte frazionaria

-- MULT4
	signal mult4_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULT4 espressa su 48 bit, di cui 2 per
	--! la parte intera e 46 per quella decimale (m.n = 1.46).
	signal P4 : std_logic_vector (23 downto 0):=(others=>'0'); --! L'uscita di MULT4 deve essere espressa su 24 bit, di cui 
	--! 1 per la parte intera e 23 per quella decimale ( m.n = 0.23 ).

-- SUB5
	signal S5 : std_logic_vector (23 downto 0):=(others=>'0'); --! L'uscita di SUB5 deve essere espressa su 24 bit, di cui 
	--! 7 per la parte intera  e 17 per quella decimale ( m.n = 6.17 ).

-- SUB6
	signal S6 : std_logic_vector (23 downto 0):=(others=>'0'); --! L'uscita di SUB6 deve essere espressa su 24 bit, di cui 
	--! 1 per la parte intera e 23 per quella decimale ( m.n = 0.23 ).

-- MULTM					  
	signal multM_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULTM espressa su 48 bit, di cui 13 per 
	--! la parte intera e 35 per quella decimale (m.n = 12.35).

-- MULTQ
	signal multQ_out : std_logic_vector (47 downto 0):=(others=>'0'); --! Uscita di MULTQ espressa su 48 bit, di cui 7 per 
	--! la parte intera e 41 per quella decimale (m.n = 6.41).

begin

	MULT3: multiplier
		Generic map( nbits1 => 6,
					 nbits2 => 24)
		port map ( factor1 => prim,
				   factor2 => Sum2,
				   prod => mult3_out);
				   
	P3 <= mult3_out(27 downto 4);  --! Cambio di rappresentazione dell'uscita di MULT3 da 30 bit, di cui 9 per la parte intera 
	--! (m.n = 8.21) a 24 bit, di cui 7 per la parte intera (m.n = 6.17). Quindi tronchiamo 2 bit in testa e 4 in coda.


	MULT2: multiplier
		Generic map( nbits1 => 24,
					 nbits2 => 24)
		port map ( factor1 => Sum2,
				   factor2 => B,
				   prod => mult2_out);
				   
	P2 <= mult2_out(45 downto 22);  --! Cambio di rappresentazione dell'uscita di MULT2 da 48 bit, di cui 3 per la parte intera 
	--! (m.n = 2.45) a 24 bit, di cui 1 per la parte intera (m.n = 0.23). Quindi tronchiamo 2 bit in testa e 22 in coda.


	MULT1: multiplier
		Generic map( nbits1 => 24,
					 nbits2 => 24)
		port map ( factor1 => B,
				   factor2 => Sum1,
				   prod => mult1_out);
				   
	P1 <= mult1_out(46 downto 23);  --! Cambio di rappresentazione dell'uscita di MULT1 da 48 bit, di cui 8 per la parte intera 
	--! (m.n = 7.40) a 24 bit, di cui 7 per la parte intera (m.n = 6.17). Quindi tronchiamo 1 bit in testa e 23 in coda.


	MULT4: multiplier
		Generic map( nbits1 => 24,
					 nbits2 => 24)
		port map ( factor1 => Sum1,
				   factor2 => C,
				   prod => mult4_out);
				   
	P4 <= mult4_out(46 downto 23);  --! Cambio di rappresentazione dell'uscita di MULT4 da 48 bit, di cui 2 per la parte intera 
	--! (m.n = 1.46) a 24 bit, di cui 1 per la parte intera (m.n = 0.23). Quindi tronchiamo 1 bit in testa e 23 in coda.

	SUB5: subtractor
		Generic map (nbits => 24)
		port map( sub1 => P3,
				  sub2 => P1,
				  diff => S5);
		
	SUB6: subtractor
		Generic map (nbits => 24)
		port map( sub1 => P4,
				  sub2 => P2,
				  diff => S6);
				 
	MULTM: multiplier
		Generic map( nbits1 => 24,
					 nbits2 => 24)
		port map ( factor1 => S5,
				   factor2 => A,
				   prod => multM_out);
				   
	m <= multM_out (44 downto 21); --! L'uscita di  MULT5 deve essere portata da una rappresentazione di 48 bit con
	--! 13 bit di parte intera e 35 decimale (m.n = 12.35), ad una di 24 bit con 10 bit di parte intera e 14 decimale (m.n = 9.14). 
	--! Quindi tronca 3 bit in testa e 21 in coda.		
				   
	MULTQ: multiplier
		Generic map( nbits1 => 24,
					 nbits2 => 24)
		port map ( factor1 => A,
				   factor2 => S6,
				   prod => multQ_out);	  			  
		
				  
	q <= multQ_out(41 downto 18);	--! L'uscita di  MULTQ deve essere portata da una rappresentazione di 48 bit con
	--! 7 bit di parte intera e 41 decimale (m.n = 6.41), ad una di 24 bit con 1 bit di parte intera e 23 decimale (m.n = 0.23). 
	--! Qindi tronca 6 bit in testa e 18 in coda.

end Structural;

--! @} 
