function []=plot_schematicAppen(type,dim,noise,n)

% type=6;n=100;dim=1;noise=1;
% CorrSimPlotsA(type,n,dim,noise,pre1);
% Used to generate figure A in the files

%% % File path searching
if nargin<1
    type=8;
end
if nargin<2
    dim=1;
end
if nargin<3
    noise=0.3;
end
if nargin<4
    n=100;
end

fpath = mfilename('fullpath');
fpath=strrep(fpath,'\','/');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-2));
addpath(genpath(strcat(rootDir,'Code/')));

try
     load(strcat(rootDir,'Data/Results/CorrFigure1Type',num2str(type),'n',num2str(n),'dim',num2str(dim),'.mat')); % The folder to locate data
catch
    display('no file exist, running instead')
    run_fig1Data(type,n,dim,noise);
    load(strcat(rootDir,'Data/Results/CorrFigure1Type',num2str(type),'n',num2str(n),'dim',num2str(dim),'.mat')); % The folder to locate data
end

fontSize=22;
mkSize=20;
sameBar=0;

%% plotting parameters

cmap=zeros(2,3);
gray = [0.5,0.5,0.5];
map2 = brewermap(128,'PiYG'); % brewmap
map3 = map2(size(map2,1)/2+1:end,:);
% map3 = brewermap(128,'Greens'); % brewmap
map4 = brewermap(128,'BuPu'); % brewmap
s=3;t=5;
gr=map2(120,:);
pu=map2(8,:);
map3 = brewermap(128,'PiYG'); % brewmap
loca=map3(100,:);
glob=[0.5,0.5,0.5];
mgc='green';
cmap(1,:) = pu;
cmap(2,:) = gr;
map1=cmap;
set(groot,'defaultAxesColorOrder',map1);

% [left,bottom,width,height]
height=0.21; %18; %21;
width=height-0.04; %17;
hspace=0;
vspace=0.09;
for i=1:6
    left(i)=0.01+(i-1)*(width+hspace);
    bottom(i)=0.06+(i-1)*(height+vspace);
end
bottom(3)=bottom(3)+0.01;
bottom(2)=bottom(2);
bottom(1)=bottom(1)-0.025;
left(5)=left(5)+0.03;
left(6)=left(6)+0.09;
left(2:end)=left(2:end)+0.02;
left=left+0.01;
left(1)=left(1)-0.016; 

fig=figure(1); clf
set(gcf,'units','normalized','position',[0 0 1 1])


%%  Col 1
% ax=subplot(s,t,t+1);
ax=subplot('Position',[left(1), bottom(2), width, height]);
cla,


hold all
set(groot,'defaultAxesColorOrder',map2);
plot(x,y,'.','MarkerSize',mkSize,'Color',gray);
xlabel('x')
ylabel('y')

if type~=8
    I=2;J=4;J2=n;
else
    I=20;J=21;J2=n-5;
end
% [I,J]=ind2sub([n,n],find(C_MGC>0.1,1,'first'));
% J2=find(mcorrH(J,:)<0,1,'last');
% ids=unique([I,J]);
% xx=15;
id=[I,J,J2,J];
id2=[1,2,3,2];
col=[1 .5 0];
hy=[-0.5,+0.5,0];

for ind=[1,2,3]; %length(id)
    hs=0.2;
    text(x(id(ind))+hs,y(id(ind))+hy(ind),num2str(ind),'fontsize',fontSize,'color',col)
    plot(x(id(ind)),y(id(ind)),'.','MarkerSize',mkSize,'Color',col);
end

tname=CorrSimuTitle(type);
findex=strfind(tname,'.');
tname=tname(findex+1:end);
xlim([min(x)-0.2, max(x)]);
ylim([min(y)-0.2, max(y)]);

% title(['0. ', [tname], ' (X,Y)'], 'Units', 'normalized', ...
title([{'0. Sample Data'}], 'Units', 'normalized', ...
    'Position', [0 1.1], 'HorizontalAlignment', 'left')
set(gca,'XTick',[],'YTick',[],'FontSize',fontSize); % Remove x axis tick
pos=[nan, nan, width, height];
axis('square')


% make table
clc

MantelVec=[C(id(1),id(2)), D(id(1),id(2)), mantelH(id(1),id(2)), C(id(3),id(4)), D(id(3),id(4)), mantelH(id(3),id(4)), mantelH(id(1),id(2))+mantelH(id(3),id(4))];
McorrVec=[A(id(1),id(2)), B(id(1),id(2)), mcorrH(id(1),id(2)), A(id(3),id(4)), B(id(3),id(4)), mcorrH(id(3),id(4)), mcorrH(id(1),id(2))+mcorrH(id(3),id(4))];
MGCVec=[A_MGC(id(1),id(2)), B_MGC(id(1),id(2)), A_MGC(id(1),id(2))*B_MGC(id(1),id(2)), A_MGC(id(3),id(4)), B_MGC(id(3),id(4)), A_MGC(id(3),id(4)) * B_MGC(id(3),id(4)), A_MGC(id(1),id(2))*B_MGC(id(1),id(2))+A_MGC(id(3),id(4)) * B_MGC(id(3),id(4))];

[MantelVec; McorrVec; MGCVec]'
display(['k=', num2str(k), ' l=',num2str(l)])

formatSpec = 'k= %1i, l= %1i\n\n';
fprintf(formatSpec,k,l)

formatSpec = '\n & Mantel & Mcorr & MGC \\\\ \n';
fprintf(formatSpec)
formatSpec = '\n $\\delta_x$(%i,%i) & %1.2f & %1.2f & %1.2f  \\\\ \n $\\delta_y$(%i,%i) & %1.2f & %1.2f & %1.2f  \\\\ \n $\\delta_x \\times \\delta_y$ & %1.2f & %1.2f & %1.2f  \\\\ \n \n';
fprintf(formatSpec,id2(1),id2(2),C(id(1),id(2)),A(id(1),id(2)),A_MGC(id(1),id(2)),...
    id2(1),id2(2),D(id(1),id(2)),B(id(1),id(2)),B_MGC(id(1),id(2)),...
    mantelH(id(1),id(2)),mcorrH(id(1),id(2)),A_MGC(id(1),id(2))*B_MGC(id(1),id(2)))
fprintf('\\hline\n\n')
formatSpec = '\n $\\delta_x$(%i,%i) & %1.2f & %1.2f & %1.2f  \\\\ \n $\\delta_y$(%i,%i) & %1.2f & %1.2f & %1.2f  \\\\ \n $\\delta_x \\times \\delta_y$ & %1.2f & %1.2f & %1.2f  \\\\ \n \n';
fprintf(formatSpec,id2(3),id2(4),C(id(3),id(4)),A(id(3),id(4)),A_MGC(id(3),id(4)),...
    id2(3),id2(4),D(id(3),id(4)),B(id(3),id(4)),B_MGC(id(3),id(4)),...
    mantelH(id(3),id(4)),mcorrH(id(3),id(4)),A_MGC(id(3),id(4)) * B_MGC(id(3),id(4)))

fprintf('\\hline\n\n')

formatSpec = '\n $\\sum \\delta_x \\times \\delta_y$ & %1.2f & %1.2f & %1.2f  \\\\ \n \n';
fprintf(formatSpec,sum(sum(mantelH)), sum(sum(mcorrH)),sum(sum(C_MGC)));
fprintf(formatSpec,sum(sum(mantelH))/norm(C,'fro')/norm(D,'fro'), sum(sum(mcorrH))/norm(A,'fro')/norm(B,'fro'),sum(sum(C_MGC))/norm((A_MGC-mean(mean(A_MGC))),'fro')/norm((B_MGC--mean(mean(B_MGC))),'fro'));

%% permute sample order

xynorm=sum([x,y]').^2';
[foo, bar]=sort(xynorm);
bar=1:n;
bar=randperm(n);
bar(find(bar==I))=bar(1);
bar(1)=I;
bar(find(bar==J))=bar(2);
bar(2)=J;
bar(find(bar==J2))=bar(3);
bar(3)=J2;
%% Mantel


% A Mantel
% ax=subplot(s,t,2); %
ax=subplot('Position',[left(2), bottom(3), width, height]);
hold all
if sameBar==1
    maxC=ceil(max(max([C,D]))*10)/10;
    minC=ceil(min(min([C,D]))*10)/10;
else
    maxC=ceil(max(max(C))*10)/10;
    minC=ceil(min(min(C))*10)/10;
end
minC=min(minC,-maxC);maxC=max(maxC,-minC);
imagesc(C(bar,bar)');
caxis([minC,maxC]);
set(gca,'YDir','normal')
set(gca,'FontSize',16); % Remove y axis ticks
%xlabel('# X Neighbors','FontSize',fontSize, 'Units', 'normalized', ...
 %   'Position', [0 -0.16], 'HorizontalAlignment', 'left')
%ylabel('# Y Neighbors','FontSize',fontSize, 'Units', 'normalized', ...
 %   'Position', [-0.25 0.4], 'VerticalAlignment', 'bottom')
% 'Position', [-0.2 -0.05], 'HorizontalAlignment', 'Left')
text(45,110,'$\tilde{A}$','interpreter','latex','FontSize',fontSize)
title([{'1. Mantel'}; %{'(pairwise distances)'}; 
    {' ' }],'FontSize',fontSize-1, 'Units', 'normalized', ...
    'Position', [0 1], 'HorizontalAlignment', 'left');
% title([{'Mantel'}; {' '}],'FontSize',fontSize);
clean_panel(ax,map2,pos,id,n,col,fontSize)
set(gca,'visible','on')
set(gca,'XTick',[2,round(n/2),n],'XtickLabel',[1,round(n/2),n]); % Remove x axis ticks
set(gca,'YTick',[2.5,round(n/2),n],'YtickLabel',[1,round(n/2),n]); % Remove x axis ticks

% B Mantel
% ax=subplot(s,t,t+2);
ax=subplot('Position',[left(2), bottom(2), width, height]);
hold all
if sameBar~=1
    maxC=ceil(max(max(D))*10)/10;
end
imagesc(D(bar,bar)');
set(gca,'FontSize',16)
% colormap(ax,map3);
caxis([minC,maxC]);
set(gca,'YDir','normal')
set(gca,'FontSize',13); % Remove y axis ticks
title('$\tilde{B}$','interpreter','latex','FontSize',fontSize);
clean_panel(ax,map2,pos,id,n,col,fontSize)


% C Mantel
% ax=subplot(s,t,2*t+2);
ax=subplot('Position',[left(2), bottom(1), width, height]);
hold all
MH=ceil(max(max(mantelH(2:end,2:end))));
mH=floor(min(min(mantelH(2:end,2:end))));
mH=min(mH,-MH);
MH=max(MH,-mH);
imagesc(mantelH(bar,bar)');
set(gca,'YDir','normal')
title('$$\tilde{C} = \tilde{A} \circ \tilde{B}$$','FontSize',fontSize,'interpreter','latex');
caxis([mH,MH]);
colorbar('location','westoutside')
clean_panel(ax,map2,pos,id,n,col,fontSize)


%% Mcorr
if sameBar==1
    minC=floor(min(min([A,B]))*10)/10;maxC=ceil(max(max([A,B]))*10)/10;
else
    minC=floor(min(min([A]))*10)/10;maxC=ceil(max(max([A]))*10)/10;
end
minC=min(minC,-maxC);maxC=max(maxC,-minC);


% A Mcorr
% ax=subplot(s,t,3);
ax=subplot('Position',[left(3), bottom(3), width, height]);
hold all
imagesc(A(bar,bar)');
set(gca,'YDir','normal')
caxis([minC,maxC]);
text(45,110,'$A$','interpreter','latex','FontSize',fontSize)
title([{'2. Mcorr'}; %{'(single center)'}; 
    {' '}],'FontSize',fontSize-1, 'Units', 'normalized', ...
    'Position', [0 1], 'HorizontalAlignment', 'left')
clean_panel(ax,map2,pos,id,n,col,fontSize)


% B MCorr
% ax=subplot(s,t,t+3);
ax=subplot('Position',[left(3), bottom(2), width, height]);
hold all
if sameBar==1
    minD=floor(min(min([A,B]))*10)/10;maxD=ceil(max(max([A,B]))*10)/10;
else
    minD=floor(min(min([B]))*10)/10;maxD=ceil(max(max([B]))*10)/10;
end
minD=min(minD,-maxD);maxD=max(maxD,-minD);
imagesc(B(bar,bar)');
set(gca,'YDir','normal')
set(gca,'FontSize',fontSize)
caxis([minD,maxD]);
title('$$B$$','interpreter','latex');
clean_panel(ax,map2,pos,id,n,col,fontSize)


% C MCorr
% ax=subplot(s,t,2*t+3);
ax=subplot('Position',[left(3), bottom(1), width, height]);
hold all
MH=ceil(max(max(mcorrH(2:end,2:end))));
mH=floor(min(min(mcorrH(2:end,2:end))));
mH=min(mH,-MH);
MH=max(MH,-mH);
imagesc(mcorrH(bar,bar)');
set(gca,'YDir','normal')
title('$$C = A \circ B$$','FontSize',fontSize,'interpreter','latex');
clean_panel(ax,map2,pos,id,n,col,fontSize)



%% MGC


% A MGC
% ax=subplot(s,t,4);
ax=subplot('Position',[left(4), bottom(3), width, height]);
hold all
imagesc(A_MGC(bar,bar)');
caxis([minC,maxC]);
set(gca,'YDir','normal')
text(45,110,'$A^{k}$','interpreter','latex','FontSize',fontSize)
title([{'3. MGC^k^,^l'}; %{'(local scale)'}; 
    {' '}],'FontSize',fontSize-1,...
    'Units', 'normalized','Position', [0 1], 'HorizontalAlignment', 'left')
clean_panel(ax,map2,pos,id,n,col,fontSize)


% B MGC
% ax=subplot(s,t,t+4);
ax=subplot('Position',[left(4), bottom(2), width, height]);
hold all
imagesc(B_MGC(bar,bar)');
caxis([minD,maxD]);
set(gca,'YDir','normal')
title('$$B^{l}$$','interpreter','latex');
clean_panel(ax,map2,pos,id,n,col,fontSize)

% C MGC
% ax=subplot(s,t,2*t+4);
ax=subplot('Position',[left(4), bottom(1), width, height]);
cla, hold all
MH=ceil(max(max(C_MGC(2:end,2:end))));
mH=floor(min(min(C_MGC(2:end,2:end))));
mH=min(mH,-MH);MH=max(MH,-mH);
imagesc(C_MGC(bar,bar)');
set(gca,'YDir','normal')
caxis([mH,MH]);
title('$$C^{kl} = A^{k} \circ B^{l}$$','interpreter','latex');
clean_panel(ax,map2,pos,id,n,col,fontSize)

%% Col5 Multiscale Test Statistics
% ax=subplot(s,t,2*t+t);
ax=subplot('Position',[left(5), bottom(3), width, height]);
hold on
set(groot,'defaultAxesColorOrder',map1);
kmin=2;
ph=tA(kmin:n,kmin:n)';
%indPower=find(ph>=(max(max(ph))-0.03));% All scales of 0.03 power diff with max
% ph(indPower)=2;
imagesc(ph);
plot(n-1,n-1,'.','markerSize',40,'MarkerFaceColor',glob,'Color',glob)
plot(k-1,l-1,'g.','markerSize',40)
hold off

set(gca,'FontSize',fontSize)
set(gca,'YDir','normal')
cmap=map4;
colormap(ax,cmap)
hm=ceil(max(max(ph))*100)/100;
hm=ceil(prctile(ph(ph<1),99)*100)/100;
caxis([0 hm])
h=colorbar('Ticks',[0,hm/2,hm]);%,'location','westoutside');
set(h,'FontSize',fontSize);
xlim([1 n-1]);
ylim([1 n-1]);
set(gca,'XTick',[2.5,round(n/2)-1,n-1],'YTick',[2.5,round(n/2)-1,n-1],'XTickLabel',[2,round(n/2),n],'YTickLabel',[2,round(n/2),n],'FontSize',16);
set(gca,'XTick',[],'YTick',[])
pos = get(ax,'position');
% xlabel('# X Neighbors','FontSize',fontSize, ...
%     'Units', 'normalized','Position', [0 -0.2], 'HorizontalAlignment', 'left')
% ylabel('# Y Neighbors','FontSize',fontSize, ...
%     'Units', 'normalized','Position', [-0.2 0], 'HorizontalAlignment', 'left')
% text(-1,73,'4. Multiscale Maps','fontSize',fontSize,'fontweight','bold');
% title(1,60,[{'4. Multiscale Maps'}; {'(all scales)'}; {' '}],'FontSize',fontSize,...
%     'Units', 'normalized','Position', [0 1.1], 'HorizontalAlignment', 'left')
title([{'4. Multiscale Maps'}; %{'(all scales)'}; 
    {' ' }],'FontSize',fontSize-1, 'Units', 'normalized', ...
    'Position', [0 1], 'HorizontalAlignment', 'left');
% title('Local Correlations','fontweight','normal','FontSize',fontSize);
xlabel('# X Neighbors','FontSize',fontSize, 'Units', 'normalized', ...
    'Position', [0 -0.1], 'HorizontalAlignment', 'left')
ylabel('# Y Neighbors','FontSize',fontSize, 'Units', 'normalized', ...
    'Position', [-0.1 0.4], 'VerticalAlignment', 'bottom')
text(10,110,'MGC Image','FontSize',fontSize)
axis('square')
clean_panel(ax,map4,pos,id,n,col,fontSize)

%% Col5 Multiscale Power Maps
% ax=subplot(s,t,2*t+t);
ax=subplot('Position',[left(5), bottom(2), width, height]);
hold on
set(groot,'defaultAxesColorOrder',map1);
kmin=2;
ph=powerMLocal(kmin:n,kmin:n)';
indPower=find(ph>=(max(max(ph))-0.03));% All scales of 0.03 power diff with max
% ph(indPower)=2;
imagesc(ph);
plot(n-1,n-1,'.','markerSize',40,'MarkerFaceColor',glob,'Color',glob)
plot(k-1,l-1,'g.','markerSize',40)
hold off

set(gca,'FontSize',fontSize)
set(gca,'YDir','normal')
cmap=map4;
colormap(ax,cmap)
caxis([0 1])
h=colorbar('Ticks',[0,0.5,1]);%,'location','westoutside');
set(h,'FontSize',fontSize);
xlim([1 n-1]);
ylim([1 n-1]);
set(gca,'XTick',[2.5,round(n/2)-1,n-1],'YTick',[2.5,round(n/2)-1,n-1],'XTickLabel',[2,round(n/2),n],'YTickLabel',[2,round(n/2),n],'FontSize',16);
set(gca,'XTick',[],'YTick',[])
pos = get(ax,'position');
%xlabel('# of X Neighbors','FontSize',fontSize, ...
%      'Units', 'normalized','Position', [0 -0.2], 'HorizontalAlignment', 'left')
%ylabel('# of Y Neighbors','FontSize',fontSize, ...
%       'Units', 'normalized','Position', [-0.2 0], 'HorizontalAlignment', 'left')
%text(-1,73,'4. Multiscale Maps','fontSize',fontSize,'fontweight','bold');
%text(19,55,'Power','FontSize',fontSize)
title('Powers','fontweight','normal','FontSize',fontSize);
axis('square')
clean_panel(ax,map4,pos,id,n,col,fontSize)

%% Col5 multiscale p-value map
% ax=subplot(s,t,t+t);
ax=subplot('Position',[left(5), bottom(1), width, height]);
hold on

%set(groot,'defaultAxesColorOrder',map1);
kmin=2;
% pMLocal(pMLocal<=eps)=0.005;
ph=pMLocal';
% ph(indP)=0.00001;
imagesc(log(ph)); %log(ph)-min(log(ph(:))));

set(gca,'FontSize',fontSize)
set(gca,'YDir','normal')
cmap=map4;
colormap(ax,flipud(cmap));
%ceil(max(max(ph))*10)/10
% caxis([0 1]);
cticks=[0.001, 0.01, 0.1, 0.5];

h=colorbar('Ticks',log(cticks),'TickLabels',cticks);%,'location','westoutside');
set(h,'FontSize',fontSize);
% set(gca,'XTick',[1,round(n/2)-1,n-1],'YTick',[1,round(n/2)-1,n-1],'XTickLabel',[2,round(n/2),n],'YTickLabel',[2,round(n/2),n],'FontSize',16);
set(gca,'XTick',[],'YTick',[])
%xlabel('# of Neighbors for X','FontSize',16)
%ylabel('# of Neighbors for Y','FontSize',16) %,'Rotation',0,'position',[-7,20]);
% xlim([1 n-1]);
% ylim([1 n-1]);
% plot([n-2:n-2],[n-2:n-1],'-m','linewidth',2)
% plot([n-1:n-1],[n-2:n-1],'-m','linewidth',12)
% plot(k,l,'s','color',glob,'markerSize',5,'MarkerFaceColor',glob)
% plot(k,l,'s','color',loca,'markerSize',5,'MarkerFaceColor',loca)
plot(n-1,n-1,'.','markerSize',40,'MarkerFaceColor',glob,'Color',glob)
plot(k-1,l-1,'g.','markerSize',40)

% draw boundary around optimal scale
%[pval,indP]=MGCScaleVerify(ph,1000);
indP=optimalInd;
%disp(strcat('Approximated MGC p-value: ',num2str(pval)));
% indP=indP(2:end,2:end)';
[J,I]=ind2sub(size(ph),indP);
Ymin=min(I);
Ymax=max(I);
Xmin=min(J);
Xmax=max(J);

lw=1.5;
% plot([Xmin,Xmin],[Ymin,Ymax],'g','linewidth',lw)
% plot([Xmax,Xmax],[Ymin,Ymax],'g','linewidth',lw)
% plot([Xmin,Xmax],[Ymin,Ymin],'g','linewidth',lw)
% plot([Xmin,Xmax],[Ymax,Ymax],'g','linewidth',lw)
xlim([2,n]);
ylim([2,n]);
%     imagesc(k,l,1);
hold off
title('P-Values','fontweight','normal','FontSize',fontSize);
axis('square')
pos2 = get(ax,'position');
pos2(3:4) = [pos(3:4)];
set(ax,'position',pos2);
%clean_panel(ax,map4,pos,id,n,col,fontSize)
%%
pre2=strcat(rootDir,'Figures/');% The folder to save figures
donzo=1;
if donzo==1
    F.fname=strcat(pre2, 'FigA');
else
    F.fname=strcat(pre2, 'Auxiliary/A2_type', num2str(type),'_n', num2str(n), '_noise', num2str(round(noise*10)));
end
F.wh=[10 6.5]*2;
F.PaperPositionMode='auto';

print_fig(gcf,F)

%
%% Col 5 p-value
% subplot(s,t,t)
glob='cyan';
fig=figure(2); clf
fs=fontSize+2;
%ax=subplot('Position',[left(1), bottom(1)+width/2+0.01, width, height]);
tN=zeros(rep,n,n);
% testN=zeros(rep,1);
% pMLocal=zeros(n,n);
% pMGC=0;
for r=1:rep;
    per=randperm(n);
    tmp=MGCLocalCorr(C,D(per,per),'mcor');
%     tmp2=MGCSampleStat(tmp);
    tN(r,:,:)=tmp;
%     testN(r)=tmp2;
%     pMLocal=pMLocal+(tmp>=tA)/rep;
%     pMGC=pMGC+(tmp2>=test)/rep;
end

minp=min([min(tN(:,n,n)),min(tN(:,k,l)),tA(k,l),tN(n,n)]);
minp=floor(minp*10)/10;
maxp=max([max(tN(:,n,n)),max(tN(:,k,l)),tA(k,l),tN(n,n)]);
maxp=ceil(maxp*10)/10;
% p=tN(:,k,l);
% [f1,xi1]=ksdensity(p,'support',[-1,1]);
p=tN(:,n,n);
[f,xi]=ksdensity(p,'support',[-1,1]);
p=testN;
[f2,xi2]=ksdensity(p,'support',[-1,1]);

hold on
plot(xi,f,'.-','LineWidth',4,'Color',glob);
% plot(xi1,f1,'.-','LineWidth',4,'Color',loca);
plot(xi2,f2,'.-','LineWidth',4,'Color',mgc);
set(gca,'FontSize',15);
% x1=round(tA(end)*100)/100;
x1=abs(sum(sum(mcorrH))/norm(A,'fro')/norm(B,'fro'));x2=sum(sum(C_MGC))/norm((A_MGC-mean(mean(A_MGC))),'fro')/norm((B_MGC--mean(mean(B_MGC))),'fro');
x1=round(x1*100)/100;x2=round(x2*100)/100;x3=round(test*100)/100;
plot(x1,0.1,'*','MarkerSize',12,'Color',glob,'linewidth',2);
% plot(x2,0.1,'*','MarkerSize',12,'Color',loca,'linewidth',2);
plot(x3,0.1,'*','MarkerSize',12,'Color',mgc,'linewidth',2);
% if x1<x3
    set(gca,'XTick',sort([x1,x3]),'TickLength',[0 0],'XTickLabel',sort([x1,x3]));
% else
%     set(gca,'XTick',sort([x3,x2,x3]),'TickLength',[0 0],'XTickLabel',sort([x1,x2,x3]));
% end
% set(gca,'XTickLabel',[x1;x2],'YTick',[]); % Remove x axis ticks

% x1 = tA(end);
ind=find(xi>x1,1,'first');
% x2 = tA(k,l);
% x3=test;
y1=max(f)+2;
y2 = 2;
% y3 = 5;
%txt1 = {'Mcorr';['p = ' num2str(pMLocal(end))]};
txt1 = strcat('$$p(c) =', num2str(pMLocal(end)),'$$');
% txt2 = strcat('$$p(c^{*}) = ', num2str(pMLocal(k,l)),'$$');
txt3 = strcat('$$p(c^{*}) = ', num2str(pMGC),'$$');
a=text(x1,y1,txt1,'VerticalAlignment','bottom','HorizontalAlignment','left','Color',glob,'Interpreter','latex');
% b=text(x2,y2,txt2,'VerticalAlignment','bottom','HorizontalAlignment','left','Color',loca,'Interpreter','latex');
c=text(x2,y2,txt3,'VerticalAlignment','bottom','HorizontalAlignment','left','Color',mgc,'Interpreter','latex');
ylim([0 y1+25]);
% <<<<<<< HEAD
set(a,'FontSize',fs);
% set(b,'FontSize',fs);
set(c,'FontSize',fs);
xlim([minp-0.04,maxp+0.1]);
xlabel('Test Statistic','FontSize',fs,...
    'Units', 'normalized','Position', [-0.008, -0.01], 'HorizontalAlignment', 'left')
ylabel('Density','FontSize',fs, ...
    'Units', 'normalized', 'Position', [-0.02 0], 'HorizontalAlignment', 'left')
% =======
% set(a,'FontSize',fontSize);
% set(b,'FontSize',fontSize);
% set(c,'FontSize',fontSize);
% xlim([minp,maxp+0.1]);
% xlabel('Test Statistic','FontSize',fontSize-5,'HorizontalAlignment','right');
% ylabel('Density','FontSize',fontSize-5, ...
% >>>>>>> c55135b820b0d669c0dcdac7dc915b0200706c61
%     'Units', 'normalized', 'Position', [-0.02 0], 'HorizontalAlignment', 'left')
set(gca,'YTick',[],'FontSize',fs-1)
title([{'5. Null Distribution'}],'FontSize',fs, ...
    'Units', 'normalized', 'Position', [0 1.0], 'HorizontalAlignment', 'left')
% pos2 = get(ax,'position');
% pos2(3:4) = [pos(3:4)];
% set(ax,'position',pos2);
% axis('square')
hold off
% axis([0, y2, 0, y2])
% 1-pAll(end)
% 1-pAll(k,l)
% power1(end)
% power1(k,l)


%
% ax=subplot('Position',[left(1), bottom(1), width, height]);
%
% ntab=5;
% t = uitable(fig,'Data',round([x(1:5),y(1:5)]*10)/10,...
%     'ColumnWidth',{60},...
%     'ColumnName',{'x','y'},...
%     'ColumnFormat',{'bank','bank'},...
%     'FontSize',18);
% t.Position(3) = t.Extent(3);
% t.Position(4) = t.Extent(4);
% set(gca,'visible','off')
% set(gca, 'visible', 'off')
% set(gca,'FontSize',fontSize)
% set(findall(gca, 'type', 'text'), 'visible', 'on')
% set(gca,'XTick',[],'YTick',[]); % Remove y axis ticks

%
pre2=strcat(rootDir,'Figures/');% The folder to save figures
donzo=1;
if donzo==1
    F.fname=strcat(pre2, 'FigB');
else
    F.fname=strcat(pre2, 'Auxiliary/A2_type', num2str(type),'_n', num2str(n), '_noise', num2str(round(noise*10)));
end
F.wh=[4 2.5]*2;
F.PaperPositionMode='auto';

print_fig(gcf,F)
