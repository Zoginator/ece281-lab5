----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;
 
architecture Behavioral of ALU is
-- components
 
 
-- signals
    signal A, B : signed(7 downto 0);
    signal result_addsub : signed(8 downto 0);
    signal result_logic : signed(7 downto 0);
    signal result_temp : std_logic_vector(7 downto 0);
    signal carry, overflow, zero, negative : std_logic := '0';

begin
 
    A <= signed(i_A);
    B <= signed(i_B);
 
process(A, B, i_op)
    begin
        case i_op(1 downto 0) is
            when "00" =>  -- add
                result_addsub <= ('0' & A) + ('0' & B);
                result_temp <= std_logic_vector(result_addsub(7 downto 0));
                carry    <= result_addsub(8);
                overflow <= (A(7) xor B(7) xor i_op(0)) and (A(7) xor result_addsub(7));

            when "01" =>  -- sub
                result_addsub <= ('0' & A) - ('0' & B);
                result_temp <= std_logic_vector(result_addsub(7 downto 0));
                carry    <= not result_addsub(8);  -- invert for no borrow
                overflow <= (A(7) xor B(7) xor i_op(0)) and (A(7) xor result_addsub(7));

            when "10" =>  -- and
                result_logic <= A and B;
                result_temp <= std_logic_vector(result_logic);
                carry    <= '0';
                overflow <= '0';

            when "11" =>  -- or
                result_logic <= A or B;
                result_temp <= std_logic_vector(result_logic);
                carry    <= '0';
                overflow <= '0';

            when others =>
                result_temp <= (others => '0');
                carry <= '0';
                overflow <= '0';
        end case;
 
        -- Negative flag
        negative <= result_temp(7);
 
        -- Zero flag
        if result_temp = "00000000" then
            zero <= '1';
        else
            zero <= '0';
        end if;
        
        -- Set flags: N Z C V
        o_flags <= negative & zero & carry & overflow;
    end process;
 
    -- Assign final result to output
    o_result <= result_temp;

end Behavioral;
 

 
