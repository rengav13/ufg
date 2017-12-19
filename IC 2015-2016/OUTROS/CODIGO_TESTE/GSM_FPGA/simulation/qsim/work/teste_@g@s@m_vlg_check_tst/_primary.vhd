library verilog;
use verilog.vl_types.all;
entity teste_GSM_vlg_check_tst is
    port(
        GPout           : in     vl_logic_vector(7 downto 0);
        LCD_BLON        : in     vl_logic;
        LCD_DATA        : in     vl_logic_vector(7 downto 0);
        LCD_EN          : in     vl_logic;
        LCD_ON          : in     vl_logic;
        LCD_RS          : in     vl_logic;
        LCD_RW          : in     vl_logic;
        TxD             : in     vl_logic;
        erro            : in     vl_logic_vector(1 downto 0);
        led_RX          : in     vl_logic;
        led_TX          : in     vl_logic;
        led_TX_data     : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end teste_GSM_vlg_check_tst;
