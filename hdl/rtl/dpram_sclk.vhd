--*****************************************************************************
-- Company			EPFL-LSM
-- Project Name		Medusa
--*****************************************************************************
-- Doxygen labels
--! @file 			lut.vhd
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
entity dpram_sclk is
	generic(
		DATA_WIDTH 	: natural := 8;
		ADDR_WIDTH 	: natural := 8);
	port(
		Clk		: in std_logic;
		-- Read port
		Rd_en	: in std_logic;
		Rd_addr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		Rd_data	: out std_logic_vector(DATA_WIDTH-1 downto 0);
		-- Write port
		Wr_en	: in std_logic;
		Wr_addr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		Wr_data	: in std_logic_vector(DATA_WIDTH-1 downto 0));
end entity dpram_sclk;
--------------------------------------------------------------------------------
architecture rtl of dpram_sclk is
--------------------------------------------------------------------------------	
	type ram_type is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal 	MEM : ram_type := (others=>(others=>'0'));
--------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------
    READ_PROC: process (Clk)
    begin
        if rising_edge(Clk) then
			if Rd_en = '1' then 
				Rd_data <= MEM(to_integer(unsigned(Rd_addr)));
			end if;
		end if;
    end process READ_PROC;
--------------------------------------------------------------------------------	
	WRITE_PROC: process (Clk)
    begin
        if rising_edge(Clk) then
			if Wr_en = '1' then 
				MEM(to_integer(unsigned(Wr_addr))) <= Wr_data;
			end if;
		end if;
    end process WRITE_PROC;
--------------------------------------------------------------------------------
end architecture rtl;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--component dpram_sclk
--	generic(
--		DATA_WIDTH 	: natural := 8;
--		ADDR_WIDTH 	: natural := 8);
--	port(
--		Clk		: in std_logic;
--		-- Read port
--		Rd_en	: in std_logic;
--		Rd_addr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
--		Rd_data	: out std_logic_vector(DATA_WIDTH-1 downto 0);
--		-- Write port
--		Wr_en	: in std_logic;
--		Wr_addr	: in std_logic;
--		Wr_data	: in std_logic_vector(DATA_WIDTH-1 downto 0));
--end component;
----------------------------------------------------------------------------------
--	I_DPRAM_SCLK: dpram_sclk
--		generic map(
--			DATA_WIDTH 	=> 8,
--			ADDR_WIDTH 	=> 8)
--		port map(
--			Clk			=> Clk,
--			Rd_en		=> Rd_en,
--			Rd_addr		=> rd_addr,
--			Rd_data		=> rd_data,
--			Wr_en		=> Wr_en,
--			Wr_addr		=> wr_addr,
--			Wr_data		=> wr_data
--	end component;