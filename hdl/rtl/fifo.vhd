--*****************************************************************************
-- Company			EPFL-LSM
-- Project Name		Medusa
--*****************************************************************************
-- Doxygen labels
--! @file 			fifo.vhd
--! @brief 			a short description what can be found in the file
--! @details 		detailed description
--! @author 		Selman Ergünay
--! @date 			05.06.2017
--*****************************************************************************
-- Revision History:
--   Rev 0.0 - File created.
-- TODO : out 
--*****************************************************************************
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_* -all UPPERCASE"
--   state machine current/next state:      "*_cs" / "*_ns"         
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--	 data valid signals						"*_vld"
--   internal version of output port:       "*_i"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROC"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
--*****************************************************************************
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity fifo is 
	generic(
		DATA_WIDTH 	: natural := 8;
		ADDR_WIDTH 	: natural := 4;
		FIFO_DEPTH	: natural := 16);
	port(
		Clk		: in std_logic;
		Rst		: in std_logic;
		--Write agent:
		D_in 	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		Wr_en	: in std_logic;
		Full 	: out std_logic;
		--Read agent
		D_out	: out std_logic_vector(DATA_WIDTH-1 downto 0);
		Rd_en 	: in std_logic;
		Empty 	: out std_logic);
end entity fifo;
--------------------------------------------------------------------------------
architecture rtl of fifo is
	signal wr_addr      : unsigned(ADDR_WIDTH-1 downto 0);
	signal rd_addr      : unsigned(ADDR_WIDTH-1 downto 0);
	signal wr_data      : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rd_data      : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal full_next    : std_logic;   
	signal full_reg     : std_logic;   
	signal empty_next   : std_logic;   
	signal empty_reg    : std_logic;   
	signal last_op_reg  : std_logic;   
	signal last_op_next : std_logic;   
	signal ram_wr_en    : std_logic;   
	signal ram_rd_en	: std_logic;   
	
	component dpram_sclk
		generic(
			DATA_WIDTH 	: natural := 8;
			ADDR_WIDTH 	: natural := 8);
		port(
			Clk		: in std_logic;
			Rd_en	: in std_logic;
			Rd_addr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
			Rd_data	: out std_logic_vector(DATA_WIDTH-1 downto 0);
			Wr_en	: in std_logic;
			Wr_addr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
			Wr_data	: in std_logic_vector(DATA_WIDTH-1 downto 0));
	end component;
begin
--------------------------------------------------------------------------------
	I_DPRAM_SCLK: dpram_sclk
		generic map(
			DATA_WIDTH 	=> DATA_WIDTH,
			ADDR_WIDTH 	=> ADDR_WIDTH)
		port map(
			Clk			=> Clk,
			Rd_en		=> ram_rd_en,
			Rd_addr		=> std_logic_vector(rd_addr),
			Rd_data		=> rd_data,
			Wr_en		=> ram_wr_en,
			Wr_addr		=> std_logic_vector(wr_addr),
			Wr_data		=> wr_data);
--------------------------------------------------------------------------------
	ram_wr_en 	<= (Wr_en and not full_reg);
	ram_rd_en 	<= (Rd_en and not empty_reg);
--------------------------------------------------------------------------------
	WR_ADDR_REG_PROC: process (Clk)
	begin
		if rising_edge(Clk) then
			if Rst = '1' then 
				wr_addr <= (others => '0');
			elsif ram_wr_en = '1' then
				if wr_addr = FIFO_DEPTH-1 then
					wr_addr <= to_unsigned(0, ADDR_WIDTH);
				else
					wr_addr <= wr_addr+1;
				end if;
			end if;
		end if;
	end process WR_ADDR_REG_PROC;
--------------------------------------------------------------------------------
	RD_ADDR_REG_PROC: process (Clk)
	begin
		if rising_edge(Clk) then
			if Rst = '1' then 
				rd_addr <= (others => '0');
			elsif ram_rd_en = '1' then
				if rd_addr = FIFO_DEPTH-1 then
					rd_addr <= to_unsigned(0, ADDR_WIDTH);
				else
					rd_addr <= rd_addr+1;
				end if;
			end if;
		end if;
	end process RD_ADDR_REG_PROC;
--------------------------------------------------------------------------------
	EMPTY_REG_PROC: process (Clk)
	begin
		if rising_edge(Clk) then
			if Rst = '1'then 
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
	FULL_REG_PROC: process (Clk)
	begin
		if rising_edge(Clk) then
			if Rst = '1'then 
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
	wr_data <= D_in;
	D_out 	<= rd_data;
--------------------------------------------------------------------------------
	Empty 	<= empty_reg;
	Full 	<= full_reg;
--------------------------------------------------------------------------------
end architecture rtl;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--component fifo
--	generic(
--		DATA_WIDTH 	: natural := 8;
--		ADDR_WIDTH 	: natural := 4;
--		FIFO_DEPTH	: natural := 16
--	);
--	port(
--		Clk			: in std_logic;
--		Rst			: in std_logic;
--		D_in 		: in std_logic_vector(DATA_WIDTH-1 downto 0);
--		Wr_en		: in std_logic;
--		Full 		: out std_logic;
--		D_out		: out std_logic_vector(DATA_WIDTH-1 downto 0);
--		Rd_en 		: in std_logic;
--		Empty 		: out std_logic);
--end component;
----------------------------------------------------------------------------------
--I_FIFO: fifo
--	generic map(
--		DATA_WIDTH 	=> DATA_WIDTH,
--		ADDR_WIDTH	=> ADDR_WIDTH,
--		FIFO_DEPTH	=> FIFO_DEPTH)
--	port map(
--		Clk		=> clk,
--		Rst		=> rst,
--		D_in 	=> d_in,
--		Wr_en	=> wr_en,
--		Full 	=> full,
--		D_out	=> d_out,
--		Rd_en 	=> rd_en,
--		Empty 	=> empty);