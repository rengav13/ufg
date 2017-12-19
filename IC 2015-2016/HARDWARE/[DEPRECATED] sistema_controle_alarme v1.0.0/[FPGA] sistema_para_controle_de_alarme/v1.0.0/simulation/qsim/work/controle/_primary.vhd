library verilog;
use verilog.vl_types.all;
entity controle is
    port(
        clk             : in     vl_logic;
        button          : in     vl_logic;
        RxD             : in     vl_logic;
        communication   : in     vl_logic;
        saida           : out    vl_logic_vector(2 downto 0);
        led             : out    vl_logic
    );
end controle;
