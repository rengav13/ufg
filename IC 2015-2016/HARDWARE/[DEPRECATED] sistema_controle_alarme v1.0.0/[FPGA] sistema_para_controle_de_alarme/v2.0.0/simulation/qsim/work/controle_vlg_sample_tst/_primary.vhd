library verilog;
use verilog.vl_types.all;
entity controle_vlg_sample_tst is
    port(
        RxD             : in     vl_logic;
        button          : in     vl_logic;
        clk             : in     vl_logic;
        communication   : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end controle_vlg_sample_tst;
