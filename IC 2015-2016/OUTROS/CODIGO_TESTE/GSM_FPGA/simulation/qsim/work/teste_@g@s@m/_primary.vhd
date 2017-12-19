library verilog;
use verilog.vl_types.all;
entity teste_GSM is
    port(
        clk             : in     vl_logic;
        RxD             : in     vl_logic;
        switch          : in     vl_logic;
        TxD             : out    vl_logic;
        LCD_ON          : out    vl_logic;
        LCD_BLON        : out    vl_logic;
        LCD_RW          : out    vl_logic;
        LCD_EN          : out    vl_logic;
        LCD_RS          : out    vl_logic;
        LCD_DATA        : inout  vl_logic_vector(7 downto 0);
        GPout           : out    vl_logic_vector(7 downto 0);
        led_TX_data     : out    vl_logic_vector(7 downto 0);
        led_TX          : out    vl_logic;
        led_RX          : out    vl_logic;
        erro            : out    vl_logic_vector(1 downto 0)
    );
end teste_GSM;
