--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:39:08 10/27/2011
-- Design Name:   
-- Module Name:   C:/fpgaclass/project6/project6_tb.vhd
-- Project Name:  project6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Projec6
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
USE work.test_procs.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY project6_tb IS
END project6_tb;
 
ARCHITECTURE behavior OF project6_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Projec6
    PORT(
         clk : IN  std_logic;
         we : IN  std_logic;
         re : IN  std_logic;
         rst : IN  std_logic;
         din : IN  std_logic_vector(15 downto 0);
         almost_empty : OUT  std_logic;
         empty : OUT  std_logic;
         almost_full : OUT  std_logic;
         full : OUT  std_logic;
         dout : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal we : std_logic := '0';
   signal re : std_logic := '0';
   signal rst : std_logic := '0';
	signal din: std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal almost_empty : std_logic;
   signal empty : std_logic;
   signal almost_full : std_logic;
   signal full : std_logic;
   signal dout : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Projec6 PORT MAP (
          clk => clk,
          we => we,
          re => re,
          rst => rst,
          din => din,
          almost_empty => almost_empty,
          empty => empty,
          almost_full => almost_full,
          full => full,
          dout => dout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
		
   -- Stimulus process
   stim_proc: process
	   variable outlar: std_logic_vector(15 downto 0) := (others => '0');
		file myfile:text open read_mode is "rand300x16.txt";
   begin		
      wait for 2*clk_period;
		-- hold reset state for 100 ns.
		rst<='1';
      wait for 3*clk_period;	
		rst<='0';
		assert empty='1';
			report "Error, it is not on empty state"
			severity error;
--read the first value
		we<='1';
		loadfifo(outlar);
		din<=outlar; 
		wait for clk_period;
		we<='0';
		re<='1';
		wait for clk_period;
		re<='0';
		wait for clk_period;
		assert dout=x"5F21";
			report"Error, it is not the value of 5F21"
			severity error;
--read the second value 
		we<='1';
		loadfifo(outlar);
		din<=outlar; 
		wait for clk_period;
		we<='0';
		re<='1';
		wait for clk_period;
		re<='0'; 
		wait for clk_period;
		assert almost_empty='1';
			report "Error, almost_empty is not 1"
			severity error; 
		assert dout=x"6CDD";
			report"Error, it is not the value of 6CDD"
			severity error;
--reset the fifo
		rst<='1';
		wait for 2*clk_period;
		rst<='0';
		while not endfile(myfile) loop
				we<='1';
				loadfifo(outlar);
				din<=outlar;
				wait for clk_period;
		end loop;
				re<='1';
				wait until full='1';
				re<='0';
				wait for clk_period; 
		-- check dout and full at the end of the file
		assert dout=x"E424";
			report "Error, it is not the value of E424 at the end of the file"
			severity error;
		assert full='1';
			report "Error, full state is not 1"
			severity error;
      wait;
   end process;

END;
