From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 2/2] arm64: Support systems without FP/ASIMD
Date: Tue, 25 Oct 2016 14:50:33 +0100
Message-ID: <1477403433-2279-3-git-send-email-suzuki.poulose@arm.com>
References: <1477403433-2279-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B26140EA9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2016 09:51:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 02BZYFDGCRaR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Oct 2016 09:51:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DF1940C59
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2016 09:51:10 -0400 (EDT)
In-Reply-To: <1477403433-2279-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The arm64 kernel assumes that FP/ASIMD units are always present
and accesses the FP/ASIMD specific registers unconditionally. This
could cause problems when they are absent. This patch adds the
support for kernel handling systems without FP/ASIMD by skipping the
register access within the kernel. For kvm, we trap the accesses
to FP/ASIMD and inject an undefined instruction exception to the VM.

The callers of the exported kernel_neon_begin_parital() should
make sure that the FP/ASIMD is supported.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
---
 arch/arm64/crypto/aes-ce-ccm-glue.c |  2 +-
 arch/arm64/crypto/aes-ce-cipher.c   |  2 ++
 arch/arm64/crypto/ghash-ce-glue.c   |  2 ++
 arch/arm64/crypto/sha1-ce-glue.c    |  2 ++
 arch/arm64/include/asm/cpufeature.h |  8 +++++++-
 arch/arm64/include/asm/neon.h       |  3 ++-
 arch/arm64/kernel/cpufeature.c      | 15 +++++++++++++++
 arch/arm64/kernel/fpsimd.c          | 14 ++++++++++++++
 arch/arm64/kvm/handle_exit.c        | 11 +++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S      |  9 ++++++++-
 arch/arm64/kvm/hyp/switch.c         |  5 ++++-
 11 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index f4bf2f2..d001b4e 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -296,7 +296,7 @@ static struct aead_alg ccm_aes_alg = {
 
 static int __init aes_mod_init(void)
 {
-	if (!(elf_hwcap & HWCAP_AES))
+	if (!(elf_hwcap & HWCAP_AES) || !system_supports_fpsimd())
 		return -ENODEV;
 	return crypto_register_aead(&ccm_aes_alg);
 }
diff --git a/arch/arm64/crypto/aes-ce-cipher.c b/arch/arm64/crypto/aes-ce-cipher.c
index f7bd9bf..1a43be2 100644
--- a/arch/arm64/crypto/aes-ce-cipher.c
+++ b/arch/arm64/crypto/aes-ce-cipher.c
@@ -253,6 +253,8 @@ static struct crypto_alg aes_alg = {
 
 static int __init aes_mod_init(void)
 {
+	if (!system_supports_fpsimd())
+		return -ENODEV;
 	return crypto_register_alg(&aes_alg);
 }
 
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 833ec1e..2bc518d 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -144,6 +144,8 @@ static struct shash_alg ghash_alg = {
 
 static int __init ghash_ce_mod_init(void)
 {
+	if (!system_supports_fpsimd())
+		return -ENODEV;
 	return crypto_register_shash(&ghash_alg);
 }
 
diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index aefda98..9f3427a 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -102,6 +102,8 @@ static struct shash_alg alg = {
 
 static int __init sha1_ce_mod_init(void)
 {
+	if (!system_supports_fpsimd())
+		return -ENODEV;
 	return crypto_register_shash(&alg);
 }
 
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ae5e994..63d739c 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -38,8 +38,9 @@
 #define ARM64_HAS_32BIT_EL0			13
 #define ARM64_HYP_OFFSET_LOW			14
 #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
+#define ARM64_HAS_NO_FPSIMD			16
 
-#define ARM64_NCAPS				16
+#define ARM64_NCAPS				17
 
 #ifndef __ASSEMBLY__
 
@@ -236,6 +237,11 @@ static inline bool system_supports_mixed_endian_el0(void)
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
index d577f26..8f22544 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -744,6 +744,14 @@ static bool hyp_offset_low(const struct arm64_cpu_capabilities *entry,
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
@@ -827,6 +835,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
index 975b274..80da5aa 100644
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
index fa96fe2..39e055a 100644
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
index f6d9694..16167d7 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -117,9 +117,16 @@ el1_trap:
 	 * x2: ESR_EC
 	 */
 
-	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
+	/*
+	 * We trap the first access to the FP/SIMD to save the host context
+	 * and restore the guest context lazily.
+	 * If FP/SIMD is not implemented, handle the trap and inject an
+	 * undefined instruction exception to the guest.
+	 */
+alternative_if_not ARM64_HAS_NO_FPSIMD
 	cmp	x2, #ESR_ELx_EC_FP_ASIMD
 	b.eq	__fpsimd_guest_restore
+alternative_else_nop_endif
 
 	mrs	x0, tpidr_el2
 	mov	x1, #ARM_EXCEPTION_TRAP
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index ae7855f..f2d0c4f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/fpsimd.h>
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
@@ -73,9 +74,11 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
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
