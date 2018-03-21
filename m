From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 4/4] KVM: arm64: Optimise FPSIMD context switching
Date: Wed, 21 Mar 2018 17:47:33 +0000
Message-ID: <1521654453-3837-5-git-send-email-Dave.Martin@arm.com>
References: <1521654453-3837-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 835264A05F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Mar 2018 13:40:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IIBho-HsDA4Y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Mar 2018 13:39:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 254124A036
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Mar 2018 13:39:52 -0400 (EDT)
In-Reply-To: <1521654453-3837-1-git-send-email-Dave.Martin@arm.com>
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

Currently, the optimisations to move most of the KVM save/restore
logic to vcpu_load()/vcpu_put() don't work for FPSIMD, so the host
and guest FPSIMD state must be saved/restored rather deep in the
guest entry code, in the local_irq_disable() region.  This avoids
some nasty interactions with kernel-mode NEON, which might
otherwise corrupt the registers since it may use them any time that
softirqs are enabled: blocking softirqs and/or kernel-mode NEON use
throughout the KVM run loop is not considered acceptable as a
solution for this.

This results in some unnecessary work, and extension to interrupt
blackout times around guest entry/exit.  These issues will tend to
worsen when full SVE support is added to KVM, due to the
corresponding increase in the amount of register state that may
need to be switched.

This patch attempts to improve the situation by giving hyp and the
host FPSIMD context handling code some visibility of each other.

TIF_FOREIGN_FPSTATE, TIF_SVE and fpsimd_last_state_struct now
equally describe the host or vcpu context, so that kernel-mode NEON
can transparently save state in the correct place
(__this_cpu_read(fpsimd_last_state.st)) and signal that the
registers have been corrupted (via setting TIF_FOREIGN_FPSTATE).
Hyp is also taught how to use the same bookkeeping mechanism to
save the host context in the correct place when preparing to load
the vcpu FPSIMD state during an FPSIMD access trap, and the
required host task data (thread flags and user_fpsimd_state data)
is mapped to hyp as appropriate in order to enable this to work.

An additional vcpu flag vcpu->arch.fp_enabled is added to indicate
that the "current" FPSIMD context (as described by the above
bookkeeping data) is the vcpu's state, as opposed to the host's.

On entry via vcpu_load(), fp_enabled is initially false, indicating
that the hosts's FPSIMD state (or possibly garbage) remains in the
FPSIMD regs.  On taking an FPSIMD trap to hyp, the host's state is
saved if required, the vcpu's state is loaded and fp_enabled is
set.  On return to the KVM run loop, this flag is checked to update
the bookkeeping data appropriately before exposing it to the host
kernel by enabling interrupts.

fp_enabled and TIF_FOREIGN_FPSTATE need to be rechecked on each
guest entry, in order to determine whether to trap FPSIMD while in
the guest.  This is how reload of the guest's state is guaranteed
after the registers are corrupted by kernel-mode NEON in a softirq.

Currently SVE is not supported for guests, so TIF_SVE is simply
cleared when loading the guest's state.  A flag
vcpu->arch.host_sve_in_use is added to back up the state of this
flag while the guest's state is loaded.

In vcpu_put() it is necessary to tidy up so that there is no stray
guest state in the registers before the host context switch code
takes over: if fp_enabled was set, then the vcpu's FPSIMD state is
saved back to the vcpu struct and the register content is
invalidated.  TIF_SVE is restored from the backed-up value in
host_sve_in_use.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/fpsimd.h   |  5 ++++
 arch/arm64/include/asm/kvm_host.h |  7 +++++
 arch/arm64/kernel/fpsimd.c        | 24 ++++++++++++-----
 arch/arm64/kvm/hyp/switch.c       | 44 +++++++++++++++++++------------
 virt/kvm/arm/arm.c                | 54 ++++++++++++++++++++++++++++++++++++---
 5 files changed, 108 insertions(+), 26 deletions(-)

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
index 596f8e4..56c60ff 100644
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
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index c4be311..8e7dffc 100644
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
@@ -1067,7 +1079,7 @@ void fpsimd_flush_task_state(struct task_struct *t)
 	fpsimd_flush_state(&t->thread.fpsimd_cpu);
 }
 
-static inline void fpsimd_flush_cpu_state(void)
+void fpsimd_flush_cpu_state(void)
 {
 	__this_cpu_write(fpsimd_last_state.st, NULL);
 }
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 01e4254..c177534 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -27,6 +27,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
+#include <asm/thread_info.h>
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
@@ -47,24 +48,38 @@ bool __hyp_text __fpsimd_enabled(void)
 	return __fpsimd_is_enabled()();
 }
 
-static void __hyp_text __activate_traps_vhe(void)
+static bool update_fp_enabled(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
+		vcpu->arch.fp_enabled = false;
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
 
@@ -107,7 +122,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(0, pmselr_el0);
 	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
-	__activate_traps_arch()();
+	__activate_traps_arch()(vcpu);
 }
 
 static void __hyp_text __deactivate_traps_vhe(void)
@@ -305,7 +320,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
-	bool fp_enabled;
 	u64 exit_code;
 
 	vcpu = kern_hyp_va(vcpu);
@@ -409,8 +423,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	fp_enabled = __fpsimd_enabled();
-
 	__sysreg_save_guest_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
@@ -421,11 +433,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_host_state(host_ctxt);
 
-	if (fp_enabled) {
-		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
-		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
-	}
-
 	__debug_save_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
@@ -439,8 +446,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 				    struct kvm_vcpu *vcpu)
 {
-	kvm_cpu_context_t *host_ctxt;
-
 	if (has_vhe())
 		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
 			     cpacr_el1);
@@ -450,14 +455,19 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
 
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
index 02a153a..2c69def 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -48,6 +48,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/sections.h>
+#include <asm/thread_info.h>
 
 #ifdef REQUIRES_VIRT
 __asm__(".arch_extension	virt");
@@ -359,6 +360,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->cpu = cpu;
 	vcpu->arch.host_cpu_context = this_cpu_ptr(&kvm_host_cpu_state);
 
+	BUG_ON(system_supports_sve());
+	BUG_ON(!current->mm);
+
+	vcpu->arch.fp_enabled = false;
+	vcpu->arch.host_fpsimd_state =
+		kern_hyp_va(&current->thread.fpsimd_state);
+	vcpu->arch.host_sve_in_use = !!test_thread_flag(TIF_SVE);
+
 	kvm_arm_set_running_vcpu(vcpu);
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
@@ -371,6 +380,21 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	vcpu->cpu = -1;
 
+	local_bh_disable();
+
+	if (vcpu->arch.fp_enabled) {
+		task_fpsimd_save();
+		fpsimd_flush_cpu_state();
+		set_thread_flag(TIF_FOREIGN_FPSTATE);
+	}
+
+	if (vcpu->arch.host_sve_in_use)
+		set_thread_flag(TIF_SVE);
+	else
+		clear_thread_flag(TIF_SVE);
+
+	local_bh_enable();
+
 	kvm_arm_set_running_vcpu(NULL);
 }
 
@@ -778,6 +802,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
 			kvm_timer_sync_hwstate(vcpu);
 
+		if (vcpu->arch.fp_enabled) {
+			fpsimd_bind_state_to_cpu(
+				&vcpu->arch.ctxt.gp_regs.fp_regs);
+			clear_thread_flag(TIF_FOREIGN_FPSTATE);
+			clear_thread_flag(TIF_SVE);
+		}
+
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
@@ -825,10 +856,27 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 #ifdef CONFIG_ARM64
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 {
-	struct task_struct *tsk = current;
+	int ret;
+
+	struct thread_info *ti = &current->thread_info;
+	struct user_fpsimd_state *fpsimd = &current->thread.fpsimd_state;
 
-	/* Make sure the host task fpsimd state is visible to hyp: */
-	return create_hyp_mappings(tsk, tsk + 1, PAGE_HYP);
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
 }
 #endif
 
-- 
2.1.4
