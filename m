From: Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH v4 03/12] arm64: Remove the ability to build a kernel without
 ssbd
Date: Fri, 25 Jan 2019 12:07:02 -0600
Message-ID: <20190125180711.1970973-4-jeremy.linton@arm.com>
References: <20190125180711.1970973-1-jeremy.linton@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190125180711.1970973-1-jeremy.linton@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: stefan.wahren@i2se.com, mlangsdo@redhat.com, suzuki.poulose@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, julien.thierry@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>, steven.price@arm.com, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, ykaukab@suse.de, dave.martin@arm.com, shankerd@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

Buried behind EXPERT is the ability to build a kernel without
SSBD, this needlessly clutters up the code as well as creates
the opportunity for bugs. It also removes the kernel's ability
to determine if the machine its running on is vulnerable.

Since its also possible to disable it at boot time, lets remove
the config option.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/Kconfig                  | 9 ---------
 arch/arm64/include/asm/cpufeature.h | 8 --------
 arch/arm64/include/asm/kvm_mmu.h    | 7 -------
 arch/arm64/kernel/Makefile          | 3 +--
 arch/arm64/kernel/cpu_errata.c      | 4 ----
 arch/arm64/kernel/cpufeature.c      | 4 ----
 arch/arm64/kernel/entry.S           | 2 --
 arch/arm64/kvm/hyp/hyp-entry.S      | 2 --
 arch/arm64/kvm/hyp/switch.c         | 4 ----
 9 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a4168d366127..0baa632bf0a8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1038,15 +1038,6 @@ config HARDEN_EL2_VECTORS
 
 	  If unsure, say Y.
 
-config ARM64_SSBD
-	bool "Speculative Store Bypass Disable" if EXPERT
-	default y
-	help
-	  This enables mitigation of the bypassing of previous stores
-	  by speculative loads.
-
-	  If unsure, say Y.
-
 config RODATA_FULL_DEFAULT_ENABLED
 	bool "Apply r/o permissions of VM areas also to their linear aliases"
 	default y
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index dfcfba725d72..bbed2067a1a4 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -620,19 +620,11 @@ static inline bool system_supports_generic_auth(void)
 
 static inline int arm64_get_ssbd_state(void)
 {
-#ifdef CONFIG_ARM64_SSBD
 	extern int ssbd_state;
 	return ssbd_state;
-#else
-	return ARM64_SSBD_UNKNOWN;
-#endif
 }
 
-#ifdef CONFIG_ARM64_SSBD
 void arm64_set_ssbd_mitigation(bool state);
-#else
-static inline void arm64_set_ssbd_mitigation(bool state) {}
-#endif
 
 extern int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 8af4b1befa42..a5c152d79820 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -541,7 +541,6 @@ static inline int kvm_map_vectors(void)
 }
 #endif
 
-#ifdef CONFIG_ARM64_SSBD
 DECLARE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
 static inline int hyp_map_aux_data(void)
@@ -558,12 +557,6 @@ static inline int hyp_map_aux_data(void)
 	}
 	return 0;
 }
-#else
-static inline int hyp_map_aux_data(void)
-{
-	return 0;
-}
-#endif
 
 #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
 
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index cd434d0719c1..306336a2fa34 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -19,7 +19,7 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   return_address.o cpuinfo.o cpu_errata.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
 			   smp.o smp_spin_table.o topology.o smccc-call.o	\
-			   syscall.o
+			   syscall.o ssbd.o
 
 extra-$(CONFIG_EFI)			:= efi-entry.o
 
@@ -57,7 +57,6 @@ arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
 obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
 obj-$(CONFIG_CRASH_CORE)		+= crash_core.o
 obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
-obj-$(CONFIG_ARM64_SSBD)		+= ssbd.o
 obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
 
 obj-y					+= vdso/ probes/
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 9a7b5fca51a0..934d50788ca3 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -281,7 +281,6 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
-#ifdef CONFIG_ARM64_SSBD
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
 int ssbd_state __read_mostly = ARM64_SSBD_KERNEL;
@@ -473,7 +472,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	return required;
 }
-#endif	/* CONFIG_ARM64_SSBD */
 
 static void __maybe_unused
 cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
@@ -726,14 +724,12 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(arm64_harden_el2_vectors),
 	},
 #endif
-#ifdef CONFIG_ARM64_SSBD
 	{
 		.desc = "Speculative Store Bypass Disable",
 		.capability = ARM64_SSBD,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = has_ssbd_mitigation,
 	},
-#endif
 #ifdef CONFIG_ARM64_ERRATUM_1188873
 	{
 		/* Cortex-A76 r0p0 to r2p0 */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f6d84e2c92fe..d1a7fd7972f9 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1131,7 +1131,6 @@ static void cpu_has_fwb(const struct arm64_cpu_capabilities *__unused)
 	WARN_ON(val & (7 << 27 | 7 << 21));
 }
 
-#ifdef CONFIG_ARM64_SSBD
 static int ssbs_emulation_handler(struct pt_regs *regs, u32 instr)
 {
 	if (user_mode(regs))
@@ -1171,7 +1170,6 @@ static void cpu_enable_ssbs(const struct arm64_cpu_capabilities *__unused)
 		arm64_set_ssbd_mitigation(true);
 	}
 }
-#endif /* CONFIG_ARM64_SSBD */
 
 #ifdef CONFIG_ARM64_PAN
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
@@ -1400,7 +1398,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64ISAR0_CRC32_SHIFT,
 		.min_field_value = 1,
 	},
-#ifdef CONFIG_ARM64_SSBD
 	{
 		.desc = "Speculative Store Bypassing Safe (SSBS)",
 		.capability = ARM64_SSBS,
@@ -1412,7 +1409,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = ID_AA64PFR1_SSBS_PSTATE_ONLY,
 		.cpu_enable = cpu_enable_ssbs,
 	},
-#endif
 #ifdef CONFIG_ARM64_CNP
 	{
 		.desc = "Common not Private translations",
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 0ec0c46b2c0c..bee54b7d17b9 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -137,7 +137,6 @@ alternative_else_nop_endif
 	// This macro corrupts x0-x3. It is the caller's duty
 	// to save/restore them if required.
 	.macro	apply_ssbd, state, tmp1, tmp2
-#ifdef CONFIG_ARM64_SSBD
 alternative_cb	arm64_enable_wa2_handling
 	b	.L__asm_ssbd_skip\@
 alternative_cb_end
@@ -151,7 +150,6 @@ alternative_cb	arm64_update_smccc_conduit
 	nop					// Patched to SMC/HVC #0
 alternative_cb_end
 .L__asm_ssbd_skip\@:
-#endif
 	.endm
 
 	.macro	kernel_entry, el, regsize = 64
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 73c1b483ec39..53c9344968d4 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -114,7 +114,6 @@ el1_hvc_guest:
 			  ARM_SMCCC_ARCH_WORKAROUND_2)
 	cbnz	w1, el1_trap
 
-#ifdef CONFIG_ARM64_SSBD
 alternative_cb	arm64_enable_wa2_handling
 	b	wa2_end
 alternative_cb_end
@@ -141,7 +140,6 @@ alternative_cb_end
 wa2_end:
 	mov	x2, xzr
 	mov	x1, xzr
-#endif
 
 wa_epilogue:
 	mov	x0, xzr
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index b0b1478094b4..9ce43ae6fc13 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -436,7 +436,6 @@ static inline bool __hyp_text __needs_ssbd_off(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __set_guest_arch_workaround_state(struct kvm_vcpu *vcpu)
 {
-#ifdef CONFIG_ARM64_SSBD
 	/*
 	 * The host runs with the workaround always present. If the
 	 * guest wants it disabled, so be it...
@@ -444,19 +443,16 @@ static void __hyp_text __set_guest_arch_workaround_state(struct kvm_vcpu *vcpu)
 	if (__needs_ssbd_off(vcpu) &&
 	    __hyp_this_cpu_read(arm64_ssbd_callback_required))
 		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, 0, NULL);
-#endif
 }
 
 static void __hyp_text __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
 {
-#ifdef CONFIG_ARM64_SSBD
 	/*
 	 * If the guest has disabled the workaround, bring it back on.
 	 */
 	if (__needs_ssbd_off(vcpu) &&
 	    __hyp_this_cpu_read(arm64_ssbd_callback_required))
 		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, 1, NULL);
-#endif
 }
 
 /* Switch to the guest for VHE systems running in EL2 */
-- 
2.17.2
