function xyz_inflated = ieeg_snap2inflated(loc_info,gR,gL,gR_infl,gL_infl)
%
%
% Function snaps electrode positions to closest pial surface within <=5 mm
% and returns corresponding inflated coordinates.
%
% Usage: xyz_inflated = ieeg_snap2inflated(loc_info,gR,gL,gR_infl,gL_infl)
%
% Inputs:
% loc_info needs, x, y, z and hemisphere
% gR gifti of the pial surface of the right hemisphere
% gL gifti of the pial surface of the left hemisphere
% gR_infl gifti of the inflated surface of the right hemisphere
% gL_infl gifti of the inflated surface of the left hemisphere
%
% Outputs:
% xyz_inflated xyz coordinates on the inflated brain
%
% This function is WIP, probably needs some more testing
%
% DH, 2021


elecmatrix = [loc_info.x loc_info.y loc_info.z];

%% %%%% snap gray matter electrodes to surface, get index on surface, and get point on inflated brain
xyz_surf = NaN(size(elecmatrix));
xyz_inflated = NaN(size(elecmatrix));
surfIndex = NaN(size(elecmatrix,1),1);

for kk = 1:height(loc_info)
    % check for left or right
    if strcmp(loc_info.hemisphere{kk},'R')
        % any matter label, non right thalamic 
        if ~isnan(isnan(loc_info.Destrieux_label(kk))) && ...
             loc_info.Destrieux_label(kk)~=49    % non right thalamic
            % get coordinates
            xyz = [loc_info.x(kk) loc_info.y(kk) loc_info.z(kk)];

            % find closest point on gray surface
            dist_xyz2Surf = sqrt(sum((gR.vertices-xyz).^2,2));
            [minDist,ind_minDist] = min(dist_xyz2Surf);
            if minDist < 6 % only find points less than 6 mm away
                xyz_surf(kk,:) = gR.vertices(ind_minDist,:);
                surfIndex(kk) = ind_minDist;
                xyz_inflated(kk,:) = gR_infl.vertices(ind_minDist,:);
            end
            
        end
    elseif strcmp(loc_info.hemisphere{kk},'L')
        % any matter label, non left thalamic 
        if ~isnan(isnan(loc_info.Destrieux_label(kk))) && ...
                loc_info.Destrieux_label(kk)~=10    % non left thalamic
            % get coordinates
            xyz = [loc_info.x(kk) loc_info.y(kk) loc_info.z(kk)];

            % find closest point on gray surface
            dist_xyz2Surf = sqrt(sum((gL.vertices-xyz).^2,2));
            [minDist,ind_minDist] = min(dist_xyz2Surf);
            if minDist < 6 % only find points less than 6 mm away
                xyz_surf(kk,:) = gL.vertices(ind_minDist,:);
                surfIndex(kk) = ind_minDist;
                xyz_inflated(kk,:) = gL_infl.vertices(ind_minDist,:);
            end
        end
    end
end
clear minDist ind_minDist dist_xyz2Surf xyz