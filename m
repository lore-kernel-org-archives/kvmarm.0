From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 13/95] ARM: KVM: Add VFP save/restore
Date: Wed,  9 Mar 2016 07:30:07 +0000
Message-ID: <1457508689-19672-14-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6967D49AFA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9MOZXSQKb3iF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:32:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C64CB412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:22 -0500 (EST)
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

This is almost a copy/paste of the existing version, with a couple
of subtle differences:
- Only write to FPEXC once on the save path
- Add an isb when enabling VFP access

The patch also defines a few sysreg accessors and a __vfp_enabled
predicate that test the VFP trapping state.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/Makefile |  1 +
 arch/arm/kvm/hyp/hyp.h    | 13 +++++++++
 arch/arm/kvm/hyp/vfp.S    | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)
 create mode 100644 arch/arm/kvm/hyp/vfp.S

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index d8acbb6..5a45f4c 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += cp15-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
index 7eb1c21..dce0f73 100644
--- a/arch/arm/kvm/hyp/hyp.h
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -21,6 +21,7 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
+#include <asm/vfp.h>
 
 #define __hyp_text __section(.hyp.text) notrace
 
@@ -31,6 +32,8 @@
 	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
 #define __ACCESS_CP15_64(Op1, CRm)		\
 	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
+#define __ACCESS_VFP(CRn)			\
+	"mrc", "mcr", __stringify(p10, 7, %0, CRn, cr0, 0), u32
 
 #define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
 #define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
@@ -53,6 +56,7 @@
 #define VMPIDR		__ACCESS_CP15(c0, 4, c0, 5)
 #define SCTLR		__ACCESS_CP15(c1, 0, c0, 0)
 #define CPACR		__ACCESS_CP15(c1, 0, c0, 2)
+#define HCPTR		__ACCESS_CP15(c1, 4, c1, 2)
 #define TTBCR		__ACCESS_CP15(c2, 0, c0, 2)
 #define DACR		__ACCESS_CP15(c3, 0, c0, 0)
 #define DFSR		__ACCESS_CP15(c5, 0, c0, 0)
@@ -77,6 +81,8 @@
 #define CNTV_CTL	__ACCESS_CP15(c14, 0, c3, 1)
 #define CNTHCTL		__ACCESS_CP15(c14, 4, c1, 0)
 
+#define VFP_FPEXC	__ACCESS_VFP(FPEXC)
+
 void __timer_save_state(struct kvm_vcpu *vcpu);
 void __timer_restore_state(struct kvm_vcpu *vcpu);
 
@@ -86,4 +92,11 @@ void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 void __sysreg_save_state(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 
+void asmlinkage __vfp_save_state(struct vfp_hard_struct *vfp);
+void asmlinkage __vfp_restore_state(struct vfp_hard_struct *vfp);
+static inline bool __vfp_enabled(void)
+{
+	return !(read_sysreg(HCPTR) & (HCPTR_TCP(11) | HCPTR_TCP(10)));
+}
+
 #endif /* __ARM_KVM_HYP_H__ */
diff --git a/arch/arm/kvm/hyp/vfp.S b/arch/arm/kvm/hyp/vfp.S
new file mode 100644
index 0000000..7c297e8
--- /dev/null
+++ b/arch/arm/kvm/hyp/vfp.S
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2012 - Virtual Open Systems and Columbia University
+ * Author: Christoffer Dall <c.dall@virtualopensystems.com>
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
+#include <linux/linkage.h>
+#include <asm/vfpmacros.h>
+
+	.text
+	.pushsection	.hyp.text, "ax"
+
+/* void __vfp_save_state(struct vfp_hard_struct *vfp); */
+ENTRY(__vfp_save_state)
+	push	{r4, r5}
+	VFPFMRX	r1, FPEXC
+
+	@ Make sure *really* VFP is enabled so we can touch the registers.
+	orr	r5, r1, #FPEXC_EN
+	tst	r5, #FPEXC_EX		@ Check for VFP Subarchitecture
+	bic	r5, r5, #FPEXC_EX	@ FPEXC_EX disable
+	VFPFMXR	FPEXC, r5
+	isb
+
+	VFPFMRX	r2, FPSCR
+	beq	1f
+
+	@ If FPEXC_EX is 0, then FPINST/FPINST2 reads are upredictable, so
+	@ we only need to save them if FPEXC_EX is set.
+	VFPFMRX r3, FPINST
+	tst	r5, #FPEXC_FP2V
+	VFPFMRX r4, FPINST2, ne		@ vmrsne
+1:
+	VFPFSTMIA r0, r5		@ Save VFP registers
+	stm	r0, {r1-r4}		@ Save FPEXC, FPSCR, FPINST, FPINST2
+	pop	{r4, r5}
+	bx	lr
+ENDPROC(__vfp_save_state)
+
+/* void __vfp_restore_state(struct vfp_hard_struct *vfp);
+ * Assume FPEXC_EN is on and FPEXC_EX is off */
+ENTRY(__vfp_restore_state)
+	VFPFLDMIA r0, r1		@ Load VFP registers
+	ldm	r0, {r0-r3}		@ Load FPEXC, FPSCR, FPINST, FPINST2
+
+	VFPFMXR FPSCR, r1
+	tst	r0, #FPEXC_EX		@ Check for VFP Subarchitecture
+	beq	1f
+	VFPFMXR FPINST, r2
+	tst	r0, #FPEXC_FP2V
+	VFPFMXR FPINST2, r3, ne
+1:
+	VFPFMXR FPEXC, r0		@ FPEXC	(last, in case !EN)
+	bx	lr
+ENDPROC(__vfp_restore_state)
+
+	.popsection
-- 
2.1.4
