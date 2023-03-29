library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity bcd_7segmente is
Port ( BCDin : in STD_LOGIC_VECTOR (3 downto 0);
Sapte_Segmente : out STD_LOGIC_VECTOR (6 downto 0));
end bcd_7segmente;
 
architecture arh of bcd_7segmente is
 
begin
 
process(BCDin)
begin
 
case BCDin is
when "0000" =>
Sapte_Segmente <= "1111110"; --0
when "0001" =>
Sapte_Segmente <= "0110000"; --1
when "0010" =>
Sapte_Segmente <= "1101101"; --2
when "0011" =>
Sapte_Segmente <= "1111001"; --3
when "0100" =>
Sapte_Segmente <= "0110011"; --4
when "0101" =>
Sapte_Segmente <= "1011011"; --5
when "0110" =>
Sapte_Segmente <= "1011111"; --6
when "0111" =>
Sapte_Segmente <= "1110000"; --7
when "1000" =>
Sapte_Segmente <= "1111111"; --8
when "1001" =>
Sapte_Segmente <= "1111011"; --9
when others =>
Sapte_Segmente <= "1111111"; --null
end case;
 
end process;
 
end arh;