package DataPathPipeline

import chisel3._
import chisel3.util._

class Execute extends Module
{
    val io = IO(new Bundle{
        val execute_in_A = Input ( UInt ( 32.W ) )
        val execute_in_B = Input ( UInt ( 32.W ) )
        val execute_alu_Op = Input ( UInt ( 4.W ) )
        val execute_out = Output ( UInt ( 32.W ) )
    })

    val alu_module = Module(new ALU)

    // assigning opcode from CU using Execute port
    alu_module.io.alu_Op := io.execute_alu_Op    

    // alu_module.io.in_A := 0.U  // Default value to ALU
    // alu_module.io.in_B := 0.U

    // Inserting data from register file to ALU using execute port
    alu_module.io.in_A  := io.execute_in_A
    alu_module.io.in_B  := io.execute_in_B

    io.execute_out      := alu_module.io.out 

    // when(imem_module.io.dataOut(6,0) === "h33".U) 
    // {
    //     alu_module.io.in_A := io.execute_in_A  // Inserting data from register file to ALU
    //     alu_module.io.in_B := io.execute_in_B

    //     when(register_module.io.rdata1 >= 4096.U && register_module.io.rdata2(10) === 1.U)
    //     {
    //         alu_module.io.in_A := register_module.io.rdata1 
    //         alu_module.io.in_B := register_module.io.rdata2
    //     }.elsewhen(register_module.io.rdata1(11) === 1.U && register_module.io.rdata2 >= 4096.U)
    //     {
    //         alu_module.io.in_A := register_module.io.rdata1
    //         alu_module.io.in_B := register_module.io.rdata2 + 1.U
    //     } 

    // }.elsewhen(imem_module.io.dataOut(6, 0) === "h13".U)
    // {
    //     alu_module.io.in_A := register_module.io.rdata1  // Inserting data from register file to ALU
    //     alu_module.io.in_B := cu_module.io.immediate
    // }
}