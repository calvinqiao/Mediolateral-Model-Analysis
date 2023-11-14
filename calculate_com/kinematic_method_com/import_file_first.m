function Trial2 = importfile1(filename, dataLines)
%IMPORTFILE1 Import data from a text file
%  TRIAL2 = IMPORTFILE1(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the data as a table.
%
%  TRIAL2 = IMPORTFILE1(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%  Example:
%  Trial2 = importfile1("C:\Users\Ahmad\Documents\original data\MLBAL01\Trial2.trc", [5, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 13-Nov-2023 15:23:01

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [5, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 186);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["Frame", "Time", "LInfTrag", "VarName4", "VarName5", "LInfOrb", "VarName7", "VarName8", "RInfTrag", "VarName10", "VarName11", "RInfOrb", "VarName13", "VarName14", "RAC", "VarName16", "VarName17", "LAC", "VarName19", "VarName20", "Manub", "VarName22", "VarName23", "T5", "VarName25", "VarName26", "C7", "VarName28", "VarName29", "LPSIS", "VarName31", "VarName32", "RPSIS", "VarName34", "VarName35", "RASIS", "VarName37", "VarName38", "VSacral", "VarName40", "VarName41", "LASIS", "VarName43", "VarName44", "RTAT", "VarName46", "VarName47", "RTPT", "VarName49", "VarName50", "RBAT", "VarName52", "VarName53", "RBPT", "VarName55", "VarName56", "RKnee", "VarName58", "VarName59", "RTAS", "VarName61", "VarName62", "RTPS", "VarName64", "VarName65", "RBAS", "VarName67", "VarName68", "RBPS", "VarName70", "VarName71", "RAnkle", "VarName73", "VarName74", "RHeel", "VarName76", "VarName77", "RFMH", "VarName79", "VarName80", "RVMH", "VarName82", "VarName83", "RToe", "VarName85", "VarName86", "LTAT", "VarName88", "VarName89", "LTPT", "VarName91", "VarName92", "LBAT", "VarName94", "VarName95", "LBPT", "VarName97", "VarName98", "LKnee", "VarName100", "VarName101", "LTAS", "VarName103", "VarName104", "LTPS", "VarName106", "VarName107", "LBAS", "VarName109", "VarName110", "LBPS", "VarName112", "VarName113", "LAnkle", "VarName115", "VarName116", "LHeel", "VarName118", "VarName119", "LFMH", "VarName121", "VarName122", "LVMH", "VarName124", "VarName125", "LToe", "VarName127", "VarName128", "RKneeMedial", "VarName130", "VarName131", "RAnkleMedial", "VarName133", "VarName134", "LKneeMedial", "VarName136", "VarName137", "LAnkleMedial", "VarName139", "VarName140", "V_Mid_ASIS", "VarName142", "VarName143", "V_Pelvis_Origin", "VarName145", "VarName146", "V_RHip_JC", "VarName148", "VarName149", "V_LHip_JC", "VarName151", "VarName152", "V_RKnee_JC_Static", "VarName154", "VarName155", "V_LKnee_JC_Static", "VarName157", "VarName158", "V_RAnkle_JC_Static", "VarName160", "VarName161", "V_LAnkle_JC_Static", "VarName163", "VarName164", "V_RAnkle_JC", "VarName166", "VarName167", "V_LAnkle_JC", "VarName169", "VarName170", "V_Mid_Hip", "VarName172", "VarName173", "V_RToe_Offset_Static", "VarName175", "VarName176", "V_LToe_Offset_Static", "VarName178", "VarName179", "V_RToe_Offset", "VarName181", "VarName182", "V_LToe_Offset", "VarName184", "VarName185", "VarName186"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["V_Mid_ASIS", "VarName142", "VarName143", "V_Pelvis_Origin", "VarName145", "VarName146", "V_RHip_JC", "VarName148", "VarName149", "V_LHip_JC", "VarName151", "VarName152", "V_RKnee_JC_Static", "VarName154", "VarName155", "V_LKnee_JC_Static", "VarName157", "VarName158", "V_RAnkle_JC_Static", "VarName160", "VarName161", "V_LAnkle_JC_Static", "VarName163", "VarName164", "V_RAnkle_JC", "VarName166", "VarName167", "V_LAnkle_JC", "VarName169", "VarName170", "V_Mid_Hip", "VarName172", "VarName173", "V_RToe_Offset_Static", "VarName175", "VarName176", "V_LToe_Offset_Static", "VarName178", "VarName179", "V_RToe_Offset", "VarName181", "VarName182", "V_LToe_Offset", "VarName184", "VarName185", "VarName186"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["V_Mid_ASIS", "VarName142", "VarName143", "V_Pelvis_Origin", "VarName145", "VarName146", "V_RHip_JC", "VarName148", "VarName149", "V_LHip_JC", "VarName151", "VarName152", "V_RKnee_JC_Static", "VarName154", "VarName155", "V_LKnee_JC_Static", "VarName157", "VarName158", "V_RAnkle_JC_Static", "VarName160", "VarName161", "V_LAnkle_JC_Static", "VarName163", "VarName164", "V_RAnkle_JC", "VarName166", "VarName167", "V_LAnkle_JC", "VarName169", "VarName170", "V_Mid_Hip", "VarName172", "VarName173", "V_RToe_Offset_Static", "VarName175", "VarName176", "V_LToe_Offset_Static", "VarName178", "VarName179", "V_RToe_Offset", "VarName181", "VarName182", "V_LToe_Offset", "VarName184", "VarName185", "VarName186"], "EmptyFieldRule", "auto");

% Import the data
Trial2 = readtable(filename, opts);

end