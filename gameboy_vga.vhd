library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Video Input Pins
-- 55 VSync
-- 58 HSync
-- 60 Clock
-- 67 DATA0
-- 70 DATA1

-- Video Output Pins
-- 17  Clock
-- 115 VSync
-- 119 HSync
-- 125 DATA0
-- 135 DATA1

entity gameboy_vga is 
	port(
		VinVSync  : in std_logic;
		VinHSync  : in std_logic;
		VinClock  : in std_logic;
		VinData   : in std_logic_vector(1 downto 0);
		
		VoutVSync : out std_logic := '1';
		VoutHSync : out std_logic := '1';
		VoutData  : out std_logic_vector(1 downto 0) := "00";
		
		SourceClock: in std_logic
	);
end gameboy_vga;

architecture Behavioral of gameboy_vga is

	-- frame buffer, 160 x 144 pixels, 2 bit per pixel
	type video_ram_matrix is array (0 to 23040) of std_logic_vector(1 downto 0);
	shared variable video_ram: video_ram_matrix;
	
	signal VoutClock: std_logic;
	signal FakeReset: std_logic; -- not connected to anything

	signal FakeClock: std_logic;
	
	component pll is
		port (
			pll_input_clock_clk  : in  std_logic := 'X'; -- clock in
			pll_reset_reset      : in  std_logic := 'X'; -- reset
			pll_output_clock_clk : out std_logic         -- clock out
		);
	end component pll;

begin

	FakeClock <= VinClock or VinHSync;

	u0: component pll port map (
		pll_input_clock_clk  => SourceClock,
		pll_reset_reset      => FakeReset,
		pll_output_clock_clk => VoutClock
	);
	
	process (FakeClock)
		variable ram_cell: integer range 0 to 23040 := 0;
	begin
		if falling_edge(FakeClock) then
			if (VinVSync = '1' and ram_cell > 160) then
				ram_cell := 0;
			else
				ram_cell := ram_cell + 1;
			end if;
			video_ram(ram_cell) := VinData;
		end if;
	end process;

	process (VoutClock)
		
		-- VESA Signal 768 x 576 @ 60 Hz
		-- http://tinyvga.com/vga-timing/768x576@60Hz
		-- 768 x 576 (976 x 597)
		
		variable VideoPixel: integer range 1 to 976 := 1;
		variable VideoLine: integer range 1 to 598 := 1;
		variable VideoRamCell: integer range 0 to 23040 := 0;
	begin
		if rising_edge(VoutClock) then
		
			if (VideoPixel < 976) then
				if (VideoPixel <= 768) then -- video data
					
					if (VideoPixel = 1 or VideoPixel = 768) then
						VoutData <= "10";
					else
						if (VideoPixel > 60 and VideoPixel < 701) then
						--if (VideoPixel < 641) then
							VoutData <= not video_ram(VideoRamCell);
							if (VideoPixel mod 4 = 0) then 
								VideoRamCell := VideoRamCell + 1;
							end if;
						else
							VoutData <= "00";
						end if;
					end if;
					
				else
				
					VoutData <= "00";
					if (VideoPixel > 792 and VideoPixel < 873) then
						VoutHSync <= '0';
					else
						VoutHSync <= '1';
					end if;
					
				end if;
				VideoPixel := VideoPixel + 1;
			else
				VideoLine := VideoLine + 1;
				VideoPixel := 1;
				if ((VideoLine mod 4 /= 0) and VideoRamCell > 159) then
					VideoRamCell := VideoRamCell - 160;
				end if;
			end if;
			
			if (VideoLine < 598) then
				if (VideoLine > 577 and VideoLine < 581) then
					VoutVSync <= '0';
				else
					VoutVSync <= '1';
				end if;
			else
				VideoLine := 1;
				VideoRamCell := 0;
			end if;
		
		end if;
	end process;
	
end Behavioral;