library verilog;
use verilog.vl_types.all;
entity teste_Mod_comm_vlg_sample_tst is
    port(
        child           : in     vl_logic;
        clock           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end teste_Mod_comm_vlg_sample_tst;
