library verilog;
use verilog.vl_types.all;
entity teste_Mod_comm is
    port(
        child           : in     vl_logic;
        clock           : in     vl_logic;
        data_sliced     : out    vl_logic_vector(7 downto 0)
    );
end teste_Mod_comm;
