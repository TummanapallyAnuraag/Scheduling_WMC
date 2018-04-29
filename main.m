# Using GNU Octave version 4.2.1
clc; clear; close;
tic;

if( exist('pictures','dir') == 0)
	mkdir 'pictures';
endif

% Generate 10 User Equipments (MSs) in Center Cell.
MS = getRandMS(10, 0, 0, 500);
