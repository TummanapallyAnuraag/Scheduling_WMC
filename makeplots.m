main;
dir = pwd;
% plot performance metric over number of users Vs different scheduling techniques
bar(20:20:100,final_jn_fnss_ndx);
fullname = [dir,'/pictures/jain_index_Vs_usrs.eps'];
xlabel('Time');
ylabel('Jain Fainess Index');
legend('MT','TTA','PF');
print(gcf,'-deps','-color',fullname);
bar(20:20:100,final_avg_usr_tp);
fullname = [dir,'/pictures/avg_tp_Vs_usrs.eps'];
xlabel('Time');
ylabel('Average ThroughPut for user');
legend('MT','TTA','PF');
print(gcf,'-deps','-color',fullname);
bar(20:20:100,final_cell_tp)
fullname = [dir,'/pictures/cell_tp_Vs_usrs.eps'];
xlabel('Time');
ylabel('Cell Throughput');
legend('MT','TTA','PF');
print(gcf,'-deps','-color',fullname);