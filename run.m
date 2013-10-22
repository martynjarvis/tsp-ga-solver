M = csvread('capitals.csv',0,2);
cities = [(M(:,1)+M(:,2)./60) (M(:,3)+M(:,4)./60) M(:,5)];

[cities,route] = euro_mail(cities,50,10000);

plot(cities(:,2),cities(:,1),'b--o')