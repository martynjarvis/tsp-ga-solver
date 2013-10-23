% read and format data
fileID = fopen('capitals.csv');

% United Kingdom,London,51,30,-0,-7,0
C = textscan(fileID,'%q %q %f %f %f %f %f','Delimiter',',');
fclose(fileID);

% convert to matrix (latDeg latSec lonDeg lonSec Eurozone)
M = cell2mat([C(:,3) C(:,4) C(:,5) C(:,6) C(:,7)]);
[N,dims] = size(M);

% convert degree/seconds to decimal degrees
cities = [(M(:,1)+M(:,2)./60) (M(:,3)+M(:,4)./60) M(:,5)];
 
% find optimal route
[cities,route] = euro_mail(cities,50,2000);
 
% plot route
plot(cities(:,2),cities(:,1),'b--o');

% output solution
names = C{2};
fileID = fopen('output.csv','w');

% I didn't save the running fuel and dist so I'll calculate them again
dist = 0.0;
fuel = 0.0;
position = 1;
for step = 1:N
    %London,Paris,Full,120,481
    next = route(step+1);
    stepDist = Dist( cities(step,:) , cities(step+1,:) );
    stepFuel = stepDist*0.04;
    cargo = 'EMPTY';
    if (cities(step,3)==0) && (cities(step+1,3)==1) 
    	stepFuel = stepFuel*1.20; % carry cargo
        cargo = 'FULL';
    end
    dist = dist+stepDist;
    fuel = fuel+stepFuel;
    fprintf(fileID,'%s, %s, %s, %.0f, %.0f\n',char(names(position)),char(names(next)),cargo,round(dist),round(fuel));
    position = next;
end

fclose(fileID);


