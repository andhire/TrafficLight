----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:02:14 05/11/2019 
-- Design Name: 
-- Module Name:    controlador - Behavioral 
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
--Librerias necesarias para las operaciones.
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


--Definicion de las entidad
entity Controlador is
    Port ( WCF,WOU,WFC,WUO : in  STD_LOGIC_VECTOR ( 7 downto 0); -- Entradas para la ponderacion de cada semaforo
           CLK : in  STD_LOGIC; -- Señal de reloj
           SemaforoSel : out  STD_LOGIC_VECTOR (3 downto 0); -- Selector
			  S1,S2,S3,S4: out STD_LOGIC_VECTOR(2 downto 0); -- Señales del estado de los semaforos
			  Cont: out STD_LOGIC_VECTOR(5 downto 0); -- Contador
			  MAXXX: out STD_LOGIC_VECTOR(7 downto 0); -- Variable de maximo peso
			  POSM: out STD_LOGIC_VECTOR(2 downto 0); -- Posicion donde se encuentra el peso masimo
			  repeat: out STD_LOGIC_VECTOR(2 downto 0); -- Variable para checar si el peso es el mismo y se repite
           Tiempo : out  STD_LOGIC_VECTOR (5 downto 0)); -- Tiempo
end Controlador;

-- Arquitectura del controlador
architecture Behavioral of Controlador is
	
	signal selector : STD_LOGIC_VECTOR(2 downto 0); -- Señal del selector
	signal posMax : STD_LOGIC_VECTOR(2 downto 0); 	-- Señal para la posicion maxima
	signal max : STD_LOGIC_VECTOR(7 downto 0):="00000000"; -- valor maximo iniciado en 0
	signal tiempoVerde: STD_LOGIC_VECTOR(5 downto 0):="001000"; -- Tiempo que durara el semaforo en estado de siga
	signal sEnable :  STD_LOGIC_VECTOR(3 downto 0);	-- Señal que habilita los semaforos
	signal count : STD_LOGIC_VECTOR(5 downto 0):= "000000"; -- Contador
	signal ss1,ss2,ss3,ss4:STD_LOGIC_VECTOR(2 downto 0):="100"; 	-- Señales del estado de los semaforos
	signal pastS : STD_LOGIC_VECTOR(2 downto 0); -- Variable para checar si el mismo estado es el siguiente
	signal repeatNumber: STD_LOGIC_VECTOR(2 downto 0):="000"; -- Variable para cambiar los semaforos
begin
	--Inicializacion de semaforo con sus entradas
	process(WCF,WOU,WUO,WFC,CLK)
		begin
		
			if(CLK = '1' and clk'event) then -- Flanco de subida del reloj
				count <= count + '1';		-- Aumentamos el contador del tiempo
				if( count = tiempoVerde - "000010" ) then	 -- Un segundo antes de que llegue al tiempo de cambiar
					--Comprobamos si la circulacion de todos los semaforos es minima
					if WFC = "00011001" and WOU = "00011001" and WCF = "00011001" and WUO = "00011001" then
						max <= "00011001"; -- Asignamos la ponderacion 
						posMax <= repeatNumber; --Asignamos el semaforo que se eligio
						if(repeatNumber = "011") then  -- Comprobamos si ya llego al 4 semaforo
							repeatNumber <= "000";
						else
							repeatNumber <= repeatNumber +'1'; --Aumentamos el semaforo al siguiente
						end if;
					--Obtenemos el mayor y asignamos ponderacion y posicion
					elsif( WCF>=WOU and WCF >= WFC and WCF >= WUO) then
						max <= WCF;
						posMax <= "000";
					elsif ( WOU>=WCF and WOU >= WFC and WOU >= WUO) then
						max <= WOU;
						posMax <= "001";
					elsif ( WFC>=WCF and WFC >= WOU and WFC >= WUO) then
						max <= WFC;
						posMax <= "010";
					elsif ( WUO>=WCF and WUO >= WFC and WUO >= WOU) then
						max <= WUO;
						posMax <= "011";
					end if;

					
						
						
					

				
				-- Si el semaforo a actualizar es el mismo que el pasado reiniciamos el contador y asignamos el nuevo tiempo	
				elsif (pastS = posMax  and ( count = tiempoVerde - "000001" )) then
						count<="000000";
						if max = "01100100" then
							tiempoVerde <= "110000";
							elsif max = "01001011" then
								tiempoVerde <= "100100";
							elsif max = "00110010" then
								tiempoVerde <= "011000";
							elsif max = "00011001" then
								tiempoVerde <= "001100";
							end if;
							pastS <= posMax ;

				
				-- Un segundo antes de cambiar el estado, asignamos el semaforo pasado a su variable
				elsif count = tiempoVerde -"000001" then
					pastS <= posMax ;
					
				
				else
					--Checamos cual semaforo se habilitara
					case sEnable is
						--semaforo 1, CUCEI hacia Forum
						when "0001" => 
							case ss1 is 
								when "001" => --Cuando se cumpla el tiempo 
									if(count = (tiempoVerde ) ) then 
									--Cambiamos el estado a preventivo
										ss1 <= "010"; 
										
									end if;
									
								when "010" => --Despues de 6 segundos
									if(count = tiempoVerde +"000110") then 
									--El contador se vuelve 0 
										count<="000000";
									--Asignamos el estado a rojo
										ss1 <= "100";
									--Deshabilitamos el semaforo
										sEnable(0) <= '0';
								
									end if;
								
									
								when others =>
									if(sEnable(0) = '1') then
										ss1 <= "001";
										
									end if;
							end case;
						--semaforo 2, Olimpica hacia Uteg(direccion minerva)
						when "0010" =>
							case ss2 is 
								when "001" => --Cuando se cumpla el tiempo 
									if(count = (tiempoVerde) ) then 
									--Cambiamos el estado a preventivo
										ss2 <= "010";
										
									end if;
									
								when "010" =>  --Despues de 6 segundos
									if(count = tiempoVerde +"000110") then 
									--El contador se vuelve 0 
										count<="000000";
										--Asignamos el estado a rojo
										ss2 <= "100";
								--Deshabilitamos el semaforo
										sEnable(1) <= '0';
										
									end if;
								
									
								when others =>
									if(sEnable(1) = '1') then
										ss2 <= "001";
			
									end if;
							end case;
							
						--semaforo 3, Forum hacia CUCEI
						when "0100" =>
							case ss3 is 
								when "001" => --Cuando se cumpla el tiempo 
									if(count = (tiempoVerde ) ) then 
									--Cambiamos el estado a preventivo
										ss3 <= "010";
										
									end if;
									
								when "010" =>  --Despues de 6 segundos
									if(count = tiempoVerde +"000110") then 
									--Asignamos el estado a rojo
										ss3 <= "100";
										--Deshabilitamos el semaforo
										sEnable(2) <= '0';
										--El contador se vuelve 0 
										count<="000000";
									end if;
								
									
								when others =>
									if(sEnable(2) = '1') then
										ss3 <= "001";

									end if;
							end case;
						--semaforo 2, UTEG hacia Olimpica(direccion Medrano)
						when "1000" =>
							case ss4 is 
								when "001" => --Cuando se cumpla el tiempo 
									if(count = (tiempoVerde) ) then 
									--Cambiamos el estado a preventivo
										ss4 <= "010";
										
									end if;
									
								when "010" =>  --Despues de 6 segundos
									if(count = tiempoVerde +"000110") then 
									--Asignamos el estado a rojo
										ss4 <= "100";
								--Deshabilitamos el semaforo
										sEnable(3) <= '0';
										--El contador se vuelve 0 
										count<="000000";
									end if;
								
									
								when others =>
									if(sEnable(3) = '1') then
										ss4 <= "001";
			
									end if;
							end case;
						
						when others =>null;
										
						end case;
						--Si el contador despues de los 6 segundos, asigna el nuevo semaforo a habilitar
						if  count = tiempoVerde + "000110"  then
							case posMax is
							--100
								when "000" => 
									sEnable(0) <='1';
									sEnable(1) <='0';
									sEnable(2) <='0';
									sEnable(3) <='0';
								--75
								when "001" =>
									sEnable(0) <='0';
									sEnable(1) <='1';
									sEnable(2) <='0';
									sEnable(3) <='0';
									
								--50
								when "010" =>
									sEnable(0) <='0';
									sEnable(1) <='0';
									sEnable(2) <='1';
									sEnable(3) <='0';
								--25
								when "011" =>
									sEnable(0) <='0';
									sEnable(1) <='0';
									sEnable(2) <='0';
									sEnable(3) <='1';
								
								when others =>
									sEnable(0) <='0';
									sEnable(1) <='0';
									sEnable(2) <='0';
									sEnable(3) <='0';
											
								end case;
								--Asignacion de nuevo tiempo 
								if max = "01100100" then
									tiempoVerde <= "110000";
									elsif max = "01001011" then
										tiempoVerde <= "100100";
									elsif max = "00110010" then
										tiempoVerde <= "011000";
									elsif max = "00011001" then
										tiempoVerde <= "001100";
									end if;
								
						
						end if;
				end if;
			
				
			end if;
				
		end process;

--Asignacion de señales a salidas 
	S1 <= ss1;
	S2 <= ss2;
	S3 <= ss3;
	S4 <= ss4;
	SemaforoSel <= sEnable;
	Tiempo <= tiempoVerde;
	Cont<=count;
	MAXXX <= max;
	POSM<= posMax;
	repeat<= repeatNumber;
end Behavioral;

