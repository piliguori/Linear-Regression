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
--! Prende 5 segnali in ingresso, e attraverso l'utilizzo di moltiplicatori e addizionatori / sottrattori, oltre 
--! all'opportuno troncamento dei valori intermedi calcolati, restituisce i parametri di uscita m ed q per la regressione.
--! La rappresentazione dei segnali è in signed fixed point.
--! @htmlonly
--! <div align='center'>
--! <img src="../schemes/LinearRegressionBlackBox.jpg"/>
--! </div>
--! @endhtmlonly


entity LinearRegression is
    Port ( prim : in STD_LOGIC_VECTOR (4 downto 0);		--! costante in input, 5 bit di parte intera e 0 decimale (m.n = 4.0)
           Sum2 : in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 3 bit di parte intera e 21 decimale (m.n = 2.21)
		   B 	: in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 3 bit di parte intera e 21 decimale (m.n = 2.21)
		   Sum1 : in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 8 bit di parte intera e 16 decimale (m.n = 7.16)
		   C 	: in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, msb di peso -10  (m.n = -10.33)
		   A 	: in STD_LOGIC_VECTOR (23 downto 0);	--! segnale in input, 16 bit di parte intera e 8 decimale (m.n = 15.8)
		   m 	: out STD_LOGIC_VECTOR (23 downto 0);	--! segnale in output, 16 bit di parte intera e 8 decimale (m.n = 15.8)
		   q 	: out STD_LOGIC_VECTOR (23 downto 0));	--! segnaes in output, 8 bit di parte intera e 16 decimale (m.n = 7.16)

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
--! @test
--! <table>
--! <tr>
--!	<th>Test Case #</th>
--! 	<th>Componente interessato</th>
--! 	<th>Obbiettivo</th>
--! 	<th>Input</th>
--! 	<th>Output ottenuto</th>
--! 	<th>Output atteso</th>
--! 	<th>Esito</th>
--! </tr>
--! <tr>
--! 	<td>1</td>
--! 	<td>MULT1</td>
--! 	<td>Verificare che il troncamento post-moltiplicazione venga effettuato correttamente (tagliare 3 bit in testa, 2 in coda)</td>
--! 	<td align="right">
--! 		#prim=b"10110"<br>
--! 		#Sum2=b"100000010011011110101011"
--! 	</td>
--! 	<td align="right">
--! 		mult1_out=	b"00100111100111101001101010010"<br>
--! 		P3=			b"   001111001111010011010100  "</td>
--! 	<td align="right">
--! 		mult1_out=	b"00100111100111101001101010010"<br>
--! 		P3=			b"   001111001111010011010100  "</td>
--! 	<td>Superato</td>
--! </tr>
--! <tr>
--! 	<td>2</td>
--! 	<td>MULT2</td>
--! 	<td>Verificare che il troncamento post-moltiplicazione venga effettuato correttamente (tagliare 8 bit in testa e 16 in coda)</td>
--! 	<td align="right">
--! 		B=b"001100000000000000000000"<br>
--! 		Sum2=b"101000000000000000000000"
--! 	</td>
--! 	<td align="right">
--! 		mult2_out=b"111011100000000000000000000000000000000000000000"<br>
--! 		P2=		  b"        000000000000000000000000                "</td>
--! 	<td align="right">
--! 		mult2_out=b"111011100000000000000000000000000000000000000000"<br>
--! 		P2=		  b"        000000000000000000000000                "</td>
--! 	<td>Superato</td>
--! </tr>
--! <tr>
--! 	<td>3</td>
--! 	<td>MULT3</td>
--! 	<td>Verificare che il troncamento post-moltiplicazione venga effettuato correttamente (tagliare 6 bit dalla testa e 18 dalla coda)</td>
--! 	<td align="right">
--! 		B=b"101011001010110011001010"<br>
--! 		Sum1=b"000011001010110011001010"
--! 	</td>
--! 	<td align="right">
--! 		mult3_out=b"111110111101111111011011110100000000111101100100"<br>
--! 		P1=		  b"111101111111011011110100"</td>
--! 	<td align="right">
--! 		mult3_out=b"111110111101111111011011110100000000111101100100"<br>
--! 		P1=		  b"      111101111111011011110100                  "</td>
--! 	<td>Superato</td>
--! </tr>
--! <tr>
--! 	<td>4</td>
--! 	<td>MULT4</td>
--! 	<td>Verificare che il troncamento post-moltiplicazione venga effettuato correttamente (tagliare 1 bit in testa e 23 bit in coda)</td>
--! 	<td align="right">
--! 		C=b"111111111111000100100011"<br>
--! 		Sum1=b"110100100101101000001000"
--! 	</td>
--! 	<td align="right">
--! 		mult4_out=b"000000000000001010100110011110111101011100011000"<br>
--! 		P4=		  b" 000000000000010101001100"</td>
--! 	<td align="right">
--! 		mult4_out=b"000000000000001010100110011110111101011100011000"<br>
--! 		P4=		  b" 000000000000010101001100"</td>
--! 	<td>Superato</td>
--! </tr>
--! <tr>
--! 	<td>5</td>
--! 	<td>MULT1, MULT3, ADD1</td>
--! 	<td>Verificare che il sommatore ADD1 venga sollecitato correttamente e che produca una somma corretta</td>
--! 	<td align="right">
--! 		#prim=b"01010"<br>
--! 		Sum2=b"001010111100110111101111"<br>
--! 		B=b"001000110100010101100111"<br>
--! 		Sum1=b"001101001011110110010011"
--! 	</td>
--! 	<td align="right">
--! 		mult1_out=b"00001101101100000101101010110"<br>
--! 		P3=		  b"011011011000001011010101"<br>
--! 		mult3_out=b"000001110100010000110111011010011110010100100101"<br>
--! 		P1=		  b"110100010000110111011010"<br>
--! 		S5=       b"001111101001000010101111"
--! 	</td>
--! 	<td align="right">
--! 		mult1_out=b"00001101101100000101101010110"<br>
--! 		P3=		  b"011011011000001011010101"<br>
--! 		mult3_out=b"000001110100010000110111011010011110010100100101"<br>
--! 		P1=		  b"110100010000110111011010"<br>
--! 		S5=       b"001111101001000010101111"
--! 	</td>
--! 	<td>Superato</td>
--! </tr>
--! <tr>
--! 	<td>6</td>
--! 	<td>MULT2, MULT4, ADD6</td>
--! 	<td>Verificare che il sommatore ADD2 venga sollecitato correttamente e che produca una somma corretta</td>
--! 	<td align="right">
--! 		C=b"011000011101000101011010"<br>
--! 		Sum2=b"001010111100110111101111"<br>
--! 		B=b"001000110100010101100111"<br>
--! 		Sum1=b"001101001011110110010011"
--! 	</td>
--! 	<td align="right">
--! 		mult2_out=b"000001100000100100000111110011100100011000101001"<br>
--! 		P2=		  b"000010010000011111001110"<br>
--! 		mult4_out=b"000101000010011011110110000000101010100010101110"<br>
--! 		P4=		  b"001010000100110111101100"<br>
--! 		add2_out= b"001100010101010110111010"<br>
--! 		S6=       b"000110001010101011011101"
--! 	</td>
--! 	<td align="right">
--! 		mult2_out=b"000001100000100100000111110011100100011000101001"<br>
--! 		P2=		  b"000010010000011111001110"<br>
--! 		mult4_out=b"000101000010011011110110000000101010100010101110"<br>
--! 		P4=		  b"001010000100110111101100"<br>
--! 		add2_out= b"001100010101010110111010"<br>
--! 		S6=       b"000110001010101011011101"
--! 	</td>
--! 	<td>Superato</td>
--! </tr>
--! <tr>
--! 	<td>7</td>
--! 	<td>MULT1, MULT2, MULT3, MULT4, ADD5, ADD6, MULT5</td>
--! 	<td>Verificare che il troncamento post MULT5 venga effettuato correttamente (tronca 5 bit in testa e 19 in coda)</td>
--! 	<td align="right">
--! 		C=b"011000011101000101011010"<br>
--! 		Sum2=b"001010111100110111101111"<br>
--! 		B=b"001000110100010101100111"<br>
--! 		Sum1=b"001101001011110110010011"<br>
--! 		A=b"000111101111000111001010"
--! 	</td>
--! 	<td align="right">
--! 		mult2_out=b"000001100000100100000111110011100100011000101001"<br>
--! 		P2=		  b"000010010000011111001110"<br>
--! 		mult4_out=b"000101000010011011110110000000101010100010101110"<br>
--! 		P4=		  b"001010000100110111101100"<br>
--! 		add2_out= b"001100010101010110111010"<br>
--! 		S6=       b"000110001010101011011101"<br>
--! 		mult1_out=b"00001101101100000101101010110"<br>
--! 		P3=		  b"011011011000001011010101"<br>
--! 		mult3_out=b"000001110100010000110111011010011110010100100101"<br>
--! 		P1=		  b"110100010000110111011010"<br>
--! 		S5=       b"001111101001000010101111"<br>
--! 		mult5_out=b"000001111001000000001100000101001110100100010110"<br>
--! 		m        =b"111100100000000110000010"
--! 	</td>
--! 	<td align="right">
--! 		mult2_out=b"000001100000100100000111110011100100011000101001"<br>
--! 		P2=		  b"000010010000011111001110"<br>
--! 		mult4_out=b"000101000010011011110110000000101010100010101110"<br>
--! 		P4=		  b"001010000100110111101100"<br>
--! 		add2_out= b"001100010101010110111010"<br>
--! 		S6=       b"000110001010101011011101"<br>
--! 		mult1_out=b"00001101101100000101101010110"<br>
--! 		P3=		  b"011011011000001011010101"<br>
--! 		mult3_out=b"000001110100010000110111011010011110010100100101"<br>
--! 		P1=		  b"110100010000110111011010"<br>
--! 		S5=       b"001111101001000010101111"<br>
--! 		mult5_out=b"000001111001000000001100000101001110100100010110"<br>
--! 		m        =b"     111100100000000110000010"
--! 	</td>
--! 	<td>Superato</td>
--! </tr>
--! <tr>
--! 	<td>8</td>
--! 	<td>MULT1, MULT2, MULT3, MULT4, ADD5, ADD6, MULT6</td>
--! 	<td>Verificare che il troncamento post MULT6 venga effettuato correttamente (7 bit in testa e 17 in coda)</td>
--! 	<td align="right">
--! 		C=b"011000011101000101011010"<br>
--! 		Sum2=b"001010111100110111101111"<br>
--! 		B=b"001000110100010101100111"<br>
--! 		Sum1=b"001101001011110110010011"<br>
--! 		A=b"000111101111000111001010"
--! 	</td>
--! 	<td align="right">
--! 		mult2_out=b"000001100000100100000111110011100100011000101001"<br>
--! 		P2=		  b"000010010000011111001110"<br>
--! 		mult4_out=b"000101000010011011110110000000101010100010101110"<br>
--! 		P4=		  b"001010000100110111101100"<br>
--! 		add2_out= b"001100010101010110111010"<br>
--! 		S6=       b"000110001010101011011101"<br>
--! 		mult1_out=b"00001101101100000101101010110"<br>
--! 		P3=		  b"011011011000001011010101"<br>
--! 		mult3_out=b"000001110100010000110111011010011110010100100101"<br>
--! 		P1=		  b"110100010000110111011010"<br>
--! 		S5=       b"001111101001000010101111"<br>
--! 		mult6_out=b"000000101111101101010010001101101101111101100010"<br>
--! 		q        =b"011111011010100100011011"
--! 	</td>
--! 	<td align="right">
--! 		mult2_out=b"000001100000100100000111110011100100011000101001"<br>
--! 		P2=		  b"000010010000011111001110"<br>
--! 		mult4_out=b"000101000010011011110110000000101010100010101110"<br>
--! 		P4=		  b"001010000100110111101100"<br>
--! 		add2_out= b"001100010101010110111010"<br>
--! 		S6=       b"000110001010101011011101"<br>
--! 		mult1_out=b"00001101101100000101101010110"<br>
--! 		P3=		  b"011011011000001011010101"<br>
--! 		mult3_out=b"000001110100010000110111011010011110010100100101"<br>
--! 		P1=		  b"110100010000110111011010"<br>
--! 		S5=       b"001111101001000010101111"<br>
--! 		mult6_out=b"000000101111101101010010001101101101111101100010"<br>
--! 		q        =b"       011111011010100100011011"
--! 	</td>
--! 	<td>Superato</td>
--! </tr>
--! </table>
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

--! @} 
