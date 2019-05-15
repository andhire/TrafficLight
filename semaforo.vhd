----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:51:10 05/11/2019 
-- Design Name: 
-- Module Name:    semaforo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Semaforo is
    Port ( Color : out  STD_LOGIC_VECTOR (2 downto 0);
			  counts : out  STD_LOGIC_VECTOR (4 downto 0);
			  CEnable: out  STD_LOGIC;
			  Tiempo : in STD_LOGIC_VECTOR(5 downto 0);
           Enable,TrafficComing,CLK : in  STD_LOGIC);
end Semaforo;

architecture Behavioral of Semaforo is
	

	
	--Contador para checar tiempo
	signal count: STD_LOGIC_VECTOR(4 downto 0):= "00000";
	
	--Tiempo promedio 30 segundos
	signal timeToWaitAmarillo : STD_LOGIC_VECTOR(5 downto 0):= Tiempo;
	--Tiempo promedio 6 segundos
	signal timeToWaitRojo : STD_LOGIC_VECTOR(5 downto 0):= "000110";
	
	signal sColor : STD_LOGIC_VECTOR (2 downto 0):= "100";
	
	signal sEnable  : STD_LOGIC ;
	signal firstTime : STD_LOGIC;
	
begin

	process(TrafficComing,Enable,CLK,Tiempo)
		begin
		
			
			if(CLK = '1' and clk'event) then
			
				case sColor is 
					when "001" => 
						count <= count + '1';
						if(count = timeToWaitAmarillo ) then 
							sColor <= "010";
							count <= "00000";
						end if;
						
					when "010" => 
						count <= count +'1';
						if(count = timeToWaitRojo) then 
							sColor <= "100";
							count <= "00000";
						sEnable <= '0';
						end if;
					
						
					when others =>
						if(Enable = '1' and count = timeToWaitRojo ) then
							sColor <= "001";

						end if;
				end case;
			end if;

		end process;
Color <= sColor;
counts <= count;

end Behavioral;

