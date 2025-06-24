#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"  // pour usleep()

// === Définition des adresses de registres dans le wrapper ===
#define WRAPPER_BASE       XPAR_MYIPWRAPPER_V1_0_0_BASEADDR

#define REG_ID_FIXED       (WRAPPER_BASE + 0x00)
#define REG_ID_DYNAMIC     (WRAPPER_BASE + 0x04)
#define REG_STATUS         (WRAPPER_BASE + 0x10)  // reg4 dans wrapper

int main() {
    u32 id_fixed   = 0x00001234;
    u32 id_dynamic = 0;
    u32 status     = 0;
    u8  granted, denied, irq;

    xil_printf("\n=== Début surveillance MicroBlaze ===\r\n\n");

    // Initialiser l'ID fixe
    Xil_Out32(REG_ID_FIXED, id_fixed);
    xil_printf("→  Initialisation ID fixe : 0x%08lx\r\n\n", id_fixed);

    while (1) {
        // Lire l'ID dynamique et le status
        id_dynamic = Xil_In32(REG_ID_DYNAMIC);

        // Ignorer l'ID nul
        if (id_dynamic == 0x00000000) {
            usleep(100000); // 100ms pour éviter de spammer
            continue;
        }

        status = Xil_In32(REG_STATUS);

        granted = (status & 0x1);
        denied  = (status >> 1) & 0x1;
        irq     = (status >> 2) & 0x1;

        xil_printf("→ ID dynamique : 0x%08lx | Granted = %d | Denied = %d | IRQ = %d\r\n",
                   id_dynamic, granted, denied, irq);

        usleep(950000);
    }

    return 0; // jamais atteint
}
