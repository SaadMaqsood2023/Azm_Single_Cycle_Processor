package DataPathPipeline

import chisel3._
import chisel3.util._

class Memory extends Module 
{
    // In memory we are 
    val io = IO( new Bundle {
        val mem_mask_addr2      = Input(UInt(2.W))       // 2 Bit address for selecting bytes of memory address
        
        val mem_opcode          = Input(UInt(7.W))
        val mem_datainput       = Input(Vec(4,UInt(8.W))) // rdata2, Taking data as input from register file for data memory, Store
        val mem_rdata1          = Input(UInt(32.W))
        val mem_rd_enable       = Input(Bool())
        val mem_dmem_enable       = Input(Bool()) 
        val mem_mask_val        = Input(Vec(4, Bool()))  // value of mask from control unit of decode
        val mem_func3_7         = Input(UInt(4.W))
        // val mem_cu_immediate    = Input(UInt(32.W))
        val mem_alu_out         = Input(UInt(32.W))      // Taking Input of Address calculated from ALU
        // val mem_dataOut         = Input(Vec(4, UInt(8.W)))
        
        // val dmem_addr           = Output(UInt(10.W))
        // val mem_dataIn          = Output(Vec(4, UInt(8.W)))    // Giving the data from the register file to data memory, Store
        // val mem_alu_in_A        = Output(UInt(32.W))
        val mem_alu_in_B        = Output(UInt(32.W))
        val mem_alu_Op          = Output(UInt(4.W))
        val mem_dataOut         = Output(UInt(32.W))      // Output will be given to the write back module
    })
    // Data memory instance
    val dmem_module = Module(new DMEM)

    dmem_module.io.rd_enable    := io.mem_rd_enable
    dmem_module.io.wr_enable    := io.mem_dmem_enable
    dmem_module.io.mask         := io.mem_mask_val

    // dmem_module.io.wr_enable := cu_module.io.dmem_en  // Write enable for DMEM
    
    // From register file to DMEM (store instruction)
    // io.mem_mask_addr2 := (io.mem_alu_out)(1,0)-    
    dmem_module.io.dataIn(0) := 0.U
    dmem_module.io.dataIn(1) := 0.U
    dmem_module.io.dataIn(2) := 0.U
    dmem_module.io.dataIn(3) := 0.U
    // io.mem_dataIn := 0.U

    io.mem_dataOut   := 0.U
    
    // dmem_module.io.mask(0) :=  0.B
    // dmem_module.io.mask(1) :=  0.B
    // dmem_module.io.mask(2) :=  0.B
    // dmem_module.io.mask(3) :=  0.B                               //
    
    // dmem_module.io.mask :=  0.B
    // Default value for the Outputs
    io.mem_alu_Op       := 0.U
    // io.mem_alu_in_A     := 0.U
    io.mem_alu_in_B     := 0.U
    dmem_module.io.addr := 0.U   // Address of Data Memory where data will stored and also retrieved

                                // STORE INSTRUCTION
    // when(cu_module.io.ins(6,0) === "b0100011".U)   //Store Instruction
    when(io.mem_opcode === "h23".U)
    {
        io.mem_alu_Op := 0.U                          // Calculating address in store instruction
        // io.mem_alu_in_A := io.mem_cu_immediate
        io.mem_alu_in_B := io.mem_rdata1  // write according to S-format
        // val temp_addr   = Cat( Fill( 2,(io.mem_alu_out)(31) ), (io.mem_alu_out)(31,2) )
        val temp_addr = io.mem_alu_out(11,2)

        // val store_address = RegInit(0.U(32.W))
        // store_address := io.mem_alu_out(11,2)
        dmem_module.io.addr := io.mem_alu_out(11,2)
        // Masking value from CU to data memory
        // dmem_module.io.mask := cu_module.io.mask_val

        // dmem_module.io.mask :=  cu_module.io.mask_val(3) ## cu_module.io.mask_val(2) ## cu_module.io.mask_val(1) ## cu_module.io.mask_val(0)
        
        when(io.mem_func3_7 === 0.U)             // Func3 
        {
            // when(io.mem_mask_addr2 === 0.U)   // Store Byte
            // {
            //     dmem_module.io.dataIn(0) := io.mem_datainput(7,0)
            //     dmem_module.io.dataIn(1) := 0.U
            //     dmem_module.io.dataIn(2) := 0.U
            //     dmem_module.io.dataIn(3) := 0.U
            // }.elsewhen(io.mem_mask_addr2 === 1.U)
            // {
            //     dmem_module.io.dataIn(0) := 0.U
            //     dmem_module.io.dataIn(1) := io.mem_datainput(7,0)
            //     dmem_module.io.dataIn(2) := 0.U
            //     dmem_module.io.dataIn(3) := 0.U
            // }.elsewhen(io.mem_mask_addr2 === 2.U)
            // {
            //     dmem_module.io.dataIn(0) := 0.U
            //     dmem_module.io.dataIn(1) := 0.U
            //     dmem_module.io.dataIn(2) := io.mem_datainput(7,0)
            //     dmem_module.io.dataIn(3) := 0.U
            // }.elsewhen(io.mem_mask_addr2 === 3.U)
            // {
            //     dmem_module.io.dataIn(0) := 0.U
            //     dmem_module.io.dataIn(1) := 0.U
            //     dmem_module.io.dataIn(2) := 0.U
            //     dmem_module.io.dataIn(3) := io.mem_datainput(7,0)
            // }
            dmem_module.io.dataIn(0) := io.mem_datainput(0)
            dmem_module.io.dataIn(1) := io.mem_datainput(0)
            dmem_module.io.dataIn(2) := io.mem_datainput(0)
            dmem_module.io.dataIn(3) := io.mem_datainput(0)

            // io.mem_dataIn := io.mem_datainput(7,0) ## io.mem_datainput(7,0) ## io.mem_datainput(7,0) ## io.mem_datainput(7,0)

        }.elsewhen(io.mem_func3_7 === 1.U)  // Store Half
        {
            when(io.mem_mask_addr2 === 0.U)
            {
                // As storing a half word requires 2 bytes so we use 2 bytes 
                // for storing in the given address
                dmem_module.io.dataIn(0) := io.mem_datainput(0)
                dmem_module.io.dataIn(1) := io.mem_datainput(1)

                // io.mem_dataIn := Fill(16 ,0.U) ## io.mem_datainput(15,8) ## io.mem_datainput(7,0)  // 15,0

            }.elsewhen(io.mem_mask_addr2 === 1.U)
            {
                // As storing a half word requires 2 bytes so we use 2 bytes 
                // for storing in the given address
                dmem_module.io.dataIn(1) := io.mem_datainput(1)
                dmem_module.io.dataIn(2) := io.mem_datainput(2)
                // io.mem_dataIn := Fill(8 ,0.U) ## io.mem_datainput(15,8) ## io.mem_datainput(7,0) ## Fill(8 ,0.U) // (23,8)
            }.elsewhen(io.mem_mask_addr2 === 2.U)
            {
                // As storing a half word requires 2 bytes so we use 2 bytes 
                // for storing in the given address
                dmem_module.io.dataIn(2) := io.mem_datainput(2)
                dmem_module.io.dataIn(3) := io.mem_datainput(3)   

                // io.mem_dataIn := io.mem_datainput(15,8) ## io.mem_datainput(7,0) ## Fill(16 ,0.U)  //(31,16)
            }.elsewhen(io.mem_mask_addr2 === 3.U)
            {
                // As storing a half word requires 2 bytes so we use 2 bytes 
                // for storing in the given address
                dmem_module.io.dataIn(3) := io.mem_datainput(3)
                dmem_module.io.addr := temp_addr + 1.U
                dmem_module.io.dataIn(0) := io.mem_datainput(0)   

                // io.mem_dataIn := io.mem_datainput(7,0) ## Fill(24 ,0.U)  // (31, 24)
                // dmem_module.io.addr := temp_addr + 1.U
                // io.mem_dataIn := Fill(24 ,0.U) ## io.mem_datainput(15,8)  // (7,0)
                
            }

        }.elsewhen(io.mem_func3_7 === 2.U)  // Store word
        {
            when(io.mem_mask_addr2 === 0.U)
            {
                // As storing a word requires 4 bytes so we use only first 4 bytes 
                // for storing in any given address
                dmem_module.io.dataIn(0) := io.mem_datainput(0) 
                dmem_module.io.dataIn(1) := io.mem_datainput(1)   
                dmem_module.io.dataIn(2) := io.mem_datainput(2)
                dmem_module.io.dataIn(3) := io.mem_datainput(3)

                // io.mem_dataIn := io.mem_datainput

            }.elsewhen(io.mem_mask_addr2 === 1.U){                        
                // As storing a word requires 4 bytes so we use 4 bytes 
                // for storing in the given address
                dmem_module.io.dataIn(1) := io.mem_datainput(1) 
                dmem_module.io.dataIn(2) := io.mem_datainput(2)   
                dmem_module.io.dataIn(3) := io.mem_datainput(3)
                dmem_module.io.addr := temp_addr + 1.U
                dmem_module.io.dataIn(0) := io.mem_datainput(0)

                // io.mem_dataIn :=  io.mem_datainput(31,8) ## Fill(8, 0.U)   // (31, 8)
                // dmem_module.io.addr := temp_addr + 1.U
                // io.mem_dataIn := Fill(24, 0.U) ## io.mem_datainput(31,24)  //(7,0)

            }.elsewhen(io.mem_mask_addr2 === 2.U){                        
                // As storing a word requires 4 bytes so we use 4 bytes 
                // for storing in the given address
                dmem_module.io.dataIn(2) := io.mem_datainput(2) 
                dmem_module.io.dataIn(3) := io.mem_datainput(3)   
                dmem_module.io.addr := temp_addr + 1.U
                dmem_module.io.dataIn(0) := io.mem_datainput(0)
                dmem_module.io.dataIn(1) := io.mem_datainput(1)

                // io.mem_dataIn := io.mem_datainput(15,0) ## Fill(16, 0.U) // (31,16)
                // dmem_module.io.addr := temp_addr + 1.U
                // io.mem_dataIn := Fill(16, 0.U) ## io.mem_datainput(31,16)  // (15,0)

            }.elsewhen(io.mem_mask_addr2 === 3.U){                        
                // As storing a word requires 4 bytes so we use 4 bytes 
                // for storing in the given address
                dmem_module.io.dataIn(3) := io.mem_datainput(3) 
                dmem_module.io.addr := temp_addr + 1.U
                dmem_module.io.dataIn(0) := io.mem_datainput(0)  
                dmem_module.io.dataIn(1) := io.mem_datainput(1)
                dmem_module.io.dataIn(2) := io.mem_datainput(2)

                // io.mem_dataIn := io.mem_datainput(7, 0) ## Fill(24, 0.U) // (31,24) Where we are assigning the bits
                // dmem_module.io.addr := temp_addr + 1.U
                // io.mem_dataIn := Fill(8, 0.U) ## io.mem_datainput(31,8)
            }

        }


        
        
    }




    // io.wb_out := Mux(wb_en, io.wb_in, 0.U)


    // Setting data of register according to func3 of Load instruction
    // From DMEM to register file (load instruction using masking)
    // mistakes: check dmem vector width, address calculation, func3 assignment, dmem_addr2 calculation
    // when(cu_module.io.ins(6,0) === 3.U)
    // io.mem_dataOut := 0.U
                                    
                                    // LOAD INSTRUCTION
                                    
    when(io.mem_opcode === 3.U)
    {
        // Using ALU to calculate load address
        io.mem_alu_Op        := 0.U
        // io.mem_alu_in_A      := io.mem_cu_immediate
        io.mem_alu_in_B      := io.mem_rdata1
        // val address_load = RegInit(0.U(32.W))
        // address_load := io.mem_alu_out(11,2)
        dmem_module.io.addr         := io.mem_alu_out(11,2)
        val next_address      = io.mem_alu_out(11,2)
        // dmem_module.io.addr :=  io.mem_alu_out(11,2)
        
        when(io.mem_func3_7 === 0.U)   // Load Byte
        {// Loading a 8-bit signed num, so while using it, use asSInt
            // When dmem_addr2 is 0 which means our data is in first block of memory(memory has four blocks)
            when(io.mem_mask_addr2 === 0.U)
            {   // used .asSInt because of signed value
                // val lb_num = (dmem_module.io.dataOut(7,0) ).asSInt
                val lb_num     = (dmem_module.io.dataOut(0) ).asSInt
                io.mem_dataOut := Cat( Fill(24, lb_num(7) ) , lb_num ).asUInt 

            }.elsewhen(io.mem_mask_addr2 === 1.U)
            {
                // val lb_num   = (dmem_module.io.dataOut(15,8) ).asSInt
                val lb_num     = (dmem_module.io.dataOut(1) ).asSInt
                io.mem_dataOut := Cat( Fill(24, lb_num(7)) , lb_num ).asUInt

            }.elsewhen(io.mem_mask_addr2 === 2.U)
            {
                // val lb_num   = (dmem_module.io.dataOut(23,16) ).asSInt
                val lb_num     = (dmem_module.io.dataOut(2) ).asSInt
                io.mem_dataOut := Cat( Fill(24, lb_num(7)) , lb_num ).asUInt

            }.elsewhen(io.mem_mask_addr2 === 3.U)
            {
                // val lb_num = (dmem_module.io.dataOut(31, 24) ).asSInt
                val lb_num     = (dmem_module.io.dataOut(3) ).asSInt
                io.mem_dataOut := Cat( Fill(24, lb_num(7)) , lb_num ).asUInt

            }
            
        }
        .elsewhen(io.mem_func3_7 === 1.U)   // Load Half word
        {// Loading a 16-bit signed num, so while using it, use asSInt
            // When dmem_addr2 is 0 which means our data is in first and second blocks of memory

            when(io.mem_mask_addr2 === 0.U)
            {
                val lh_num     = Cat(dmem_module.io.dataOut(1) , dmem_module.io.dataOut(0) ).asSInt
                // val lh_num = Cat(dmem_module.io.dataOut(15,0) ).asSInt
                io.mem_dataOut := Cat( Fill(16, lh_num(15)) , lh_num ).asUInt

            }.elsewhen(io.mem_mask_addr2 === 1.U)
            {
                val lh_num     = Cat(dmem_module.io.dataOut(2) , dmem_module.io.dataOut(1) ).asSInt
                // val lh_num = Cat(dmem_module.io.dataOut(23,8) ).asSInt
                io.mem_dataOut := Cat( Fill(16, lh_num(15)) , lh_num ).asUInt
                
            }.elsewhen(io.mem_mask_addr2 === 2.U)
            {
                val lh_num     = Cat(dmem_module.io.dataOut(3) , dmem_module.io.dataOut(2) ).asSInt
                // val lh_num = Cat(dmem_module.io.dataOut(31,16) ).asSInt
                io.mem_dataOut := Cat( Fill(16, lh_num(15)) , lh_num ).asUInt
                
            }.elsewhen(io.mem_mask_addr2 === 3.U)
            {
                val lh_num           = dmem_module.io.dataOut(3)
                dmem_module.io.addr := next_address + 1.U
                val lh_num2          = Cat( dmem_module.io.dataOut(0), lh_num).asSInt
                io.mem_dataOut       := Cat( Fill(16, lh_num2(15)) , lh_num2 ).asUInt

                // val lh_num = dmem_module.io.dataOut(31,24)
                // dmem_module.io.addr := next_address + 1.U
                // val lh_num2 = Cat( dmem_module.io.dataOut(7,0), lh_num).asSInt
                // io.mem_dataOut := Cat( Fill(16, lh_num2(15)) , lh_num2 ).asUInt
                
            }
        }
        .elsewhen(io.mem_func3_7 === 2.U)
        {// Loading a 32-bit signed num, so while using it, use asSInt
            // For now whatever the address is, we have build the logic that 
            // for every lw bits will be stored from 0th block to 3rd block
            when(io.mem_mask_addr2 === 0.U)
            {
                val lw_num     = Cat(dmem_module.io.dataOut(3) , dmem_module.io.dataOut(2),
                dmem_module.io.dataOut(1) , dmem_module.io.dataOut(0) ).asSInt
                io.mem_dataOut := lw_num.asUInt

                // io.mem_dataOut := dmem_module.io.dataOut
            }.elsewhen(io.mem_mask_addr2 === 1.U)
            {
                val lw_num           = Cat(dmem_module.io.dataOut(2),dmem_module.io.dataOut(1),dmem_module.io.dataOut(0))
                dmem_module.io.addr := next_address + 1.U
                io.mem_dataOut       := Cat( dmem_module.io.dataOut(3) ,lw_num)

                // val lw_num = Cat(dmem_module.io.dataOut(23,8))
                // dmem_module.io.addr := next_address + 1.U
                // io.mem_dataOut := Cat( dmem_module.io.dataOut(7,0) ,lw_num)

            }.elsewhen(io.mem_mask_addr2 === 2.U)
            {
                val lw_num           = Cat(dmem_module.io.dataOut(1),dmem_module.io.dataOut(0))
                dmem_module.io.addr := next_address + 1.U
                io.mem_dataOut       := Cat(dmem_module.io.dataOut(3), dmem_module.io.dataOut(2) ,lw_num)

                // val lw_num = Cat(dmem_module.io.dataOut(31,16))
                // dmem_module.io.addr := next_address + 1.U
                // io.mem_dataOut := Cat(dmem_module.io.dataOut(15,0),lw_num)
            }.elsewhen(io.mem_mask_addr2 === 3.U)
            {
                val lw_num           = dmem_module.io.dataOut(0)
                dmem_module.io.addr := next_address + 1.U
                io.mem_dataOut       := Cat(dmem_module.io.dataOut(3), dmem_module.io.dataOut(2), dmem_module.io.dataOut(1), lw_num)

                // val lw_num = dmem_module.io.dataOut(31,24)
                // dmem_module.io.addr := next_address + 1.U
                // io.mem_dataOut := Cat(dmem_module.io.dataOut(23,0), lw_num)
            }


        }
        .elsewhen(io.mem_func3_7 === 4.U)  // Load Byte Unsigned
        {
            when(io.mem_mask_addr2 === 0.U)
            {   
                val lbu_num    = (dmem_module.io.dataOut(0) )
                io.mem_dataOut := Cat( Fill(24, lbu_num(7)) , lbu_num ).asUInt

                // val lbu_num = (dmem_module.io.dataOut(7,0) )
                // io.mem_dataOut := Cat( Fill(24, lbu_num(7) ) , lbu_num ).asUInt 

            }.elsewhen(io.mem_mask_addr2 === 1.U)
            {
                val lbu_num    = (dmem_module.io.dataOut(1) )
                io.mem_dataOut := Cat( Fill(24, lbu_num(7)) , lbu_num ).asUInt

                // val lb_num = (dmem_module.io.dataOut(15,8) )
                // io.mem_dataOut := Cat( Fill(24, lb_num(7)) , lb_num ).asUInt

            }.elsewhen(io.mem_mask_addr2 === 2.U)
            {
                val lbu_num    = (dmem_module.io.dataOut(2) )
                io.mem_dataOut := Cat( Fill(24, lbu_num(7)) , lbu_num ).asUInt

                // val lb_num = (dmem_module.io.dataOut(23,16) )
                // io.mem_dataOut := Cat( Fill(24, lb_num(7)) , lb_num ).asUInt

            }.elsewhen(io.mem_mask_addr2 === 3.U)
            {
                val lbu_num    = (dmem_module.io.dataOut(3) )
                io.mem_dataOut := Cat( Fill(24, lbu_num(7)) , lbu_num ).asUInt

                // val lb_num = (dmem_module.io.dataOut(31, 24) )
                // io.mem_dataOut := Cat( Fill(24, lb_num(7)) , lb_num ).asUInt

            }

            // val lbu_num    = dmem_module.io.dataOut(0)
            // io.mem_dataOut := lbu_num.asUInt
        }
        .elsewhen(io.mem_func3_7 === 5.U)    // Load Half unsigned
        {
            when(io.mem_mask_addr2 === 0.U)
            {
                val lhu_num    = Cat(dmem_module.io.dataOut(1) , dmem_module.io.dataOut(0) )
                io.mem_dataOut := Cat( Fill(16, lhu_num(15)) , lhu_num ).asUInt

                // val lh_num = Cat(dmem_module.io.dataOut(15,0) )
                // io.mem_dataOut := Cat( Fill(16, lh_num(15)) , lh_num ).asUInt

            }.elsewhen(io.mem_mask_addr2 === 1.U)
            {
                val lhu_num    = Cat(dmem_module.io.dataOut(2) , dmem_module.io.dataOut(1) )
                io.mem_dataOut := Cat( Fill(16, lhu_num(15)) , lhu_num ).asUInt

                // val lh_num = Cat(dmem_module.io.dataOut(23,8) ).asSInt
                // io.mem_dataOut := Cat( Fill(16, lh_num(15)) , lh_num ).asUInt
                
            }.elsewhen(io.mem_mask_addr2 === 2.U)
            {
                val lhu_num    = Cat(dmem_module.io.dataOut(3) , dmem_module.io.dataOut(2) )
                io.mem_dataOut := Cat( Fill(16, lhu_num(15)) , lhu_num ).asUInt

                // val lh_num = Cat(dmem_module.io.dataOut(31,16) ).asSInt
                // io.mem_dataOut := Cat( Fill(16, lh_num(15)) , lh_num ).asUInt
                
            }.elsewhen(io.mem_mask_addr2 === 3.U)
            {
                val lh_num           = dmem_module.io.dataOut(3)
                dmem_module.io.addr := next_address + 1.U
                val lh_num2          = Cat( dmem_module.io.dataOut(0), lh_num)
                io.mem_dataOut       := Cat( Fill(16, lh_num2(15)) , lh_num2 ).asUInt

                // val lh_num = dmem_module.io.dataOut(31,24)
                // dmem_module.io.addr := next_address + 1.U
                // val lh_num2 = Cat( dmem_module.io.dataOut(7,0), lh_num).asSInt
                // io.mem_dataOut := Cat( Fill(16, lh_num2(15)) , lh_num2 ).asUInt
                
            }


        }


        
    }


}