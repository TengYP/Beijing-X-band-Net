clc
clear all
close all

folder_name{1}='I:\2018\BJX_03h\DX';

folder_name{2}='I:\2018\BJX_03h\CP';
folder_name{3}='I:\2018\BJX_03h\FS';
folder_name{4}='I:\2018\BJX_03h\MY';
folder_name{5}='I:\2018\BJX_03h\SY';
folder_name{6}='I:\2018\BJX_03h\TZ';
DirFile{1}=dir(fullfile(folder_name{1},'*.bin'));
for i=2:6
    DirFile{i}=dir(fullfile(folder_name{i},'*.AR2'));
end
NetX=zeros(5,801,801);NetY=zeros(5,801,801);
for i=1:5
    switch i
        case 1
            N=41+04/60+15.55/60/60;S=39+16/60+11.56/60/60;W=115+10/60+21.16/60/60;E=117+31/60+13.19/60/60;
        case 2
            N=40+35/60+25.59/60/60;S=38+47/60+20.33/60/60;W=115+01/60+28.56/60/60;E=117+21/60+22.98/60/60;
        case 3
            N=41+15/60+24.26/60/60;S=39+27/60+19.74/60/60;W=115+37/60+01.58/60/60;E=117+58/60+16.82/60/60;
        case 4
            N=41+01/60+37.99/60/60;S=39+13/60+33.76/60/60;W=115+26/60+29.83/60/60;E=117+47/60+16.86/60/60;
        case 5
            N=40+45/60+14.78/60/60;S=38+57/60+10.05/60/60;W=115+35/60+01.05/60/60;E=117+55/60+14.35/60/60;
    end
    [NetX(i,1:801,1:801),NetY(i,1:801,1:801)]=meshgrid(W:((E-W)/800):E,N:((S-N)/800):S);
end
for mm=6:9%3:9
    for dd=1:31%1:31
        if (mm==4||mm==6||mm==9)&&dd==31
            continue
        end
        for hh=12:12%0:3:21
            str=['2018',num2str(mm,'%02d'),num2str(dd,'%02d'),'.',num2str(hh,'%02d'),'000'];
            CAPPI_DBZ=NaN.*ones(5,801,801);
            CAPPI_CC=NaN.*ones(5,801,801);
            CAPPI_ZDR=NaN.*ones(5,801,801);
            Data_DBZ=NaN.*ones(2001,2001);
            Data_CC=NaN.*ones(2001,2001);
            Data_ZDR=NaN.*ones(2001,2001);
            Data_DBZ_tmp=NaN.*ones(5,2001,2001);
            Data_CC_tmp=NaN.*ones(5,2001,2001);
            Data_ZDR_tmp=NaN.*ones(5,2001,2001);
            row=zeros(5,1);radarLon=zeros(5,1);radarLat=zeros(5,1);
            for i=2:4:6
                DBZ=NaN.*ones(9,801,801);
                CC=NaN.*ones(9,801,801);
                ZDR=NaN.*ones(9,801,801);
                for f=1:length(DirFile{i})
                    if ~isempty(strfind(DirFile{i}(f).name,str))
                        row(i-1)=f;
                        FileName=fullfile(folder_name{i},DirFile{i}(f).name);
                        fid=fopen(FileName,'rb');
                        CommonBlock=Read_CommonBlock(fid);
                        RadialBlock=Read_RadialBlock(fid);
                        fclose(fid);
                        radarLon(i-1)=CommonBlock.SiteConfiguration.Longitude;
                        radarLat(i-1)=CommonBlock.SiteConfiguration.Latitude;
                        b=1;
                        for a=1:size(RadialBlock.Data,2)
                            if ~isempty(RadialBlock.Data(a).ZDR)
                                DBZ(b,1:801,1:801)=getCartInfo(RadialBlock.Data(a).dBZ)';%250m*250m
                                ZDR(b,1:801,1:801)=getCartInfo(RadialBlock.Data(a).ZDR)';%250m*250m
                                CC(b,1:801,1:801)=getCartInfo(RadialBlock.Data(a).CC)';%250m*250m
                                b=b+1;
                            end
                        end
                        CAPPI_DBZ((i-1),801:-1:1,1:801)=nanmax(DBZ,[],1);
                        CAPPI_CC((i-1),801:-1:1,1:801)=nanmax(CC,[],1);%250m*250m
                        CAPPI_ZDR((i-1),801:-1:1,1:801)=nanmax(ZDR,[],1);
                        Zin_DBZ=reshape(CAPPI_DBZ((i-1),:,:),1,size(CAPPI_DBZ,2)*size(CAPPI_DBZ,3));
                        Zin_CC=reshape(CAPPI_CC((i-1),:,:),1,size(CAPPI_CC,2)*size(CAPPI_CC,3));
                        Zin_ZDR=reshape(CAPPI_ZDR((i-1),:,:),1,size(CAPPI_ZDR,2)*size(CAPPI_ZDR,3));
                        Xin=reshape(NetX((i-1),:,:),1,size(NetX,2)*size(NetX,3));
                        Yin=reshape(NetY((i-1),:,:),1,size(NetY,2)*size(NetY,3));
                        X_Net_DBZ=scatteredInterpolant(Xin(~isnan(Zin_DBZ))',Yin(~isnan(Zin_DBZ))',Zin_DBZ(~isnan(Zin_DBZ))','natural','none');
                        X_Net_CC=scatteredInterpolant(Xin(~isnan(Zin_CC))',Yin(~isnan(Zin_CC))',Zin_CC(~isnan(Zin_CC))','natural','none');
                        X_Net_ZDR=scatteredInterpolant(Xin(~isnan(Zin_ZDR))',Yin(~isnan(Zin_ZDR))',Zin_ZDR(~isnan(Zin_ZDR))','natural','none');
                        [X,Y]=meshgrid(115.5:2/2000:117.5,41:-1.5/2000:39.5);
                        Data_DBZ_tmp((i-1),1:2001,1:2001)=X_Net_DBZ(X,Y);
                        Data_CC_tmp((i-1),1:2001,1:2001)=X_Net_CC(X,Y);
                        Data_ZDR_tmp((i-1),1:2001,1:2001)=X_Net_ZDR(X,Y);
                        break
                    end
                end  
            end
            Data_DBZ(1:2001,1:2001)=(nanmax(Data_DBZ_tmp,[],1));
            Data_CC(1:2001,1:2001)=(nanmax(Data_CC_tmp,[],1));
            Data_ZDR(1:2001,1:2001)=(nanmax(Data_ZDR_tmp,[],1));
            figure('visible','off')
            subplot(1,3,1)
            surf(Data_DBZ,'edgecolor','none'),colorbar('SouthOutside'),view(2),axis([1 2001 1 2001]),set(gca, 'CLim', [-20 40])
            subplot(1,3,2)
            surf(Data_CC,'edgecolor','none'),colorbar('SouthOutside'),view(2),axis([1 2001 1 2001]),set(gca, 'CLim', [.5 1])
            subplot(1,3,3)
            surf(Data_ZDR,'edgecolor','none'),colorbar('SouthOutside'),view(2),axis([1 2001 1 2001]),set(gca, 'CLim', [-5 5])
            set(gcf,'outerposition',[1 1 1920 720])
            saveas(gcf,['I:\2018\BJX_03h\Z_jpg_20\',str,'0.jpg'])
            close(gcf)
        end
    end
end




