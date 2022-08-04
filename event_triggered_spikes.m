function [Averages,Save]=event_triggered_spikes(TimeStampsCell,EventTimeStampsON,cellnum,xlims,binsize,plotgraph)
if nargin<5
    binsize=.25;
end
if nargin<6
    plotgraph=1;
end
sp=single(vertcat(TimeStampsCell{cellnum}))/30000;
EventTimeStampsON=single(EventTimeStampsON)/30000;
ts=min(sp):binsize:max(max(sp),max(EventTimeStampsON)+xlims(2)/binsize);
[binnedspikedata]=histc(sp, ts-binsize/2);
% [Avs, StdErr, Save] = TimeTriggeredAv(binnedspikedata, (min(sp):binsize:max(sp))+binsize/2, 1./binsize, abs(xlims(1))*1e3, xlims(2)*1e3,EventTimeStampsON);
% if nargout>1
%     Save=vertcat(Save{:});
% end
Save=event_triggered_signal(binnedspikedata,ts,EventTimeStampsON,ceil(abs(xlims(1))/binsize),ceil(xlims(2)/binsize));
Save=Save/binsize;
Averages=nanmean(Save);
if plotgraph
figure
h=zeros(1,2);
h(1)=subplot(2,1,1);
bar(linspace(xlims(1),xlims(2),length(Averages)),Averages)
box off
set(gca,'TickDir','out')
ylabel('Firing Rate (Hz)')
xlabel('time (s)')
title('Time Triggered Average')
h(2)=subplot(2,1,2);
for trialnum=1:length(EventTimeStampsON)
    zeroedraster=sp-EventTimeStampsON(trialnum);
    zeroedraster=zeroedraster(zeroedraster<xlims(2) & zeroedraster>xlims(1))';
%     interleave=ceil(numel(zeroedraster)/1000);
%     zeroedraster=zeroedraster(1:interleave:end);
    rasterplot_atheir(trialnum,zeroedraster);
end
box off
set(gca,'TickDir','out')
set(gca,'YTick',[])
linkaxes(h,'x')
end