From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v6 2/6] arm64/kvm: preserve host MDCR_EL2 value
Date: Tue, 19 Feb 2019 14:54:27 +0530
Message-ID: <1550568271-5319-3-git-send-email-amit.kachhap@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm/include/asm/kvm_host.h   |  1 -
 arch/arm64/include/asm/kvm_host.h |  6 ++----
 arch/arm64/kvm/debug.c            | 28 ++++++----------------------
 arch/arm64/kvm/hyp/switch.c       | 17 ++++-------------
 arch/arm64/kvm/hyp/sysreg-sr.c    |  6 ++++++
 virt/kvm/arm/arm.c                |  1 -
 6 files changed, 18 insertions(+), 41 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 05706b4..704667e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -294,7 +294,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
-static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1b2e05b..2f1bb86 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -205,6 +205,8 @@ struct kvm_cpu_context {
 
 	/* HYP host/guest configuration */
 	u64 hcr_el2;
+	u32 mdcr_el2;
+
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
@@ -213,9 +215,6 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
-	/* HYP configuration */
-	u32 mdcr_el2;
-
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
@@ -446,7 +445,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
-void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index f39801e..99dc0a4 100644
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
-	__this_cpu_write(mdcr_el2, kvm_call_hyp(__kvm_get_mdcr_el2));
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
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 006bd33..03b36f1 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -82,7 +82,7 @@ static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
 	 */
 	write_sysreg(0, pmselr_el0);
 	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
-	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	write_sysreg(vcpu->arch.ctxt.mdcr_el2, mdcr_el2);
 }
 
 static void __hyp_text __deactivate_traps_common(void)
@@ -157,14 +157,9 @@ static void deactivate_traps_vhe(struct kvm_cpu_context *host_ctxt)
 
 static void __hyp_text __deactivate_traps_nvhe(struct kvm_cpu_context *host_ctxt)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
-
 	__deactivate_traps_common();
 
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
-	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
-
-	write_sysreg(mdcr_el2, mdcr_el2);
+	write_sysreg(host_ctxt->mdcr_el2, mdcr_el2);
 	write_sysreg(host_ctxt->hcr_el2, hcr_el2);
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
@@ -196,13 +191,9 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 
 void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
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
index 68ddc0f..42ec50f 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -334,4 +334,10 @@ void __hyp_text __kvm_populate_host_regs(void)
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
index 8e18f7f..2032a66 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1327,7 +1327,6 @@ static void cpu_hyp_reinit(void)
 	else
 		cpu_init_hyp_mode(NULL);
 
-	kvm_arm_init_debug();
 	__cpu_copy_hyp_conf();
 
 	if (vgic_present)
-- 
2.7.4
