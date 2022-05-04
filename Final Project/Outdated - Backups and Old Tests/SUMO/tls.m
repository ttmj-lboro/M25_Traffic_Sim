clear all
CON = ["SON_A1M_C"; "SON_M11_C";"SON_M2_C";"SON_M20_C";"SON_M26_C";"SON_M23_C";"SON_M3_C";"SON_M4_C";"SON_M40_C";"SON_M1_C"];
ACON = ["SON_A1M_AC";"SON_M11_AC";"SON_M2_AC";"SON_M20_AC";"SON_M26_AC";"SON_M23_AC";"SON_M3_AC";"SON_M4_AC";"SON_M40_AC";"SON_M1_AC"];

file_ID = fopen('tls.txt','w');
phaseDurG = "75";
minDur = "20";
maxDur = "50";
phaseDurY = "5"
phaseDurR = "20"
for i = 1:10
    fprintf(file_ID,"    <tlLogic id=""%s"" type=""actuated"" programID=""1"" offset=""0"">\n",CON(i))
    fprintf(file_ID,"        <phase duration=""%s"" state=""G"" minDur=""%s"" maxDur=""%s""/>\n",phaseDurG,minDur,maxDur)
    fprintf(file_ID,"        <phase duration=""%s""  state=""y""/>\n", phaseDurY)
    fprintf(file_ID,"        <phase duration=""%s""  state=""r""/>\n", phaseDurR)
    fprintf(file_ID,"    </tlLogic>")
    
    fprintf(file_ID,"    <tlLogic id=""%s"" type=""actuated"" programID=""1"" offset=""0"">\n",ACON(i))
    fprintf(file_ID,"        <phase duration=""%s"" state=""G"" minDur=""%s"" maxDur=""%s""/>\n",phaseDurG,minDur,maxDur)
    fprintf(file_ID,"        <phase duration=""%s""  state=""y""/>\n", phaseDurY)
    fprintf(file_ID,"        <phase duration=""%s""  state=""r""/>\n", phaseDurR)
    fprintf(file_ID,"    </tlLogic>")
end
fclose(file_ID);
