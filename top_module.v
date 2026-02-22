module top_module (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire [1:0]   mode, // 00: 128, 01: 192, 10: 256
    input  wire         encrypt_en, // 1: Encrypt, 0: Decrypt
    input  wire [127:0] data_in,
    input  wire [255:0] key,
    output reg  [127:0] data_out,
    output reg          done
);

    wire [127:0] enc_out, dec_out;
    wire         enc_done, dec_done;

    // Instantiate Encryption Module
    aes_encrypt_top enc_inst (
        .clk        (clk),
        .rst        (rst),
        .start      (start && encrypt_en),
        .mode       (mode),
        .plaintext  (data_in),
        .key        (key),
        .ciphertext (enc_out),
        .done       (enc_done)
    );

    // Instantiate Decryption Module
    aes_decrypt_top dec_inst (
        .clk        (clk),
        .rst        (rst),
        .start      (start && !encrypt_en),
        .mode       (mode),
        .ciphertext (data_in),
        .key        (key),
        .plaintext  (dec_out),
        .done       (dec_done)
    );

    // Multiplex Output
    always @(*) begin
        if (encrypt_en) begin
            data_out = enc_out;
            done     = enc_done;
        end else begin
            data_out = dec_out;
            done     = dec_done;
        end
    end

endmodule
