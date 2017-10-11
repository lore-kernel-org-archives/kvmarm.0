From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v2 1/3] arm64: mm: Support Common Not Private translations
Date: Wed, 11 Oct 2017 13:19:53 +0100
Message-ID: <1507724395-13735-2-git-send-email-vladimir.murzin@arm.com>
References: <1507724395-13735-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB7D49D6D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 08:19:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0dYsx1dB8fBk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 08:19:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE2E949D41
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 08:19:30 -0400 (EDT)
In-Reply-To: <1507724395-13735-1-git-send-email-vladimir.murzin@arm.com>
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
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, kbuild-all@01.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Common Not Private (CNP) is a feature of ARMv8.2 extension which
allows translation table entries to be shared between different PEs in
the same inner shareable domain, so the hardware can use this fact to
optimise the caching of such entries in the TLB.

CNP occupies one bit in TTBRx_ELy and VTTBR_EL2, which advertises to
the hardware that the translation table entries pointed to by this
TTBR are the same as every PE in the same inner shareable domain for
which the equivalent TTBR also has CNP bit set. In case CNP bit is set
but TTBR does not point at the same translation table entries or a
given ASID and VMID, then the system is mis-configured, so the results
of translations are UNPREDICTABLE.

This patch adds support for Common Not Private translations on
different exceptions levels:

(1) For EL0 there are a few cases we need to care of changes in
    TTBR0_EL1:
    - a switch to idmap
    - software emulated PAN
    we rule out latter via Kconfig options and for the former we make
    sure that CNP is set for non-zero ASIDs only.

(2) For EL1 we postpone setting CNP till all cpus are up and rely on
    cpufeature framework to 1) patch the code which is sensitive to
    CNP and 2) update TTBR1_EL1 with CNP bit set. TTBR1_EL1 can be
    reprogrammed as result of hibernation or cpuidle (via __enable_mmu).
    cpuidle's path has been changed to restore CnP and for hibernation
    the code has been changed to save raw TTBR1_EL1 and blindly restore
    it on resume.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/Kconfig                     | 14 ++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/cpufeature.h    |  6 ++++++
 arch/arm64/include/asm/mmu_context.h   | 12 ++++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h |  2 ++
 arch/arm64/kernel/cpufeature.c         | 19 +++++++++++++++++++
 arch/arm64/kernel/hibernate.c          |  2 +-
 arch/arm64/kernel/suspend.c            |  3 +++
 arch/arm64/mm/proc.S                   |  5 +++++
 9 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0df64a6..c8ab280 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -973,6 +973,20 @@ config ARM64_PMEM
 	  operations if DC CVAP is not supported (following the behaviour of
 	  DC CVAP itself if the system does not define a point of persistence).
 
+config ARM64_CNP
+	bool "Enable support for Common Not Private (CNP) translations"
+	depends on ARM64_PAN || !ARM64_SW_TTBR0_PAN
+	default y
+	help
+	  Common Not Private (CNP) allows translation table entries to
+	  be shared between different PEs in the same inner shareable
+	  domain, so the hardware can use this fact to optimise the
+	  caching of such entries in the TLB.
+
+	  Selecting this option allows the CNP feature to be detected
+	  at runtime, and does not affect PEs that do not implement
+	  this feature.
+
 endmenu
 
 config ARM64_MODULE_CMODEL_LARGE
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8da6216..9b7d94c 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -40,7 +40,8 @@
 #define ARM64_WORKAROUND_858921			19
 #define ARM64_WORKAROUND_CAVIUM_30115		20
 #define ARM64_HAS_DCPOP				21
+#define ARM64_HAS_CNP				22
 
-#define ARM64_NCAPS				22
+#define ARM64_NCAPS				23
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 428ee1f..f7c75ac 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -262,6 +262,12 @@ static inline bool system_uses_ttbr0_pan(void)
 		!cpus_have_const_cap(ARM64_HAS_PAN);
 }
 
+static inline bool system_supports_cnp(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_CNP) &&
+		cpus_have_const_cap(ARM64_HAS_CNP);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 3257895a..8e78a51 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -135,6 +135,18 @@ static inline void cpu_replace_ttbr1(pgd_t *pgd)
 
 	phys_addr_t pgd_phys = virt_to_phys(pgd);
 
+	if (system_supports_cnp() && !WARN_ON(pgd != lm_alias(swapper_pg_dir))) {
+		/*
+		 * cpu_replace_ttbr1() is used when there's a boot CPU
+		 * up (i.e. cpufeature framework is not up yet) and
+		 * latter only when we enable CNP via cpufeature's
+		 * enable() callback.
+                 * Also we rely on the cpu_hwcap bit being set before
+		 * calling the enable() function.
+		 */
+		pgd_phys |= TTBR_CNP_BIT;
+	}
+
 	replace_phys = (void *)__pa_symbol(idmap_cpu_replace_ttbr1);
 
 	cpu_install_idmap();
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index eb0c2bd..59247e7 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -199,6 +199,8 @@
 #define PHYS_MASK_SHIFT		(48)
 #define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
 
+#define TTBR_CNP_BIT		(UL(1) << 0)
+
 /*
  * TCR flags.
  */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 21e2c95..83809a8 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -101,6 +101,7 @@ EXPORT_SYMBOL(cpu_hwcap_keys);
 static bool __maybe_unused
 cpufeature_pan_not_uao(const struct arm64_cpu_capabilities *entry, int __unused);
 
+static int cpu_enable_cnp(void *__unused);
 
 /*
  * NOTE: Any changes to the visibility of features should be kept in
@@ -898,6 +899,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sys_reg = SYS_ID_AA64ISAR1_EL1,
 		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
 		.min_field_value = 1,
+#endif
+#ifdef CONFIG_ARM64_CNP
+	{
+		.desc = "Common not Private translations",
+		.capability = ARM64_HAS_CNP,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_CNP_SHIFT,
+		.min_field_value = 1,
+		.enable = cpu_enable_cnp,
 	},
 #endif
 	{},
@@ -1211,6 +1224,12 @@ cpufeature_pan_not_uao(const struct arm64_cpu_capabilities *entry, int __unused)
 	return (cpus_have_const_cap(ARM64_HAS_PAN) && !cpus_have_const_cap(ARM64_HAS_UAO));
 }
 
+static int __maybe_unused cpu_enable_cnp(void *__unused)
+{
+	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+	return 0;
+}
+
 /*
  * We emulate only the following system register space.
  * Op0 = 0x3, CRn = 0x0, Op1 = 0x0, CRm = [0, 4 - 7]
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 095d3c1..1d056f3 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -124,7 +124,7 @@ int arch_hibernation_header_save(void *addr, unsigned int max_size)
 		return -EOVERFLOW;
 
 	arch_hdr_invariants(&hdr->invariants);
-	hdr->ttbr1_el1		= __pa_symbol(swapper_pg_dir);
+	hdr->ttbr1_el1		= read_sysreg(ttbr1_el1);
 	hdr->reenter_kernel	= _cpu_resume;
 
 	/* We can't use __hyp_get_vectors() because kvm may still be loaded */
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 1e3be90..f28c44a 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -46,6 +46,9 @@ void notrace __cpu_suspend_exit(void)
 	 */
 	cpu_uninstall_idmap();
 
+	/* Restore CnP bit in TTBR1_EL1 */
+	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));
+
 	/*
 	 * PSTATE was not saved over suspend/resume, re-enable any detected
 	 * features that might not have been set correctly.
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 877d42f..d5b9f6b 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -141,6 +141,11 @@ ENTRY(cpu_do_switch_mm)
 	pre_ttbr0_update_workaround x0, x2, x3
 	mmid	x1, x1				// get mm->context.id
 	bfi	x0, x1, #48, #16		// set the ASID
+alternative_if ARM64_HAS_CNP
+	cbz	x1, 1f                          // skip CNP for ASID == 0
+	orr	x0, x0, #TTBR_CNP_BIT
+1:
+alternative_else_nop_endif
 	msr	ttbr0_el1, x0			// set TTBR0
 	isb
 	post_ttbr0_update_workaround
-- 
2.0.0
