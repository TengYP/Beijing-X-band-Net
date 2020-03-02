function RadialBlock=Read_RadialBlock(fid)
while(fid)
%%
%RADIAL HEADER
    RadialBlock.RadialHeader.RadialState=fread(fid,1,'int32');
    RadialBlock.RadialHeader.SpotBlank=fread(fid,1,'int32');
    RadialBlock.RadialHeader.SequenceNumber=fread(fid,1,'int32');
    RadialBlock.RadialHeader.RadialNumber=fread(fid,1,'int32');
    RadialBlock.RadialHeader.ElevationNumber=fread(fid,1,'int32');
    RadialBlock.RadialHeader.Azimuth=fread(fid,1,'float32');
    RadialBlock.RadialHeader.Elevation=fread(fid,1,'float32');
    RadialBlock.RadialHeader.Seconds=fread(fid,1,'int32');
    RadialBlock.RadialHeader.Microseconds=fread(fid,1,'int32');
    RadialBlock.RadialHeader.LengthOfData=fread(fid,1,'int32');
    RadialBlock.RadialHeader.MomentNumber=fread(fid,1,'int32');
    RadialBlock.RadialHeader.Reserved=fread(fid,20,'char');
    for Num=1:RadialBlock.RadialHeader.MomentNumber
    %%
    %MOMENT HEADER
        RadialBlock.MomentHeader.DataType=fread(fid,1,'int32');
        RadialBlock.MomentHeader.Scale=fread(fid,1,'int32');
        RadialBlock.MomentHeader.Offset=fread(fid,1,'int32');
        RadialBlock.MomentHeader.BinLength=fread(fid,1,'int16');
        RadialBlock.MomentHeader.Flags=fread(fid,1,'int16');
        RadialBlock.MomentHeader.Length=fread(fid,1,'int32');
        RadialBlock.MomentHeader.Reserved=fread(fid,12,'char');
    %%
    %MOMENT DATA
        RadialBlock.MomentData=NaN.*ones(1,RadialBlock.MomentHeader.Length/RadialBlock.MomentHeader.BinLength);
        switch (RadialBlock.MomentHeader.BinLength)
            case 1
                RadialBlock.MomentData(1:RadialBlock.MomentHeader.Length/RadialBlock.MomentHeader.BinLength)=fread(fid,RadialBlock.MomentHeader.Length/RadialBlock.MomentHeader.BinLength,'uint8');
            case 2
                RadialBlock.MomentData(1:RadialBlock.MomentHeader.Length/RadialBlock.MomentHeader.BinLength)=fread(fid,RadialBlock.MomentHeader.Length/RadialBlock.MomentHeader.BinLength,'uint16');
        end
        switch (RadialBlock.MomentHeader.DataType)
            case 1%每个位置的扫描角记着.dBT.data/.dBT.Azimuth/.dBT.Elevation
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).dBT.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).dBT.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).dBT.Elevation=RadialBlock.RadialHeader.Elevation;
            case 2
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).dBZ.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).dBZ.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).dBZ.Elevation=RadialBlock.RadialHeader.Elevation;
            case 3
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).V.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).V.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).V.Elevation=RadialBlock.RadialHeader.Elevation;
            case 4
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).W.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).W.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).W.Elevation=RadialBlock.RadialHeader.Elevation;
            case 5
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).SQI.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).SQI.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).SQI.Elevation=RadialBlock.RadialHeader.Elevation;
            case 6
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CPA.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CPA.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CPA.Elevation=RadialBlock.RadialHeader.Elevation;
            case 7
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).ZDR.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).ZDR.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).ZDR.Elevation=RadialBlock.RadialHeader.Elevation;
            case 8
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).LDR.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).LDR.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).LDR.Elevation=RadialBlock.RadialHeader.Elevation;
            case 9
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CC.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CC.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CC.Elevation=RadialBlock.RadialHeader.Elevation;
            case 10
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).DP.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).DP.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).DP.Elevation=RadialBlock.RadialHeader.Elevation;
            case 11
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).KDP.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).KDP.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).KDP.Elevation=RadialBlock.RadialHeader.Elevation;
            case 12
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CP.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CP.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CP.Elevation=RadialBlock.RadialHeader.Elevation;
            case 14
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).HCL.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).HCL.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).HCL.Elevation=RadialBlock.RadialHeader.Elevation;
            case 15
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CF.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CF.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).CF.Elevation=RadialBlock.RadialHeader.Elevation;
            case 16
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).SNR.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).SNR.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).SNR.Elevation=RadialBlock.RadialHeader.Elevation;
            case 17
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).VSNR.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).VSNR.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).VSNR.Elevation=RadialBlock.RadialHeader.Elevation;
            case 32
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).Zc.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).Zc.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).Zc.Elevation=RadialBlock.RadialHeader.Elevation;
            case 33
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).Vc.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).Vc.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).Vc.Elevation=RadialBlock.RadialHeader.Elevation;
            case 34
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).Wc.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).Wc.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).Wc.Elevation=RadialBlock.RadialHeader.Elevation;
            case 35
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).ZDRc.Data(RadialBlock.RadialHeader.RadialNumber,:)=(RadialBlock.MomentData-RadialBlock.MomentHeader.Offset)./RadialBlock.MomentHeader.Scale;
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).ZDRc.Azimuth(RadialBlock.RadialHeader.RadialNumber)=RadialBlock.RadialHeader.Azimuth';
                RadialBlock.Data(RadialBlock.RadialHeader.ElevationNumber).ZDRc.Elevation=RadialBlock.RadialHeader.Elevation;
        end
    end
	if RadialBlock.RadialHeader.RadialState==4
        break
    end
end