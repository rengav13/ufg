library verilog;
use verilog.vl_types.all;
entity teste_GSM_vlg_sample_tst is
    port(
        LCD_DATA        : in     vl_logic_vector(7 downto 0);
        RxD             : in     vl_logic;
        clk             : in     vl_logic;
        switch          : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end teste_GSM_vlg_sample_tst;
