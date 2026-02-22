module impl_top (
    input  wire clk,
    input  wire rst,
    input  wire start, // Start button
    output wire done, // Done LED
    output wire check_led // Check LED (XOR of output)
);

    // --- Hardcoded Inputs to Bypass IO Limits ---
    // In a real implementation, you would use UART/SPI/Buttons
    // to load these values serially.
    reg [1:0]   mode = 2'b00; // 128-bit mode
    reg         encrypt_en = 1'b1; // Encrypt

    // Example Key & Data
    reg [127:0] data_in = 128'h00112233445566778899aabbccddeeff;
    reg [255:0] key     = 256'h000102030405060708090a0b0c0d0e0f00000000000000000000000000000000;

    wire [127:0] data_out;
    wire         core_done;

    // --- Instantiate the AES Core ---
    top_module aes_core (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .mode       (mode),
        .encrypt_en (encrypt_en),
        .data_in    (data_in),
        .key        (key),
        .data_out   (data_out),
        .done       (core_done)
    );

    // Connect Output Signals
    assign done = core_done;

    // Reduce 128-bit output to 1-bit LED to prevent logic optimization
    assign check_led = ^data_out;

endmodule
