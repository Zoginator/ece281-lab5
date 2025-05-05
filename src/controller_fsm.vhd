----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
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

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is

signal f_Q : STD_LOGIC_VECTOR (1 downto 0);
signal f_Q_next : STD_LOGIC_VECTOR (1 downto 0);

begin

	-- Next state logic
	f_Q_next <= "00" when f_Q = "11" and i_adv = '1' else
	            "01" when f_Q = "00" and i_adv = '1' else
	            "10" when f_Q = "01" and i_adv = '1' else
	            "11" when f_Q = "10" and i_adv = '1' else
	            f_Q_next;
	
	
	-- Output logic
	with f_Q select
	o_cycle <= "0001" when "00",
	           "0010" when "01",
	           "0100" when "10",
	           "1000" when "11",
	           "0001" when others;
	         
	-------------------------------------------------------	
	
	-- PROCESSES ----------------------------------------	
	-- state memory w/ asynchronous reset ---------------
    register_proc : process (i_adv, i_reset)
	begin
	   if i_reset = '1' then
	       f_Q <= "00";
	   elsif (i_adv = '1') then
	       f_Q <= f_Q_next;
	   end if;
	end process register_proc;	   
end FSM;
