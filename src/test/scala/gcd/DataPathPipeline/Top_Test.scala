package DataPathPipeline

import chisel3._
import chisel3.tester._
import org.scalatest.FreeSpec
import chisel3.experimental.BundleLiterals._
import chiseltest.internal.VerilatorBackendAnnotation
import chiseltest.experimental.TestOptionBuilder._

class Top_Test extends FreeSpec with ChiselScalatestTester
{
    "Top Test Pipeline" in {  // .withAnnotations(Seq(VerilatorBackendAnnotation))
        test(new CoreTop) { a =>   
            // Write the data type and width of inputs, not the data itself
            a.io.dataIn.poke("h00500213".U) // Dummy value
            a.clock.step(150)
            // a.io.out.expect(5.S)   // Value being expected from the txt file.
            
        }
    }
}