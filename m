From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 07/38] KVM: arm64: Add EL2 system registers to vcpu
 context
Date: Tue, 18 Jul 2017 11:58:33 -0500
Message-ID: <1500397144-16232-8-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8737049C0A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HFUUSvXBiF4A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:58:58 -0400 (EDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com
 [209.85.223.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56D8649C1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:58 -0400 (EDT)
Received: by mail-io0-f170.google.com with SMTP id 5so16498484iow.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:59:47 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

ARM v8.3 introduces a new bit in the HCR_EL2, which is the NV bit. When
this bit is set, accessing EL2 registers in EL1 traps to EL2. In
addition, executing the following instructions in EL1 will trap to EL2:
tlbi, at, eret, and msr/mrs instructions to access SP_EL1. Most of the
instructions that trap to EL2 with the NV bit were undef at EL1 prior to
ARM v8.3. The only instruction that was not undef is eret.

This patch sets up a handler for EL2 registers and SP_EL1 register
accesses at EL1. The host hypervisor keeps those register values in
memory, and will emulate their behavior.

This patch doesn't set the NV bit yet. It will be set in a later patch
once nested virtualization support is completed.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h | 30 +++++++++++++++++++-
 arch/arm64/include/asm/sysreg.h   | 37 +++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         | 58 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 86d4b6c..1dc4ed6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -134,12 +134,40 @@ enum vcpu_sysreg {
 	PMSWINC_EL0,	/* Software Increment Register */
 	PMUSERENR_EL0,	/* User Enable Register */
 
-	/* 32bit specific registers. Keep them at the end of the range */
+	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
 	FPEXC32_EL2,	/* Floating-Point Exception Control Register */
 	DBGVCR32_EL2,	/* Debug Vector Catch Register */
 
+	/* EL2 registers sorted ascending by Op0, Op1, CRn, CRm, Op2 */
+	VPIDR_EL2,	/* Virtualization Processor ID Register */
+	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
+	SCTLR_EL2,	/* System Control Register (EL2) */
+	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
+	HCR_EL2,	/* Hypervisor Configuration Register */
+	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
+	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
+	HSTR_EL2,	/* Hypervisor System Trap Register */
+	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
+	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
+	TCR_EL2,	/* Translation Control Register (EL2) */
+	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
+	VTCR_EL2,	/* Virtualization Translation Control Register */
+	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
+	AFSR1_EL2,	/* Auxiliary Fault Status Register 1 (EL2) */
+	ESR_EL2,	/* Exception Syndrome Register (EL2) */
+	FAR_EL2,	/* Hypervisor IPA Fault Address Register */
+	HPFAR_EL2,	/* Hypervisor IPA Fault Address Register */
+	MAIR_EL2,	/* Memory Attribute Indirection Register (EL2) */
+	AMAIR_EL2,	/* Auxiliary Memory Attribute Indirection Register (EL2) */
+	VBAR_EL2,	/* Vector Base Address Register (EL2) */
+	RVBAR_EL2,	/* Reset Vector Base Address Register */
+	RMR_EL2,	/* Reset Management Register */
+	TPIDR_EL2,	/* EL2 Software Thread ID Register */
+	CNTVOFF_EL2,	/* Counter-timer Virtual Offset register */
+	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 737ca30..9277c4a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -250,10 +250,42 @@
 
 #define SYS_PMCCFILTR_EL0		sys_reg (3, 3, 14, 15, 7)
 
+#define SYS_VPIDR_EL2			sys_reg(3, 4, 0, 0, 0)
+#define SYS_VMPIDR_EL2			sys_reg(3, 4, 0, 0, 5)
+
+#define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
+#define SYS_ACTLR_EL2			sys_reg(3, 4, 1, 0, 1)
+#define SYS_HCR_EL2			sys_reg(3, 4, 1, 1, 0)
+#define SYS_MDCR_EL2			sys_reg(3, 4, 1, 1, 1)
+#define SYS_CPTR_EL2			sys_reg(3, 4, 1, 1, 2)
+#define SYS_HSTR_EL2			sys_reg(3, 4, 1, 1, 3)
+#define SYS_HACR_EL2			sys_reg(3, 4, 1, 1, 7)
+
+#define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
+#define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
+#define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
+#define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
+
 #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
+
+#define SYS_SP_EL1			sys_reg(3, 4, 4, 1, 0)
+
 #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
+#define SYS_AFSR0_EL2			sys_reg(3, 4, 5, 1, 0)
+#define SYS_AFSR1_EL2			sys_reg(3, 4, 5, 1, 1)
+#define SYS_ESR_EL2			sys_reg(3, 4, 5, 2, 0)
 #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
 
+#define SYS_FAR_EL2			sys_reg(3, 4, 6, 0, 0)
+#define SYS_HPFAR_EL2			sys_reg(3, 4, 6, 0, 4)
+
+#define SYS_MAIR_EL2			sys_reg(3, 4, 10, 2, 0)
+#define SYS_AMAIR_EL2			sys_reg(3, 4, 10, 3, 0)
+
+#define SYS_VBAR_EL2			sys_reg(3, 4, 12, 0, 0)
+#define SYS_RVBAR_EL2			sys_reg(3, 4, 12, 0, 1)
+#define SYS_RMR_EL2			sys_reg(3, 4, 12, 0, 2)
+
 #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
 #define SYS_ICH_AP0R0_EL2		__SYS__AP0Rx_EL2(0)
 #define SYS_ICH_AP0R1_EL2		__SYS__AP0Rx_EL2(1)
@@ -295,6 +327,11 @@
 #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
+#define SYS_TPIDR_EL2			sys_reg(3, 4, 13, 0, 2)
+
+#define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
+#define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
 #define SCTLR_ELx_I	(1 << 12)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7786288..1568f8b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -892,6 +892,27 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static inline void access_rw(struct sys_reg_params *p, u64 *sysreg)
+{
+	if (!p->is_write)
+		p->regval = *sysreg;
+	else
+		*sysreg = p->regval;
+}
+
+static bool trap_el2_regs(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	/* SP_EL1 is NOT maintained in sys_regs array */
+	if (sys_reg(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2) == SYS_SP_EL1)
+		access_rw(p, &vcpu->arch.ctxt.gp_regs.sp_el1);
+	else
+		access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
+
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -1077,9 +1098,46 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 	 */
 	{ SYS_DESC(SYS_PMCCFILTR_EL0), access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
 
+	{ SYS_DESC(SYS_VPIDR_EL2), trap_el2_regs, reset_val, VPIDR_EL2, 0 },
+	{ SYS_DESC(SYS_VMPIDR_EL2), trap_el2_regs, reset_val, VMPIDR_EL2, 0 },
+
+	{ SYS_DESC(SYS_SCTLR_EL2), trap_el2_regs, reset_val, SCTLR_EL2, 0 },
+	{ SYS_DESC(SYS_ACTLR_EL2), trap_el2_regs, reset_val, ACTLR_EL2, 0 },
+	{ SYS_DESC(SYS_HCR_EL2), trap_el2_regs, reset_val, HCR_EL2, 0 },
+	{ SYS_DESC(SYS_MDCR_EL2), trap_el2_regs, reset_val, MDCR_EL2, 0 },
+	{ SYS_DESC(SYS_CPTR_EL2), trap_el2_regs, reset_val, CPTR_EL2, 0 },
+	{ SYS_DESC(SYS_HSTR_EL2), trap_el2_regs, reset_val, HSTR_EL2, 0 },
+	{ SYS_DESC(SYS_HACR_EL2), trap_el2_regs, reset_val, HACR_EL2, 0 },
+
+	{ SYS_DESC(SYS_TTBR0_EL2), trap_el2_regs, reset_val, TTBR0_EL2, 0 },
+	{ SYS_DESC(SYS_TCR_EL2), trap_el2_regs, reset_val, TCR_EL2, 0 },
+	{ SYS_DESC(SYS_VTTBR_EL2), trap_el2_regs, reset_val, VTTBR_EL2, 0 },
+	{ SYS_DESC(SYS_VTCR_EL2), trap_el2_regs, reset_val, VTCR_EL2, 0 },
+
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
+
+	{ SYS_DESC(SYS_SP_EL1), trap_el2_regs },
+
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
+	{ SYS_DESC(SYS_AFSR0_EL2), trap_el2_regs, reset_val, AFSR0_EL2, 0 },
+	{ SYS_DESC(SYS_AFSR1_EL2), trap_el2_regs, reset_val, AFSR1_EL2, 0 },
+	{ SYS_DESC(SYS_ESR_EL2), trap_el2_regs, reset_val, ESR_EL2, 0 },
 	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x70 },
+
+	{ SYS_DESC(SYS_FAR_EL2), trap_el2_regs, reset_val, FAR_EL2, 0 },
+	{ SYS_DESC(SYS_HPFAR_EL2), trap_el2_regs, reset_val, HPFAR_EL2, 0 },
+
+	{ SYS_DESC(SYS_MAIR_EL2), trap_el2_regs, reset_val, MAIR_EL2, 0 },
+	{ SYS_DESC(SYS_AMAIR_EL2), trap_el2_regs, reset_val, AMAIR_EL2, 0 },
+
+	{ SYS_DESC(SYS_VBAR_EL2), trap_el2_regs, reset_val, VBAR_EL2, 0 },
+	{ SYS_DESC(SYS_RVBAR_EL2), trap_el2_regs, reset_val, RVBAR_EL2, 0 },
+	{ SYS_DESC(SYS_RMR_EL2), trap_el2_regs, reset_val, RMR_EL2, 0 },
+
+	{ SYS_DESC(SYS_TPIDR_EL2), trap_el2_regs, reset_val, TPIDR_EL2, 0 },
+
+	{ SYS_DESC(SYS_CNTVOFF_EL2), trap_el2_regs, reset_val, CNTVOFF_EL2, 0 },
+	{ SYS_DESC(SYS_CNTHCTL_EL2), trap_el2_regs, reset_val, CNTHCTL_EL2, 0 },
 };
 
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
-- 
1.9.1
