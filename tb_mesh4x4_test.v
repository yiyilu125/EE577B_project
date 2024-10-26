module tb_mesh4x4_test();
    reg in;
    wire out;

    mesh4x4 uut(
        .pesi_r0(in), 
        .pero_r0(), 
        .pesi_r1(), 
        .pero_r1(), 
        .pesi_r2(), 
        .pero_r2(), 
        .pesi_r3(), 
        .pero_r3(),
        .pedi_r0(), 
        .pedi_r1(), 
        .pedi_r2(), 
        .pedi_r3(),
        .peri_r0(out), 
        .peso_r0(), 
        .peri_r1(), 
        .peso_r1(), 
        .peri_r2(), 
        .peso_r2(), 
        .peri_r3(), 
        .peso_r3(),
        .pedo_r0(), 
        .pedo_r1(), 
        .pedo_r2(), 
        .pedo_r3()
    );
endmodule