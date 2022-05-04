clear all
CON = ["TLON_A1M_C"; "TLON_M11_C";"TLON_M2_C";"TLON_M20_C";"TLON_M26_C";"TLON_M23_C";"TLON_M3_C";"TLON_M4_C";"TLON_M40_C";"TLON_M1_C"];
ACON = ["TLON_A1M_AC";"TLON_M11_AC";"TLON_M2_AC";"TLON_M20_AC";"TLON_M26_AC";"TLON_M23_AC";"TLON_M3_AC";"TLON_M4_AC";"TLON_M40_AC";"TLON_M1_AC"];
COFF = ["LOFF_A1M_C"; "LOFF_M11_C";"LOFF_M2_C";"LOFF_M20_C";"LOFF_M26_C";"LOFF_M23_C";"LOFF_M3_C";"LOFF_M4_C";"LOFF_M40_C";"LOFF_M1_C"];
ACOFF = ["LOFF_A1M_AC";"LOFF_M11_AC";"LOFF_M2_AC";"LOFF_M20_AC";"LOFF_M26_AC";"LOFF_M23_AC";"LOFF_M3_AC";"LOFF_M4_AC";"LOFF_M40_AC";"LOFF_M1_AC"];
tp = 0.1;
file_ID = fopen('testfile.txt','w');
for i = 0:tp:100
    name = ["vehicle",num2str(i/tp)];
    vehicle = join(name,"_");
    r1 = randi([1 10],1);
    r2 = randi([1 10],1);
    while r2 == r1
        r2 = randi([1 10],1);
    end
    r3 = randi([1 1000],1)/10;
    if r3 <= 74.7
        type = "passenger";
    elseif r3 <= 98.5
        type = "lorry";
    elseif r3 <= 99.4
        type = "motorcycle";
    else
        type = "bus";
    end
    r4 = randi([1 2],1);        
    if r4 == 1        
    fprintf(file_ID,"   <trip id=""%s"" type=""%s"" depart=""%s"" from=""%s"" to=""%s""/>\n",vehicle, type, num2str(i), CON(r1), COFF(r2))
    else
        fprintf(file_ID,"   <trip id=""%s"" type=""%s"" depart=""%s"" from=""%s"" to=""%s""/>\n",vehicle, type, num2str(i), ACON(r1), ACOFF(r2))
    end   
end
fclose(file_ID);
