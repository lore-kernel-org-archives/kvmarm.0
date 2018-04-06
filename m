From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 3/3] KVM: arm64: Optimise FPSIMD handling to reduce
 guest/host thrashing
Date: Fri,  6 Apr 2018 16:01:04 +0100
Message-ID: <1523026864-15413-4-git-send-email-Dave.Martin@arm.com>
References: <1523026864-15413-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C505749FBB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Apr 2018 10:53:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e5rJ+QdVB98Q for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Apr 2018 10:52:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD09F49EA2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Apr 2018 10:52:40 -0400 (EDT)
In-Reply-To: <1523026864-15413-1-git-send-email-Dave.Martin@arm.com>
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

 * kvm_arch_vcpu_park_fp():
   Get FP/SIMD into a safe state for re-enabling interrupts after a
   guest exit back to the run loop.

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
---
 arch/arm/include/asm/kvm_host.h   |  8 +++++++
 arch/arm64/include/asm/fpsimd.h   |  5 +++++
 arch/arm64/include/asm/kvm_host.h | 18 +++++++++++++++
 arch/arm64/kernel/fpsimd.c        | 31 ++++++++++++++++++++------
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/hyp/switch.c       | 46 ++++++++++++++++++++++++---------------
 virt/kvm/arm/arm.c                | 14 ++++--------
 7 files changed, 89 insertions(+), 35 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 248b930..11cd64a3 100644
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
+static inline void kvm_arch_vcpu_park_fp(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
+
 /* All host FP/SIMD state is restored on guest exit, so nothing to save: */
 static inline void kvm_fpsimd_flush_cpu_state(void) {}
 
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 1bfc920..dbe7340 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -40,6 +40,8 @@ struct task_struct;
 extern void fpsimd_save_state(struct user_fpsimd_state *state);
 extern void fpsimd_load_state(struct user_fpsimd_state *state);
 
+extern void task_fpsimd_save(void);
+
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
 
@@ -48,7 +50,10 @@ extern void fpsimd_preserve_current_state(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 
+extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state);
+
 extern void fpsimd_flush_task_state(struct task_struct *target);
+extern void fpsimd_flush_cpu_state(void);
 extern void sve_flush_cpu_state(void);
 
 /* Maximum VL that SVE VL-agnostic software can transparently support */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 596f8e4..80716fe 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -30,6 +30,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
+#include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -235,6 +236,12 @@ struct kvm_vcpu_arch {
 
 	/* Pointer to host CPU context */
 	kvm_cpu_context_t *host_cpu_context;
+
+	struct thread_info *host_thread_info;	/* hyp VA */
+	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
+	bool host_sve_in_use;	/* backup for host TIF_SVE while in guest */
+	bool fp_enabled;
+
 	struct {
 		/* {Break,watch}point registers */
 		struct kvm_guest_debug_arch regs;
@@ -398,6 +405,17 @@ static inline void __cpu_init_stage2(void)
 		  "PARange is %d bits, unsupported configuration!", parange);
 }
 
+/* Guest/host FPSIMD coordination helpers */
+int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_park_fp(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
+
+static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_run_map_fp(vcpu);
+}
+
 /*
  * All host FP/SIMD state is restored on guest exit, so nothing needs
  * doing here except in the SVE case:
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index db08a54..74c5a46 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -268,13 +268,15 @@ static void task_fpsimd_load(void)
 }
 
 /*
- * Ensure current's FPSIMD/SVE storage in thread_struct is up to date
+ * Ensure current's FPSIMD/SVE storage in memory is up to date
  * with respect to the CPU registers.
  *
  * Softirqs (and preemption) must be disabled.
  */
-static void task_fpsimd_save(void)
+void task_fpsimd_save(void)
 {
+	struct user_fpsimd_state *st = __this_cpu_read(fpsimd_last_state.st);
+
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
@@ -290,10 +292,9 @@ static void task_fpsimd_save(void)
 				return;
 			}
 
-			sve_save_state(sve_pffr(current),
-				       &current->thread.fpsimd_state.fpsr);
+			sve_save_state(sve_pffr(current), &st->fpsr);
 		} else
-			fpsimd_save_state(&current->thread.fpsimd_state);
+			fpsimd_save_state(st);
 	}
 }
 
@@ -1010,6 +1011,17 @@ static void fpsimd_bind_to_cpu(void)
 	current->thread.fpsimd_cpu = smp_processor_id();
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
@@ -1054,15 +1066,20 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
 	local_bh_enable();
 }
 
+void fpsimd_flush_state(unsigned int *cpu)
+{
+	*cpu = NR_CPUS;
+}
+
 /*
  * Invalidate live CPU copies of task t's FPSIMD state
  */
 void fpsimd_flush_task_state(struct task_struct *t)
 {
-	t->thread.fpsimd_cpu = NR_CPUS;
+	fpsimd_flush_state(&t->thread.fpsimd_cpu);
 }
 
-static inline void fpsimd_flush_cpu_state(void)
+void fpsimd_flush_cpu_state(void)
 {
 	__this_cpu_write(fpsimd_last_state.st, NULL);
 }
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 87c4f7a..36d9c2f 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -19,7 +19,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
 kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o
+kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8605e04..797b259 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -27,6 +27,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
+#include <asm/thread_info.h>
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
@@ -47,24 +48,40 @@ bool __hyp_text __fpsimd_enabled(void)
 	return __fpsimd_is_enabled()();
 }
 
-static void __hyp_text __activate_traps_vhe(void)
+static bool update_fp_enabled(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE) {
+		vcpu->arch.host_fpsimd_state = NULL;
+		vcpu->arch.fp_enabled = false;
+	}
+
+	return vcpu->arch.fp_enabled;
+}
+
+static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
-	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
+	val &= ~CPACR_EL1_ZEN;
+	if (!update_fp_enabled(vcpu))
+		val &= ~CPACR_EL1_FPEN;
+
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
 }
 
-static void __hyp_text __activate_traps_nvhe(void)
+static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	val = CPTR_EL2_DEFAULT;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
+	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
+	if (!update_fp_enabled(vcpu))
+		val |= CPTR_EL2_TFP;
+
 	write_sysreg(val, cptr_el2);
 }
 
@@ -111,7 +128,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(0, pmselr_el0);
 	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
-	__activate_traps_arch()();
+	__activate_traps_arch()(vcpu);
 }
 
 static void __hyp_text __deactivate_traps_vhe(void)
@@ -309,7 +326,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
-	bool fp_enabled;
 	u64 exit_code;
 
 	vcpu = kern_hyp_va(vcpu);
@@ -413,8 +429,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	fp_enabled = __fpsimd_enabled();
-
 	__sysreg_save_guest_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
@@ -425,11 +439,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_host_state(host_ctxt);
 
-	if (fp_enabled) {
-		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
-		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
-	}
-
 	__debug_save_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
@@ -443,8 +452,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 				    struct kvm_vcpu *vcpu)
 {
-	kvm_cpu_context_t *host_ctxt;
-
 	if (has_vhe())
 		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
 			     cpacr_el1);
@@ -454,14 +461,19 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 
 	isb();
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
+	if (vcpu->arch.host_fpsimd_state) {
+		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
+		vcpu->arch.host_fpsimd_state = NULL;
+	}
+
 	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(vcpu->arch.ctxt.sys_regs[FPEXC32_EL2],
 			     fpexc32_el2);
+
+	vcpu->arch.fp_enabled = true;
 }
 
 static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index d3af3f4..cf0f457 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -362,10 +362,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_arm_set_running_vcpu(vcpu);
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
+	kvm_arch_vcpu_load_fp(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_arch_vcpu_put_fp(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 
@@ -772,6 +774,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
 			kvm_timer_sync_hwstate(vcpu);
 
+		kvm_arch_vcpu_park_fp(vcpu);
+
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
@@ -816,16 +820,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return ret;
 }
 
-#ifdef CONFIG_ARM64
-int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
-{
-	struct task_struct *tsk = current;
-
-	/* Make sure the host task fpsimd state is visible to hyp: */
-	return create_hyp_mappings(tsk, tsk + 1, PAGE_HYP);
-}
-#endif
-
 static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
 {
 	int bit_index;
-- 
2.1.4
