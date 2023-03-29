 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
entity automat2 is
	port(
	senzor1: in std_logic;
	senzor2: in std_logic;	
	start: in std_logic;
	reset: in std_logic;  
	clk:in std_logic;
	temperatura: out integer;	
	minut:out integer;
	ora:out integer;
	ziua:out integer;
	luna:out integer;
	afisare_7seg:out integer
	);
end entity;

architecture func_automat2 of automat2 is
signal temperatura_default : integer:=15;	

signal count_minut: integer:=0;	   --semnal cu care numaram minutele
signal semnal_reset_minut:std_logic:='0';  --semnal cu care resetam count_minut la 0 pt count_minut=59, si incrementam count_ora
signal count_ora: integer:=0; --semnal cu care numaram orele
signal semnal_reset_ore:std_logic:='0';	 --semnal cu care resetam count_ore la 0 pt count_ore=23,si incrementam count_ziua
signal count_ziua: integer:=0; 	 --semnal cu care numaram orele
signal semnal_reset_zile:std_logic:='0'; --semnal cu care resetam count_ziua la 0 pt count_ziua=31, si incrementam count_luna
signal count_luna:integer:=0;  --semnal cu care numaram lunile
signal semnal_reset_luni:std_logic:='0'; --semnal cu care resetam count_luna la 0 pt count_luna=11 si revenim in bucla(st initiala)
signal ok_minut : std_logic; --semanl cu care incrementam minutele
signal ok_ora: std_logic;   --semnal cu care incrementam orele
signal ok_zi: std_logic;    --semnal cu care incrementam ziua
signal ok_luna:std_logic;   --semnal cu care incrementam luna
signal ciclic:integer:=0;

constant minute :integer:=59;
constant ore: integer :=23;
constant zile: integer:=30;
constant luni:integer  :=11;



begin
	
	
			   
			   
		
		
	--pe baza input-urilor senzor1 si senzor2,verific daca temperatura
	--este mai mare decat temperatura_default(15 C) si atunci o incrementez
	--sau daca este mai mica decat temperatura_default(15 C) si atunci o decrementez
	
		Modific_Temperatura:process(senzor1,senzor2,clk)
		begin
			if(clk='1' and clk'event) then
				 
				if (senzor1='1' and senzor2='0')then
				    temperatura_default<=temperatura_default+1;
				elsif (senzor1='0' and senzor2='1') then
					temperatura_default<=temperatura_default-1;
				end if;
				end if;
				
				temperatura<=temperatura_default;
			end process; 	
		--counter cu care numar minutele
		--pseudocod:
		-- ifstart=1 && reset!=0 
		-- count_min++
		--else count_min=0;
            
		Numar_Minute:process(clk,count_minut,semnal_reset_minut,start)	
		begin
		if(clk='1' and clk'event )then	
			if(reset='0')then
			if(start='1')then 
				if(semnal_reset_minut='0') then
				count_minut<=count_minut+1;
				else count_minut<=0;
	
				
			end if;	
			end if;
		end if;
		end if;
		end process; 
		
		
		--circuit cu care verific daca pot genera ora
		--pseudocod 
		--(if minute=59)
			--min=0 & ora++;
		Generez_Ora: process(clk,count_minut)
		begin
		
			if (count_minut=minute)then
				ok_minut<='1'; 
				semnal_reset_minut<='1';
			else
				ok_minut<='0'; 
				semnal_reset_minut<='0';
			end if;
			
		end process;
		
		--circuit  cu care numar orele
		--pseudocod:
		--if minute=59 && semnal_reset_ore=0
			--ora++;
		--else
			--ora=0(pt semnal_reset_ore=1) 
			--ora=ora(pt semnal_reset_ore=0)
			
		Numar_Ore:process(clk,count_ora,ok_minut)
		begin
			if(clk='1' and clk'event)then
				if(reset='0')then  
					if(ok_minut='1') then
					if (semnal_reset_ore='0') then
					count_ora<=count_ora+1;
				else count_ora<=0;
				end if;	
				end if;
				end if;
				end if;
				
			end process;
			
		--circuit cu care verific daca pot genera ziua
		--pseudocod:
		--if ore=23 
			--ore=0 & ziua++;
	    Generez_Ziua: process(clk,count_ora)
		begin
			if(clk='1' and clk'event)then
				if(count_ora=ore)then
					ok_ora<='1';
					semnal_reset_ore<='1';
				else 
					ok_ora<='0';
					semnal_reset_ore<='0';
				end if;
				end if;
			end process;  
			
			--circuit cu care numar zilele
			--pseudocod
			-- if ore=23 && semnal_reset_ore =0	
				--ziua++
			--else
				--ziua=0 (pt semnal_reset_ore=1)
				--ziua=ziua(pt semnal_reset_ore=0)
			Numar_Zile: process (clk,ok_ora,semnal_reset_ore)
			begin 
				if (clk='1' and clk'event) then 
					if(ok_ora='1')then	
						if(semnal_reset_ore='0')then
						count_ziua<=count_ziua+1;
						
					else count_ziua<=0;
					end if;
					end if;	
					end if;
				end process;
			--circuit cu care verific daca pot genera luna
			--pseudocod:
			--if  zile=30 
				--zile=0 & luna++;
				Generez_Luna:process(clk,count_ziua)
				begin
					if(clk='1' and clk'event)then
						if(count_ziua=zile) then
							ok_luna<='1';	
							semnal_reset_luni<='1';
							
						else
							ok_luna<='0';
							semnal_reset_luni<='0';
						end if;
						end if;
					end process;
					
					--circuit cu care numar lunile
					--pseudocod
					--if zile=30 && semnal_reset_luni=0
					-- luni++
					--else
						--luni=0(semnal_reset_luni=1)
						--luni=luni (semnal_reeset_luni=0)
					Numar_Luni: process(clk,ok_luna,semnal_reset_luni)
					begin
						if(clk='1' and clk'event)then
							if(ok_luna='1')then		
								if(semnal_reset_luni='0') then
								count_luna<=count_luna+1;
							else count_luna<=0;
							end if;
							end if;
							end if;
						end process;
						
						
						minut<=count_minut;
						ora<=count_ora;
						ziua<=count_ziua;
						luna<=count_luna; 
						
						  
				--pentru afisarea ciclica,folosesc un counter mod16 care sa
				--genereze selectiile multiplexorului 16:1
				Counter_Mod16: process (clk,ciclic)
				begin
					if(clk='1' and clk'event)then 
						if(ciclic<=15) then
						ciclic<=ciclic+1;  
						else
							ciclic<=0;
						end if;
						end if;
					end process;  
					
					
					MUX16_Afisare:process(clk,ciclic)
					begin
						case ciclic is

when 0 => afisare_7seg<=count_minut;
when 1=>afisare_7seg<=count_minut;
when 2=> afisare_7seg<=count_minut;	
when 3=>  afisare_7seg<=count_minut;	
when 4=>afisare_7seg<=count_ora;
when 5=>afisare_7seg<=count_ora;
when 6=>afisare_7seg<=count_ora;
when 7=>afisare_7seg<=count_ora;
when 8=>afisare_7seg<=count_ziua;
when 9=>afisare_7seg<=count_ziua;	
when 10=>afisare_7seg<=count_ziua;
when 11=>afisare_7seg<=count_ziua; 
when 12=>afisare_7seg<=count_luna;
when 13=>afisare_7seg<=count_luna;
when 14=>afisare_7seg<=count_luna;
when 15=>afisare_7seg<=temperatura_default;	  
when others =>null;



end case;
end process;
				
							
			end architecture;