package DataPathPipeline

import chisel3._
import chisel3.util._

// Fetch PC
object var_size1
{
    val counter_size = 1024
    val load_B = 0.U
    val load_H = 1.U
    val load_W = 2.U
    val load_BU = 4.U
    val load_HU = 5.U
    val store_B = 0.U
    val store_H = 1.U
    val store_W = 2.U
    val lui     = "h37".U
    val SB_type = "h63".U
    val auipc   = "h17".U
    val unb_ins   = "h6f".U
    val jalr    = "h67".U
}
import var_size1._

class Fetch extends Module
{
    val io = IO(new Bundle{
        val fetch_pc_br_imm     = Input(SInt(32.W))
        val fetch_pc_en_jump    = Input(Bool())
        val fetch_jalr_en_pc    = Input(Bool())
        val fetch_wen           = Input(Bool())
        
        val fetch_dataOut       = Output(UInt(32.W))  // imem instruction
        val fetch_pc_out           = Output(SInt(10.W))
        // val fetch_imem_addr     = Output(UInt(10.W))
        
        

    })

    val imem_module_Fetch     = Module(new IMEM())
    val pc_module_Fetch       = Module(new PC(counter_size))

    // imem_module_Fetch.io.address := (pc_module_Fetch.io.out).asUInt
    // pc_module_Fetch.io.fetch_jalr_en_pc := cu_module.io.jalr_en           // Enabling PC jalr through CU

    // io.inst_out := io.ins
    // imem_module_Fetch.io.dataIn := io.inst_out  // assigning the output to dataIn of IMEM

    pc_module_Fetch.io.br_imm := 0.S         // default value for branch immediate

    pc_module_Fetch.io.br_imm       := (io.fetch_pc_br_imm).asSInt
    pc_module_Fetch.io.en_jump      := io.fetch_pc_en_jump
    pc_module_Fetch.io.jalr_en_pc   := io.fetch_jalr_en_pc
    // io.fetch_imem_addr              := (pc_module_Fetch.io.out).asUInt
    imem_module_Fetch.io.address    := (pc_module_Fetch.io.out).asUInt
    imem_module_Fetch.io.dataIn     := 0.U
    imem_module_Fetch.io.wen        := io.fetch_wen  // write enable for IMEM from CU
    io.fetch_dataOut                := imem_module_Fetch.io.dataOut
    io.fetch_pc_out                       := pc_module_Fetch.io.out


    // val again_ins = RegInit(false.B  )
    
    // // when(imem_module_Fetch.io.dataOut (6,0) === 3.U || imem_module_Fetch.io.dataOut (6,0) === "h23".U)
    // when(imem_module_Fetch.io.dataOut (6,0) === 23.U )
    // {
    //     when(again_ins === false.B)
    //     {
    //         pc_module_Fetch.io.fetch_jalr_en_pc := 1.B
    //         pc_module_Fetch.io.br_imm := (pc_module_Fetch.io.out).asSInt  // same instruction address
    //         // pc_module_Fetch.io.br_imm := (0.U).asSInt  // same instruction address
    //     }
    // }

    // cu_module.io.ins := imem_module_Fetch.io.dataOut        // Giving whole instruction to CU
    // when(again_ins === true.B)  // true means we are exucuting second time
    // {
    //     cu_module.io.ins := 0.U
    // // }.elsewhen((imem_module_Fetch.io.dataOut (6,0) === 3.U || imem_module_Fetch.io.dataOut (6,0) === "h23".U) && !again_ins)
    // }.elsewhen((imem_module_Fetch.io.dataOut(6,0) === 23.U ) && !again_ins)  // This block will run in the first execution (load)
    // {
    //     again_ins := true.B
    // }

    //  when(cu_module.io.ins === 0.U)
    // {
    //     again_ins := false.B
    // }


}