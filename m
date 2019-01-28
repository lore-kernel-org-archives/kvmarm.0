From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v5 2/5] arm64/kvm: preserve host HCR_EL2/MDCR_EL2 value
Date: Mon, 28 Jan 2019 12:28:43 +0530
Message-ID: <1548658727-14271-3-git-send-email-amit.kachhap@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A23354A3BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 01:59:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yCOwkrY0unWp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 01:59:22 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C92AB4A3C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 01:59:22 -0500 (EST)
In-Reply-To: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
is a constant value. This works today, as the host HCR_EL2 value is
always the same, but this will get in the way of supporting extensions
that require HCR_EL2 bits to be set conditionally for the host.

To allow such features to work without KVM having to explicitly handle
every possible host feature combination, this patch has KVM save/restore
the host HCR when switching to/from a guest HCR. The saving of the
register is done once during cpu hypervisor initialization state and is
just restored after switch from guest.

For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
kvm_call_hyp and is helpful in NHVE case.

For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
to toggle the TGE bit with a RMW sequence, as we already do in
__tlb_switch_to_guest_vhe().

While at it, host MDCR_EL2 value is fetched in a similar way and restored
after every switch from host to guest. There should not be any change in
functionality due to this.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/kvm_host.h      |  3 ++-
 arch/arm64/include/asm/kvm_asm.h     |  2 ++
 arch/arm64/include/asm/kvm_emulate.h | 22 ++++++++++----------
 arch/arm64/include/asm/kvm_host.h    | 28 ++++++++++++++++++++-----
 arch/arm64/include/asm/kvm_hyp.h     |  2 +-
 arch/arm64/kvm/debug.c               | 28 ++++++-------------------
 arch/arm64/kvm/guest.c               |  2 +-
 arch/arm64/kvm/hyp/switch.c          | 40 +++++++++++++++---------------------
 arch/arm64/kvm/hyp/sysreg-sr.c       | 13 +++++++++++-
 arch/arm64/kvm/hyp/tlb.c             |  6 +++++-
 virt/kvm/arm/arm.c                   |  4 ++--
 11 files changed, 82 insertions(+), 68 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index ca56537..704667e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -273,6 +273,8 @@ static inline void __cpu_init_stage2(void)
 	kvm_call_hyp(__init_stage2_translation);
 }
 
+static inline void __cpu_copy_hyp_conf(void) {}
+
 static inline int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	return 0;
@@ -292,7 +294,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
-static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f5b79e9..2da6e43 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -80,6 +80,8 @@ extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
+extern u64 __kvm_get_hcr_el2(void);
+
 /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
 #define __hyp_this_cpu_ptr(sym)						\
 	({								\
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 506386a..0dbe795 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -50,25 +50,25 @@ void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 
 static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
-	return !(vcpu->arch.hcr_el2 & HCR_RW);
+	return !(vcpu->arch.ctxt.hcr_el2 & HCR_RW);
 }
 
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
+	vcpu->arch.ctxt.hcr_el2 = HCR_GUEST_FLAGS;
 	if (is_kernel_in_hyp_mode())
-		vcpu->arch.hcr_el2 |= HCR_E2H;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_E2H;
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
 		/* route synchronous external abort exceptions to EL2 */
-		vcpu->arch.hcr_el2 |= HCR_TEA;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_TEA;
 		/* trap error record accesses */
-		vcpu->arch.hcr_el2 |= HCR_TERR;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_TERR;
 	}
 	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		vcpu->arch.hcr_el2 |= HCR_FWB;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_FWB;
 
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
-		vcpu->arch.hcr_el2 &= ~HCR_RW;
+		vcpu->arch.ctxt.hcr_el2 &= ~HCR_RW;
 
 	/*
 	 * TID3: trap feature register accesses that we virtualise.
@@ -76,22 +76,22 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	 * are currently virtualised.
 	 */
 	if (!vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 |= HCR_TID3;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_TID3;
 }
 
 static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu->arch.hcr_el2;
+	return (unsigned long *)&vcpu->arch.ctxt.hcr_el2;
 }
 
 static inline void vcpu_clear_wfe_traps(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 &= ~HCR_TWE;
+	vcpu->arch.ctxt.hcr_el2 &= ~HCR_TWE;
 }
 
 static inline void vcpu_set_wfe_traps(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 |= HCR_TWE;
+	vcpu->arch.ctxt.hcr_el2 |= HCR_TWE;
 }
 
 static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7732d0b..1f2d237 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -203,6 +203,10 @@ struct kvm_cpu_context {
 		u32 copro[NR_COPRO_REGS];
 	};
 
+	/* HYP configuration */
+	u64 hcr_el2;
+	u32 mdcr_el2;
+
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
@@ -211,10 +215,6 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
-	/* HYP configuration */
-	u64 hcr_el2;
-	u32 mdcr_el2;
-
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
@@ -445,7 +445,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
-void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
@@ -458,6 +457,25 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 
 static inline void __cpu_init_stage2(void) {}
 
+/**
+ * __cpu_copy_hyp_conf - copy the boot hyp configuration registers
+ *
+ * It is called once per-cpu during CPU hyp initialisation.
+ */
+static inline void __cpu_copy_hyp_conf(void)
+{
+	kvm_cpu_context_t *host_cxt = this_cpu_ptr(&kvm_host_cpu_state);
+
+	host_cxt->hcr_el2 = kvm_call_hyp(__kvm_get_hcr_el2);
+
+	/*
+	 * Retrieve the initial value of mdcr_el2 so we can preserve
+	 * MDCR_EL2.HPMN which has presumably been set-up by some
+	 * knowledgeable bootcode.
+	 */
+	host_cxt->mdcr_el2 = kvm_call_hyp(__kvm_get_mdcr_el2);
+}
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index a80a7ef..6e65cad 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -151,7 +151,7 @@ void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 bool __fpsimd_enabled(void);
 
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
-void deactivate_traps_vhe_put(void);
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
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
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dd436a5..e2f0268 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -345,7 +345,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events)
 {
-	events->exception.serror_pending = !!(vcpu->arch.hcr_el2 & HCR_VSE);
+	events->exception.serror_pending = !!(vcpu->arch.ctxt.hcr_el2 & HCR_VSE);
 	events->exception.serror_has_esr = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
 
 	if (events->exception.serror_pending && events->exception.serror_has_esr)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index b0b1478..03b36f1 100644
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
@@ -126,7 +126,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
-	u64 hcr = vcpu->arch.hcr_el2;
+	u64 hcr = vcpu->arch.ctxt.hcr_el2;
 
 	write_sysreg(hcr, hcr_el2);
 
@@ -139,10 +139,10 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_nvhe(vcpu);
 }
 
-static void deactivate_traps_vhe(void)
+static void deactivate_traps_vhe(struct kvm_cpu_context *host_ctxt)
 {
 	extern char vectors[];	/* kernel exception vectors */
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	write_sysreg(host_ctxt->hcr_el2, hcr_el2);
 
 	/*
 	 * ARM erratum 1165522 requires the actual execution of the above
@@ -155,35 +155,33 @@ static void deactivate_traps_vhe(void)
 	write_sysreg(vectors, vbar_el1);
 }
 
-static void __hyp_text __deactivate_traps_nvhe(void)
+static void __hyp_text __deactivate_traps_nvhe(struct kvm_cpu_context *host_ctxt)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
-
 	__deactivate_traps_common();
 
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
-	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
-
-	write_sysreg(mdcr_el2, mdcr_el2);
-	write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
+	write_sysreg(host_ctxt->mdcr_el2, mdcr_el2);
+	write_sysreg(host_ctxt->hcr_el2, hcr_el2);
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
 static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = vcpu->arch.host_cpu_context;
 	/*
 	 * If we pended a virtual abort, preserve it until it gets
 	 * cleared. See D1.14.3 (Virtual Interrupts) for details, but
 	 * the crucial bit is "On taking a vSError interrupt,
 	 * HCR_EL2.VSE is cleared to 0."
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_VSE)
-		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
+	if (vcpu->arch.ctxt.hcr_el2 & HCR_VSE)
+		vcpu->arch.ctxt.hcr_el2 = read_sysreg(hcr_el2);
 
 	if (has_vhe())
-		deactivate_traps_vhe();
+		deactivate_traps_vhe(host_ctxt);
 	else
-		__deactivate_traps_nvhe();
+		__deactivate_traps_nvhe(host_ctxt);
 }
 
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
@@ -191,15 +189,11 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
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
index 68d6f7c..22c854a 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -294,7 +294,7 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 	if (!has_vhe())
 		return;
 
-	deactivate_traps_vhe_put();
+	deactivate_traps_vhe_put(vcpu);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
@@ -316,3 +316,14 @@ void __hyp_text __kvm_enable_ssbs(void)
 	"msr	sctlr_el2, %0"
 	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
 }
+
+/**
+ * __read_hyp_hcr_el2 - Returns hcr_el2 register value
+ *
+ * This function acts as a function handler parameter for kvm_call_hyp and
+ * may be called from EL1 exception level to fetch the register value.
+ */
+u64 __hyp_text __kvm_get_hcr_el2(void)
+{
+	return read_sysreg(hcr_el2);
+}
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 76c3086..c5e7144 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -86,12 +86,16 @@ static hyp_alternate_select(__tlb_switch_to_guest,
 static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
 						struct tlb_inv_context *cxt)
 {
+	u64 val;
+
 	/*
 	 * We're done with the TLB operation, let's restore the host's
 	 * view of HCR_EL2.
 	 */
 	write_sysreg(0, vttbr_el2);
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	val = read_sysreg(hcr_el2);
+	val |= HCR_TGE;
+	write_sysreg(val, hcr_el2);
 	isb();
 
 	if (cpus_have_const_cap(ARM64_WORKAROUND_1165522)) {
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9e350fd3..2d65ada 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1327,10 +1327,10 @@ static void cpu_hyp_reinit(void)
 	else
 		cpu_init_hyp_mode(NULL);
 
-	kvm_arm_init_debug();
-
 	if (vgic_present)
 		kvm_vgic_init_cpu_hardware();
+
+	__cpu_copy_hyp_conf();
 }
 
 static void _kvm_arch_hardware_enable(void *discard)
-- 
2.7.4
