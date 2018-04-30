# Scheduling_WMC

This is Course Project of EE-764 of EE Dept, IITB
It's Aim is to simulate the *scheduling schemes* of LTE


# Function Descriptions

* main.m
```
This is the mail file to run our simulation. Just use octave-cli and type "main" in the command line, or run it with Octave GUI
```

* getRandMS.m
```
This file is an octave custom function, written for the specific purpose of generating UEs(User Equipments) in a cell of radius 500m.
Each UE has some parameters associated with it like "x-position" , "y-position" , "Data-Rate Experienced", ..
```

* get SINRs.m
```
This file is also a function file, aimed to calculate SINR *(Signal to Interferece Noise Ratio)* values of each UE.
```


# Reference Paper: 

* Capozzi, Francesco, et al. “Downlink packet scheduling in LTE cellular networks:Key design issues and a survey.” IEEE Communications Surveys & Tutorials 15.2(2013): 678-700.


