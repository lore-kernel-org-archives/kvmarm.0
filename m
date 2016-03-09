From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 31/95] arm64: KVM: Switch to C-based stage2 init
Date: Wed,  9 Mar 2016 07:30:25 +0000
Message-ID: <1457508689-19672-32-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

There is no real need to leave the stage2 initialization as part
of the early HYP bootstrap, and we can easily postpone it to
the point where we can safely run C code.

This will help VHE, which doesn't need any of this bootstrap.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h  |  2 ++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/hyp-init.S         | 15 +------------
 arch/arm64/kvm/hyp/Makefile       |  1 +
 arch/arm64/kvm/hyp/s2-setup.c     | 44 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 50 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/s2-setup.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2ad8930..1037392 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -45,6 +45,8 @@ extern u64 __vgic_v3_get_ich_vtr_el2(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
+extern void __init_stage2_translation(void);
+
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fe86cf9..43688d9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -25,6 +25,7 @@
 #include <linux/types.h>
 #include <linux/kvm_types.h>
 #include <asm/kvm.h>
+#include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -334,6 +335,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 
 static inline void __cpu_init_stage2(void)
 {
+	kvm_call_hyp(__init_stage2_translation);
 }
 
 static inline void kvm_arch_hardware_disable(void) {}
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index d073b5a..7d8747c 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -87,26 +87,13 @@ __do_hyp_init:
 #endif
 	/*
 	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
-	 * TCR_EL2 and VTCR_EL2.
+	 * TCR_EL2.
 	 */
 	mrs	x5, ID_AA64MMFR0_EL1
 	bfi	x4, x5, #16, #3
 
 	msr	tcr_el2, x4
 
-	ldr	x4, =VTCR_EL2_FLAGS
-	bfi	x4, x5, #16, #3
-	/*
-	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS bit in
-	 * VTCR_EL2.
-	 */
-	mrs	x5, ID_AA64MMFR1_EL1
-	ubfx	x5, x5, #5, #1
-	lsl	x5, x5, #VTCR_EL2_VS
-	orr	x4, x4, x5
-
-	msr	vtcr_el2, x4
-
 	mrs	x4, mair_el1
 	msr	mair_el2, x4
 	isb
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 826032b..5326e66 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += switch.o
 obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
+obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
new file mode 100644
index 0000000..17e8cc0
--- /dev/null
+++ b/arch/arm64/kvm/hyp/s2-setup.c
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2016 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/types.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
+
+#include "hyp.h"
+
+void __hyp_text __init_stage2_translation(void)
+{
+	u64 val = VTCR_EL2_FLAGS;
+	u64 tmp;
+
+	/*
+	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS
+	 * bits in VTCR_EL2. Amusingly, the PARange is 4 bits, while
+	 * PS is only 3. Fortunately, bit 19 is RES0 in VTCR_EL2...
+	 */
+	val |= (read_sysreg(id_aa64mmfr0_el1) & 7) << 16;
+
+	/*
+	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS
+	 * bit in VTCR_EL2.
+	 */
+	tmp = (read_sysreg(id_aa64mmfr1_el1) >> 4) & 0xf;
+	val |= (tmp == 2) ? VTCR_EL2_VS : 0;
+
+	write_sysreg(val, vtcr_el2);
+}
-- 
2.1.4

