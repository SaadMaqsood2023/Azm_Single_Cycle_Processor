Azm عزم
=======================

<img src='https://github.com/syedowaisalishah/Al-Battar-/blob/main/Single%20Cycle%20RISC-V%20Core.png' height=600 width=100%>

[![Join the chat at https://gitter.im/merledu/scala-chisel-learning-journey](https://badges.gitter.im/merledu/scala-chisel-learning-journey.svg)](https://gitter.im/merledu/scala-chisel-learning-journey?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


Start by setting up the working enviroment

### Dependencies

#### JDK 8 or newer

```bash
sudo apt-get install openjdk-11-jdk
sudo apt-get install openjdk-11-jre
```
#### SBT 

SBT is the most common built tool in the Scala community. You can download it [here](https://www.scala-sbt.org/download.html).  

#### VERILATOR
```bash
sudo apt-get install verilator
```

### How to get started

Fork this repository on your own individual profiles. After forking clone the repository and run:

```sh
sbt test
```
You should see a whole bunch of output that ends with something like the following lines
```
[info] Tests: succeeded 1, failed 0, canceled 0, ignored 0, pending 0
[info] All tests passed.
[success] Total time: 5 s, completed Dec 16, 2020 12:18:44 PM
```
If you see the above then...
### Code Dump from venus
After cloning the repo and successfully testing the sbt you need hexadecimal code. Now click [here](venus.kvakil.me) to go to venus, write your assembly code there and generate hexadecimal code by clicking on Dump. Copy the code and paste it in the file assemblyHexcode.txt. You can also take assembly code given for test in the end.

### Assembly file path change required
Right click on the file and select Copy Path and paste it inside the IMEM module. Now you are ready to run the code. 

### How to run 
In the Visual studio code open folder by clicking on the folder name Azm_Single_Cycle_Processor. Open terminal and write command
```
sbt
```
After that terminal will show the folder name you opened 
```
sbt:Azm_Single_Cycle_Processor>
```
Now enter the command:
```
sbt:Azm_Single_Cycle_Processor> testOnly DataPathPipeline.Top_Test -- -DwriteVcd=1
```
After successfully running the code go test_run_dir and open the CoreTop.Vcd on gktwave to see the generated results.

### It worked!

You are ready to go. Next step is to go inside the `docs/` folder where you will find the labs to perform.

### For quick debugging
If you quickly want to see what verilog is being generated, go to this link  https://bit.ly/3u3zr0e and write Chisel here.
