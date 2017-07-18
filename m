From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 28/38] KVM: arm64: Emulate EL12 register accesses from the virtual EL2
Date: Tue, 18 Jul 2017 11:58:54 -0500
Message-ID: <1500397144-16232-29-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: corbet@lwn.net, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, daniel.lezcano@linaro.org, david.daney@cavium.com, mark.rutland@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, andy.gross@linaro.org, wcohen@redhat.com, ard.biesheuvel@linaro.org, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Jintack Lim <jintack.lim@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

With HCR_EL2.NV bit set, accesses to EL12 registers in the virtual EL2
trap to EL2. Handle those traps just like we do for EL1 registers.

One exception is CNTKCTL_EL12. We don't trap on CNTKCTL_EL1 for non-VHE
virtual EL2 because we don't have to. However, accessing CNTKCTL_EL12
will trap since it's one of the EL12 registers controlled by HCR_EL2.NV
bit.  Therefore, add a handler for it and don't treat it as a
non-trap-registers when preparing a shadow context.

Move EL12 system register macros to a common place to reuse them.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 24 ------------------------
 arch/arm64/include/asm/sysreg.h  | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/context.c         |  7 +++++++
 arch/arm64/kvm/sys_regs.c        | 25 +++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4572a9b..353b895 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -73,30 +73,6 @@
 #define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
 #define write_sysreg_el1(v,r)	write_sysreg_elx(v, r, _EL1, _EL12)
 
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
 /**
  * hyp_alternate_select - Generates patchable code sequences that are
  * used to switch between two implementations of a function, depending
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b01c608..b8d4d0c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -338,6 +338,30 @@
 #define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
 #define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
 
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
 #define SYS_SP_EL2			sys_reg(3, 6, 4, 1, 0)
 
 /* Common SCTLR_ELx flags. */
diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index e1bc753..f3d3398 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -121,6 +121,13 @@ static void copy_shadow_non_trap_el1_state(struct kvm_vcpu *vcpu, bool setup)
 	for (i = 0; i < ARRAY_SIZE(el1_non_trap_regs); i++) {
 		const int sr = el1_non_trap_regs[i];
 
+		/*
+		 * We trap on cntkctl_el12 accesses from virtual EL2 as suppose
+		 * to not trapping on cntlctl_el1 accesses.
+		 */
+		if (vcpu_el2_e2h_is_set(vcpu) && sr == CNTKCTL_EL1)
+			continue;
+
 		if (setup)
 			s_sys_regs[sr] = vcpu_sys_reg(vcpu, sr);
 		else
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b3e0cb8..2aa922c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -905,6 +905,14 @@ static inline void access_rw(struct sys_reg_params *p, u64 *sysreg)
 		*sysreg = p->regval;
 }
 
+static bool access_cntkctl_el12(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
+	return true;
+}
+
 static u64 *get_special_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
 {
 	u64 reg = sys_reg(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
@@ -1201,6 +1209,23 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
 	{ SYS_DESC(SYS_CNTVOFF_EL2), trap_el2_regs, reset_val, CNTVOFF_EL2, 0 },
 	{ SYS_DESC(SYS_CNTHCTL_EL2), trap_el2_regs, reset_val, CNTHCTL_EL2, 0 },
 
+	{ SYS_DESC(sctlr_EL12), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
+	{ SYS_DESC(cpacr_EL12), access_cpacr, reset_val, CPACR_EL1, 0 },
+	{ SYS_DESC(ttbr0_EL12), access_vm_reg, reset_unknown, TTBR0_EL1 },
+	{ SYS_DESC(ttbr1_EL12), access_vm_reg, reset_unknown, TTBR1_EL1 },
+	{ SYS_DESC(tcr_EL12), access_vm_reg, reset_val, TCR_EL1, 0 },
+	{ SYS_DESC(spsr_EL12), access_spsr},
+	{ SYS_DESC(elr_EL12), access_elr},
+	{ SYS_DESC(afsr0_EL12), access_vm_reg, reset_unknown, AFSR0_EL1 },
+	{ SYS_DESC(afsr1_EL12), access_vm_reg, reset_unknown, AFSR1_EL1 },
+	{ SYS_DESC(esr_EL12), access_vm_reg, reset_unknown, ESR_EL1 },
+	{ SYS_DESC(far_EL12), access_vm_reg, reset_unknown, FAR_EL1 },
+	{ SYS_DESC(mair_EL12), access_vm_reg, reset_unknown, MAIR_EL1 },
+	{ SYS_DESC(amair_EL12), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
+	{ SYS_DESC(vbar_EL12), access_vbar, reset_val, VBAR_EL1, 0 },
+	{ SYS_DESC(contextidr_EL12), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
+	{ SYS_DESC(cntkctl_EL12), access_cntkctl_el12, reset_val, CNTKCTL_EL1, 0 },
+
 	{ SYS_DESC(SYS_SP_EL2), NULL, reset_special, SP_EL2, 0},
 };
 
-- 
1.9.1
