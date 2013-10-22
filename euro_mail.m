function [ route, solution ] = euro_mail( cities , popSize, nGens)
%   Detailed explanation goes here

[N,dims] = size(cities);

% pre-calculate fuel usage going between cities
fuelMat = zeros(N);
for origin = 1:N
    for dest = 1:N
        xdist = cities(origin,1) - cities(dest,1);
        ydist = cities(origin,2) - cities(dest,2);
        fuelMat(origin,dest) = sqrt(xdist.^2+ydist.^2); % assume xy cartesian coordinates for now
        %if (cities(origin,4)==0) && (cities(dest,4)==0) 
        %    fuelMat(origin,dest) = inf; % can't travel from none-ez to none-ez
        %end
    end
end

% initialise populations and arrays for ga solver
pop = zeros(popSize,N-1);


% initial population
for organism = 1:popSize
    pop(organism,:) = randperm(N-1) + 1; % first city is our origin and dest    
end

best = 1;

% begin generation loop here
for gen = 1:nGens
    
    % calculate fitness of population
    fitness = zeros(popSize,2);
    % stores fitness and index of pop

    for organism = 1:popSize
        position = 1; % start london
        fitness(organism,2) = organism;
        for step = 1:N-1
            next = pop(organism,step);
            fitness(organism,1) = fitness(organism,1)+fuelMat(position,next);
            position = next;
        end
        fitness(organism,1) = fitness(organism,1)+fuelMat(position,1); % return to london
    end

    % pick best 
    fitness = sortrows(fitness); % low fitness is good
    
    disp(fitness(1,:));
    best = fitness(1,2);
    
    if gen < nGens        
        % pick indexes to use as parents for new generation
        % could be more intelligent here and use something other than a uniform dist (poisson?) 
        newPop = zeros(popSize,N-1);
        nParents = floor(popSize/3); % number of organisms that survive to reproduce
        parents = randi(nParents,1,popSize); % rand int (1 to nParents) in a 1 by popSize array

        % put best solution in new generation so we never get worse results
        newPop(1,:) =  pop(fitness(1,2),:);
        
        % create rest of new population
        for organism = 2:popSize
            % copy parent
            parent_idx = fitness(parents(organism),2);
            newPop(organism,:) = pop(parent_idx,:);
            
            % mutate
            r = sort(ceil((N-1)*rand(1,2)));
            a = r(1);
            b = r(2);
            mut = randi(3);
            if mut==1 % swap
                newPop(organism,[a b]) = newPop(organism,[b a]);
            end
            if mut==2% invert
                newPop(organism,a:b) = newPop(organism,b:-1:a);
            end
            if mut==3% insertion
                newPop(organism,a:b) = newPop(organism,[a+1:b a]);
            end
        end
        pop = newPop;
    end
end
% end generation loop here

% basic solution
solution = [1 pop(best,:) 1];

%actual route
route = zeros(N+1,dims);
route(1,:) = cities(1,:);
for stop = 1:N-1
    route(stop+1,:) =  cities(pop(best,stop),:);
end
route(N+1,:) = cities(1,:);

end