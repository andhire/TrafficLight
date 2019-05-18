--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:57:29 05/16/2019
-- Design Name:   
-- Module Name:   C:/e/EmbebidosPro/tst11.vhd
-- Project Name:  EmbebidosPro
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Controlador
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tst11 IS
END tst11;
 
ARCHITECTURE behavior OF tst11 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Controlador
    PORT(
         WCF : IN  std_logic_vector(7 downto 0);
         WOU : IN  std_logic_vector(7 downto 0);
         WFC : IN  std_logic_vector(7 downto 0);
         WUO : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         SemaforoSel : OUT  std_logic_vector(3 downto 0);
         S1 : OUT  std_logic_vector(2 downto 0);
         S2 : OUT  std_logic_vector(2 downto 0);
         S3 : OUT  std_logic_vector(2 downto 0);
         S4 : OUT  std_logic_vector(2 downto 0);
         Cont : OUT  std_logic_vector(5 downto 0);
         MAXXX : OUT  std_logic_vector(7 downto 0);
         POSM : OUT  std_logic_vector(2 downto 0);
         repeat : OUT  std_logic_vector(2 downto 0);
         Tiempo : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal WCF : std_logic_vector(7 downto 0) := (others => '0');
   signal WOU : std_logic_vector(7 downto 0) := (others => '0');
   signal WFC : std_logic_vector(7 downto 0) := (others => '0');
   signal WUO : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal SemaforoSel : std_logic_vector(3 downto 0);
   signal S1 : std_logic_vector(2 downto 0);
   signal S2 : std_logic_vector(2 downto 0);
   signal S3 : std_logic_vector(2 downto 0);
   signal S4 : std_logic_vector(2 downto 0);
   signal Cont : std_logic_vector(5 downto 0);
   signal MAXXX : std_logic_vector(7 downto 0);
   signal POSM : std_logic_vector(2 downto 0);
   signal repeat : std_logic_vector(2 downto 0);
   signal Tiempo : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Controlador PORT MAP (
          WCF => WCF,
          WOU => WOU,
          WFC => WFC,
          WUO => WUO,
          CLK => CLK,
          SemaforoSel => SemaforoSel,
          S1 => S1,
          S2 => S2,
          S3 => S3,
          S4 => S4,
          Cont => Cont,
          MAXXX => MAXXX,
          POSM => POSM,
          repeat => repeat,
          Tiempo => Tiempo
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      
       WCF <="00011001";
       WOU <= "00011001";
       WFC <= "00011001";
       WUO <= "00011001";
		CLK<='1';
		wait for 50 ns;	

       WCF <="00011001";
       WOU <= "00110010";
       WFC <= "00011001";
       WUO <= "00011001";
		CLK<='1';
---De aqui funciona bien
		wait for 120 ns;	

       WCF <="01100100";
       WOU <= "00011001";
       WFC <= "00011001";
       WUO <= "00011001";
		CLK<='1';
      
		wait for 120 ns;	

       WCF <="01100100";
       WOU <= "00011001";
       WFC <= "00011001";
       WUO <= "00011001";
		CLK<='1';
      
		
		wait for 120 ns;	

       WCF <="00011001";
       WOU <= "00011001";
       WFC <= "01100100";
       WUO <= "00011001";
		CLK<='1';
		
		wait for 120 ns;	

       WCF <="00011001";
       WOU <= "00011001";
       WFC <= "00011001";
       WUO <= "00011001";
		CLK<='1';
      wait;
   end process;

END;
