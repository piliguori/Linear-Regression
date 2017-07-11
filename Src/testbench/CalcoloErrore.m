dataset_file = 'dataset.txt';
vivado_output_file = 'outputPostImp.txt';
error_file = 'errorPostImp.csv';

dataset=textread(dataset_file,'%s');
m_matlab_bin= dataset(3:4:end);
q_matlab_bin= dataset(4:4:end);
m_matlab=bin2num(quantizer([24 13]),m_matlab_bin);
q_matlab=bin2num(quantizer([24 21]),q_matlab_bin);
m_matlab=cell2mat(m_matlab);
q_matlab=cell2mat(q_matlab);

out=textread(vivado_output_file, '%s');
m_vivado_bin =  out(1:2:end);
q_vivado_bin =  out(2:2:end);
m_vivado=bin2num(quantizer([24 13]),m_vivado_bin);
q_vivado=bin2num(quantizer([24 21]),q_vivado_bin);
m_vivado=cell2mat(m_vivado);
q_vivado=cell2mat(q_vivado);

error_abs_m= abs(m_vivado - m_matlab);
error_abs_q=abs(q_vivado-q_matlab);
error_rel_m=abs(m_vivado-m_matlab)./m_matlab;
error_rel_q=abs(q_vivado-q_matlab)./q_matlab;


T = table(m_matlab,  q_matlab,m_vivado,q_vivado, error_abs_m, error_abs_q, error_rel_m, error_rel_q);
writetable(T, error_file,'WriteRowNames',true);