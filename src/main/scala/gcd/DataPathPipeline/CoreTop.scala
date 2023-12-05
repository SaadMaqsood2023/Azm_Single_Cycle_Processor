package DataPathPipeline

import chisel3._
import chisel3.util._


object var_size2
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
import var_size2._

class CoreTop extends Module
{
    val io = IO(new Bundle{

        // val core_top_imem_en        = Output(Bool())
        // val core_top_ins            = Input(UInt(32.W))  // Instruction will come from IMEM
        val dataIn                  = Input( UInt(32.W))
        // val wen                     = Input(Bool())
        // val ren                     = Input(Bool())
        
        // val mem_mask                = Output( Vec(4, Bool()))
        // val rd_addr                 = Output(UInt(32.W))
        // val wr_addr                 = Output(UInt(32.W))
        val dataOut = Output(UInt(32.W))
        
    })

    val fetch_module        = Module(new Fetch)
    val decode_module       = Module(new Decode)
    val execute_module      = Module(new Execute)
    val memory_module       = Module(new Memory)
    val wb_module           = Module(new WriteBack)

    // Will enable instruction memory(IMEM) using control unit(CU) in Decode 
    // io.core_top_imem_en := decode_module.io.decode_imem_en  --- old
    fetch_module.io.fetch_wen     := decode_module.io.decode_imem_en

    // Taking Instruction from IMEM using core top and giving to Decode Module --- old 
    // decode_module.io.decode_ins   := io.core_top_ins

    // Taking Instruction from IMEM using fetch module and giving to Decode Module
    decode_module.io.decode_ins      := fetch_module.io.fetch_dataOut
    // Initializing pc_br_imm in fetch module using cu in decode module
    fetch_module.io.fetch_pc_br_imm  := decode_module.io.decode_pc_br_imm
    // Initializing pc branch enable in fetch module using cu in decode module
    fetch_module.io.fetch_pc_en_jump := decode_module.io.decode_pc_en_jump 
    // Initializing pc unconditional jump enable in fetch using cu in decode module
    fetch_module.io.fetch_jalr_en_pc := decode_module.io.decode_pc_en_jalr
    // Sending inputs of ALU from Register File and Func3 from CU
    execute_module.io.execute_in_A      := decode_module.io.decode_rdata1
    execute_module.io.execute_in_B      := decode_module.io.decode_rdata2
    execute_module.io.execute_alu_Op    := decode_module.io.decode_func3_7

    // Assigning write data of register file using ALU output
    decode_module.io.decode_regfile_wdata   :=  execute_module.io.execute_out
    // decode_module.io.decode_regfile_wdata   := 0.U       // decode module register file write data default value
    decode_module.io.decode_alu_out         := execute_module.io.execute_out
    // decode_module.io.decode_alu_out         := 0.U       // decode module alu_out default value
    decode_module.io.decode_pc_out          := fetch_module.io.fetch_pc_out   // pc value for decode value
    // auipc, branch, jal, jalr
    when( (fetch_module.io.fetch_dataOut(6,0) === auipc 
        || fetch_module.io.fetch_dataOut(6,0) === SB_type)
            ||
        (fetch_module.io.fetch_dataOut(6,0) === unb_ins
        || fetch_module.io.fetch_dataOut(6,0) === jalr ) )
    {
        execute_module.io.execute_in_A        := decode_module.io.decode_alu_in_A
        execute_module.io.execute_in_B        := decode_module.io.decode_alu_in_B
        execute_module.io.execute_alu_Op      := decode_module.io.decode_alu_Op
        decode_module.io.decode_alu_out       := execute_module.io.execute_out
    }

    // 2 Bit address for selecting masked bytes of memory address
    decode_module.io.decode_dmem_addr2        := (execute_module.io.execute_out)(1,0)
 
    // Masking value from Control Unit
    // memory_module.io.mem_mask_val           := decode_module.io.decode_mask_val

    // Default value for immediate of memory and write back 
    // memory_module.io.mem_cu_immediate   := 0.U  --- old (no need for the extra ouput port)
    // wb_module.io.mem_cu_immediate       := 0.U
    // Assigning func3 and opcode to the memory module
    memory_module.io.mem_opcode         := fetch_module.io.fetch_dataOut(6,0)
    memory_module.io.mem_func3_7        := fetch_module.io.fetch_dataOut(14,12)
    
    //Assigning default value to maskaddr2 of memory and write modules
    memory_module.io.mem_mask_addr2     := 0.U
    // wb_module.io.wb_mask_addr2          := 0.U
    // Default value for data of memory module, store (from register file to DMEM)
    memory_module.io.mem_datainput(0)      := 0.U
    memory_module.io.mem_datainput(1)      := 0.U
    memory_module.io.mem_datainput(2)      := 0.U
    memory_module.io.mem_datainput(3)      := 0.U
    // Default value for data memory rdata1
    memory_module.io.mem_rdata1         := 0.U

    memory_module.io.mem_dmem_enable       := decode_module.io.decode_dmem_en    // write enable for dmem in memory module
    memory_module.io.mem_rd_enable         := decode_module.io.decode_r_en       // read enable for dmem in memory module
    memory_module.io.mem_mask_val          := decode_module.io.decode_mask_val   // mask value from cu in decode to dmem in mem
    memory_module.io.mem_alu_out           := execute_module.io.execute_out      // default value for address calculation of mem

    // Directly sending masked value from decode module to CoreTop output  --old
    // Masking value from Control Unit to data memory instance
    // io.mem_mask     = decode_module.io.decode_mask_val

    // From register file to DMEM (store instruction) Default value
    // memory_module.io.mem_dataIn(0) := 0.U
    // memory_module.io.mem_dataIn(1) := 0.U
    // memory_module.io.mem_dataIn(2) := 0.U
    // memory_module.io.mem_dataIn(3) := 0.U
    // dmem_module.io.dataIn := 0.U
    // sending opcode to write back module for checking load instruction
    wb_module.io.wb_opcode              := fetch_module.io.fetch_dataOut(6,0)

    wb_module.io.wb_dmem_dataOut     := 0.U
    // wb_module.io.wb_dmem_dataOut(1)     := 0.U
    // wb_module.io.wb_dmem_dataOut(2)     := 0.U
    // wb_module.io.wb_dmem_dataOut(3)     := 0.U

    // Calculating address for load and store instructions
    when(fetch_module.io.fetch_dataOut(6,0) === "h23".U)
    {
        // Assigning immediate for load and store address calculation
        // memory_module.io.mem_cu_immediate     := decode_module.io.decode_immediate 
        memory_module.io.mem_rdata1           := decode_module.io.decode_rdata1

        // Giving inputs to ALU and then taking back the output
        // execute_module.io.execute_in_A        := memory_module.io.mem_alu_in_A  //--old (we can directly assign the
        // immediate, so no need to create extra input port for immediate in the memory module)
        execute_module.io.execute_in_A        := decode_module.io.decode_immediate
        execute_module.io.execute_in_B        := memory_module.io.mem_alu_in_B
        execute_module.io.execute_alu_Op      := memory_module.io.mem_alu_Op
        memory_module.io.mem_mask_addr2       := execute_module.io.execute_out(1,0)
        memory_module.io.mem_alu_out          := execute_module.io.execute_out
        
        // memory_module.io.mem_datainput        := register_module.io.rdata2
        memory_module.io.mem_datainput(0)        := decode_module.io.decode_rdata2(7,0)
        memory_module.io.mem_datainput(1)        := decode_module.io.decode_rdata2(15,8)
        memory_module.io.mem_datainput(2)        := decode_module.io.decode_rdata2(23,16)
        memory_module.io.mem_datainput(3)        := decode_module.io.decode_rdata2(31,24)
    }.elsewhen(fetch_module.io.fetch_dataOut(6,0) === 3.U)
    {
        // Assigning immediate for load and store address calculation
        // wb_module.io.wb_cu_immediate          := decode_module.io.decode_immediate
        
        // Giving inputs to ALU and then taking back the output  
        // execute_module.io.execute_in_A        := memory_module.io.mem_alu_in_A --old (we can directly assign the
        // immediate, so no need to create extra input port for immediate in the memory module)
        execute_module.io.execute_in_A        := decode_module.io.decode_immediate
        execute_module.io.execute_in_B        := memory_module.io.mem_alu_in_B
        execute_module.io.execute_alu_Op      := memory_module.io.mem_alu_Op
        memory_module.io.mem_mask_addr2       := execute_module.io.execute_out(1,0)
        memory_module.io.mem_alu_out          := execute_module.io.execute_out
        
        wb_module.io.wb_dmem_dataOut          := memory_module.io.mem_dataOut
        // Assigning values to register file from write back module
        decode_module.io.decode_regfile_wdata := wb_module.io.wb_dataOut
    }

    io.dataOut      := decode_module.io.decode_regfile_wdata

}