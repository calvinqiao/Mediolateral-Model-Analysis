
data = load3D_table('../../Data-0428/MLBAL02/Trial13.trc');
% l_psis = data.LASIS;


l_psisx = data.LPSIS;
l_psisz = data.VarName32;
l_psis = [l_psisx l_psisz];
r_psisx = data.RPSIS;
r_psisz = data.VarName35;
r_psis = [r_psisx r_psisz];
psis_vec1 = l_psis - r_psis;

p_ang1 = atand(psis_vec1(:,2)./psis_vec1(:,1));

% plot(p_ang1-mean(p_ang1)); hold on;
% 
% plot((l_psisx-mean(l_psisx))*0.1);

l_asisx = data.LASIS;
l_asisz = data.VarName44;
l_asis = [l_asisx l_asisz];
r_asisx = data.RASIS;
r_asisz = data.VarName38;
r_asis = [r_asisx r_asisz];
psis_vec2 = l_asis - r_asis;
p_ang2 = atand(psis_vec2(:,2)./psis_vec2(:,1));
figure;
plot(p_ang1-mean(p_ang1)); hold on;
plot(p_ang2-mean(p_ang2)); hold on;
figure;
plot(l_psisz-mean(l_psisz)); hold on;
plot(l_asisz-mean(l_asisz)); hold on;
plot(p_ang1-mean(p_ang1)); hold on;
plot((l_asisx-mean(l_asisx))*0.1);
legend('l psis Z', 'l asis Z', 'pelvis Ang', 'l asis X');

% 3-marker coordinate system, R matrix 3 by 3, and get the angle
% Ethics amendment
% Jesse meeting next week


