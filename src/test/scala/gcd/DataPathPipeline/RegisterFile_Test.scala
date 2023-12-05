package DataPathPipeline

import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._

class RegisterFile_Test extends FreeSpec with ChiselScalatestTester
{
    "Register File Test" in {
        test(new RegisterFile ){ a =>   // Write the data type and width of inputs, not the data itself
            
            a.io.raddr1.poke(3.U)
            a.io.raddr2.poke(4.U)
            a.io.waddr.poke(5.U)
            a.io.wdata.poke(10.U)
            a.io.wen.poke(1.B)

            a.clock.step(2)
            a.io.rdata1.expect(0.U)
            a.io.rdata2.expect(0.U)
            
        }
    }
}