From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 2/2] arm64: Support systems without FP/ASIMD
Date: Tue,  8 Nov 2016 13:56:21 +0000
Message-ID: <1478613381-5718-3-git-send-email-suzuki.poulose@arm.com>
References: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D53FB4029D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 08:56:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pmqpeKdADwfB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2016 08:56:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D5474019C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2016 08:56:24 -0500 (EST)
In-Reply-To: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The arm64 kernel assumes that FP/ASIMD units are always present
and accesses the FP/ASIMD specific registers unconditionally. This
could cause problems when they are absent. This patch adds the
support for kernel handling systems without FP/ASIMD by skipping the
register access within the kernel. For kvm, we trap the accesses
to FP/ASIMD and inject an undefined instruction exception to the VM.

The callers of the exported kernel_neon_begin_partial() should
make sure that the FP/ASIMD is supported.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/cpufeature.h |  5 +++++
 arch/arm64/include/asm/neon.h       |  3 ++-
 arch/arm64/kernel/cpufeature.c      | 15 +++++++++++++++
 arch/arm64/kernel/fpsimd.c          | 14 ++++++++++++++
 arch/arm64/kvm/handle_exit.c        | 11 +++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S      |  9 ++++++++-
 arch/arm64/kvm/hyp/switch.c         |  5 ++++-
 8 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 87b4465..4174f09 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -34,7 +34,8 @@
 #define ARM64_HAS_32BIT_EL0			13
 #define ARM64_HYP_OFFSET_LOW			14
 #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
+#define ARM64_HAS_NO_FPSIMD			16
 
-#define ARM64_NCAPS				16
+#define ARM64_NCAPS				17
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 9890d20..ce45770 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -213,6 +213,11 @@ static inline bool system_supports_mixed_endian_el0(void)
 	return id_aa64mmfr0_mixed_endian_el0(read_system_reg(SYS_ID_AA64MMFR0_EL1));
 }
 
+static inline bool system_supports_fpsimd(void)
+{
+	return !cpus_have_const_cap(ARM64_HAS_NO_FPSIMD);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/include/asm/neon.h b/arch/arm64/include/asm/neon.h
index 13ce4cc..ad4cdc9 100644
--- a/arch/arm64/include/asm/neon.h
+++ b/arch/arm64/include/asm/neon.h
@@ -9,8 +9,9 @@
  */
 
 #include <linux/types.h>
+#include <asm/fpsimd.h>
 
-#define cpu_has_neon()		(1)
+#define cpu_has_neon()		system_supports_fpsimd()
 
 #define kernel_neon_begin()	kernel_neon_begin_partial(32)
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index fc2bd19..f89385d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -746,6 +746,14 @@ static bool hyp_offset_low(const struct arm64_cpu_capabilities *entry,
 	return idmap_addr > GENMASK(VA_BITS - 2, 0) && !is_kernel_in_hyp_mode();
 }
 
+static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unused)
+{
+	u64 pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
+
+	return cpuid_feature_extract_signed_field(pfr0,
+					ID_AA64PFR0_FP_SHIFT) < 0;
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -829,6 +837,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.def_scope = SCOPE_SYSTEM,
 		.matches = hyp_offset_low,
 	},
+	{
+		/* FP/SIMD is not implemented */
+		.capability = ARM64_HAS_NO_FPSIMD,
+		.def_scope = SCOPE_SYSTEM,
+		.min_field_value = 0,
+		.matches = has_no_fpsimd,
+	},
 	{},
 };
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 394c61d..b883f1f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -127,6 +127,8 @@ void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
 
 void fpsimd_thread_switch(struct task_struct *next)
 {
+	if (!system_supports_fpsimd())
+		return;
 	/*
 	 * Save the current FPSIMD state to memory, but only if whatever is in
 	 * the registers is in fact the most recent userland FPSIMD state of
@@ -157,6 +159,8 @@ void fpsimd_thread_switch(struct task_struct *next)
 
 void fpsimd_flush_thread(void)
 {
+	if (!system_supports_fpsimd())
+		return;
 	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
 	fpsimd_flush_task_state(current);
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
@@ -168,6 +172,8 @@ void fpsimd_flush_thread(void)
  */
 void fpsimd_preserve_current_state(void)
 {
+	if (!system_supports_fpsimd())
+		return;
 	preempt_disable();
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE))
 		fpsimd_save_state(&current->thread.fpsimd_state);
@@ -181,6 +187,8 @@ void fpsimd_preserve_current_state(void)
  */
 void fpsimd_restore_current_state(void)
 {
+	if (!system_supports_fpsimd())
+		return;
 	preempt_disable();
 	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
 		struct fpsimd_state *st = &current->thread.fpsimd_state;
@@ -199,6 +207,8 @@ void fpsimd_restore_current_state(void)
  */
 void fpsimd_update_current_state(struct fpsimd_state *state)
 {
+	if (!system_supports_fpsimd())
+		return;
 	preempt_disable();
 	fpsimd_load_state(state);
 	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
@@ -228,6 +238,8 @@ static DEFINE_PER_CPU(struct fpsimd_partial_state, softirq_fpsimdstate);
  */
 void kernel_neon_begin_partial(u32 num_regs)
 {
+	if (WARN_ON(!system_supports_fpsimd()))
+		return;
 	if (in_interrupt()) {
 		struct fpsimd_partial_state *s = this_cpu_ptr(
 			in_irq() ? &hardirq_fpsimdstate : &softirq_fpsimdstate);
@@ -252,6 +264,8 @@ EXPORT_SYMBOL(kernel_neon_begin_partial);
 
 void kernel_neon_end(void)
 {
+	if (!system_supports_fpsimd())
+		return;
 	if (in_interrupt()) {
 		struct fpsimd_partial_state *s = this_cpu_ptr(
 			in_irq() ? &hardirq_fpsimdstate : &softirq_fpsimdstate);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index a204adf..1bfe30d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -57,6 +57,16 @@ static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
+/*
+ * Guest access to FP/ASIMD registers are routed to this handler only
+ * when the system doesn't support FP/ASIMD.
+ */
+static int handle_no_fpsimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
 /**
  * kvm_handle_wfx - handle a wait-for-interrupts or wait-for-event
  *		    instruction executed by a guest
@@ -144,6 +154,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_BREAKPT_LOW]= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
+	[ESR_ELx_EC_FP_ASIMD]	= handle_no_fpsimd,
 };
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 4e92399..5e9052f 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -106,9 +106,16 @@ el1_trap:
 	 * x0: ESR_EC
 	 */
 
-	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
+	/*
+	 * We trap the first access to the FP/SIMD to save the host context
+	 * and restore the guest context lazily.
+	 * If FP/SIMD is not implemented, handle the trap and inject an
+	 * undefined instruction exception to the guest.
+	 */
+alternative_if_not ARM64_HAS_NO_FPSIMD
 	cmp	x0, #ESR_ELx_EC_FP_ASIMD
 	b.eq	__fpsimd_guest_restore
+alternative_else_nop_endif
 
 	mrs	x1, tpidr_el2
 	mov	x0, #ARM_EXCEPTION_TRAP
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 83037cd..8bcae7b 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -21,6 +21,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/fpsimd.h>
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
@@ -76,9 +77,11 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	 * traps are only taken to EL2 if the operation would not otherwise
 	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
 	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
+	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
+	 * it will cause an exception.
 	 */
 	val = vcpu->arch.hcr_el2;
-	if (!(val & HCR_RW)) {
+	if (!(val & HCR_RW) && system_supports_fpsimd()) {
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
-- 
2.7.4
