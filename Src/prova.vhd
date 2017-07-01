----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.07.2017 18:07:28
-- Design Name: 
-- Module Name: prova - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.MATH_REAL.all;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity prova is
	generic (m : natural :=24;
			n: natural:=20);
    Port ( x : in STD_LOGIC_VECTOR (m-1 downto 0);
           y : in STD_LOGIC_VECTOR (n-1 downto 0);
           prod: out STD_LOGIC_VECTOR (m+n-1 downto 0));
end prova;

architecture Behavioral of prova is




begin
prod<=std_logic_vector(signed(x)*signed(y));


end Behavioral;
