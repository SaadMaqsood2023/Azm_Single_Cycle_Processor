package DataPathPipeline

import chisel3._
import chisel3.util._

object var_size
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
import var_size._


// Decode contains Conrol unit, Register, Branch (All immediates are generated here)
class Decode extends Module
{
    val io = IO(new Bundle {
        // val decode_imem_en = Output(Bool())
    val decode_ins                 = Input(UInt( 32.W ) )
    val decode_dmem_addr2          = Input(UInt(2.W))
    val decode_regfile_wdata       = Input(UInt(32.W))
    val decode_pc_out              = Input(SInt(32.W))
    val decode_alu_out             = Input(UInt(32.W))

    val decode_w_en                = Output( Bool())
    val decode_imem_en             = Output( Bool())
    val decode_pc_en_jump          = Output( Bool())
    val decode_pc_en_jalr          = Output( Bool())
    val decode_pc_br_imm           = Output( SInt(32.W))
    val decode_r_en                = Output(Bool())
    val decode_dmem_en             = Output(Bool())
    val decode_immediate           = Output(UInt(32.W))
    val decode_func3_7             = Output(UInt(4.W))
    val decode_br_en               = Output(Bool())
    val decode_unbr_en             = Output(Bool())
    val decode_mask_val            = Output(Vec(4, Bool() ) )   //
    val decode_jalr_en             = Output( Bool() )
    val decode_rdata1              = Output(UInt(32.W))
    val decode_rdata2              = Output(UInt(32.W))

    val decode_alu_in_A            = Output(UInt(32.W))
    val decode_alu_in_B            = Output(UInt(32.W))
    val decode_alu_Op              = Output(UInt(4.W))
    })

    val cu_module       = Module(new CU)
    val register_module = Module(new RegisterFile)
    val branch_module   = Module(new Branch)

    // cu_module.io.ins := imem_module.io.dataOut        
    cu_module.io.ins        := io.decode_ins               // Giving whole instruction to CU
    cu_module.io.dmem_addr2 := io.decode_dmem_addr2        // Giving value to address2 to select mask in cu

    // Now Assigning the values of all output of CU to Output ports of Decode
    io.decode_w_en                  := cu_module.io.w_en
    io.decode_imem_en               := cu_module.io.imem_en
    io.decode_pc_en_jump            := 0.B
    io.decode_pc_en_jalr            := 0.B
    io.decode_pc_br_imm             := 0.S
    io.decode_r_en                  := cu_module.io.r_en
    io.decode_dmem_en               := cu_module.io.dmem_en
    io.decode_immediate             := cu_module.io.immediate
    io.decode_func3_7               := cu_module.io.func3_7
    io.decode_br_en                 := cu_module.io.br_en
    io.decode_unbr_en               := cu_module.io.unbr_en
    io.decode_mask_val              := cu_module.io.mask_val
    io.decode_jalr_en               := cu_module.io.jalr_en

    register_module.io.raddr1 := cu_module.io.rs1     // Input of address of source register
    register_module.io.raddr2 := cu_module.io.rs2
    register_module.io.waddr  := cu_module.io.rd      // Input of address of rd register

    io.decode_alu_Op   := cu_module.io.func3_7    // assigning opcode from CU

    // This read data of register file will go the ALU
    io.decode_rdata1 := register_module.io.rdata1  // Default value to read data
    io.decode_rdata2 := register_module.io.rdata2

    register_module.io.wen   := cu_module.io.w_en          // write enable register file 

    io.decode_alu_in_A  := 0.U
    io.decode_alu_in_B  := 0.U
    io.decode_alu_Op    := 0.U


    when(cu_module.io.ins(6,0) === "h33".U) 
    {
        io.decode_rdata1 := register_module.io.rdata1  // Inserting data from register file to ALU
        io.decode_rdata2 := register_module.io.rdata2

        when(register_module.io.rdata1 >= 4096.U && register_module.io.rdata2(10) === 1.U)
        {
            io.decode_rdata1 := register_module.io.rdata1 
            io.decode_rdata2 := register_module.io.rdata2
        }.elsewhen(register_module.io.rdata1(11) === 1.U && register_module.io.rdata2 >= 4096.U)
        {
            io.decode_rdata1 := register_module.io.rdata1
            io.decode_rdata2 := register_module.io.rdata2 + 1.U
        } 

    }.elsewhen(cu_module.io.ins(6, 0) === "h13".U)
    {
        io.decode_rdata1 := register_module.io.rdata1  // Inserting data from register file to ALU
        io.decode_rdata2 := cu_module.io.immediate
    }

    // Getting the write data from core top and assigning to the register file
    register_module.io.wdata := io.decode_regfile_wdata
    
    //Assigning branch module inputts
    branch_module.io.func3      := cu_module.io.func3_7
    branch_module.io.br_ins     := cu_module.io.br_en
    branch_module.io.inpA       := register_module.io.rdata1
    branch_module.io.inpB       := register_module.io.rdata2
    // branch_module.io.br_taken

    io.decode_pc_en_jump        := cu_module.io.unbr_en  // For Both Jal and Jalr   
    // This line was not letting to execute the branch instruction
    // so had to write the branch statement inside the condition
    when(cu_module.io.ins(6,0) === SB_type)
    {
        io.decode_pc_en_jump    := branch_module.io.br_taken
    }

    when(cu_module.io.ins(6,0) === lui)    
    {   
        // Assigning upper immediate to register file
        register_module.io.wdata := cu_module.io.immediate
    }.elsewhen(cu_module.io.ins(6,0) === auipc )
    {
        io.decode_alu_in_A := (io.decode_pc_out).asUInt
        io.decode_alu_in_B := cu_module.io.immediate
        register_module.io.wdata := io.decode_alu_out
    }.elsewhen(branch_module.io.br_ins)   // checking if there is a branch instruction
    {
        io.decode_pc_en_jump := branch_module.io.br_taken
        
    //    when(branch_module.io.br_taken)
    //    {
    //         io.decode_pc_br_imm := (cu_module.io.immediate).asSInt
    //    }
        io.decode_alu_in_A := (io.decode_pc_out).asUInt
        io.decode_alu_in_B := cu_module.io.immediate
        io.decode_alu_Op   := 0.U
        io.decode_pc_br_imm := (io.decode_alu_out).asSInt

    }.elsewhen(cu_module.io.ins(6,0) === unb_ins)   // Unconditional branch jal instruction
    {
        io.decode_alu_in_A := (io.decode_pc_out).asUInt
        io.decode_alu_in_B := cu_module.io.immediate
        io.decode_alu_Op   := 0.U
        io.decode_pc_br_imm   := (io.decode_alu_out).asSInt
        // io.decode_pc_br_imm   := (cu_module.io.immediate).asSInt
        // register_module.io.wdata := io.decode_alu_out     // PC + 4
        register_module.io.wdata := (io.decode_pc_out).asUInt + 4.U
    }.elsewhen(cu_module.io.ins(6,0) === jalr)      // Unconditional branch jalr instructioni
    {
        io.decode_alu_Op   := 0.U
        io.decode_alu_in_A := register_module.io.rdata1
        io.decode_alu_in_B := cu_module.io.immediate
        io.decode_pc_br_imm := (io.decode_alu_out).asSInt      // rs1 + imm

        io.decode_pc_en_jalr := cu_module.io.jalr_en
        // io.decode_alu_in_A := (pc_module.io.out).asUInt
        // io.decode_alu_in_B := 4.U
        io.decode_alu_Op   := 0.U

        register_module.io.wdata :=  io.decode_alu_out
    }

}