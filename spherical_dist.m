function [ dist ] = spherical_dist( origin , dest )
%Dist Calculates the distance between two points given by origin(lat,long)
%and dest (lat,long)

lat1 = pi*origin(1)/180;
lat2 = pi*dest(1)/180;
lon1 = pi*origin(2)/180;
lon2 = pi*dest(2)/180;

% http://mathworld.wolfram.com/SphericalTrigonometry.html
dist = acos(sin(lat1)*sin(lat2) + cos(lat1)*cos(lat2) * cos(lon2-lon1)) * 6371; % earth radius in km

end

