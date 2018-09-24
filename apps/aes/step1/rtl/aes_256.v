/*
 * Copyright 2012, Homer Hsing <homer.hsing@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module aes_256 (clk, state, key, out);
    input          clk;
    input  [127:0] state;
    input  [255:0] key;
    output [127:0] out;
    reg    [127:0] s0, k0b;
    reg    [255:0] k0, k0a, k1, k1_d;
    wire   [127:0] s1, s2_pre, s2_post, s3_pre, s3_post, s4_pre, s4_post, s5_pre, s5_post, s6_pre, s6_post, s7_pre, s7_post, s8_pre, s8_post,
                   s9_pre, s9_post, s10_pre, s10_post, s11_pre, s11_post, s12_pre, s12_post, s13_pre, s13_post;
    wire   [255:0] k2_pre, k2_post, k3_pre, k3_post, k4_pre, k4_post, k5_pre, k5_post, k6_pre, k6_post, k7_pre, k7_post, k8_pre, k8_post,
                   k9_pre, k9_post, k10_pre, k10_post, k11_pre, k11_post, k12_pre, k12_post, k13_pre, k13_post;
    wire   [127:0] k1b, k2b, k3b, k4b, k5b, k6b, k7b, k8b,
                   k9b, k10b, k11b, k12b, k13b;

    always @ (posedge clk)
      begin
        s0 <= state ^ key[255:128];
        k0 <= key;
        k0a <= k0;
        k1_d <= k0a;
	      k0b <= k0a[127:0];
        k1 <= k1_d;
      end

    //assign k0b = k0a[127:0];
    // ************* hyper retime *****************
    regchain #(0, 384) s2_rc(clk, {s2_pre, k2_pre}, {s2_post, k2_post});
    regchain #(0, 384) s3_rc(clk, {s3_pre, k3_pre}, {s3_post, k3_post});
    regchain #(0, 384) s4_rc(clk, {s4_pre, k4_pre}, {s4_post, k4_post});
    regchain #(0, 384) s5_rc(clk, {s5_pre, k5_pre}, {s5_post, k5_post});
    regchain #(0, 384) s6_rc(clk, {s6_pre, k6_pre}, {s6_post, k6_post});
    regchain #(0, 384) s7_rc(clk, {s7_pre, k7_pre}, {s7_post, k7_post});
    regchain #(0, 384) s8_rc(clk, {s8_pre, k8_pre}, {s8_post, k8_post});
    regchain #(0, 384) s9_rc(clk, {s9_pre, k9_pre}, {s9_post, k9_post});
    regchain #(0, 384) s10_rc(clk, {s10_pre, k10_pre}, {s10_post, k10_post});
    regchain #(0, 384) s11_rc(clk, {s11_pre, k11_pre}, {s11_post, k11_post});
    regchain #(0, 384) s12_rc(clk, {s12_pre, k12_pre}, {s12_post, k12_post});
    regchain #(0, 384) s13_rc(clk, {s13_pre, k13_pre}, {s13_post, k13_post});
    // ************* hyper retime *****************

    expand_key_type_A_256
        a1 (clk, k1, 8'h1, k2_pre, k1b),
        a3 (clk, k3_post, 8'h2, k4_pre, k3b),
        a5 (clk, k5_post, 8'h4, k6_pre, k5b),
        a7 (clk, k7_post, 8'h8, k8_pre, k7b),
        a9 (clk, k9_post, 8'h10, k10_pre, k9b),
        a11 (clk, k11_post, 8'h20, k12_pre, k11b),
        a13 (clk, k13_post, 8'h40,    , k13b);

    expand_key_type_B_256
        a2 (clk, k2_post, k3_pre, k2b),
        a4 (clk, k4_post, k5_pre, k4b),
        a6 (clk, k6_post, k7_pre, k6b),
        a8 (clk, k8_post, k9_pre, k8b),
        a10 (clk, k10_post, k11_pre, k10b),
        a12 (clk, k12_post, k13_pre, k12b);

    one_round
         r1 (clk, s0, k0b, s1),
         r2 (clk, s1, k1b, s2_pre),
         r3 (clk, s2_post, k2b, s3_pre),
         r4 (clk, s3_post, k3b, s4_pre),
         r5 (clk, s4_post, k4b, s5_pre),
         r6 (clk, s5_post, k5b, s6_pre),
         r7 (clk, s6_post, k6b, s7_pre),
         r8 (clk, s7_post, k7b, s8_pre),
         r9 (clk, s8_post, k8b, s9_pre),
        r10 (clk, s9_post, k9b, s10_pre),
        r11 (clk, s10_post, k10b, s11_pre),
        r12 (clk, s11_post, k11b, s12_pre),
        r13 (clk, s12_post, k12b, s13_pre);

    final_round
        rf (clk, s13_post, k13b, out);
endmodule

/* expand k0,k1,k2,k3 for every two clock cycles */
module expand_key_type_A_256 (clk, in, rcon, out_1, out_2);
    input              clk;
    input      [255:0] in;
    input      [7:0]   rcon;
    output reg [255:0] out_1;
    output     [127:0] out_2;
    wire       [31:0]  k0, k1, k2, k3, k4, k5, k6, k7,
                       v0, v1, v2, v3;
    reg        [31:0]  k0a, k1a, k2a, k3a, k4a, k5a, k6a, k7a;
    wire       [31:0]  k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b, k8a;

    reg        [255:0] tmp;

    assign {k0, k1, k2, k3, k4, k5, k6, k7} = in;

    assign v0 = {k0[31:24] ^ rcon, k0[23:0]};
    assign v1 = v0 ^ k1;
    assign v2 = v1 ^ k2;
    assign v3 = v2 ^ k3;

    always @ (posedge clk)
    begin
        tmp <= {v0, v1, v2, v3, k4, k5, k6, k7};
        {k0a, k1a, k2a, k3a, k4a, k5a, k6a, k7a} <= tmp;
    end

    S4
        S4_0 (clk, {k7[23:0], k7[31:24]}, k8a);

    assign k0b = k0a ^ k8a;
    assign k1b = k1a ^ k8a;
    assign k2b = k2a ^ k8a;
    assign k3b = k3a ^ k8a;
    assign {k4b, k5b, k6b, k7b} = {k4a, k5a, k6a, k7a};

    always @ (posedge clk)
        out_1 <= {k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b};

    assign out_2 = {k0b, k1b, k2b, k3b};

    //regshf #(1, 256) out_1_hp(clk, out_1_tmp, out_1);
    //regshf #(1, 128) out_2_hp(clk, out_2_tmp, out_2);
endmodule

/* expand k4,k5,k6,k7 for every two clock cycles */
module expand_key_type_B_256 (clk, in, out_1, out_2);
    input              clk;
    input      [255:0] in;
    output reg [255:0] out_1;
    output     [127:0] out_2;
    wire       [31:0]  k0, k1, k2, k3, k4, k5, k6, k7,
                       v5, v6, v7;
    reg        [31:0]  k0a, k1a, k2a, k3a, k4a, k5a, k6a, k7a;
    wire       [31:0]  k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b, k8a;

    reg        [255:0] tmp;

    assign {k0, k1, k2, k3, k4, k5, k6, k7} = in;

    assign v5 = k4 ^ k5;
    assign v6 = v5 ^ k6;
    assign v7 = v6 ^ k7;

    always @ (posedge clk)
    begin
        tmp <= {k0, k1, k2, k3, k4, v5, v6, v7};
        {k0a, k1a, k2a, k3a, k4a, k5a, k6a, k7a} <= tmp;
    end

    S4
        S4_0 (clk, k3, k8a);

    assign {k0b, k1b, k2b, k3b} = {k0a, k1a, k2a, k3a};
    assign k4b = k4a ^ k8a;
    assign k5b = k5a ^ k8a;
    assign k6b = k6a ^ k8a;
    assign k7b = k7a ^ k8a;

    always @ (posedge clk)
        out_1 <= {k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b};

    assign out_2 = {k4b, k5b, k6b, k7b};

    //regshf #(1, 256) out_1_hp(clk, out_1_tmp, out_1);
    //regshf #(1, 128) out_2_hp(clk, out_2_tmp, out_2);
endmodule
