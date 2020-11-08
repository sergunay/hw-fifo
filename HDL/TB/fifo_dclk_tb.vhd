--! @file       dpram_dclk.vhd
--! @brief      Dual port RAM with dual clock
--! @details
--! @author     Selman Ergunay
--! @date       2017-06-05
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity fifo_dclk_tb is
end entity;
----------------------------------------------------------------------------
architecture arch_sim_tb_top of fifo_dclk_tb is
	component fifo_dclk
		generic(
			DATA_NBITS 	: natural := 20;
			ADDR_NBITS 	: natural := 11;
			FIFO_DEPTH	: natural := 1024);
		port(
			iRst		: in std_logic;
			iWr_clk		: in std_logic;
			iWr_data 	: in std_logic_vector(DATA_NBITS-1 downto 0);
			iWr_en		: in std_logic;
			oFull 		: out std_logic;
			iRd_clk		: in std_logic;
			oRd_data	: out std_logic_vector(DATA_NBITS-1 downto 0);
			iRd_en 		: in std_logic;
			oEmpty 		: out std_logic);
	end component;

	-- Simulation constants
	constant C_CLK_PER			: time 		:= 10 ns;
	constant C_DATA_NBITS 		: natural 	:= 8;
	constant C_ADDR_NBITS 		: natural 	:= 8;
	constant C_FIFO_DEPTH 		: natural 	:= 5;

	-- File/file name definitions
	constant C_TV_FILE_NAME		: string 	:= "./IN/tv.txt";
	file tv_file				: text;

	-- Simulation control signals
	signal sim_clk				: std_logic := '0';
	signal sim_rst 				: std_logic := '0'; 		-- system active high reset
	signal sim_stop				: boolean 	:= false;		-- stop simulation?

	signal sim_fifo_in_data		: std_logic_vector(C_DATA_NBITS-1 downto 0) := (others=>'0');
	signal sim_fifo_wr_en		: std_logic := '0';
	signal sim_fifo_rd_en		: std_logic := '0';

	signal fifo_full			: std_logic_vector(0 downto 0) := "0";
	signal fifo_empty			: std_logic_vector(0 downto 0) := "0";
	signal fifo_out_data		: std_logic_vector(C_DATA_NBITS-1 downto 0) := (others=>'0');
----------------------------------------------------------------------------
begin
	I_FIFO_DCLK: fifo_dclk
		generic map(
			DATA_NBITS 	=> C_DATA_NBITS,
			ADDR_NBITS 	=> C_ADDR_NBITS,
			FIFO_DEPTH	=> C_FIFO_DEPTH)
		port map(
			iRst		=> sim_rst,
			iWr_clk		=> sim_clk,
			iWr_data 	=> sim_fifo_in_data,
			iWr_en		=> sim_fifo_wr_en,
			oFull 		=> fifo_full(0),
			iRd_clk		=> sim_clk,
			oRd_data	=> fifo_out_data,
			iRd_en 		=> sim_fifo_rd_en,
			oEmpty 		=> fifo_empty(0));
----------------------------------------------------------------------------
	--! @brief 100MHz system clock generation
	CLK_STIM : sim_clk 	<= not sim_clk after C_CLK_PER/2 when not sim_stop;
----------------------------------------------------------------------------
	STIM_PROC: process
		variable tv_line	: line;
		variable op_id		: integer;
		variable push_data	: integer;
		variable pop_data	: integer;
		variable empty		: integer;
		variable full		: integer;
		variable empty_prev	: integer;
		variable full_prev	: integer;

		procedure init is
		begin
			sim_rst 	<= '1';
			wait for 100 ns;
			sim_rst		<= '0';
		end procedure init;

		procedure check_flags(
			constant empty	: integer;
			constant full	: integer) is
		begin
			assert to_integer(unsigned(fifo_empty)) = empty
			report 	"Empty/Exp = " 	 & integer'image(empty) & " / " &
					"Empty/Got = " 	 & integer'image(to_integer(unsigned(fifo_empty)))
			severity ERROR;

			assert to_integer(unsigned(fifo_full)) = full
			report 	"Full/Exp = " 	 & integer'image(full) & " / " &
					"Full/Got = " 	 & integer'image(to_integer(unsigned(fifo_full)))
			severity ERROR;
		end procedure check_flags;

		procedure check_data(
			constant pop_data	: integer) is
		begin
			assert to_integer(unsigned(fifo_out_data)) = pop_data
			report 	"Data/Exp = " 	 & integer'image(pop_data) & " / " &
					"Data/Got = " 	 & integer'image(to_integer(unsigned(fifo_out_data)))
			severity ERROR;
		end procedure check_data;

		procedure push(
			constant push_data	: integer := 0) is
		begin
			sim_fifo_wr_en		<= '1';
			sim_fifo_in_data	<= std_logic_vector(to_unsigned(push_data, C_DATA_NBITS));
		end procedure push;

		procedure pop is
		begin
			sim_fifo_rd_en		<= '1';
		end procedure pop;

		procedure release is
		begin
			sim_fifo_wr_en		<= '0';
			sim_fifo_rd_en		<= '0';
		end procedure release;
----------------------------------------------------------------------------
	begin
		file_open(tv_file, C_TV_FILE_NAME,  READ_MODE);
		init;
		empty 	:= 1;
		full 	:= 0;
		while not endfile(tv_file) loop

			empty_prev	:= empty;
			full_prev 	:= full;

			readline(tv_file, tv_line);
			read(tv_line, op_id);
			read(tv_line, push_data);
			read(tv_line, pop_data);
			read(tv_line, empty);
			read(tv_line, full);

			if op_id = 0 then
				push(push_data);
				wait until falling_edge(sim_clk);
				release;
				check_flags(empty, full);
			end if;

			if op_id = 1 then
				pop;
				wait until falling_edge(sim_clk);
				release;
				check_flags(empty, full);
				if empty_prev = 0 then
					check_data(pop_data);
				end if;
			end if;

			if op_id = 2 then
				push(push_data);
				pop;
				wait until falling_edge(sim_clk);
				release;
				check_flags(empty, full);
				if empty_prev = 0 then
					check_data(pop_data);
				end if;
			end if;
		end loop;
		sim_stop 	<= TRUE;
		wait;
	end process STIM_PROC;
----------------------------------------------------------------------------
end arch_sim_tb_top;
----------------------------------------------------------------------------
