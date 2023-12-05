package DataPathPipeline

import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._

class ALU_Test extends FreeSpec with ChiselScalatestTester
{
    "ALU Tester" in {
        test(new ALU) { a => 
            a.io.in_A.poke("b1111111111110100".U)
            a.io.in_B.poke("b11000".U)
            a.io.alu_Op.poke(13.U)
            a.clock.step(2)

            a.io.out.expect(12.U)
            // a.io.sum.expect("b10".U)    // You have to change the sum according to the last bit of the opcode given 
        }
    }
}