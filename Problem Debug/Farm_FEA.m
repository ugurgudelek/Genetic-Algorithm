function out = Farm_FEA(x1, x2, x3, x4, x5, showPlot)
%
% Farm_FEA.m
%
% Model exported on Apr 15 2017, 20:15 by COMSOL 5.2.1.262.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath(['C:\Users\Doga\Documents\Railgun\3. Analiz - Sim' native2unicode(hex2dec({'00' 'fc'}), 'unicode') 'lasyon\6. PPC']);

model.label('Freq.mph');

model.comments(['Untitled\n\n']);

model.param.set('rail_x', '20[mm]');
model.param.set('rail_y', 'arm_poz+50[mm]');
model.param.set('arm_poz', '100[mm]');
model.param.set('var1', x1);
model.param.set('var2', x2);
model.param.set('var3',x3);
model.param.set('var4', x4);
model.param.set('var5',x5);
model.param.set('height', '25[mm]');
model.param.set('air_r', '300[mm]');
model.param.set('air_h', 'rail_y+10[mm]');

model.modelNode.create('comp1');

model.geom.create('geom1', 3);

model.mesh.create('mesh1', 'geom1');

model.geom('geom1').lengthUnit('mm');
model.geom('geom1').create('wp1', 'WorkPlane');
model.geom('geom1').feature('wp1').label('Railgun');
model.geom('geom1').feature('wp1').set('unite', 'on');
model.geom('geom1').feature('wp1').geom.create('r1', 'Rectangle');
model.geom('geom1').feature('wp1').geom.feature('r1').label('left rail');
model.geom('geom1').feature('wp1').geom.feature('r1').set('size', {'rail_x' 'rail_y'});
model.geom('geom1').feature('wp1').geom.feature('r1').set('pos', {'-rail_x' '0'});
model.geom('geom1').feature('wp1').geom.create('r3', 'Rectangle');
model.geom('geom1').feature('wp1').geom.feature('r3').label('armature');
model.geom('geom1').feature('wp1').geom.feature('r3').set('size', {'2*(var1+var2+var3)' 'var4+var5+5[mm]'});
model.geom('geom1').feature('wp1').geom.feature('r3').set('pos', {'0' 'arm_poz'});
model.geom('geom1').feature('wp1').geom.create('pol1', 'Polygon');
model.geom('geom1').feature('wp1').geom.feature('pol1').set('source', 'table');
model.geom('geom1').feature('wp1').geom.feature('pol1').set('table', {'0' 'arm_poz';  ...
'var1' 'arm_poz';  ...
'var1+var2' 'arm_poz+var4';  ...
'var1+var2+var3+var3' 'arm_poz+var4';  ...
'var1+var2+var3+var2+var3' 'arm_poz';  ...
'var1+var2+var3+var2+var1' 'arm_poz+var5-var5'});
model.geom('geom1').feature('wp1').geom.create('e1', 'Ellipse');
model.geom('geom1').feature('wp1').geom.feature('e1').set('semiaxes', {'var3' 'var5'});
model.geom('geom1').feature('wp1').geom.feature('e1').set('pos', {'var1+var2+var3' 'arm_poz+var4'});
model.geom('geom1').feature('wp1').geom.create('dif1', 'Difference');
model.geom('geom1').feature('wp1').geom.feature('dif1').selection('input2').set({'e1' 'pol1'});
model.geom('geom1').feature('wp1').geom.feature('dif1').selection('input').set({'r3'});
model.geom('geom1').create('ext1', 'Extrude');
model.geom('geom1').feature('ext1').setIndex('distance', 'height', 0);
model.geom('geom1').feature('ext1').selection('input').set({'wp1'});
model.geom('geom1').create('cyl1', 'Cylinder');
model.geom('geom1').feature('cyl1').label('Air');
model.geom('geom1').feature('cyl1').set('axis', {'0' '1' '0'});
model.geom('geom1').feature('cyl1').set('r', 'air_r');
model.geom('geom1').feature('cyl1').set('pos', {'rail_x+var1+var2+var3' '0' 'height/2'});
model.geom('geom1').feature('cyl1').set('h', 'air_h');
model.geom('geom1').create('wp2', 'WorkPlane');
model.geom('geom1').feature('wp2').label('xy symmetry');
model.geom('geom1').feature('wp2').set('unite', 'on');
model.geom('geom1').feature('wp2').set('quickz', 'height/2');
model.geom('geom1').create('par1', 'Partition');
model.geom('geom1').feature('par1').set('partitionwith', 'workplane');
model.geom('geom1').feature('par1').selection('input').set({'cyl1' 'ext1'});
model.geom('geom1').create('del1', 'Delete');
model.geom('geom1').feature('del1').selection('input').init(3);
model.geom('geom1').feature('del1').selection('input').set('par1(2)', [2 4]);
model.geom('geom1').feature('del1').selection('input').set('par1(1)', [2]);
model.geom('geom1').create('wp3', 'WorkPlane');
model.geom('geom1').feature('wp3').label('yz symmetry');
model.geom('geom1').feature('wp3').set('quickplane', 'yz');
model.geom('geom1').feature('wp3').set('unite', 'on');
model.geom('geom1').feature('wp3').set('quickx', 'var1+var2+var3');
model.geom('geom1').create('par2', 'Partition');
model.geom('geom1').feature('par2').set('partitionwith', 'workplane');
model.geom('geom1').feature('par2').selection('input').set({'del1'});
model.geom('geom1').create('del2', 'Delete');
model.geom('geom1').feature('del2').selection('input').init(3);
model.geom('geom1').feature('del2').selection('input').set('par2(1)', [3]);
model.geom('geom1').feature('del2').selection('input').set('par2(2)', [2]);
model.geom('geom1').run;
model.geom('geom1').run('fin');

model.variable.create('var1');
model.variable('var1').model('comp1');
model.variable('var1').set('Fy', 'mef.Forcey_0*4');
model.variable('var1').set('Iarm', 'mef.I0_1*2');
model.variable('var1').set('volume', 'intop1(1)*4');
model.variable('var1').set('density', '2700[kg/m^3]');
model.variable('var1').set('mass', 'density*volume');
model.variable('var1').set('acc', 'Fy/mass');

model.view.create('view5', 2);

model.material.create('mat1', 'Common', 'comp1');
model.material.create('mat3', 'Common', 'comp1');
model.material.create('mat4', 'Common', 'comp1');
model.material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
model.material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
model.material('mat1').propertyGroup('def').func.create('rho', 'Analytic');
model.material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
model.material('mat1').propertyGroup('def').func.create('cs', 'Analytic');
model.material('mat1').propertyGroup.create('RefractiveIndex', 'Refractive index');
model.material('mat3').selection.set([3]);
model.material('mat3').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.material('mat3').propertyGroup.create('Murnaghan', 'Murnaghan');
model.material('mat3').propertyGroup.create('Lame', ['Lam' native2unicode(hex2dec({'00' 'e9'}), 'unicode') ' parameters']);
model.material('mat4').selection.set([2]);
model.material('mat4').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.material('mat4').propertyGroup.create('linzRes', 'Linearized resistivity');

model.cpl.create('intop1', 'Integration', 'geom1');
model.cpl('intop1').selection.set([3]);

model.physics.create('mef', 'ElectricInductionCurrents', 'geom1');
model.physics('mef').feature('mi1').create('term1', 'Terminal', 2);
model.physics('mef').feature('mi1').feature('term1').selection.set([6]);
model.physics('mef').feature('mi1').create('gnd1', 'Ground', 2);
model.physics('mef').feature('mi1').feature('gnd1').selection.set([21]);
model.physics('mef').create('fcal1', 'ForceCalculation', 3);
model.physics('mef').feature('fcal1').selection.set([3]);
model.physics('mef').create('pmc1', 'PerfectMagneticConductor', 2);
model.physics('mef').feature('pmc1').selection.set([1 8 11 15]);

model.mesh('mesh1').create('ftet1', 'FreeTet');
model.mesh('mesh1').feature('ftet1').selection.geom('geom1');
model.mesh('mesh1').feature('ftet1').create('size1', 'Size');
model.mesh('mesh1').feature('ftet1').create('size3', 'Size');
model.mesh('mesh1').feature('ftet1').create('size2', 'Size');
model.mesh('mesh1').feature('ftet1').create('size4', 'Size');
model.mesh('mesh1').feature('ftet1').create('size5', 'Size');
model.mesh('mesh1').feature('ftet1').create('size6', 'Size');
model.mesh('mesh1').feature('ftet1').feature('size1').selection.geom('geom1', 3);
model.mesh('mesh1').feature('ftet1').feature('size1').selection.set([2]);
model.mesh('mesh1').feature('ftet1').feature('size3').selection.geom('geom1', 3);
model.mesh('mesh1').feature('ftet1').feature('size3').selection.set([1]);
model.mesh('mesh1').feature('ftet1').feature('size2').selection.geom('geom1', 3);
model.mesh('mesh1').feature('ftet1').feature('size2').selection.set([3]);
model.mesh('mesh1').feature('ftet1').feature('size4').selection.geom('geom1', 2);
model.mesh('mesh1').feature('ftet1').feature('size4').selection.set([13 18]);
model.mesh('mesh1').feature('ftet1').feature('size5').selection.geom('geom1', 2);
model.mesh('mesh1').feature('ftet1').feature('size6').selection.geom('geom1', 2);
model.mesh('mesh1').feature('ftet1').feature('size6').selection.set([19]);

model.result.table.create('tbl2', 'Table');

model.view('view2').axis.set('abstractviewxscale', '0.10533283650875092');
model.view('view2').axis.set('abstractviewtratio', '7.824706844985485E-4');
model.view('view2').axis.set('abstractviewlratio', '-0.33300477266311646');
model.view('view2').axis.set('abstractviewyscale', '0.10533283650875092');
model.view('view2').axis.set('abstractviewrratio', '2.364177703857422');
model.view('view2').axis.set('abstractviewbratio', '0.6517797112464905');
model.view('view2').axis.set('ymax', '152.6116485595703');
model.view('view2').axis.set('xmax', '87.53294372558594');
model.view('view2').axis.set('ymin', '97.76696014404297');
model.view('view2').axis.set('xmin', '-28.66718292236328');
model.view('view4').axis.set('xmax', '2.1187121868133545');
model.view('view4').axis.set('xmin', '-2.1187121868133545');
model.view('view5').axis.set('abstractviewxscale', '0.38512033224105835');
model.view('view5').axis.set('abstractviewtratio', '0.05000000074505806');
model.view('view5').axis.set('abstractviewlratio', '-0.22659547626972198');
model.view('view5').axis.set('abstractviewyscale', '0.38512036204338074');
model.view('view5').axis.set('abstractviewrratio', '0.22659547626972198');
model.view('view5').axis.set('abstractviewbratio', '-0.05000000074505806');
model.view('view5').axis.set('ymax', '169.34791564941406');
model.view('view5').axis.set('xmax', '60.04693603515625');
model.view('view5').axis.set('ymin', '-9.347915649414062');
model.view('view5').axis.set('xmin', '-313.9049072265625');

model.material('mat1').label('Air');
model.material('mat1').set('family', 'air');
model.material('mat1').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.material('mat1').propertyGroup('def').func('eta').set('arg', 'T');
model.material('mat1').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.material('mat1').propertyGroup('def').func('Cp').set('arg', 'T');
model.material('mat1').propertyGroup('def').func('rho').set('dermethod', 'manual');
model.material('mat1').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/8.314/T');
model.material('mat1').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/8.314/T,pA)'; 'T' 'd(pA*0.02897/8.314/T,T)'});
model.material('mat1').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.material('mat1').propertyGroup('def').func('rho').set('plotargs', {'pA' '0' '1'; 'T' '0' '1'});
model.material('mat1').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.material('mat1').propertyGroup('def').func('k').set('arg', 'T');
model.material('mat1').propertyGroup('def').func('cs').set('dermethod', 'manual');
model.material('mat1').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*287*T)');
model.material('mat1').propertyGroup('def').func('cs').set('argders', {'T' 'd(sqrt(1.4*287*T),T)'});
model.material('mat1').propertyGroup('def').func('cs').set('args', {'T'});
model.material('mat1').propertyGroup('def').func('cs').set('plotargs', {'T' '0' '1'});
model.material('mat1').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat1').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat1').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.material('mat1').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.material('mat1').propertyGroup('def').set('electricconductivity', {'0.001[S/m]' '0' '0' '0' '0.001[S/m]' '0' '0' '0' '0.001[S/m]'});
model.material('mat1').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.material('mat1').propertyGroup('def').set('density', 'rho(pA[1/Pa],T[1/K])[kg/m^3]');
model.material('mat1').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
model.material('mat1').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.material('mat1').propertyGroup('def').addInput('temperature');
model.material('mat1').propertyGroup('def').addInput('pressure');
model.material('mat1').propertyGroup('RefractiveIndex').set('n', '');
model.material('mat1').propertyGroup('RefractiveIndex').set('ki', '');
model.material('mat1').propertyGroup('RefractiveIndex').set('n', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat1').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
model.material('mat3').label('Aluminum');
model.material('mat3').set('family', 'aluminum');
model.material('mat3').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat3').propertyGroup('def').set('heatcapacity', '900[J/(kg*K)]');
model.material('mat3').propertyGroup('def').set('thermalconductivity', {'238[W/(m*K)]' '0' '0' '0' '238[W/(m*K)]' '0' '0' '0' '238[W/(m*K)]'});
model.material('mat3').propertyGroup('def').set('electricconductivity', {'3.774e7[S/m]' '0' '0' '0' '3.774e7[S/m]' '0' '0' '0' '3.774e7[S/m]'});
model.material('mat3').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat3').propertyGroup('def').set('thermalexpansioncoefficient', {'23e-6[1/K]' '0' '0' '0' '23e-6[1/K]' '0' '0' '0' '23e-6[1/K]'});
model.material('mat3').propertyGroup('def').set('density', '2700[kg/m^3]');
model.material('mat3').propertyGroup('Enu').set('youngsmodulus', '70e9[Pa]');
model.material('mat3').propertyGroup('Enu').set('poissonsratio', '0.33');
model.material('mat3').propertyGroup('Murnaghan').set('l', '');
model.material('mat3').propertyGroup('Murnaghan').set('m', '');
model.material('mat3').propertyGroup('Murnaghan').set('n', '');
model.material('mat3').propertyGroup('Murnaghan').set('l', '-2.5e11[Pa]');
model.material('mat3').propertyGroup('Murnaghan').set('m', '-3.3e11[Pa]');
model.material('mat3').propertyGroup('Murnaghan').set('n', '-3.5e11[Pa]');
model.material('mat3').propertyGroup('Lame').set('lambLame', '');
model.material('mat3').propertyGroup('Lame').set('muLame', '');
model.material('mat3').propertyGroup('Lame').set('lambLame', '5.1e10[Pa]');
model.material('mat3').propertyGroup('Lame').set('muLame', '2.6e10[Pa]');
model.material('mat4').label('Copper');
model.material('mat4').set('family', 'copper');
model.material('mat4').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat4').propertyGroup('def').set('electricconductivity', {'5.998e7[S/m]' '0' '0' '0' '5.998e7[S/m]' '0' '0' '0' '5.998e7[S/m]'});
model.material('mat4').propertyGroup('def').set('thermalexpansioncoefficient', {'17e-6[1/K]' '0' '0' '0' '17e-6[1/K]' '0' '0' '0' '17e-6[1/K]'});
model.material('mat4').propertyGroup('def').set('heatcapacity', '385[J/(kg*K)]');
model.material('mat4').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat4').propertyGroup('def').set('density', '8960[kg/m^3]');
model.material('mat4').propertyGroup('def').set('thermalconductivity', {'400[W/(m*K)]' '0' '0' '0' '400[W/(m*K)]' '0' '0' '0' '400[W/(m*K)]'});
model.material('mat4').propertyGroup('Enu').set('youngsmodulus', '110e9[Pa]');
model.material('mat4').propertyGroup('Enu').set('poissonsratio', '0.35');
model.material('mat4').propertyGroup('linzRes').set('rho0', '');
model.material('mat4').propertyGroup('linzRes').set('alpha', '');
model.material('mat4').propertyGroup('linzRes').set('Tref', '');
model.material('mat4').propertyGroup('linzRes').set('rho0', '1.72e-8[ohm*m]');
model.material('mat4').propertyGroup('linzRes').set('alpha', '0.0039[1/K]');
model.material('mat4').propertyGroup('linzRes').set('Tref', '298[K]');
model.material('mat4').propertyGroup('linzRes').addInput('temperature');

model.cpl('intop1').label('Integration 1a');
%CURRENT EXCITATION
model.physics('mef').feature('mi1').feature('term1').set('I0', '1.5435e5/2');

model.mesh('mesh1').feature('ftet1').feature('size1').label('rail');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', 3);
model.mesh('mesh1').feature('ftet1').feature('size3').label('air');
model.mesh('mesh1').feature('ftet1').feature('size2').label('armature');
model.mesh('mesh1').feature('ftet1').feature('size2').set('hauto', 3);
model.mesh('mesh1').feature('ftet1').feature('size2').set('custom', 'on');
model.mesh('mesh1').feature('ftet1').feature('size2').set('hgrad', '1.1');
model.mesh('mesh1').feature('ftet1').feature('size2').set('hmin', '0.8');
model.mesh('mesh1').feature('ftet1').feature('size2').set('hmax', '11');
model.mesh('mesh1').feature('ftet1').feature('size2').set('hgradactive', true);
model.mesh('mesh1').feature('ftet1').feature('size2').set('hminactive', false);
model.mesh('mesh1').feature('ftet1').feature('size2').set('hmaxactive', false);
model.mesh('mesh1').feature('ftet1').feature('size4').set('hauto', 1);
model.mesh('mesh1').feature('ftet1').feature('size4').set('custom', 'on');
model.mesh('mesh1').feature('ftet1').feature('size4').set('hmaxactive', true);
model.mesh('mesh1').feature('ftet1').feature('size4').set('hmin', '0.04');
model.mesh('mesh1').feature('ftet1').feature('size4').set('hmax', '2');
model.mesh('mesh1').feature('ftet1').feature('size4').set('hminactive', false);
model.mesh('mesh1').feature('ftet1').feature('size5').set('hauto', 1);
model.mesh('mesh1').feature('ftet1').feature('size5').set('custom', 'on');
model.mesh('mesh1').feature('ftet1').feature('size5').set('hmaxactive', true);
model.mesh('mesh1').feature('ftet1').feature('size5').set('hmin', '0.04');
model.mesh('mesh1').feature('ftet1').feature('size5').set('hmax', '2');
model.mesh('mesh1').feature('ftet1').feature('size5').set('hminactive', false);
model.mesh('mesh1').feature('ftet1').feature('size6').set('hauto', 2);
model.mesh('mesh1').run;

model.result.table('tbl2').comments('Global Evaluation 3 (sin(x))');

model.study.create('std1');
model.study('std1').create('freq', 'Frequency');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').create('so1', 'SOR');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('so1', 'SOR');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').create('kp1', 'KrylovPreconditioner');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('kp1').create('so1', 'SOR');
model.sol('sol1').feature('s1').feature.remove('fcDef');

model.result.dataset.create('cpl1', 'CutPlane');
model.result.numerical.create('gev4', 'EvalGlobal');
model.result.numerical('gev4').set('probetag', 'none');
model.result.create('pg1', 'PlotGroup3D');
model.result.create('pg2', 'PlotGroup2D');
model.result('pg1').create('mslc1', 'Multislice');
model.result('pg1').create('surf1', 'Surface');
model.result('pg2').create('surf1', 'Surface');
%SET FREQUENCY
model.study('std1').feature('freq').set('plist', '100');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('v1').set('clist', {'100[Hz]'});
model.sol('sol1').feature('v1').set('cname', {'freq'});
model.sol('sol1').feature('v1').set('clistctrl', {'p1'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'100'});
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'fgmres');
model.sol('sol1').feature('s1').feature('i1').set('rhob', '1e4');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('kp1').set('iterm', 'itertol');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('kp1').set('prefuntype', 'right');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('kp1').set('iter', '25');
model.sol('sol1').runAll;

model.result.dataset('cpl1').set('quickplane', 'xy');
model.result.dataset('cpl1').set('quickz', '5');
model.result.numerical('gev4').label('acc from mef');
model.result.numerical('gev4').set('descr', {'' ''});
model.result.numerical('gev4').set('unit', {'m/s^2' ''});
model.result.numerical('gev4').set('expr', {'acc' ''});
model.result('pg1').label('Magnetic Flux Density Norm (mef)');
model.result('pg1').feature('mslc1').active(false);
model.result('pg1').feature('mslc1').set('descr', 'Current density norm');
model.result('pg1').feature('mslc1').set('unit', 'A/m^2');
model.result('pg1').feature('mslc1').set('expr', 'mef.normJ');
model.result('pg1').feature('mslc1').set('resolution', 'normal');
model.result('pg1').feature('surf1').set('descr', 'Magnetic flux density norm');
model.result('pg1').feature('surf1').set('unit', 'T');
model.result('pg1').feature('surf1').set('expr', 'mef.normB');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg2').label('Current');
model.result('pg2').feature('surf1').set('descr', 'Current density norm');
model.result('pg2').feature('surf1').set('unit', 'A/m^2');
model.result('pg2').feature('surf1').set('expr', 'mef.normJ');
model.result('pg2').feature('surf1').set('resolution', 'normal');
model.result.numerical.create('gev5', 'EvalGlobal');
model.result.numerical('gev5').setIndex('expr', 'mass', 0);
model.result.table.create('tbl3', 'Table');
model.result.table('tbl3').comments('Global Evaluation 5 (mass)');
model.result.numerical('gev5').set('table', 'tbl3');
model.result.numerical('gev5').setResult;
model.result.table.remove('tbl3');
model.result.numerical('gev5').label('Mass Calculation');

%bunun altini aynen al!!
acc_peak = mpheval(model,'acc');
acc_peak = acc_peak.d1;
acc_peak = acc_peak(1,1);
%mphplot(model,'pg1','rangenum',1);

mass = mpheval(model,'mass');
mass = mass.d1;
mass = mass(1,1);

if(showPlot == 1)
    mphplot(model,'pg1','rangenum',1);
end




% return acceleration and mass
out = [acc_peak mass];
