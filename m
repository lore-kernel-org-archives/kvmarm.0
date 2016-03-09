From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 52/95] arm64: KVM: Move kvm/hyp/hyp.h to include/asm/kvm_hyp.h
Date: Wed,  9 Mar 2016 07:30:46 +0000
Message-ID: <1457508689-19672-53-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F9D49B32
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O33lqi41dBnx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:34:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55ECF48531
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:12 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to be able to move code outside of kvm/hyp, we need to make
the global hyp.h file accessible from a standard location.

include/asm/kvm_hyp.h seems good enough.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 180 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/debug-sr.c    |   4 +-
 arch/arm64/kvm/hyp/hyp.h         | 180 ---------------------------------------
 arch/arm64/kvm/hyp/s2-setup.c    |   3 +-
 arch/arm64/kvm/hyp/switch.c      |   3 +-
 arch/arm64/kvm/hyp/sysreg-sr.c   |   4 +-
 arch/arm64/kvm/hyp/timer-sr.c    |   4 +-
 arch/arm64/kvm/hyp/tlb.c         |   2 +-
 arch/arm64/kvm/hyp/vgic-v2-sr.c  |   4 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c  |   4 +-
 10 files changed, 188 insertions(+), 200 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_hyp.h
 delete mode 100644 arch/arm64/kvm/hyp/hyp.h

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
new file mode 100644
index 0000000..44eaff7
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -0,0 +1,180 @@
+/*
+ * Copyright (C) 2015 - ARM Ltd
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
+#ifndef __ARM64_KVM_HYP_H__
+#define __ARM64_KVM_HYP_H__
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_mmu.h>
+#include <asm/sysreg.h>
+
+#define __hyp_text __section(.hyp.text) notrace
+
+static inline unsigned long __kern_hyp_va(unsigned long v)
+{
+	asm volatile(ALTERNATIVE("and %0, %0, %1",
+				 "nop",
+				 ARM64_HAS_VIRT_HOST_EXTN)
+		     : "+r" (v) : "i" (HYP_PAGE_OFFSET_MASK));
+	return v;
+}
+
+#define kern_hyp_va(v) (typeof(v))(__kern_hyp_va((unsigned long)(v)))
+
+static inline unsigned long __hyp_kern_va(unsigned long v)
+{
+	u64 offset = PAGE_OFFSET - HYP_PAGE_OFFSET;
+	asm volatile(ALTERNATIVE("add %0, %0, %1",
+				 "nop",
+				 ARM64_HAS_VIRT_HOST_EXTN)
+		     : "+r" (v) : "r" (offset));
+	return v;
+}
+
+#define hyp_kern_va(v) (typeof(v))(__hyp_kern_va((unsigned long)(v)))
+
+#define read_sysreg_elx(r,nvh,vh)					\
+	({								\
+		u64 reg;						\
+		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##nvh),\
+					 "mrs_s %0, " __stringify(r##vh),\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+			     : "=r" (reg));				\
+		reg;							\
+	})
+
+#define write_sysreg_elx(v,r,nvh,vh)					\
+	do {								\
+		u64 __val = (u64)(v);					\
+		asm volatile(ALTERNATIVE("msr " __stringify(r##nvh) ", %x0",\
+					 "msr_s " __stringify(r##vh) ", %x0",\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+					 : : "rZ" (__val));		\
+	} while (0)
+
+/*
+ * Unified accessors for registers that have a different encoding
+ * between VHE and non-VHE. They must be specified without their "ELx"
+ * encoding.
+ */
+#define read_sysreg_el2(r)						\
+	({								\
+		u64 reg;						\
+		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##_EL2),\
+					 "mrs %0, " __stringify(r##_EL1),\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+			     : "=r" (reg));				\
+		reg;							\
+	})
+
+#define write_sysreg_el2(v,r)						\
+	do {								\
+		u64 __val = (u64)(v);					\
+		asm volatile(ALTERNATIVE("msr " __stringify(r##_EL2) ", %x0",\
+					 "msr " __stringify(r##_EL1) ", %x0",\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+					 : : "rZ" (__val));		\
+	} while (0)
+
+#define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
+#define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
+#define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
+#define write_sysreg_el1(v,r)	write_sysreg_elx(v, r, _EL1, _EL12)
+
+/* The VHE specific system registers and their encoding */
+#define sctlr_EL12              sys_reg(3, 5, 1, 0, 0)
+#define cpacr_EL12              sys_reg(3, 5, 1, 0, 2)
+#define ttbr0_EL12              sys_reg(3, 5, 2, 0, 0)
+#define ttbr1_EL12              sys_reg(3, 5, 2, 0, 1)
+#define tcr_EL12                sys_reg(3, 5, 2, 0, 2)
+#define afsr0_EL12              sys_reg(3, 5, 5, 1, 0)
+#define afsr1_EL12              sys_reg(3, 5, 5, 1, 1)
+#define esr_EL12                sys_reg(3, 5, 5, 2, 0)
+#define far_EL12                sys_reg(3, 5, 6, 0, 0)
+#define mair_EL12               sys_reg(3, 5, 10, 2, 0)
+#define amair_EL12              sys_reg(3, 5, 10, 3, 0)
+#define vbar_EL12               sys_reg(3, 5, 12, 0, 0)
+#define contextidr_EL12         sys_reg(3, 5, 13, 0, 1)
+#define cntkctl_EL12            sys_reg(3, 5, 14, 1, 0)
+#define cntp_tval_EL02          sys_reg(3, 5, 14, 2, 0)
+#define cntp_ctl_EL02           sys_reg(3, 5, 14, 2, 1)
+#define cntp_cval_EL02          sys_reg(3, 5, 14, 2, 2)
+#define cntv_tval_EL02          sys_reg(3, 5, 14, 3, 0)
+#define cntv_ctl_EL02           sys_reg(3, 5, 14, 3, 1)
+#define cntv_cval_EL02          sys_reg(3, 5, 14, 3, 2)
+#define spsr_EL12               sys_reg(3, 5, 4, 0, 0)
+#define elr_EL12                sys_reg(3, 5, 4, 0, 1)
+
+/**
+ * hyp_alternate_select - Generates patchable code sequences that are
+ * used to switch between two implementations of a function, depending
+ * on the availability of a feature.
+ *
+ * @fname: a symbol name that will be defined as a function returning a
+ * function pointer whose type will match @orig and @alt
+ * @orig: A pointer to the default function, as returned by @fname when
+ * @cond doesn't hold
+ * @alt: A pointer to the alternate function, as returned by @fname
+ * when @cond holds
+ * @cond: a CPU feature (as described in asm/cpufeature.h)
+ */
+#define hyp_alternate_select(fname, orig, alt, cond)			\
+typeof(orig) * __hyp_text fname(void)					\
+{									\
+	typeof(alt) *val = orig;					\
+	asm volatile(ALTERNATIVE("nop		\n",			\
+				 "mov	%0, %1	\n",			\
+				 cond)					\
+		     : "+r" (val) : "r" (alt));				\
+	return val;							\
+}
+
+void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
+void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
+
+void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
+void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
+
+void __timer_save_state(struct kvm_vcpu *vcpu);
+void __timer_restore_state(struct kvm_vcpu *vcpu);
+
+void __sysreg_save_host_state(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_host_state(struct kvm_cpu_context *ctxt);
+void __sysreg_save_guest_state(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
+void __sysreg32_save_state(struct kvm_vcpu *vcpu);
+void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
+
+void __debug_save_state(struct kvm_vcpu *vcpu,
+			struct kvm_guest_debug_arch *dbg,
+			struct kvm_cpu_context *ctxt);
+void __debug_restore_state(struct kvm_vcpu *vcpu,
+			   struct kvm_guest_debug_arch *dbg,
+			   struct kvm_cpu_context *ctxt);
+void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
+void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
+
+void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
+void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
+bool __fpsimd_enabled(void);
+
+u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
+void __noreturn __hyp_do_panic(unsigned long, ...);
+
+#endif /* __ARM64_KVM_HYP_H__ */
+
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index c9c1e97..053cf8b 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -19,9 +19,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_asm.h>
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 #define read_debug(r,n)		read_sysreg(r##n##_el1)
 #define write_debug(v,r,n)	write_sysreg(v, r##n##_el1)
diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
deleted file mode 100644
index 44eaff7..0000000
--- a/arch/arm64/kvm/hyp/hyp.h
+++ /dev/null
@@ -1,180 +0,0 @@
-/*
- * Copyright (C) 2015 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __ARM64_KVM_HYP_H__
-#define __ARM64_KVM_HYP_H__
-
-#include <linux/compiler.h>
-#include <linux/kvm_host.h>
-#include <asm/kvm_mmu.h>
-#include <asm/sysreg.h>
-
-#define __hyp_text __section(.hyp.text) notrace
-
-static inline unsigned long __kern_hyp_va(unsigned long v)
-{
-	asm volatile(ALTERNATIVE("and %0, %0, %1",
-				 "nop",
-				 ARM64_HAS_VIRT_HOST_EXTN)
-		     : "+r" (v) : "i" (HYP_PAGE_OFFSET_MASK));
-	return v;
-}
-
-#define kern_hyp_va(v) (typeof(v))(__kern_hyp_va((unsigned long)(v)))
-
-static inline unsigned long __hyp_kern_va(unsigned long v)
-{
-	u64 offset = PAGE_OFFSET - HYP_PAGE_OFFSET;
-	asm volatile(ALTERNATIVE("add %0, %0, %1",
-				 "nop",
-				 ARM64_HAS_VIRT_HOST_EXTN)
-		     : "+r" (v) : "r" (offset));
-	return v;
-}
-
-#define hyp_kern_va(v) (typeof(v))(__hyp_kern_va((unsigned long)(v)))
-
-#define read_sysreg_elx(r,nvh,vh)					\
-	({								\
-		u64 reg;						\
-		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##nvh),\
-					 "mrs_s %0, " __stringify(r##vh),\
-					 ARM64_HAS_VIRT_HOST_EXTN)	\
-			     : "=r" (reg));				\
-		reg;							\
-	})
-
-#define write_sysreg_elx(v,r,nvh,vh)					\
-	do {								\
-		u64 __val = (u64)(v);					\
-		asm volatile(ALTERNATIVE("msr " __stringify(r##nvh) ", %x0",\
-					 "msr_s " __stringify(r##vh) ", %x0",\
-					 ARM64_HAS_VIRT_HOST_EXTN)	\
-					 : : "rZ" (__val));		\
-	} while (0)
-
-/*
- * Unified accessors for registers that have a different encoding
- * between VHE and non-VHE. They must be specified without their "ELx"
- * encoding.
- */
-#define read_sysreg_el2(r)						\
-	({								\
-		u64 reg;						\
-		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##_EL2),\
-					 "mrs %0, " __stringify(r##_EL1),\
-					 ARM64_HAS_VIRT_HOST_EXTN)	\
-			     : "=r" (reg));				\
-		reg;							\
-	})
-
-#define write_sysreg_el2(v,r)						\
-	do {								\
-		u64 __val = (u64)(v);					\
-		asm volatile(ALTERNATIVE("msr " __stringify(r##_EL2) ", %x0",\
-					 "msr " __stringify(r##_EL1) ", %x0",\
-					 ARM64_HAS_VIRT_HOST_EXTN)	\
-					 : : "rZ" (__val));		\
-	} while (0)
-
-#define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
-#define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
-#define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
-#define write_sysreg_el1(v,r)	write_sysreg_elx(v, r, _EL1, _EL12)
-
-/* The VHE specific system registers and their encoding */
-#define sctlr_EL12              sys_reg(3, 5, 1, 0, 0)
-#define cpacr_EL12              sys_reg(3, 5, 1, 0, 2)
-#define ttbr0_EL12              sys_reg(3, 5, 2, 0, 0)
-#define ttbr1_EL12              sys_reg(3, 5, 2, 0, 1)
-#define tcr_EL12                sys_reg(3, 5, 2, 0, 2)
-#define afsr0_EL12              sys_reg(3, 5, 5, 1, 0)
-#define afsr1_EL12              sys_reg(3, 5, 5, 1, 1)
-#define esr_EL12                sys_reg(3, 5, 5, 2, 0)
-#define far_EL12                sys_reg(3, 5, 6, 0, 0)
-#define mair_EL12               sys_reg(3, 5, 10, 2, 0)
-#define amair_EL12              sys_reg(3, 5, 10, 3, 0)
-#define vbar_EL12               sys_reg(3, 5, 12, 0, 0)
-#define contextidr_EL12         sys_reg(3, 5, 13, 0, 1)
-#define cntkctl_EL12            sys_reg(3, 5, 14, 1, 0)
-#define cntp_tval_EL02          sys_reg(3, 5, 14, 2, 0)
-#define cntp_ctl_EL02           sys_reg(3, 5, 14, 2, 1)
-#define cntp_cval_EL02          sys_reg(3, 5, 14, 2, 2)
-#define cntv_tval_EL02          sys_reg(3, 5, 14, 3, 0)
-#define cntv_ctl_EL02           sys_reg(3, 5, 14, 3, 1)
-#define cntv_cval_EL02          sys_reg(3, 5, 14, 3, 2)
-#define spsr_EL12               sys_reg(3, 5, 4, 0, 0)
-#define elr_EL12                sys_reg(3, 5, 4, 0, 1)
-
-/**
- * hyp_alternate_select - Generates patchable code sequences that are
- * used to switch between two implementations of a function, depending
- * on the availability of a feature.
- *
- * @fname: a symbol name that will be defined as a function returning a
- * function pointer whose type will match @orig and @alt
- * @orig: A pointer to the default function, as returned by @fname when
- * @cond doesn't hold
- * @alt: A pointer to the alternate function, as returned by @fname
- * when @cond holds
- * @cond: a CPU feature (as described in asm/cpufeature.h)
- */
-#define hyp_alternate_select(fname, orig, alt, cond)			\
-typeof(orig) * __hyp_text fname(void)					\
-{									\
-	typeof(alt) *val = orig;					\
-	asm volatile(ALTERNATIVE("nop		\n",			\
-				 "mov	%0, %1	\n",			\
-				 cond)					\
-		     : "+r" (val) : "r" (alt));				\
-	return val;							\
-}
-
-void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
-void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
-
-void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
-void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
-
-void __timer_save_state(struct kvm_vcpu *vcpu);
-void __timer_restore_state(struct kvm_vcpu *vcpu);
-
-void __sysreg_save_host_state(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_host_state(struct kvm_cpu_context *ctxt);
-void __sysreg_save_guest_state(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
-void __sysreg32_save_state(struct kvm_vcpu *vcpu);
-void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
-
-void __debug_save_state(struct kvm_vcpu *vcpu,
-			struct kvm_guest_debug_arch *dbg,
-			struct kvm_cpu_context *ctxt);
-void __debug_restore_state(struct kvm_vcpu *vcpu,
-			   struct kvm_guest_debug_arch *dbg,
-			   struct kvm_cpu_context *ctxt);
-void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
-void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
-
-void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
-void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
-bool __fpsimd_enabled(void);
-
-u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
-void __noreturn __hyp_do_panic(unsigned long, ...);
-
-#endif /* __ARM64_KVM_HYP_H__ */
-
diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
index 17e8cc0..bfc54fd 100644
--- a/arch/arm64/kvm/hyp/s2-setup.c
+++ b/arch/arm64/kvm/hyp/s2-setup.c
@@ -18,8 +18,7 @@
 #include <linux/types.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 void __hyp_text __init_stage2_translation(void)
 {
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index ecf5b05..7b81e56 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -17,8 +17,7 @@
 
 #include <linux/types.h>
 #include <asm/kvm_asm.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 74b5f81..0f7c40e 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -19,9 +19,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_asm.h>
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 /* Yes, this does nothing, on purpose */
 static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/arch/arm64/kvm/hyp/timer-sr.c
index f276d9e..ea00d69 100644
--- a/arch/arm64/kvm/hyp/timer-sr.c
+++ b/arch/arm64/kvm/hyp/timer-sr.c
@@ -19,9 +19,7 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 /* vcpu is already in the HYP VA space */
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 2a7e0d8..be8177c 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -15,7 +15,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
index e717612..9514a7d 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
@@ -19,9 +19,7 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm_host.h>
 
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 /* vcpu is already in the HYP VA space */
 void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 5dd2a26..0035b2d 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -19,9 +19,7 @@
 #include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kvm_host.h>
 
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 #define vtr_to_max_lr_idx(v)		((v) & 0xf)
 #define vtr_to_nr_pri_bits(v)		(((u32)(v) >> 29) + 1)
-- 
2.1.4
