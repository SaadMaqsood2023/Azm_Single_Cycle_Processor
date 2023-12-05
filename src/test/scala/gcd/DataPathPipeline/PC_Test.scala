package DataPathPipeline

import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._

class PC_Test extends FreeSpec with ChiselScalatestTester
{
    "PC Test" in {
        test(new PC(16)){ a =>   // Write the data type and width of inputs, not the data itself
            
            
            // a.io.in.poke(3.U)
            a.clock.step(6)
            a.io.out.expect(8.S)

        }
    }
}