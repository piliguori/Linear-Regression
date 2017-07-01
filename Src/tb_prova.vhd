----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.07.2017 19:03:18
-- Design Name: 
-- Module Name: tb_prova - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_prova is
--  Port ( );
end tb_prova;

architecture Behavioral of tb_prova is

component prova is
	generic (m : natural :=24;
			n: natural:=20);
    Port ( x : in STD_LOGIC_VECTOR (m-1 downto 0);
           y : in STD_LOGIC_VECTOR (n-1 downto 0);
           prod: out STD_LOGIC_VECTOR (m+n-1 downto 0));
end component;

 signal x :  STD_LOGIC_VECTOR (23 downto 0) := (others =>'0');
 signal y :  STD_LOGIC_VECTOR (19 downto 0) := (others => '0');
 signal prod: STD_LOGIC_VECTOR (43 downto 0) := (others =>'0');


begin

uut: prova
generic map(m=>24,
			n=>20)
port map(x => x,
		y=>y,
		prod=>prod);
		
		
proc: process
	begin
	x <=x"200000";
	y <=x"80000";
	wait;
	end process; 
end Behavioral;
