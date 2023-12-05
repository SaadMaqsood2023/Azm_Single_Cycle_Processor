package DataPathPipeline

import chisel3._
import chisel3.util._

class WriteBack extends Module
{
    val io = IO(new Bundle {
        
        // val wb_mask_addr2       = Input(UInt(32.W))
        val wb_opcode           = Input(UInt(7.W))
        // val wb_func3_7          = Input(UInt(4.W))
        // val wb_cu_immediate     = Input(UInt(32.W))
        // val wb_alu_out          = Input(UInt(32.W))      // Taking Input of Address calculated from ALU
        // val wb_alu_in_A         = Output(UInt(32.W))
        // val wb_alu_in_B         = Output(UInt(32.W))
        // val wb_alu_Op           = Output(UInt(4.W))

        val wb_dmem_dataOut     = Input(UInt(32.W))      // From DMEM (of memory module) to write back and then to register file
        val wb_dataOut          = Output(UInt(32.W))    /// From memory module to register file through write back
    })

    // if load instruction then send data from DMEM to register file
    io.wb_dataOut := Mux(io.wb_opcode === 3.U,io.wb_dmem_dataOut, 0.U )
    
}