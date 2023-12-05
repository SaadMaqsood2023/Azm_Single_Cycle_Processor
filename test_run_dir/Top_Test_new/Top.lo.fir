circuit Top :
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

    mem Sync_memory_0 : @[DMEM.scala 20:34]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    mem Sync_memory_1 : @[DMEM.scala 20:34]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    mem Sync_memory_2 : @[DMEM.scala 20:34]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    mem Sync_memory_3 : @[DMEM.scala 20:34]
      data-type => UInt<8>
      depth => 1024
      read-latency => 1
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    node _GEN_0 = validif(io_mask_0, io_dataIn_0)
    node _GEN_1 = mux(io_mask_0, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_2 = validif(io_mask_1, io_dataIn_1)
    node _GEN_3 = mux(io_mask_1, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_4 = validif(io_mask_2, io_dataIn_2)
    node _GEN_5 = mux(io_mask_2, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_6 = validif(io_mask_3, io_dataIn_3)
    node _GEN_7 = mux(io_mask_3, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_8 = validif(io_wr_enable, io_addr) @[DMEM.scala 24:27]
    node _GEN_9 = validif(io_wr_enable, clock) @[DMEM.scala 24:27]
    node _GEN_10 = mux(io_wr_enable, UInt<1>("h1"), UInt<1>("h0")) @[DMEM.scala 24:27 DMEM.scala 20:34]
    node _GEN_11 = validif(io_wr_enable, _GEN_1) @[DMEM.scala 24:27]
    node _GEN_12 = validif(io_wr_enable, _GEN_3) @[DMEM.scala 24:27]
    node _GEN_13 = validif(io_wr_enable, _GEN_5) @[DMEM.scala 24:27]
    node _GEN_14 = validif(io_wr_enable, _GEN_7) @[DMEM.scala 24:27]
    node _GEN_15 = validif(io_wr_enable, _GEN_0) @[DMEM.scala 24:27]
    node _GEN_16 = validif(io_wr_enable, _GEN_2) @[DMEM.scala 24:27]
    node _GEN_17 = validif(io_wr_enable, _GEN_4) @[DMEM.scala 24:27]
    node _GEN_18 = validif(io_wr_enable, _GEN_6) @[DMEM.scala 24:27]
    io_dataOut_0 <= Sync_memory_0.MPORT_1.data @[DMEM.scala 29:18]
    io_dataOut_1 <= Sync_memory_1.MPORT_1.data @[DMEM.scala 29:18]
    io_dataOut_2 <= Sync_memory_2.MPORT_1.data @[DMEM.scala 29:18]
    io_dataOut_3 <= Sync_memory_3.MPORT_1.data @[DMEM.scala 29:18]
    Sync_memory_0.MPORT_1.addr <= io_addr @[DMEM.scala 29:38]
    Sync_memory_1.MPORT_1.addr <= io_addr @[DMEM.scala 29:38]
    Sync_memory_2.MPORT_1.addr <= io_addr @[DMEM.scala 29:38]
    Sync_memory_3.MPORT_1.addr <= io_addr @[DMEM.scala 29:38]
    Sync_memory_0.MPORT_1.en <= UInt<1>("h1") @[DMEM.scala 29:38]
    Sync_memory_1.MPORT_1.en <= UInt<1>("h1") @[DMEM.scala 29:38]
    Sync_memory_2.MPORT_1.en <= UInt<1>("h1") @[DMEM.scala 29:38]
    Sync_memory_3.MPORT_1.en <= UInt<1>("h1") @[DMEM.scala 29:38]
    Sync_memory_0.MPORT_1.clk <= clock @[DMEM.scala 29:38]
    Sync_memory_1.MPORT_1.clk <= clock @[DMEM.scala 29:38]
    Sync_memory_2.MPORT_1.clk <= clock @[DMEM.scala 29:38]
    Sync_memory_3.MPORT_1.clk <= clock @[DMEM.scala 29:38]
    Sync_memory_0.MPORT.addr <= _GEN_8
    Sync_memory_1.MPORT.addr <= _GEN_8
    Sync_memory_2.MPORT.addr <= _GEN_8
    Sync_memory_3.MPORT.addr <= _GEN_8
    Sync_memory_0.MPORT.en <= _GEN_10
    Sync_memory_1.MPORT.en <= _GEN_10
    Sync_memory_2.MPORT.en <= _GEN_10
    Sync_memory_3.MPORT.en <= _GEN_10
    Sync_memory_0.MPORT.clk <= _GEN_9
    Sync_memory_1.MPORT.clk <= _GEN_9
    Sync_memory_2.MPORT.clk <= _GEN_9
    Sync_memory_3.MPORT.clk <= _GEN_9
    Sync_memory_0.MPORT.data <= _GEN_15
    Sync_memory_1.MPORT.data <= _GEN_16
    Sync_memory_2.MPORT.data <= _GEN_17
    Sync_memory_3.MPORT.data <= _GEN_18
    Sync_memory_0.MPORT.mask <= _GEN_11
    Sync_memory_1.MPORT.mask <= _GEN_12
    Sync_memory_2.MPORT.mask <= _GEN_13
    Sync_memory_3.MPORT.mask <= _GEN_14

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
    node _T = bits(io_ins, 6, 0) @[CU.scala 83:16]
    node _T_1 = eq(_T, UInt<6>("h33")) @[CU.scala 83:22]
    node io_func3_7_hi = bits(io_ins, 30, 30) @[CU.scala 86:34]
    node io_func3_7_lo = bits(io_ins, 14, 12) @[CU.scala 86:46]
    node _io_func3_7_T_1 = cat(io_func3_7_hi, io_func3_7_lo) @[Cat.scala 30:58]
    node _T_2 = bits(io_ins, 6, 0) @[CU.scala 87:22]
    node _T_3 = eq(_T_2, UInt<5>("h13")) @[CU.scala 87:28]
    node _io_immediate_T = bits(io_ins, 31, 31) @[CU.scala 90:46]
    node _io_immediate_T_1 = bits(_io_immediate_T, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi = mux(_io_immediate_T_1, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_immediate_lo = bits(io_ins, 31, 20) @[CU.scala 90:60]
    node _io_immediate_T_2 = cat(io_immediate_hi, io_immediate_lo) @[Cat.scala 30:58]
    node _T_4 = bits(io_ins, 14, 12) @[CU.scala 92:20]
    node _T_5 = eq(_T_4, UInt<1>("h1")) @[CU.scala 92:28]
    node _T_6 = bits(io_ins, 14, 12) @[CU.scala 93:18]
    node _T_7 = eq(_T_6, UInt<3>("h5")) @[CU.scala 93:26]
    node _T_8 = or(_T_5, _T_7) @[CU.scala 93:9]
    node _T_9 = bits(io_ins, 14, 12) @[CU.scala 93:49]
    node _T_10 = eq(_T_9, UInt<4>("hd")) @[CU.scala 93:57]
    node _T_11 = or(_T_8, _T_10) @[CU.scala 93:40]
    node io_func3_7_hi_1 = bits(io_ins, 30, 30) @[CU.scala 95:38]
    node io_func3_7_lo_1 = bits(io_ins, 14, 12) @[CU.scala 95:50]
    node _io_func3_7_T_2 = cat(io_func3_7_hi_1, io_func3_7_lo_1) @[Cat.scala 30:58]
    node _GEN_0 = mux(_T_11, _io_func3_7_T_2, _io_func3_7_T) @[CU.scala 94:9 CU.scala 95:24 CU.scala 71:16]
    node _T_12 = bits(io_ins, 6, 0) @[CU.scala 97:22]
    node _T_13 = eq(_T_12, UInt<2>("h3")) @[CU.scala 97:28]
    node _io_immediate_T_3 = bits(io_ins, 31, 31) @[CU.scala 99:46]
    node _io_immediate_T_4 = bits(_io_immediate_T_3, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_1 = mux(_io_immediate_T_4, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_immediate_lo_1 = bits(io_ins, 31, 20) @[CU.scala 99:60]
    node _io_immediate_T_5 = cat(io_immediate_hi_1, io_immediate_lo_1) @[Cat.scala 30:58]
    node _T_14 = bits(io_ins, 6, 0) @[CU.scala 103:22]
    node _T_15 = eq(_T_14, UInt<6>("h23")) @[CU.scala 103:28]
    node imm_temp_hi = bits(io_ins, 31, 25) @[CU.scala 105:35]
    node imm_temp_lo = bits(io_ins, 11, 7) @[CU.scala 105:50]
    node io_immediate_lo_2 = cat(imm_temp_hi, imm_temp_lo) @[Cat.scala 30:58]
    node _io_immediate_T_6 = bits(io_immediate_lo_2, 11, 11) @[CU.scala 106:46]
    node _io_immediate_T_7 = bits(_io_immediate_T_6, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_2 = mux(_io_immediate_T_7, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node _io_immediate_T_8 = cat(io_immediate_hi_2, io_immediate_lo_2) @[Cat.scala 30:58]
    node _T_16 = bits(io_ins, 14, 12) @[CU.scala 113:20]
    node _T_17 = eq(_T_16, UInt<1>("h0")) @[CU.scala 113:28]
    node _T_18 = eq(io_dmem_addr2, UInt<1>("h0")) @[CU.scala 115:32]
    node _T_19 = eq(io_dmem_addr2, UInt<1>("h1")) @[CU.scala 121:38]
    node _T_20 = eq(io_dmem_addr2, UInt<2>("h2")) @[CU.scala 127:38]
    node _T_21 = eq(io_dmem_addr2, UInt<2>("h3")) @[CU.scala 133:38]
    node _GEN_1 = mux(_T_21, UInt<1>("h0"), UInt<1>("h0")) @[CU.scala 134:13 CU.scala 135:32 CU.scala 58:20]
    node _GEN_2 = mux(_T_21, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 134:13 CU.scala 138:32 CU.scala 61:20]
    node _GEN_3 = mux(_T_20, UInt<1>("h0"), _GEN_1) @[CU.scala 128:13 CU.scala 129:32]
    node _GEN_4 = mux(_T_20, UInt<1>("h1"), _GEN_1) @[CU.scala 128:13 CU.scala 131:32]
    node _GEN_5 = mux(_T_20, UInt<1>("h0"), _GEN_2) @[CU.scala 128:13 CU.scala 132:32]
    node _GEN_6 = mux(_T_19, UInt<1>("h0"), _GEN_3) @[CU.scala 122:13 CU.scala 123:32]
    node _GEN_7 = mux(_T_19, UInt<1>("h1"), _GEN_3) @[CU.scala 122:13 CU.scala 124:32]
    node _GEN_8 = mux(_T_19, UInt<1>("h0"), _GEN_4) @[CU.scala 122:13 CU.scala 125:32]
    node _GEN_9 = mux(_T_19, UInt<1>("h0"), _GEN_5) @[CU.scala 122:13 CU.scala 126:32]
    node _GEN_10 = mux(_T_18, UInt<1>("h1"), _GEN_6) @[CU.scala 116:13 CU.scala 117:32]
    node _GEN_11 = mux(_T_18, UInt<1>("h0"), _GEN_7) @[CU.scala 116:13 CU.scala 118:32]
    node _GEN_12 = mux(_T_18, UInt<1>("h0"), _GEN_8) @[CU.scala 116:13 CU.scala 119:32]
    node _GEN_13 = mux(_T_18, UInt<1>("h0"), _GEN_9) @[CU.scala 116:13 CU.scala 120:32]
    node _T_22 = bits(io_ins, 14, 12) @[CU.scala 141:26]
    node _T_23 = eq(_T_22, UInt<1>("h1")) @[CU.scala 141:34]
    node _T_24 = eq(io_dmem_addr2, UInt<1>("h0")) @[CU.scala 143:32]
    node _T_25 = eq(io_dmem_addr2, UInt<1>("h1")) @[CU.scala 149:38]
    node _T_26 = eq(io_dmem_addr2, UInt<2>("h2")) @[CU.scala 155:38]
    node _T_27 = eq(io_dmem_addr2, UInt<2>("h3")) @[CU.scala 161:38]
    node _GEN_14 = mux(_T_27, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 162:13 CU.scala 163:32 CU.scala 58:20]
    node _GEN_15 = mux(_T_27, UInt<1>("h0"), UInt<1>("h0")) @[CU.scala 162:13 CU.scala 164:32 CU.scala 59:20]
    node _GEN_16 = mux(_T_26, UInt<1>("h0"), _GEN_14) @[CU.scala 156:13 CU.scala 157:32]
    node _GEN_17 = mux(_T_26, UInt<1>("h0"), _GEN_15) @[CU.scala 156:13 CU.scala 158:32]
    node _GEN_18 = mux(_T_26, UInt<1>("h1"), _GEN_15) @[CU.scala 156:13 CU.scala 159:32]
    node _GEN_19 = mux(_T_26, UInt<1>("h1"), _GEN_14) @[CU.scala 156:13 CU.scala 160:32]
    node _GEN_20 = mux(_T_25, UInt<1>("h0"), _GEN_16) @[CU.scala 150:13 CU.scala 151:32]
    node _GEN_21 = mux(_T_25, UInt<1>("h1"), _GEN_17) @[CU.scala 150:13 CU.scala 152:32]
    node _GEN_22 = mux(_T_25, UInt<1>("h1"), _GEN_18) @[CU.scala 150:13 CU.scala 153:32]
    node _GEN_23 = mux(_T_25, UInt<1>("h0"), _GEN_19) @[CU.scala 150:13 CU.scala 154:32]
    node _GEN_24 = mux(_T_24, UInt<1>("h1"), _GEN_20) @[CU.scala 144:13 CU.scala 145:32]
    node _GEN_25 = mux(_T_24, UInt<1>("h1"), _GEN_21) @[CU.scala 144:13 CU.scala 146:32]
    node _GEN_26 = mux(_T_24, UInt<1>("h0"), _GEN_22) @[CU.scala 144:13 CU.scala 147:32]
    node _GEN_27 = mux(_T_24, UInt<1>("h0"), _GEN_23) @[CU.scala 144:13 CU.scala 148:32]
    node _T_28 = bits(io_ins, 14, 12) @[CU.scala 169:26]
    node _T_29 = eq(_T_28, UInt<2>("h2")) @[CU.scala 169:34]
    node _T_30 = eq(io_dmem_addr2, UInt<1>("h0")) @[CU.scala 171:32]
    node _GEN_28 = mux(_T_30, UInt<1>("h1"), UInt<1>("h1")) @[CU.scala 172:13 CU.scala 173:32 CU.scala 178:32]
    node _GEN_29 = mux(_T_29, _GEN_28, UInt<1>("h0")) @[CU.scala 170:9 CU.scala 58:20]
    node _GEN_30 = mux(_T_23, _GEN_24, _GEN_29) @[CU.scala 142:9]
    node _GEN_31 = mux(_T_23, _GEN_25, _GEN_29) @[CU.scala 142:9]
    node _GEN_32 = mux(_T_23, _GEN_26, _GEN_29) @[CU.scala 142:9]
    node _GEN_33 = mux(_T_23, _GEN_27, _GEN_29) @[CU.scala 142:9]
    node _GEN_34 = mux(_T_17, _GEN_10, _GEN_30) @[CU.scala 114:9]
    node _GEN_35 = mux(_T_17, _GEN_11, _GEN_31) @[CU.scala 114:9]
    node _GEN_36 = mux(_T_17, _GEN_12, _GEN_32) @[CU.scala 114:9]
    node _GEN_37 = mux(_T_17, _GEN_13, _GEN_33) @[CU.scala 114:9]
    node _T_31 = bits(io_ins, 6, 0) @[CU.scala 187:22]
    node _T_32 = eq(_T_31, UInt<6>("h37")) @[CU.scala 187:28]
    node io_immediate_hi_3 = bits(io_ins, 31, 12) @[CU.scala 189:36]
    node io_immediate_lo_3 = mux(UInt<1>("h0"), UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 72:12]
    node _io_immediate_T_9 = cat(io_immediate_hi_3, io_immediate_lo_3) @[Cat.scala 30:58]
    node _T_33 = bits(io_ins, 6, 0) @[CU.scala 192:22]
    node _T_34 = eq(_T_33, UInt<5>("h17")) @[CU.scala 192:28]
    node _io_immediate_T_10 = bits(io_ins, 31, 12) @[CU.scala 194:33]
    node _io_immediate_T_11 = shl(_io_immediate_T_10, 12) @[CU.scala 194:43]
    node _T_35 = bits(io_ins, 6, 0) @[CU.scala 197:22]
    node _T_36 = eq(_T_35, UInt<7>("h63")) @[CU.scala 197:28]
    node temp_hi_hi_hi = bits(io_ins, 31, 31) @[CU.scala 200:30]
    node temp_hi_hi_lo = bits(io_ins, 7, 7) @[CU.scala 200:42]
    node temp_hi_lo = bits(io_ins, 30, 25) @[CU.scala 200:53]
    node temp_lo_hi = bits(io_ins, 11, 8) @[CU.scala 200:67]
    node temp_lo = cat(temp_lo_hi, UInt<1>("h0")) @[Cat.scala 30:58]
    node temp_hi_hi = cat(temp_hi_hi_hi, temp_hi_hi_lo) @[Cat.scala 30:58]
    node temp_hi = cat(temp_hi_hi, temp_hi_lo) @[Cat.scala 30:58]
    node io_immediate_lo_4 = cat(temp_hi, temp_lo) @[Cat.scala 30:58]
    node _io_immediate_T_12 = bits(io_immediate_lo_4, 12, 12) @[CU.scala 201:43]
    node _io_immediate_T_13 = bits(_io_immediate_T_12, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_4 = mux(_io_immediate_T_13, UInt<19>("h7ffff"), UInt<19>("h0")) @[Bitwise.scala 72:12]
    node _io_immediate_T_14 = cat(io_immediate_hi_4, io_immediate_lo_4) @[Cat.scala 30:58]
    node _io_func3_7_T_3 = bits(io_ins, 14, 12) @[CU.scala 203:29]
    node _T_37 = bits(io_ins, 6, 0) @[CU.scala 205:22]
    node _T_38 = eq(_T_37, UInt<7>("h6f")) @[CU.scala 205:28]
    node temp_hi_hi_hi_1 = bits(io_ins, 31, 31) @[CU.scala 208:31]
    node temp_hi_hi_lo_1 = bits(io_ins, 19, 12) @[CU.scala 208:42]
    node temp_hi_lo_1 = bits(io_ins, 20, 20) @[CU.scala 208:56]
    node temp_lo_hi_1 = bits(io_ins, 30, 21) @[CU.scala 208:67]
    node temp_lo_1 = cat(temp_lo_hi_1, UInt<1>("h0")) @[Cat.scala 30:58]
    node temp_hi_hi_1 = cat(temp_hi_hi_hi_1, temp_hi_hi_lo_1) @[Cat.scala 30:58]
    node temp_hi_1 = cat(temp_hi_hi_1, temp_hi_lo_1) @[Cat.scala 30:58]
    node io_immediate_lo_5 = cat(temp_hi_1, temp_lo_1) @[Cat.scala 30:58]
    node _io_immediate_T_15 = bits(io_immediate_lo_5, 20, 20) @[CU.scala 209:43]
    node _io_immediate_T_16 = bits(_io_immediate_T_15, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_5 = mux(_io_immediate_T_16, UInt<11>("h7ff"), UInt<11>("h0")) @[Bitwise.scala 72:12]
    node _io_immediate_T_17 = cat(io_immediate_hi_5, io_immediate_lo_5) @[Cat.scala 30:58]
    node _T_39 = bits(io_ins, 6, 0) @[CU.scala 213:22]
    node _T_40 = eq(_T_39, UInt<7>("h67")) @[CU.scala 213:28]
    node _io_immediate_T_18 = bits(io_ins, 31, 31) @[CU.scala 215:46]
    node _io_immediate_T_19 = bits(_io_immediate_T_18, 0, 0) @[Bitwise.scala 72:15]
    node io_immediate_hi_6 = mux(_io_immediate_T_19, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_immediate_lo_6 = bits(io_ins, 31, 20) @[CU.scala 215:60]
    node _io_immediate_T_20 = cat(io_immediate_hi_6, io_immediate_lo_6) @[Cat.scala 30:58]
    node _GEN_38 = mux(_T_40, _io_immediate_T_20, UInt<1>("h0")) @[CU.scala 214:5 CU.scala 215:22 CU.scala 67:18]
    node _GEN_39 = mux(_T_40, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 214:5 CU.scala 216:17 CU.scala 50:13]
    node _GEN_40 = mux(_T_40, UInt<1>("h0"), _io_func3_7_T) @[CU.scala 214:5 CU.scala 217:20 CU.scala 71:16]
    node _GEN_41 = mux(_T_38, _io_immediate_T_17, _GEN_38) @[CU.scala 206:5 CU.scala 209:22]
    node _GEN_42 = mux(_T_38, UInt<1>("h1"), _GEN_39) @[CU.scala 206:5 CU.scala 210:17]
    node _GEN_43 = mux(_T_38, UInt<1>("h0"), _GEN_40) @[CU.scala 206:5 CU.scala 211:21]
    node _GEN_44 = mux(_T_38, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 206:5 CU.scala 212:21 CU.scala 54:16]
    node _GEN_45 = mux(_T_38, UInt<1>("h0"), _GEN_39) @[CU.scala 206:5 CU.scala 56:16]
    node _GEN_46 = mux(_T_36, _io_immediate_T_14, _GEN_41) @[CU.scala 198:5 CU.scala 201:22]
    node _GEN_47 = mux(_T_36, UInt<1>("h0"), _GEN_42) @[CU.scala 198:5 CU.scala 202:17]
    node _GEN_48 = mux(_T_36, _io_func3_7_T_3, _GEN_43) @[CU.scala 198:5 CU.scala 203:20]
    node _GEN_49 = mux(_T_36, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 198:5 CU.scala 204:18 CU.scala 52:14]
    node _GEN_50 = mux(_T_36, UInt<1>("h0"), _GEN_44) @[CU.scala 198:5 CU.scala 54:16]
    node _GEN_51 = mux(_T_36, UInt<1>("h0"), _GEN_45) @[CU.scala 198:5 CU.scala 56:16]
    node _GEN_52 = mux(_T_34, _io_immediate_T_11, _GEN_46) @[CU.scala 193:5 CU.scala 194:22]
    node _GEN_53 = mux(_T_34, UInt<1>("h1"), _GEN_47) @[CU.scala 193:5 CU.scala 195:17]
    node _GEN_54 = mux(_T_34, UInt<1>("h0"), _GEN_48) @[CU.scala 193:5 CU.scala 196:20]
    node _GEN_55 = mux(_T_34, UInt<1>("h0"), _GEN_49) @[CU.scala 193:5 CU.scala 52:14]
    node _GEN_56 = mux(_T_34, UInt<1>("h0"), _GEN_50) @[CU.scala 193:5 CU.scala 54:16]
    node _GEN_57 = mux(_T_34, UInt<1>("h0"), _GEN_51) @[CU.scala 193:5 CU.scala 56:16]
    node _GEN_58 = mux(_T_32, _io_immediate_T_9, _GEN_52) @[CU.scala 188:5 CU.scala 189:22]
    node _GEN_59 = mux(_T_32, UInt<1>("h1"), _GEN_53) @[CU.scala 188:5 CU.scala 190:17]
    node _GEN_60 = mux(_T_32, UInt<1>("h0"), _GEN_54) @[CU.scala 188:5 CU.scala 191:20]
    node _GEN_61 = mux(_T_32, UInt<1>("h0"), _GEN_55) @[CU.scala 188:5 CU.scala 52:14]
    node _GEN_62 = mux(_T_32, UInt<1>("h0"), _GEN_56) @[CU.scala 188:5 CU.scala 54:16]
    node _GEN_63 = mux(_T_32, UInt<1>("h0"), _GEN_57) @[CU.scala 188:5 CU.scala 56:16]
    node _GEN_64 = mux(_T_15, _io_immediate_T_8, _GEN_58) @[CU.scala 104:5 CU.scala 106:22]
    node _GEN_65 = mux(_T_15, UInt<1>("h0"), _GEN_59) @[CU.scala 104:5 CU.scala 107:17]
    node _GEN_66 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 104:5 CU.scala 109:17 CU.scala 82:13]
    node _GEN_67 = mux(_T_15, _GEN_34, UInt<1>("h0")) @[CU.scala 104:5 CU.scala 58:20]
    node _GEN_68 = mux(_T_15, _GEN_35, UInt<1>("h0")) @[CU.scala 104:5 CU.scala 59:20]
    node _GEN_69 = mux(_T_15, _GEN_36, UInt<1>("h0")) @[CU.scala 104:5 CU.scala 60:20]
    node _GEN_70 = mux(_T_15, _GEN_37, UInt<1>("h0")) @[CU.scala 104:5 CU.scala 61:20]
    node _GEN_71 = mux(_T_15, _io_func3_7_T, _GEN_60) @[CU.scala 104:5 CU.scala 71:16]
    node _GEN_72 = mux(_T_15, UInt<1>("h0"), _GEN_61) @[CU.scala 104:5 CU.scala 52:14]
    node _GEN_73 = mux(_T_15, UInt<1>("h0"), _GEN_62) @[CU.scala 104:5 CU.scala 54:16]
    node _GEN_74 = mux(_T_15, UInt<1>("h0"), _GEN_63) @[CU.scala 104:5 CU.scala 56:16]
    node _GEN_75 = mux(_T_13, _io_immediate_T_5, _GEN_64) @[CU.scala 98:5 CU.scala 99:22]
    node _GEN_76 = mux(_T_13, UInt<1>("h1"), _GEN_65) @[CU.scala 98:5 CU.scala 100:17]
    node _GEN_77 = mux(_T_13, UInt<1>("h1"), _GEN_66) @[CU.scala 98:5 CU.scala 102:17]
    node _GEN_78 = mux(_T_13, UInt<1>("h0"), _GEN_66) @[CU.scala 98:5 CU.scala 81:16]
    node _GEN_79 = mux(_T_13, UInt<1>("h0"), _GEN_67) @[CU.scala 98:5 CU.scala 58:20]
    node _GEN_80 = mux(_T_13, UInt<1>("h0"), _GEN_68) @[CU.scala 98:5 CU.scala 59:20]
    node _GEN_81 = mux(_T_13, UInt<1>("h0"), _GEN_69) @[CU.scala 98:5 CU.scala 60:20]
    node _GEN_82 = mux(_T_13, UInt<1>("h0"), _GEN_70) @[CU.scala 98:5 CU.scala 61:20]
    node _GEN_83 = mux(_T_13, _io_func3_7_T, _GEN_71) @[CU.scala 98:5 CU.scala 71:16]
    node _GEN_84 = mux(_T_13, UInt<1>("h0"), _GEN_72) @[CU.scala 98:5 CU.scala 52:14]
    node _GEN_85 = mux(_T_13, UInt<1>("h0"), _GEN_73) @[CU.scala 98:5 CU.scala 54:16]
    node _GEN_86 = mux(_T_13, UInt<1>("h0"), _GEN_74) @[CU.scala 98:5 CU.scala 56:16]
    node _GEN_87 = mux(_T_3, UInt<1>("h1"), _GEN_76) @[CU.scala 88:5 CU.scala 89:17]
    node _GEN_88 = mux(_T_3, _io_immediate_T_2, _GEN_75) @[CU.scala 88:5 CU.scala 90:22]
    node _GEN_89 = mux(_T_3, _GEN_0, _GEN_83) @[CU.scala 88:5]
    node _GEN_90 = mux(_T_3, UInt<1>("h0"), _GEN_77) @[CU.scala 88:5 CU.scala 82:13]
    node _GEN_91 = mux(_T_3, UInt<1>("h0"), _GEN_78) @[CU.scala 88:5 CU.scala 81:16]
    node _GEN_92 = mux(_T_3, UInt<1>("h0"), _GEN_79) @[CU.scala 88:5 CU.scala 58:20]
    node _GEN_93 = mux(_T_3, UInt<1>("h0"), _GEN_80) @[CU.scala 88:5 CU.scala 59:20]
    node _GEN_94 = mux(_T_3, UInt<1>("h0"), _GEN_81) @[CU.scala 88:5 CU.scala 60:20]
    node _GEN_95 = mux(_T_3, UInt<1>("h0"), _GEN_82) @[CU.scala 88:5 CU.scala 61:20]
    node _GEN_96 = mux(_T_3, UInt<1>("h0"), _GEN_84) @[CU.scala 88:5 CU.scala 52:14]
    node _GEN_97 = mux(_T_3, UInt<1>("h0"), _GEN_85) @[CU.scala 88:5 CU.scala 54:16]
    node _GEN_98 = mux(_T_3, UInt<1>("h0"), _GEN_86) @[CU.scala 88:5 CU.scala 56:16]
    node _GEN_99 = mux(_T_1, UInt<1>("h1"), _GEN_87) @[CU.scala 84:5 CU.scala 85:17]
    node _GEN_100 = mux(_T_1, _io_func3_7_T_1, _GEN_89) @[CU.scala 84:5 CU.scala 86:20]
    node _GEN_101 = mux(_T_1, UInt<1>("h0"), _GEN_88) @[CU.scala 84:5 CU.scala 67:18]
    node _GEN_102 = mux(_T_1, UInt<1>("h0"), _GEN_90) @[CU.scala 84:5 CU.scala 82:13]
    node _GEN_103 = mux(_T_1, UInt<1>("h0"), _GEN_91) @[CU.scala 84:5 CU.scala 81:16]
    node _GEN_104 = mux(_T_1, UInt<1>("h0"), _GEN_92) @[CU.scala 84:5 CU.scala 58:20]
    node _GEN_105 = mux(_T_1, UInt<1>("h0"), _GEN_93) @[CU.scala 84:5 CU.scala 59:20]
    node _GEN_106 = mux(_T_1, UInt<1>("h0"), _GEN_94) @[CU.scala 84:5 CU.scala 60:20]
    node _GEN_107 = mux(_T_1, UInt<1>("h0"), _GEN_95) @[CU.scala 84:5 CU.scala 61:20]
    node _GEN_108 = mux(_T_1, UInt<1>("h0"), _GEN_96) @[CU.scala 84:5 CU.scala 52:14]
    node _GEN_109 = mux(_T_1, UInt<1>("h0"), _GEN_97) @[CU.scala 84:5 CU.scala 54:16]
    node _GEN_110 = mux(_T_1, UInt<1>("h0"), _GEN_98) @[CU.scala 84:5 CU.scala 56:16]
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

  module Top :
    input clock : Clock
    input reset : UInt<1>
    input io_ins : UInt<32>
    output io_inst_out : UInt<32>
    output io_out : SInt<32>

    inst imem_module of IMEM @[Top.scala 33:33]
    inst pc_module of PC @[Top.scala 34:33]
    inst register_module of RegisterFile @[Top.scala 35:33]
    inst alu_module of ALU @[Top.scala 36:33]
    inst dmem_module of DMEM @[Top.scala 37:33]
    inst cu_module of CU @[Top.scala 38:33]
    inst branch_module of Branch @[Top.scala 39:33]
    node _imem_module_io_address_T = asUInt(pc_module.io_out) @[Top.scala 52:50]
    reg again_ins : UInt<1>, clock with :
      reset => (UInt<1>("h0"), again_ins) @[Top.scala 60:28]
    node _T = bits(imem_module.io_dataOut, 6, 0) @[Top.scala 63:33]
    node _T_1 = eq(_T, UInt<5>("h17")) @[Top.scala 63:39]
    node _T_2 = eq(again_ins, UInt<1>("h0")) @[Top.scala 65:24]
    node _GEN_0 = mux(_T_2, UInt<1>("h1"), cu_module.io_jalr_en) @[Top.scala 66:9 Top.scala 67:37 Top.scala 53:29]
    node _GEN_1 = mux(_T_2, pc_module.io_out, asSInt(UInt<1>("h0"))) @[Top.scala 66:9 Top.scala 68:33 Top.scala 58:25]
    node _GEN_2 = mux(_T_1, _GEN_0, cu_module.io_jalr_en) @[Top.scala 64:5 Top.scala 53:29]
    node _GEN_3 = mux(_T_1, _GEN_1, asSInt(UInt<1>("h0"))) @[Top.scala 64:5 Top.scala 58:25]
    node _T_3 = eq(again_ins, UInt<1>("h1")) @[Top.scala 74:20]
    node _T_4 = bits(imem_module.io_dataOut, 6, 0) @[Top.scala 78:39]
    node _T_5 = eq(_T_4, UInt<5>("h17")) @[Top.scala 78:45]
    node _T_6 = eq(again_ins, UInt<1>("h0")) @[Top.scala 78:59]
    node _T_7 = and(_T_5, _T_6) @[Top.scala 78:56]
    node _GEN_4 = mux(_T_7, UInt<1>("h1"), again_ins) @[Top.scala 79:5 Top.scala 80:19 Top.scala 60:28]
    node _GEN_5 = mux(_T_3, UInt<1>("h0"), imem_module.io_dataOut) @[Top.scala 75:5 Top.scala 76:26 Top.scala 73:22]
    node _GEN_6 = mux(_T_3, again_ins, _GEN_4) @[Top.scala 75:5 Top.scala 60:28]
    node _T_8 = eq(cu_module.io_ins, UInt<1>("h0")) @[Top.scala 83:28]
    node _GEN_7 = mux(_T_8, UInt<1>("h0"), _GEN_6) @[Top.scala 84:5 Top.scala 85:19]
    node _T_9 = bits(imem_module.io_dataOut, 6, 0) @[Top.scala 98:32]
    node _T_10 = eq(_T_9, UInt<6>("h33")) @[Top.scala 98:38]
    node _T_11 = geq(register_module.io_rdata1, UInt<13>("h1000")) @[Top.scala 103:40]
    node _T_12 = bits(register_module.io_rdata2, 10, 10) @[Top.scala 103:78]
    node _T_13 = eq(_T_12, UInt<1>("h1")) @[Top.scala 103:83]
    node _T_14 = and(_T_11, _T_13) @[Top.scala 103:50]
    node _T_15 = bits(register_module.io_rdata1, 11, 11) @[Top.scala 107:45]
    node _T_16 = eq(_T_15, UInt<1>("h1")) @[Top.scala 107:50]
    node _T_17 = geq(register_module.io_rdata2, UInt<13>("h1000")) @[Top.scala 107:87]
    node _T_18 = and(_T_16, _T_17) @[Top.scala 107:58]
    node _alu_module_io_in_B_T = add(register_module.io_rdata2, UInt<1>("h1")) @[Top.scala 110:61]
    node _alu_module_io_in_B_T_1 = tail(_alu_module_io_in_B_T, 1) @[Top.scala 110:61]
    node _GEN_8 = mux(_T_18, register_module.io_rdata1, register_module.io_rdata1) @[Top.scala 108:9 Top.scala 109:32 Top.scala 100:28]
    node _GEN_9 = mux(_T_18, _alu_module_io_in_B_T_1, register_module.io_rdata2) @[Top.scala 108:9 Top.scala 110:32 Top.scala 101:28]
    node _GEN_10 = mux(_T_14, register_module.io_rdata1, _GEN_8) @[Top.scala 104:9 Top.scala 105:32]
    node _GEN_11 = mux(_T_14, register_module.io_rdata2, _GEN_9) @[Top.scala 104:9 Top.scala 106:32]
    node _T_19 = bits(imem_module.io_dataOut, 6, 0) @[Top.scala 113:38]
    node _T_20 = eq(_T_19, UInt<5>("h13")) @[Top.scala 113:45]
    node _GEN_12 = mux(_T_20, register_module.io_rdata1, UInt<1>("h0")) @[Top.scala 114:5 Top.scala 115:28 Top.scala 95:24]
    node _GEN_13 = mux(_T_20, cu_module.io_immediate, UInt<1>("h0")) @[Top.scala 114:5 Top.scala 116:28 Top.scala 96:24]
    node _GEN_14 = mux(_T_10, _GEN_10, _GEN_12) @[Top.scala 99:5]
    node _GEN_15 = mux(_T_10, _GEN_11, _GEN_13) @[Top.scala 99:5]
    node _T_21 = bits(imem_module.io_dataOut, 6, 0) @[Top.scala 144:32]
    node _T_22 = eq(_T_21, UInt<2>("h3")) @[Top.scala 144:38]
    node _T_23 = and(_T_22, again_ins) @[Top.scala 144:46]
    node _GEN_16 = mux(_T_23, UInt<1>("h0"), cu_module.io_w_en) @[Top.scala 145:5 Top.scala 146:32 Top.scala 143:28]
    node _T_24 = bits(cu_module.io_ins, 6, 0) @[Top.scala 162:26]
    node _T_25 = eq(_T_24, UInt<7>("h63")) @[Top.scala 162:32]
    node _GEN_17 = mux(_T_25, branch_module.io_br_taken, cu_module.io_unbr_en) @[Top.scala 163:5 Top.scala 164:30 Top.scala 159:26]
    node _T_26 = bits(cu_module.io_ins, 6, 0) @[Top.scala 168:26]
    node _T_27 = eq(_T_26, UInt<6>("h37")) @[Top.scala 168:32]
    node _T_28 = bits(cu_module.io_ins, 6, 0) @[Top.scala 172:32]
    node _T_29 = eq(_T_28, UInt<5>("h17")) @[Top.scala 172:38]
    node _alu_module_io_in_A_T = asUInt(pc_module.io_out) @[Top.scala 174:50]
    node _alu_module_io_in_A_T_1 = asUInt(pc_module.io_out) @[Top.scala 185:50]
    node _pc_module_io_br_imm_T = asSInt(alu_module.io_out) @[Top.scala 188:52]
    node _T_30 = bits(cu_module.io_ins, 6, 0) @[Top.scala 190:32]
    node _T_31 = eq(_T_30, UInt<7>("h6f")) @[Top.scala 190:38]
    node _alu_module_io_in_A_T_2 = asUInt(pc_module.io_out) @[Top.scala 192:50]
    node _pc_module_io_br_imm_T_1 = asSInt(alu_module.io_out) @[Top.scala 195:54]
    node _register_module_io_wdata_T = asUInt(pc_module.io_out) @[Top.scala 198:56]
    node _register_module_io_wdata_T_1 = add(_register_module_io_wdata_T, UInt<3>("h4")) @[Top.scala 198:63]
    node _register_module_io_wdata_T_2 = tail(_register_module_io_wdata_T_1, 1) @[Top.scala 198:63]
    node _T_32 = bits(cu_module.io_ins, 6, 0) @[Top.scala 199:32]
    node _T_33 = eq(_T_32, UInt<7>("h67")) @[Top.scala 199:38]
    node _pc_module_io_br_imm_T_2 = asSInt(alu_module.io_out) @[Top.scala 204:52]
    node _GEN_18 = mux(_T_33, UInt<1>("h0"), cu_module.io_func3_7) @[Top.scala 200:5 Top.scala 209:30 Top.scala 93:26]
    node _GEN_19 = mux(_T_33, register_module.io_rdata1, _GEN_14) @[Top.scala 200:5 Top.scala 202:28]
    node _GEN_20 = mux(_T_33, cu_module.io_immediate, _GEN_15) @[Top.scala 200:5 Top.scala 203:28]
    node _GEN_21 = mux(_T_33, _pc_module_io_br_imm_T_2, _GEN_3) @[Top.scala 200:5 Top.scala 204:29]
    node _GEN_22 = mux(_T_33, cu_module.io_jalr_en, _GEN_2) @[Top.scala 200:5 Top.scala 206:33]
    node _GEN_23 = mux(_T_33, alu_module.io_out, alu_module.io_out) @[Top.scala 200:5 Top.scala 211:34 Top.scala 149:30]
    node _GEN_24 = mux(_T_31, _alu_module_io_in_A_T_2, _GEN_19) @[Top.scala 191:5 Top.scala 192:28]
    node _GEN_25 = mux(_T_31, cu_module.io_immediate, _GEN_20) @[Top.scala 191:5 Top.scala 193:28]
    node _GEN_26 = mux(_T_31, UInt<1>("h0"), _GEN_18) @[Top.scala 191:5 Top.scala 194:30]
    node _GEN_27 = mux(_T_31, _pc_module_io_br_imm_T_1, _GEN_21) @[Top.scala 191:5 Top.scala 195:31]
    node _GEN_28 = mux(_T_31, _register_module_io_wdata_T_2, _GEN_23) @[Top.scala 191:5 Top.scala 198:34]
    node _GEN_29 = mux(_T_31, _GEN_2, _GEN_22) @[Top.scala 191:5]
    node _GEN_30 = mux(branch_module.io_br_ins, branch_module.io_br_taken, _GEN_17) @[Top.scala 178:5 Top.scala 179:30]
    node _GEN_31 = mux(branch_module.io_br_ins, _alu_module_io_in_A_T_1, _GEN_24) @[Top.scala 178:5 Top.scala 185:28]
    node _GEN_32 = mux(branch_module.io_br_ins, cu_module.io_immediate, _GEN_25) @[Top.scala 178:5 Top.scala 186:28]
    node _GEN_33 = mux(branch_module.io_br_ins, UInt<1>("h0"), _GEN_26) @[Top.scala 178:5 Top.scala 187:30]
    node _GEN_34 = mux(branch_module.io_br_ins, _pc_module_io_br_imm_T, _GEN_27) @[Top.scala 178:5 Top.scala 188:29]
    node _GEN_35 = mux(branch_module.io_br_ins, alu_module.io_out, _GEN_28) @[Top.scala 178:5 Top.scala 149:30]
    node _GEN_36 = mux(branch_module.io_br_ins, _GEN_2, _GEN_29) @[Top.scala 178:5]
    node _GEN_37 = mux(_T_29, _alu_module_io_in_A_T, _GEN_31) @[Top.scala 173:5 Top.scala 174:28]
    node _GEN_38 = mux(_T_29, cu_module.io_immediate, _GEN_32) @[Top.scala 173:5 Top.scala 175:28]
    node _GEN_39 = mux(_T_29, alu_module.io_out, _GEN_35) @[Top.scala 173:5 Top.scala 176:34]
    node _GEN_40 = mux(_T_29, _GEN_17, _GEN_30) @[Top.scala 173:5]
    node _GEN_41 = mux(_T_29, cu_module.io_func3_7, _GEN_33) @[Top.scala 173:5 Top.scala 93:26]
    node _GEN_42 = mux(_T_29, _GEN_3, _GEN_34) @[Top.scala 173:5]
    node _GEN_43 = mux(_T_29, _GEN_2, _GEN_36) @[Top.scala 173:5]
    node _GEN_44 = mux(_T_27, cu_module.io_immediate, _GEN_39) @[Top.scala 169:5 Top.scala 171:34]
    node _GEN_45 = mux(_T_27, _GEN_14, _GEN_37) @[Top.scala 169:5]
    node _GEN_46 = mux(_T_27, _GEN_15, _GEN_38) @[Top.scala 169:5]
    node _GEN_47 = mux(_T_27, _GEN_17, _GEN_40) @[Top.scala 169:5]
    node _GEN_48 = mux(_T_27, cu_module.io_func3_7, _GEN_41) @[Top.scala 169:5 Top.scala 93:26]
    node _GEN_49 = mux(_T_27, _GEN_3, _GEN_42) @[Top.scala 169:5]
    node _GEN_50 = mux(_T_27, _GEN_2, _GEN_43) @[Top.scala 169:5]
    node _cu_module_io_dmem_addr2_T = bits(alu_module.io_out, 1, 0) @[Top.scala 218:51]
    node _T_34 = bits(cu_module.io_ins, 6, 0) @[Top.scala 232:26]
    node _T_35 = eq(_T_34, UInt<6>("h23")) @[Top.scala 232:32]
    node temp_addr = bits(alu_module.io_out, 11, 2) @[Top.scala 238:42]
    node _dmem_module_io_addr_T = bits(alu_module.io_out, 11, 2) @[Top.scala 242:49]
    node _T_36 = bits(cu_module.io_ins, 14, 12) @[Top.scala 247:30]
    node _T_37 = eq(_T_36, UInt<1>("h0")) @[Top.scala 247:38]
    node _dmem_module_io_dataIn_0_T = bits(register_module.io_rdata2, 7, 0) @[Top.scala 274:66]
    node _dmem_module_io_dataIn_1_T = bits(register_module.io_rdata2, 7, 0) @[Top.scala 275:66]
    node _dmem_module_io_dataIn_2_T = bits(register_module.io_rdata2, 7, 0) @[Top.scala 276:66]
    node _dmem_module_io_dataIn_3_T = bits(register_module.io_rdata2, 7, 0) @[Top.scala 277:66]
    node _T_38 = bits(cu_module.io_ins, 14, 12) @[Top.scala 281:36]
    node _T_39 = eq(_T_38, UInt<1>("h1")) @[Top.scala 281:44]
    node _T_40 = eq(cu_module.io_dmem_addr2, UInt<1>("h0")) @[Top.scala 283:42]
    node _dmem_module_io_dataIn_0_T_1 = bits(register_module.io_rdata2, 7, 0) @[Top.scala 287:70]
    node _dmem_module_io_dataIn_1_T_1 = bits(register_module.io_rdata2, 15, 8) @[Top.scala 288:70]
    node _T_41 = eq(cu_module.io_dmem_addr2, UInt<1>("h1")) @[Top.scala 292:48]
    node _dmem_module_io_dataIn_1_T_2 = bits(register_module.io_rdata2, 7, 0) @[Top.scala 296:70]
    node _dmem_module_io_dataIn_2_T_1 = bits(register_module.io_rdata2, 15, 8) @[Top.scala 297:70]
    node _T_42 = eq(cu_module.io_dmem_addr2, UInt<2>("h2")) @[Top.scala 299:48]
    node _dmem_module_io_dataIn_2_T_2 = bits(register_module.io_rdata2, 7, 0) @[Top.scala 303:70]
    node _dmem_module_io_dataIn_3_T_1 = bits(register_module.io_rdata2, 15, 8) @[Top.scala 304:70]
    node _T_43 = eq(cu_module.io_dmem_addr2, UInt<2>("h3")) @[Top.scala 307:48]
    node _dmem_module_io_dataIn_3_T_2 = bits(register_module.io_rdata2, 7, 0) @[Top.scala 311:70]
    node _dmem_module_io_addr_T_1 = add(temp_addr, UInt<1>("h1")) @[Top.scala 312:50]
    node _dmem_module_io_addr_T_2 = tail(_dmem_module_io_addr_T_1, 1) @[Top.scala 312:50]
    node _dmem_module_io_dataIn_0_T_2 = bits(register_module.io_rdata2, 15, 8) @[Top.scala 313:70]
    node _GEN_51 = mux(_T_43, _dmem_module_io_dataIn_3_T_2, UInt<1>("h0")) @[Top.scala 308:13 Top.scala 311:42 Top.scala 222:30]
    node _GEN_52 = mux(_T_43, _dmem_module_io_addr_T_2, _dmem_module_io_addr_T) @[Top.scala 308:13 Top.scala 312:37 Top.scala 242:29]
    node _GEN_53 = mux(_T_43, _dmem_module_io_dataIn_0_T_2, UInt<1>("h0")) @[Top.scala 308:13 Top.scala 313:42 Top.scala 219:30]
    node _GEN_54 = mux(_T_42, _dmem_module_io_dataIn_2_T_2, UInt<1>("h0")) @[Top.scala 300:13 Top.scala 303:42 Top.scala 221:30]
    node _GEN_55 = mux(_T_42, _dmem_module_io_dataIn_3_T_1, _GEN_51) @[Top.scala 300:13 Top.scala 304:42]
    node _GEN_56 = mux(_T_42, _dmem_module_io_addr_T, _GEN_52) @[Top.scala 300:13 Top.scala 242:29]
    node _GEN_57 = mux(_T_42, UInt<1>("h0"), _GEN_53) @[Top.scala 300:13 Top.scala 219:30]
    node _GEN_58 = mux(_T_41, _dmem_module_io_dataIn_1_T_2, UInt<1>("h0")) @[Top.scala 293:13 Top.scala 296:42 Top.scala 220:30]
    node _GEN_59 = mux(_T_41, _dmem_module_io_dataIn_2_T_1, _GEN_54) @[Top.scala 293:13 Top.scala 297:42]
    node _GEN_60 = mux(_T_41, UInt<1>("h0"), _GEN_55) @[Top.scala 293:13 Top.scala 222:30]
    node _GEN_61 = mux(_T_41, _dmem_module_io_addr_T, _GEN_56) @[Top.scala 293:13 Top.scala 242:29]
    node _GEN_62 = mux(_T_41, UInt<1>("h0"), _GEN_57) @[Top.scala 293:13 Top.scala 219:30]
    node _GEN_63 = mux(_T_40, _dmem_module_io_dataIn_0_T_1, _GEN_62) @[Top.scala 284:13 Top.scala 287:42]
    node _GEN_64 = mux(_T_40, _dmem_module_io_dataIn_1_T_1, _GEN_58) @[Top.scala 284:13 Top.scala 288:42]
    node _GEN_65 = mux(_T_40, UInt<1>("h0"), _GEN_59) @[Top.scala 284:13 Top.scala 221:30]
    node _GEN_66 = mux(_T_40, UInt<1>("h0"), _GEN_60) @[Top.scala 284:13 Top.scala 222:30]
    node _GEN_67 = mux(_T_40, _dmem_module_io_addr_T, _GEN_61) @[Top.scala 284:13 Top.scala 242:29]
    node _T_44 = bits(cu_module.io_ins, 14, 12) @[Top.scala 321:36]
    node _T_45 = eq(_T_44, UInt<2>("h2")) @[Top.scala 321:44]
    node _T_46 = eq(cu_module.io_dmem_addr2, UInt<1>("h0")) @[Top.scala 323:42]
    node _dmem_module_io_dataIn_0_T_3 = bits(register_module.io_rdata2, 7, 0) @[Top.scala 327:70]
    node _dmem_module_io_dataIn_1_T_3 = bits(register_module.io_rdata2, 15, 8) @[Top.scala 328:70]
    node _dmem_module_io_dataIn_2_T_3 = bits(register_module.io_rdata2, 23, 16) @[Top.scala 329:70]
    node _dmem_module_io_dataIn_3_T_3 = bits(register_module.io_rdata2, 31, 24) @[Top.scala 330:70]
    node _T_47 = eq(cu_module.io_dmem_addr2, UInt<1>("h1")) @[Top.scala 334:48]
    node _dmem_module_io_dataIn_1_T_4 = bits(register_module.io_rdata2, 7, 0) @[Top.scala 337:70]
    node _dmem_module_io_dataIn_2_T_4 = bits(register_module.io_rdata2, 15, 8) @[Top.scala 338:70]
    node _dmem_module_io_dataIn_3_T_4 = bits(register_module.io_rdata2, 23, 16) @[Top.scala 339:70]
    node _dmem_module_io_addr_T_3 = add(temp_addr, UInt<1>("h1")) @[Top.scala 340:50]
    node _dmem_module_io_addr_T_4 = tail(_dmem_module_io_addr_T_3, 1) @[Top.scala 340:50]
    node _dmem_module_io_dataIn_0_T_4 = bits(register_module.io_rdata2, 31, 24) @[Top.scala 341:70]
    node _T_48 = eq(cu_module.io_dmem_addr2, UInt<2>("h2")) @[Top.scala 347:48]
    node _dmem_module_io_dataIn_2_T_5 = bits(register_module.io_rdata2, 7, 0) @[Top.scala 350:70]
    node _dmem_module_io_dataIn_3_T_5 = bits(register_module.io_rdata2, 15, 8) @[Top.scala 351:70]
    node _dmem_module_io_addr_T_5 = add(temp_addr, UInt<1>("h1")) @[Top.scala 352:50]
    node _dmem_module_io_addr_T_6 = tail(_dmem_module_io_addr_T_5, 1) @[Top.scala 352:50]
    node _dmem_module_io_dataIn_0_T_5 = bits(register_module.io_rdata2, 23, 16) @[Top.scala 353:70]
    node _dmem_module_io_dataIn_1_T_5 = bits(register_module.io_rdata2, 31, 24) @[Top.scala 354:70]
    node _T_49 = eq(cu_module.io_dmem_addr2, UInt<2>("h3")) @[Top.scala 360:48]
    node _dmem_module_io_dataIn_3_T_6 = bits(register_module.io_rdata2, 7, 0) @[Top.scala 363:70]
    node _dmem_module_io_addr_T_7 = add(temp_addr, UInt<1>("h1")) @[Top.scala 364:50]
    node _dmem_module_io_addr_T_8 = tail(_dmem_module_io_addr_T_7, 1) @[Top.scala 364:50]
    node _dmem_module_io_dataIn_0_T_6 = bits(register_module.io_rdata2, 15, 8) @[Top.scala 365:70]
    node _dmem_module_io_dataIn_1_T_6 = bits(register_module.io_rdata2, 23, 16) @[Top.scala 366:70]
    node _dmem_module_io_dataIn_2_T_6 = bits(register_module.io_rdata2, 31, 24) @[Top.scala 367:70]
    node _GEN_68 = mux(_T_49, _dmem_module_io_dataIn_3_T_6, UInt<1>("h0")) @[Top.scala 360:56 Top.scala 363:42 Top.scala 222:30]
    node _GEN_69 = mux(_T_49, _dmem_module_io_addr_T_8, _dmem_module_io_addr_T) @[Top.scala 360:56 Top.scala 364:37 Top.scala 242:29]
    node _GEN_70 = mux(_T_49, _dmem_module_io_dataIn_0_T_6, UInt<1>("h0")) @[Top.scala 360:56 Top.scala 365:42 Top.scala 219:30]
    node _GEN_71 = mux(_T_49, _dmem_module_io_dataIn_1_T_6, UInt<1>("h0")) @[Top.scala 360:56 Top.scala 366:42 Top.scala 220:30]
    node _GEN_72 = mux(_T_49, _dmem_module_io_dataIn_2_T_6, UInt<1>("h0")) @[Top.scala 360:56 Top.scala 367:42 Top.scala 221:30]
    node _GEN_73 = mux(_T_48, _dmem_module_io_dataIn_2_T_5, _GEN_72) @[Top.scala 347:56 Top.scala 350:42]
    node _GEN_74 = mux(_T_48, _dmem_module_io_dataIn_3_T_5, _GEN_68) @[Top.scala 347:56 Top.scala 351:42]
    node _GEN_75 = mux(_T_48, _dmem_module_io_addr_T_6, _GEN_69) @[Top.scala 347:56 Top.scala 352:37]
    node _GEN_76 = mux(_T_48, _dmem_module_io_dataIn_0_T_5, _GEN_70) @[Top.scala 347:56 Top.scala 353:42]
    node _GEN_77 = mux(_T_48, _dmem_module_io_dataIn_1_T_5, _GEN_71) @[Top.scala 347:56 Top.scala 354:42]
    node _GEN_78 = mux(_T_47, _dmem_module_io_dataIn_1_T_4, _GEN_77) @[Top.scala 334:56 Top.scala 337:42]
    node _GEN_79 = mux(_T_47, _dmem_module_io_dataIn_2_T_4, _GEN_73) @[Top.scala 334:56 Top.scala 338:42]
    node _GEN_80 = mux(_T_47, _dmem_module_io_dataIn_3_T_4, _GEN_74) @[Top.scala 334:56 Top.scala 339:42]
    node _GEN_81 = mux(_T_47, _dmem_module_io_addr_T_4, _GEN_75) @[Top.scala 334:56 Top.scala 340:37]
    node _GEN_82 = mux(_T_47, _dmem_module_io_dataIn_0_T_4, _GEN_76) @[Top.scala 334:56 Top.scala 341:42]
    node _GEN_83 = mux(_T_46, _dmem_module_io_dataIn_0_T_3, _GEN_82) @[Top.scala 324:13 Top.scala 327:42]
    node _GEN_84 = mux(_T_46, _dmem_module_io_dataIn_1_T_3, _GEN_78) @[Top.scala 324:13 Top.scala 328:42]
    node _GEN_85 = mux(_T_46, _dmem_module_io_dataIn_2_T_3, _GEN_79) @[Top.scala 324:13 Top.scala 329:42]
    node _GEN_86 = mux(_T_46, _dmem_module_io_dataIn_3_T_3, _GEN_80) @[Top.scala 324:13 Top.scala 330:42]
    node _GEN_87 = mux(_T_46, _dmem_module_io_addr_T, _GEN_81) @[Top.scala 324:13 Top.scala 242:29]
    node _GEN_88 = mux(_T_45, _GEN_83, UInt<1>("h0")) @[Top.scala 322:9 Top.scala 219:30]
    node _GEN_89 = mux(_T_45, _GEN_84, UInt<1>("h0")) @[Top.scala 322:9 Top.scala 220:30]
    node _GEN_90 = mux(_T_45, _GEN_85, UInt<1>("h0")) @[Top.scala 322:9 Top.scala 221:30]
    node _GEN_91 = mux(_T_45, _GEN_86, UInt<1>("h0")) @[Top.scala 322:9 Top.scala 222:30]
    node _GEN_92 = mux(_T_45, _GEN_87, _dmem_module_io_addr_T) @[Top.scala 322:9 Top.scala 242:29]
    node _GEN_93 = mux(_T_39, _GEN_63, _GEN_88) @[Top.scala 282:9]
    node _GEN_94 = mux(_T_39, _GEN_64, _GEN_89) @[Top.scala 282:9]
    node _GEN_95 = mux(_T_39, _GEN_65, _GEN_90) @[Top.scala 282:9]
    node _GEN_96 = mux(_T_39, _GEN_66, _GEN_91) @[Top.scala 282:9]
    node _GEN_97 = mux(_T_39, _GEN_67, _GEN_92) @[Top.scala 282:9]
    node _GEN_98 = mux(_T_37, _dmem_module_io_dataIn_0_T, _GEN_93) @[Top.scala 248:9 Top.scala 274:38]
    node _GEN_99 = mux(_T_37, _dmem_module_io_dataIn_1_T, _GEN_94) @[Top.scala 248:9 Top.scala 275:38]
    node _GEN_100 = mux(_T_37, _dmem_module_io_dataIn_2_T, _GEN_95) @[Top.scala 248:9 Top.scala 276:38]
    node _GEN_101 = mux(_T_37, _dmem_module_io_dataIn_3_T, _GEN_96) @[Top.scala 248:9 Top.scala 277:38]
    node _GEN_102 = mux(_T_37, _dmem_module_io_addr_T, _GEN_97) @[Top.scala 248:9 Top.scala 242:29]
    node _GEN_103 = mux(_T_35, UInt<1>("h0"), _GEN_48) @[Top.scala 233:5 Top.scala 234:30]
    node _GEN_104 = mux(_T_35, cu_module.io_immediate, _GEN_45) @[Top.scala 233:5 Top.scala 235:28]
    node _GEN_105 = mux(_T_35, register_module.io_rdata1, _GEN_46) @[Top.scala 233:5 Top.scala 236:28]
    node _GEN_106 = mux(_T_35, _GEN_102, UInt<1>("h0")) @[Top.scala 233:5 Top.scala 122:25]
    node _GEN_107 = mux(_T_35, cu_module.io_mask_val_0, UInt<1>("h0")) @[Top.scala 233:5 Top.scala 243:29 Top.scala 225:28]
    node _GEN_108 = mux(_T_35, cu_module.io_mask_val_1, UInt<1>("h0")) @[Top.scala 233:5 Top.scala 243:29 Top.scala 226:28]
    node _GEN_109 = mux(_T_35, cu_module.io_mask_val_2, UInt<1>("h0")) @[Top.scala 233:5 Top.scala 243:29 Top.scala 227:28]
    node _GEN_110 = mux(_T_35, cu_module.io_mask_val_3, UInt<1>("h0")) @[Top.scala 233:5 Top.scala 243:29 Top.scala 228:28]
    node _GEN_111 = mux(_T_35, _GEN_98, UInt<1>("h0")) @[Top.scala 233:5 Top.scala 219:30]
    node _GEN_112 = mux(_T_35, _GEN_99, UInt<1>("h0")) @[Top.scala 233:5 Top.scala 220:30]
    node _GEN_113 = mux(_T_35, _GEN_100, UInt<1>("h0")) @[Top.scala 233:5 Top.scala 221:30]
    node _GEN_114 = mux(_T_35, _GEN_101, UInt<1>("h0")) @[Top.scala 233:5 Top.scala 222:30]
    node _T_50 = bits(cu_module.io_ins, 6, 0) @[Top.scala 386:26]
    node _T_51 = eq(_T_50, UInt<2>("h3")) @[Top.scala 386:32]
    node _dmem_module_io_addr_T_9 = bits(alu_module.io_out, 11, 2) @[Top.scala 394:52]
    node next_address = bits(alu_module.io_out, 11, 2) @[Top.scala 395:45]
    node _T_52 = eq(cu_module.io_func3_7, UInt<1>("h0")) @[Top.scala 398:35]
    node _T_53 = eq(cu_module.io_dmem_addr2, UInt<1>("h0")) @[Top.scala 401:42]
    node lb_num = asSInt(dmem_module.io_dataOut_0) @[Top.scala 404:59]
    node _register_module_io_wdata_T_3 = bits(lb_num, 7, 7) @[Top.scala 405:65]
    node _register_module_io_wdata_T_4 = bits(_register_module_io_wdata_T_3, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi = mux(_register_module_io_wdata_T_4, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node register_module_io_wdata_lo = asUInt(lb_num) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_5 = cat(register_module_io_wdata_hi, register_module_io_wdata_lo) @[Cat.scala 30:58]
    node _T_54 = eq(cu_module.io_dmem_addr2, UInt<1>("h1")) @[Top.scala 407:48]
    node lb_num_1 = asSInt(dmem_module.io_dataOut_1) @[Top.scala 410:59]
    node _register_module_io_wdata_T_6 = bits(lb_num_1, 7, 7) @[Top.scala 411:65]
    node _register_module_io_wdata_T_7 = bits(_register_module_io_wdata_T_6, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_1 = mux(_register_module_io_wdata_T_7, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node register_module_io_wdata_lo_1 = asUInt(lb_num_1) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_8 = cat(register_module_io_wdata_hi_1, register_module_io_wdata_lo_1) @[Cat.scala 30:58]
    node _T_55 = eq(cu_module.io_dmem_addr2, UInt<2>("h2")) @[Top.scala 413:48]
    node lb_num_2 = asSInt(dmem_module.io_dataOut_2) @[Top.scala 416:59]
    node _register_module_io_wdata_T_9 = bits(lb_num_2, 7, 7) @[Top.scala 417:65]
    node _register_module_io_wdata_T_10 = bits(_register_module_io_wdata_T_9, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_2 = mux(_register_module_io_wdata_T_10, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node register_module_io_wdata_lo_2 = asUInt(lb_num_2) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_11 = cat(register_module_io_wdata_hi_2, register_module_io_wdata_lo_2) @[Cat.scala 30:58]
    node _T_56 = eq(cu_module.io_dmem_addr2, UInt<2>("h3")) @[Top.scala 419:48]
    node lb_num_3 = asSInt(dmem_module.io_dataOut_3) @[Top.scala 422:59]
    node _register_module_io_wdata_T_12 = bits(lb_num_3, 7, 7) @[Top.scala 423:65]
    node _register_module_io_wdata_T_13 = bits(_register_module_io_wdata_T_12, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_3 = mux(_register_module_io_wdata_T_13, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node register_module_io_wdata_lo_3 = asUInt(lb_num_3) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_14 = cat(register_module_io_wdata_hi_3, register_module_io_wdata_lo_3) @[Cat.scala 30:58]
    node _GEN_115 = mux(_T_56, _register_module_io_wdata_T_14, _GEN_44) @[Top.scala 420:13 Top.scala 423:42]
    node _GEN_116 = mux(_T_55, _register_module_io_wdata_T_11, _GEN_115) @[Top.scala 414:13 Top.scala 417:42]
    node _GEN_117 = mux(_T_54, _register_module_io_wdata_T_8, _GEN_116) @[Top.scala 408:13 Top.scala 411:42]
    node _GEN_118 = mux(_T_53, _register_module_io_wdata_T_5, _GEN_117) @[Top.scala 402:13 Top.scala 405:42]
    node _T_57 = eq(cu_module.io_func3_7, UInt<1>("h1")) @[Top.scala 428:40]
    node _T_58 = eq(cu_module.io_dmem_addr2, UInt<1>("h0")) @[Top.scala 432:42]
    node _lh_num_T = cat(dmem_module.io_dataOut_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node lh_num = asSInt(_lh_num_T) @[Top.scala 434:90]
    node _register_module_io_wdata_T_15 = bits(lh_num, 15, 15) @[Top.scala 436:65]
    node _register_module_io_wdata_T_16 = bits(_register_module_io_wdata_T_15, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_4 = mux(_register_module_io_wdata_T_16, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node register_module_io_wdata_lo_4 = asUInt(lh_num) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_17 = cat(register_module_io_wdata_hi_4, register_module_io_wdata_lo_4) @[Cat.scala 30:58]
    node _T_59 = eq(cu_module.io_dmem_addr2, UInt<1>("h1")) @[Top.scala 438:48]
    node _lh_num_T_1 = cat(dmem_module.io_dataOut_2, dmem_module.io_dataOut_1) @[Cat.scala 30:58]
    node lh_num_1 = asSInt(_lh_num_T_1) @[Top.scala 440:90]
    node _register_module_io_wdata_T_18 = bits(lh_num_1, 15, 15) @[Top.scala 442:65]
    node _register_module_io_wdata_T_19 = bits(_register_module_io_wdata_T_18, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_5 = mux(_register_module_io_wdata_T_19, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node register_module_io_wdata_lo_5 = asUInt(lh_num_1) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_20 = cat(register_module_io_wdata_hi_5, register_module_io_wdata_lo_5) @[Cat.scala 30:58]
    node _T_60 = eq(cu_module.io_dmem_addr2, UInt<2>("h2")) @[Top.scala 444:48]
    node _lh_num_T_2 = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node lh_num_2 = asSInt(_lh_num_T_2) @[Top.scala 446:90]
    node _register_module_io_wdata_T_21 = bits(lh_num_2, 15, 15) @[Top.scala 448:65]
    node _register_module_io_wdata_T_22 = bits(_register_module_io_wdata_T_21, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_6 = mux(_register_module_io_wdata_T_22, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node register_module_io_wdata_lo_6 = asUInt(lh_num_2) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_23 = cat(register_module_io_wdata_hi_6, register_module_io_wdata_lo_6) @[Cat.scala 30:58]
    node _T_61 = eq(cu_module.io_dmem_addr2, UInt<2>("h3")) @[Top.scala 450:48]
    node _dmem_module_io_addr_T_10 = add(next_address, UInt<1>("h1")) @[Top.scala 453:53]
    node _dmem_module_io_addr_T_11 = tail(_dmem_module_io_addr_T_10, 1) @[Top.scala 453:53]
    node _lh_num2_T = cat(dmem_module.io_dataOut_0, dmem_module.io_dataOut_3) @[Cat.scala 30:58]
    node lh_num2 = asSInt(_lh_num2_T) @[Top.scala 454:71]
    node _register_module_io_wdata_T_24 = bits(lh_num2, 15, 15) @[Top.scala 455:66]
    node _register_module_io_wdata_T_25 = bits(_register_module_io_wdata_T_24, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_7 = mux(_register_module_io_wdata_T_25, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node register_module_io_wdata_lo_7 = asUInt(lh_num2) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_26 = cat(register_module_io_wdata_hi_7, register_module_io_wdata_lo_7) @[Cat.scala 30:58]
    node _GEN_119 = mux(_T_61, _dmem_module_io_addr_T_11, _dmem_module_io_addr_T_9) @[Top.scala 451:13 Top.scala 453:37 Top.scala 394:32]
    node _GEN_120 = mux(_T_61, _register_module_io_wdata_T_26, _GEN_44) @[Top.scala 451:13 Top.scala 455:42]
    node _GEN_121 = mux(_T_60, _register_module_io_wdata_T_23, _GEN_120) @[Top.scala 445:13 Top.scala 448:42]
    node _GEN_122 = mux(_T_60, _dmem_module_io_addr_T_9, _GEN_119) @[Top.scala 445:13 Top.scala 394:32]
    node _GEN_123 = mux(_T_59, _register_module_io_wdata_T_20, _GEN_121) @[Top.scala 439:13 Top.scala 442:42]
    node _GEN_124 = mux(_T_59, _dmem_module_io_addr_T_9, _GEN_122) @[Top.scala 439:13 Top.scala 394:32]
    node _GEN_125 = mux(_T_58, _register_module_io_wdata_T_17, _GEN_123) @[Top.scala 433:13 Top.scala 436:42]
    node _GEN_126 = mux(_T_58, _dmem_module_io_addr_T_9, _GEN_124) @[Top.scala 433:13 Top.scala 394:32]
    node _T_62 = eq(cu_module.io_func3_7, UInt<2>("h2")) @[Top.scala 464:40]
    node _T_63 = eq(cu_module.io_dmem_addr2, UInt<1>("h0")) @[Top.scala 468:42]
    node lw_num_lo = cat(dmem_module.io_dataOut_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node lw_num_hi = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node _lw_num_T = cat(lw_num_hi, lw_num_lo) @[Cat.scala 30:58]
    node lw_num = asSInt(_lw_num_T) @[Top.scala 471:73]
    node _register_module_io_wdata_T_27 = asUInt(lw_num) @[Top.scala 472:52]
    node _T_64 = eq(cu_module.io_dmem_addr2, UInt<1>("h1")) @[Top.scala 475:48]
    node lw_num_hi_1 = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node register_module_io_wdata_lo_8 = cat(lw_num_hi_1, dmem_module.io_dataOut_1) @[Cat.scala 30:58]
    node _dmem_module_io_addr_T_12 = add(next_address, UInt<1>("h1")) @[Top.scala 478:53]
    node _dmem_module_io_addr_T_13 = tail(_dmem_module_io_addr_T_12, 1) @[Top.scala 478:53]
    node _register_module_io_wdata_T_28 = cat(dmem_module.io_dataOut_0, register_module_io_wdata_lo_8) @[Cat.scala 30:58]
    node _T_65 = eq(cu_module.io_dmem_addr2, UInt<2>("h2")) @[Top.scala 485:48]
    node register_module_io_wdata_lo_9 = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node _dmem_module_io_addr_T_14 = add(next_address, UInt<1>("h1")) @[Top.scala 488:53]
    node _dmem_module_io_addr_T_15 = tail(_dmem_module_io_addr_T_14, 1) @[Top.scala 488:53]
    node register_module_io_wdata_hi_8 = cat(dmem_module.io_dataOut_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_29 = cat(register_module_io_wdata_hi_8, register_module_io_wdata_lo_9) @[Cat.scala 30:58]
    node _T_66 = eq(cu_module.io_dmem_addr2, UInt<2>("h3")) @[Top.scala 494:48]
    node _dmem_module_io_addr_T_16 = add(next_address, UInt<1>("h1")) @[Top.scala 497:53]
    node _dmem_module_io_addr_T_17 = tail(_dmem_module_io_addr_T_16, 1) @[Top.scala 497:53]
    node register_module_io_wdata_lo_10 = cat(dmem_module.io_dataOut_0, dmem_module.io_dataOut_3) @[Cat.scala 30:58]
    node register_module_io_wdata_hi_9 = cat(dmem_module.io_dataOut_2, dmem_module.io_dataOut_1) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_30 = cat(register_module_io_wdata_hi_9, register_module_io_wdata_lo_10) @[Cat.scala 30:58]
    node _GEN_127 = mux(_T_66, _dmem_module_io_addr_T_17, _dmem_module_io_addr_T_9) @[Top.scala 495:13 Top.scala 497:37 Top.scala 394:32]
    node _GEN_128 = mux(_T_66, _register_module_io_wdata_T_30, _GEN_44) @[Top.scala 495:13 Top.scala 498:42]
    node _GEN_129 = mux(_T_65, _dmem_module_io_addr_T_15, _GEN_127) @[Top.scala 486:13 Top.scala 488:37]
    node _GEN_130 = mux(_T_65, _register_module_io_wdata_T_29, _GEN_128) @[Top.scala 486:13 Top.scala 489:42]
    node _GEN_131 = mux(_T_64, _dmem_module_io_addr_T_13, _GEN_129) @[Top.scala 476:13 Top.scala 478:37]
    node _GEN_132 = mux(_T_64, _register_module_io_wdata_T_28, _GEN_130) @[Top.scala 476:13 Top.scala 479:42]
    node _GEN_133 = mux(_T_63, _register_module_io_wdata_T_27, _GEN_132) @[Top.scala 469:13 Top.scala 472:42]
    node _GEN_134 = mux(_T_63, _dmem_module_io_addr_T_9, _GEN_131) @[Top.scala 469:13 Top.scala 394:32]
    node _T_67 = eq(cu_module.io_func3_7, UInt<3>("h4")) @[Top.scala 507:40]
    node _T_68 = eq(cu_module.io_dmem_addr2, UInt<1>("h0")) @[Top.scala 509:42]
    node _register_module_io_wdata_T_31 = bits(dmem_module.io_dataOut_0, 7, 7) @[Top.scala 512:66]
    node _register_module_io_wdata_T_32 = bits(_register_module_io_wdata_T_31, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_10 = mux(_register_module_io_wdata_T_32, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _register_module_io_wdata_T_33 = cat(register_module_io_wdata_hi_10, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node _T_69 = eq(cu_module.io_dmem_addr2, UInt<1>("h1")) @[Top.scala 517:48]
    node _register_module_io_wdata_T_34 = bits(dmem_module.io_dataOut_1, 7, 7) @[Top.scala 520:66]
    node _register_module_io_wdata_T_35 = bits(_register_module_io_wdata_T_34, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_11 = mux(_register_module_io_wdata_T_35, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _register_module_io_wdata_T_36 = cat(register_module_io_wdata_hi_11, dmem_module.io_dataOut_1) @[Cat.scala 30:58]
    node _T_70 = eq(cu_module.io_dmem_addr2, UInt<2>("h2")) @[Top.scala 525:48]
    node _register_module_io_wdata_T_37 = bits(dmem_module.io_dataOut_2, 7, 7) @[Top.scala 528:66]
    node _register_module_io_wdata_T_38 = bits(_register_module_io_wdata_T_37, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_12 = mux(_register_module_io_wdata_T_38, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _register_module_io_wdata_T_39 = cat(register_module_io_wdata_hi_12, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node _T_71 = eq(cu_module.io_dmem_addr2, UInt<2>("h3")) @[Top.scala 533:48]
    node _register_module_io_wdata_T_40 = bits(dmem_module.io_dataOut_3, 7, 7) @[Top.scala 536:66]
    node _register_module_io_wdata_T_41 = bits(_register_module_io_wdata_T_40, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_13 = mux(_register_module_io_wdata_T_41, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _register_module_io_wdata_T_42 = cat(register_module_io_wdata_hi_13, dmem_module.io_dataOut_3) @[Cat.scala 30:58]
    node _GEN_135 = mux(_T_71, _register_module_io_wdata_T_42, _GEN_44) @[Top.scala 534:13 Top.scala 536:42]
    node _GEN_136 = mux(_T_70, _register_module_io_wdata_T_39, _GEN_135) @[Top.scala 526:13 Top.scala 528:42]
    node _GEN_137 = mux(_T_69, _register_module_io_wdata_T_36, _GEN_136) @[Top.scala 518:13 Top.scala 520:42]
    node _GEN_138 = mux(_T_68, _register_module_io_wdata_T_33, _GEN_137) @[Top.scala 510:13 Top.scala 512:42]
    node _T_72 = eq(cu_module.io_func3_7, UInt<3>("h5")) @[Top.scala 546:40]
    node _T_73 = eq(cu_module.io_dmem_addr2, UInt<1>("h0")) @[Top.scala 548:42]
    node register_module_io_wdata_lo_11 = cat(dmem_module.io_dataOut_1, dmem_module.io_dataOut_0) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_43 = bits(register_module_io_wdata_lo_11, 15, 15) @[Top.scala 551:66]
    node _register_module_io_wdata_T_44 = bits(_register_module_io_wdata_T_43, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_14 = mux(_register_module_io_wdata_T_44, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node _register_module_io_wdata_T_45 = cat(register_module_io_wdata_hi_14, register_module_io_wdata_lo_11) @[Cat.scala 30:58]
    node _T_74 = eq(cu_module.io_dmem_addr2, UInt<1>("h1")) @[Top.scala 556:48]
    node register_module_io_wdata_lo_12 = cat(dmem_module.io_dataOut_2, dmem_module.io_dataOut_1) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_46 = bits(register_module_io_wdata_lo_12, 15, 15) @[Top.scala 559:66]
    node _register_module_io_wdata_T_47 = bits(_register_module_io_wdata_T_46, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_15 = mux(_register_module_io_wdata_T_47, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node _register_module_io_wdata_T_48 = cat(register_module_io_wdata_hi_15, register_module_io_wdata_lo_12) @[Cat.scala 30:58]
    node _T_75 = eq(cu_module.io_dmem_addr2, UInt<2>("h2")) @[Top.scala 564:48]
    node register_module_io_wdata_lo_13 = cat(dmem_module.io_dataOut_3, dmem_module.io_dataOut_2) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_49 = bits(register_module_io_wdata_lo_13, 15, 15) @[Top.scala 567:66]
    node _register_module_io_wdata_T_50 = bits(_register_module_io_wdata_T_49, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_16 = mux(_register_module_io_wdata_T_50, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node _register_module_io_wdata_T_51 = cat(register_module_io_wdata_hi_16, register_module_io_wdata_lo_13) @[Cat.scala 30:58]
    node _T_76 = eq(cu_module.io_dmem_addr2, UInt<2>("h3")) @[Top.scala 572:48]
    node _dmem_module_io_addr_T_18 = add(next_address, UInt<1>("h1")) @[Top.scala 575:53]
    node _dmem_module_io_addr_T_19 = tail(_dmem_module_io_addr_T_18, 1) @[Top.scala 575:53]
    node register_module_io_wdata_lo_14 = cat(dmem_module.io_dataOut_0, dmem_module.io_dataOut_3) @[Cat.scala 30:58]
    node _register_module_io_wdata_T_52 = bits(register_module_io_wdata_lo_14, 15, 15) @[Top.scala 577:66]
    node _register_module_io_wdata_T_53 = bits(_register_module_io_wdata_T_52, 0, 0) @[Bitwise.scala 72:15]
    node register_module_io_wdata_hi_17 = mux(_register_module_io_wdata_T_53, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node _register_module_io_wdata_T_54 = cat(register_module_io_wdata_hi_17, register_module_io_wdata_lo_14) @[Cat.scala 30:58]
    node _GEN_139 = mux(_T_76, _dmem_module_io_addr_T_19, _dmem_module_io_addr_T_9) @[Top.scala 573:13 Top.scala 575:37 Top.scala 394:32]
    node _GEN_140 = mux(_T_76, _register_module_io_wdata_T_54, _GEN_44) @[Top.scala 573:13 Top.scala 577:42]
    node _GEN_141 = mux(_T_75, _register_module_io_wdata_T_51, _GEN_140) @[Top.scala 565:13 Top.scala 567:42]
    node _GEN_142 = mux(_T_75, _dmem_module_io_addr_T_9, _GEN_139) @[Top.scala 565:13 Top.scala 394:32]
    node _GEN_143 = mux(_T_74, _register_module_io_wdata_T_48, _GEN_141) @[Top.scala 557:13 Top.scala 559:42]
    node _GEN_144 = mux(_T_74, _dmem_module_io_addr_T_9, _GEN_142) @[Top.scala 557:13 Top.scala 394:32]
    node _GEN_145 = mux(_T_73, _register_module_io_wdata_T_45, _GEN_143) @[Top.scala 549:13 Top.scala 551:42]
    node _GEN_146 = mux(_T_73, _dmem_module_io_addr_T_9, _GEN_144) @[Top.scala 549:13 Top.scala 394:32]
    node _GEN_147 = mux(_T_72, _GEN_145, _GEN_44) @[Top.scala 547:9]
    node _GEN_148 = mux(_T_72, _GEN_146, _dmem_module_io_addr_T_9) @[Top.scala 547:9 Top.scala 394:32]
    node _GEN_149 = mux(_T_67, _GEN_138, _GEN_147) @[Top.scala 508:9]
    node _GEN_150 = mux(_T_67, _dmem_module_io_addr_T_9, _GEN_148) @[Top.scala 508:9 Top.scala 394:32]
    node _GEN_151 = mux(_T_62, _GEN_133, _GEN_149) @[Top.scala 465:9]
    node _GEN_152 = mux(_T_62, _GEN_134, _GEN_150) @[Top.scala 465:9]
    node _GEN_153 = mux(_T_57, _GEN_125, _GEN_151) @[Top.scala 429:9]
    node _GEN_154 = mux(_T_57, _GEN_126, _GEN_152) @[Top.scala 429:9]
    node _GEN_155 = mux(_T_52, _GEN_118, _GEN_153) @[Top.scala 399:9]
    node _GEN_156 = mux(_T_52, _dmem_module_io_addr_T_9, _GEN_154) @[Top.scala 399:9 Top.scala 394:32]
    node _GEN_157 = mux(_T_51, UInt<1>("h0"), _GEN_103) @[Top.scala 387:5 Top.scala 389:30]
    node _GEN_158 = mux(_T_51, cu_module.io_immediate, _GEN_104) @[Top.scala 387:5 Top.scala 390:28]
    node _GEN_159 = mux(_T_51, register_module.io_rdata1, _GEN_105) @[Top.scala 387:5 Top.scala 391:28]
    node _GEN_160 = mux(_T_51, _GEN_156, _GEN_106) @[Top.scala 387:5]
    node _GEN_161 = mux(_T_51, _GEN_155, _GEN_44) @[Top.scala 387:5]
    node _io_out_T = asSInt(register_module.io_wdata) @[Top.scala 593:42]
    io_inst_out <= io_ins @[Top.scala 55:17]
    io_out <= _io_out_T @[Top.scala 593:12]
    imem_module.clock <= clock
    imem_module.reset <= reset
    imem_module.io_address <= _imem_module_io_address_T @[Top.scala 52:28]
    imem_module.io_dataIn <= io_inst_out @[Top.scala 56:27]
    imem_module.io_wen <= cu_module.io_imem_en @[Top.scala 45:24]
    pc_module.clock <= clock
    pc_module.reset <= reset
    pc_module.io_en_jump <= _GEN_47
    pc_module.io_br_imm <= _GEN_49
    pc_module.io_jalr_en_pc <= _GEN_50
    register_module.clock <= clock
    register_module.reset <= reset
    register_module.io_raddr1 <= cu_module.io_rs1 @[Top.scala 90:31]
    register_module.io_raddr2 <= cu_module.io_rs2 @[Top.scala 91:31]
    register_module.io_wen <= _GEN_16
    register_module.io_waddr <= cu_module.io_rd @[Top.scala 148:30]
    register_module.io_wdata <= _GEN_161
    alu_module.clock <= clock
    alu_module.reset <= reset
    alu_module.io_in_A <= _GEN_158
    alu_module.io_in_B <= _GEN_159
    alu_module.io_alu_Op <= _GEN_157
    dmem_module.clock <= clock
    dmem_module.reset <= reset
    dmem_module.io_addr <= _GEN_160
    dmem_module.io_rd_enable <= cu_module.io_r_en @[Top.scala 123:30]
    dmem_module.io_wr_enable <= cu_module.io_dmem_en @[Top.scala 215:30]
    dmem_module.io_mask_0 <= _GEN_107
    dmem_module.io_mask_1 <= _GEN_108
    dmem_module.io_mask_2 <= _GEN_109
    dmem_module.io_mask_3 <= _GEN_110
    dmem_module.io_dataIn_0 <= _GEN_111
    dmem_module.io_dataIn_1 <= _GEN_112
    dmem_module.io_dataIn_2 <= _GEN_113
    dmem_module.io_dataIn_3 <= _GEN_114
    cu_module.clock <= clock
    cu_module.reset <= reset
    cu_module.io_ins <= imem_module.io_dataOut @[Top.scala 88:22]
    cu_module.io_dmem_addr2 <= _cu_module_io_dmem_addr2_T @[Top.scala 218:29]
    branch_module.clock <= clock
    branch_module.reset <= reset
    branch_module.io_func3 <= bits(cu_module.io_func3_7, 2, 0) @[Top.scala 151:28]
    branch_module.io_br_ins <= cu_module.io_br_en @[Top.scala 152:29]
    branch_module.io_inpA <= register_module.io_rdata1 @[Top.scala 154:27]
    branch_module.io_inpB <= register_module.io_rdata2 @[Top.scala 155:27]
    again_ins <= mux(reset, UInt<1>("h0"), _GEN_7) @[Top.scala 60:28 Top.scala 60:28]
