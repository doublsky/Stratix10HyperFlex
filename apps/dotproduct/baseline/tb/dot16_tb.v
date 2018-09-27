// Copyright 2018 Tian Tan
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

`timescale 1ns/1ps

module dot16_tb;

    // parameters for dot product unit
    localparam DATA_WIDTH = 8;
    localparam MULT_LATENCY = 4;
    localparam TREE_DELAY = 1;
    localparam CLK_P = 10;

    // big three
    reg     clk;
    reg     rst;
    reg     ena;

    reg     [DATA_WIDTH-1:0]    a[0:15];
    reg     [DATA_WIDTH-1:0]    b[0:15];
    wire    [DATA_WIDTH*2-1+4:0]    results;

    reg     [DATA_WIDTH*2-1+4:0]    acc;
    reg     [DATA_WIDTH*2-1+4:0]    exp_res;

    integer i, j, k;

    // instance of dot product
    top #(DATA_WIDTH, MULT_LATENCY, TREE_DELAY) dot_inst
    (
        .clk(clk),
        .rst(rst),
        .ena(ena),

        .a1_in(a[0]),
        .a2_in(a[1]),
        .a3_in(a[2]),
        .a4_in(a[3]),
        .a5_in(a[4]),
        .a6_in(a[5]),
        .a7_in(a[6]),
        .a8_in(a[7]),
        .a9_in(a[8]),
        .a10_in(a[9]),
        .a11_in(a[10]),
        .a12_in(a[11]),
        .a13_in(a[12]),
        .a14_in(a[13]),
        .a15_in(a[14]),
        .a16_in(a[15]),

        .b1_in(b[0]),
        .b2_in(b[1]),
        .b3_in(b[2]),
        .b4_in(b[3]),
        .b5_in(b[4]),
        .b6_in(b[5]),
        .b7_in(b[6]),
        .b8_in(b[7]),
        .b9_in(b[8]),
        .b10_in(b[9]),
        .b11_in(b[10]),
        .b12_in(b[11]),
        .b13_in(b[12]),
        .b14_in(b[13]),
        .b15_in(b[14]),
        .b16_in(b[15]),

        .res_out(results)
    );

    // drive the clk
    always #(CLK_P/2) clk = ~clk;

    // start simulation
    initial begin
        #0  // cycle 0
        clk = 1;
        rst = 1;
        ena = 1;

        // init inputs to zero
        for(i = 0; i < 16; i = i + 1) begin
            a[i] = 0;
            b[i] = 0;
        end

        #(10*CLK_P)    // cycle 10
        rst = 0;

        #(10*CLK_P)    // cycle 20
        a[1] = 3;
        b[1] = 4;

        #(CLK_P)
        a[2] = 5;
        b[2] = 10;
        a[5] = 6;
        b[5] = 9;

        #(100*CLK_P)   // cycle 120
        $display("PASS!");
        $finish;
    end

    // compute expected results
    always @(*) begin
        acc = 0;
        for (j = 0; j < 16; j = j + 1) begin
            acc = acc + a[j] * b[j];
        end
        exp_res <= #(CLK_P*7) acc;
    end

    // assert output
    always @(posedge clk) begin
        //$monitor("results: %d @ %t", results, $time);
        if (exp_res !== results && rst == 0) begin
            $display("Error: results %d != expected results %d @ %t", results, exp_res, $time);
            $stop;
        end
    end


endmodule
