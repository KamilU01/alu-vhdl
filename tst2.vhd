library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tst2 is
port (
      A : in signed(15 downto 0);
      B : in signed(15 downto 0);
      Salu : in bit_vector (4 downto 0);
      LDF : in bit;
      clk : in bit;
      Y : out signed (15 downto 0);
      C,Z,S : out std_logic;
		BCD : out signed(6 downto 0)
);
end entity;
 
architecture rtl of tst2 is
begin
  process (Salu, A, B, clk)
       variable res, AA, BB,CC: signed (16 downto 0);
       variable CF,ZF,SF : std_logic;
       begin
         AA(16) := A(15);
         AA(15 downto 0) := A;
         BB(16) := B(15);
         BB(15 downto 0) := B;
         CC(0) := CF;
         CC(16 downto 1) := "0000000000000000";
         case Salu is
             when "00000" => res := AA;
             when "00001" => res := BB;
             when "00010" => res := AA + BB;
             when "00011" => res := AA - BB;
             when "00100" => res := AA or BB;
             when "00101" => res := AA and BB;
             when "00110" => res := AA xor BB;
             when "00111" => res := AA xnor BB;
             when "01000" => res := not AA;
             when "01001" => res := -AA;
             when "01010" => res := "00000000000000000";
             when "01011" => res := AA + BB + CC;
             when "01100" => res := AA + BB - CC;
             when "01101" => res := AA + 1;
             when "01110" => res := shift_left(AA, 1);
             when "01111" => res := shift_right(AA, 1);
             when "10000" => res := AA rol 1;
             when "10001" => res := AA ror 1;
             when "10010" => res := AA nor BB;
             when "10011" => res := AA nand BB;
	 when others => null;
         end case;
			
         Y <= res(15 downto 0);
         Z <= ZF;
         S <= SF;
         C <= CF;
			
			case res(15 downto 0) is
				when "0000000000000000" => BCD <= "0000001";
				when "0000000000000001" => BCD <= "1001111";
				when "0000000000000010" => BCD <= "0010010";
				when "0000000000000011" => BCD <= "0000110";
				when "0000000000000100" => BCD <= "1001100";
				when "0000000000000101" => BCD <= "0100100";
				when "0000000000000110" => BCD <= "0100000";
				when "0000000000000111" => BCD <= "0001111";
				when "0000000000001000" => BCD <= "0000000";
				when "0000000000001001" => BCD <= "0000100";
				when others => BCD <= "1111111";
			end case;
			
         if (clk'event and clk='1') then
             if (LDF='1') then
                 if (res = "00000000000000000") then ZF:='1';
                 else ZF:='0';
                 end if;
             if (res(15)='1') then SF:='1';
             else SF:='0'; end if;
             CF := res(16) xor res(15);
             end if;
         end if;
  end process;
end rtl;