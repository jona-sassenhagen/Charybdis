Readme Scripts Charybdis

Seven scripts were used to calculate and plot the main data from a neurosciene/linguistics experiment with the working title Charybdis. Together with the raw data available elsewhere, they should be sufficient to reproduce the plots and statistical results in the resulting paper. The scripts are:

1. charybdis preproc <- run this first to preprocess the data
2. charybdis make study to select eye ICs <- guess what it does
3. charybdis erplab preprocessing scrip <- for the ERPs (figure 1)
4. charybdis plot erpimages <- ERPimages (figure 2)
5. charybdis respbinlat <- RT binning jackknife
6. charybdis itc2 <- Inter-trial coherence
7. charybdis neuwood <- Woody filtering

There are also some additional scripts for e.g. Butterfly ERPs.
All files are released under the GPL, though honestly, if you ever find the need to use them for something non-GPLy, you should probably just write me and I'll allow you to LPGL them or something.

All scripts were originally written and run on 64bit Matlab (Mathworks), v2012, running on Linux, and with the statistics and signal processing toolboxes. Mainly, they all rely on EEGLAB (v. 12), which can be downloaded for free on the EEGLAB website. Also, the Robust Correlation toolbox was used (Rousselet & Pernet 2012).
On any reasonably fast computer, the whole show should be done within less than a day.

The scripts assume 1. you're running MATLAB and EEGLAB is in your path, 2. that in a folder ~/Desktop/charybdis/raw, the raw Brainvision files sit named 'ch[subj#].vhdr'.
I honestly just copy and paste them into the MATLAB window.

The "preproc" script does preprocessing. Run this first, because it creates usable files from the raw files. You will probably need to adapt the file structure!
The preproc script will take some time because it runs ICA. ICA is ONLY used for eye artefact correction. You can probably look at the P600 effect at PZ without doing that, really.
The "make study to select eye ICs" script needs some manual input halfway through. Since every ICA decomposition is different (ICAs with identical starting parameters converge roughly, but not completely, on the same results), you will have to check for yourself what eye IC templates you want to use for CORRMAP later on. It must be run after the preproc script, but before the other scripts. However, if you decide to skip IC eye correction (only advisable if all you care about is PZ), you can skip this (and need to remove all references to eye ICs in the other scripts). Skipping ICA will significantly speed up the whole procedure.

The other EEGLAB scripts can be run in any order.
"plot erpimages" plots the ERPimages used in the study. Note that some minor manual editing was applied (including the manual removal of a vertical straight line that didn't make any sense, and marking the ERP components in the ERP by hand). It can be instructive to plot the individual ERPimages instead of the collected (double) ERPimages if the actual plots are confusing.

The ERPs in the submitted paper were done using the graphical interface of ERPLAB, freely available as an EEGLAB plugin on the ERPLAB website. The ERPs are more of an afterthought really, the meat is in the ERPimages.
The "erplab preprocessing" script has to be run after the main preproc script and (if using ICA eye correction) after the make study script. The "binlist-rt.txt" file must be in ~/Desktop/erplab/, and ~/Desktop/erplab must exist. The ERPLAB GUI is very nice to use, and reproducing my plots should be trivial.

The experiment is described in more detail elsewhere.
The metadata in the .vhdr files is informative. However, some electrodes are not correctly labelled in the raw files (the scripts take this into account). #27 is the left temple eye electrode, #28 is the right temple (roughly LO1 and LO2), 32 is infraorbital left and 30 infraorbital right. Reference was the right mastoid.

Critical triggers: 
S196 is correct button press
S197/S199 is incorrect button press and time-out

S80 and S71 mark the onset of a noun that does not agree in morphosyntactic gender with the preceding article.
S60 and S61 mark the onset of a noun that does not fit with the category word (hyponym) of the sentence.
S40, S41, S50 and S51 are control (correct) noun onsets.

20 subjects were recorded and all 20 entered the final results.

Jona Sassenhagen, in a train from Mainz to Marburg, 2013