library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ps2Driver is
    Port (
        rst  : in  std_logic;
        clk  : in  std_logic;
        PS2C : in  std_logic;
        PS2D : in  std_logic;
        data : inout std_logic_vector(7 downto 0);  -- the recived data
        error: out std_logic;  -- an error has ocurred
        event: out std_logic;  -- new data is available
        send : out std_logic   -- send the data in data
        bussy: out std_logic   -- the driver is bussy sending or reciving data
	);
end ps2Driver;

architecture rlt of ps2Driver is
    type fsm_state is (idle, start, wd0, d0, wd1, d1, wd2, d2, wd3, d3, wd4, d4, wd5, d5, wd6, d6, wd7, d7, wparity, parity, wstopstate, stopstate, signalstate);
    signal PS2Data: std_logic_vector(7 downto 0);
    signal PS2Parity: std_logic;
    signal state: fsm_state;
    signal wdTimer: std_logic_vector(15 downto 0);

begin
    process(clk, rst) is begin
        if rst = '1' then
            state   <= idle;
            data    <= (others => '0');
            wdTimer <= (others => '0');
        elsif clk'event and clk = '1' then
            event <= '0';
            bussy <= '1';
            error <= '0';
            wdTimer <= wdTimer + 1;
            if wdTimer(15) = '1' then
                wdTimer <= (others => '0');
                data    <= (others => '0');
                state   <= idle;
                error   <= '1';
                event   <= '1';
            else
                if (send = '1') then
                else
                    case state is
                        when idle =>
                            if PS2C = '0' then
                                state <= start;
                                PS2Data <= (others => '0');
                                wdTimer <= (others => '0');
                            else
                                bussy <= '0';
                                state <= idle;
                                wdTimer <= (others => '0');
                            end if;
                        
                        when start =>
                            if PS2C = '1' then
                                state <= wd0;
                                wdTimer <= (others => '0');
                            else
                                state <= start;
                            end if;

                        when wd0 => -- waiting for bit 0 (when PS2C falls)
                            if PS2C = '0' then
                                state <= d0;
                                wdTimer <= (others => '0');
                            else
                                state <= wd0;
                            end if;

                        when d0 => -- reading bit 0
                            if PS2C = '1' then
                                state <= wd1;
                                wdTimer <= (others => '0');
                            else
                                state <= d0;
                                PS2Data(0) <= PS2D;
                            end if;

                        when wd1 => -- waiting for bit 1 (when PS2C falls)
                            if PS2C = '0' then
                                state <= d1;
                                wdTimer <= (others => '0');
                            else
                                state <= wd1;
                            end if;

                        when d1 => -- reading bit 1
                            if PS2C = '1' then
                                state <= wd2;
                                wdTimer <= (others => '0');
                            else
                                state <= d1;
                                PS2Data(1) <= PS2D;
                            end if;

                        when wd2 => -- waiting for bit 2 (when PS2C falls)
                            if PS2C = '0' then
                                state <= d2;
                                wdTimer <= (others => '0');
                            else
                                state <= wd2;
                            end if;

                        when d2 => -- reading bit 2
                            if PS2C = '1' then
                                state <= wd3;
                                wdTimer <= (others => '0');
                            else
                                state <= d2;
                                PS2Data(2) <= PS2D;
                            end if;

                        when wd3 => -- waiting for bit 3 (when PS2C falls)
                            if PS2C = '0' then
                                state <= d3;
                                wdTimer <= (others => '0');
                            else
                                state <= wd3;
                            end if;

                        when d3 => -- reading bit 3
                            if PS2C = '1' then
                                state <= wd4;
                                wdTimer <= (others => '0');
                            else
                                state <= d3;
                                PS2Data(3) <= PS2D;
                            end if;

                        when wd4 => -- waiting for bit 4 (when PS2C falls)
                            if PS2C = '0' then
                                state <= d4;
                                wdTimer <= (others => '0');
                            else
                                state <= wd4;
                            end if;

                        when d4 => -- reading bit 4
                            if PS2C = '1' then
                                state <= wd5;
                                wdTimer <= (others => '0');
                            else
                                state <= d4;
                                PS2Data(4) <= PS2D;
                            end if;

                        when wd5 => -- waiting for bit 5 (when PS2C falls)
                            if PS2C = '0' then
                                state <= d5;
                                wdTimer <= (others => '0');
                            else
                                state <= wd5;
                            end if;

                        when d5 => -- reading bit 5
                            if PS2C = '1' then
                                state <= wd6;
                                wdTimer <= (others => '0');
                            else
                                state <= d5;
                                PS2Data(5) <= PS2D;
                            end if;

                        when wd6 => -- waiting for bit 6 (when PS2C falls)
                            if PS2C = '0' then
                                state <= d6;
                                wdTimer <= (others => '0');
                            else
                                state <= wd6;
                            end if;

                        when d6 => -- reading bit 6
                            if PS2C = '1' then
                                state <= wd7;
                                wdTimer <= (others => '0');
                            else
                                state <= d6;
                                PS2Data(6) <= PS2D;
                            end if;

                        when wd7 => -- waiting for bit 7 (when PS2C falls)
                            if PS2C = '0' then
                                state <= d7;
                                wdTimer <= (others => '0');
                            else
                                state <= wd7;
                            end if;

                        when d7 => -- reading bit 7
                            if PS2C = '1' then
                                state <= wparity;
                                wdTimer <= (others => '0');
                            else
                                state <= d7;
                                PS2Data(7) <= PS2D;
                            end if;

                        when wparity => -- waiting for parity bit (when PS2C falls)
                            if PS2C = '0' then
                                state <= parity;
                                wdTimer <= (others => '0');
                            else
                                state <= wparity;
                            end if;

                        when parity => -- reading parity bit
                            if PS2C = '1' then
                                state <= wstopstate;
                                wdTimer <= (others => '0');
                            else
                                state <= parity;
                                PS2Parity <= PS2D;
                            end if;

                        when wstopstate => -- waiting for stop bit (when PS2C falls)
                            if PS2C = '0' then
                                state <= stopstate;
                                wdTimer <= (others => '0');
                            else
                                state <= wstopstate;
                            end if;

                        when stopstate => -- reading stop bit
                            if PS2C = '1' then
                                state <= signalstate;
                                wdTimer <= (others => '0');
                            else
                                state <= stopstate;
                            end if;

                        when signalstate => -- signaling
                            state <= idle;
                            event <= '1';
                            if PS2Data < x"7F" and (((PS2Data(0) xor PS2Data(1)) xor (PS2Data(2) xor PS2Data(3))) xor ((PS2Data(4) xor PS2Data(5)) xor (PS2Data(6) xor PS2Data(7)))) = not PS2Parity then
                                data <= PS2Data;
                            else
                                error <= '1';
                            end if;
                        
                        when others =>
                            state <= idle;
                            event <= '1';
                            error <= '1';
                    end case;
                end if;
            end if;
		end if;
    end process;
end rlt;

