This repository contains the Matlab functions and scripts for initializing, simulating and evaluating the herding task with human-inspired target selection strategies as presented in [1], dynamic selection strategies presented in [2] and two heuristic selection strategies. 


[MAIN_TrialMaker](MAIN_TrialMaker.m) run N numerical trials with N initial condition for each strategy selected. Simulation paramenters will be saved in [Paramenters/](Paramenters/) while numerical trials will be saved in [Trials/*](Trials/); each in a subfolder named after the target selection strategy implemented. Note that the artificial neural networks trained to act as novice- and expert- human inpired target selection strategies are stored in [model/](model/). Note that a toy script to quickly plot timeseries of a trial is given in [plots](plots.m). 


`MAIN_TrialMaker` also calls [MAIN_MetricsMaker](MAIN_MetricsMaker.m) to compute performance metrics and save them in [Metrics/](Metrics/). 


Additional comments are included throughout to assist with comprehension.



[1] Auletta, F., Kallen, R. W., di Bernardo, M. & Richardson, M. J. (2021). Employing Supervised Machine Leaning and Explainable-AI to Model and Understand Human Decision Making During Skillful Joint-Action.  

[2] Auletta, F., Fiore, D., Richardson, M.J. & di Bernardo, M. (2020) Herding stochastic autonomous agents via local control rules and online global target selection strategies.  https://arxiv.org/abs/2010.00386v2 , Submitted.

------------------------------------------------------------------------------------------
Author: F. Auletta

E-mail : fabrizia.auletta@hdr.mq.edu.au

