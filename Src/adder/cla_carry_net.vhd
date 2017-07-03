--! @file cla_carry_net.vhd
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
--! @addtogroup CarryLoockahead
--! @{
--! @addtogroup CarryNetwork
--! @{
--! @brief Rete di generazione dei segnali di carry per un adder a quattro bit

--! @cond
library ieee;
use ieee.std_logic_1164.all;
--! @endcond

--! Rete logica di calcolo dei riporti per un addizionatore a quattro bit con carry lookahead. 
--!
--! Permette di anticipare il calcolo dei riporti usando le funzioni "propagazione" e "generazione" prodotte dai singoli
--! blocchi cla_adder_cell, in modo da ridurre tempo necessario ad effettuare il calcolo di tutti i carry, quindi il
--! tempo necessario a completare la somma.
--! Questo blocco calcola solo i carry, pertanto va connesso ai blocchi cla_adder_cell, per il calcolo materiale della somma,
--! così come indicato dallo schema seguente, il quale rappresenta lo schema completo di un addizionatore a quattro bit:
--! @htmlonly
--! <div align='center'>
--! <img src="../../Doc/schemes/nibble_adder.jpg"/>
--! </div>
--! @endhtmlonly 
entity cla_carry_net is
	port (	prop 		: in 	std_logic_vector(3 downto 0);	--! funzione “propagazione” prodotta da cla_adder_cell;
			--! vale 1 quando, sulla base degli ingressi, un adder propaghera' un eventuale carry in ingresso; 
			--! prop(i) = add(i) OR add(i); in questo caso viene prodotta da quattro blocchi cla_adder_cell sulla base dei
			--! loro ingressi
			gen 		: in 	std_logic_vector(3 downto 0);	--! funzione "generazione" prodotta da cla_adder_cell;
			--! vale 1 quando, sulla base degli ingressi, un adder generera' un carry in uscita; gen(i) = add(i) AND add(i);
			--! in questo caso viene prodotta da quattro blocchi cla_adder_cell sulla base dei loro ingressi
			carryin 	: in 	std_logic;	--! segnale di "carry-in", prodotto da un eventuale cla_carry_net a monte. 
			propin 		: in 	std_logic;	--! funzione "propagazione", prodotta da una eventuale cla_carry_net a monte 
			genin 		: in 	std_logic;	--! funzione "generazione", prodotta da una eventuale cla_carry_net a monte 
			carryout	: out 	std_logic_vector(3 downto 0);	--! carry calcolati sulla base delle funzioni "propagazione"
			--! e "generazione" prodotti dai blocchi cla_adder_cell, e sulla base delle funzioni "carry-in", "propagazione"
			--! e "generazione" prodotti da eventuali blocchi a monte; ciascuno dei bit dovra' essere posto in ingresso ad
			--! un blocco cla_adder_cell differente, affinche' possa essere calcolata la somma degli addendi
			propout 	: out 	std_logic; 	--! funzione "propagazione" da porre in ingresso ad un eventuale blocco
			--! cla_carry_net a valle
			genout 		: out 	std_logic); --! funzione "generazione" da porre in ingresso ad un eventuale blocco
			--! cla_carry_net a valle
end cla_carry_net;

--! Implementazione dataflow dell'entita' cla_carry_net. 
--!
--! L'implementazione si basa sul seguente ragionamento:
--! Proviamo ad esprimere, adesso, il carry carryout(i+1) in base alle funzioni gen(i) e prop(i),
--! partendo, ad esempio, da carryout(1).
--! Il carry carryout(0) varra' 1 se al passo precedente è stato generato riporto oppure se verra' propagato il carry
--! carryin. In formule:
--! <center>carryout(0)=genin+(propin*carryin);</center>
--! Possiamo estendere lo stesso ragionamento a carryout(2):
--! <center>carryout(1)=gen(1)+prop(1)*carryout(1)=gen(1)+prop(1)*gen(0)+prop(1)*prop(0)*carryin</center>
--! Cio' significa che il riporto carryout(1) lo si può esprimere sulla base di soli dati di ingresso con reti
--! combinatorie a due livelli, senza utilizzare valori calcolati da nodi precedenti. Tutto ciò si traduce in un minor 
--! tempo necessario ad effettuare il calcolo di tutti i carry, quindi un minor tempo necessario a completare la somma.
--! Purtroppo non si può procedere in questo modo ad oltranza per cui si tende a spezzare" la rete per il calcolo dei
--! carry in blocchi più piccoli, ad esempio reti per il calcolo di carry per quattro bit. Considerando che
--! <center>carryout(4)=gen(3)+prop(3)*carryout(3)=...=genout+propout*carryin</center>
--! con
--! <center>genout=gen(3)+(prop(3)*gen(2))+(prop(3)*prop(2)*gen(1))+(prop(3)*prop(2)*prop(1)*gen(0))+(prop(3)*prop(2)*prop(1)*prop(0)*genin)</center>
--! <center>propout=prop(3)*prop(2)*prop(1)*prop(0)*propin</center>
--! Si può costruire dei blocchi che presentino in uscita i segnali genout e propout, in modo da permettere ad eventuali
--! blocchi successivi il calcolo veloce dei carry sulla base di questi segnali e del segnale carryin.
architecture dataflow of cla_carry_net is
begin
	carryout(0) <= genin or (propin and carryin);
	
	carryout(1) <= 	gen(0) or
					(prop(0) and genin) or 
					(prop(0) and propin and carryin);
	
	carryout(2) <= 	gen(1) or 
					(prop(1) and gen(0)) or
					(prop(1) and prop(0) and genin) or
					(prop(1) and prop(0) and propin and carryin);
					
	carryout(3) <= 	gen(2) or
					(prop(2) and gen(1)) or 
					(prop(2) and prop(1) and gen(0)) or
					(prop(2) and prop(1) and prop(0) and genin) or
					(prop(2) and prop(1) and prop(0) and propin and carryin);
	
	genout <=	gen(3) or
				(prop(3) and gen(2)) or
				(prop(3) and prop(2) and gen(1)) or 
				(prop(3) and prop(2) and prop(1) and gen(0)) or
				(prop(3) and prop(2) and prop(1) and prop(0) and genin);
					
	propout <=	prop(3) and prop(2) and prop(1) and prop(0) and propin;
	
end dataflow;

--! @}
--! @}
--! @}


