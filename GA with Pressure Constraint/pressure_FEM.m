function out = pressure_FEM(x1,x2,x3,x4,x5,x6,bombe)
    val = FEM_t_1mj_pressure_friction2(x1,x2,x3,x4,x5,x6,bombe,0);
    out = val(1,2);
end