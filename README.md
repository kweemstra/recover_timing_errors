# Recovering timing errors using seismic interferometry
Created by Cornelis Weemstra, May 7, 2020

## Description

Fortran code to recover instrumental timing errors of seismic stations, such as, for example, ocean bottom seismometers. The code reads time-averaged crosscorrelations computed from a large-N seismic array and determines the difference in arrival time between the direct surface wave at positive time and the direct surface wave at negative time. These measurements allow one to set up a system of equations which can be solved for potential timing errors of (some) of the stations. <The details are given in the GJI publication ...>
