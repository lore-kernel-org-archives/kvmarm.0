From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 29/41] KVM: arm64: Defer saving/restoring 64-bit sysregs to vcpu load/put on VHE
Date: Fri, 12 Jan 2018 13:07:35 +0100
Message-ID: <20180112120747.27999-30-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Some system registers do not affect the host kernel's execution and can
therefore be loaded when we are about to run a VCPU and we don't have to
restore the host state to the hardware before the time when we are
actually about to return to userspace or schedule out the VCPU thread.

The EL1 system registers and the userspace state registers only
affecting EL0 execution do not need to be saved and restored on every
switch between the VM and the host, because they don't affect the host
kernel's execution.

We mark all registers which are now deffered as such in the
declarations in sys-regs.c to ensure the most up-to-date copy is always
accessed.

Note MPIDR_EL1 (controlled via VMPIDR_EL2) is accessed from other vcpu
threads, for example via the GIC emulation, and therefore must be
declared as immediate, which is fine as the guest cannot modify this
value.

The 32-bit sysregs can also be deferred but we do this in a separate
patch as it requires a bit more infrastructure.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 37 +++++++++++++++++++++++++++++--------
 arch/arm64/kvm/sys_regs.c      | 40 ++++++++++++++++++++--------------------
 2 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 1f2d5e9343b0..eabd35154232 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -25,8 +25,12 @@
 /*
  * Non-VHE: Both host and guest must save everything.
  *
- * VHE: Host must save tpidr*_el0, actlr_el1, mdscr_el1, sp_el0,
- * and guest must save everything.
+ * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and pstate,
+ * which are handled as part of the el2 return state) on every switch.
+ * tpidr_el0, tpidrro_el0, and actlr_el1 only need to be switched when going
+ * to host userspace or a different VCPU.  EL1 registers only need to be
+ * switched when potentially going to run a different VCPU.  The latter two
+ * classes are handled as part of kvm_arch_vcpu_load and kvm_arch_vcpu_put.
  */
 
 static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
@@ -90,14 +94,11 @@ void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_save_common_state(ctxt);
-	__sysreg_save_user_state(ctxt);
 }
 
 void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
-	__sysreg_save_user_state(ctxt);
 	__sysreg_save_el2_return_state(ctxt);
 }
 
@@ -163,14 +164,11 @@ void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_restore_common_state(ctxt);
-	__sysreg_restore_user_state(ctxt);
 }
 
 void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
-	__sysreg_restore_user_state(ctxt);
 	__sysreg_restore_el2_return_state(ctxt);
 }
 
@@ -236,6 +234,18 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+
+	if (!has_vhe())
+		return;
+
+	__sysreg_save_user_state(host_ctxt);
+
+	__sysreg_restore_user_state(guest_ctxt);
+	__sysreg_restore_el1_state(guest_ctxt);
+
+	vcpu->arch.sysregs_loaded_on_cpu = true;
 }
 
 /**
@@ -264,6 +274,17 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
 		vcpu->arch.guest_vfp_loaded = 0;
 	}
+
+	if (!has_vhe())
+		return;
+
+	__sysreg_save_el1_state(guest_ctxt);
+	__sysreg_save_user_state(guest_ctxt);
+
+	/* Restore host user state */
+	__sysreg_restore_user_state(host_ctxt);
+
+	vcpu->arch.sysregs_loaded_on_cpu = false;
 }
 
 void __hyp_text __kvm_set_tpidr_el2(u64 tpidr_el2)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9d353a6a55c9..8df651a8a36c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -140,26 +140,26 @@ static void __default_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
 
 /* Ordered as in enum vcpu_sysreg */
 DECLARE_IMMEDIATE_SR(MPIDR_EL1);
-DECLARE_IMMEDIATE_SR(CSSELR_EL1);
-DECLARE_IMMEDIATE_SR(SCTLR_EL1);
-DECLARE_IMMEDIATE_SR(ACTLR_EL1);
-DECLARE_IMMEDIATE_SR(CPACR_EL1);
-DECLARE_IMMEDIATE_SR(TTBR0_EL1);
-DECLARE_IMMEDIATE_SR(TTBR1_EL1);
-DECLARE_IMMEDIATE_SR(TCR_EL1);
-DECLARE_IMMEDIATE_SR(ESR_EL1);
-DECLARE_IMMEDIATE_SR(AFSR0_EL1);
-DECLARE_IMMEDIATE_SR(AFSR1_EL1);
-DECLARE_IMMEDIATE_SR(FAR_EL1);
-DECLARE_IMMEDIATE_SR(MAIR_EL1);
-DECLARE_IMMEDIATE_SR(VBAR_EL1);
-DECLARE_IMMEDIATE_SR(CONTEXTIDR_EL1);
-DECLARE_IMMEDIATE_SR(TPIDR_EL0);
-DECLARE_IMMEDIATE_SR(TPIDRRO_EL0);
-DECLARE_IMMEDIATE_SR(TPIDR_EL1);
-DECLARE_IMMEDIATE_SR(AMAIR_EL1);
-DECLARE_IMMEDIATE_SR(CNTKCTL_EL1);
-DECLARE_IMMEDIATE_SR(PAR_EL1);
+DECLARE_DEFERRABLE_SR(CSSELR_EL1,	SYS_CSSELR_EL1);
+DECLARE_DEFERRABLE_SR(SCTLR_EL1,	sctlr_EL12);
+DECLARE_DEFERRABLE_SR(ACTLR_EL1,	SYS_ACTLR_EL1);
+DECLARE_DEFERRABLE_SR(CPACR_EL1,	cpacr_EL12);
+DECLARE_DEFERRABLE_SR(TTBR0_EL1,	ttbr0_EL12);
+DECLARE_DEFERRABLE_SR(TTBR1_EL1,	ttbr1_EL12);
+DECLARE_DEFERRABLE_SR(TCR_EL1,		tcr_EL12);
+DECLARE_DEFERRABLE_SR(ESR_EL1,		esr_EL12);
+DECLARE_DEFERRABLE_SR(AFSR0_EL1,	afsr0_EL12);
+DECLARE_DEFERRABLE_SR(AFSR1_EL1,	afsr1_EL12);
+DECLARE_DEFERRABLE_SR(FAR_EL1,		far_EL12);
+DECLARE_DEFERRABLE_SR(MAIR_EL1,		mair_EL12);
+DECLARE_DEFERRABLE_SR(VBAR_EL1,		vbar_EL12);
+DECLARE_DEFERRABLE_SR(CONTEXTIDR_EL1,	contextidr_EL12);
+DECLARE_DEFERRABLE_SR(TPIDR_EL0,	SYS_TPIDR_EL0);
+DECLARE_DEFERRABLE_SR(TPIDRRO_EL0,	SYS_TPIDRRO_EL0);
+DECLARE_DEFERRABLE_SR(TPIDR_EL1,	SYS_TPIDR_EL1);
+DECLARE_DEFERRABLE_SR(AMAIR_EL1,	amair_EL12);
+DECLARE_DEFERRABLE_SR(CNTKCTL_EL1,	cntkctl_EL12);
+DECLARE_DEFERRABLE_SR(PAR_EL1,		SYS_PAR_EL1);
 DECLARE_IMMEDIATE_SR(MDSCR_EL1);
 DECLARE_IMMEDIATE_SR(MDCCINT_EL1);
 DECLARE_IMMEDIATE_SR(PMCR_EL0);
-- 
2.14.2
