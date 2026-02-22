`timescale 1ns / 1ps

module tb_aes_encrypt;

    reg clk;
    reg rst;
    reg start;
    reg [1:0] mode;
    reg [127:0] plaintext;

    // Dedicated Signals for Waveform
    reg [127:0] key_128;
    reg [127:0] ciphertext_128;

    reg [191:0] key_192;
    reg [127:0] ciphertext_192;

    reg [255:0] key_256;
    reg [127:0] ciphertext_256;

    // Interconnects
    reg [255:0] key_in;
    wire [127:0] ciphertext;
    wire done;

    // Instantiate AES Encryption Module
    aes_encrypt_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mode(mode),
        .plaintext(plaintext),
        .key(key_in),
        .ciphertext(ciphertext),
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
        plaintext = 128'h00112233445566778899aabbccddeeff;

        // Define Keys
        key_128 = 128'h000102030405060708090a0b0c0d0e0f;
        key_192 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
        key_256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

        ciphertext_128 = 0;
        ciphertext_192 = 0;
        ciphertext_256 = 0;
        key_in = 0;

        // Reset
        #100;
        rst = 0;
        #20;

        // ============================================
        // 1. AES-128 Encryption Test
        // ============================================
        $display("\n========================================");
        $display("   AES-128 ENCRYPTION TEST");
        $display("========================================");
        mode = 2'b00;
        key_in = {128'b0, key_128}; // Pad to 256
        plaintext = 128'h00112233445566778899aabbccddeeff;

        start = 1;
        #10;
        start = 0;
        wait(done);
        ciphertext_128 = ciphertext; // Capture
        #10;

        $display("Plaintext    : %h", plaintext);
        $display("Key (128-bit): %h", key_128);
        $display("Ciphertext   : %h", ciphertext_128);

        if (ciphertext_128 == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL. Expected: 69c4e0d86a7b0430d8cdb78070b4c55a");


            // ============================================
            // 2. AES-192 Encryption Test
            // ============================================
        $display("\n========================================");
        $display("   AES-192 ENCRYPTION TEST");
        $display("========================================");
        mode = 2'b01;
        key_in = {64'b0, key_192}; // Pad to 256
        plaintext = 128'h00112233445566778899aabbccddeeff;

        start = 1;
        #10;
        start = 0;
        wait(done);
        ciphertext_192 = ciphertext; // Capture
        #10;

        $display("Plaintext    : %h", plaintext);
        $display("Key (192-bit): %h", key_192);
        $display("Ciphertext   : %h", ciphertext_192);

        if (ciphertext_192 == 128'hdda97ca4864cdfe06eaf70a0ec0d7191)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL. Expected: dda97ca4864cdfe06eaf70a0ec0d7191");


            // ============================================
            // 3. AES-256 Encryption Test
            // ============================================
        $display("\n========================================");
        $display("   AES-256 ENCRYPTION TEST");
        $display("========================================");
        mode = 2'b10;
        key_in = key_256;
        plaintext = 128'h00112233445566778899aabbccddeeff;

        start = 1;
        #10;
        start = 0;
        wait(done);
        ciphertext_256 = ciphertext; // Capture
        #10;

        $display("Plaintext    : %h", plaintext);
        $display("Key (256-bit): %h", key_256);
        $display("Ciphertext   : %h", ciphertext_256);

        if (ciphertext_256 == 128'h8ea2b7ca516745bfeafc49904b496089)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL. Expected: 8ea2b7ca516745bfeafc49904b496089");

        $display("\n----------------------------------------");
        $display("Simulation Complete.");
        $stop;
    end
endmodule
