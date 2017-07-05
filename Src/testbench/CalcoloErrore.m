dataset=textread('dataset.txt','%s');
m_matlab_bin= dataset(3:4:end);
q_matlab_bin= dataset(4:4:end);
m_matlab=bin2num(quantizer([24 14]),m_matlab_bin);
q_matlab=bin2num(quantizer([24 23]),q_matlab_bin);
m_matlab=cell2mat(m_matlab);
q_matlab=cell2mat(q_matlab);

out=textread('output.txt', '%s');
m_vivado_bin =  out(1:2:end);
q_vivado_bin =  out(2:2:end);
m_vivado=bin2num(quantizer([24 14]),m_vivado_bin);
q_vivado=bin2num(quantizer([24 23]),q_vivado_bin);
m_vivado=cell2mat(m_vivado);
q_vivado=cell2mat(q_vivado);

error_m= abs(m_vivado - m_matlab);
error_q=abs(q_vivado-q_matlab);


