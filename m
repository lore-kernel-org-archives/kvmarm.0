From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v10 10/18] KVM: arm64: Optimise FPSIMD handling to reduce
 guest/host thrashing
Date: Tue, 22 May 2018 17:05:11 +0100
Message-ID: <1527005119-6842-11-git-send-email-Dave.Martin@arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA3374A102
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 11:56:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LKn-YHi0aABp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 May 2018 11:56:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA4E4A0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 11:55:47 -0400 (EDT)
In-Reply-To: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch refactors KVM to align the host and guest FPSIMD
save/restore logic with each other for arm64.  This reduces the
number of redundant save/restore operations that must occur, and
reduces the common-case IRQ blackout time during guest exit storms
by saving the host state lazily and optimising away the need to
restore the host state before returning to the run loop.

Four hooks are defined in order to enable this:

 * kvm_arch_vcpu_run_map_fp():
   Called on PID change to map necessary bits of current to Hyp.

 * kvm_arch_vcpu_load_fp():
   Set up FP/SIMD for entering the KVM run loop (parse as
   "vcpu_load fp").

 * kvm_arch_vcpu_ctxsync_fp():
   Get FP/SIMD into a safe state for re-enabling interrupts after a
   guest exit back to the run loop.

   For arm64 specifically, this involves updating the host kernel's
   FPSIMD context tracking metadata so that kernel-mode NEON use
   will cause the vcpu's FPSIMD state to be saved back correctly
   into the vcpu struct.  This must be done before re-enabling
   interrupts because kernel-mode NEON may be used by softirqs.

 * kvm_arch_vcpu_put_fp():
   Save guest FP/SIMD state back to memory and dissociate from the
   CPU ("vcpu_put fp").

Also, the arm64 FPSIMD context switch code is updated to enable it
to save back FPSIMD state for a vcpu, not just current.  A few
helpers drive this:

 * fpsimd_bind_state_to_cpu(struct user_fpsimd_state *fp):
   mark this CPU as having context fp (which may belong to a vcpu)
   currently loaded in its registers.  This is the non-task
   equivalent of the static function fpsimd_bind_to_cpu() in
   fpsimd.c.

 * task_fpsimd_save():
   exported to allow KVM to save the guest's FPSIMD state back to
   memory on exit from the run loop.

 * fpsimd_flush_state():
   invalidate any context's FPSIMD state that is currently loaded.
   Used to disassociate the vcpu from the CPU regs on run loop exit.

These changes allow the run loop to enable interrupts (and thus
softirqs that may use kernel-mode NEON) without having to save the
guest's FPSIMD state eagerly.

Some new vcpu_arch fields are added to make all this work.  Because
host FPSIMD state can now be saved back directly into current's
thread_struct as appropriate, host_cpu_context is no longer used
for preserving the FPSIMD state.  However, it is still needed for
preserving other things such as the host's system registers.  To
avoid ABI churn, the redundant storage space in host_cpu_context is
not removed for now.

arch/arm is not addressed by this patch and continues to use its
current save/restore logic.  It could provide implementations of
the helpers later if desired.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>

---

Reviewers note: tags retained because this delta is straightforward by
itself.  Please shout if you're not happy!

Changes since v9:

 * Remove redundant set_thread_flag(TIF_FOREIGN_FPSTATE) that is now
   implicit in fpsimd_flush_cpu_state().
---
 arch/arm/include/asm/kvm_host.h   |   8 +++
 arch/arm64/include/asm/fpsimd.h   |   6 +++
 arch/arm64/include/asm/kvm_host.h |  21 ++++++++
 arch/arm64/kernel/fpsimd.c        |  17 ++++--
 arch/arm64/kvm/Kconfig            |   1 +
 arch/arm64/kvm/Makefile           |   2 +-
 arch/arm64/kvm/fpsimd.c           | 111 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/switch.c       |  51 +++++++++---------
 virt/kvm/arm/arm.c                |   4 ++
 9 files changed, 191 insertions(+), 30 deletions(-)
 create mode 100644 arch/arm64/kvm/fpsimd.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index c7c28c8..ac870b2 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -303,6 +303,14 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
+/*
+ * VFP/NEON switching is all done by the hyp switch code, so no need to
+ * coordinate with host context handling for this state:
+ */
+static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
+
 /* All host FP/SIMD state is restored on guest exit, so nothing to save: */
 static inline void kvm_fpsimd_flush_cpu_state(void) {}
 
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index aa7162a..3e00f70 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -41,6 +41,8 @@ struct task_struct;
 extern void fpsimd_save_state(struct user_fpsimd_state *state);
 extern void fpsimd_load_state(struct user_fpsimd_state *state);
 
+extern void fpsimd_save(void);
+
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
 
@@ -49,7 +51,11 @@ extern void fpsimd_preserve_current_state(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 
+extern void fpsimd_bind_task_to_cpu(void);
+extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state);
+
 extern void fpsimd_flush_task_state(struct task_struct *target);
+extern void fpsimd_flush_cpu_state(void);
 extern void sve_flush_cpu_state(void);
 
 /* Maximum VL that SVE VL-agnostic software can transparently support */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 146c167..b3fe730 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -30,6 +30,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
+#include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -238,6 +239,10 @@ struct kvm_vcpu_arch {
 
 	/* Pointer to host CPU context */
 	kvm_cpu_context_t *host_cpu_context;
+
+	struct thread_info *host_thread_info;	/* hyp VA */
+	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
+
 	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
@@ -295,6 +300,9 @@ struct kvm_vcpu_arch {
 
 /* vcpu_arch flags field values: */
 #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
+#define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
+#define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
+#define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
 
@@ -423,6 +431,19 @@ static inline void __cpu_init_stage2(void)
 		  "PARange is %d bits, unsupported configuration!", parange);
 }
 
+/* Guest/host FPSIMD coordination helpers */
+int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
+
+#ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
+static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_run_map_fp(vcpu);
+}
+#endif
+
 /*
  * All host FP/SIMD state is restored on guest exit, so nothing needs
  * doing here except in the SVE case:
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index ba9e7df..ded7ffd 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -265,7 +265,7 @@ static void task_fpsimd_load(void)
  *
  * Softirqs (and preemption) must be disabled.
  */
-static void fpsimd_save(void)
+void fpsimd_save(void)
 {
 	struct user_fpsimd_state *st = __this_cpu_read(fpsimd_last_state.st);
 
@@ -981,7 +981,7 @@ void fpsimd_signal_preserve_current_state(void)
  * Associate current's FPSIMD context with this cpu
  * Preemption must be disabled when calling this function.
  */
-static void fpsimd_bind_task_to_cpu(void)
+void fpsimd_bind_task_to_cpu(void)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1001,6 +1001,17 @@ static void fpsimd_bind_task_to_cpu(void)
 	}
 }
 
+void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
+{
+	struct fpsimd_last_state_struct *last =
+		this_cpu_ptr(&fpsimd_last_state);
+
+	WARN_ON(!in_softirq() && !irqs_disabled());
+
+	last->st = st;
+	last->sve_in_use = false;
+}
+
 /*
  * Load the userland FPSIMD state of 'current' from memory, but only if the
  * FPSIMD state already held in the registers is /not/ the most recent FPSIMD
@@ -1053,7 +1064,7 @@ void fpsimd_flush_task_state(struct task_struct *t)
 	t->thread.fpsimd_cpu = NR_CPUS;
 }
 
-static inline void fpsimd_flush_cpu_state(void)
+void fpsimd_flush_cpu_state(void)
 {
 	__this_cpu_write(fpsimd_last_state.st, NULL);
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a2e3a5a..47b23bf 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ config KVM
 	select HAVE_KVM_IRQ_ROUTING
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
+	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 93afff9..0f2a135 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -19,7 +19,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
 kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o
+kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
new file mode 100644
index 0000000..365933a
--- /dev/null
+++ b/arch/arm64/kvm/fpsimd.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * arch/arm64/kvm/fpsimd.c: Guest/host FPSIMD context coordination helpers
+ *
+ * Copyright 2018 Arm Limited
+ * Author: Dave Martin <Dave.Martin@arm.com>
+ */
+#include <linux/bottom_half.h>
+#include <linux/sched.h>
+#include <linux/thread_info.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_host.h>
+#include <asm/kvm_mmu.h>
+
+/*
+ * Called on entry to KVM_RUN unless this vcpu previously ran at least
+ * once and the most recent prior KVM_RUN for this vcpu was called from
+ * the same task as current (highly likely).
+ *
+ * This is guaranteed to execute before kvm_arch_vcpu_load_fp(vcpu),
+ * such that on entering hyp the relevant parts of current are already
+ * mapped.
+ */
+int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	struct thread_info *ti = &current->thread_info;
+	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
+
+	/*
+	 * Make sure the host task thread flags and fpsimd state are
+	 * visible to hyp:
+	 */
+	ret = create_hyp_mappings(ti, ti + 1, PAGE_HYP);
+	if (ret)
+		goto error;
+
+	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
+	if (ret)
+		goto error;
+
+	vcpu->arch.host_thread_info = kern_hyp_va(ti);
+	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
+error:
+	return ret;
+}
+
+/*
+ * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
+ * The actual loading is done by the FPSIMD access trap taken to hyp.
+ *
+ * Here, we just set the correct metadata to indicate that the FPSIMD
+ * state in the cpu regs (if any) belongs to current on the host.
+ *
+ * TIF_SVE is backed up here, since it may get clobbered with guest state.
+ * This flag is restored by kvm_arch_vcpu_put_fp(vcpu).
+ */
+void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
+{
+	BUG_ON(system_supports_sve());
+	BUG_ON(!current->mm);
+
+	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_HOST_SVE_IN_USE);
+	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
+	if (test_thread_flag(TIF_SVE))
+		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
+}
+
+/*
+ * If the guest FPSIMD state was loaded, update the host's context
+ * tracking data mark the CPU FPSIMD regs as dirty and belonging to vcpu
+ * so that they will be written back if the kernel clobbers them due to
+ * kernel-mode NEON before re-entry into the guest.
+ */
+void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+
+	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs);
+		clear_thread_flag(TIF_FOREIGN_FPSTATE);
+		clear_thread_flag(TIF_SVE);
+	}
+}
+
+/*
+ * Write back the vcpu FPSIMD regs if they are dirty, and invalidate the
+ * cpu FPSIMD regs so that they can't be spuriously reused if this vcpu
+ * disappears and another task or vcpu appears that recycles the same
+ * struct fpsimd_state.
+ */
+void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
+{
+	local_bh_disable();
+
+	update_thread_flag(TIF_SVE,
+			   vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE);
+
+	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+		/* Clean guest FP state to memory and invalidate cpu view */
+		fpsimd_save();
+		fpsimd_flush_cpu_state();
+	} else if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
+		/* Ensure user trap controls are correctly restored */
+		fpsimd_bind_task_to_cpu();
+	}
+
+	local_bh_enable();
+}
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c0796c4..118f300 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -23,19 +23,21 @@
 
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
+#include <asm/thread_info.h>
 
-static bool __hyp_text __fpsimd_enabled_nvhe(void)
+/* Check whether the FP regs were dirtied while in the host-side run loop: */
+static bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
 {
-	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
-}
+	if (vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
+		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
+				      KVM_ARM64_FP_HOST);
 
-static bool fpsimd_enabled_vhe(void)
-{
-	return !!(read_sysreg(cpacr_el1) & CPACR_EL1_FPEN);
+	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
 }
 
 /* Save the 32-bit only FPSIMD system register state */
@@ -92,7 +94,10 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
-	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
+	val &= ~CPACR_EL1_ZEN;
+	if (!update_fp_enabled(vcpu))
+		val &= ~CPACR_EL1_FPEN;
+
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
@@ -105,7 +110,10 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 	__activate_traps_common(vcpu);
 
 	val = CPTR_EL2_DEFAULT;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
+	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
+	if (!update_fp_enabled(vcpu))
+		val |= CPTR_EL2_TFP;
+
 	write_sysreg(val, cptr_el2);
 }
 
@@ -321,8 +329,6 @@ static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
 void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 				    struct kvm_vcpu *vcpu)
 {
-	kvm_cpu_context_t *host_ctxt;
-
 	if (has_vhe())
 		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
 			     cpacr_el1);
@@ -332,14 +338,19 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 
 	isb();
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
+	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
+		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
+		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
+	}
+
 	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(vcpu->arch.ctxt.sys_regs[FPEXC32_EL2],
 			     fpexc32_el2);
+
+	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
 }
 
 /*
@@ -418,7 +429,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
-	bool fp_enabled;
 	u64 exit_code;
 
 	host_ctxt = vcpu->arch.host_cpu_context;
@@ -440,19 +450,14 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-	fp_enabled = fpsimd_enabled_vhe();
-
 	sysreg_save_guest_state_vhe(guest_ctxt);
 
 	__deactivate_traps(vcpu);
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (fp_enabled) {
-		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
-		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
+	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
-	}
 
 	__debug_switch_to_host(vcpu);
 
@@ -464,7 +469,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
-	bool fp_enabled;
 	u64 exit_code;
 
 	vcpu = kern_hyp_va(vcpu);
@@ -496,8 +500,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-	fp_enabled = __fpsimd_enabled_nvhe();
-
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
@@ -508,11 +510,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (fp_enabled) {
-		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
-		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
+	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
-	}
 
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a4c1b76..bee226c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -363,10 +363,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
+	kvm_arch_vcpu_load_fp(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_arch_vcpu_put_fp(vcpu);
 	kvm_vcpu_put_sysregs(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
@@ -778,6 +780,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
 			kvm_timer_sync_hwstate(vcpu);
 
+		kvm_arch_vcpu_ctxsync_fp(vcpu);
+
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
-- 
2.1.4
