module aes_encrypt_top (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire [1:0]   mode, // 00: 128, 01: 192, 10: 256
    input  wire [127:0] plaintext,
    input  wire [255:0] key, // Max key size
    output reg  [127:0] ciphertext,
    output reg          done
);

    reg  [3:0]   round;
    reg  [127:0] state;
    reg          busy;

    // Derived number of rounds
    reg [3:0] Nr;

    always @(*) begin
        case (mode)
            2'b00: Nr = 10;
            2'b01: Nr = 12;
            2'b10: Nr = 14;
            default: Nr = 10;
        endcase
    end

    // All round keys: Max 15 * 128 = 1920 bits
    wire [1919:0] round_keys;
    reg  [127:0]  round_key;

    // Internal wires
    wire [127:0] sub_bytes_out, shift_rows_out, mix_columns_out;

    // Key Expansion
    key_expansion key_exp (
        .mode       (mode),
        .key        (key),
        .round_keys (round_keys)
    );

    // Encryption Modules
    sub_bytes    sb  (.in(state),          .out(sub_bytes_out));
    shift_rows   sr  (.in(sub_bytes_out),  .out(shift_rows_out));
    mix_columns  mc  (.in(shift_rows_out), .out(mix_columns_out));

    // Round Key Selection
    always @(*) begin
        // round_keys is [1919:0].
        // Round 0 key is at [1919 : 1919-127]
        // Round i key is at [1919 - 128*i : ...]
        round_key = round_keys[1919 - round*128 -: 128];
    end

    // FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round      <= 0;
            state      <= 0;
            ciphertext <= 0;
            done       <= 0;
            busy       <= 0;
        end else if (start && !busy) begin
            busy  <= 1;
            done  <= 0;
            round <= 1; // Current round logic processes Round 1 to Nr in loop. Initial AddKey is done here.

            // Initial AddRoundKey (Round 0)
            state <= plaintext ^ round_keys[1919 -: 128];
        end else if (busy && round < Nr) begin
            // Rounds 1 to Nr-1
            // SubBytes -> ShiftRows -> MixColumns -> AddRoundKey
            state <= mix_columns_out ^ round_key;
            round <= round + 1;
        end else if (busy && round == Nr) begin
            // Final Round (Nr)
            // SubBytes -> ShiftRows -> AddRoundKey
            ciphertext <= shift_rows_out ^ round_key;
            busy  <= 0;
            done  <= 1;
            round <= 0;
        end
    end

endmodule
