clear all; close all; clc

% Planet paramters 
mu = 398600.4;           % Standar gravitational parameter (km^3/s^2)             
we = 7.29e-5;            % Earth's rotation speed [rad/s]

% Initial orbit ephemerids, ISS
% (https://spaceflight.nasa.gov/realdata/sightings/SSapplications/Post/JavaSSOP/orbit/ISS/SVPOST.html)
a1  = 480+6370;  e1 = 0.0004; 
OM1 = 114.03;   om1 = 311.5;     i1 = 51.64;

% Final orbit ephemerids, Iridium 154
% (https://www.n2yo.com/satellite/?s=43574)

a2  = 785+6370;  e2 = 0.008; th2 = 250*pi/180;
OM2 = 119.4;     om2 = 336; i2 = 86.04;


Vc1 = sqrt(mu/(a1)); % Circular velocity of orbit 1 [Km/s]
Vc2 = sqrt(mu/(a2)); % Circular velocity of orbit 2 [Km/s]
DV1 = Vc1-Vc2;       % Velocity cost to go from orbit 1 to orbit 2 [Km/s]

% Plane change cost
phi = acos(cos(i1)*cos(i2)+sin(i1)*sin(i2)*cos(OM2-OM1));
DV2 = 2*Vc2*sin(phi/2); % Velocity cost in plane change [Km/s]

DVt = DV1 + DV2 % Total velocity cost


DV2v = [];
for DOM=0:0.05:2*pi
    phi = acos(cos(i1)*cos(i2)+sin(i1)*sin(i2)*cos(DOM));;
    DV2 = 2*Vc2*sin(phi/2);
    DV2v = [DV2v DV2];
end

figure
plot((0:0.05:2*pi)*180/pi,DV2v+DV1); xlabel('OM difference [º]'); ylabel('Mision cost [km/s]');grid

% Phase change (from satellite of Iridium orbit to the closest satellite
% inside the same orbit)

E   = 360/11*pi/180;
T2  = 2*pi*sqrt(a2^3/mu); 
t   = T2/(2*pi)*E;
T3  = T2-t;
a3  = (T3/(2*pi))^(2/3)*mu^(1/3);
rp3 = 2*a3-a2;
h3  = sqrt(mu*2)*sqrt(rp3*a2/(rp3+a2));
DVp = 2*norm(h3/a2-Vc2)                  % Total phase change cost [Km/s]
tp  = t/60                               % Time spent              [min]


