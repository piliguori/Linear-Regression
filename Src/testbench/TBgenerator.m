
n=25;               % Number of elements for test
fs=20460000;        % Sampling frequency (Hz)
dt=1/fs;            % Time step (s)
T_P=0.001;          % Length of 1 primary code (s)
x=(0:n-1)*T_P;      % Time distance between points (s)
t_fast = (0:1/fs:T_P-1/fs); % fast time axis [s]
myFile='dataset.txt';       % Filename
    fid = fopen(myFile,'w');        % Open file

for j=1:10000
    
    sig=zeros(1,n);
    sig(1)=rand()-0.5; % This signal simulates the output of an atan2 module
    for i=2:length(sig)
        sig(i)=sig(i-1)+rand()-0.2;
    end
    sig=unwrap(sig);
    % Since we have unwrapped a +-1 signal, this will have a plausible range of
    % more than 1 bit integer part. we'll use a 4 bit integer part.
    % Now we have a plausible set of data

    % Compute constants:
    sx=sum(x);
    s2x=(sum(x)).^2;
    sx2=sum(x.^2);
    div1=1/((n*sx2)-s2x);

    % Compute operations
    s1=sum(sig);
    s2=sum(x.*sig);
    m = (n*s2 - s1*sx) *div1;
    q = (s1*sx2 - sx*s2) *div1;
    
    
%     m(j,1) = (n*s2 - s1*sx) *div1;
%     q (j,1)= (s1*sx2 - sx*s2) *div1;
%     sum1(j,1)=s1;
%     sum2(j,1)=s2;
%     
%     mult3(j,1)= n*s2;
%     mult1(j,1)= s1*sx;
%     
%     mult2(j,1)=sx*s2;
%     mult4(j,1)=s1*sx2;
%     
%     sub5(j,1)=n*s2 - s1*sx;
%     sub6(j,1)=s1*sx2 - sx*s2;


    % %% Write data on file
    
     s1_bin = num2bin(quantizer([24 15]),s1); % Generate binary string
     s2_bin = num2bin(quantizer([24 21]),s2);
     m_bin = num2bin(quantizer([24 13]),m);
     q_bin = num2bin(quantizer([24 21]),q); 
     fwrite(fid,[s1_bin char(32) s2_bin char(32) m_bin char(32) q_bin char(32) char(13) char(10)]); % Remember to add \r\n to end lines!

                  
end
fclose(fid);