module aes_decrypt_top (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire [1:0]   mode,
    input  wire [127:0] ciphertext,
    input  wire [255:0] key,
    output reg  [127:0] plaintext,
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
    wire [127:0] inv_shift_rows_out;
    wire [127:0] inv_sub_bytes_out;
    wire [127:0] after_key;
    wire [127:0] inv_mix_columns_out;

    // Key Expansion
    key_expansion key_exp (
        .mode       (mode),
        .key        (key),
        .round_keys (round_keys)
    );

    // Decryption Modules
    // Note: Assuming these modules exist and match these interfaces from original project
    InvShiftRows           isr (.state_in(state),           .state_out(inv_shift_rows_out));
    InvSubstitutionMatrix  isb (.Data(inv_shift_rows_out),  .Data_out(inv_sub_bytes_out));
    // after_key = inv_sub_bytes_out ^ round_key (performed in assignment)
    InvMixColumns          imc (.state_in(after_key),       .state_out(inv_mix_columns_out));

    assign after_key = inv_sub_bytes_out ^ round_key;

    // Round Key Selection for Decryption
    always @(*) begin
        // Decryption uses keys in reverse order.
        // Initial state uses Key[Nr].
        // Round 1 uses Key[Nr-1].
        // ...
        // Round Nr uses Key[0].

        // FSM Logic:
        // Initial step sets state (uses Key[Nr]).
        // Then loop round 1 to Nr.
        // So in loop, if round=r, we want Key[Nr-r].
        // Key[k] is at round_keys[1919 - 128*k -: 128].
        // So Key[Nr-r] is round_keys[1919 - 128*(Nr-r) -: 128].

        if (busy) begin
            // During rounds 1..Nr
            round_key = round_keys[1919 - (Nr - round)*128 -: 128];
        end else begin
            // For initial state (before busy loop starts, or right at start)
            // We need Key[Nr].
            round_key = round_keys[1919 - Nr*128 -: 128];
        end
    end

    // FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round      <= 0;
            state      <= 0;
            plaintext  <= 0;
            done       <= 0;
            busy       <= 0;
        end else if (start && !busy) begin
            busy  <= 1;
            done  <= 0;
            round <= 1;

            // Initial AddRoundKey (Round Nr)
            state <= ciphertext ^ round_keys[1919 - Nr*128 -: 128];
        end else if (busy && round < Nr) begin
            // Rounds 1 to Nr-1
            // InvShift -> InvSub -> AddRoundKey -> InvMix
            state <= inv_mix_columns_out;
            round <= round + 1;
        end else if (busy && round == Nr) begin
            // Final Round (Nr)
            // InvShift -> InvSub -> AddRoundKey
            plaintext <= after_key; // which is InvSub ^ RoundKey[0]
            busy  <= 0;
            done  <= 1;
            round <= 0;
        end
    end

endmodule
