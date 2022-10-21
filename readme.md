# Communication System Design Project

## Installation

```shell
brew install icarus-verilog
```

## Usage

```shell
chmod +x run.sh
./run.sh
```

Then visualize the `.vcd` file with `Scansion` or `GtkWave`

## Structure overview

* ✅`SigGen.v`:randomly generate a signal
* ✅`Modulator.v`: QPSK
* ✅`Demodulator.v`: deQPSK
* ✅`ComSys.v`: communication system assemble & display module
* TODO..


## Demostrations

|Module|Results|
|-|-|
|QPSK Modulator-Demodulator|![](https://tva1.sinaimg.cn/large/008vxvgGly1h7d8bohw5tj30z206wtav.jpg)|
