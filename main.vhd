library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity main is
    Port (
        rst	 : in  std_logic;
        clk	 : in  std_logic;
        Hsync: out std_logic;
        Vsync: out std_logic;
        vgaR : out std_logic_vector(3 downto 1);
        vgaG : out std_logic_vector(3 downto 1);
        vgaB : out std_logic_vector(3 downto 2);
        --btn  : in  std_logic_vector(3 downto 0);
        Led  : out std_logic_vector(7 downto 0);
        PS2C : in std_logic;
        PS2D : in std_logic
    );
end main;

architecture rtl of main is
    signal von  : std_logic;
    signal hc   : std_logic_vector(9 downto 0);
    signal vc   : std_logic_vector(9 downto 0);
    signal error: std_logic;
    signal bussy: std_logic;
    signal event: std_logic;
    signal data : std_logic_vector(7 downto 0);
    signal btn  : std_logic_vector(3 downto 0);

begin

    vgaDriver : entity work.vgaDriver port map(
        rst   => rst,
        clk   => clk,
        Hsync => Hsync,
        Vsync => Vsync,
        von   => von,
        hc    => hc,
        vc    => vc
    );

    vgaPainter : entity work.vgaPainter port map(
        rst   => rst,
        clk   => clk,
        von   => von,
        hc    => hc,
        vc    => vc,
        vgaR  => vgaR,
        vgaG  => vgaG,
        vgaB  => vgaB,
        btn   => btn
    );

    ps2Driver : entity work.ps2Driver port map(
        rst   => rst,
        clk   => clk,
        PS2C  => PS2C,
        PS2D  => PS2D,
        data  => data,
        error => error,
        bussy => bussy,
        event => event
    );

    process (clk) begin
        Led <= data;
        if event = '1' and error = '0' then
            if data = "01101011" then btn <= "0010";
            elsif data = "01110100" then btn <= "0001"; 
            elsif data = "01110101" then btn <= "0100"; 
            elsif data = "01110010" then btn <= "1000";
            else btn <= "0000"; end if; 
        else
            btn <= (others => '0');
        end if;
    end process;

end rtl;

