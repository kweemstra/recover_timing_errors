# Recovering timing errors using seismic interferometry
Created by Cornelis Weemstra, May 7, 2020

## Description

Fortran code to recover instrumental timing errors of seismic stations, such as, for example, ocean bottom seismometers. The code reads time-averaged crosscorrelations computed from a large-N seismic array and determines the difference in arrival time between the direct surface wave at positive time and the direct surface wave at negative time. These measurements allow one to set up a system of equations which can be solved for potential timing errors of (some) of the stations. The details are given in the GJI article _title of article (202?)_, which can be found on [my personal webpage](https://kweemstra.com/publications.php "Link to my publications").   

The code contains MPI (compiler) directives such that it can be run in parallel on a cluster. In fact, it needs to be run in parallel in order to work. And although I am able to compile and run the binary on our cluster, this code certainly is not up to the standard of a software engineer. I did include some (minimal) comments though. At the same time, those who have read the aforementioned article, will recogize many of the instructions. I believe that sharing this code therefore is still usefull. In case of questions pertaining to the method implemented in this code, don't hesitate to ask. In case of compiler/code related questions: I'll see what I can do.   

Best regards,
Kees
