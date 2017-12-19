library verilog;
use verilog.vl_types.all;
entity teste_Mod_comm_vlg_check_tst is
    port(
        data_sliced     : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end teste_Mod_comm_vlg_check_tst;
