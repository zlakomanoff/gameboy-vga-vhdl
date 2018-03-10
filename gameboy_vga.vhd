library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Video Input Pins
-- 55 VSunc
-- 58 HSunc
-- 60 Clock
-- 67 DATA0
-- 70 DATA1

-- Video Output Pins
-- 17  Clock
-- 115 VSunc
-- 119 HSunc
-- 125 DATA0
-- 135 DATA1

entity gameboy_vga is 
	port(
		VinVSunc  : in std_logic;
		VinHSunc  : in std_logic;
		VinClock  : in std_logic;
		VinData   : in std_logic_vector(1 downto 0);
		
		VoutVSunc : out std_logic := '1';
		VoutHSunc : out std_logic := '1';
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
	
	component pll is
		port (
			pll_input_clock_clk  : in  std_logic := 'X'; -- clock in
			pll_reset_reset      : in  std_logic := 'X'; -- reset
			pll_output_clock_clk : out std_logic         -- clock out
		);
	end component pll;

begin

	u0: component pll port map (
		pll_input_clock_clk  => SourceClock,
		pll_reset_reset      => FakeReset,
		pll_output_clock_clk => VoutClock
	);
	
	process (VinClock)
		variable ram_cell: integer range 0 to 23040 := 0;
	begin
		if rising_edge(VinClock) then
			if (VinHSunc = '1') then 
				if (VinVSunc = '1') then
					ram_cell := 0;
				end if;
			else
				video_ram(ram_cell) := VinData;
				ram_cell := ram_cell + 1;
			end if;
		end if;
	end process;

	process (VoutClock)
		variable VoutLineCounter : integer range 0 to 525 := 0;
		variable VoutPixelCounter: integer range 0 to 800 := 0;
		
		variable VoutRamCell: integer range 0 to 23040;
		
--		variable RamLine: integer range 0 to 144;
--		variable RamPixel: integer range 0 to 160;
	begin
		if rising_edge(VoutClock) then
			
			
			
			if (VoutPixelCounter < 799) then
				if (VoutPixelCounter < 639) then -- video data
					if (VoutLineCounter < 479) then 
						if (VoutPixelCounter < 160 and VoutLineCounter < 144) then
							VoutData <= not video_ram(VoutRamCell);
--							VoutRamCell := VoutRamCell + 1;
						else
							VoutData <= "00";
						end if;
					else 
						VoutData <= "00";
					end if;
				else
					VoutData <= "00";
					if (VoutPixelCounter > 655 and VoutPixelCounter < 751) then
						VoutHSunc <= '0';
					else
						VoutHSunc <= '1';
					end if;
				end if;
			else
				VoutLineCounter := VoutLineCounter + 1;
				VoutPixelCounter := 0;
			end if;
			
			
			
			if (VoutLineCounter < 524) then
				if (VoutLineCounter > 490 and VoutLineCounter < 493) then
					VoutVSunc <= '0';
				else
					VoutVSunc <= '1';
				end if;
			else
				VoutLineCounter := 0;
				VoutRamCell := 0;
			end if;
			
			
			
			VoutPixelCounter := VoutPixelCounter + 1;
			
			
			
		end if;
	end process;
	
end Behavioral;