function [ cities, solution ] = tsp_ga( cities , pop_size, n_generations)
% TSP solver. Assume cities(1,:) is our origin and final destination

[N,dims] = size(cities);

% pre-calculate fuel usage going between cities, and store in matrix
fuel_matrix = zeros(N);
for origin = 1:N
    for dest = 1:N
        dist = spherical_dist( cities(origin,:) , cities(dest,:) );
        fuel_matrix(origin,dest) = dist*0.04; % 4lt/km

        if (cities(origin,3)==0) && (cities(dest,3)==0)
            fuel_matrix(origin,dest) = inf; % can't travel from none-ez to none-ez
        end
        if (cities(origin,3)==0) && (cities(dest,3)==1)
            fuel_matrix(origin,dest) = fuel_matrix(origin,dest)*1.20; % carry cargo
        end
    end
end

% initialise population array for ga solver
pop = zeros(pop_size,N-1);

% initial population (random permutations)
for organism = 1:pop_size
    pop(organism,:) = randperm(N-1) + 1; % first city is our origin and dest
end

% holds the index of the best organism from each population
best = 1;

% begin generation loop here
for gen = 1:n_generations
    % calculate fitness of population
    fitness = zeros(pop_size,2); % stores fitness and index of pop
    for organism = 1:pop_size
        fitness(organism,2) = organism;
        position = 1; % start in london
        for step = 1:N-1 % step through solution
            next = pop(organism,step);
            fitness(organism,1) = fitness(organism,1)+fuel_matrix(position,next);
            position = next;
        end
        fitness(organism,1) = fitness(organism,1)+fuel_matrix(position,1);  % return to london
    end

    % sort by fitness, low fitness is good
    fitness = sortrows(fitness);
    best = fitness(1,2);

    format_spec = 'Generation %.0f, best solution %.1f lt \n';
    fprintf(format_spec, gen, fitness(1,1));

    if gen < n_generations
        new_pop = zeros(pop_size,N-1); % next generation

        % pick indexes to use as parents for new generation
        % could be more intelligent here and use something other than a uniform dist (poisson?)
        n_parents = floor(pop_size/3); % number of organisms that survive to reproduce (a third?)
        parents = randi(n_parents,1,pop_size); % pick a random parent for each of the new generation

        % put best solution in new generation so results never worsen
        new_pop(1,:) =  pop(fitness(1,2),:);

        % create rest of new population
        for organism = 2:pop_size
            % copy parent
            parent_idx = fitness(parents(organism),2);
            new_pop(organism,:) = pop(parent_idx,:);

            % mutate
            r = sort(ceil((N-1)*rand(1,2)));
            a = r(1);
            b = r(2);
            mut = randi(3);
            if mut==1 % swap
                new_pop(organism,[a b]) = new_pop(organism,[b a]);
            end
            if mut==2 % invert
                new_pop(organism,a:b) = new_pop(organism,b:-1:a);
            end
            if mut==3 % insertion
                new_pop(organism,a:b) = new_pop(organism,[a+1:b a]);
            end
        end
        pop = new_pop;
    end
end
% end generation loop here


% solution indexes
solution = [1 pop(best,:) 1];

% actual route
cities = cities(solution,:);

end
