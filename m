From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 17/27] arm64/sve: Preserve SVE registers around EFI runtime service calls
Date: Wed,  9 Aug 2017 13:05:23 +0100
Message-ID: <1502280338-23002-18-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The EFI runtime services ABI allows EFI to make free use of the
FPSIMD registers during EFI runtime service calls, subject to the
callee-save requirements of the AArch64 procedure call standard.

However, the SVE architecture allows upper bits of the SVE vector
registers to be zeroed as a side-effect of FPSIMD V-register
writes.  This means that the SVE vector registers must be saved in
their entirety in order to avoid data loss: non-SVE-aware EFI
implementations cannot restore them correctly.

The non-IRQ case is already handled gracefully by
kernel_neon_begin().  For the IRQ case, this patch allocates a
suitable per-CPU stash buffer for the full SVE register state and
uses it to preserve the affected registers around EFI calls.  It is
currently unclear how the EFI runtime services ABI will be
clarified with respect to SVE, so it safest to assume that the
predicate registers and FFR must be saved and restored too.

No attempt is made to restore the restore the vector length after
a call, for now.  It is deemed rather insane for EFI to change it,
and contemporary EFI implementations certainly won't.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 53 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index b7fb836..c727b47 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -120,12 +120,14 @@ int sve_max_vl = -1;
 /* Set of available vector lengths, as vq_to_bit(vq): */
 static DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
 static bool sve_vq_map_finalised;
+static void __percpu *efi_sve_state;
 
 #else /* ! CONFIG_ARM64_SVE */
 
 /* Dummy declaration for code that will be optimised out: */
 extern DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
 extern bool sve_vq_map_finalised;
+extern void __percpu *efi_sve_state;
 
 #endif /* ! CONFIG_ARM64_SVE */
 
@@ -416,6 +418,23 @@ int sve_verify_vq_map(void)
 	return ret;
 }
 
+static void __init sve_kernel_mode_neon_setup(void)
+{
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON))
+		return;
+
+	/*
+	 * alloc_percpu() warns and prints a backtrace if this goes wrong.
+	 * This is evidence of a crippled system and we are returning void,
+	 * so no attempt is made to handle this situation here.
+	 */
+	BUG_ON(!sve_vl_valid(sve_max_vl));
+	efi_sve_state = __alloc_percpu(
+		SVE_SIG_REGS_SIZE(sve_vq_from_vl(sve_max_vl)), 16);
+	if (!efi_sve_state)
+		panic("Cannot allocate percpu memory for EFI SVE save/restore");
+}
+
 void __init sve_setup(void)
 {
 	u64 zcr;
@@ -455,6 +474,8 @@ void __init sve_setup(void)
 		sve_max_vl);
 	pr_info("SVE: default vector length %u bytes per vector\n",
 		sve_default_vl);
+
+	sve_kernel_mode_neon_setup();
 }
 
 void fpsimd_release_thread(struct task_struct *dead_task)
@@ -797,6 +818,7 @@ EXPORT_SYMBOL(kernel_neon_end);
 
 DEFINE_PER_CPU(struct fpsimd_state, efi_fpsimd_state);
 DEFINE_PER_CPU(bool, efi_fpsimd_state_used);
+DEFINE_PER_CPU(bool, efi_sve_state_used);
 
 /*
  * EFI runtime services support functions
@@ -825,7 +847,20 @@ void __efi_fpsimd_begin(void)
 	if (may_use_simd())
 		kernel_neon_begin();
 	else {
-		fpsimd_save_state(this_cpu_ptr(&efi_fpsimd_state));
+		/*
+		 * If !efi_sve_state, SVE can't be in use yet and doesn't need
+		 * preserving:
+		 */
+		if (system_supports_sve() && likely(efi_sve_state)) {
+			char *sve_state = this_cpu_ptr(efi_sve_state);
+
+			__this_cpu_write(efi_sve_state_used, true);
+
+			sve_save_state(sve_state + sve_ffr_offset(sve_max_vl),
+				       &this_cpu_ptr(&efi_fpsimd_state)->fpsr);
+		} else
+			fpsimd_save_state(this_cpu_ptr(&efi_fpsimd_state));
+
 		__this_cpu_write(efi_fpsimd_state_used, true);
 	}
 }
@@ -838,10 +873,20 @@ void __efi_fpsimd_end(void)
 	if (!system_supports_fpsimd())
 		return;
 
-	if (__this_cpu_xchg(efi_fpsimd_state_used, false))
-		fpsimd_load_state(this_cpu_ptr(&efi_fpsimd_state));
-	else
+	if (!__this_cpu_xchg(efi_fpsimd_state_used, false))
 		kernel_neon_end();
+	else
+		if (system_supports_sve() &&
+		    likely(__this_cpu_read(efi_sve_state_used))) {
+			char const *sve_state = this_cpu_ptr(efi_sve_state);
+
+			sve_load_state(sve_state + sve_ffr_offset(sve_max_vl),
+				       &this_cpu_ptr(&efi_fpsimd_state)->fpsr,
+				       sve_vq_from_vl(sve_get_vl()) - 1);
+
+			__this_cpu_write(efi_sve_state_used, false);
+		} else
+			fpsimd_load_state(this_cpu_ptr(&efi_fpsimd_state));
 }
 
 #endif /* CONFIG_KERNEL_MODE_NEON */
-- 
2.1.4
