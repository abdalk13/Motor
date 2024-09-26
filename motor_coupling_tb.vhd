library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity motor_coupling_tb is
end motor_coupling_tb;

architecture TB_ARCH of motor_coupling_tb is
    constant CLOCK_PERIOD : time := 10 ns;
    signal clk, reset, A, B, u0, u1 : STD_LOGIC := '0';
    
    component motor_coupling
        Port ( 
            clk, reset, A, B : in STD_LOGIC;
            u0, u1 : out STD_LOGIC
        );
    end component;
    
begin
    -- Instantiate the device under test (DUT)
    DUT: motor_coupling port map (
        clk => clk,
        reset => reset,
        A => A,
        B => B,
        u0 => u0,
        u1 => u1
    );

    -- Clock process generates the clock signal
    Clock_Process: process
    begin
        while now < 1000 ns loop
            clk <= not clk;
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process to drive the input signals
    Stimulus_Process: process
    begin
        -- Start with an idle period
        wait for CLOCK_PERIOD * 7 / 3;
        reset <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        reset <= '0';
        wait for CLOCK_PERIOD * 7 / 3;

        -- Scenario 1: Valid sequence to start the motor
        A <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        A <= '0';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '0';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '0';

        -- Scenario 2: Reset and another sequence
        wait for CLOCK_PERIOD * 7 / 3;
        reset <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        reset <= '0';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '0';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '0';

        -- Additional reset and sequence steps
        A <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        A <= '0';
        wait for CLOCK_PERIOD * 7 / 3;
        reset <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        reset <= '0';
        wait for CLOCK_PERIOD * 7 / 3;

        -- Another sequence of A and B
        A <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        A <= '0';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '0';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '1';
        wait for CLOCK_PERIOD * 7 / 3;
        B <= '0';
        wait for CLOCK_PERIOD * 7 / 3;
        
        wait;
    end process;
    
end TB_ARCH;
