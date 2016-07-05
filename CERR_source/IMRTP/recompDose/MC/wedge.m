function [wedge_data wedge_density] = wedge();

% wedge coordinates
Y = [-7.0 -4.35    0  3.0  0 -4.35 -7.0 -7.0];
Z = [-5.8 -5.8  -2.46    0  0   0    0  -5.8];
figure; line(Y,Z, 'LineStyle', '-', 'Marker', 'o');
disp('This wedge can be modeled as a rectangle and a triangle, as shown below')
Y = [-7.0 -4.35   -4.35 -7.0 -7.0];
Z = [-5.8 -5.8  0    0  -5.8];
figure; line(Y,Z, 'Color', 'b', 'LineStyle', '-', 'Marker', 'o');
Y = [-4.35  3.0  -4.35 -4.35];
Z = [-5.8    0     0   -5.8];
hold on; line(Y,Z, 'Color', 'r', 'LineStyle', '-', 'Marker', 'o'); axis equal;
xlabel('Y/cm'); ylabel('Z/cm'); title('Elekta Universal Wedge');

% From the NIST website, get the attenuation coefficients.
% Components of the wedge:
Pb = 0.96     %Fraction by weigth for Lead
Sb = 0.04     %Fraction by weight for Antimony

% Ref:
%http://physics.nist.gov/PhysRefData/XrayMassCoef/ElemTab/z82.html
%Energy       mu over rho        mu e n over rho 
%      (MeV)      (cm2/g)     (cm2/g)
%____________________________________
%
Pb_data =   [1.00000E-03  5.210E+03  5.197E+03 
   1.50000E-03  2.356E+03  2.344E+03 
   2.00000E-03  1.285E+03  1.274E+03 
   2.48400E-03  8.006E+02  7.895E+02 
   2.48400E-03  1.397E+03  1.366E+03 
   2.53429E-03  1.726E+03  1.682E+03 
   2.58560E-03  1.944E+03  1.895E+03 
   2.58560E-03  2.458E+03  2.390E+03 
   3.00000E-03  1.965E+03  1.913E+03 
   3.06640E-03  1.857E+03  1.808E+03 
   3.06640E-03  2.146E+03  2.090E+03 
   3.30130E-03  1.796E+03  1.748E+03 
   3.55420E-03  1.496E+03  1.459E+03 
   3.55420E-03  1.585E+03  1.546E+03 
   3.69948E-03  1.442E+03  1.405E+03 
   3.85070E-03  1.311E+03  1.279E+03 
   3.85070E-03  1.368E+03  1.335E+03 
   4.00000E-03  1.251E+03  1.221E+03 
   5.00000E-03  7.304E+02  7.124E+02 
   6.00000E-03  4.672E+02  4.546E+02 
   8.00000E-03  2.287E+02  2.207E+02 
   1.00000E-02  1.306E+02  1.247E+02 
   1.30352E-02  6.701E+01  6.270E+01 
   1.30352E-02  1.621E+02  1.291E+02 
   1.50000E-02  1.116E+02  9.100E+01 
   1.52000E-02  1.078E+02  8.807E+01 
   1.52000E-02  1.485E+02  1.131E+02 
   1.55269E-02  1.416E+02  1.083E+02 
   1.58608E-02  1.344E+02  1.032E+02 
   1.58608E-02  1.548E+02  1.180E+02 
   2.00000E-02  8.636E+01  6.899E+01 
   3.00000E-02  3.032E+01  2.536E+01 
   4.00000E-02  1.436E+01  1.211E+01 
   5.00000E-02  8.041E+00  6.740E+00 
   6.00000E-02  5.021E+00  4.149E+00 
   8.00000E-02  2.419E+00  1.916E+00 
   8.80045E-02  1.910E+00  1.482E+00 
   8.80045E-02  7.683E+00  2.160E+00 
   1.00000E-01  5.549E+00  1.976E+00 
   1.50000E-01  2.014E+00  1.056E+00 
   2.00000E-01  9.985E-01  5.870E-01 
   3.00000E-01  4.031E-01  2.455E-01 
   4.00000E-01  2.323E-01  1.370E-01 
   5.00000E-01  1.614E-01  9.128E-02 
   6.00000E-01  1.248E-01  6.819E-02 
   8.00000E-01  8.870E-02  4.644E-02 
   1.00000E+00  7.102E-02  3.654E-02 
   1.25000E+00  5.876E-02  2.988E-02 
   1.50000E+00  5.222E-02  2.640E-02 
   2.00000E+00  4.606E-02  2.360E-02 
   3.00000E+00  4.234E-02  2.322E-02 
   4.00000E+00  4.197E-02  2.449E-02 
   5.00000E+00  4.272E-02  2.600E-02 
   6.00000E+00  4.391E-02  2.744E-02 
   8.00000E+00  4.675E-02  2.989E-02 
   1.00000E+01  4.972E-02  3.181E-02 
   1.50000E+01  5.658E-02  3.478E-02 
   2.00000E+01  6.206E-02  3.595E-02];


%Antimony
%Z = 51
%
%ASCII format
%
%____________________________________
%
%     Energy       mu over rho        mu e n over rho 
%      (MeV)      (cm2/g)     (cm2/g)
%____________________________________

Sb_data = [1.00000E-03  8.582E+03  8.568E+03 
   1.50000E-03  3.491E+03  3.481E+03 
   2.00000E-03  1.767E+03  1.759E+03 
   3.00000E-03  6.536E+02  6.469E+02 
   4.00000E-03  3.169E+02  3.113E+02 
   4.13220E-03  2.918E+02  2.863E+02 
   4.13220E-03  8.691E+02  8.252E+02 
   4.25449E-03  8.308E+02  7.865E+02 
   4.38040E-03  7.776E+02  7.392E+02 
   4.38040E-03  1.050E+03  9.906E+02 
   4.53657E-03  9.743E+02  9.178E+02 
   4.69830E-03  8.939E+02  8.457E+02 
   4.69830E-03  1.029E+03  9.725E+02 
   5.00000E-03  8.846E+02  8.377E+02 
   6.00000E-03  5.569E+02  5.305E+02 
   8.00000E-03  2.631E+02  2.518E+02 
   1.00000E-02  1.459E+02  1.396E+02 
   1.50000E-02  4.923E+01  4.657E+01 
   2.00000E-02  2.268E+01  2.105E+01 
   3.00000E-02  7.631E+00  6.755E+00 
   3.04912E-02  7.307E+00  6.452E+00 
   3.04912E-02  4.073E+01  1.391E+01 
   4.00000E-02  2.027E+01  9.789E+00 
   5.00000E-02  1.120E+01  6.400E+00 
   6.00000E-02  6.879E+00  4.311E+00 
   8.00000E-02  3.176E+00  2.173E+00 
   1.00000E-01  1.758E+00  1.237E+00 
   1.50000E-01  6.361E-01  4.312E-01 
   2.00000E-01  3.381E-01  2.084E-01 
   3.00000E-01  1.677E-01  8.504E-02 
   4.00000E-01  1.172E-01  5.288E-02 
   5.00000E-01  9.453E-02  4.061E-02 
   6.00000E-01  8.153E-02  3.465E-02 
   8.00000E-01  6.670E-02  2.896E-02 
   1.00000E+00  5.797E-02  2.608E-02 
   1.25000E+00  5.086E-02  2.378E-02 
   1.50000E+00  4.628E-02  2.230E-02 
   2.00000E+00  4.105E-02  2.081E-02 
   3.00000E+00  3.686E-02  2.043E-02 
   4.00000E+00  3.567E-02  2.118E-02 
   5.00000E+00  3.559E-02  2.219E-02 
   6.00000E+00  3.598E-02  2.321E-02 
   8.00000E+00  3.745E-02  2.509E-02 
   1.00000E+01  3.921E-02  2.664E-02 
   1.50000E+01  4.351E-02  2.920E-02 
   2.00000E+01  4.704E-02  3.038E-02]; 

% put data on the same, unique intervals.
[A, s] = unique(Pb_data(:,1));
[B,I] = unique(Sb_data(:,1));
Pb_data = [B interp1(Pb_data(s,1), Pb_data(s,2), B) interp1(Pb_data(s,1), Pb_data(s,3), B)];
Sb_data = [B interp1(Sb_data(I,1), Sb_data(I,2), B) interp1(Sb_data(I,1), Sb_data(I,3), B)];

wedge_data = Pb*Pb_data + Sb*Sb_data;
figure; loglog(Pb_data(:,1), Pb_data(:,2), Sb_data(:,1), Sb_data(:,2), wedge_data(:,1), wedge_data(:,2));
wedge_density = 11.16;