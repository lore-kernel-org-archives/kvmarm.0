From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v8 5/9] KVM: arm/arm64: preserve host MDCR_EL2 value
Date: Tue,  2 Apr 2019 07:57:13 +0530
Message-ID: <1554172037-4516-6-git-send-email-amit.kachhap@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Save host MDCR_EL2 value during kvm HYP initialisation and restore
after every switch from host to guest. There should not be any
change in functionality due to this.

The value of mdcr_el2 is now stored in struct kvm_cpu_context as
both host and guest can now use this field in a common way.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---

Changes since v7:
* Removed unused function __kvm_get_mdcr_el2 [Kristina].

 arch/arm/include/asm/kvm_host.h   |  1 -
 arch/arm64/include/asm/kvm_asm.h  |  2 --
 arch/arm64/include/asm/kvm_host.h |  6 ++----
 arch/arm64/include/asm/kvm_hyp.h  |  2 +-
 arch/arm64/kvm/debug.c            | 28 ++++++----------------------
 arch/arm64/kvm/hyp/debug-sr.c     |  5 -----
 arch/arm64/kvm/hyp/switch.c       | 18 +++++-------------
 arch/arm64/kvm/hyp/sysreg-sr.c    |  8 +++++++-
 virt/kvm/arm/arm.c                |  1 -
 9 files changed, 21 insertions(+), 50 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 6d0aac4..a928565 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -343,7 +343,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
-static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a68205c..a15ba55 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -78,8 +78,6 @@ extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
 extern void __vgic_v3_init_lrs(void);
 
-extern u32 __kvm_get_mdcr_el2(void);
-
 extern void __kvm_populate_host_regs(void);
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3b09fd0..e3ccd7b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -211,6 +211,8 @@ struct kvm_cpu_context {
 
 	/* HYP host/guest configuration */
 	u64 hcr_el2;
+	u32 mdcr_el2;
+
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
@@ -226,9 +228,6 @@ struct vcpu_reset_state {
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
-	/* HYP configuration */
-	u32 mdcr_el2;
-
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
@@ -498,7 +497,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
-void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4da765f..7fcde8a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -152,7 +152,7 @@ void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 bool __fpsimd_enabled(void);
 
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
-void deactivate_traps_vhe_put(void);
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index fd917d6..99dc0a4 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -32,8 +32,6 @@
 				DBG_MDSCR_KDE | \
 				DBG_MDSCR_MDE)
 
-static DEFINE_PER_CPU(u32, mdcr_el2);
-
 /**
  * save/restore_guest_debug_regs
  *
@@ -65,21 +63,6 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 }
 
 /**
- * kvm_arm_init_debug - grab what we need for debug
- *
- * Currently the sole task of this function is to retrieve the initial
- * value of mdcr_el2 so we can preserve MDCR_EL2.HPMN which has
- * presumably been set-up by some knowledgeable bootcode.
- *
- * It is called once per-cpu during CPU hyp initialisation.
- */
-
-void kvm_arm_init_debug(void)
-{
-	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
-}
-
-/**
  * kvm_arm_reset_debug_ptr - reset the debug ptr to point to the vcpu state
  */
 
@@ -111,6 +94,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
 
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
+	kvm_cpu_context_t *host_cxt = this_cpu_ptr(&kvm_host_cpu_state);
 	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
 	unsigned long mdscr;
 
@@ -120,8 +104,8 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
 	 * to the profiling buffer.
 	 */
-	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
+	vcpu->arch.ctxt.mdcr_el2 = host_cxt->mdcr_el2 & MDCR_EL2_HPMN_MASK;
+	vcpu->arch.ctxt.mdcr_el2 |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
@@ -130,7 +114,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	/* Is Guest debugging in effect? */
 	if (vcpu->guest_debug) {
 		/* Route all software debug exceptions to EL2 */
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
+		vcpu->arch.ctxt.mdcr_el2 |= MDCR_EL2_TDE;
 
 		/* Save guest debug state */
 		save_guest_debug_regs(vcpu);
@@ -202,13 +186,13 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 	/* Trap debug register access */
 	if (trap_debug)
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
+		vcpu->arch.ctxt.mdcr_el2 |= MDCR_EL2_TDA;
 
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 
-	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
+	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.ctxt.mdcr_el2);
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 5000976..f49a3f7 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -198,8 +198,3 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
-
-u32 __hyp_text __kvm_get_mdcr_el2(void)
-{
-	return read_sysreg(mdcr_el2);
-}
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index f5cefa1..fe76e24 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -84,7 +84,7 @@ static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
 	 */
 	write_sysreg(0, pmselr_el0);
 	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
-	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	write_sysreg(vcpu->arch.ctxt.mdcr_el2, mdcr_el2);
 }
 
 static void __hyp_text __deactivate_traps_common(void)
@@ -161,15 +161,11 @@ NOKPROBE_SYMBOL(deactivate_traps_vhe);
 
 static void __hyp_text __deactivate_traps_nvhe(struct kvm_cpu_context *host_ctxt)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 	struct kvm_cpu_context *hyp_host_ctxt = kern_hyp_va(host_ctxt);
 
 	__deactivate_traps_common();
 
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
-	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
-
-	write_sysreg(mdcr_el2, mdcr_el2);
+	write_sysreg(hyp_host_ctxt->mdcr_el2, mdcr_el2);
 	write_sysreg(hyp_host_ctxt->hcr_el2, hcr_el2);
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
@@ -199,15 +195,11 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 	__activate_traps_common(vcpu);
 }
 
-void deactivate_traps_vhe_put(void)
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
-
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
-		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-		    MDCR_EL2_TPMS;
+	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
 
-	write_sysreg(mdcr_el2, mdcr_el2);
+	write_sysreg(host_ctxt->mdcr_el2, mdcr_el2);
 
 	__deactivate_traps_common();
 }
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 277f82b..6afd309 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -298,7 +298,7 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 	if (!has_vhe())
 		return;
 
-	deactivate_traps_vhe_put();
+	deactivate_traps_vhe_put(vcpu);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
@@ -333,4 +333,10 @@ void __hyp_text __kvm_populate_host_regs(void)
 
 	host_ctxt = __hyp_this_cpu_ptr(kvm_host_cpu_state);
 	host_ctxt->hcr_el2 = read_sysreg(hcr_el2);
+	/*
+	 * Retrieve the initial value of mdcr_el2 so we can preserve
+	 * MDCR_EL2.HPMN which has presumably been set-up by some
+	 * knowledgeable bootcode.
+	 */
+	host_ctxt->mdcr_el2 = read_sysreg(mdcr_el2);
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index e8c2ee6..58de0ca 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1322,7 +1322,6 @@ static void cpu_hyp_reinit(void)
 	else
 		cpu_init_hyp_mode(NULL);
 
-	kvm_arm_init_debug();
 	cpu_init_host_ctxt();
 
 	if (vgic_present)
-- 
2.7.4
