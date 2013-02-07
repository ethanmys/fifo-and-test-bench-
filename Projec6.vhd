----------------------------------------------------------------------------------
-- Author: Ethan Kho
-- Design overview: fifo and test bench for verification
-- Design name: project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Projec6 is
generic (
num_words:positive :=256; 
word_width: positive :=16;
al_empty_lev:natural:=5; 
al_full_lev:natural :=28
);
port(
clk: in std_logic;
we:in std_logic;
re:in std_logic;
rst:in std_logic;
din:in std_logic_vector(word_width-1 downto 0);
almost_empty: out std_logic;
empty: out std_logic;
almost_full: out std_logic;
full:out std_logic;
dout: out std_logic_vector(word_width-1 downto 0)
);
end Projec6;

architecture Behavioral of Projec6 is
type ram_type is array(31 downto 0) of std_logic_vector( word_width-1 downto 0);
signal ram: ram_type;
signal read_adr:unsigned(4 downto 0);
signal write_adr:unsigned(4 downto 0);
signal Fifofull_sig:std_logic;
signal Fifoempty_sig:std_logic;

begin

process(clk,rst)
begin
	if (clk'event and clk='1') then 
		if(rst='1') then 
			read_adr<= to_unsigned(0,read_adr' length);
			write_adr<= to_unsigned(0,write_adr' length);
		end if;
		if (we='1' and Fifofull_sig='0') then
			ram(to_integer(write_adr))<=din;
			write_adr<=write_adr+1;
		end if;
		if (re='1' and Fifoempty_sig='0') then 
			read_adr<=read_adr+1;
			dout<=ram(to_integer(read_adr));
		end if;
	end if;
end process;

process(write_adr)
begin
if (to_integer(write_adr))>=(al_full_lev) and ((to_integer(write_adr))<31) then
	almost_full<='1';
else
	almost_full<='0';
end if;
if ((to_integer(write_adr))>0 and (to_integer(write_adr))<=al_empty_lev) then
	almost_empty<='1';
else
	almost_empty<='0';
end if;
end process;

Fifoempty_sig<='1' when (write_adr="00000") else '0';
Fifofull_sig<='1' when (write_adr="11111") else '0';
Full<=Fifofull_sig;
empty<=Fifoempty_sig;
end Behavioral;

