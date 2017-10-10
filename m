From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v3 22/28] arm64/sve: KVM: Prevent guests from using SVE
Date: Tue, 10 Oct 2017 19:38:39 +0100
Message-ID: <1507660725-7986-23-git-send-email-Dave.Martin@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Until KVM has full SVE support, guests must not be allowed to
execute SVE instructions.

This patch enables the necessary traps, and also ensures that the
traps are disabled again on exit from the guest so that the host
can still use SVE if it wants to.

This patch introduces another instance of
__this_cpu_write(fpsimd_last_state, NULL), so this flush operation
is abstracted out as a separate helper fpsimd_flush_cpu_state().
Other instances are ported appropriately.

As a side effect of this refactoring, a this_cpu_write() in
fpsimd_cpu_pm_notifier() is changed to __this_cpu_write().  This
should be fine, since cpu_pm_enter() is supposed to be called only
with interrupts disabled.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   |  3 +++
 arch/arm64/include/asm/fpsimd.h   |  1 +
 arch/arm64/include/asm/kvm_arm.h  |  4 +++-
 arch/arm64/include/asm/kvm_host.h | 11 +++++++++++
 arch/arm64/kernel/fpsimd.c        | 31 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/switch.c       |  6 +++---
 virt/kvm/arm/arm.c                |  3 +++
 7 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 4a879f6..242151e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -293,4 +293,7 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
+/* All host FP/SIMD state is restored on guest exit, so nothing to save: */
+static inline void kvm_fpsimd_flush_cpu_state(void) {}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 3cfdfbe..10b2824 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -75,6 +75,7 @@ extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct fpsimd_state *state);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
+extern void sve_flush_cpu_state(void);
 
 /* Maximum VL that SVE VL-agnostic software can transparently support */
 #define SVE_VL_ARCH_MAX 0x100
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index dbf0537..7f069ff 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -186,7 +186,8 @@
 #define CPTR_EL2_TTA	(1 << 20)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
 #define CPTR_EL2_TZ	(1 << 8)
-#define CPTR_EL2_DEFAULT	0x000033ff
+#define CPTR_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 */
+#define CPTR_EL2_DEFAULT	CPTR_EL2_RES1
 
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_TPMS		(1 << 14)
@@ -237,5 +238,6 @@
 
 #define CPACR_EL1_FPEN		(3 << 20)
 #define CPACR_EL1_TTA		(1 << 28)
+#define CPACR_EL1_DEFAULT	(CPACR_EL1_FPEN | CPACR_EL1_ZEN_EL1EN)
 
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e923b58..674912d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -25,6 +25,7 @@
 #include <linux/types.h>
 #include <linux/kvm_types.h>
 #include <asm/cpufeature.h>
+#include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
@@ -384,4 +385,14 @@ static inline void __cpu_init_stage2(void)
 		  "PARange is %d bits, unsupported configuration!", parange);
 }
 
+/*
+ * All host FP/SIMD state is restored on guest exit, so nothing needs
+ * doing here except in the SVE case:
+*/
+static inline void kvm_fpsimd_flush_cpu_state(void)
+{
+	if (system_supports_sve())
+		sve_flush_cpu_state();
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index a9cb794..6ae3703 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1073,6 +1073,33 @@ void fpsimd_flush_task_state(struct task_struct *t)
 	t->thread.fpsimd_state.cpu = NR_CPUS;
 }
 
+static inline void fpsimd_flush_cpu_state(void)
+{
+	__this_cpu_write(fpsimd_last_state, NULL);
+}
+
+/*
+ * Invalidate any task SVE state currently held in this CPU's regs.
+ *
+ * This is used to prevent the kernel from trying to reuse SVE register data
+ * that is detroyed by KVM guest enter/exit.  This function should go away when
+ * KVM SVE support is implemented.  Don't use it for anything else.
+ */
+#ifdef CONFIG_ARM64_SVE
+void sve_flush_cpu_state(void)
+{
+	struct fpsimd_state *const fpstate = __this_cpu_read(fpsimd_last_state);
+	struct task_struct *tsk;
+
+	if (!fpstate)
+		return;
+
+	tsk = container_of(fpstate, struct task_struct, thread.fpsimd_state);
+	if (test_tsk_thread_flag(tsk, TIF_SVE))
+		fpsimd_flush_cpu_state();
+}
+#endif /* CONFIG_ARM64_SVE */
+
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 DEFINE_PER_CPU(bool, kernel_neon_busy);
@@ -1113,7 +1140,7 @@ void kernel_neon_begin(void)
 	}
 
 	/* Invalidate any task state remaining in the fpsimd regs: */
-	__this_cpu_write(fpsimd_last_state, NULL);
+	fpsimd_flush_cpu_state();
 
 	preempt_disable();
 
@@ -1234,7 +1261,7 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
 	case CPU_PM_ENTER:
 		if (current->mm)
 			task_fpsimd_save();
-		this_cpu_write(fpsimd_last_state, NULL);
+		fpsimd_flush_cpu_state();
 		break;
 	case CPU_PM_EXIT:
 		if (current->mm)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 35a90b8..951f3eb 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -48,7 +48,7 @@ static void __hyp_text __activate_traps_vhe(void)
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
-	val &= ~CPACR_EL1_FPEN;
+	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(__kvm_hyp_vector, vbar_el1);
@@ -59,7 +59,7 @@ static void __hyp_text __activate_traps_nvhe(void)
 	u64 val;
 
 	val = CPTR_EL2_DEFAULT;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TFP;
+	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
 	write_sysreg(val, cptr_el2);
 }
 
@@ -117,7 +117,7 @@ static void __hyp_text __deactivate_traps_vhe(void)
 
 	write_sysreg(mdcr_el2, mdcr_el2);
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
-	write_sysreg(CPACR_EL1_FPEN, cpacr_el1);
+	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 	write_sysreg(vectors, vbar_el1);
 }
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b9f68e4..4d3cf9c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -652,6 +652,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		preempt_disable();
 
+		/* Flush FP/SIMD state that can't survive guest entry/exit */
+		kvm_fpsimd_flush_cpu_state();
+
 		kvm_pmu_flush_hwstate(vcpu);
 
 		kvm_timer_flush_hwstate(vcpu);
-- 
2.1.4
