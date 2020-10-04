-- File Name: StateMachine.vhd
-- Project Name: STATE MACHINE VHDL IMPLEMENTATION
--
-- This is the top level entity for a state machine implementation on a Cyclone II
--
-- Author: Gabriel Fontaine-Escobar	
-- Date Created: Oct. 02, 2020
-- Date Modified: Oct. 04, 2020
--																										
-- References 
--																					
-- Unknown Source.(August 2020)
-- Can't find the reference for the clock divider
--
-- Wild Engineering.(October 2020)
-- https://www.youtube.com/watch?v=2ryfFH8VOjg

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StateMachine is
	port (
		clk : in std_logic;
		sel : in std_logic;
		--rst : in std_logic;
		--en : in std_logic;
		hex : out std_logic_vector(6 downto 0);
		led : out std_logic := '1'
	);
end entity StateMachine;

architecture rtl of StateMachine is
	signal cur : std_logic_vector (3 downto 0) := (others => '0');
	signal nxt : std_logic_vector (3 downto 0);
	signal tmp : std_logic_vector (6 downto 0);
	signal cnt : unsigned (25 downto 0) := (others => '0'); 
	
	--signal cmp_vct :  natural := 0; -- comparator
	constant cnt_1hz :  natural := (125e5-1);--(25e6-1); 50Mhz clock, 50% duty cycle
	signal cmp_1hz :  natural := 0; -- comparator
	signal clk_1hz : std_logic := '0';
	signal led_val : std_logic := '1';
begin

  Clk1hzProc : process (clk) is
  begin
    if (rising_edge(clk)) then
      if (cmp_1hz = cnt_1hz) then
		  --sta_clk <= not sta_clk;
        clk_1hz <= not clk_1hz;
        cmp_1hz <= 0;
		  hex <= tmp; --temp result goes to hex
		  cur <= nxt; --jump to next state
		  led_val <= not led_val;
		  led <= led_val;
      else
        cmp_1hz <= cmp_1hz + 1;
      end if;
    end if;
  end process Clk1hzProc;
	
	process (sel, cur)
	begin
		case cur is
			-- Common States
			when "0000" =>
				tmp <= "1100000";
				if (sel = '0') then nxt <= "0001"; -- 1
				else nxt <= "1001"; -- 9
				end if;
			when "0001" =>
				tmp <= "0110000";
				--if (sel = '0') then 
				nxt <= "0010";
				--else nxt <= "1000";
				--end if;
			when "0010" =>
				tmp <= "0011000";
				if (sel = '0') then nxt <= "0011";
				else nxt <= "1000";
				end if;
			when "0011" =>
				tmp <= "0001100";
				if (sel = '0') then nxt <= "0100";
				else nxt <= "0010";
				end if;
			when "0100" =>
				tmp <= "0000110";
				--if (sel = '0') then 
				nxt <= "0101";
				--else nxt <= "1111";
				--end if;
			when "0101" =>
				tmp <= "1000010";
				if (sel = '0') then nxt <= "0000";
				else nxt <= "0000";
				end if;
			-- Figure of 8 States			
			when "0110" =>
				tmp <= "0000101";
				nxt <= "0011";
			when "0111" =>
				tmp <= "0000011";
				nxt <= "0101";
			when "1000" =>
				tmp <= "0010001";
				nxt <= "0111";				
			when others =>
				tmp <= "0100001";
				nxt <= "0110";
		end case;
	end process;

end architecture rtl; --of StateMachine

