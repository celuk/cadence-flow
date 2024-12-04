`timescale 1ns / 1ns

module c0_pads_pwr ( );

    PVDD2POC VDD2POC ( .VDDPST() );
    PVDD2CDG VDDPST_0 ( .VDDPST() );
    PVDD2CDG VDDPST_1 ( .VDDPST() );
    PVDD1CDG VDD_0 ( .VDD() );
    PVDD1CDG VDD_1 ( .VDD() );
    PVSS3CDG VSS_0 ( .VSS() );
    PVSS3CDG VSS_1 ( .VSS() );

endmodule

