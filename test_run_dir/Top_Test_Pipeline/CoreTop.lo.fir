circuit CoreTop :
  module IMEM :
    input clock : Clock
    input reset : UInt<1>
    input io_address : UInt<32>
    input io_dataIn : UInt<32>
    input io_wen : UInt<1>
    output io_dataOut : UInt<32>

    mem async_mem : @[IMEM.scala 31:24]
      data-type => UInt<32>
      depth => 256
      read-latency => 0
      write-latency => 1
      reader => io_dataOut_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = bits(io_address, 7, 0)
    node _GEN_0 = validif(io_wen, _T) @[IMEM.scala 35:5]
    node _GEN_1 = validif(io_wen, clock) @[IMEM.scala 35:5]
    node _GEN_2 = mux(io_wen, UInt<1>("h1"), UInt<1>("h0")) @[IMEM.scala 35:5 IMEM.scala 31:24]
    node _GEN_3 = validif(io_wen, UInt<1>("h1")) @[IMEM.scala 35:5]
    node _GEN_4 = validif(io_wen, io_dataIn) @[IMEM.scala 35:5]
    node _address_pc_T = mux(UInt<1>("h0"), UInt<2>("h3"), UInt<2>("h0")) @[Bitwise.scala 72:12]
    node _address_pc_T_1 = cat(_address_pc_T, io_address) @[IMEM.scala 39:35]
    node address_pc = shr(_address_pc_T_1, 2) @[IMEM.scala 39:49]
    node _io_dataOut_T = bits(address_pc, 7, 0) @[IMEM.scala 43:33]
    io_dataOut <= async_mem.io_dataOut_MPORT.data @[IMEM.scala 43:16]
    async_mem.io_dataOut_MPORT.addr <= _io_dataOut_T @[IMEM.scala 43:33]
    async_mem.io_dataOut_MPORT.en <= UInt<1>("h1") @[IMEM.scala 43:33]
    async_mem.io_dataOut_MPORT.clk <= clock @[IMEM.scala 43:33]
    async_mem.MPORT.addr <= _GEN_0
    async_mem.MPORT.en <= _GEN_2
    async_mem.MPORT.clk <= _GEN_1
    async_mem.MPORT.data <= _GEN_4
    async_mem.MPORT.mask <= _GEN_3

  module PC :
    input clock : Clock
    input reset : UInt<1>
    input io_en_jump : UInt<1>
    input io_br_imm : SInt<32>
    input io_jalr_en_pc : UInt<1>
    output io_out : SInt<10>

    reg counter : SInt<10>, clock with :
      reset => (UInt<1>("h0"), counter) @[PC.scala 14:27]
    node _count_buffer_T = eq(counter, asSInt(UInt<12>("h400"))) @[PC.scala 17:96]
    node _count_buffer_T_1 = add(counter, asSInt(UInt<4>("h4"))) @[PC.scala 18:46]
    node _count_buffer_T_2 = tail(_count_buffer_T_1, 1) @[PC.scala 18:46]
    node _count_buffer_T_3 = asSInt(_count_buffer_T_2) @[PC.scala 18:46]
    node _count_buffer_T_4 = mux(_count_buffer_T, asSInt(UInt<1>("h0")), _count_buffer_T_3) @[PC.scala 17:86]
    node _count_buffer_T_5 = mux(io_en_jump, io_br_imm, _count_buffer_T_4) @[PC.scala 17:57]
    node count_buffer = mux(io_jalr_en_pc, io_br_imm, _count_buffer_T_5) @[PC.scala 17:27]
    io_out <= counter @[PC.scala 22:12]
    counter <= mux(reset, asSInt(UInt<10>("h0")), asSInt(bits(count_buffer, 9, 0))) @[PC.scala 14:27 PC.scala 14:27 PC.scala 20:13]

  module Fetch :
    input clock : Clock
    input reset : UInt<1>
    input io_fetch_pc_br_imm : SInt<32>
    input io_fetch_pc_en_jump : UInt<1>
    input io_fetch_jalr_en_pc : UInt<1>
    input io_fetch_wen : UInt<1>
    output io_fetch_dataOut : UInt<32>
    output io_fetch_pc_out : SInt<10>

    inst imem_module_Fetch of IMEM @[Fetch.scala 42:39]
    inst pc_module_Fetch of PC @[Fetch.scala 43:39]
    node _imem_module_Fetch_io_address_T = asUInt(pc_module_Fetch.io_out) @[Fetch.scala 57:65]
    io_fetch_dataOut <= imem_module_Fetch.io_dataOut @[Fetch.scala 60:37]
    io_fetch_pc_out <= pc_module_Fetch.io_out @[Fetch.scala 61:43]
    imem_module_Fetch.clock <= clock
    imem_module_Fetch.reset <= reset
    imem_module_Fetch.io_address <= _imem_module_Fetch_io_address_T @[Fetch.scala 57:37]
    imem_module_Fetch.io_dataIn <= UInt<1>("h0") @[Fetch.scala 58:37]
    imem_module_Fetch.io_wen <= io_fetch_wen @[Fetch.scala 59:37]
    pc_module_Fetch.clock <= clock
    pc_module_Fetch.reset <= reset
    pc_module_Fetch.io_en_jump <= io_fetch_pc_en_jump @[Fetch.scala 54:37]
    pc_module_Fetch.io_br_imm <= io_fetch_pc_br_imm @[Fetch.scala 53:37]
    pc_module_Fetch.io_jalr_en_pc <= io_fetch_jalr_en_pc @[Fetch.scala 55:37]

  module CU :
    input clock : Clock
    input reset : UInt<1>
    input io_ins : UInt<32>
    input io_dmem_addr2 : UInt<2>
    output io_w_en : UInt<1>
    output io_imem_en : UInt<1>
    output io_rs1 : UInt<5>
    output io_rs2 : UInt<5>
    output io_rd : UInt<5>
    output io_r_en : UInt<1>
    output io_dmem_en : UInt<1>
    output io_immediate : UInt<32>
    output io_func3_7 : UInt<4>
    output io_br_en : UInt<1>
    output io_unbr_en : UInt<1>
    output io_mask_val_0 : UInt<1>
    output io_mask_val_1 : UInt<1>
    output io_mask_val_2 : UInt<1>
    output io_mask_val_3 : UInt<1>
    output io_jalr_en : UInt<1>

    node _io_rs1_T = bits(io_ins, 19, 15) @[CU.scala 64:21]
    node _io_rs2_T = bits(io_ins, 24, 20) @[CU.scala 65:21]
    node _io_rd_T = bits(io_ins, 11, 7) @[CU.scala 66:20]
    node _io_func3_7_T = bits(io_ins, 14, 12) @[CU.scala 71:26]
    node _T = bits(io_ins, 6, 0) @[CU.scala 84:16]
    node _T_1 = eq(_T, UInt<6>("h33")) @[CU.scala 84:22]
    node io_func3_7_hi = bits(io_ins, 30, 30) @[CU.scala 87:34]
    node io_func3_7_lo = bits(io_ins, 14, 12) @[CU.scala 87:46]
    node _io_func3_7_T_1 = cat(io_func3_7_hi, io_func3_7_lo) @[Cat.scala 30:58]
    node _T_2 = bits(io_ins, 6, 0) @[CU.scala 88:22]
    node _T_3 = eq(_T_2, UInt<5>("h13")) @[CU.scala 88:28]
    node _io_immediate_T = bits(io_ins, 31, 31) @[CU.scala 91:46]
    node _io_immediate_T_1 = bits(_io_immediate_T, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi = mux(_io_immediate_T_1, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_immediate_lo = bits(io_ins, 31, 20) @[CU.scala 91:60]
    node _io_immediate_T_2 = cat(io_immediate_hi, io_immediate_lo) @[Cat.scala 30:58]
    node _T_4 = bits(io_ins, 14, 12) @[CU.scala 93:20]
    node _T_5 = eq(_T_4, UInt<1>("h1")) @[CU.scala 93:28]
    node _T_6 = bits(io_ins, 14, 12) @[CU.scala 94:18]
    node _T_7 = eq(_T_6, UInt<3>("h5")) @[CU.scala 94:26]
    node _T_8 = or(_T_5, _T_7) @[CU.scala 94:9]
    node _T_9 = bits(io_ins, 14, 12) @[CU.scala 94:49]
    node _T_10 = eq(_T_9, UInt<4>("hd")) @[CU.scala 94:57]
    node _T_11 = or(_T_8, _T_10) @[CU.scala 94:40]
    node io_func3_7_hi_1 = bits(io_ins, 30, 30) @[CU.scala 96:38]
    node io_func3_7_lo_1 = bits(io_ins, 14, 12) @[CU.scala 96:50]
    node _io_func3_7_T_2 = cat(io_func3_7_hi_1, io_func3_7_lo_1) @[Cat.scala 30:58]
    node _GEN_0 = mux(_T_11, _io_func3_7_T_2, _io_func3_7_T) @[CU.scala 95:9 CU.scala 96:24 CU.scala 71:16]
    node _T_12 = bits(io_ins, 6, 0) @[CU.scala 98:22]
    node _T_13 = eq(_T_12, UInt<2>("h3")) @[CU.scala 98:28]
    node _io_immediate_T_3 = bits(io_ins, 31, 31) @[CU.scala 100:46]
    node _io_immediate_T_4 = bits(_io_immediate_T_3, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_1 = mux(_io_immediate_T_4, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_immediate_lo_1 = bits(io_ins, 31, 20) @[CU.scala 100:60]
    node _io_immediate_T_5 = cat(io_immediate_hi_1, io_immediate_lo_1) @[Cat.scala 30:58]
    node _T_14 = bits(io_ins, 6, 0) @[CU.scala 104:22]
    node _T_15 = eq(_T_14, UInt<6>("h23")) @[CU.scala 104:28]
    node imm_temp_hi = bits(io_ins, 31, 25) @[CU.scala 106:35]
    node imm_temp_lo = bits(io_ins, 11, 7) @[CU.scala 106:50]
    node io_immediate_lo_2 = cat(imm_temp_hi, imm_temp_lo) @[Cat.scala 30:58]
    node _io_immediate_T_6 = bits(io_immediate_lo_2, 11, 11) @[CU.scala 107:46]
    node _io_immediate_T_7 = bits(_io_immediate_T_6, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_2 = mux(_io_immediate_T_7, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node _io_immediate_T_8 = cat(io_immediate_hi_2, io_immediate_lo_2) @[Cat.scala 30:58]
    node _T_16 = bits(io_ins, 14, 12) @[CU.scala 114:20]
    node _T_17 = eq(_T_16, UInt<1>("h0")) @[CU.scala 114:28]
    node _T_18 = eq(io_dmem_addr2, UInt<1>("h0")) @[CU.scala 116:32]
    node _T_19 = eq(io_dmem_addr2, UInt<1>("h1")) @[CU.scala 122:38]
    node _T_20 = eq(io_dmem_addr2, UInt<2>("h2")) @[CU.scala 128:38]
    node _T_21 = eq(io_dmem_addr2, UInt<2>("h3")) @[CU.scala 134:38]
    node _GEN_1 = mux(_T_21, UInt<1>("h0"), UInt<1>("h0")) @[CU.scala 135:13 CU.scala 136:32 CU.scala 58:20]
    node _GEN_2 = mux(_T_21, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 135:13 CU.scala 139:32 CU.scala 61:20]
    node _GEN_3 = mux(_T_20, UInt<1>("h0"), _GEN_1) @[CU.scala 129:13 CU.scala 130:32]
    node _GEN_4 = mux(_T_20, UInt<1>("h1"), _GEN_1) @[CU.scala 129:13 CU.scala 132:32]
    node _GEN_5 = mux(_T_20, UInt<1>("h0"), _GEN_2) @[CU.scala 129:13 CU.scala 133:32]
    node _GEN_6 = mux(_T_19, UInt<1>("h0"), _GEN_3) @[CU.scala 123:13 CU.scala 124:32]
    node _GEN_7 = mux(_T_19, UInt<1>("h1"), _GEN_3) @[CU.scala 123:13 CU.scala 125:32]
    node _GEN_8 = mux(_T_19, UInt<1>("h0"), _GEN_4) @[CU.scala 123:13 CU.scala 126:32]
    node _GEN_9 = mux(_T_19, UInt<1>("h0"), _GEN_5) @[CU.scala 123:13 CU.scala 127:32]
    node _GEN_10 = mux(_T_18, UInt<1>("h1"), _GEN_6) @[CU.scala 117:13 CU.scala 118:32]
    node _GEN_11 = mux(_T_18, UInt<1>("h0"), _GEN_7) @[CU.scala 117:13 CU.scala 119:32]
    node _GEN_12 = mux(_T_18, UInt<1>("h0"), _GEN_8) @[CU.scala 117:13 CU.scala 120:32]
    node _GEN_13 = mux(_T_18, UInt<1>("h0"), _GEN_9) @[CU.scala 117:13 CU.scala 121:32]
    node _T_22 = bits(io_ins, 14, 12) @[CU.scala 142:26]
    node _T_23 = eq(_T_22, UInt<1>("h1")) @[CU.scala 142:34]
    node _T_24 = eq(io_dmem_addr2, UInt<1>("h0")) @[CU.scala 144:32]
    node _T_25 = eq(io_dmem_addr2, UInt<1>("h1")) @[CU.scala 150:38]
    node _T_26 = eq(io_dmem_addr2, UInt<2>("h2")) @[CU.scala 156:38]
    node _T_27 = eq(io_dmem_addr2, UInt<2>("h3")) @[CU.scala 162:38]
    node _GEN_14 = mux(_T_27, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 163:13 CU.scala 164:32 CU.scala 58:20]
    node _GEN_15 = mux(_T_27, UInt<1>("h0"), UInt<1>("h0")) @[CU.scala 163:13 CU.scala 165:32 CU.scala 59:20]
    node _GEN_16 = mux(_T_26, UInt<1>("h0"), _GEN_14) @[CU.scala 157:13 CU.scala 158:32]
    node _GEN_17 = mux(_T_26, UInt<1>("h0"), _GEN_15) @[CU.scala 157:13 CU.scala 159:32]
    node _GEN_18 = mux(_T_26, UInt<1>("h1"), _GEN_15) @[CU.scala 157:13 CU.scala 160:32]
    node _GEN_19 = mux(_T_26, UInt<1>("h1"), _GEN_14) @[CU.scala 157:13 CU.scala 161:32]
    node _GEN_20 = mux(_T_25, UInt<1>("h0"), _GEN_16) @[CU.scala 151:13 CU.scala 152:32]
    node _GEN_21 = mux(_T_25, UInt<1>("h1"), _GEN_17) @[CU.scala 151:13 CU.scala 153:32]
    node _GEN_22 = mux(_T_25, UInt<1>("h1"), _GEN_18) @[CU.scala 151:13 CU.scala 154:32]
    node _GEN_23 = mux(_T_25, UInt<1>("h0"), _GEN_19) @[CU.scala 151:13 CU.scala 155:32]
    node _GEN_24 = mux(_T_24, UInt<1>("h1"), _GEN_20) @[CU.scala 145:13 CU.scala 146:32]
    node _GEN_25 = mux(_T_24, UInt<1>("h1"), _GEN_21) @[CU.scala 145:13 CU.scala 147:32]
    node _GEN_26 = mux(_T_24, UInt<1>("h0"), _GEN_22) @[CU.scala 145:13 CU.scala 148:32]
    node _GEN_27 = mux(_T_24, UInt<1>("h0"), _GEN_23) @[CU.scala 145:13 CU.scala 149:32]
    node _T_28 = bits(io_ins, 14, 12) @[CU.scala 170:26]
    node _T_29 = eq(_T_28, UInt<2>("h2")) @[CU.scala 170:34]
    node _T_30 = eq(io_dmem_addr2, UInt<1>("h0")) @[CU.scala 172:32]
    node _GEN_28 = mux(_T_30, UInt<1>("h1"), UInt<1>("h1")) @[CU.scala 173:13 CU.scala 174:32 CU.scala 179:32]
    node _GEN_29 = mux(_T_29, _GEN_28, UInt<1>("h0")) @[CU.scala 171:9 CU.scala 58:20]
    node _GEN_30 = mux(_T_23, _GEN_24, _GEN_29) @[CU.scala 143:9]
    node _GEN_31 = mux(_T_23, _GEN_25, _GEN_29) @[CU.scala 143:9]
    node _GEN_32 = mux(_T_23, _GEN_26, _GEN_29) @[CU.scala 143:9]
    node _GEN_33 = mux(_T_23, _GEN_27, _GEN_29) @[CU.scala 143:9]
    node _GEN_34 = mux(_T_17, _GEN_10, _GEN_30) @[CU.scala 115:9]
    node _GEN_35 = mux(_T_17, _GEN_11, _GEN_31) @[CU.scala 115:9]
    node _GEN_36 = mux(_T_17, _GEN_12, _GEN_32) @[CU.scala 115:9]
    node _GEN_37 = mux(_T_17, _GEN_13, _GEN_33) @[CU.scala 115:9]
    node _T_31 = bits(io_ins, 6, 0) @[CU.scala 188:22]
    node _T_32 = eq(_T_31, UInt<6>("h37")) @[CU.scala 188:28]
    node io_immediate_hi_3 = bits(io_ins, 31, 12) @[CU.scala 190:36]
    node io_immediate_lo_3 = mux(UInt<1>("h0"), UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 72:12]
    node _io_immediate_T_9 = cat(io_immediate_hi_3, io_immediate_lo_3) @[Cat.scala 30:58]
    node _T_33 = bits(io_ins, 6, 0) @[CU.scala 193:22]
    node _T_34 = eq(_T_33, UInt<5>("h17")) @[CU.scala 193:28]
    node _io_immediate_T_10 = bits(io_ins, 31, 12) @[CU.scala 195:33]
    node _io_immediate_T_11 = shl(_io_immediate_T_10, 12) @[CU.scala 195:43]
    node _T_35 = bits(io_ins, 6, 0) @[CU.scala 198:22]
    node _T_36 = eq(_T_35, UInt<7>("h63")) @[CU.scala 198:28]
    node temp_hi_hi_hi = bits(io_ins, 31, 31) @[CU.scala 201:30]
    node temp_hi_hi_lo = bits(io_ins, 7, 7) @[CU.scala 201:42]
    node temp_hi_lo = bits(io_ins, 30, 25) @[CU.scala 201:53]
    node temp_lo_hi = bits(io_ins, 11, 8) @[CU.scala 201:67]
    node temp_lo = cat(temp_lo_hi, UInt<1>("h0")) @[Cat.scala 30:58]
    node temp_hi_hi = cat(temp_hi_hi_hi, temp_hi_hi_lo) @[Cat.scala 30:58]
    node temp_hi = cat(temp_hi_hi, temp_hi_lo) @[Cat.scala 30:58]
    node io_immediate_lo_4 = cat(temp_hi, temp_lo) @[Cat.scala 30:58]
    node _io_immediate_T_12 = bits(io_immediate_lo_4, 12, 12) @[CU.scala 202:43]
    node _io_immediate_T_13 = bits(_io_immediate_T_12, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_4 = mux(_io_immediate_T_13, UInt<19>("h7ffff"), UInt<19>("h0")) @[Bitwise.scala 72:12]
    node _io_immediate_T_14 = cat(io_immediate_hi_4, io_immediate_lo_4) @[Cat.scala 30:58]
    node _io_func3_7_T_3 = bits(io_ins, 14, 12) @[CU.scala 204:29]
    node _T_37 = bits(io_ins, 6, 0) @[CU.scala 206:22]
    node _T_38 = eq(_T_37, UInt<7>("h6f")) @[CU.scala 206:28]
    node temp_hi_hi_hi_1 = bits(io_ins, 31, 31) @[CU.scala 209:31]
    node temp_hi_hi_lo_1 = bits(io_ins, 19, 12) @[CU.scala 209:42]
    node temp_hi_lo_1 = bits(io_ins, 20, 20) @[CU.scala 209:56]
    node temp_lo_hi_1 = bits(io_ins, 30, 21) @[CU.scala 209:67]
    node temp_lo_1 = cat(temp_lo_hi_1, UInt<1>("h0")) @[Cat.scala 30:58]
    node temp_hi_hi_1 = cat(temp_hi_hi_hi_1, temp_hi_hi_lo_1) @[Cat.scala 30:58]
    node temp_hi_1 = cat(temp_hi_hi_1, temp_hi_lo_1) @[Cat.scala 30:58]
    node io_immediate_lo_5 = cat(temp_hi_1, temp_lo_1) @[Cat.scala 30:58]
    node _io_immediate_T_15 = bits(io_immediate_lo_5, 20, 20) @[CU.scala 210:43]
    node _io_immediate_T_16 = bits(_io_immediate_T_15, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_5 = mux(_io_immediate_T_16, UInt<11>("h7ff"), UInt<11>("h0")) @[Bitwise.scala 72:12]
    node _io_immediate_T_17 = cat(io_immediate_hi_5, io_immediate_lo_5) @[Cat.scala 30:58]
    node _T_39 = bits(io_ins, 6, 0) @[CU.scala 214:22]
    node _T_40 = eq(_T_39, UInt<7>("h67")) @[CU.scala 214:28]
    node _io_immediate_T_18 = bits(io_ins, 31, 31) @[CU.scala 216:46]
    node _io_immediate_T_19 = bits(_io_immediate_T_18, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_6 = mux(_io_immediate_T_19, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_immediate_lo_6 = bits(io_ins, 31, 20) @[CU.scala 216:60]
    node _io_immediate_T_20 = cat(io_immediate_hi_6, io_immediate_lo_6) @[Cat.scala 30:58]
    node _GEN_38 = mux(_T_40, _io_immediate_T_20, UInt<1>("h0")) @[CU.scala 215:5 CU.scala 216:22 CU.scala 67:18]
    node _GEN_39 = mux(_T_40, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 215:5 CU.scala 217:17 CU.scala 50:13]
    node _GEN_40 = mux(_T_40, UInt<1>("h0"), _io_func3_7_T) @[CU.scala 215:5 CU.scala 218:20 CU.scala 71:16]
    node _GEN_41 = mux(_T_38, _io_immediate_T_17, _GEN_38) @[CU.scala 207:5 CU.scala 210:22]
    node _GEN_42 = mux(_T_38, UInt<1>("h1"), _GEN_39) @[CU.scala 207:5 CU.scala 211:17]
    node _GEN_43 = mux(_T_38, UInt<1>("h0"), _GEN_40) @[CU.scala 207:5 CU.scala 212:21]
    node _GEN_44 = mux(_T_38, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 207:5 CU.scala 213:21 CU.scala 54:16]
    node _GEN_45 = mux(_T_38, UInt<1>("h0"), _GEN_39) @[CU.scala 207:5 CU.scala 56:16]
    node _GEN_46 = mux(_T_36, _io_immediate_T_14, _GEN_41) @[CU.scala 199:5 CU.scala 202:22]
    node _GEN_47 = mux(_T_36, UInt<1>("h0"), _GEN_42) @[CU.scala 199:5 CU.scala 203:17]
    node _GEN_48 = mux(_T_36, _io_func3_7_T_3, _GEN_43) @[CU.scala 199:5 CU.scala 204:20]
    node _GEN_49 = mux(_T_36, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 199:5 CU.scala 205:18 CU.scala 52:14]
    node _GEN_50 = mux(_T_36, UInt<1>("h0"), _GEN_44) @[CU.scala 199:5 CU.scala 54:16]
    node _GEN_51 = mux(_T_36, UInt<1>("h0"), _GEN_45) @[CU.scala 199:5 CU.scala 56:16]
    node _GEN_52 = mux(_T_34, _io_immediate_T_11, _GEN_46) @[CU.scala 194:5 CU.scala 195:22]
    node _GEN_53 = mux(_T_34, UInt<1>("h1"), _GEN_47) @[CU.scala 194:5 CU.scala 196:17]
    node _GEN_54 = mux(_T_34, UInt<1>("h0"), _GEN_48) @[CU.scala 194:5 CU.scala 197:20]
    node _GEN_55 = mux(_T_34, UInt<1>("h0"), _GEN_49) @[CU.scala 194:5 CU.scala 52:14]
    node _GEN_56 = mux(_T_34, UInt<1>("h0"), _GEN_50) @[CU.scala 194:5 CU.scala 54:16]
    node _GEN_57 = mux(_T_34, UInt<1>("h0"), _GEN_51) @[CU.scala 194:5 CU.scala 56:16]
    node _GEN_58 = mux(_T_32, _io_immediate_T_9, _GEN_52) @[CU.scala 189:5 CU.scala 190:22]
    node _GEN_59 = mux(_T_32, UInt<1>("h1"), _GEN_53) @[CU.scala 189:5 CU.scala 191:17]
    node _GEN_60 = mux(_T_32, UInt<1>("h0"), _GEN_54) @[CU.scala 189:5 CU.scala 192:20]
    node _GEN_61 = mux(_T_32, UInt<1>("h0"), _GEN_55) @[CU.scala 189:5 CU.scala 52:14]
    node _GEN_62 = mux(_T_32, UInt<1>("h0"), _GEN_56) @[CU.scala 189:5 CU.scala 54:16]
    node _GEN_63 = mux(_T_32, UInt<1>("h0"), _GEN_57) @[CU.scala 189:5 CU.scala 56:16]
    node _GEN_64 = mux(_T_15, _io_immediate_T_8, _GEN_58) @[CU.scala 105:5 CU.scala 107:22]
    node _GEN_65 = mux(_T_15, UInt<1>("h0"), _GEN_59) @[CU.scala 105:5 CU.scala 108:17]
    node _GEN_66 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 105:5 CU.scala 110:17 CU.scala 83:13]
    node _GEN_67 = mux(_T_15, _GEN_34, UInt<1>("h0")) @[CU.scala 105:5 CU.scala 58:20]
    node _GEN_68 = mux(_T_15, _GEN_35, UInt<1>("h0")) @[CU.scala 105:5 CU.scala 59:20]
    node _GEN_69 = mux(_T_15, _GEN_36, UInt<1>("h0")) @[CU.scala 105:5 CU.scala 60:20]
    node _GEN_70 = mux(_T_15, _GEN_37, UInt<1>("h0")) @[CU.scala 105:5 CU.scala 61:20]
    node _GEN_71 = mux(_T_15, _io_func3_7_T, _GEN_60) @[CU.scala 105:5 CU.scala 71:16]
    node _GEN_72 = mux(_T_15, UInt<1>("h0"), _GEN_61) @[CU.scala 105:5 CU.scala 52:14]
    node _GEN_73 = mux(_T_15, UInt<1>("h0"), _GEN_62) @[CU.scala 105:5 CU.scala 54:16]
    node _GEN_74 = mux(_T_15, UInt<1>("h0"), _GEN_63) @[CU.scala 105:5 CU.scala 56:16]
    node _GEN_75 = mux(_T_13, _io_immediate_T_5, _GEN_64) @[CU.scala 99:5 CU.scala 100:22]
    node _GEN_76 = mux(_T_13, UInt<1>("h1"), _GEN_65) @[CU.scala 99:5 CU.scala 101:17]
    node _GEN_77 = mux(_T_13, UInt<1>("h1"), _GEN_66) @[CU.scala 99:5 CU.scala 103:17]
    node _GEN_78 = mux(_T_13, UInt<1>("h0"), _GEN_66) @[CU.scala 99:5 CU.scala 82:16]
    node _GEN_79 = mux(_T_13, UInt<1>("h0"), _GEN_67) @[CU.scala 99:5 CU.scala 58:20]
    node _GEN_80 = mux(_T_13, UInt<1>("h0"), _GEN_68) @[CU.scala 99:5 CU.scala 59:20]
    node _GEN_81 = mux(_T_13, UInt<1>("h0"), _GEN_69) @[CU.scala 99:5 CU.scala 60:20]
    node _GEN_82 = mux(_T_13, UInt<1>("h0"), _GEN_70) @[CU.scala 99:5 CU.scala 61:20]
    node _GEN_83 = mux(_T_13, _io_func3_7_T, _GEN_71) @[CU.scala 99:5 CU.scala 71:16]
    node _GEN_84 = mux(_T_13, UInt<1>("h0"), _GEN_72) @[CU.scala 99:5 CU.scala 52:14]
    node _GEN_85 = mux(_T_13, UInt<1>("h0"), _GEN_73) @[CU.scala 99:5 CU.scala 54:16]
    node _GEN_86 = mux(_T_13, UInt<1>("h0"), _GEN_74) @[CU.scala 99:5 CU.scala 56:16]
    node _GEN_87 = mux(_T_3, UInt<1>("h1"), _GEN_76) @[CU.scala 89:5 CU.scala 90:17]
    node _GEN_88 = mux(_T_3, _io_immediate_T_2, _GEN_75) @[CU.scala 89:5 CU.scala 91:22]
    node _GEN_89 = mux(_T_3, _GEN_0, _GEN_83) @[CU.scala 89:5]
    node _GEN_90 = mux(_T_3, UInt<1>("h0"), _GEN_77) @[CU.scala 89:5 CU.scala 83:13]
    node _GEN_91 = mux(_T_3, UInt<1>("h0"), _GEN_78) @[CU.scala 89:5 CU.scala 82:16]
    node _GEN_92 = mux(_T_3, UInt<1>("h0"), _GEN_79) @[CU.scala 89:5 CU.scala 58:20]
    node _GEN_93 = mux(_T_3, UInt<1>("h0"), _GEN_80) @[CU.scala 89:5 CU.scala 59:20]
    node _GEN_94 = mux(_T_3, UInt<1>("h0"), _GEN_81) @[CU.scala 89:5 CU.scala 60:20]
    node _GEN_95 = mux(_T_3, UInt<1>("h0"), _GEN_82) @[CU.scala 89:5 CU.scala 61:20]
    node _GEN_96 = mux(_T_3, UInt<1>("h0"), _GEN_84) @[CU.scala 89:5 CU.scala 52:14]
    node _GEN_97 = mux(_T_3, UInt<1>("h0"), _GEN_85) @[CU.scala 89:5 CU.scala 54:16]
    node _GEN_98 = mux(_T_3, UInt<1>("h0"), _GEN_86) @[CU.scala 89:5 CU.scala 56:16]
    node _GEN_99 = mux(_T_1, UInt<1>("h1"), _GEN_87) @[CU.scala 85:5 CU.scala 86:17]
    node _GEN_100 = mux(_T_1, _io_func3_7_T_1, _GEN_89) @[CU.scala 85:5 CU.scala 87:20]
    node _GEN_101 = mux(_T_1, UInt<1>("h0"), _GEN_88) @[CU.scala 85:5 CU.scala 67:18]
    node _GEN_102 = mux(_T_1, UInt<1>("h0"), _GEN_90) @[CU.scala 85:5 CU.scala 83:13]
    node _GEN_103 = mux(_T_1, UInt<1>("h0"), _GEN_91) @[CU.scala 85:5 CU.scala 82:16]
    node _GEN_104 = mux(_T_1, UInt<1>("h0"), _GEN_92) @[CU.scala 85:5 CU.scala 58:20]
    node _GEN_105 = mux(_T_1, UInt<1>("h0"), _GEN_93) @[CU.scala 85:5 CU.scala 59:20]
    node _GEN_106 = mux(_T_1, UInt<1>("h0"), _GEN_94) @[CU.scala 85:5 CU.scala 60:20]
    node _GEN_107 = mux(_T_1, UInt<1>("h0"), _GEN_95) @[CU.scala 85:5 CU.scala 61:20]
    node _GEN_108 = mux(_T_1, UInt<1>("h0"), _GEN_96) @[CU.scala 85:5 CU.scala 52:14]
    node _GEN_109 = mux(_T_1, UInt<1>("h0"), _GEN_97) @[CU.scala 85:5 CU.scala 54:16]
    node _GEN_110 = mux(_T_1, UInt<1>("h0"), _GEN_98) @[CU.scala 85:5 CU.scala 56:16]
    io_w_en <= _GEN_99
    io_imem_en <= UInt<1>("h0") @[CU.scala 48:16]
    io_rs1 <= _io_rs1_T @[CU.scala 64:12]
    io_rs2 <= _io_rs2_T @[CU.scala 65:12]
    io_rd <= _io_rd_T @[CU.scala 66:11]
    io_r_en <= _GEN_102
    io_dmem_en <= _GEN_103
    io_immediate <= _GEN_101
    io_func3_7 <= _GEN_100
    io_br_en <= _GEN_108
    io_unbr_en <= _GEN_109
    io_mask_val_0 <= _GEN_104
    io_mask_val_1 <= _GEN_105
    io_mask_val_2 <= _GEN_106
    io_mask_val_3 <= _GEN_107
    io_jalr_en <= _GEN_110

  module RegisterFile :
    input clock : Clock
    input reset : UInt<1>
    input io_raddr1 : UInt<5>
    input io_raddr2 : UInt<5>
    output io_rdata1 : UInt<32>
    output io_rdata2 : UInt<32>
    input io_wen : UInt<1>
    input io_waddr : UInt<5>
    input io_wdata : UInt<32>

    reg regs_0 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_0) @[RegisterFile.scala 30:20]
    reg regs_1 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_1) @[RegisterFile.scala 30:20]
    reg regs_2 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_2) @[RegisterFile.scala 30:20]
    reg regs_3 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_3) @[RegisterFile.scala 30:20]
    reg regs_4 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_4) @[RegisterFile.scala 30:20]
    reg regs_5 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_5) @[RegisterFile.scala 30:20]
    reg regs_6 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_6) @[RegisterFile.scala 30:20]
    reg regs_7 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_7) @[RegisterFile.scala 30:20]
    reg regs_8 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_8) @[RegisterFile.scala 30:20]
    reg regs_9 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_9) @[RegisterFile.scala 30:20]
    reg regs_10 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_10) @[RegisterFile.scala 30:20]
    reg regs_11 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_11) @[RegisterFile.scala 30:20]
    reg regs_12 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_12) @[RegisterFile.scala 30:20]
    reg regs_13 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_13) @[RegisterFile.scala 30:20]
    reg regs_14 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_14) @[RegisterFile.scala 30:20]
    reg regs_15 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_15) @[RegisterFile.scala 30:20]
    reg regs_16 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_16) @[RegisterFile.scala 30:20]
    reg regs_17 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_17) @[RegisterFile.scala 30:20]
    reg regs_18 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_18) @[RegisterFile.scala 30:20]
    reg regs_19 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_19) @[RegisterFile.scala 30:20]
    reg regs_20 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_20) @[RegisterFile.scala 30:20]
    reg regs_21 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_21) @[RegisterFile.scala 30:20]
    reg regs_22 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_22) @[RegisterFile.scala 30:20]
    reg regs_23 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_23) @[RegisterFile.scala 30:20]
    reg regs_24 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_24) @[RegisterFile.scala 30:20]
    reg regs_25 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_25) @[RegisterFile.scala 30:20]
    reg regs_26 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_26) @[RegisterFile.scala 30:20]
    reg regs_27 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_27) @[RegisterFile.scala 30:20]
    reg regs_28 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_28) @[RegisterFile.scala 30:20]
    reg regs_29 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_29) @[RegisterFile.scala 30:20]
    reg regs_30 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_30) @[RegisterFile.scala 30:20]
    reg regs_31 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), regs_31) @[RegisterFile.scala 30:20]
    node _io_rdata1_T = orr(io_raddr1) @[RegisterFile.scala 31:35]
    node _GEN_0 = validif(eq(UInt<1>("h0"), io_raddr1), regs_0) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_1 = mux(eq(UInt<1>("h1"), io_raddr1), regs_1, _GEN_0) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_2 = mux(eq(UInt<2>("h2"), io_raddr1), regs_2, _GEN_1) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_3 = mux(eq(UInt<2>("h3"), io_raddr1), regs_3, _GEN_2) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_4 = mux(eq(UInt<3>("h4"), io_raddr1), regs_4, _GEN_3) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_5 = mux(eq(UInt<3>("h5"), io_raddr1), regs_5, _GEN_4) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_6 = mux(eq(UInt<3>("h6"), io_raddr1), regs_6, _GEN_5) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_7 = mux(eq(UInt<3>("h7"), io_raddr1), regs_7, _GEN_6) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_8 = mux(eq(UInt<4>("h8"), io_raddr1), regs_8, _GEN_7) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_9 = mux(eq(UInt<4>("h9"), io_raddr1), regs_9, _GEN_8) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_10 = mux(eq(UInt<4>("ha"), io_raddr1), regs_10, _GEN_9) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_11 = mux(eq(UInt<4>("hb"), io_raddr1), regs_11, _GEN_10) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_12 = mux(eq(UInt<4>("hc"), io_raddr1), regs_12, _GEN_11) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_13 = mux(eq(UInt<4>("hd"), io_raddr1), regs_13, _GEN_12) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_14 = mux(eq(UInt<4>("he"), io_raddr1), regs_14, _GEN_13) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_15 = mux(eq(UInt<4>("hf"), io_raddr1), regs_15, _GEN_14) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_16 = mux(eq(UInt<5>("h10"), io_raddr1), regs_16, _GEN_15) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_17 = mux(eq(UInt<5>("h11"), io_raddr1), regs_17, _GEN_16) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_18 = mux(eq(UInt<5>("h12"), io_raddr1), regs_18, _GEN_17) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_19 = mux(eq(UInt<5>("h13"), io_raddr1), regs_19, _GEN_18) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_20 = mux(eq(UInt<5>("h14"), io_raddr1), regs_20, _GEN_19) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_21 = mux(eq(UInt<5>("h15"), io_raddr1), regs_21, _GEN_20) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_22 = mux(eq(UInt<5>("h16"), io_raddr1), regs_22, _GEN_21) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_23 = mux(eq(UInt<5>("h17"), io_raddr1), regs_23, _GEN_22) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_24 = mux(eq(UInt<5>("h18"), io_raddr1), regs_24, _GEN_23) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_25 = mux(eq(UInt<5>("h19"), io_raddr1), regs_25, _GEN_24) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_26 = mux(eq(UInt<5>("h1a"), io_raddr1), regs_26, _GEN_25) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_27 = mux(eq(UInt<5>("h1b"), io_raddr1), regs_27, _GEN_26) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_28 = mux(eq(UInt<5>("h1c"), io_raddr1), regs_28, _GEN_27) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_29 = mux(eq(UInt<5>("h1d"), io_raddr1), regs_29, _GEN_28) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_30 = mux(eq(UInt<5>("h1e"), io_raddr1), regs_30, _GEN_29) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _GEN_31 = mux(eq(UInt<5>("h1f"), io_raddr1), regs_31, _GEN_30) @[RegisterFile.scala 31:22 RegisterFile.scala 31:22]
    node _regs_io_raddr1 = _GEN_31 @[RegisterFile.scala 31:22]
    node _io_rdata1_T_1 = mux(_io_rdata1_T, _regs_io_raddr1, UInt<1>("h0")) @[RegisterFile.scala 31:22]
    node _io_rdata2_T = orr(io_raddr2) @[RegisterFile.scala 33:35]
    node _GEN_32 = validif(eq(UInt<1>("h0"), io_raddr2), regs_0) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_33 = mux(eq(UInt<1>("h1"), io_raddr2), regs_1, _GEN_32) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_34 = mux(eq(UInt<2>("h2"), io_raddr2), regs_2, _GEN_33) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_35 = mux(eq(UInt<2>("h3"), io_raddr2), regs_3, _GEN_34) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_36 = mux(eq(UInt<3>("h4"), io_raddr2), regs_4, _GEN_35) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_37 = mux(eq(UInt<3>("h5"), io_raddr2), regs_5, _GEN_36) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_38 = mux(eq(UInt<3>("h6"), io_raddr2), regs_6, _GEN_37) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_39 = mux(eq(UInt<3>("h7"), io_raddr2), regs_7, _GEN_38) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_40 = mux(eq(UInt<4>("h8"), io_raddr2), regs_8, _GEN_39) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_41 = mux(eq(UInt<4>("h9"), io_raddr2), regs_9, _GEN_40) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_42 = mux(eq(UInt<4>("ha"), io_raddr2), regs_10, _GEN_41) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_43 = mux(eq(UInt<4>("hb"), io_raddr2), regs_11, _GEN_42) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_44 = mux(eq(UInt<4>("hc"), io_raddr2), regs_12, _GEN_43) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_45 = mux(eq(UInt<4>("hd"), io_raddr2), regs_13, _GEN_44) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_46 = mux(eq(UInt<4>("he"), io_raddr2), regs_14, _GEN_45) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_47 = mux(eq(UInt<4>("hf"), io_raddr2), regs_15, _GEN_46) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_48 = mux(eq(UInt<5>("h10"), io_raddr2), regs_16, _GEN_47) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_49 = mux(eq(UInt<5>("h11"), io_raddr2), regs_17, _GEN_48) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_50 = mux(eq(UInt<5>("h12"), io_raddr2), regs_18, _GEN_49) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_51 = mux(eq(UInt<5>("h13"), io_raddr2), regs_19, _GEN_50) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_52 = mux(eq(UInt<5>("h14"), io_raddr2), regs_20, _GEN_51) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_53 = mux(eq(UInt<5>("h15"), io_raddr2), regs_21, _GEN_52) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_54 = mux(eq(UInt<5>("h16"), io_raddr2), regs_22, _GEN_53) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_55 = mux(eq(UInt<5>("h17"), io_raddr2), regs_23, _GEN_54) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_56 = mux(eq(UInt<5>("h18"), io_raddr2), regs_24, _GEN_55) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_57 = mux(eq(UInt<5>("h19"), io_raddr2), regs_25, _GEN_56) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_58 = mux(eq(UInt<5>("h1a"), io_raddr2), regs_26, _GEN_57) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_59 = mux(eq(UInt<5>("h1b"), io_raddr2), regs_27, _GEN_58) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_60 = mux(eq(UInt<5>("h1c"), io_raddr2), regs_28, _GEN_59) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_61 = mux(eq(UInt<5>("h1d"), io_raddr2), regs_29, _GEN_60) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_62 = mux(eq(UInt<5>("h1e"), io_raddr2), regs_30, _GEN_61) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _GEN_63 = mux(eq(UInt<5>("h1f"), io_raddr2), regs_31, _GEN_62) @[RegisterFile.scala 33:22 RegisterFile.scala 33:22]
    node _regs_io_raddr2 = _GEN_63 @[RegisterFile.scala 33:22]
    node _io_rdata2_T_1 = mux(_io_rdata2_T, _regs_io_raddr2, UInt<1>("h0")) @[RegisterFile.scala 33:22]
    node _T = orr(io_waddr) @[RegisterFile.scala 35:30]
    node _T_1 = and(io_wen, _T) @[RegisterFile.scala 35:19]
    node _regs_io_waddr = io_wdata @[RegisterFile.scala 36:27 RegisterFile.scala 36:27]
    node _GEN_64 = mux(eq(UInt<1>("h0"), io_waddr), _regs_io_waddr, regs_0) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_65 = mux(eq(UInt<1>("h1"), io_waddr), _regs_io_waddr, regs_1) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_66 = mux(eq(UInt<2>("h2"), io_waddr), _regs_io_waddr, regs_2) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_67 = mux(eq(UInt<2>("h3"), io_waddr), _regs_io_waddr, regs_3) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_68 = mux(eq(UInt<3>("h4"), io_waddr), _regs_io_waddr, regs_4) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_69 = mux(eq(UInt<3>("h5"), io_waddr), _regs_io_waddr, regs_5) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_70 = mux(eq(UInt<3>("h6"), io_waddr), _regs_io_waddr, regs_6) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_71 = mux(eq(UInt<3>("h7"), io_waddr), _regs_io_waddr, regs_7) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_72 = mux(eq(UInt<4>("h8"), io_waddr), _regs_io_waddr, regs_8) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_73 = mux(eq(UInt<4>("h9"), io_waddr), _regs_io_waddr, regs_9) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_74 = mux(eq(UInt<4>("ha"), io_waddr), _regs_io_waddr, regs_10) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_75 = mux(eq(UInt<4>("hb"), io_waddr), _regs_io_waddr, regs_11) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_76 = mux(eq(UInt<4>("hc"), io_waddr), _regs_io_waddr, regs_12) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_77 = mux(eq(UInt<4>("hd"), io_waddr), _regs_io_waddr, regs_13) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_78 = mux(eq(UInt<4>("he"), io_waddr), _regs_io_waddr, regs_14) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_79 = mux(eq(UInt<4>("hf"), io_waddr), _regs_io_waddr, regs_15) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_80 = mux(eq(UInt<5>("h10"), io_waddr), _regs_io_waddr, regs_16) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_81 = mux(eq(UInt<5>("h11"), io_waddr), _regs_io_waddr, regs_17) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_82 = mux(eq(UInt<5>("h12"), io_waddr), _regs_io_waddr, regs_18) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_83 = mux(eq(UInt<5>("h13"), io_waddr), _regs_io_waddr, regs_19) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_84 = mux(eq(UInt<5>("h14"), io_waddr), _regs_io_waddr, regs_20) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_85 = mux(eq(UInt<5>("h15"), io_waddr), _regs_io_waddr, regs_21) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_86 = mux(eq(UInt<5>("h16"), io_waddr), _regs_io_waddr, regs_22) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_87 = mux(eq(UInt<5>("h17"), io_waddr), _regs_io_waddr, regs_23) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_88 = mux(eq(UInt<5>("h18"), io_waddr), _regs_io_waddr, regs_24) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_89 = mux(eq(UInt<5>("h19"), io_waddr), _regs_io_waddr, regs_25) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_90 = mux(eq(UInt<5>("h1a"), io_waddr), _regs_io_waddr, regs_26) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_91 = mux(eq(UInt<5>("h1b"), io_waddr), _regs_io_waddr, regs_27) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_92 = mux(eq(UInt<5>("h1c"), io_waddr), _regs_io_waddr, regs_28) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_93 = mux(eq(UInt<5>("h1d"), io_waddr), _regs_io_waddr, regs_29) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_94 = mux(eq(UInt<5>("h1e"), io_waddr), _regs_io_waddr, regs_30) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _GEN_95 = mux(eq(UInt<5>("h1f"), io_waddr), _regs_io_waddr, regs_31) @[RegisterFile.scala 36:27 RegisterFile.scala 36:27 RegisterFile.scala 30:20]
    node _io_rdata1_T_2 = orr(io_raddr1) @[RegisterFile.scala 37:39]
    node _regs_io_raddr1_0 = _GEN_31 @[RegisterFile.scala 37:26]
    node _io_rdata1_T_3 = mux(_io_rdata1_T_2, _regs_io_raddr1_0, UInt<1>("h0")) @[RegisterFile.scala 37:26]
    node _io_rdata2_T_2 = orr(io_raddr2) @[RegisterFile.scala 39:39]
    node _regs_io_raddr2_0 = _GEN_63 @[RegisterFile.scala 39:26]
    node _io_rdata2_T_3 = mux(_io_rdata2_T_2, _regs_io_raddr2_0, UInt<1>("h0")) @[RegisterFile.scala 39:26]
    node _GEN_96 = mux(_T_1, _GEN_64, regs_0) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_97 = mux(_T_1, _GEN_65, regs_1) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_98 = mux(_T_1, _GEN_66, regs_2) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_99 = mux(_T_1, _GEN_67, regs_3) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_100 = mux(_T_1, _GEN_68, regs_4) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_101 = mux(_T_1, _GEN_69, regs_5) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_102 = mux(_T_1, _GEN_70, regs_6) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_103 = mux(_T_1, _GEN_71, regs_7) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_104 = mux(_T_1, _GEN_72, regs_8) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_105 = mux(_T_1, _GEN_73, regs_9) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_106 = mux(_T_1, _GEN_74, regs_10) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_107 = mux(_T_1, _GEN_75, regs_11) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_108 = mux(_T_1, _GEN_76, regs_12) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_109 = mux(_T_1, _GEN_77, regs_13) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_110 = mux(_T_1, _GEN_78, regs_14) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_111 = mux(_T_1, _GEN_79, regs_15) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_112 = mux(_T_1, _GEN_80, regs_16) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_113 = mux(_T_1, _GEN_81, regs_17) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_114 = mux(_T_1, _GEN_82, regs_18) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_115 = mux(_T_1, _GEN_83, regs_19) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_116 = mux(_T_1, _GEN_84, regs_20) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_117 = mux(_T_1, _GEN_85, regs_21) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_118 = mux(_T_1, _GEN_86, regs_22) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_119 = mux(_T_1, _GEN_87, regs_23) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_120 = mux(_T_1, _GEN_88, regs_24) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_121 = mux(_T_1, _GEN_89, regs_25) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_122 = mux(_T_1, _GEN_90, regs_26) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_123 = mux(_T_1, _GEN_91, regs_27) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_124 = mux(_T_1, _GEN_92, regs_28) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_125 = mux(_T_1, _GEN_93, regs_29) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_126 = mux(_T_1, _GEN_94, regs_30) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_127 = mux(_T_1, _GEN_95, regs_31) @[RegisterFile.scala 35:36 RegisterFile.scala 30:20]
    node _GEN_128 = mux(_T_1, _io_rdata1_T_3, _io_rdata1_T_1) @[RegisterFile.scala 35:36 RegisterFile.scala 37:19 RegisterFile.scala 31:15]
    node _GEN_129 = mux(_T_1, _io_rdata2_T_3, _io_rdata2_T_1) @[RegisterFile.scala 35:36 RegisterFile.scala 39:19 RegisterFile.scala 33:15]
    io_rdata1 <= _GEN_128
    io_rdata2 <= _GEN_129
    regs_0 <= _GEN_96
    regs_1 <= _GEN_97
    regs_2 <= _GEN_98
    regs_3 <= _GEN_99
    regs_4 <= _GEN_100
    regs_5 <= _GEN_101
    regs_6 <= _GEN_102
    regs_7 <= _GEN_103
    regs_8 <= _GEN_104
    regs_9 <= _GEN_105
    regs_10 <= _GEN_106
    regs_11 <= _GEN_107
    regs_12 <= _GEN_108
    regs_13 <= _GEN_109
    regs_14 <= _GEN_110
    regs_15 <= _GEN_111
    regs_16 <= _GEN_112
    regs_17 <= _GEN_113
    regs_18 <= _GEN_114
    regs_19 <= _GEN_115
    regs_20 <= _GEN_116
    regs_21 <= _GEN_117
    regs_22 <= _GEN_118
    regs_23 <= _GEN_119
    regs_24 <= _GEN_120
    regs_25 <= _GEN_121
    regs_26 <= _GEN_122
    regs_27 <= _GEN_123
    regs_28 <= _GEN_124
    regs_29 <= _GEN_125
    regs_30 <= _GEN_126
    regs_31 <= _GEN_127

  module Branch :
    input clock : Clock
    input reset : UInt<1>
    input io_func3 : UInt<3>
    input io_br_ins : UInt<1>
    input io_inpA : UInt<32>
    input io_inpB : UInt<32>
    output io_br_taken : UInt<1>

    node _T = eq(UInt<1>("h0"), io_func3) @[Conditional.scala 37:30]
    node _T_1 = eq(io_inpA, io_inpB) @[Branch.scala 37:30]
    node _GEN_0 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 38:17 Branch.scala 39:33 Branch.scala 30:17]
    node _T_2 = eq(UInt<1>("h1"), io_func3) @[Conditional.scala 37:30]
    node _T_3 = neq(io_inpA, io_inpB) @[Branch.scala 44:30]
    node _GEN_1 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 45:17 Branch.scala 46:33 Branch.scala 30:17]
    node _T_4 = eq(UInt<3>("h4"), io_func3) @[Conditional.scala 37:30]
    node _T_5 = leq(io_inpA, io_inpB) @[Branch.scala 51:30]
    node _GEN_2 = mux(_T_5, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 52:17 Branch.scala 53:33 Branch.scala 30:17]
    node _T_6 = eq(UInt<3>("h5"), io_func3) @[Conditional.scala 37:30]
    node _T_7 = geq(io_inpA, io_inpB) @[Branch.scala 58:30]
    node _GEN_3 = mux(_T_7, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 59:17 Branch.scala 60:33 Branch.scala 30:17]
    node _T_8 = eq(UInt<3>("h6"), io_func3) @[Conditional.scala 37:30]
    node _T_9 = leq(io_inpA, io_inpB) @[Branch.scala 65:40]
    node _GEN_4 = mux(_T_9, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 66:17 Branch.scala 67:33 Branch.scala 30:17]
    node _T_10 = eq(UInt<3>("h7"), io_func3) @[Conditional.scala 37:30]
    node _T_11 = geq(io_inpA, io_inpB) @[Branch.scala 72:40]
    node _GEN_5 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 73:17 Branch.scala 74:33 Branch.scala 30:17]
    node _GEN_6 = mux(_T_10, _GEN_5, UInt<1>("h0")) @[Conditional.scala 39:67 Branch.scala 30:17]
    node _GEN_7 = mux(_T_8, _GEN_4, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_8 = mux(_T_6, _GEN_3, _GEN_7) @[Conditional.scala 39:67]
    node _GEN_9 = mux(_T_4, _GEN_2, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_10 = mux(_T_2, _GEN_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_11 = mux(_T, _GEN_0, _GEN_10) @[Conditional.scala 40:58]
    node _GEN_12 = mux(io_br_ins, _GEN_11, UInt<1>("h0")) @[Branch.scala 32:5 Branch.scala 30:17]
    io_br_taken <= _GEN_12

  module Decode :
    input clock : Clock
    input reset : UInt<1>
    input io_decode_ins : UInt<32>
    input io_decode_dmem_addr2 : UInt<2>
    input io_decode_regfile_wdata : UInt<32>
    input io_decode_pc_out : SInt<32>
    input io_decode_alu_out : UInt<32>
    output io_decode_w_en : UInt<1>
    output io_decode_imem_en : UInt<1>
    output io_decode_pc_en_jump : UInt<1>
    output io_decode_pc_en_jalr : UInt<1>
    output io_decode_pc_br_imm : SInt<32>
    output io_decode_r_en : UInt<1>
    output io_decode_dmem_en : UInt<1>
    output io_decode_immediate : UInt<32>
    output io_decode_func3_7 : UInt<4>
    output io_decode_br_en : UInt<1>
    output io_decode_unbr_en : UInt<1>
    output io_decode_mask_val_0 : UInt<1>
    output io_decode_mask_val_1 : UInt<1>
    output io_decode_mask_val_2 : UInt<1>
    output io_decode_mask_val_3 : UInt<1>
    output io_decode_jalr_en : UInt<1>
    output io_decode_rdata1 : UInt<32>
    output io_decode_rdata2 : UInt<32>
    output io_decode_alu_in_A : UInt<32>
    output io_decode_alu_in_B : UInt<32>
    output io_decode_alu_Op : UInt<4>

    inst cu_module of CU @[Decode.scala 58:33]
    inst register_module of RegisterFile @[Decode.scala 59:33]
    inst branch_module of Branch @[Decode.scala 60:33]
    node _T = bits(cu_module.io_ins, 6, 0) @[Decode.scala 98:26]
    node _T_1 = eq(_T, UInt<6>("h33")) @[Decode.scala 98:32]
    node _T_2 = geq(register_module.io_rdata1, UInt<13>("h1000")) @[Decode.scala 103:40]
    node _T_3 = bits(register_module.io_rdata2, 10, 10) @[Decode.scala 103:78]
    node _T_4 = eq(_T_3, UInt<1>("h1")) @[Decode.scala 103:83]
    node _T_5 = and(_T_2, _T_4) @[Decode.scala 103:50]
    node _T_6 = bits(register_module.io_rdata1, 11, 11) @[Decode.scala 107:45]
    node _T_7 = eq(_T_6, UInt<1>("h1")) @[Decode.scala 107:50]
    node _T_8 = geq(register_module.io_rdata2, UInt<13>("h1000")) @[Decode.scala 107:87]
    node _T_9 = and(_T_7, _T_8) @[Decode.scala 107:58]
    node _io_decode_rdata2_T = add(register_module.io_rdata2, UInt<1>("h1")) @[Decode.scala 110:59]
    node _io_decode_rdata2_T_1 = tail(_io_decode_rdata2_T, 1) @[Decode.scala 110:59]
    node _GEN_0 = mux(_T_9, register_module.io_rdata1, register_module.io_rdata1) @[Decode.scala 108:9 Decode.scala 109:30 Decode.scala 100:26]
    node _GEN_1 = mux(_T_9, _io_decode_rdata2_T_1, register_module.io_rdata2) @[Decode.scala 108:9 Decode.scala 110:30 Decode.scala 101:26]
    node _GEN_2 = mux(_T_5, register_module.io_rdata1, _GEN_0) @[Decode.scala 104:9 Decode.scala 105:30]
    node _GEN_3 = mux(_T_5, register_module.io_rdata2, _GEN_1) @[Decode.scala 104:9 Decode.scala 106:30]
    node _T_10 = bits(cu_module.io_ins, 6, 0) @[Decode.scala 113:32]
    node _T_11 = eq(_T_10, UInt<5>("h13")) @[Decode.scala 113:39]
    node _GEN_4 = mux(_T_11, register_module.io_rdata1, register_module.io_rdata1) @[Decode.scala 114:5 Decode.scala 115:26 Decode.scala 88:22]
    node _GEN_5 = mux(_T_11, cu_module.io_immediate, register_module.io_rdata2) @[Decode.scala 114:5 Decode.scala 116:26 Decode.scala 89:22]
    node _GEN_6 = mux(_T_1, _GEN_2, _GEN_4) @[Decode.scala 99:5]
    node _GEN_7 = mux(_T_1, _GEN_3, _GEN_5) @[Decode.scala 99:5]
    node _T_12 = bits(cu_module.io_ins, 6, 0) @[Decode.scala 132:26]
    node _T_13 = eq(_T_12, UInt<7>("h63")) @[Decode.scala 132:32]
    node _GEN_8 = mux(_T_13, branch_module.io_br_taken, cu_module.io_unbr_en) @[Decode.scala 133:5 Decode.scala 134:33 Decode.scala 129:33]
    node _T_14 = bits(cu_module.io_ins, 6, 0) @[Decode.scala 137:26]
    node _T_15 = eq(_T_14, UInt<6>("h37")) @[Decode.scala 137:32]
    node _T_16 = bits(cu_module.io_ins, 6, 0) @[Decode.scala 141:32]
    node _T_17 = eq(_T_16, UInt<5>("h17")) @[Decode.scala 141:38]
    node _io_decode_alu_in_A_T = asUInt(io_decode_pc_out) @[Decode.scala 143:50]
    node _io_decode_alu_in_A_T_1 = asUInt(io_decode_pc_out) @[Decode.scala 154:50]
    node _io_decode_pc_br_imm_T = asSInt(io_decode_alu_out) @[Decode.scala 157:52]
    node _T_18 = bits(cu_module.io_ins, 6, 0) @[Decode.scala 159:32]
    node _T_19 = eq(_T_18, UInt<7>("h6f")) @[Decode.scala 159:38]
    node _io_decode_alu_in_A_T_2 = asUInt(io_decode_pc_out) @[Decode.scala 161:50]
    node _io_decode_pc_br_imm_T_1 = asSInt(io_decode_alu_out) @[Decode.scala 164:54]
    node _register_module_io_wdata_T = asUInt(io_decode_pc_out) @[Decode.scala 167:56]
    node _register_module_io_wdata_T_1 = add(_register_module_io_wdata_T, UInt<3>("h4")) @[Decode.scala 167:63]
    node _register_module_io_wdata_T_2 = tail(_register_module_io_wdata_T_1, 1) @[Decode.scala 167:63]
    node _T_20 = bits(cu_module.io_ins, 6, 0) @[Decode.scala 168:32]
    node _T_21 = eq(_T_20, UInt<7>("h67")) @[Decode.scala 168:38]
    node _io_decode_pc_br_imm_T_2 = asSInt(io_decode_alu_out) @[Decode.scala 173:52]
    node _GEN_9 = mux(_T_21, UInt<1>("h0"), UInt<1>("h0")) @[Decode.scala 169:5 Decode.scala 178:28 Decode.scala 95:25]
    node _GEN_10 = mux(_T_21, register_module.io_rdata1, UInt<1>("h0")) @[Decode.scala 169:5 Decode.scala 171:28 Decode.scala 93:25]
    node _GEN_11 = mux(_T_21, cu_module.io_immediate, UInt<1>("h0")) @[Decode.scala 169:5 Decode.scala 172:28 Decode.scala 94:25]
    node _GEN_12 = mux(_T_21, _io_decode_pc_br_imm_T_2, asSInt(UInt<1>("h0"))) @[Decode.scala 169:5 Decode.scala 173:29 Decode.scala 71:37]
    node _GEN_13 = mux(_T_21, cu_module.io_jalr_en, UInt<1>("h0")) @[Decode.scala 169:5 Decode.scala 175:30 Decode.scala 70:37]
    node _GEN_14 = mux(_T_21, io_decode_alu_out, io_decode_regfile_wdata) @[Decode.scala 169:5 Decode.scala 180:34 Decode.scala 120:30]
    node _GEN_15 = mux(_T_19, _io_decode_alu_in_A_T_2, _GEN_10) @[Decode.scala 160:5 Decode.scala 161:28]
    node _GEN_16 = mux(_T_19, cu_module.io_immediate, _GEN_11) @[Decode.scala 160:5 Decode.scala 162:28]
    node _GEN_17 = mux(_T_19, UInt<1>("h0"), _GEN_9) @[Decode.scala 160:5 Decode.scala 163:28]
    node _GEN_18 = mux(_T_19, _io_decode_pc_br_imm_T_1, _GEN_12) @[Decode.scala 160:5 Decode.scala 164:31]
    node _GEN_19 = mux(_T_19, _register_module_io_wdata_T_2, _GEN_14) @[Decode.scala 160:5 Decode.scala 167:34]
    node _GEN_20 = mux(_T_19, UInt<1>("h0"), _GEN_13) @[Decode.scala 160:5 Decode.scala 70:37]
    node _GEN_21 = mux(branch_module.io_br_ins, branch_module.io_br_taken, _GEN_8) @[Decode.scala 147:5 Decode.scala 148:30]
    node _GEN_22 = mux(branch_module.io_br_ins, _io_decode_alu_in_A_T_1, _GEN_15) @[Decode.scala 147:5 Decode.scala 154:28]
    node _GEN_23 = mux(branch_module.io_br_ins, cu_module.io_immediate, _GEN_16) @[Decode.scala 147:5 Decode.scala 155:28]
    node _GEN_24 = mux(branch_module.io_br_ins, UInt<1>("h0"), _GEN_17) @[Decode.scala 147:5 Decode.scala 156:28]
    node _GEN_25 = mux(branch_module.io_br_ins, _io_decode_pc_br_imm_T, _GEN_18) @[Decode.scala 147:5 Decode.scala 157:29]
    node _GEN_26 = mux(branch_module.io_br_ins, io_decode_regfile_wdata, _GEN_19) @[Decode.scala 147:5 Decode.scala 120:30]
    node _GEN_27 = mux(branch_module.io_br_ins, UInt<1>("h0"), _GEN_20) @[Decode.scala 147:5 Decode.scala 70:37]
    node _GEN_28 = mux(_T_17, _io_decode_alu_in_A_T, _GEN_22) @[Decode.scala 142:5 Decode.scala 143:28]
    node _GEN_29 = mux(_T_17, cu_module.io_immediate, _GEN_23) @[Decode.scala 142:5 Decode.scala 144:28]
    node _GEN_30 = mux(_T_17, io_decode_alu_out, _GEN_26) @[Decode.scala 142:5 Decode.scala 145:34]
    node _GEN_31 = mux(_T_17, _GEN_8, _GEN_21) @[Decode.scala 142:5]
    node _GEN_32 = mux(_T_17, UInt<1>("h0"), _GEN_24) @[Decode.scala 142:5 Decode.scala 95:25]
    node _GEN_33 = mux(_T_17, asSInt(UInt<1>("h0")), _GEN_25) @[Decode.scala 142:5 Decode.scala 71:37]
    node _GEN_34 = mux(_T_17, UInt<1>("h0"), _GEN_27) @[Decode.scala 142:5 Decode.scala 70:37]
    node _GEN_35 = mux(_T_15, cu_module.io_immediate, _GEN_30) @[Decode.scala 138:5 Decode.scala 140:34]
    node _GEN_36 = mux(_T_15, UInt<1>("h0"), _GEN_28) @[Decode.scala 138:5 Decode.scala 93:25]
    node _GEN_37 = mux(_T_15, UInt<1>("h0"), _GEN_29) @[Decode.scala 138:5 Decode.scala 94:25]
    node _GEN_38 = mux(_T_15, _GEN_8, _GEN_31) @[Decode.scala 138:5]
    node _GEN_39 = mux(_T_15, UInt<1>("h0"), _GEN_32) @[Decode.scala 138:5 Decode.scala 95:25]
    node _GEN_40 = mux(_T_15, asSInt(UInt<1>("h0")), _GEN_33) @[Decode.scala 138:5 Decode.scala 71:37]
    node _GEN_41 = mux(_T_15, UInt<1>("h0"), _GEN_34) @[Decode.scala 138:5 Decode.scala 70:37]
    io_decode_w_en <= cu_module.io_w_en @[Decode.scala 67:37]
    io_decode_imem_en <= cu_module.io_imem_en @[Decode.scala 68:37]
    io_decode_pc_en_jump <= _GEN_38
    io_decode_pc_en_jalr <= _GEN_41
    io_decode_pc_br_imm <= _GEN_40
    io_decode_r_en <= cu_module.io_r_en @[Decode.scala 72:37]
    io_decode_dmem_en <= cu_module.io_dmem_en @[Decode.scala 73:37]
    io_decode_immediate <= cu_module.io_immediate @[Decode.scala 74:37]
    io_decode_func3_7 <= cu_module.io_func3_7 @[Decode.scala 75:37]
    io_decode_br_en <= cu_module.io_br_en @[Decode.scala 76:37]
    io_decode_unbr_en <= cu_module.io_unbr_en @[Decode.scala 77:37]
    io_decode_mask_val_0 <= cu_module.io_mask_val_0 @[Decode.scala 78:37]
    io_decode_mask_val_1 <= cu_module.io_mask_val_1 @[Decode.scala 78:37]
    io_decode_mask_val_2 <= cu_module.io_mask_val_2 @[Decode.scala 78:37]
    io_decode_mask_val_3 <= cu_module.io_mask_val_3 @[Decode.scala 78:37]
    io_decode_jalr_en <= cu_module.io_jalr_en @[Decode.scala 79:37]
    io_decode_rdata1 <= _GEN_6
    io_decode_rdata2 <= _GEN_7
    io_decode_alu_in_A <= _GEN_36
    io_decode_alu_in_B <= _GEN_37
    io_decode_alu_Op <= _GEN_39
    cu_module.clock <= clock
    cu_module.reset <= reset
    cu_module.io_ins <= io_decode_ins @[Decode.scala 63:29]
    cu_module.io_dmem_addr2 <= io_decode_dmem_addr2 @[Decode.scala 64:29]
    register_module.clock <= clock
    register_module.reset <= reset
    register_module.io_raddr1 <= cu_module.io_rs1 @[Decode.scala 81:31]
    register_module.io_raddr2 <= cu_module.io_rs2 @[Decode.scala 82:31]
    register_module.io_wen <= cu_module.io_w_en @[Decode.scala 91:30]
    register_module.io_waddr <= cu_module.io_rd @[Decode.scala 83:31]
    register_module.io_wdata <= _GEN_35
    branch_module.clock <= clock
    branch_module.reset <= reset
    branch_module.io_func3 <= bits(cu_module.io_func3_7, 2, 0) @[Decode.scala 123:33]
    branch_module.io_br_ins <= cu_module.io_br_en @[Decode.scala 124:33]
    branch_module.io_inpA <= register_module.io_rdata1 @[Decode.scala 125:33]
    branch_module.io_inpB <= register_module.io_rdata2 @[Decode.scala 126:33]

  module ALU :
    input clock : Clock
    input reset : UInt<1>
    input io_in_A : UInt<32>
    input io_in_B : UInt<32>
    input io_alu_Op : UInt<4>
    output io_out : UInt<32>
    output io_sum : UInt<32>

    node _sum_T = bits(io_alu_Op, 3, 3) @[ALU.scala 47:42]
    node _sum_T_1 = sub(UInt<1>("h0"), io_in_B) @[ALU.scala 47:49]
    node _sum_T_2 = tail(_sum_T_1, 1) @[ALU.scala 47:49]
    node _sum_T_3 = mux(_sum_T, _sum_T_2, io_in_B) @[ALU.scala 47:30]
    node _sum_T_4 = add(io_in_A, _sum_T_3) @[ALU.scala 47:25]
    node sum = tail(_sum_T_4, 1) @[ALU.scala 47:25]
    node _cmp_T = bits(io_in_A, 31, 31) @[ALU.scala 49:28]
    node _cmp_T_1 = bits(io_in_B, 31, 31) @[ALU.scala 49:51]
    node _cmp_T_2 = eq(_cmp_T, _cmp_T_1) @[ALU.scala 49:39]
    node _cmp_T_3 = bits(sum, 31, 31) @[ALU.scala 49:68]
    node _cmp_T_4 = bits(io_alu_Op, 1, 1) @[ALU.scala 50:22]
    node _cmp_T_5 = bits(io_in_B, 31, 31) @[ALU.scala 50:36]
    node _cmp_T_6 = bits(io_in_A, 31, 31) @[ALU.scala 50:59]
    node _cmp_T_7 = mux(_cmp_T_4, _cmp_T_5, _cmp_T_6) @[ALU.scala 50:8]
    node cmp = mux(_cmp_T_2, _cmp_T_3, _cmp_T_7) @[ALU.scala 49:18]
    node shamt = bits(io_in_B, 4, 0) @[ALU.scala 52:25]
    node _shin_T = bits(io_alu_Op, 3, 3) @[ALU.scala 55:33]
    node _shin_T_1 = eq(io_alu_Op, UInt<3>("h5")) @[ALU.scala 55:50]
    node _shin_T_2 = or(_shin_T, _shin_T_1) @[ALU.scala 55:37]
    node _shin_T_3 = shl(UInt<16>("hffff"), 16) @[Bitwise.scala 102:47]
    node _shin_T_4 = xor(UInt<32>("hffffffff"), _shin_T_3) @[Bitwise.scala 102:21]
    node _shin_T_5 = shr(io_in_A, 16) @[Bitwise.scala 103:21]
    node _shin_T_6 = and(_shin_T_5, _shin_T_4) @[Bitwise.scala 103:31]
    node _shin_T_7 = bits(io_in_A, 15, 0) @[Bitwise.scala 103:46]
    node _shin_T_8 = shl(_shin_T_7, 16) @[Bitwise.scala 103:65]
    node _shin_T_9 = not(_shin_T_4) @[Bitwise.scala 103:77]
    node _shin_T_10 = and(_shin_T_8, _shin_T_9) @[Bitwise.scala 103:75]
    node _shin_T_11 = or(_shin_T_6, _shin_T_10) @[Bitwise.scala 103:39]
    node _shin_T_12 = bits(_shin_T_4, 23, 0) @[Bitwise.scala 102:28]
    node _shin_T_13 = shl(_shin_T_12, 8) @[Bitwise.scala 102:47]
    node _shin_T_14 = xor(_shin_T_4, _shin_T_13) @[Bitwise.scala 102:21]
    node _shin_T_15 = shr(_shin_T_11, 8) @[Bitwise.scala 103:21]
    node _shin_T_16 = and(_shin_T_15, _shin_T_14) @[Bitwise.scala 103:31]
    node _shin_T_17 = bits(_shin_T_11, 23, 0) @[Bitwise.scala 103:46]
    node _shin_T_18 = shl(_shin_T_17, 8) @[Bitwise.scala 103:65]
    node _shin_T_19 = not(_shin_T_14) @[Bitwise.scala 103:77]
    node _shin_T_20 = and(_shin_T_18, _shin_T_19) @[Bitwise.scala 103:75]
    node _shin_T_21 = or(_shin_T_16, _shin_T_20) @[Bitwise.scala 103:39]
    node _shin_T_22 = bits(_shin_T_14, 27, 0) @[Bitwise.scala 102:28]
    node _shin_T_23 = shl(_shin_T_22, 4) @[Bitwise.scala 102:47]
    node _shin_T_24 = xor(_shin_T_14, _shin_T_23) @[Bitwise.scala 102:21]
    node _shin_T_25 = shr(_shin_T_21, 4) @[Bitwise.scala 103:21]
    node _shin_T_26 = and(_shin_T_25, _shin_T_24) @[Bitwise.scala 103:31]
    node _shin_T_27 = bits(_shin_T_21, 27, 0) @[Bitwise.scala 103:46]
    node _shin_T_28 = shl(_shin_T_27, 4) @[Bitwise.scala 103:65]
    node _shin_T_29 = not(_shin_T_24) @[Bitwise.scala 103:77]
    node _shin_T_30 = and(_shin_T_28, _shin_T_29) @[Bitwise.scala 103:75]
    node _shin_T_31 = or(_shin_T_26, _shin_T_30) @[Bitwise.scala 103:39]
    node _shin_T_32 = bits(_shin_T_24, 29, 0) @[Bitwise.scala 102:28]
    node _shin_T_33 = shl(_shin_T_32, 2) @[Bitwise.scala 102:47]
    node _shin_T_34 = xor(_shin_T_24, _shin_T_33) @[Bitwise.scala 102:21]
    node _shin_T_35 = shr(_shin_T_31, 2) @[Bitwise.scala 103:21]
    node _shin_T_36 = and(_shin_T_35, _shin_T_34) @[Bitwise.scala 103:31]
    node _shin_T_37 = bits(_shin_T_31, 29, 0) @[Bitwise.scala 103:46]
    node _shin_T_38 = shl(_shin_T_37, 2) @[Bitwise.scala 103:65]
    node _shin_T_39 = not(_shin_T_34) @[Bitwise.scala 103:77]
    node _shin_T_40 = and(_shin_T_38, _shin_T_39) @[Bitwise.scala 103:75]
    node _shin_T_41 = or(_shin_T_36, _shin_T_40) @[Bitwise.scala 103:39]
    node _shin_T_42 = bits(_shin_T_34, 30, 0) @[Bitwise.scala 102:28]
    node _shin_T_43 = shl(_shin_T_42, 1) @[Bitwise.scala 102:47]
    node _shin_T_44 = xor(_shin_T_34, _shin_T_43) @[Bitwise.scala 102:21]
    node _shin_T_45 = shr(_shin_T_41, 1) @[Bitwise.scala 103:21]
    node _shin_T_46 = and(_shin_T_45, _shin_T_44) @[Bitwise.scala 103:31]
    node _shin_T_47 = bits(_shin_T_41, 30, 0) @[Bitwise.scala 103:46]
    node _shin_T_48 = shl(_shin_T_47, 1) @[Bitwise.scala 103:65]
    node _shin_T_49 = not(_shin_T_44) @[Bitwise.scala 103:77]
    node _shin_T_50 = and(_shin_T_48, _shin_T_49) @[Bitwise.scala 103:75]
    node _shin_T_51 = or(_shin_T_46, _shin_T_50) @[Bitwise.scala 103:39]
    node shin = mux(_shin_T_2, io_in_A, _shin_T_51) @[ALU.scala 55:19]
    node _shiftr_T = bits(io_alu_Op, 0, 0) @[ALU.scala 57:36]
    node _shiftr_T_1 = bits(shin, 31, 31) @[ALU.scala 57:48]
    node shiftr_hi = and(_shiftr_T, _shiftr_T_1) @[ALU.scala 57:40]
    node _shiftr_T_2 = cat(shiftr_hi, shin) @[Cat.scala 30:58]
    node _shiftr_T_3 = asSInt(_shiftr_T_2) @[ALU.scala 57:69]
    node _shiftr_T_4 = dshr(_shiftr_T_3, shamt) @[ALU.scala 57:76]
    node shiftr = bits(_shiftr_T_4, 31, 0) @[ALU.scala 57:87]
    node _shiftl_T = shl(UInt<16>("hffff"), 16) @[Bitwise.scala 102:47]
    node _shiftl_T_1 = xor(UInt<32>("hffffffff"), _shiftl_T) @[Bitwise.scala 102:21]
    node _shiftl_T_2 = shr(shiftr, 16) @[Bitwise.scala 103:21]
    node _shiftl_T_3 = and(_shiftl_T_2, _shiftl_T_1) @[Bitwise.scala 103:31]
    node _shiftl_T_4 = bits(shiftr, 15, 0) @[Bitwise.scala 103:46]
    node _shiftl_T_5 = shl(_shiftl_T_4, 16) @[Bitwise.scala 103:65]
    node _shiftl_T_6 = not(_shiftl_T_1) @[Bitwise.scala 103:77]
    node _shiftl_T_7 = and(_shiftl_T_5, _shiftl_T_6) @[Bitwise.scala 103:75]
    node _shiftl_T_8 = or(_shiftl_T_3, _shiftl_T_7) @[Bitwise.scala 103:39]
    node _shiftl_T_9 = bits(_shiftl_T_1, 23, 0) @[Bitwise.scala 102:28]
    node _shiftl_T_10 = shl(_shiftl_T_9, 8) @[Bitwise.scala 102:47]
    node _shiftl_T_11 = xor(_shiftl_T_1, _shiftl_T_10) @[Bitwise.scala 102:21]
    node _shiftl_T_12 = shr(_shiftl_T_8, 8) @[Bitwise.scala 103:21]
    node _shiftl_T_13 = and(_shiftl_T_12, _shiftl_T_11) @[Bitwise.scala 103:31]
    node _shiftl_T_14 = bits(_shiftl_T_8, 23, 0) @[Bitwise.scala 103:46]
    node _shiftl_T_15 = shl(_shiftl_T_14, 8) @[Bitwise.scala 103:65]
    node _shiftl_T_16 = not(_shiftl_T_11) @[Bitwise.scala 103:77]
    node _shiftl_T_17 = and(_shiftl_T_15, _shiftl_T_16) @[Bitwise.scala 103:75]
    node _shiftl_T_18 = or(_shiftl_T_13, _shiftl_T_17) @[Bitwise.scala 103:39]
    node _shiftl_T_19 = bits(_shiftl_T_11, 27, 0) @[Bitwise.scala 102:28]
    node _shiftl_T_20 = shl(_shiftl_T_19, 4) @[Bitwise.scala 102:47]
    node _shiftl_T_21 = xor(_shiftl_T_11, _shiftl_T_20) @[Bitwise.scala 102:21]
    node _shiftl_T_22 = shr(_shiftl_T_18, 4) @[Bitwise.scala 103:21]
    node _shiftl_T_23 = and(_shiftl_T_22, _shiftl_T_21) @[Bitwise.scala 103:31]
    node _shiftl_T_24 = bits(_shiftl_T_18, 27, 0) @[Bitwise.scala 103:46]
    node _shiftl_T_25 = shl(_shiftl_T_24, 4) @[Bitwise.scala 103:65]
    node _shiftl_T_26 = not(_shiftl_T_21) @[Bitwise.scala 103:77]
    node _shiftl_T_27 = and(_shiftl_T_25, _shiftl_T_26) @[Bitwise.scala 103:75]
    node _shiftl_T_28 = or(_shiftl_T_23, _shiftl_T_27) @[Bitwise.scala 103:39]
    node _shiftl_T_29 = bits(_shiftl_T_21, 29, 0) @[Bitwise.scala 102:28]
    node _shiftl_T_30 = shl(_shiftl_T_29, 2) @[Bitwise.scala 102:47]
    node _shiftl_T_31 = xor(_shiftl_T_21, _shiftl_T_30) @[Bitwise.scala 102:21]
    node _shiftl_T_32 = shr(_shiftl_T_28, 2) @[Bitwise.scala 103:21]
    node _shiftl_T_33 = and(_shiftl_T_32, _shiftl_T_31) @[Bitwise.scala 103:31]
    node _shiftl_T_34 = bits(_shiftl_T_28, 29, 0) @[Bitwise.scala 103:46]
    node _shiftl_T_35 = shl(_shiftl_T_34, 2) @[Bitwise.scala 103:65]
    node _shiftl_T_36 = not(_shiftl_T_31) @[Bitwise.scala 103:77]
    node _shiftl_T_37 = and(_shiftl_T_35, _shiftl_T_36) @[Bitwise.scala 103:75]
    node _shiftl_T_38 = or(_shiftl_T_33, _shiftl_T_37) @[Bitwise.scala 103:39]
    node _shiftl_T_39 = bits(_shiftl_T_31, 30, 0) @[Bitwise.scala 102:28]
    node _shiftl_T_40 = shl(_shiftl_T_39, 1) @[Bitwise.scala 102:47]
    node _shiftl_T_41 = xor(_shiftl_T_31, _shiftl_T_40) @[Bitwise.scala 102:21]
    node _shiftl_T_42 = shr(_shiftl_T_38, 1) @[Bitwise.scala 103:21]
    node _shiftl_T_43 = and(_shiftl_T_42, _shiftl_T_41) @[Bitwise.scala 103:31]
    node _shiftl_T_44 = bits(_shiftl_T_38, 30, 0) @[Bitwise.scala 103:46]
    node _shiftl_T_45 = shl(_shiftl_T_44, 1) @[Bitwise.scala 103:65]
    node _shiftl_T_46 = not(_shiftl_T_41) @[Bitwise.scala 103:77]
    node _shiftl_T_47 = and(_shiftl_T_45, _shiftl_T_46) @[Bitwise.scala 103:75]
    node shiftl = or(_shiftl_T_43, _shiftl_T_47) @[Bitwise.scala 103:39]
    node _T = eq(UInt<4>("h0"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_1 = eq(UInt<4>("h8"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_2 = eq(UInt<4>("h2"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_3 = eq(UInt<4>("h3"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_4 = eq(UInt<4>("hd"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_5 = eq(UInt<4>("h5"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_6 = eq(UInt<4>("h1"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_7 = eq(UInt<4>("h7"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T = and(io_in_A, io_in_B) @[ALU.scala 104:32]
    node _T_8 = eq(UInt<4>("h6"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T_1 = or(io_in_A, io_in_B) @[ALU.scala 109:32]
    node _T_9 = eq(UInt<4>("h4"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T_2 = xor(io_in_A, io_in_B) @[ALU.scala 114:32]
    node _T_10 = eq(UInt<4>("ha"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_11 = eq(UInt<4>("hb"), io_alu_Op) @[Conditional.scala 37:30]
    node _GEN_0 = mux(_T_11, io_in_B, UInt<1>("h0")) @[Conditional.scala 39:67 ALU.scala 124:20 ALU.scala 63:12]
    node _GEN_1 = mux(_T_10, io_in_A, _GEN_0) @[Conditional.scala 39:67 ALU.scala 119:20]
    node _GEN_2 = mux(_T_9, _io_out_T_2, _GEN_1) @[Conditional.scala 39:67 ALU.scala 114:20]
    node _GEN_3 = mux(_T_8, _io_out_T_1, _GEN_2) @[Conditional.scala 39:67 ALU.scala 109:20]
    node _GEN_4 = mux(_T_7, _io_out_T, _GEN_3) @[Conditional.scala 39:67 ALU.scala 104:20]
    node _GEN_5 = mux(_T_6, shiftl, _GEN_4) @[Conditional.scala 39:67 ALU.scala 99:20]
    node _GEN_6 = mux(_T_5, shiftr, _GEN_5) @[Conditional.scala 39:67 ALU.scala 94:20]
    node _GEN_7 = mux(_T_4, shiftr, _GEN_6) @[Conditional.scala 39:67 ALU.scala 89:20]
    node _GEN_8 = mux(_T_3, cmp, _GEN_7) @[Conditional.scala 39:67 ALU.scala 84:20]
    node _GEN_9 = mux(_T_2, cmp, _GEN_8) @[Conditional.scala 39:67 ALU.scala 79:20]
    node _GEN_10 = mux(_T_1, sum, _GEN_9) @[Conditional.scala 39:67 ALU.scala 74:20]
    node _GEN_11 = mux(_T, sum, _GEN_10) @[Conditional.scala 40:58 ALU.scala 69:20]
    io_out <= _GEN_11
    io_sum <= UInt<1>("h0") @[ALU.scala 64:12]

  module Execute :
    input clock : Clock
    input reset : UInt<1>
    input io_execute_in_A : UInt<32>
    input io_execute_in_B : UInt<32>
    input io_execute_alu_Op : UInt<4>
    output io_execute_out : UInt<32>

    inst alu_module of ALU @[Execute.scala 15:28]
    io_execute_out <= alu_module.io_out @[Execute.scala 27:25]
    alu_module.clock <= clock
    alu_module.reset <= reset
    alu_module.io_in_A <= io_execute_in_A @[Execute.scala 24:25]
    alu_module.io_in_B <= io_execute_in_B @[Execute.scala 25:25]
    alu_module.io_alu_Op <= io_execute_alu_Op @[Execute.scala 18:26]

  module DMEM :
    input clock : Clock
    input reset : UInt<1>
    input io_addr : UInt<10>
    input io_rd_enable : UInt<1>
    input io_wr_enable : UInt<1>
    input io_mask_0 : UInt<1>
    input io_mask_1 : UInt<1>
    input io_mask_2 : UInt<1>
    input io_mask_3 : UInt<1>
    input io_dataIn_0 : UInt<8>
    input io_dataIn_1 : UInt<8>
    input io_dataIn_2 : UInt<8>
    input io_dataIn_3 : UInt<8>
    output io_dataOut_0 : UInt<8>
    output io_dataOut_1 : UInt<8>
    output io_dataOut_2 : UInt<8>
    output io_dataOut_3 : UInt<8>

    mem Sync_memory_0 : @[DMEM.scala 21:26]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    mem Sync_memory_1 : @[DMEM.scala 21:26]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    mem Sync_memory_2 : @[DMEM.scala 21:26]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    mem Sync_memory_3 : @[DMEM.scala 21:26]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(io_wr_enable, io_addr) @[DMEM.scala 24:27]
    node _GEN_1 = validif(io_wr_enable, clock) @[DMEM.scala 24:27]
    node _GEN_2 = mux(io_wr_enable, UInt<1>("h1"), UInt<1>("h0")) @[DMEM.scala 24:27 DMEM.scala 21:26]
    node _GEN_3 = validif(io_wr_enable, UInt<1>("h1")) @[DMEM.scala 24:27]
    node _GEN_4 = validif(io_wr_enable, io_dataIn_0) @[DMEM.scala 24:27]
    node _GEN_5 = validif(io_wr_enable, io_dataIn_1) @[DMEM.scala 24:27]
    node _GEN_6 = validif(io_wr_enable, io_dataIn_2) @[DMEM.scala 24:27]
    node _GEN_7 = validif(io_wr_enable, io_dataIn_3) @[DMEM.scala 24:27]
    io_dataOut_0 <= Sync_memory_0.MPORT_1.data @[DMEM.scala 29:18]
    io_dataOut_1 <= Sync_memory_1.MPORT_1.data @[DMEM.scala 29:18]
    io_dataOut_2 <= Sync_memory_2.MPORT_1.data @[DMEM.scala 29:18]
    io_dataOut_3 <= Sync_memory_3.MPORT_1.data @[DMEM.scala 29:18]
    Sync_memory_0.MPORT_1.addr <= io_addr @[DMEM.scala 29:37]
    Sync_memory_1.MPORT_1.addr <= io_addr @[DMEM.scala 29:37]
    Sync_memory_2.MPORT_1.addr <= io_addr @[DMEM.scala 29:37]
    Sync_memory_3.MPORT_1.addr <= io_addr @[DMEM.scala 29:37]
    Sync_memory_0.MPORT_1.en <= UInt<1>("h1") @[DMEM.scala 29:37]
    Sync_memory_1.MPORT_1.en <= UInt<1>("h1") @[DMEM.scala 29:37]
    Sync_memory_2.MPORT_1.en <= UInt<1>("h1") @[DMEM.scala 29:37]
    Sync_memory_3.MPORT_1.en <= UInt<1>("h1") @[DMEM.scala 29:37]
    Sync_memory_0.MPORT_1.clk <= clock @[DMEM.scala 29:37]
    Sync_memory_1.MPORT_1.clk <= clock @[DMEM.scala 29:37]
    Sync_memory_2.MPORT_1.clk <= clock @[DMEM.scala 29:37]
    Sync_memory_3.MPORT_1.clk <= clock @[DMEM.scala 29:37]
    Sync_memory_0.MPORT.addr <= _GEN_0
    Sync_memory_1.MPORT.addr <= _GEN_0
    Sync_memory_2.MPORT.addr <= _GEN_0
    Sync_memory_3.MPORT.addr <= _GEN_0
    Sync_memory_0.MPORT.en <= _GEN_2
    Sync_memory_1.MPORT.en <= _GEN_2
    Sync_memory_2.MPORT.en <= _GEN_2
    Sync_memory_3.MPORT.en <= _GEN_2
    Sync_memory_0.MPORT.clk <= _GEN_1
    Sync_memory_1.MPORT.clk <= _GEN_1
    Sync_memory_2.MPORT.clk <= _GEN_1
    Sync_memory_3.MPORT.clk <= _GEN_1
    Sync_memory_0.MPORT.data <= _GEN_4
    Sync_memory_1.MPORT.data <= _GEN_5
    Sync_memory_2.MPORT.data <= _GEN_6
    Sync_memory_3.MPORT.data <= _GEN_7
    Sync_memory_0.MPORT.mask <= _GEN_3
    Sync_memory_1.MPORT.mask <= _GEN_3
    Sync_memory_2.MPORT.mask <= _GEN_3
    Sync_memory_3.MPORT.mask <= _GEN_3

  module Memory :
    input clock : Clock
    input reset : UInt<1>
    input io_mem_mask_addr2 : UInt<2>
    input io_mem_opcode : UInt<7>
    input io_mem_datainput_0 : UInt<8>
    input io_mem_datainput_1 : UInt<8>
    input io_mem_datainput_2 : UInt<8>
    input io_mem_datainput_3 : UInt<8>
    input io_mem_rdata1 : UInt<32>
    input io_mem_rd_enable : UInt<1>
    input io_mem_dmem_enable : UInt<1>
    input io_mem_mask_val_0 : UInt<1>
    input io_mem_mask_val_1 : UInt<1>
    input io_mem_mask_val_2 : UInt<1>
    input io_mem_mask_val_3 : UInt<1>
    input io_mem_func3_7 : UInt<4>
    input io_mem_alu_out : UInt<32>
    output io_mem_alu_in_B : UInt<32>
    output io_mem_alu_Op : UInt<4>
    output io_mem_dataOut : UInt<32>

    inst dmem_module of DMEM @[Memory.scala 31:29]
    node _T = eq(io_mem_opcode, UInt<6>("h23")) @[Memory.scala 63:24]
    node temp_addr = bits(io_mem_alu_out, 11, 2) @[Memory.scala 69:39]
    node _dmem_module_io_addr_T = bits(io_mem_alu_out, 11, 2) @[Memory.scala 73:46]
    node _T_1 = eq(io_mem_func3_7, UInt<1>("h0")) @[Memory.scala 79:29]
    node _T_2 = eq(io_mem_func3_7, UInt<1>("h1")) @[Memory.scala 113:35]
    node _T_3 = eq(io_mem_mask_addr2, UInt<1>("h0")) @[Memory.scala 115:36]
    node _T_4 = eq(io_mem_mask_addr2, UInt<1>("h1")) @[Memory.scala 124:42]
    node _T_5 = eq(io_mem_mask_addr2, UInt<2>("h2")) @[Memory.scala 131:42]
    node _T_6 = eq(io_mem_mask_addr2, UInt<2>("h3")) @[Memory.scala 139:42]
    node _dmem_module_io_addr_T_1 = add(temp_addr, UInt<1>("h1")) @[Memory.scala 144:50]
    node _dmem_module_io_addr_T_2 = tail(_dmem_module_io_addr_T_1, 1) @[Memory.scala 144:50]
    node _GEN_0 = mux(_T_6, io_mem_datainput_3, UInt<1>("h0")) @[Memory.scala 140:13 Memory.scala 143:42 Memory.scala 44:30]
    node _GEN_1 = mux(_T_6, _dmem_module_io_addr_T_2, _dmem_module_io_addr_T) @[Memory.scala 140:13 Memory.scala 144:37 Memory.scala 73:29]
    node _GEN_2 = mux(_T_6, io_mem_datainput_0, UInt<1>("h0")) @[Memory.scala 140:13 Memory.scala 145:42 Memory.scala 41:30]
    node _GEN_3 = mux(_T_5, io_mem_datainput_2, UInt<1>("h0")) @[Memory.scala 132:13 Memory.scala 135:42 Memory.scala 43:30]
    node _GEN_4 = mux(_T_5, io_mem_datainput_3, _GEN_0) @[Memory.scala 132:13 Memory.scala 136:42]
    node _GEN_5 = mux(_T_5, _dmem_module_io_addr_T, _GEN_1) @[Memory.scala 132:13 Memory.scala 73:29]
    node _GEN_6 = mux(_T_5, UInt<1>("h0"), _GEN_2) @[Memory.scala 132:13 Memory.scala 41:30]
    node _GEN_7 = mux(_T_4, io_mem_datainput_1, UInt<1>("h0")) @[Memory.scala 125:13 Memory.scala 128:42 Memory.scala 42:30]
    node _GEN_8 = mux(_T_4, io_mem_datainput_2, _GEN_3) @[Memory.scala 125:13 Memory.scala 129:42]
    node _GEN_9 = mux(_T_4, UInt<1>("h0"), _GEN_4) @[Memory.scala 125:13 Memory.scala 44:30]
    node _GEN_10 = mux(_T_4, _dmem_module_io_addr_T, _GEN_5) @[Memory.scala 125:13 Memory.scala 73:29]
    node _GEN_11 = mux(_T_4, UInt<1>("h0"), _GEN_6) @[Memory.scala 125:13 Memory.scala 41:30]
    node _GEN_12 = mux(_T_3, io_mem_datainput_0, _GEN_11) @[Memory.scala 116:13 Memory.scala 119:42]
    node _GEN_13 = mux(_T_3, io_mem_datainput_1, _GEN_7) @[Memory.scala 116:13 Memory.scala 120:42]
    node _GEN_14 = mux(_T_3, UInt<1>("h0"), _GEN_8) @[Memory.scala 116:13 Memory.scala 43:30]
    node _GEN_15 = mux(_T_3, UInt<1>("h0"), _GEN_9) @[Memory.scala 116:13 Memory.scala 44:30]
    node _GEN_16 = mux(_T_3, _dmem_module_io_addr_T, _GEN_10) @[Memory.scala 116:13 Memory.scala 73:29]
    node _T_7 = eq(io_mem_func3_7, UInt<2>("h2")) @[Memory.scala 153:35]
    node _T_8 = eq(io_mem_mask_addr2, UInt<1>("h0")) @[Memory.scala 155:36]
    node _T_9 = eq(io_mem_mask_addr2, UInt<1>("h1")) @[Memory.scala 166:42]
    node _dmem_module_io_addr_T_3 = add(temp_addr, UInt<1>("h1")) @[Memory.scala 172:50]
    node _dmem_module_io_addr_T_4 = tail(_dmem_module_io_addr_T_3, 1) @[Memory.scala 172:50]
    node _T_10 = eq(io_mem_mask_addr2, UInt<2>("h2")) @[Memory.scala 179:42]
    node _dmem_module_io_addr_T_5 = add(temp_addr, UInt<1>("h1")) @[Memory.scala 184:50]
    node _dmem_module_io_addr_T_6 = tail(_dmem_module_io_addr_T_5, 1) @[Memory.scala 184:50]
    node _T_11 = eq(io_mem_mask_addr2, UInt<2>("h3")) @[Memory.scala 192:42]
    node _dmem_module_io_addr_T_7 = add(temp_addr, UInt<1>("h1")) @[Memory.scala 196:50]
    node _dmem_module_io_addr_T_8 = tail(_dmem_module_io_addr_T_7, 1) @[Memory.scala 196:50]
    node _GEN_17 = mux(_T_11, io_mem_datainput_3, UInt<1>("h0")) @[Memory.scala 192:50 Memory.scala 195:42 Memory.scala 44:30]
    node _GEN_18 = mux(_T_11, _dmem_module_io_addr_T_8, _dmem_module_io_addr_T) @[Memory.scala 192:50 Memory.scala 196:37 Memory.scala 73:29]
    node _GEN_19 = mux(_T_11, io_mem_datainput_0, UInt<1>("h0")) @[Memory.scala 192:50 Memory.scala 197:42 Memory.scala 41:30]
    node _GEN_20 = mux(_T_11, io_mem_datainput_1, UInt<1>("h0")) @[Memory.scala 192:50 Memory.scala 198:42 Memory.scala 42:30]
    node _GEN_21 = mux(_T_11, io_mem_datainput_2, UInt<1>("h0")) @[Memory.scala 192:50 Memory.scala 199:42 Memory.scala 43:30]
    node _GEN_22 = mux(_T_10, io_mem_datainput_2, _GEN_21) @[Memory.scala 179:50 Memory.scala 182:42]
    node _GEN_23 = mux(_T_10, io_mem_datainput_3, _GEN_17) @[Memory.scala 179:50 Memory.scala 183:42]
    node _GEN_24 = mux(_T_10, _dmem_module_io_addr_T_6, _GEN_18) @[Memory.scala 179:50 Memory.scala 184:37]
    node _GEN_25 = mux(_T_10, io_mem_datainput_0, _GEN_19) @[Memory.scala 179:50 Memory.scala 185:42]
    node _GEN_26 = mux(_T_10, io_mem_datainput_1, _GEN_20) @[Memory.scala 179:50 Memory.scala 186:42]
    node _GEN_27 = mux(_T_9, io_mem_datainput_1, _GEN_26) @[Memory.scala 166:50 Memory.scala 169:42]
    node _GEN_28 = mux(_T_9, io_mem_datainput_2, _GEN_22) @[Memory.scala 166:50 Memory.scala 170:42]
    node _GEN_29 = mux(_T_9, io_mem_datainput_3, _GEN_23) @[Memory.scala 166:50 Memory.scala 171:42]
    node _GEN_30 = mux(_T_9, _dmem_module_io_addr_T_4, _GEN_24) @[Memory.scala 166:50 Memory.scala 172:37]
    node _GEN_31 = mux(_T_9, io_mem_datainput_0, _GEN_25) @[Memory.scala 166:50 Memory.scala 173:42]
    node _GEN_32 = mux(_T_8, io_mem_datainput_0, _GEN_31) @[Memory.scala 156:13 Memory.scala 159:42]
    node _GEN_33 = mux(_T_8, io_mem_datainput_1, _GEN_27) @[Memory.scala 156:13 Memory.scala 160:42]
    node _GEN_34 = mux(_T_8, io_mem_datainput_2, _GEN_28) @[Memory.scala 156:13 Memory.scala 161:42]
    node _GEN_35 = mux(_T_8, io_mem_datainput_3, _GEN_29) @[Memory.scala 156:13 Memory.scala 162:42]
    node _GEN_36 = mux(_T_8, _dmem_module_io_addr_T, _GEN_30) @[Memory.scala 156:13 Memory.scala 73:29]
    node _GEN_37 = mux(_T_7, _GEN_32, UInt<1>("h0")) @[Memory.scala 154:9 Memory.scala 41:30]
    node _GEN_38 = mux(_T_7, _GEN_33, UInt<1>("h0")) @[Memory.scala 154:9 Memory.scala 42:30]
    node _GEN_39 = mux(_T_7, _GEN_34, UInt<1>("h0")) @[Memory.scala 154:9 Memory.scala 43:30]
    node _GEN_40 = mux(_T_7, _GEN_35, UInt<1>("h0")) @[Memory.scala 154:9 Memory.scala 44:30]
    node _GEN_41 = mux(_T_7, _GEN_36, _dmem_module_io_addr_T) @[Memory.scala 154:9 Memory.scala 73:29]
    node _GEN_42 = mux(_T_2, _GEN_12, _GEN_37) @[Memory.scala 114:9]
    node _GEN_43 = mux(_T_2, _GEN_13, _GEN_38) @[Memory.scala 114:9]
    node _GEN_44 = mux(_T_2, _GEN_14, _GEN_39) @[Memory.scala 114:9]
    node _GEN_45 = mux(_T_2, _GEN_15, _GEN_40) @[Memory.scala 114:9]
    node _GEN_46 = mux(_T_2, _GEN_16, _GEN_41) @[Memory.scala 114:9]
    node _GEN_47 = mux(_T_1, io_mem_datainput_0, _GEN_42) @[Memory.scala 80:9 Memory.scala 106:38]
    node _GEN_48 = mux(_T_1, io_mem_datainput_0, _GEN_43) @[Memory.scala 80:9 Memory.scala 107:38]
    node _GEN_49 = mux(_T_1, io_mem_datainput_0, _GEN_44) @[Memory.scala 80:9 Memory.scala 108:38]
    node _GEN_50 = mux(_T_1, io_mem_datainput_0, _GEN_45) @[Memory.scala 80:9 Memory.scala 109:38]
    node _GEN_51 = mux(_T_1, _dmem_module_io_addr_T, _GEN_46) @[Memory.scala 80:9 Memory.scala 73:29]
    node _GEN_52 = mux(_T, UInt<1>("h0"), UInt<1>("h0")) @[Memory.scala 64:5 Memory.scala 65:23 Memory.scala 56:25]
    node _GEN_53 = mux(_T, io_mem_rdata1, UInt<1>("h0")) @[Memory.scala 64:5 Memory.scala 67:25 Memory.scala 58:25]
    node _GEN_54 = mux(_T, _GEN_51, UInt<1>("h0")) @[Memory.scala 64:5 Memory.scala 59:25]
    node _GEN_55 = mux(_T, _GEN_47, UInt<1>("h0")) @[Memory.scala 64:5 Memory.scala 41:30]
    node _GEN_56 = mux(_T, _GEN_48, UInt<1>("h0")) @[Memory.scala 64:5 Memory.scala 42:30]
    node _GEN_57 = mux(_T, _GEN_49, UInt<1>("h0")) @[Memory.scala 64:5 Memory.scala 43:30]
    node _GEN_58 = mux(_T, _GEN_50, UInt<1>("h0")) @[Memory.scala 64:5 Memory.scala 44:30]
    node _T_12 = eq(io_mem_opcode, UInt<2>("h3")) @[Memory.scala 227:24]
    node _dmem_module_io_addr_T_9 = bits(io_mem_alu_out, 11, 2) @[Memory.scala 235:54]
    node next_address = bits(io_mem_alu_out, 11, 2) @[Memory.scala 236:47]
    node _T_13 = eq(io_mem_func3_7, UInt<1>("h0")) @[Memory.scala 239:29]
    node _T_14 = eq(io_mem_mask_addr2, UInt<1>("h0")) @[Memory.scala 242:36]
    node lb_num = asSInt(dmem_module.io_dataOut_0) @[Memory.scala 245:63]
    node _io_mem_dataOut_T = bits(lb_num, 7, 7) @[Memory.scala 246:55]
    node _io_mem_dataOut_T_1 = bits(_io_mem_dataOut_T, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi = mux(_io_mem_dataOut_T_1, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node io_mem_dataOut_lo = asUInt(lb_num) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_2 = cat(io_mem_dataOut_hi, io_mem_dataOut_lo) @[Cat.scala 30:58]
    node _T_15 = eq(io_mem_mask_addr2, UInt<1>("h1")) @[Memory.scala 248:42]
    node lb_num_1 = asSInt(dmem_module.io_dataOut_1) @[Memory.scala 251:63]
    node _io_mem_dataOut_T_3 = bits(lb_num_1, 7, 7) @[Memory.scala 252:55]
    node _io_mem_dataOut_T_4 = bits(_io_mem_dataOut_T_3, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_1 = mux(_io_mem_dataOut_T_4, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node io_mem_dataOut_lo_1 = asUInt(lb_num_1) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_5 = cat(io_mem_dataOut_hi_1, io_mem_dataOut_lo_1) @[Cat.scala 30:58]
    node _T_16 = eq(io_mem_mask_addr2, UInt<2>("h2")) @[Memory.scala 254:42]
    node lb_num_2 = asSInt(dmem_module.io_dataOut_2) @[Memory.scala 257:63]
    node _io_mem_dataOut_T_6 = bits(lb_num_2, 7, 7) @[Memory.scala 258:55]
    node _io_mem_dataOut_T_7 = bits(_io_mem_dataOut_T_6, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_2 = mux(_io_mem_dataOut_T_7, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node io_mem_dataOut_lo_2 = asUInt(lb_num_2) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_8 = cat(io_mem_dataOut_hi_2, io_mem_dataOut_lo_2) @[Cat.scala 30:58]
    node _T_17 = eq(io_mem_mask_addr2, UInt<2>("h3")) @[Memory.scala 260:42]
    node lb_num_3 = asSInt(dmem_module.io_dataOut_3) @[Memory.scala 263:63]
    node _io_mem_dataOut_T_9 = bits(lb_num_3, 7, 7) @[Memory.scala 264:55]
    node _io_mem_dataOut_T_10 = bits(_io_mem_dataOut_T_9, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_3 = mux(_io_mem_dataOut_T_10, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node io_mem_dataOut_lo_3 = asUInt(lb_num_3) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_11 = cat(io_mem_dataOut_hi_3, io_mem_dataOut_lo_3) @[Cat.scala 30:58]
    node _GEN_59 = mux(_T_17, _io_mem_dataOut_T_11, UInt<1>("h0")) @[Memory.scala 261:13 Memory.scala 264:32 Memory.scala 47:22]
    node _GEN_60 = mux(_T_16, _io_mem_dataOut_T_8, _GEN_59) @[Memory.scala 255:13 Memory.scala 258:32]
    node _GEN_61 = mux(_T_15, _io_mem_dataOut_T_5, _GEN_60) @[Memory.scala 249:13 Memory.scala 252:32]
    node _GEN_62 = mux(_T_14, _io_mem_dataOut_T_2, _GEN_61) @[Memory.scala 243:13 Memory.scala 246:32]
    node _T_18 = eq(io_mem_func3_7, UInt<1>("h1")) @[Memory.scala 269:34]
    node _T_19 = eq(io_mem_mask_addr2, UInt<1>("h0")) @[Memory.scala 273:36]
    node _lh_num_T = cat(dmem_module.io_dataOut_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node lh_num = asSInt(_lh_num_T) @[Memory.scala 275:94]
    node _io_mem_dataOut_T_12 = bits(lh_num, 15, 15) @[Memory.scala 277:55]
    node _io_mem_dataOut_T_13 = bits(_io_mem_dataOut_T_12, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_4 = mux(_io_mem_dataOut_T_13, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_mem_dataOut_lo_4 = asUInt(lh_num) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_14 = cat(io_mem_dataOut_hi_4, io_mem_dataOut_lo_4) @[Cat.scala 30:58]
    node _T_20 = eq(io_mem_mask_addr2, UInt<1>("h1")) @[Memory.scala 279:42]
    node _lh_num_T_1 = cat(dmem_module.io_dataOut_2, dmem_module.io_dataOut_1) @[Cat.scala 30:58]
    node lh_num_1 = asSInt(_lh_num_T_1) @[Memory.scala 281:94]
    node _io_mem_dataOut_T_15 = bits(lh_num_1, 15, 15) @[Memory.scala 283:55]
    node _io_mem_dataOut_T_16 = bits(_io_mem_dataOut_T_15, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_5 = mux(_io_mem_dataOut_T_16, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_mem_dataOut_lo_5 = asUInt(lh_num_1) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_17 = cat(io_mem_dataOut_hi_5, io_mem_dataOut_lo_5) @[Cat.scala 30:58]
    node _T_21 = eq(io_mem_mask_addr2, UInt<2>("h2")) @[Memory.scala 285:42]
    node _lh_num_T_2 = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node lh_num_2 = asSInt(_lh_num_T_2) @[Memory.scala 287:94]
    node _io_mem_dataOut_T_18 = bits(lh_num_2, 15, 15) @[Memory.scala 289:55]
    node _io_mem_dataOut_T_19 = bits(_io_mem_dataOut_T_18, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_6 = mux(_io_mem_dataOut_T_19, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_mem_dataOut_lo_6 = asUInt(lh_num_2) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_20 = cat(io_mem_dataOut_hi_6, io_mem_dataOut_lo_6) @[Cat.scala 30:58]
    node _T_22 = eq(io_mem_mask_addr2, UInt<2>("h3")) @[Memory.scala 291:42]
    node _dmem_module_io_addr_T_10 = add(next_address, UInt<1>("h1")) @[Memory.scala 294:53]
    node _dmem_module_io_addr_T_11 = tail(_dmem_module_io_addr_T_10, 1) @[Memory.scala 294:53]
    node _lh_num2_T = cat(dmem_module.io_dataOut_0, dmem_module.io_dataOut_3) @[Cat.scala 30:58]
    node lh_num2 = asSInt(_lh_num2_T) @[Memory.scala 295:80]
    node _io_mem_dataOut_T_21 = bits(lh_num2, 15, 15) @[Memory.scala 296:62]
    node _io_mem_dataOut_T_22 = bits(_io_mem_dataOut_T_21, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_7 = mux(_io_mem_dataOut_T_22, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_mem_dataOut_lo_7 = asUInt(lh_num2) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_23 = cat(io_mem_dataOut_hi_7, io_mem_dataOut_lo_7) @[Cat.scala 30:58]
    node _GEN_63 = mux(_T_22, _dmem_module_io_addr_T_11, _dmem_module_io_addr_T_9) @[Memory.scala 292:13 Memory.scala 294:37 Memory.scala 235:37]
    node _GEN_64 = mux(_T_22, _io_mem_dataOut_T_23, UInt<1>("h0")) @[Memory.scala 292:13 Memory.scala 296:38 Memory.scala 47:22]
    node _GEN_65 = mux(_T_21, _io_mem_dataOut_T_20, _GEN_64) @[Memory.scala 286:13 Memory.scala 289:32]
    node _GEN_66 = mux(_T_21, _dmem_module_io_addr_T_9, _GEN_63) @[Memory.scala 286:13 Memory.scala 235:37]
    node _GEN_67 = mux(_T_20, _io_mem_dataOut_T_17, _GEN_65) @[Memory.scala 280:13 Memory.scala 283:32]
    node _GEN_68 = mux(_T_20, _dmem_module_io_addr_T_9, _GEN_66) @[Memory.scala 280:13 Memory.scala 235:37]
    node _GEN_69 = mux(_T_19, _io_mem_dataOut_T_14, _GEN_67) @[Memory.scala 274:13 Memory.scala 277:32]
    node _GEN_70 = mux(_T_19, _dmem_module_io_addr_T_9, _GEN_68) @[Memory.scala 274:13 Memory.scala 235:37]
    node _T_23 = eq(io_mem_func3_7, UInt<2>("h2")) @[Memory.scala 305:34]
    node _T_24 = eq(io_mem_mask_addr2, UInt<1>("h0")) @[Memory.scala 309:36]
    node lw_num_lo = cat(dmem_module.io_dataOut_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node lw_num_hi = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node _lw_num_T = cat(lw_num_hi, lw_num_lo) @[Cat.scala 30:58]
    node lw_num = asSInt(_lw_num_T) @[Memory.scala 312:73]
    node _io_mem_dataOut_T_24 = asUInt(lw_num) @[Memory.scala 313:42]
    node _T_25 = eq(io_mem_mask_addr2, UInt<1>("h1")) @[Memory.scala 316:42]
    node lw_num_hi_1 = cat(dmem_module.io_dataOut_2, dmem_module.io_dataOut_1) @[Cat.scala 30:58]
    node io_mem_dataOut_lo_8 = cat(lw_num_hi_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node _dmem_module_io_addr_T_12 = add(next_address, UInt<1>("h1")) @[Memory.scala 319:53]
    node _dmem_module_io_addr_T_13 = tail(_dmem_module_io_addr_T_12, 1) @[Memory.scala 319:53]
    node _io_mem_dataOut_T_25 = cat(dmem_module.io_dataOut_3, io_mem_dataOut_lo_8) @[Cat.scala 30:58]
    node _T_26 = eq(io_mem_mask_addr2, UInt<2>("h2")) @[Memory.scala 326:42]
    node io_mem_dataOut_lo_9 = cat(dmem_module.io_dataOut_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node _dmem_module_io_addr_T_14 = add(next_address, UInt<1>("h1")) @[Memory.scala 329:53]
    node _dmem_module_io_addr_T_15 = tail(_dmem_module_io_addr_T_14, 1) @[Memory.scala 329:53]
    node io_mem_dataOut_hi_8 = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_26 = cat(io_mem_dataOut_hi_8, io_mem_dataOut_lo_9) @[Cat.scala 30:58]
    node _T_27 = eq(io_mem_mask_addr2, UInt<2>("h3")) @[Memory.scala 335:42]
    node _dmem_module_io_addr_T_16 = add(next_address, UInt<1>("h1")) @[Memory.scala 338:53]
    node _dmem_module_io_addr_T_17 = tail(_dmem_module_io_addr_T_16, 1) @[Memory.scala 338:53]
    node io_mem_dataOut_lo_10 = cat(dmem_module.io_dataOut_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node io_mem_dataOut_hi_9 = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_27 = cat(io_mem_dataOut_hi_9, io_mem_dataOut_lo_10) @[Cat.scala 30:58]
    node _GEN_71 = mux(_T_27, _dmem_module_io_addr_T_17, _dmem_module_io_addr_T_9) @[Memory.scala 336:13 Memory.scala 338:37 Memory.scala 235:37]
    node _GEN_72 = mux(_T_27, _io_mem_dataOut_T_27, UInt<1>("h0")) @[Memory.scala 336:13 Memory.scala 339:38 Memory.scala 47:22]
    node _GEN_73 = mux(_T_26, _dmem_module_io_addr_T_15, _GEN_71) @[Memory.scala 327:13 Memory.scala 329:37]
    node _GEN_74 = mux(_T_26, _io_mem_dataOut_T_26, _GEN_72) @[Memory.scala 327:13 Memory.scala 330:38]
    node _GEN_75 = mux(_T_25, _dmem_module_io_addr_T_13, _GEN_73) @[Memory.scala 317:13 Memory.scala 319:37]
    node _GEN_76 = mux(_T_25, _io_mem_dataOut_T_25, _GEN_74) @[Memory.scala 317:13 Memory.scala 320:38]
    node _GEN_77 = mux(_T_24, _io_mem_dataOut_T_24, _GEN_76) @[Memory.scala 310:13 Memory.scala 313:32]
    node _GEN_78 = mux(_T_24, _dmem_module_io_addr_T_9, _GEN_75) @[Memory.scala 310:13 Memory.scala 235:37]
    node _T_28 = eq(io_mem_func3_7, UInt<3>("h4")) @[Memory.scala 348:34]
    node _T_29 = eq(io_mem_mask_addr2, UInt<1>("h0")) @[Memory.scala 350:36]
    node _io_mem_dataOut_T_28 = bits(dmem_module.io_dataOut_0, 7, 7) @[Memory.scala 353:56]
    node _io_mem_dataOut_T_29 = bits(_io_mem_dataOut_T_28, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_10 = mux(_io_mem_dataOut_T_29, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_mem_dataOut_T_30 = cat(io_mem_dataOut_hi_10, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node _T_30 = eq(io_mem_mask_addr2, UInt<1>("h1")) @[Memory.scala 358:42]
    node _io_mem_dataOut_T_31 = bits(dmem_module.io_dataOut_1, 7, 7) @[Memory.scala 361:56]
    node _io_mem_dataOut_T_32 = bits(_io_mem_dataOut_T_31, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_11 = mux(_io_mem_dataOut_T_32, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_mem_dataOut_T_33 = cat(io_mem_dataOut_hi_11, dmem_module.io_dataOut_1) @[Cat.scala 30:58]
    node _T_31 = eq(io_mem_mask_addr2, UInt<2>("h2")) @[Memory.scala 366:42]
    node _io_mem_dataOut_T_34 = bits(dmem_module.io_dataOut_2, 7, 7) @[Memory.scala 369:56]
    node _io_mem_dataOut_T_35 = bits(_io_mem_dataOut_T_34, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_12 = mux(_io_mem_dataOut_T_35, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_mem_dataOut_T_36 = cat(io_mem_dataOut_hi_12, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node _T_32 = eq(io_mem_mask_addr2, UInt<2>("h3")) @[Memory.scala 374:42]
    node _io_mem_dataOut_T_37 = bits(dmem_module.io_dataOut_3, 7, 7) @[Memory.scala 377:56]
    node _io_mem_dataOut_T_38 = bits(_io_mem_dataOut_T_37, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_13 = mux(_io_mem_dataOut_T_38, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_mem_dataOut_T_39 = cat(io_mem_dataOut_hi_13, dmem_module.io_dataOut_3) @[Cat.scala 30:58]
    node _GEN_79 = mux(_T_32, _io_mem_dataOut_T_39, UInt<1>("h0")) @[Memory.scala 375:13 Memory.scala 377:32 Memory.scala 47:22]
    node _GEN_80 = mux(_T_31, _io_mem_dataOut_T_36, _GEN_79) @[Memory.scala 367:13 Memory.scala 369:32]
    node _GEN_81 = mux(_T_30, _io_mem_dataOut_T_33, _GEN_80) @[Memory.scala 359:13 Memory.scala 361:32]
    node _GEN_82 = mux(_T_29, _io_mem_dataOut_T_30, _GEN_81) @[Memory.scala 351:13 Memory.scala 353:32]
    node _T_33 = eq(io_mem_func3_7, UInt<3>("h5")) @[Memory.scala 387:34]
    node _T_34 = eq(io_mem_mask_addr2, UInt<1>("h0")) @[Memory.scala 389:36]
    node io_mem_dataOut_lo_11 = cat(dmem_module.io_dataOut_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_40 = bits(io_mem_dataOut_lo_11, 15, 15) @[Memory.scala 392:56]
    node _io_mem_dataOut_T_41 = bits(_io_mem_dataOut_T_40, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_14 = mux(_io_mem_dataOut_T_41, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node _io_mem_dataOut_T_42 = cat(io_mem_dataOut_hi_14, io_mem_dataOut_lo_11) @[Cat.scala 30:58]
    node _T_35 = eq(io_mem_mask_addr2, UInt<1>("h1")) @[Memory.scala 397:42]
    node io_mem_dataOut_lo_12 = cat(dmem_module.io_dataOut_2, dmem_module.io_dataOut_1) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_43 = bits(io_mem_dataOut_lo_12, 15, 15) @[Memory.scala 400:56]
    node _io_mem_dataOut_T_44 = bits(_io_mem_dataOut_T_43, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_15 = mux(_io_mem_dataOut_T_44, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node _io_mem_dataOut_T_45 = cat(io_mem_dataOut_hi_15, io_mem_dataOut_lo_12) @[Cat.scala 30:58]
    node _T_36 = eq(io_mem_mask_addr2, UInt<2>("h2")) @[Memory.scala 405:42]
    node io_mem_dataOut_lo_13 = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_46 = bits(io_mem_dataOut_lo_13, 15, 15) @[Memory.scala 408:56]
    node _io_mem_dataOut_T_47 = bits(_io_mem_dataOut_T_46, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_16 = mux(_io_mem_dataOut_T_47, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node _io_mem_dataOut_T_48 = cat(io_mem_dataOut_hi_16, io_mem_dataOut_lo_13) @[Cat.scala 30:58]
    node _T_37 = eq(io_mem_mask_addr2, UInt<2>("h3")) @[Memory.scala 413:42]
    node _dmem_module_io_addr_T_18 = add(next_address, UInt<1>("h1")) @[Memory.scala 416:53]
    node _dmem_module_io_addr_T_19 = tail(_dmem_module_io_addr_T_18, 1) @[Memory.scala 416:53]
    node io_mem_dataOut_lo_14 = cat(dmem_module.io_dataOut_0, dmem_module.io_dataOut_3) @[Cat.scala 30:58]
    node _io_mem_dataOut_T_49 = bits(io_mem_dataOut_lo_14, 15, 15) @[Memory.scala 418:62]
    node _io_mem_dataOut_T_50 = bits(_io_mem_dataOut_T_49, 0, 0) @[Bitwise.scala 72:15]
    node io_mem_dataOut_hi_17 = mux(_io_mem_dataOut_T_50, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node _io_mem_dataOut_T_51 = cat(io_mem_dataOut_hi_17, io_mem_dataOut_lo_14) @[Cat.scala 30:58]
    node _GEN_83 = mux(_T_37, _dmem_module_io_addr_T_19, _dmem_module_io_addr_T_9) @[Memory.scala 414:13 Memory.scala 416:37 Memory.scala 235:37]
    node _GEN_84 = mux(_T_37, _io_mem_dataOut_T_51, UInt<1>("h0")) @[Memory.scala 414:13 Memory.scala 418:38 Memory.scala 47:22]
    node _GEN_85 = mux(_T_36, _io_mem_dataOut_T_48, _GEN_84) @[Memory.scala 406:13 Memory.scala 408:32]
    node _GEN_86 = mux(_T_36, _dmem_module_io_addr_T_9, _GEN_83) @[Memory.scala 406:13 Memory.scala 235:37]
    node _GEN_87 = mux(_T_35, _io_mem_dataOut_T_45, _GEN_85) @[Memory.scala 398:13 Memory.scala 400:32]
    node _GEN_88 = mux(_T_35, _dmem_module_io_addr_T_9, _GEN_86) @[Memory.scala 398:13 Memory.scala 235:37]
    node _GEN_89 = mux(_T_34, _io_mem_dataOut_T_42, _GEN_87) @[Memory.scala 390:13 Memory.scala 392:32]
    node _GEN_90 = mux(_T_34, _dmem_module_io_addr_T_9, _GEN_88) @[Memory.scala 390:13 Memory.scala 235:37]
    node _GEN_91 = mux(_T_33, _GEN_89, UInt<1>("h0")) @[Memory.scala 388:9 Memory.scala 47:22]
    node _GEN_92 = mux(_T_33, _GEN_90, _dmem_module_io_addr_T_9) @[Memory.scala 388:9 Memory.scala 235:37]
    node _GEN_93 = mux(_T_28, _GEN_82, _GEN_91) @[Memory.scala 349:9]
    node _GEN_94 = mux(_T_28, _dmem_module_io_addr_T_9, _GEN_92) @[Memory.scala 349:9 Memory.scala 235:37]
    node _GEN_95 = mux(_T_23, _GEN_77, _GEN_93) @[Memory.scala 306:9]
    node _GEN_96 = mux(_T_23, _GEN_78, _GEN_94) @[Memory.scala 306:9]
    node _GEN_97 = mux(_T_18, _GEN_69, _GEN_95) @[Memory.scala 270:9]
    node _GEN_98 = mux(_T_18, _GEN_70, _GEN_96) @[Memory.scala 270:9]
    node _GEN_99 = mux(_T_13, _GEN_62, _GEN_97) @[Memory.scala 240:9]
    node _GEN_100 = mux(_T_13, _dmem_module_io_addr_T_9, _GEN_98) @[Memory.scala 240:9 Memory.scala 235:37]
    node _GEN_101 = mux(_T_12, UInt<1>("h0"), _GEN_52) @[Memory.scala 228:5 Memory.scala 230:30]
    node _GEN_102 = mux(_T_12, io_mem_rdata1, _GEN_53) @[Memory.scala 228:5 Memory.scala 232:30]
    node _GEN_103 = mux(_T_12, _GEN_100, _GEN_54) @[Memory.scala 228:5]
    node _GEN_104 = mux(_T_12, _GEN_99, UInt<1>("h0")) @[Memory.scala 228:5 Memory.scala 47:22]
    io_mem_alu_in_B <= _GEN_102
    io_mem_alu_Op <= _GEN_101
    io_mem_dataOut <= _GEN_104
    dmem_module.clock <= clock
    dmem_module.reset <= reset
    dmem_module.io_addr <= _GEN_103
    dmem_module.io_rd_enable <= io_mem_rd_enable @[Memory.scala 33:33]
    dmem_module.io_wr_enable <= io_mem_dmem_enable @[Memory.scala 34:33]
    dmem_module.io_mask_0 <= io_mem_mask_val_0 @[Memory.scala 35:33]
    dmem_module.io_mask_1 <= io_mem_mask_val_1 @[Memory.scala 35:33]
    dmem_module.io_mask_2 <= io_mem_mask_val_2 @[Memory.scala 35:33]
    dmem_module.io_mask_3 <= io_mem_mask_val_3 @[Memory.scala 35:33]
    dmem_module.io_dataIn_0 <= _GEN_55
    dmem_module.io_dataIn_1 <= _GEN_56
    dmem_module.io_dataIn_2 <= _GEN_57
    dmem_module.io_dataIn_3 <= _GEN_58

  module WriteBack :
    input clock : Clock
    input reset : UInt<1>
    input io_wb_opcode : UInt<7>
    input io_wb_dmem_dataOut : UInt<32>
    output io_wb_dataOut : UInt<32>

    node _io_wb_dataOut_T = eq(io_wb_opcode, UInt<2>("h3")) @[WriteBack.scala 24:39]
    node _io_wb_dataOut_T_1 = mux(_io_wb_dataOut_T, io_wb_dmem_dataOut, UInt<1>("h0")) @[WriteBack.scala 24:25]
    io_wb_dataOut <= _io_wb_dataOut_T_1 @[WriteBack.scala 24:19]

  module CoreTop :
    input clock : Clock
    input reset : UInt<1>
    input io_dataIn : UInt<32>
    output io_dataOut : UInt<32>

    inst fetch_module of Fetch @[CoreTop.scala 43:37]
    inst decode_module of Decode @[CoreTop.scala 44:37]
    inst execute_module of Execute @[CoreTop.scala 45:37]
    inst memory_module of Memory @[CoreTop.scala 46:37]
    inst wb_module of WriteBack @[CoreTop.scala 47:37]
    node _T = bits(fetch_module.io_fetch_dataOut, 6, 0) @[CoreTop.scala 76:41]
    node _T_1 = eq(_T, UInt<5>("h17")) @[CoreTop.scala 76:47]
    node _T_2 = bits(fetch_module.io_fetch_dataOut, 6, 0) @[CoreTop.scala 77:41]
    node _T_3 = eq(_T_2, UInt<7>("h63")) @[CoreTop.scala 77:47]
    node _T_4 = or(_T_1, _T_3) @[CoreTop.scala 77:9]
    node _T_5 = bits(fetch_module.io_fetch_dataOut, 6, 0) @[CoreTop.scala 79:39]
    node _T_6 = eq(_T_5, UInt<7>("h6f")) @[CoreTop.scala 79:45]
    node _T_7 = bits(fetch_module.io_fetch_dataOut, 6, 0) @[CoreTop.scala 80:41]
    node _T_8 = eq(_T_7, UInt<7>("h67")) @[CoreTop.scala 80:47]
    node _T_9 = or(_T_6, _T_8) @[CoreTop.scala 80:9]
    node _T_10 = or(_T_4, _T_9) @[CoreTop.scala 78:13]
    node _GEN_0 = mux(_T_10, decode_module.io_decode_alu_in_A, decode_module.io_decode_rdata1) @[CoreTop.scala 81:5 CoreTop.scala 82:47 CoreTop.scala 65:41]
    node _GEN_1 = mux(_T_10, decode_module.io_decode_alu_in_B, decode_module.io_decode_rdata2) @[CoreTop.scala 81:5 CoreTop.scala 83:47 CoreTop.scala 66:41]
    node _GEN_2 = mux(_T_10, decode_module.io_decode_alu_Op, decode_module.io_decode_func3_7) @[CoreTop.scala 81:5 CoreTop.scala 84:47 CoreTop.scala 67:41]
    node _GEN_3 = mux(_T_10, execute_module.io_execute_out, execute_module.io_execute_out) @[CoreTop.scala 81:5 CoreTop.scala 85:47 CoreTop.scala 72:45]
    node _decode_module_io_decode_dmem_addr2_T = bits(execute_module.io_execute_out, 1, 0) @[CoreTop.scala 89:81]
    node _memory_module_io_mem_opcode_T = bits(fetch_module.io_fetch_dataOut, 6, 0) @[CoreTop.scala 98:73]
    node _memory_module_io_mem_func3_7_T = bits(fetch_module.io_fetch_dataOut, 14, 12) @[CoreTop.scala 99:73]
    node _wb_module_io_wb_opcode_T = bits(fetch_module.io_fetch_dataOut, 6, 0) @[CoreTop.scala 128:73]
    node _T_11 = bits(fetch_module.io_fetch_dataOut, 6, 0) @[CoreTop.scala 136:39]
    node _T_12 = eq(_T_11, UInt<6>("h23")) @[CoreTop.scala 136:45]
    node _memory_module_io_mem_mask_addr2_T = bits(execute_module.io_execute_out, 1, 0) @[CoreTop.scala 148:79]
    node _memory_module_io_mem_datainput_0_T = bits(decode_module.io_decode_rdata2, 7, 0) @[CoreTop.scala 152:83]
    node _memory_module_io_mem_datainput_1_T = bits(decode_module.io_decode_rdata2, 15, 8) @[CoreTop.scala 153:83]
    node _memory_module_io_mem_datainput_2_T = bits(decode_module.io_decode_rdata2, 23, 16) @[CoreTop.scala 154:83]
    node _memory_module_io_mem_datainput_3_T = bits(decode_module.io_decode_rdata2, 31, 24) @[CoreTop.scala 155:83]
    node _T_13 = bits(fetch_module.io_fetch_dataOut, 6, 0) @[CoreTop.scala 156:45]
    node _T_14 = eq(_T_13, UInt<2>("h3")) @[CoreTop.scala 156:51]
    node _memory_module_io_mem_mask_addr2_T_1 = bits(execute_module.io_execute_out, 1, 0) @[CoreTop.scala 168:79]
    node _GEN_4 = mux(_T_14, decode_module.io_decode_rdata1, UInt<1>("h0")) @[CoreTop.scala 157:5 CoreTop.scala 164:47 CoreTop.scala 110:41]
    node _GEN_5 = mux(_T_14, decode_module.io_decode_immediate, _GEN_0) @[CoreTop.scala 157:5 CoreTop.scala 165:47]
    node _GEN_6 = mux(_T_14, memory_module.io_mem_alu_in_B, _GEN_1) @[CoreTop.scala 157:5 CoreTop.scala 166:47]
    node _GEN_7 = mux(_T_14, memory_module.io_mem_alu_Op, _GEN_2) @[CoreTop.scala 157:5 CoreTop.scala 167:47]
    node _GEN_8 = mux(_T_14, _memory_module_io_mem_mask_addr2_T_1, UInt<1>("h0")) @[CoreTop.scala 157:5 CoreTop.scala 168:47 CoreTop.scala 102:41]
    node _GEN_9 = mux(_T_14, execute_module.io_execute_out, execute_module.io_execute_out) @[CoreTop.scala 157:5 CoreTop.scala 169:47 CoreTop.scala 115:44]
    node _GEN_10 = mux(_T_14, memory_module.io_mem_dataOut, UInt<1>("h0")) @[CoreTop.scala 157:5 CoreTop.scala 171:47 CoreTop.scala 130:38]
    node _GEN_11 = mux(_T_14, wb_module.io_wb_dataOut, execute_module.io_execute_out) @[CoreTop.scala 157:5 CoreTop.scala 173:47 CoreTop.scala 70:45]
    node _GEN_12 = mux(_T_12, decode_module.io_decode_rdata1, _GEN_4) @[CoreTop.scala 137:5 CoreTop.scala 140:47]
    node _GEN_13 = mux(_T_12, decode_module.io_decode_immediate, _GEN_5) @[CoreTop.scala 137:5 CoreTop.scala 145:47]
    node _GEN_14 = mux(_T_12, memory_module.io_mem_alu_in_B, _GEN_6) @[CoreTop.scala 137:5 CoreTop.scala 146:47]
    node _GEN_15 = mux(_T_12, memory_module.io_mem_alu_Op, _GEN_7) @[CoreTop.scala 137:5 CoreTop.scala 147:47]
    node _GEN_16 = mux(_T_12, _memory_module_io_mem_mask_addr2_T, _GEN_8) @[CoreTop.scala 137:5 CoreTop.scala 148:47]
    node _GEN_17 = mux(_T_12, execute_module.io_execute_out, _GEN_9) @[CoreTop.scala 137:5 CoreTop.scala 149:47]
    node _GEN_18 = mux(_T_12, _memory_module_io_mem_datainput_0_T, UInt<1>("h0")) @[CoreTop.scala 137:5 CoreTop.scala 152:50 CoreTop.scala 105:44]
    node _GEN_19 = mux(_T_12, _memory_module_io_mem_datainput_1_T, UInt<1>("h0")) @[CoreTop.scala 137:5 CoreTop.scala 153:50 CoreTop.scala 106:44]
    node _GEN_20 = mux(_T_12, _memory_module_io_mem_datainput_2_T, UInt<1>("h0")) @[CoreTop.scala 137:5 CoreTop.scala 154:50 CoreTop.scala 107:44]
    node _GEN_21 = mux(_T_12, _memory_module_io_mem_datainput_3_T, UInt<1>("h0")) @[CoreTop.scala 137:5 CoreTop.scala 155:50 CoreTop.scala 108:44]
    node _GEN_22 = mux(_T_12, UInt<1>("h0"), _GEN_10) @[CoreTop.scala 137:5 CoreTop.scala 130:38]
    node _GEN_23 = mux(_T_12, execute_module.io_execute_out, _GEN_11) @[CoreTop.scala 137:5 CoreTop.scala 70:45]
    io_dataOut <= decode_module.io_decode_regfile_wdata @[CoreTop.scala 176:21]
    fetch_module.clock <= clock
    fetch_module.reset <= reset
    fetch_module.io_fetch_pc_br_imm <= decode_module.io_decode_pc_br_imm @[CoreTop.scala 59:38]
    fetch_module.io_fetch_pc_en_jump <= decode_module.io_decode_pc_en_jump @[CoreTop.scala 61:38]
    fetch_module.io_fetch_jalr_en_pc <= decode_module.io_decode_pc_en_jalr @[CoreTop.scala 63:38]
    fetch_module.io_fetch_wen <= decode_module.io_decode_imem_en @[CoreTop.scala 51:35]
    decode_module.clock <= clock
    decode_module.reset <= reset
    decode_module.io_decode_ins <= fetch_module.io_fetch_dataOut @[CoreTop.scala 57:38]
    decode_module.io_decode_dmem_addr2 <= _decode_module_io_decode_dmem_addr2_T @[CoreTop.scala 89:47]
    decode_module.io_decode_regfile_wdata <= _GEN_23
    decode_module.io_decode_pc_out <= fetch_module.io_fetch_pc_out @[CoreTop.scala 74:45]
    decode_module.io_decode_alu_out <= _GEN_3
    execute_module.clock <= clock
    execute_module.reset <= reset
    execute_module.io_execute_in_A <= _GEN_13
    execute_module.io_execute_in_B <= _GEN_14
    execute_module.io_execute_alu_Op <= _GEN_15
    memory_module.clock <= clock
    memory_module.reset <= reset
    memory_module.io_mem_mask_addr2 <= _GEN_16
    memory_module.io_mem_opcode <= _memory_module_io_mem_opcode_T @[CoreTop.scala 98:41]
    memory_module.io_mem_datainput_0 <= _GEN_18
    memory_module.io_mem_datainput_1 <= _GEN_19
    memory_module.io_mem_datainput_2 <= _GEN_20
    memory_module.io_mem_datainput_3 <= _GEN_21
    memory_module.io_mem_rdata1 <= _GEN_12
    memory_module.io_mem_rd_enable <= decode_module.io_decode_r_en @[CoreTop.scala 113:44]
    memory_module.io_mem_dmem_enable <= decode_module.io_decode_dmem_en @[CoreTop.scala 112:44]
    memory_module.io_mem_mask_val_0 <= decode_module.io_decode_mask_val_0 @[CoreTop.scala 114:44]
    memory_module.io_mem_mask_val_1 <= decode_module.io_decode_mask_val_1 @[CoreTop.scala 114:44]
    memory_module.io_mem_mask_val_2 <= decode_module.io_decode_mask_val_2 @[CoreTop.scala 114:44]
    memory_module.io_mem_mask_val_3 <= decode_module.io_decode_mask_val_3 @[CoreTop.scala 114:44]
    memory_module.io_mem_func3_7 <= _memory_module_io_mem_func3_7_T @[CoreTop.scala 99:41]
    memory_module.io_mem_alu_out <= _GEN_17
    wb_module.clock <= clock
    wb_module.reset <= reset
    wb_module.io_wb_opcode <= _wb_module_io_wb_opcode_T @[CoreTop.scala 128:41]
    wb_module.io_wb_dmem_dataOut <= _GEN_22
