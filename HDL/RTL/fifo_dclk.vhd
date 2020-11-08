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
entity fifo_dclk is
	generic(
		DATA_NBITS 	: natural := 20;
		ADDR_NBITS 	: natural := 11;
		FIFO_DEPTH	: natural := 1024);
	port(
		iRst		: in std_logic;
		--Write agent:
		iWr_clk		: in std_logic;
		iWr_data 	: in std_logic_vector(DATA_NBITS-1 downto 0); 	--! Write data
		iWr_en		: in std_logic;									--! Write enable
		oFull 		: out std_logic;								--! FIFO full flag
		--Read agent
		iRd_clk		: in std_logic;
		oRd_data	: out std_logic_vector(DATA_NBITS-1 downto 0);	--! Read data
		iRd_en 		: in std_logic;									--! Read enable
		oEmpty 		: out std_logic);								--! FIFO empty flag
end entity fifo_dclk;
--------------------------------------------------------------------------------
architecture rtl of fifo_dclk is
	signal wr_addr      : unsigned(ADDR_NBITS-1 downto 0) := (others=>'0');
	signal rd_addr      : unsigned(ADDR_NBITS-1 downto 0) := (others=>'0');
	signal wr_data      : std_logic_vector(DATA_NBITS-1 downto 0);
	signal rd_data      : std_logic_vector(DATA_NBITS-1 downto 0);
	signal full_next    : std_logic := '0';
	signal full_reg     : std_logic := '0';
	signal empty_next   : std_logic := '1';
	signal empty_reg    : std_logic := '1';
	signal ram_wr_en    : std_logic;
	signal ram_rd_en	: std_logic;

	component dpram_dclk
		generic(
			DATA_NBITS 	: natural := 8;
			ADDR_NBITS 	: natural := 8);
		port(
			iRd_clk		: in std_logic;
			iRd_en		: in std_logic;
			iRd_addr	: in std_logic_vector(ADDR_NBITS-1 downto 0);
			oRd_data	: out std_logic_vector(DATA_NBITS-1 downto 0);
			iWr_clk		: in std_logic;
			iWr_en		: in std_logic;
			iWr_addr	: in std_logic_vector(ADDR_NBITS-1 downto 0);
			iWr_data	: in std_logic_vector(DATA_NBITS-1 downto 0));
	end component;
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
	I_DPRAM_DCLK: dpram_dclk
		generic map(
			DATA_NBITS 	=> DATA_NBITS,
			ADDR_NBITS 	=> ADDR_NBITS)
		port map(
			iRd_clk		=> iRd_clk,
			iRd_en		=> ram_rd_en,
			iRd_addr	=> std_logic_vector(rd_addr),
			oRd_data	=> rd_data,
			iWr_clk		=> iWr_clk,
			iWr_en		=> ram_wr_en,
			iWr_addr	=> std_logic_vector(wr_addr),
			iWr_data	=> wr_data);
--------------------------------------------------------------------------------
	ram_wr_en 	<= (iWr_en and not full_reg);
	ram_rd_en 	<= (iRd_en and not empty_reg);
--------------------------------------------------------------------------------
	WR_ADDR_REG_PROC: process (iWr_clk)
	begin
		if rising_edge(iWr_clk) then
			if iRst = '1' then
				wr_addr <= (others => '0');
			elsif ram_wr_en = '1' then
				if wr_addr = FIFO_DEPTH-1 then
					wr_addr <= to_unsigned(0, ADDR_NBITS);
				else
					wr_addr <= wr_addr+1;
				end if;
			end if;
		end if;
	end process WR_ADDR_REG_PROC;
--------------------------------------------------------------------------------
	RD_ADDR_REG_PROC: process (iRd_clk)
	begin
		if rising_edge(iRd_clk) then
			if iRst = '1' then
				rd_addr <= (others => '0');
			elsif ram_rd_en = '1' then
				if rd_addr = FIFO_DEPTH-1 then
					rd_addr <= to_unsigned(0, ADDR_NBITS);
				else
					rd_addr <= rd_addr+1;
				end if;
			end if;
		end if;
	end process RD_ADDR_REG_PROC;
--------------------------------------------------------------------------------
	EMPTY_REG_PROC: process (iRd_clk)
	begin
		if rising_edge(iRd_clk) then
			if iRst = '1'then
				empty_reg <= '1';
			else
				empty_reg <= empty_next;
			end if;
		end if;
	end process EMPTY_REG_PROC;

	empty_next	<= '1'	 	when ((rd_addr = wr_addr-1) or ((rd_addr = FIFO_DEPTH-1) and (wr_addr = 0))) and ((ram_rd_en = '1') and (ram_wr_en = '0')) else
				   '0' 		when (ram_wr_en and not ram_rd_en) = '1' else
				   empty_reg;
--------------------------------------------------------------------------------
	FULL_REG_PROC: process (iWr_clk)
	begin
		if rising_edge(iWr_clk) then
			if iRst = '1'then
				full_reg <= '0';
			else
				full_reg <= full_next;
			end if;
		end if;
	end process FULL_REG_PROC;

	full_next	<= '1'	 	when ((wr_addr = rd_addr-1) or ((wr_addr = FIFO_DEPTH-1) and (rd_addr = 0))) and ((ram_wr_en = '1') and (ram_rd_en = '0')) else
				   '0' 		when (ram_rd_en and not ram_wr_en) = '1' else
				   full_reg;
--------------------------------------------------------------------------------
	wr_data 	<= iWr_data;
	oRd_data 	<= rd_data;
--------------------------------------------------------------------------------
	oEmpty 	<= empty_reg;
	oFull 	<= full_reg;
--------------------------------------------------------------------------------
end architecture rtl;
--------------------------------------------------------------------------------
