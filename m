From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 12/21] arm64: KVM: Implement fpsimd save/restore
Date: Fri, 27 Nov 2015 18:50:06 +0000
Message-ID: <1448650215-15218-13-git-send-email-marc.zyngier@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF1F3496C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BeUpYkd9yRrO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2015 13:49:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98B9741390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:42 -0500 (EST)
In-Reply-To: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Implement the fpsimd save restore, keeping the lazy part in
assembler (as returning to C would be overkill).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/Makefile    |  1 +
 arch/arm64/kvm/hyp/entry.S     | 32 +++++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/fpsimd.S    | 33 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/hyp.h       |  7 +++++++
 arch/arm64/kvm/hyp/switch.c    |  8 ++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c |  2 +-
 6 files changed, 81 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/fpsimd.S

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 9c11b0f..56238d0 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += switch.o
+obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 2c4449a..7552922 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -27,6 +27,7 @@
 
 #define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
 #define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
+#define CPU_SYSREG_OFFSET(x)	(CPU_SYSREGS + 8*x)
 
 	.text
 	.pushsection	.hyp.text, "ax"
@@ -152,4 +153,33 @@ ENTRY(__guest_exit)
 	ret
 ENDPROC(__guest_exit)
 
-	/* Insert fault handling here */
+ENTRY(__fpsimd_guest_restore)
+	push	x4, lr
+
+	mrs	x2, cptr_el2
+	bic	x2, x2, #CPTR_EL2_TFP
+	msr	cptr_el2, x2
+	isb
+
+	mrs	x3, tpidr_el2
+
+	ldr	x0, [x3, #VCPU_HOST_CONTEXT]
+	kern_hyp_va x0
+	add	x0, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
+	bl	__fpsimd_save_state
+
+	add	x2, x3, #VCPU_CONTEXT
+	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
+	bl	__fpsimd_restore_state
+
+	mrs	x1, hcr_el2
+	tbnz	x1, #HCR_RW_SHIFT, 1f
+	ldr	x4, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
+	msr	fpexc32_el2, x4
+1:
+	pop	x4, lr
+	pop	x2, x3
+	pop	x0, x1
+
+	eret
+ENDPROC(__fpsimd_guest_restore)
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
new file mode 100644
index 0000000..da3f22c
--- /dev/null
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -0,0 +1,33 @@
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
+#include <linux/linkage.h>
+
+#include <asm/fpsimdmacros.h>
+
+	.text
+	.pushsection	.hyp.text, "ax"
+
+ENTRY(__fpsimd_save_state)
+	fpsimd_save	x0, 1
+	ret
+ENDPROC(__fpsimd_save_state)
+
+ENTRY(__fpsimd_restore_state)
+	fpsimd_restore	x0, 1
+	ret
+ENDPROC(__fpsimd_restore_state)
diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index f0427ee..18365dd 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -66,6 +66,13 @@ void __debug_restore_state(struct kvm_vcpu *vcpu,
 void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
 void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
 
+void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
+void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
+static inline bool __fpsimd_enabled(void)
+{
+	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
+}
+
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d67ed9e..8affc19 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -88,6 +88,7 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
+	bool fp_enabled;
 	u64 exit_code;
 
 	vcpu = kern_hyp_va(vcpu);
@@ -117,6 +118,8 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 	exit_code = __guest_enter(vcpu, host_ctxt);
 	/* And we're baaack! */
 
+	fp_enabled = __fpsimd_enabled();
+
 	__sysreg_save_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_save_state(vcpu);
@@ -127,6 +130,11 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state(host_ctxt);
 
+	if (fp_enabled) {
+		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
+		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
+	}
+
 	__debug_save_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
 	__debug_cond_restore_host_state(vcpu);
 
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 3f81a4d..41b9d30 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -103,7 +103,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 		sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
 		sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
 
-		if (!(read_sysreg(cptr_el2) & CPTR_EL2_TFP))
+		if (__fpsimd_enabled())
 			sysreg[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
 
 		if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
-- 
2.1.4
