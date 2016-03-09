From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 23/95] ARM: KVM: Switch to C-based stage2 init
Date: Wed,  9 Mar 2016 07:30:17 +0000
Message-ID: <1457508689-19672-24-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we now have hooks to setup VTCR from C code, let's drop the
original VTCR setup and reimplement it as part of the HYP code.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h  |  2 ++
 arch/arm/include/asm/kvm_host.h |  1 +
 arch/arm/kvm/hyp/Makefile       |  1 +
 arch/arm/kvm/hyp/hyp.h          |  2 ++
 arch/arm/kvm/hyp/s2-setup.c     | 34 ++++++++++++++++++++++++++++++++++
 arch/arm/kvm/init.S             |  8 --------
 6 files changed, 40 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm/kvm/hyp/s2-setup.c

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 4841225..3283a2f 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -98,6 +98,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
+
+extern void __init_stage2_translation(void);
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index c62d717..0fe41aa 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -224,6 +224,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 
 static inline void __cpu_init_stage2(void)
 {
+	kvm_call_hyp(__init_stage2_translation);
 }
 
 static inline int kvm_arch_dev_ioctl_check_extension(long ext)
diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index a7d3a7e..7152369 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += switch.o
+obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
index 8b9c2eb..ff6de6a 100644
--- a/arch/arm/kvm/hyp/hyp.h
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -71,6 +71,8 @@
 #define HCPTR		__ACCESS_CP15(c1, 4, c1, 2)
 #define HSTR		__ACCESS_CP15(c1, 4, c1, 3)
 #define TTBCR		__ACCESS_CP15(c2, 0, c0, 2)
+#define HTCR		__ACCESS_CP15(c2, 4, c0, 2)
+#define VTCR		__ACCESS_CP15(c2, 4, c1, 2)
 #define DACR		__ACCESS_CP15(c3, 0, c0, 0)
 #define DFSR		__ACCESS_CP15(c5, 0, c0, 0)
 #define IFSR		__ACCESS_CP15(c5, 0, c0, 1)
diff --git a/arch/arm/kvm/hyp/s2-setup.c b/arch/arm/kvm/hyp/s2-setup.c
new file mode 100644
index 0000000..f5f49c5
--- /dev/null
+++ b/arch/arm/kvm/hyp/s2-setup.c
@@ -0,0 +1,34 @@
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
+	u64 val;
+
+	val = read_sysreg(VTCR) & ~VTCR_MASK;
+
+	val |= read_sysreg(HTCR) & VTCR_HTCR_SH;
+	val |= KVM_VTCR_SL0 | KVM_VTCR_T0SZ | KVM_VTCR_S;
+
+	write_sysreg(val, VTCR);
+}
diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 3988e72..1f9ae17 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -84,14 +84,6 @@ __do_hyp_init:
 	orr	r0, r0, r1
 	mcr	p15, 4, r0, c2, c0, 2	@ HTCR
 
-	mrc	p15, 4, r1, c2, c1, 2	@ VTCR
-	ldr	r2, =VTCR_MASK
-	bic	r1, r1, r2
-	bic	r0, r0, #(~VTCR_HTCR_SH)	@ clear non-reusable HTCR bits
-	orr	r1, r0, r1
-	orr	r1, r1, #(KVM_VTCR_SL0 | KVM_VTCR_T0SZ | KVM_VTCR_S)
-	mcr	p15, 4, r1, c2, c1, 2	@ VTCR
-
 	@ Use the same memory attributes for hyp. accesses as the kernel
 	@ (copy MAIRx ro HMAIRx).
 	mrc	p15, 0, r0, c10, c2, 0
-- 
2.1.4

