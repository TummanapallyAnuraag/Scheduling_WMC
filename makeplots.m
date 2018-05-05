main;
dir = pwd;
% plot performance metric over number of users Vs different scheduling techniques
bar(20:20:100,final_jn_fnss_ndx);
fullname = [dir,'/pictures/jain_index_Vs_usrs.eps'];
xlabel('UE count');
ylabel('Jain Fainess Index');
legend('MT','TTA','PF');
print(gcf,'-deps','-color',fullname);
bar(20:20:100,final_avg_usr_tp);
fullname = [dir,'/pictures/avg_tp_Vs_usrs.eps'];
xlabel('UE count');
ylabel('Average ThroughPut for user (bits per seconds)');
legend('MT','TTA','PF');
print(gcf,'-deps','-color',fullname);
bar(20:20:100,final_cell_tp)
fullname = [dir,'/pictures/cell_tp_Vs_usrs.eps'];
xlabel('UE count');
ylabel('Cell Throughput (bits per seconds)');
legend('MT','TTA','PF');
print(gcf,'-deps','-color',fullname);