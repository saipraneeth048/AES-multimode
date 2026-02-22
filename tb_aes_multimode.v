`timescale 1ns / 1ps

module tb_aes_multimode;

    // Common Inputs
    reg clk;
    reg rst;
    reg start;
    reg encrypt_en;
    reg [127:0] plaintext; // Shared plaintext input

    // Dedicated Signals for Waveform functionality
    // AES-128
    reg [127:0] key_128;
    reg [127:0] ciphertext_128;
    reg [127:0] decrypted_128;

    // AES-192
    reg [191:0] key_192;
    reg [127:0] ciphertext_192;
    reg [127:0] decrypted_192;

    // AES-256
    reg [255:0] key_256;
    reg [127:0] ciphertext_256;
    reg [127:0] decrypted_256;

    // Interconnects to UUT
    reg [1:0]   mode;
    reg [255:0] key_in;
    reg [127:0] data_in;
    wire [127:0] data_out;
    wire        done;

    // Instantiate Top Module
    top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mode(mode),
        .encrypt_en(encrypt_en),
        .data_in(data_in),
        .key(key_in),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        start = 0;
        mode = 0;
        encrypt_en = 0;
        plaintext = 128'h00112233445566778899aabbccddeeff;
        // Define Keys
        key_128 = 128'h000102030405060708090a0b0c0d0e0f;
        key_192 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
        key_256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

        ciphertext_128 = 0;
        ciphertext_192 = 0;
        ciphertext_256 = 0;
        decrypted_128 = 0;
        decrypted_192 = 0;
        decrypted_256 = 0;

        // Reset
        #100;
        rst = 0;
        #20;

        // ============================================
        // 1. AES-128 Encryption & Decryption
        // ============================================
        $display("\n========================================");
        $display("   AES-128 TEST START");
        $display("========================================");

        // Encrypt
        mode = 2'b00;
        encrypt_en = 1;
        key_in = {128'b0, key_128};
        data_in = plaintext;
        start = 1;
        #10;
        start = 0;
        wait(done);
        ciphertext_128 = data_out;
        #10;

        $display("--- ENCRYPTION ---");
        $display("Plaintext    : %h", plaintext);
        $display("Key (128-bit): %h", key_128);
        $display("Ciphertext   : %h", ciphertext_128);

        // Decrypt
        encrypt_en = 0;
        data_in = ciphertext_128;
        start = 1;
        #10;
        start = 0;
        wait(done);
        decrypted_128 = data_out;
        #10;

        $display("--- DECRYPTION ---");
        $display("Ciphertext   : %h", ciphertext_128);
        $display("Key (128-bit): %h", key_128);
        $display("Decrypted    : %h", decrypted_128);

        if (decrypted_128 == plaintext) $display("RESULT: PASS");
        else $display("RESULT: FAIL");


        // ============================================
        // 2. AES-192 Encryption & Decryption
        // ============================================
        $display("\n========================================");
        $display("   AES-192 TEST START");
        $display("========================================");

        // Encrypt
        mode = 2'b01;
        encrypt_en = 1;
        key_in = {64'b0, key_192};
        data_in = plaintext;
        start = 1;
        #10;
        start = 0;
        wait(done);
        ciphertext_192 = data_out;
        #10;

        $display("--- ENCRYPTION ---");
        $display("Plaintext    : %h", plaintext);
        $display("Key (192-bit): %h", key_192);
        $display("Ciphertext   : %h", ciphertext_192);

        // Decrypt
        encrypt_en = 0;
        data_in = ciphertext_192;
        start = 1;
        #10;
        start = 0;
        wait(done);
        decrypted_192 = data_out;
        #10;

        $display("--- DECRYPTION ---");
        $display("Ciphertext   : %h", ciphertext_192);
        $display("Key (192-bit): %h", key_192);
        $display("Decrypted    : %h", decrypted_192);

        if (decrypted_192 == plaintext) $display("RESULT: PASS");
        else $display("RESULT: FAIL");


        // ============================================
        // 3. AES-256 Encryption & Decryption
        // ============================================
        $display("\n========================================");
        $display("   AES-256 TEST START");
        $display("========================================");

        // Encrypt
        mode = 2'b10;
        encrypt_en = 1;
        key_in = key_256;
        data_in = plaintext;
        start = 1;
        #10;
        start = 0;
        wait(done);
        ciphertext_256 = data_out;
        #10;

        $display("--- ENCRYPTION ---");
        $display("Plaintext    : %h", plaintext);
        $display("Key (256-bit): %h", key_256);
        $display("Ciphertext   : %h", ciphertext_256);

        // Decrypt
        encrypt_en = 0;
        data_in = ciphertext_256;
        start = 1;
        #10;
        start = 0;
        wait(done);
        decrypted_256 = data_out;
        #10;

        $display("--- DECRYPTION ---");
        $display("Ciphertext   : %h", ciphertext_256);
        $display("Key (256-bit): %h", key_256);
        $display("Decrypted    : %h", decrypted_256);

        if (decrypted_256 == plaintext) $display("RESULT: PASS");
        else $display("RESULT: FAIL");

        $display("\n----------------------------------------");
        $display("Simulation Complete.");
        $stop;
    end

endmodule
