library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity motorkoppling2 is
    Port (
        clk, reset : in STD_LOGIC;
        A, B: in STD_LOGIC;
        u0, u1 : out STD_LOGIC
    );
end motorkoppling2;

architecture Behavioral of motorkoppling2 is
    type State is (start, A_high, A_low, B_high, B_low, B2_high, B2_low, wait_for_reset);
    signal current_state, next_state : State;
begin

    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= start;
        else
            if rising_edge(clk) then
                current_state <= next_state;
            end if;
        end if;
    end process;

    process (reset, current_state, A, B)
    begin
        u0 <= '0';
        u1 <= '0';

        case current_state is
            when start =>
                if A = '1' then
                    next_state <= A_high;
                elsif B = '0' and A = '0' then
                    next_state <= start;
                else
                    next_state <= wait_for_reset;
                    u0 <= '1';
                    u0 <= '0';
                end if;

            when A_high =>
                if A = '1' then
                    next_state <= A_high;
                elsif A = '0' and B = '0' then
                    next_state <= A_low;
                    u0 <= '0';
                else
                    next_state <= wait_for_reset;
                    u1 <= '0';
                    u0 <= '1';
                end if;

            when A_low =>
                if B = '1' then
                    next_state <= B_high;
                    u0 <= '0';
                elsif A = '0' and B = '0' then
                    next_state <= A_low;
                    u0 <= '0';
                else
                    next_state <= wait_for_reset;
                    u0 <= '1';
                    u1 <= '0';
                end if;

            when B_high =>
                if B = '1' then
                    next_state <= B_high;
                    u0 <= '0';
                elsif A = '0' and B = '0' then
                    next_state <= B_low;
                    u0 <= '0';
                else
                    next_state <= wait_for_reset;
                    u0 <= '1';
                    u1 <= '0';
                end if;

            when B_low =>
                if B = '1' then
                    next_state <= B2_high;
                    u0 <= '0';
                elsif A = '0' and B = '0' then
                    next_state <= B_low;
                    u0 <= '0';
                else
                    next_state <= wait_for_reset;
                    u0 <= '1';
                    u1 <= '0';
                end if;

            when B2_high =>
                if B = '1' then
                    next_state <= B2_high;
                    u0 <= '0';
                elsif A = '0' and B = '0' then
                    next_state <= B2_low;
                    u0 <= '0';
                else
                    next_state <= wait_for_reset;
                    u0 <= '1';
                    u1 <= '0';
                end if;

            when B2_low =>
                if A = '0' and B = '0' and reset = '0' then
                    next_state <= B2_low;
                    u0 <= '0';
                    u1 <= '1';
                elsif reset = '1' and A = '0' and B = '0' then
                    next_state <= start;
                    u0 <= '0';
                    u1 <= '0';
                else
                    next_state <= wait_for_reset;
                    u0 <= '1';
                    u1 <= '0';
                end if;

            when wait_for_reset =>
                u0 <= '1';
                if reset = '1' then
                    next_state <= start;
                else
                    next_state <= wait_for_reset;
                end if;
        end case;
    end process;

end Behavioral;
