From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 2/2] KVM: arm64: Eliminate most redundant FPSIMD saves and
 restores
Date: Fri, 16 Feb 2018 18:29:31 +0000
Message-ID: <1518805771-15346-3-git-send-email-Dave.Martin@arm.com>
References: <1518805771-15346-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 342C4401AB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Feb 2018 13:23:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wKn-9jWovnGr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Feb 2018 13:23:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DCC640683
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Feb 2018 13:23:19 -0500 (EST)
In-Reply-To: <1518805771-15346-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Currently, KVM doesn't know how host tasks interact with the cpu
FPSIMD regs, and the host doesn't knoe how vcpus interact with the
regs.  As a result, KVM must currently switch the FPSIMD state
rather defensively in order to avoid anybody's state getting
corrupted: in particular, the host and guest FPSIMD state must be
fully swapped on each iteration of the run loop.

This patch integrates KVM more closely with the host FPSIMD context
switch machinery, to enable better tracking of whose state is in
the FPSIMD regs.  This brings some advantages: KVM can tell whether
the host has any live state in the regs and can avoid saving them
if not; also, KVM can tell when and if the host clobbers the vcpu
state in the regs, to avoid reloading them before reentering the
guest.

As well as avoiding the host state being unecessarily saved, this
should also mean that the vcpu state can survive context switch
when there is no kernel-mode NEON use and no entry to userspace,
such as when ancillary kernel threads preempt a vcpu.

This patch cannot eliminate the need to save the guest context
eefore enabling interrupts, becuase softirqs may use kernel- mode
NEON and trash the vcpu regs.  However, provding that doesn't
happen the reload cost is at least saved on the next run loop
iteration.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Caveat: this does *not* currently deal properly with host SVE state,
though supporting that shouldn't be drastically different.
---
 arch/arm64/include/asm/fpsimd.h      |  1 +
 arch/arm64/include/asm/kvm_host.h    | 10 +++++++-
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/include/uapi/asm/kvm.h    | 14 +++++-----
 arch/arm64/kernel/fpsimd.c           |  7 ++++-
 arch/arm64/kvm/hyp/switch.c          | 21 +++++++++------
 virt/kvm/arm/arm.c                   | 50 ++++++++++++++++++++++++++++++++++++
 7 files changed, 88 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index f4ce4d6..1f78631 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -76,6 +76,7 @@ extern void fpsimd_preserve_current_state(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 
+extern void fpsimd_flush_state(struct fpsimd_state *state);
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void sve_flush_cpu_state(void);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b463b5e..95ffb54 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -192,7 +192,13 @@ enum vcpu_sysreg {
 #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
 
 struct kvm_cpu_context {
-	struct kvm_regs	gp_regs;
+	union {
+		struct kvm_regs	gp_regs;
+		struct {
+			__KVM_REGS_COMMON
+			struct fpsimd_state fpsimd_state;
+		};
+	};
 	union {
 		u64 sys_regs[NR_SYS_REGS];
 		u32 copro[NR_COPRO_REGS];
@@ -235,6 +241,8 @@ struct kvm_vcpu_arch {
 
 	/* Pointer to host CPU context */
 	kvm_cpu_context_t *host_cpu_context;
+	struct user_fpsimd_state *host_fpsimd_state; /* hyp va */
+	bool guest_fpsimd_loaded;
 	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 740aa03c..9f1fa1a 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -94,6 +94,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define TIF_32BIT		22	/* 32bit process */
 #define TIF_SVE			23	/* Scalable Vector Extension in use */
 #define TIF_SVE_VL_INHERIT	24	/* Inherit sve_vl_onexec across exec */
+#define TIF_MAPPED_TO_HYP	25	/* task_struct mapped to Hyp (KVM) */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9abbf30..c3392d2 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -45,14 +45,16 @@
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
 
-struct kvm_regs {
-	struct user_pt_regs regs;	/* sp = sp_el0 */
-
-	__u64	sp_el1;
-	__u64	elr_el1;
-
+#define __KVM_REGS_COMMON					\
+	struct user_pt_regs regs;	/* sp = sp_el0 */	\
+								\
+	__u64	sp_el1;						\
+	__u64	elr_el1;					\
+								\
 	__u64	spsr[KVM_NR_SPSR];
 
+struct kvm_regs {
+	__KVM_REGS_COMMON
 	struct user_fpsimd_state fp_regs;
 };
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 138efaf..c46e11f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1073,12 +1073,17 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
 	local_bh_enable();
 }
 
+void fpsimd_flush_state(struct fpsimd_state *st)
+{
+	st->cpu = NR_CPUS;
+}
+
 /*
  * Invalidate live CPU copies of task t's FPSIMD state
  */
 void fpsimd_flush_task_state(struct task_struct *t)
 {
-	t->thread.fpsimd_state.cpu = NR_CPUS;
+	fpsimd_flush_state(&t->thread.fpsimd_state);
 }
 
 static inline void fpsimd_flush_cpu_state(void)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index a0a63bc..b88e83f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -91,7 +91,11 @@ static inline void activate_traps_vhe(struct kvm_vcpu *vcpu)
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
-	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
+
+	val &= ~CPACR_EL1_ZEN;
+	if (!vcpu->arch.guest_fpsimd_loaded)
+		val &= ~CPACR_EL1_FPEN;
+
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
@@ -104,7 +108,10 @@ static inline void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 	__activate_traps_common(vcpu);
 
 	val = CPTR_EL2_DEFAULT;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
+	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
+	if (!vcpu->arch.guest_fpsimd_loaded)
+		val |= CPTR_EL2_TFP;
+
 	write_sysreg(val, cptr_el2);
 }
 
@@ -423,7 +430,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
-		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
 		__fpsimd_save_fpexc32(vcpu);
 	}
 
@@ -491,7 +497,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
-		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
 		__fpsimd_save_fpexc32(vcpu);
 	}
 
@@ -507,8 +512,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 				    struct kvm_vcpu *vcpu)
 {
-	kvm_cpu_context_t *host_ctxt;
-
 	if (has_vhe())
 		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
 			     cpacr_el1);
@@ -518,9 +521,11 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 
 	isb();
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
+	if (vcpu->arch.host_fpsimd_state)
+		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
+
 	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
+	vcpu->arch.guest_fpsimd_loaded = true;
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 6de7641..0330e1f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -329,6 +329,10 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
+	/* Mark this vcpu's FPSIMD state as non-live initially: */
+	fpsimd_flush_state(&vcpu->arch.ctxt.fpsimd_state);
+	vcpu->arch.guest_fpsimd_loaded = false;
+
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
@@ -631,6 +635,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int ret;
+	struct fpsimd_state *guest_fpsimd = &vcpu->arch.ctxt.fpsimd_state;
+	struct user_fpsimd_state *host_fpsimd =
+		&current->thread.fpsimd_state.user_fpsimd;
 
 	if (unlikely(!kvm_vcpu_initialized(vcpu)))
 		return -ENOEXEC;
@@ -650,6 +657,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	if (run->immediate_exit)
 		return -EINTR;
 
+	WARN_ON(!current->mm);
+
+	if (!test_thread_flag(TIF_MAPPED_TO_HYP)) {
+		ret = create_hyp_mappings(host_fpsimd, host_fpsimd + 1,
+					  PAGE_HYP);
+		if (ret)
+			return ret;
+
+		set_thread_flag(TIF_MAPPED_TO_HYP);
+	}
+
 	vcpu_load(vcpu);
 
 	kvm_sigset_activate(vcpu);
@@ -680,6 +698,23 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		local_irq_disable();
 
+		/*
+		 * host_fpsimd_state indicates to hyp that there is host state
+		 * to save, and where to save it:
+		 */
+		if (test_thread_flag(TIF_FOREIGN_FPSTATE))
+			vcpu->arch.host_fpsimd_state = NULL;
+		else
+			vcpu->arch.host_fpsimd_state = kern_hyp_va(host_fpsimd);
+
+		vcpu->arch.guest_fpsimd_loaded =
+			!fpsimd_foreign_fpstate(guest_fpsimd);
+
+		BUG_ON(system_supports_sve());
+
+		BUG_ON(vcpu->arch.guest_fpsimd_loaded &&
+		       vcpu->arch.host_fpsimd_state);
+
 		kvm_vgic_flush_hwstate(vcpu);
 
 		/*
@@ -774,6 +809,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
 			kvm_timer_sync_hwstate(vcpu);
 
+		/* defend against kernel-mode NEON in softirq */
+		local_bh_disable();
+
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
@@ -786,6 +824,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		local_irq_enable();
 
+		if (vcpu->arch.guest_fpsimd_loaded) {
+			set_thread_flag(TIF_FOREIGN_FPSTATE);
+			fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fpsimd_state);
+
+			/*
+			 * Protect ourselves against a softirq splatting the
+			 * FPSIMD state once irqs are enabled:
+			 */
+			fpsimd_save_state(guest_fpsimd);
+		}
+		local_bh_enable();
+
 		/*
 		 * We do local_irq_enable() before calling guest_exit() so
 		 * that if a timer interrupt hits while running the guest we
-- 
2.1.4
