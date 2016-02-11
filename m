From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 02/23] arm64: KVM: Switch to C-based stage2 init
Date: Thu, 11 Feb 2016 18:39:43 +0000
Message-ID: <1455216004-19499-3-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C910F49BEA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MmTUZHBGfqqu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FA2E49BE8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:17 -0500 (EST)
In-Reply-To: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
 arch/arm64/kvm/hyp-init.S         | 18 ----------------
 arch/arm64/kvm/hyp/Makefile       |  1 +
 arch/arm64/kvm/hyp/s2-setup.c     | 44 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 49 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/s2-setup.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 52b777b..67ac580 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -48,6 +48,8 @@ extern u64 __vgic_v3_get_ich_vtr_el2(void);
 
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
index 3e568dc..80fda7e 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -87,24 +87,6 @@ __do_hyp_init:
 #endif
 	msr	tcr_el2, x4
 
-	ldr	x4, =VTCR_EL2_FLAGS
-	/*
-	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
-	 * VTCR_EL2.
-	 */
-	mrs	x5, ID_AA64MMFR0_EL1
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
