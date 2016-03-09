From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 54/95] ARM: KVM: Move kvm/hyp/hyp.h to include/asm/kvm_hyp.h
Date: Wed,  9 Mar 2016 07:30:48 +0000
Message-ID: <1457508689-19672-55-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9776149B56
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 03uGhD7vKV9O for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:34:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3FDE49B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:17 -0500 (EST)
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

In order to be able to use the code located in virt/kvm/arm/hyp,
we need to make the global hyp.h file accessible from include/asm,
similar to what we did for arm64.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_hyp.h | 130 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/kvm/hyp/banked-sr.c   |   2 +-
 arch/arm/kvm/hyp/cp15-sr.c     |   2 +-
 arch/arm/kvm/hyp/hyp.h         | 130 -----------------------------------------
 arch/arm/kvm/hyp/s2-setup.c    |   3 +-
 arch/arm/kvm/hyp/switch.c      |   2 +-
 arch/arm/kvm/hyp/timer-sr.c    |   4 +-
 arch/arm/kvm/hyp/tlb.c         |   2 +-
 arch/arm/kvm/hyp/vgic-v2-sr.c  |   4 +-
 9 files changed, 137 insertions(+), 142 deletions(-)
 create mode 100644 arch/arm/include/asm/kvm_hyp.h
 delete mode 100644 arch/arm/kvm/hyp/hyp.h

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
new file mode 100644
index 0000000..ff6de6a
--- /dev/null
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -0,0 +1,130 @@
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
+#ifndef __ARM_KVM_HYP_H__
+#define __ARM_KVM_HYP_H__
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_mmu.h>
+#include <asm/vfp.h>
+
+#define __hyp_text __section(.hyp.text) notrace
+
+#define kern_hyp_va(v) (v)
+#define hyp_kern_va(v) (v)
+
+#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
+	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
+#define __ACCESS_CP15_64(Op1, CRm)		\
+	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
+#define __ACCESS_VFP(CRn)			\
+	"mrc", "mcr", __stringify(p10, 7, %0, CRn, cr0, 0), u32
+
+#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
+#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
+
+#define __read_sysreg(r, w, c, t) ({				\
+	t __val;						\
+	asm volatile(r " " c : "=r" (__val));			\
+	__val;							\
+})
+#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
+
+#define write_special(v, r)					\
+	asm volatile("msr " __stringify(r) ", %0" : : "r" (v))
+#define read_special(r) ({					\
+	u32 __val;						\
+	asm volatile("mrs %0, " __stringify(r) : "=r" (__val));	\
+	__val;							\
+})
+
+#define TTBR0		__ACCESS_CP15_64(0, c2)
+#define TTBR1		__ACCESS_CP15_64(1, c2)
+#define VTTBR		__ACCESS_CP15_64(6, c2)
+#define PAR		__ACCESS_CP15_64(0, c7)
+#define CNTV_CVAL	__ACCESS_CP15_64(3, c14)
+#define CNTVOFF		__ACCESS_CP15_64(4, c14)
+
+#define MIDR		__ACCESS_CP15(c0, 0, c0, 0)
+#define CSSELR		__ACCESS_CP15(c0, 2, c0, 0)
+#define VPIDR		__ACCESS_CP15(c0, 4, c0, 0)
+#define VMPIDR		__ACCESS_CP15(c0, 4, c0, 5)
+#define SCTLR		__ACCESS_CP15(c1, 0, c0, 0)
+#define CPACR		__ACCESS_CP15(c1, 0, c0, 2)
+#define HCR		__ACCESS_CP15(c1, 4, c1, 0)
+#define HDCR		__ACCESS_CP15(c1, 4, c1, 1)
+#define HCPTR		__ACCESS_CP15(c1, 4, c1, 2)
+#define HSTR		__ACCESS_CP15(c1, 4, c1, 3)
+#define TTBCR		__ACCESS_CP15(c2, 0, c0, 2)
+#define HTCR		__ACCESS_CP15(c2, 4, c0, 2)
+#define VTCR		__ACCESS_CP15(c2, 4, c1, 2)
+#define DACR		__ACCESS_CP15(c3, 0, c0, 0)
+#define DFSR		__ACCESS_CP15(c5, 0, c0, 0)
+#define IFSR		__ACCESS_CP15(c5, 0, c0, 1)
+#define ADFSR		__ACCESS_CP15(c5, 0, c1, 0)
+#define AIFSR		__ACCESS_CP15(c5, 0, c1, 1)
+#define HSR		__ACCESS_CP15(c5, 4, c2, 0)
+#define DFAR		__ACCESS_CP15(c6, 0, c0, 0)
+#define IFAR		__ACCESS_CP15(c6, 0, c0, 2)
+#define HDFAR		__ACCESS_CP15(c6, 4, c0, 0)
+#define HIFAR		__ACCESS_CP15(c6, 4, c0, 2)
+#define HPFAR		__ACCESS_CP15(c6, 4, c0, 4)
+#define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
+#define ATS1CPR		__ACCESS_CP15(c7, 0, c8, 0)
+#define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
+#define TLBIALLNSNHIS	__ACCESS_CP15(c8, 4, c3, 4)
+#define PRRR		__ACCESS_CP15(c10, 0, c2, 0)
+#define NMRR		__ACCESS_CP15(c10, 0, c2, 1)
+#define AMAIR0		__ACCESS_CP15(c10, 0, c3, 0)
+#define AMAIR1		__ACCESS_CP15(c10, 0, c3, 1)
+#define VBAR		__ACCESS_CP15(c12, 0, c0, 0)
+#define CID		__ACCESS_CP15(c13, 0, c0, 1)
+#define TID_URW		__ACCESS_CP15(c13, 0, c0, 2)
+#define TID_URO		__ACCESS_CP15(c13, 0, c0, 3)
+#define TID_PRIV	__ACCESS_CP15(c13, 0, c0, 4)
+#define HTPIDR		__ACCESS_CP15(c13, 4, c0, 2)
+#define CNTKCTL		__ACCESS_CP15(c14, 0, c1, 0)
+#define CNTV_CTL	__ACCESS_CP15(c14, 0, c3, 1)
+#define CNTHCTL		__ACCESS_CP15(c14, 4, c1, 0)
+
+#define VFP_FPEXC	__ACCESS_VFP(FPEXC)
+
+void __timer_save_state(struct kvm_vcpu *vcpu);
+void __timer_restore_state(struct kvm_vcpu *vcpu);
+
+void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
+void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
+
+void __sysreg_save_state(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
+
+void asmlinkage __vfp_save_state(struct vfp_hard_struct *vfp);
+void asmlinkage __vfp_restore_state(struct vfp_hard_struct *vfp);
+static inline bool __vfp_enabled(void)
+{
+	return !(read_sysreg(HCPTR) & (HCPTR_TCP(11) | HCPTR_TCP(10)));
+}
+
+void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt);
+void __hyp_text __banked_restore_state(struct kvm_cpu_context *ctxt);
+
+int asmlinkage __guest_enter(struct kvm_vcpu *vcpu,
+			     struct kvm_cpu_context *host);
+int asmlinkage __hyp_do_panic(const char *, int, u32);
+
+#endif /* __ARM_KVM_HYP_H__ */
diff --git a/arch/arm/kvm/hyp/banked-sr.c b/arch/arm/kvm/hyp/banked-sr.c
index d02dc80..111bda8 100644
--- a/arch/arm/kvm/hyp/banked-sr.c
+++ b/arch/arm/kvm/hyp/banked-sr.c
@@ -18,7 +18,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 __asm__(".arch_extension     virt");
 
diff --git a/arch/arm/kvm/hyp/cp15-sr.c b/arch/arm/kvm/hyp/cp15-sr.c
index 732abbc..c478281 100644
--- a/arch/arm/kvm/hyp/cp15-sr.c
+++ b/arch/arm/kvm/hyp/cp15-sr.c
@@ -18,7 +18,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 static u64 *cp15_64(struct kvm_cpu_context *ctxt, int idx)
 {
diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
deleted file mode 100644
index ff6de6a..0000000
--- a/arch/arm/kvm/hyp/hyp.h
+++ /dev/null
@@ -1,130 +0,0 @@
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
-#ifndef __ARM_KVM_HYP_H__
-#define __ARM_KVM_HYP_H__
-
-#include <linux/compiler.h>
-#include <linux/kvm_host.h>
-#include <asm/kvm_mmu.h>
-#include <asm/vfp.h>
-
-#define __hyp_text __section(.hyp.text) notrace
-
-#define kern_hyp_va(v) (v)
-#define hyp_kern_va(v) (v)
-
-#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
-	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
-#define __ACCESS_CP15_64(Op1, CRm)		\
-	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
-#define __ACCESS_VFP(CRn)			\
-	"mrc", "mcr", __stringify(p10, 7, %0, CRn, cr0, 0), u32
-
-#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
-#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
-
-#define __read_sysreg(r, w, c, t) ({				\
-	t __val;						\
-	asm volatile(r " " c : "=r" (__val));			\
-	__val;							\
-})
-#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
-
-#define write_special(v, r)					\
-	asm volatile("msr " __stringify(r) ", %0" : : "r" (v))
-#define read_special(r) ({					\
-	u32 __val;						\
-	asm volatile("mrs %0, " __stringify(r) : "=r" (__val));	\
-	__val;							\
-})
-
-#define TTBR0		__ACCESS_CP15_64(0, c2)
-#define TTBR1		__ACCESS_CP15_64(1, c2)
-#define VTTBR		__ACCESS_CP15_64(6, c2)
-#define PAR		__ACCESS_CP15_64(0, c7)
-#define CNTV_CVAL	__ACCESS_CP15_64(3, c14)
-#define CNTVOFF		__ACCESS_CP15_64(4, c14)
-
-#define MIDR		__ACCESS_CP15(c0, 0, c0, 0)
-#define CSSELR		__ACCESS_CP15(c0, 2, c0, 0)
-#define VPIDR		__ACCESS_CP15(c0, 4, c0, 0)
-#define VMPIDR		__ACCESS_CP15(c0, 4, c0, 5)
-#define SCTLR		__ACCESS_CP15(c1, 0, c0, 0)
-#define CPACR		__ACCESS_CP15(c1, 0, c0, 2)
-#define HCR		__ACCESS_CP15(c1, 4, c1, 0)
-#define HDCR		__ACCESS_CP15(c1, 4, c1, 1)
-#define HCPTR		__ACCESS_CP15(c1, 4, c1, 2)
-#define HSTR		__ACCESS_CP15(c1, 4, c1, 3)
-#define TTBCR		__ACCESS_CP15(c2, 0, c0, 2)
-#define HTCR		__ACCESS_CP15(c2, 4, c0, 2)
-#define VTCR		__ACCESS_CP15(c2, 4, c1, 2)
-#define DACR		__ACCESS_CP15(c3, 0, c0, 0)
-#define DFSR		__ACCESS_CP15(c5, 0, c0, 0)
-#define IFSR		__ACCESS_CP15(c5, 0, c0, 1)
-#define ADFSR		__ACCESS_CP15(c5, 0, c1, 0)
-#define AIFSR		__ACCESS_CP15(c5, 0, c1, 1)
-#define HSR		__ACCESS_CP15(c5, 4, c2, 0)
-#define DFAR		__ACCESS_CP15(c6, 0, c0, 0)
-#define IFAR		__ACCESS_CP15(c6, 0, c0, 2)
-#define HDFAR		__ACCESS_CP15(c6, 4, c0, 0)
-#define HIFAR		__ACCESS_CP15(c6, 4, c0, 2)
-#define HPFAR		__ACCESS_CP15(c6, 4, c0, 4)
-#define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
-#define ATS1CPR		__ACCESS_CP15(c7, 0, c8, 0)
-#define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
-#define TLBIALLNSNHIS	__ACCESS_CP15(c8, 4, c3, 4)
-#define PRRR		__ACCESS_CP15(c10, 0, c2, 0)
-#define NMRR		__ACCESS_CP15(c10, 0, c2, 1)
-#define AMAIR0		__ACCESS_CP15(c10, 0, c3, 0)
-#define AMAIR1		__ACCESS_CP15(c10, 0, c3, 1)
-#define VBAR		__ACCESS_CP15(c12, 0, c0, 0)
-#define CID		__ACCESS_CP15(c13, 0, c0, 1)
-#define TID_URW		__ACCESS_CP15(c13, 0, c0, 2)
-#define TID_URO		__ACCESS_CP15(c13, 0, c0, 3)
-#define TID_PRIV	__ACCESS_CP15(c13, 0, c0, 4)
-#define HTPIDR		__ACCESS_CP15(c13, 4, c0, 2)
-#define CNTKCTL		__ACCESS_CP15(c14, 0, c1, 0)
-#define CNTV_CTL	__ACCESS_CP15(c14, 0, c3, 1)
-#define CNTHCTL		__ACCESS_CP15(c14, 4, c1, 0)
-
-#define VFP_FPEXC	__ACCESS_VFP(FPEXC)
-
-void __timer_save_state(struct kvm_vcpu *vcpu);
-void __timer_restore_state(struct kvm_vcpu *vcpu);
-
-void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
-void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
-
-void __sysreg_save_state(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
-
-void asmlinkage __vfp_save_state(struct vfp_hard_struct *vfp);
-void asmlinkage __vfp_restore_state(struct vfp_hard_struct *vfp);
-static inline bool __vfp_enabled(void)
-{
-	return !(read_sysreg(HCPTR) & (HCPTR_TCP(11) | HCPTR_TCP(10)));
-}
-
-void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt);
-void __hyp_text __banked_restore_state(struct kvm_cpu_context *ctxt);
-
-int asmlinkage __guest_enter(struct kvm_vcpu *vcpu,
-			     struct kvm_cpu_context *host);
-int asmlinkage __hyp_do_panic(const char *, int, u32);
-
-#endif /* __ARM_KVM_HYP_H__ */
diff --git a/arch/arm/kvm/hyp/s2-setup.c b/arch/arm/kvm/hyp/s2-setup.c
index f5f49c5..7be39af 100644
--- a/arch/arm/kvm/hyp/s2-setup.c
+++ b/arch/arm/kvm/hyp/s2-setup.c
@@ -18,8 +18,7 @@
 #include <linux/types.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 void __hyp_text __init_stage2_translation(void)
 {
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index f11ede1..b13caa9 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -16,7 +16,7 @@
  */
 
 #include <asm/kvm_asm.h>
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 __asm__(".arch_extension     virt");
 
diff --git a/arch/arm/kvm/hyp/timer-sr.c b/arch/arm/kvm/hyp/timer-sr.c
index d7535fd..2bb0c92 100644
--- a/arch/arm/kvm/hyp/timer-sr.c
+++ b/arch/arm/kvm/hyp/timer-sr.c
@@ -19,9 +19,7 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 /* vcpu is already in the HYP VA space */
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index 82958b8..a263600 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -18,7 +18,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 /**
  * Flush per-VMID TLBs
diff --git a/arch/arm/kvm/hyp/vgic-v2-sr.c b/arch/arm/kvm/hyp/vgic-v2-sr.c
index e717612..9514a7d 100644
--- a/arch/arm/kvm/hyp/vgic-v2-sr.c
+++ b/arch/arm/kvm/hyp/vgic-v2-sr.c
@@ -19,9 +19,7 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm_host.h>
 
-#include <asm/kvm_mmu.h>
-
-#include "hyp.h"
+#include <asm/kvm_hyp.h>
 
 /* vcpu is already in the HYP VA space */
 void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
-- 
2.1.4
