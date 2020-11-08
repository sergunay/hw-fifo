--! @file       dpram_dclk.vhd
--! @brief      Dual port RAM with dual clock
--! @details
--! @author     Selman Ergunay
--! @date       2017-06-05
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity dpram_dclk is
	generic(
		DATA_NBITS  : natural := 8;
		ADDR_NBITS  : natural := 8);
	port(
		-- Read port
		iRd_clk     : in std_logic;
		iRd_en      : in std_logic;                                 --! Read enable
		iRd_addr    : in std_logic_vector(ADDR_NBITS-1 downto 0);   --! Read address
		oRd_data    : out std_logic_vector(DATA_NBITS-1 downto 0);  --! Read data
		-- Write port
		iWr_clk     : in std_logic;
		iWr_en      : in std_logic;                                 --! Write enable
		iWr_addr    : in std_logic_vector(ADDR_NBITS-1 downto 0);   --! Write address
		iWr_data    : in std_logic_vector(DATA_NBITS-1 downto 0));  --! Write data
end entity dpram_dclk;
--------------------------------------------------------------------------------
architecture rtl of dpram_dclk is
	type ram_type is array (0 to 2**ADDR_NBITS-1) of std_logic_vector(DATA_NBITS-1 downto 0);
	signal 	MEM : ram_type := (others=>(others=>'0'));
--------------------------------------------------------------------------------
begin
    READ_PROC: process (iRd_clk)
    begin
        if rising_edge(iRd_clk) then
			if iRd_en = '1' then
				oRd_data <= MEM(to_integer(unsigned(iRd_addr)));
			end if;
		end if;
    end process READ_PROC;
--------------------------------------------------------------------------------
	WRITE_PROC: process (iWr_clk)
    begin
        if rising_edge(iWr_clk) then
			if iWr_en = '1' then
				MEM(to_integer(unsigned(iWr_addr))) <= iWr_data;
			end if;
		end if;
    end process WRITE_PROC;
--------------------------------------------------------------------------------
end architecture rtl;
--------------------------------------------------------------------------------
