`timescale 1ns / 1ps

module tb_aes_decrypt;

    reg clk;
    reg rst;
    reg start;
    reg [1:0] mode;

    // Dedicated Signals for Waveform
    reg [127:0] key_128;
    reg [127:0] ciphertext_128;
    reg [127:0] out1; // Plaintext out 128

    reg [191:0] key_192;
    reg [127:0] ciphertext_192;
    reg [127:0] out2; // Plaintext out 192

    reg [255:0] key_256;
    reg [127:0] ciphertext_256;
    reg [127:0] out3; // Plaintext out 256

    // Interconnects
    reg [255:0] key_in;
    reg [127:0] ciphertext_in;
    wire [127:0] plaintext;
    wire done;

    // Instantiate AES Decryption Module
    aes_decrypt_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mode(mode),
        .ciphertext(ciphertext_in),
        .key(key_in),
        .plaintext(plaintext),
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

        // Define Keys & Inputs
        key_128 = 128'h000102030405060708090a0b0c0d0e0f;
        ciphertext_128 = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;

        key_192 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
        ciphertext_192 = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;

        key_256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
        ciphertext_256 = 128'h8ea2b7ca516745bfeafc49904b496089;

        out1 = 0;
        out2 = 0;
        out3 = 0;
        key_in = 0;
        ciphertext_in = 0;

        // Reset
        #100;
        rst = 0;
        #20;

        // ============================================
        // 1. AES-128 Decryption
        // ============================================
        $display("\n========================================");
        $display("   AES-128 DECRYPTION TEST");
        $display("========================================");

        @(negedge clk); // Align to negative edge
        mode = 2'b00;
        key_in = {128'b0, key_128}; // Pad to 256
        ciphertext_in = ciphertext_128;
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);
        @(negedge clk); // Wait for stable output
        out1 = plaintext; // Capture result

        $display("Ciphertext   : %h", ciphertext_128);
        $display("Key (128-bit): %h", key_128);
        $display("Decrypted    : %h", out1);

        if (out1 == 128'h00112233445566778899aabbccddeeff)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL. Expected: 00112233445566778899aabbccddeeff");


            // ============================================
            // 2. AES-192 Decryption
            // ============================================
        $display("\n========================================");
        $display("   AES-192 DECRYPTION TEST");
        $display("========================================");

        @(negedge clk);
        mode = 2'b01;
        key_in = {64'b0, key_192}; // Pad to 256
        ciphertext_in = ciphertext_192;
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);
        @(negedge clk);
        out2 = plaintext; // Capture result

        $display("Ciphertext   : %h", ciphertext_192);
        $display("Key (192-bit): %h", key_192);
        $display("Decrypted    : %h", out2);

        if (out2 == 128'h00112233445566778899aabbccddeeff)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL. Expected: 00112233445566778899aabbccddeeff");


            // ============================================
            // 3. AES-256 Decryption
            // ============================================
        $display("\n========================================");
        $display("   AES-256 DECRYPTION TEST");
        $display("========================================");

        @(negedge clk);
        mode = 2'b10;
        key_in = key_256;
        ciphertext_in = ciphertext_256;
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);
        @(negedge clk);
        out3 = plaintext; // Capture result

        $display("Ciphertext   : %h", ciphertext_256);
        $display("Key (256-bit): %h", key_256);
        $display("Decrypted    : %h", out3);

        if (out3 == 128'h00112233445566778899aabbccddeeff)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL. Expected: 00112233445566778899aabbccddeeff");

        $display("\n----------------------------------------");
        $display("Simulation Complete.");
        $stop;
    end
endmodule
