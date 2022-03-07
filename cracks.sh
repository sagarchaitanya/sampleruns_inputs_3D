#!/bin/bash
start=`date +%s`
for i in 563
do
#atomstyle=atom
#atomic
datfile=${i}
#datfile2=${i}x${i}_1sw
#datfile3=${i}x${i}_2sw
for j in 300 
do
T=${j}
cat > tensiletest_${datfile}_ac_${T}.lmp << EOF

units        real
timestep     0.5
variable     fpress  equal 0.000101325  # atm -> GPa
variable     fenergy equal 0.043        # Kcal/mole -> eV
dimension    3
boundary p p p 
atom_style   charge
read_data    ${datfile}.data
pair_style   reax/c NULL checkqeq no
pair_coeff   * * ffield.reax_2013 C
variable     tmp     equal lx
variable     lx0     equal \${tmp}
variable     tmp     equal ly
variable     ly0     equal \${tmp}
variable     tmp     equal lz
variable     lz0     equal \${tmp}
variable     etotal  equal etotal/atoms*\${fenergy} #eV/atom
variable     pe      equal     pe/atoms*\${fenergy} #eV/atom
variable     ke      equal     ke/atoms*\${fenergy} #eV/atom
variable     strainx equal (lx-\${lx0})/\${lx0}
variable     strainy equal (ly-\${ly0})/\${ly0}
variable     strainz equal (lz-\${lz0})/\${lz0}
variable     stressx equal -pxx*(lz/3.35)*\${fpress} #GPa
variable     stressy equal -pyy*(lz/3.35)*\${fpress} #GPa
variable     stressz equal -pzz*(lz/3.35)*\${fpress} #GPa
thermo_style custom step time temp etotal press v_etotal v_pe v_ke &
             v_strainx v_stressx v_strainy v_stressy v_strainz v_stressz
variable     temp index $T
variable     seed index 1717
velocity     all create \${temp} \${seed} dist uniform
fix          fnpt all npt temp \${temp} \${temp} 10 x 0 0 500 y 0 0 500 z 0 0 500
compute peratom all stress/atom NULL
variable stress_atom atom sqrt(c_peratom[1]*c_peratom[1]+c_peratom[2]*c_peratom[2]+c_peratom[3]*c_peratom[3])
dump         2 all custom 200 dump_stress_${datfile}_${T}_tensile_ac.lammpstrj id type x y z v_stress_atom
thermo       2000
run          200000
# DEFORMATION
unfix             fnpt 
reset_timestep     0
fix          boxdeform all deform 1 x scale 2 remap x
fix          fnpt all npt temp \${temp} \${temp} 10 y 0 0 500 
thermo       200
#thermo_modify lost warn flush yes
run          2000000
EOF
#mpirun -np 8 lmp_mpi < tensiletest_${datfile}_ac_${T}.lmp -l tensiletest_${datfile}_ac_${T}.log

cat > tensiletest_${datfile}_zz_${T}.lmp << EOF

units        real
timestep     0.5
variable     fpress  equal 0.000101325  # atm -> GPa
variable     fenergy equal 0.043        # Kcal/mole -> eV
dimension    3
boundary p p p 
atom_style   charge 
read_data    ${datfile}.data
pair_style   reax/c NULL checkqeq no
pair_coeff   * * ffield.reax_2013 C
variable     tmp     equal lx
variable     lx0     equal \${tmp}
variable     tmp     equal ly
variable     ly0     equal \${tmp}
variable     tmp     equal lz
variable     lz0     equal \${tmp}
variable     etotal  equal etotal/atoms*\${fenergy} #eV/atom
variable     pe      equal     pe/atoms*\${fenergy} #eV/atom
variable     ke      equal     ke/atoms*\${fenergy} #eV/atom
variable     strainx equal (lx-\${lx0})/\${lx0}
variable     strainy equal (ly-\${ly0})/\${ly0}
variable     strainz equal (lz-\${lz0})/\${lz0}
variable     stressx equal -pxx*(lz/3.35)*\${fpress} #GPa
variable     stressy equal -pyy*(lz/3.35)*\${fpress} #GPa
variable     stressz equal -pzz*(lz/3.35)*\${fpress} #GPa
thermo_style custom step time temp etotal press v_etotal v_pe v_ke &
             v_strainx v_stressx v_strainy v_stressy v_strainz v_stressz
variable     temp index $T
variable     seed index 1717
velocity     all create \${temp} \${seed} dist uniform
fix          fnpt all npt temp \${temp} \${temp} 10 x 0 0 500 y 0 0 500 z 0 0 500
compute peratom all stress/atom NULL
variable stress_atom atom sqrt(c_peratom[1]*c_peratom[1]+c_peratom[2]*c_peratom[2]+c_peratom[3]*c_peratom[3])
dump         2 all custom 200 dump_stress_${datfile}_${T}_tensile_zz.lammpstrj id type x y z v_stress_atom
thermo       2000
run          200000
# DEFORMATION
unfix              fnpt
reset_timestep     0
fix          boxdeform all deform 1 y scale 2 remap x
fix          fnpt all npt temp \${temp} \${temp} 10 x 0 0 500
thermo       200
thermo_modify lost warn flush yes
run          2000000
EOF
#mpirun -np 8 lmp_mpi < tensiletest_${datfile}_zz_${T}.lmp -l tensiletest_${datfile}_zz_${T}.log

cat > tensiletest_${datfile}_ll_${T}.lmp << EOF

units        real
timestep     0.5
variable     fpress  equal 0.000101325  # atm -> GPa
variable     fenergy equal 0.043        # Kcal/mole -> eV
dimension    3
boundary p p p 
atom_style   charge 
read_data    ${datfile}.data
pair_style   reax/c NULL checkqeq no
pair_coeff   * * ffield.reax_2013 C
variable     tmp     equal lx
variable     lx0     equal \${tmp}
variable     tmp     equal ly
variable     ly0     equal \${tmp}
variable     tmp     equal lz
variable     lz0     equal \${tmp}
variable     etotal  equal etotal/atoms*\${fenergy} #eV/atom
variable     pe      equal     pe/atoms*\${fenergy} #eV/atom
variable     ke      equal     ke/atoms*\${fenergy} #eV/atom
variable     strainx equal (lx-\${lx0})/\${lx0}
variable     strainy equal (ly-\${ly0})/\${ly0}
variable     strainz equal (lz-\${lz0})/\${lz0}
variable     stressx equal -pxx*(lz/3.35)*\${fpress} #GPa
variable     stressy equal -pyy*(lz/3.35)*\${fpress} #GPa
variable     stressz equal -pzz*(lz/3.35)*\${fpress} #GPa
thermo_style custom step time temp etotal press v_etotal v_pe v_ke &
             v_strainx v_stressx v_strainy v_stressy v_strainz v_stressz
variable     temp index $T
variable     seed index 1717
velocity     all create \${temp} \${seed} dist uniform
fix          fnpt all npt temp \${temp} \${temp} 10 x 0 0 500 y 0 0 500 z 0 0 500
compute peratom all stress/atom NULL
variable stress_atom atom sqrt(c_peratom[1]*c_peratom[1]+c_peratom[2]*c_peratom[2]+c_peratom[3]*c_peratom[3])
dump         2 all custom 200 dump_stress_${datfile}_${T}_tensile_ll.lammpstrj id type x y z v_stress_atom
thermo       2000
run          200000
# DEFORMATION
unfix              fnpt
reset_timestep     0
fix          boxdeform all deform 1 z scale 2 remap x
fix          fnpt all npt temp \${temp} \${temp} 10 x 0 0 500
thermo       200
thermo_modify lost warn flush yes
run          2000000
EOF
#mpirun -np 8 lmp_mpi < tensiletest_${datfile}_ll_${T}.lmp -l tensiletest_${datfile}_ll_${T}.log
done
done

