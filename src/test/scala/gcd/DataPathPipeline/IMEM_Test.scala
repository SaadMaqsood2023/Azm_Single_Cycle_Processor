package DataPathPipeline

import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._

class IMEM_Test extends FreeSpec with ChiselScalatestTester
{
    "IMEM Test" in {
        // test(new IMEM("D:/Semester lll/CO&AL(P)/assemblyHexcode.txt") ){ a =>   // Write the data type and width of inputs, not the data itself
        test(new IMEM ){ a =>   // Write the data type and width of inputs, not the data itself
            
            a.io.address.poke(0.U)
            // a.io.dataIn.poke("h005201b3".U)
            a.io.wen.poke(1.B)
            a.clock.step(2)
            a.io.dataOut.expect("h005201b3".U)
            
        }
    }
}