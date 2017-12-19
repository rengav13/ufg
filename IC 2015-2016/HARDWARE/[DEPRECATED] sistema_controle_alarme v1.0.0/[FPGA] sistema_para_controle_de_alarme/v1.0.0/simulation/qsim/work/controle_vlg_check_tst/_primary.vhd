library verilog;
use verilog.vl_types.all;
entity controle_vlg_check_tst is
    port(
        led             : in     vl_logic;
        saida           : in     vl_logic_vector(2 downto 0);
        sampler_rx      : in     vl_logic
    );
end controle_vlg_check_tst;
