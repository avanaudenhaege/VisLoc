%%%%%VWFA EXPERIMENT: localizer %%%%%%%
%%script from Stefania Mattioni - adapted by Alice Van Audenhaege
% Jan2022

%%RUN DESCRIPTION
% Categories of stimuli = 3 (words, houses and faces); 24 exemplars per category.
% Tot num stimuli = 72; 
% There are 24 blocks : 8 for each condition. 
% This localizer should be ran only once (1 run). 


%%BLOCK DESCRIPTION
% In each block all the 12 stimuli from a category are presented in random
% order. 750 msec fOr each image + 250 msec ISI (=central fixation cross).
% In each block there are either 0, 1 or 2 (this is randomly decided) target
% stimuli: a target is the repetition of the previous stimulus (N-back task). The
% participant has to press when he/she sees a target.
% Each block has a duration of 12, 13 or 14 s (depending if 0, 1 or 2 targets).


%TIME CALCULATION for each RUN
% 3 categories with 12 stimulus each;
% trial duration= 750msec stimulus + 250 msec ISI = 1s;
% block duration = 1 category in each block + 0/1/2 targets = 12/13/14s

% 1 pause of 8 s at the beginning of the run
% 24 pauses of 6s = 144s
% 24 blocks per run : minimum 288s / maximum 336s (according to 0, 1 or 2
% targets)

% MINIMUM DURATION = 440s (7min20sec) / MAXIMUM DURATION = 488s (8min08sec)
% Fixation cross to fill the time difference to get to 488s anyway. 


%TWO VARIANT OF THE LOCALIZER (to choose in the Global variable setting, alternate between subjects) :
%Set A
%Set B


%ACTION and VARIABLE SETTING
%The only variable you need to manually change is Cfg.device at the
%beginning of the script. Put either 'PC' or 'Scanner'.
%Once you will Run the script you will be asked to select some variables:
%1. Group (TO DEFINE): %%for the moment only controls so CON is defined as
%default
%2. SubID : first 2 letters of Name + first 2 letters of Surname (e.g. Stefania Mattioni == StMa).
%3. Run Number : 1st or 2nd run
%4. Stimuli ID: 'setA' or 'setB' (it is important to spell correctly this variable because these
%labels are used to select the correct stimuli folder in the script. In
%case this input is not given or it is mispelled. it will automatically
%pick the set A.

clear all;
clc;
Screen('Preference', 'SkipSyncTests', 1);

%% Device
%Cfg.device = 'PC'; %(Change manually: 'PC' or 'mri')
cfg.testingDevice = 'mri';
fprintf('Connected Device is %s \n\n',cfg.testingDevice);


%% SET THE MAIN VARIABLES
global  GlobalGroupID GlobalSubjectID GlobalRunNumberID GlobalStimuliID GlobalStartID

GlobalGroupID = 'CON'; %input ('Group (HNS-HES-HLS-DES):','s'); %%HNS: Hearing non signers; HES:Hearing early signers; HLS:Hearing late signers; DES:Deaf early signers
GlobalSubjectID=input('Subject ID (sub-XX): ', 's'); %% (BIDS format for subj name = sub-XX)
GlobalRunNumberID=input('Run Number(1 - 2): ', 's');
GlobalStartID = input('Start with stimuli set A/B:', 's'); %specify if the
%run should start with the stimuli subset A or B (alternate between and within subjects)

if strcmp(GlobalStartID,'A')
fprintf('Localizer Experiment: start with stimuli subset A \n\n');
elseif strcmp(GlobalStimuliID,'B')
fprintf('Localizer Experiment: start with stimuli subset B \n\n');
else 
% %if the input is empty take automatically set 1
% GlobalStimuliID='A';
% fprintf('Localizer Experiment: start with stimuli subset A \n\n');
end

%% TRIGGER
cfg.mri.triggerNb = 1;       % num of excluded volumes (first 2 triggers) [NEEDS TO BE CHECKED]
cfg.mri.triggerKey = 's';         % the keycode for the trigger

%% SETUP OUTPUT DIRECTORY AND OUTPUT FILE

%if it doesn't exist already, make the output folder
output_directory='output_files';
    if ~exist(output_directory, 'dir')
       mkdir(output_directory)
    end

output_file_name=[output_directory '/output_file_' GlobalGroupID '_' GlobalSubjectID '_ses-01_task-VisLoc_run-0' GlobalRunNumberID '_events.tsv']; 

logfile = fopen(output_file_name,'a');%'a'== PERMISSION: open or create file for writing; append data to end of file
fprintf(logfile, 'onset\tduration\ttrial_type\tstim_name\tloop_duration\tresponse_key\ttarget\ttrial_num\tblock_num\trun_num\tsubjID\tgroupID\n');


%% SET THE STIMULI/CATEGORY
CAT_WA={'WA01','WA02','WA03','WA04','WA05','WA06','WA07','WA08','WA09','WA10','WA11','WA12'}; %words subset A
CAT_HA={'HA01','HA02','HA03','HA04','HA05','HA06','HA07','HA08','HA09','HA10','HA11','HA12'}; %houses subset A
CAT_FA={'FA01','FA02','FA03','FA04','FA05','FA06','FA07','FA08','FA09','FA10','FA11','FA12'}; %faces subset A
CAT_FB={'FB01','FB02','FB03','FB04','FB05','FB06','FB07','FB08','FB09','FB10','FB11','FB12'}; %faces subset B
CAT_WB={'WB01','WB02','WB03','WB04','WB05','WB06','WB07','WB08','WB09','WB10','WB11','WB12'}; %words subset B
CAT_HB={'HB01','HB02','HB03','HB04','HB05','HB06','HB07','HB08','HB09','HB10','HB11','HB12'}; %houses subset B


%Set the repetition of 3 categories
All_catA={'WA','HA','FA'};
All_catB={'WB','HB','FB'};

%Set the block order for the whole run
if strcmp(GlobalStartID,'A')
    All_cat_rep=[Shuffle(All_catA) Shuffle(All_catB) Shuffle(All_catA) Shuffle(All_catB) Shuffle(All_catA) Shuffle(All_catB) Shuffle(All_catA) Shuffle(All_catB)];
elseif strcmp(GlobalStartID,'B')
    All_cat_rep=[Shuffle(All_catB) Shuffle(All_catA) Shuffle(All_catB) Shuffle(All_catA) Shuffle(All_catB) Shuffle(All_catA) Shuffle(All_catB) Shuffle(All_catA)];
% else  %if the input is empty take automatically set 1
%     GlobalStartID='A';
%     All_cat_rep=[Shuffle(All_catA) Shuffle(All_catB) Shuffle(All_catA) Shuffle(All_catB) Shuffle(All_catA)];
end

N_block=[1:length(All_cat_rep)]; 


Block_order=All_cat_rep;
nStim=length(CAT_WA); %this is the number of stimuli of each category


TAR=0; %%will be used to print target/non target stimuli
responseKey = 'n/a'; %will be used to print response when key press
run_duration = 488;

%OPEN THE SCREEN
[wPtr, rect]= Screen(('OpenWindow'),max(Screen('Screens'))); %open the screen
Screen('FillRect',wPtr,[180 180 180]); %draw a white rectangle (big as all the monitor) on the back buffer
Screen ('Flip',wPtr); %flip the buffer, showing the rectangle
HideCursor(wPtr);

% STIMULI SETTING
stimSize=400;
stimTime=0.75;
timeout=0.22; %Inter Stimulus Interval
trial_duration=0.97;
ISI_time=0;


% STIMULUS RECTANGLE (in the center)
screenWidth = rect(3);
screenHeight = rect(4);%-(rect(4)/3); %this part is to have it on the top of te screen
screenCenterX = screenWidth/2;
screenCenterY = screenHeight/2;
stimulusRect=[screenCenterX-stimSize/2 screenCenterY-stimSize/2 screenCenterX+stimSize/2 screenCenterY+stimSize/2];

% STIMULI FOLDER
stimFolder = 'Stimuli';

t='.tif';


% FIX CROSS
crossLength=40;
crossColor=[0 0 0];
crossWidth=5;
%Set start and end point of lines
crossLines=[-crossLength, 0; crossLength, 0; 0, -crossLength; 0, crossLength];
crossLines=crossLines';


%save the response keys into a cell array
Resp = num2cell(zeros(length(Block_order),length(CAT_WA))); 
Onset = zeros(length(Block_order),(length(CAT_WA)));
Name=num2cell(zeros(length(Block_order),(length(CAT_WA))));
Duration=zeros(length(Block_order),(length(CAT_WA)));

try  % safety loop: close the screen if code crashes
    %% TRIGGER
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Screen('TextSize', wPtr, 50);%text size
    DrawFormattedText(wPtr, '\n READY TO START \n \n - D?tectez les images r?p?t?es - ', ['center'],['center'],[0 0 0]);
    Screen('Flip', wPtr);
    
    waitForTrigger(cfg); %this calls the function from CPP github

    
    %Draw THE FIX CROSS
    Screen('DrawLines',wPtr,crossLines,crossWidth,crossColor,[screenCenterX,screenCenterY]);
    % Flip the screen
    Screen('Flip', wPtr);
    
    
    LoopStart = GetSecs();

    
    WaitSecs(8); %wait 8 sec at the beginning of the run
    
    %Block loop (12 stim)
    for b=1:length(Block_order)
        block_start=GetSecs();
        %Select the stimuli for this block
        if strcmp(Block_order{b},'WA')
            Stimuli=Shuffle(CAT_WA);
        elseif strcmp(Block_order{b},'HA')
            Stimuli=Shuffle(CAT_HA);
        elseif strcmp(Block_order{b},'FA')
            Stimuli=Shuffle(CAT_FA);
        elseif strcmp(Block_order{b},'WB')
            Stimuli=Shuffle(CAT_WB);
        elseif strcmp(Block_order{b},'HB')
            Stimuli=Shuffle(CAT_HB);
        elseif strcmp(Block_order{b},'FB')
            Stimuli=Shuffle(CAT_FB);
        end
        
        Stimuli=strcat(Stimuli,t);
        %Set the target for this block
        num_targets=[0 1 2]; %it will randomly pick one of thes
        nT = num_targets(randperm(length(num_targets),1));
        [~,idx]=sort(rand(1,nStim)); %sort randomly the stimuli in the block
        posT=sort((idx(1:nT))); %select the position of the target(s)
        disp (strcat('Number of targets in coming block:',num2str(nT)));
        
        %%stimulus loop %%%%%%%%%%%%%
        for n = 1:length(Stimuli)%% num of stimuli in each block
            Stim_start=GetSecs();
            keyIsDown=0;
            
            % LOAD AN IMAGE
            file{n} = Stimuli{n};
            [img] = imread(fullfile(stimFolder,file{n}));
            
            %DRAW THE STIMULUS
            imageDisplay = Screen('MakeTexture',wPtr, img);
            
            
                Screen('DrawTexture', wPtr, imageDisplay, [], stimulusRect);
                % FLIP SCREEN TO SHOW THE STIMULUS(after the cue has been on screen for the ISI)
                time_stim=Screen('Flip', wPtr);


%               %check the response during the stimulis presentation   
                while (GetSecs-(time_stim))<= stimTime
                    % register the keypress
                    [keyIsDown, secs, keyCode] = KbCheck(-1);
                    if keyIsDown && min(~strcmp(KbName(keyCode),cfg.mri.triggerKey))
                        responseKey = KbName(find(keyCode));
                    end
                end
                
                % Draw THE FIX CROSS
%                    Screen('DrawLines',wPtr,crossLines,crossWidth,crossColor,[screenCenterX,screenCenterY]);
%               % Flip the screen
                  ISI_time= Screen('Flip', wPtr,time_stim+stimTime);
                while (GetSecs-(ISI_time)) <= (timeout)
                    % register the keypress
                    [keyIsDown, secs, keyCode] = KbCheck(-1);
                    if keyIsDown && min(~strcmp(KbName(keyCode),cfg.mri.triggerKey))
                        responseKey = KbName(find(keyCode));
                    end
                end
                
            loop_end=GetSecs();
           
            fprintf(logfile, '%.2f\t%.2f\t%s\t%s\t%.2f\t%s\t%d\t%d\t%d\t%s\t%s\t%s\n', time_stim-LoopStart,stimTime,Stimuli{n}(1),Stimuli{n},loop_end-Stim_start,responseKey,TAR,n,b,GlobalRunNumberID,GlobalSubjectID,GlobalGroupID);


            TAR=0;%reset the Target hunter as 0 (==no target stimulus)
            responseKey = 'n/a'; %reset the response print to null
            
            Name(b,n)=Stimuli(n);
            Resp(b,n) = {responseKey};
            Onset(b,n)= time_stim-LoopStart;
            Duration(b,n)= stimTime;
            
            %% if this is a target repeat the same stimulus
            
            if sum(n==posT)==1
                TAR=1;
                %DRAW THE STIMULUS
                imageDisplay = Screen('MakeTexture',wPtr, img);
                

                    Screen('DrawTexture', wPtr, imageDisplay, [], stimulusRect);
                    % FLIP SCREEN TO SHOW THE STIMULUS(after the cue has been on screen for the ISI)
                    time_stim=Screen('Flip', wPtr);

                    %Draw THE FIX CROSS
%                     Screen('DrawLines',wPtr,crossLines,crossWidth,crossColor,[screenCenterX,screenCenterY]);
%                     % Flip the screen
                     ISI_time= Screen('Flip', wPtr,time_stim+stimTime);
                    
                    while (GetSecs-(time_stim+stimTime))<=(timeout)
                        
                        [keyIsDown, secs, keyCode] = KbCheck(-1);
                        if keyIsDown && min(~strcmp(KbName(keyCode),cfg.mri.triggerKey))
                            responseKey = KbName(find(keyCode));
                        end

                    end

                

                loop_end=GetSecs();
                
                fprintf(logfile, '%.2f\t%.2f\t%s\t%s\t%.2f\t%s\t%d\t%d\t%d\t%s\t%s\t%s\n', time_stim-LoopStart,stimTime,'target',Stimuli{n},loop_end-Stim_start,responseKey,TAR,n,b,GlobalRunNumberID,GlobalSubjectID,GlobalGroupID);

                

                TAR=0;%reset the Target hunter as 0 (==no target stimulus)
                responseKey = 'n/a'; %reset the response print to null
                
                Name_target(b,n)=Stimuli(n);
                Resp_target(b,n) = {responseKey};
                Onset_target(b,n)= time_stim-LoopStart;
                Duration_target(b,n)= stimTime;
            end %if this is a target
            
        end % for n stimuli
        block_end=GetSecs();
        block_duration=block_end-block_start;
        disp (strcat('Block duration:',num2str(block_duration)));
        
                            %Draw THE FIX CROSS
                    Screen('DrawLines',wPtr,crossLines,crossWidth,crossColor,[screenCenterX,screenCenterY]);
                    % Flip the screen
                    ISI_time= Screen('Flip', wPtr);
                    

        length_IBI = 6;
           WaitSecs(length_IBI); 
% % %         end
IBI_variable(b,1)=length_IBI;
    end%for b(lock)
    
    LoopEnd=GetSecs();
    loop_duration = (LoopEnd-LoopStart);
    disp(strcat('Timing : the run took (min)', num2str((loop_duration)/60)));
    disp(strcat('Timing : the run took (sec)', num2str(loop_duration))); 

    
%Draw THE FIX CROSS
    Screen('DrawLines',wPtr,crossLines,crossWidth,crossColor,[screenCenterX,screenCenterY]);
% Flip the screen
    length_endFix = (run_duration - loop_duration);
    endFix_time = Screen('Flip', wPtr);
    
    WaitSecs(length_endFix);
    
    RunEnd = GetSecs();
    disp(strcat('Timing : the run closed after (sec)', num2str(RunEnd-LoopStart)));
    
    Screen(wPtr,'Close');
    sca;
    
    
catch
    clear Screen;
    %% Close serial port of the scanner IF CRASH OF THE CODE
    if strcmp(cfg.testingDevice,'mri')
        CloseSerialPort(SerPor);
    end
    error(lasterror)
end
WaitSecs(1)%wait 1 sec before to finish

cd('output_files')
save(strcat (GlobalSubjectID,'_',GlobalStimuliID,'_Onsetfile_',GlobalRunNumberID,'.mat'),'Onset','Name','Duration','Resp','Onset_target','Name_target','Duration_target','Resp_target','IBI_variable');