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
-- use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if instantiating 
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;
 
entity ALU is
    Port ( --A_in    : in  STD_LOGIC_VECTOR (7 downto 0);
           --B_in    : in  STD_LOGIC_VECTOR (7 downto 0);
           --ALUOp   : in  STD_LOGIC_VECTOR (2 downto 0);
           --result  : out STD_LOGIC_VECTOR (7 downto 0);
           --flags   : out STD_LOGIC_VECTOR (3 downto 0));
           i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;
 
architecture behavioral of ALU is
    component ripple_adder
        port ( A     : in  STD_LOGIC_VECTOR(3 downto 0);
               B     : in  STD_LOGIC_VECTOR(3 downto 0);
               Cin   : in  STD_LOGIC;
               S     : out STD_LOGIC_VECTOR(3 downto 0);
               Cout  : out STD_LOGIC);
    end component;
 
    signal x_sum, resultOUT : STD_LOGIC_VECTOR(7 downto 0);
    signal x_lower_carry, x_upper_carry : STD_LOGIC;
    signal q_result : STD_LOGIC_VECTOR(7 downto 0);
    signal B_mux : STD_LOGIC_VECTOR(7 downto 0);
    signal Cin_mux : STD_LOGIC;
    
    
begin
    u0_ALU : ripple_adder
        port map ( A    => i_A(3 downto 0),
                   B    => B_mux(3 downto 0),
                   Cin  => Cin_mux,
                   S    => x_sum(3 downto 0),
                   Cout => x_lower_carry );
 
    Ripple_Upper : ripple_adder -- Upper Bits
        port map ( A    => i_A(7 downto 4),
                   B    => B_mux(7 downto 4),
                   Cin  => x_lower_carry,
                   S    => x_sum(7 downto 4),
                   Cout => x_upper_carry );
 
    -- MUX
    B_mux   <= not i_B when i_op = "001" else i_B;
    Cin_mux <= '1' when i_op = "001" else '0';
    
    resultOUT <= x_sum when i_op = "000" else
                 x_sum when i_op = "001" else
                 (i_A and i_B) when i_op = "010" else
                 (i_A or i_B) when i_op = "011" else
                 (others => '0');
                 
       
 
    q_result <= resultOUT;
 
    -- overflow flag
    o_flags(0) <= not (i_A(7) xor i_B(7) xor i_op(0)) and (i_A(7) xor x_sum(7)) and (not i_op(1));
 
    -- carry
    o_flags(1) <= x_upper_carry and (not i_op(1));
 
    -- negative
    o_flags(3) <= resultOUT(7);
 
    -- zero
    o_flags(2) <= '1' when (resultOUT = "00000000") else '0';
 
    o_result <= q_result;
end behavioral;

 
