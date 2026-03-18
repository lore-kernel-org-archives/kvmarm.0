Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B6A363C43
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 19:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773861570; cv=none; b=B6bHmOVTWAmUwUs7YkOzZ0zJUxEiVNG1EsGCD7fPMe0Z/d+M2znX4rj/1RHLWAs6Mo+n+DZw9QfF0oawMkHsz9dHsNEnxAZJrO0LnCb7tT7fl/Q0uHMXlZ0Pc+KLshgFwWgOTqm3oOAzZ1coZrJBtbY+2OevWAqBJ4I64lC43Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773861570; c=relaxed/simple;
	bh=WZDQadtYZq7DpNm3LDei2u9dSB52YuAlj6aOtMzFcKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sE6Af19hh1TMAr1F+5ty2nAwmihv7XgBnOC0iJfKZYdte3vrElNuSyAsiNFW9zQwYktK5JXYT4jGPAgGgkhOXghOlYMCdM/wb5Op4tnWIzpr2CAuNdeJjfNIWKSJZBQLOh8pl/mBC5eLCTp4CZKaPirg3+8DT/AQztQE2kcMIlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EB892008;
	Wed, 18 Mar 2026 12:19:21 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7B323F73B;
	Wed, 18 Mar 2026 12:19:25 -0700 (PDT)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 3/4] arm64: errata: Work around early CME DVMSync acknowledgement
Date: Wed, 18 Mar 2026 19:19:15 +0000
Message-ID: <20260318191918.2653160-4-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260318191918.2653160-1-catalin.marinas@arm.com>
References: <20260318191918.2653160-1-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

C1-Pro acknowledges DVMSync messages before completing the SME/CME
memory accesses. Work around this by issuing an IPI to the affected CPUs
if they are running in EL0 with SME enabled.

Note that we avoid the local DSB in the IPI handler as the kernel runs
with SCTLR_EL1.IESB=1 This is sufficient to complete SME memory accesses
at EL0 on taking an exception to EL1. On the return to user path, no
barrier is necessary either. See the comment in sme_set_active() and the
more detailed explanation in the link below.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
---
 arch/arm64/Kconfig                | 12 +++++
 arch/arm64/include/asm/cpucaps.h  |  2 +
 arch/arm64/include/asm/cputype.h  |  2 +
 arch/arm64/include/asm/fpsimd.h   | 21 ++++++++
 arch/arm64/include/asm/mmu.h      |  1 +
 arch/arm64/include/asm/tlbflush.h | 22 +++++++++
 arch/arm64/kernel/cpu_errata.c    | 30 ++++++++++++
 arch/arm64/kernel/entry-common.c  |  3 ++
 arch/arm64/kernel/fpsimd.c        | 81 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/process.c       |  7 +++
 arch/arm64/tools/cpucaps          |  1 +
 11 files changed, 182 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..f07cdb6ada08 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1175,6 +1175,18 @@ config ARM64_ERRATUM_4311569
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_SME_DVMSYNC
+	bool "C1-Pro: 4193714: SME DVMSync early acknowledgement"
+	depends on ARM64_SME
+	default y
+	help
+	  Enable workaround for C1-Pro acknowledging the DVMSync before
+	  the SME memory accesses are complete. This would cause TLB
+	  maintenance for processes using SME to also issue an IPI to
+	  the affected CPUs.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 177c691914f8..d0e6cff93876 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -64,6 +64,8 @@ cpucap_is_possible(const unsigned int cap)
 		return IS_ENABLED(CONFIG_ARM64_WORKAROUND_REPEAT_TLBI);
 	case ARM64_WORKAROUND_SPECULATIVE_SSBS:
 		return IS_ENABLED(CONFIG_ARM64_ERRATUM_3194386);
+	case ARM64_WORKAROUND_SME_DVMSYNC:
+		return IS_ENABLED(CONFIG_ARM64_ERRATUM_SME_DVMSYNC);
 	case ARM64_MPAM:
 		/*
 		 * KVM MPAM support doesn't rely on the host kernel supporting MPAM.
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 08860d482e60..7b518e81dd15 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -98,6 +98,7 @@
 #define ARM_CPU_PART_CORTEX_A725	0xD87
 #define ARM_CPU_PART_CORTEX_A720AE	0xD89
 #define ARM_CPU_PART_NEOVERSE_N3	0xD8E
+#define ARM_CPU_PART_C1_PRO		0xD8B
 
 #define APM_CPU_PART_XGENE		0x000
 #define APM_CPU_VAR_POTENZA		0x00
@@ -189,6 +190,7 @@
 #define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)
 #define MIDR_CORTEX_A720AE MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720AE)
 #define MIDR_NEOVERSE_N3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N3)
+#define MIDR_C1_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_C1_PRO)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 1d2e33559bd5..129c29aa0fc4 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -428,6 +428,24 @@ static inline size_t sme_state_size(struct task_struct const *task)
 	return __sme_state_size(task_get_sme_vl(task));
 }
 
+void sme_enable_dvmsync(void);
+void sme_set_active(unsigned int cpu);
+void sme_clear_active(unsigned int cpu);
+
+static inline void sme_enter_from_user_mode(void)
+{
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC) &&
+	    test_thread_flag(TIF_SME))
+		sme_clear_active(smp_processor_id());
+}
+
+static inline void sme_exit_to_user_mode(void)
+{
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC) &&
+	    test_thread_flag(TIF_SME))
+		sme_set_active(smp_processor_id());
+}
+
 #else
 
 static inline void sme_user_disable(void) { BUILD_BUG(); }
@@ -456,6 +474,9 @@ static inline size_t sme_state_size(struct task_struct const *task)
 	return 0;
 }
 
+static inline void sme_enter_from_user_mode(void) { }
+static inline void sme_exit_to_user_mode(void) { }
+
 #endif /* ! CONFIG_ARM64_SME */
 
 /* For use by EFI runtime services calls only */
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 137a173df1ff..ec6003db4d20 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -8,6 +8,7 @@
 #include <asm/cputype.h>
 
 #define MMCF_AARCH32	0x1	/* mm context flag for AArch32 executables */
+#define MMCF_SME_DVMSYNC 0x2	/* force DVMSync via IPI for SME completion */
 #define USER_ASID_BIT	48
 #define USER_ASID_FLAG	(UL(1) << USER_ASID_BIT)
 #define TTBR_ASID_MASK	(UL(0xffff) << 48)
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 262791191935..59a9f501a6cb 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -80,6 +80,26 @@ static inline unsigned long get_trans_granule(void)
 	}
 }
 
+void sme_do_dvmsync(void);
+
+static inline void sme_dvmsync(struct mm_struct *mm)
+{
+	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC))
+		return;
+	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &mm->context.flags))
+		return;
+
+	sme_do_dvmsync();
+}
+
+static inline void sme_dvmsync_batch(void)
+{
+	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC))
+		return;
+
+	sme_do_dvmsync();
+}
+
 /*
  * Level-based TLBI operations.
  *
@@ -189,12 +209,14 @@ static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
 {
 	dsb(ish);
 	__repeat_tlbi_sync(vale1is, 0);
+	sme_dvmsync(mm);
 }
 
 static inline void __tlbi_sync_s1ish_batch(void)
 {
 	dsb(ish);
 	__repeat_tlbi_sync(vale1is, 0);
+	sme_dvmsync_batch();
 }
 
 static inline void __tlbi_sync_s1ish_kernel(void)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 5c0ab6bfd44a..654c1e9ed7e1 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -11,6 +11,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
+#include <asm/fpsimd.h>
 #include <asm/kvm_asm.h>
 #include <asm/smp_plat.h>
 
@@ -575,6 +576,23 @@ static const struct midr_range erratum_spec_ssbs_list[] = {
 };
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
+static bool has_sme_dvmsync_erratum(const struct arm64_cpu_capabilities *entry,
+				    int scope)
+{
+	if (!id_aa64pfr1_sme(read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1)))
+		return false;
+
+	return is_affected_midr_range(entry, scope);
+}
+
+static void cpu_enable_sme_dvmsync(const struct arm64_cpu_capabilities *__unused)
+{
+	if (this_cpu_has_cap(ARM64_WORKAROUND_SME_DVMSYNC))
+		sme_enable_dvmsync();
+}
+#endif
+
 #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
 static const struct midr_range erratum_ac03_cpu_38_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
@@ -901,6 +919,18 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = need_arm_si_l1_workaround_4311569,
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
+	{
+		.desc = "C1-Pro SME DVMSync early acknowledgement",
+		.capability = ARM64_WORKAROUND_SME_DVMSYNC,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = has_sme_dvmsync_erratum,
+		.cpu_enable = cpu_enable_sme_dvmsync,
+		/* C1-Pro r0p0 - r1p2 (the latter only when REVIDR_EL1[0]==0) */
+		.midr_range = MIDR_RANGE(MIDR_C1_PRO, 0, 0, 1, 2),
+		MIDR_FIXED(MIDR_CPU_VAR_REV(1, 2), BIT(0)),
+	},
+#endif
 #ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	{
 		.desc = "ARM errata 2966298, 3117295",
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 3625797e9ee8..fb1e374af622 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -21,6 +21,7 @@
 #include <asm/daifflags.h>
 #include <asm/esr.h>
 #include <asm/exception.h>
+#include <asm/fpsimd.h>
 #include <asm/irq_regs.h>
 #include <asm/kprobes.h>
 #include <asm/mmu.h>
@@ -67,6 +68,7 @@ static __always_inline void arm64_enter_from_user_mode(struct pt_regs *regs)
 {
 	enter_from_user_mode(regs);
 	mte_disable_tco_entry(current);
+	sme_enter_from_user_mode();
 }
 
 /*
@@ -80,6 +82,7 @@ static __always_inline void arm64_exit_to_user_mode(struct pt_regs *regs)
 	local_irq_disable();
 	exit_to_user_mode_prepare_legacy(regs);
 	local_daif_mask();
+	sme_exit_to_user_mode();
 	mte_check_tfsr_exit();
 	exit_to_user_mode();
 }
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 9de1d8a604cb..4cfa362d37f8 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -15,6 +15,7 @@
 #include <linux/compiler.h>
 #include <linux/cpu.h>
 #include <linux/cpu_pm.h>
+#include <linux/cpumask.h>
 #include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/linkage.h>
@@ -28,6 +29,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
+#include <linux/smp.h>
 #include <linux/stddef.h>
 #include <linux/sysctl.h>
 #include <linux/swab.h>
@@ -1358,6 +1360,85 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
 	put_cpu_fpsimd_context();
 }
 
+#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
+
+/*
+ * SME/CME erratum handling
+ */
+static cpumask_var_t sme_dvmsync_cpus;
+static cpumask_var_t sme_active_cpus;
+
+void sme_set_active(unsigned int cpu)
+{
+	if (!cpumask_test_cpu(cpu, sme_dvmsync_cpus))
+		return;
+
+	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags))
+		set_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags);
+
+	cpumask_set_cpu(cpu, sme_active_cpus);
+
+	/*
+	 * A subsequent (post ERET) SME access may use a stale address
+	 * translation. On C1-Pro, a TLBI+DSB on a different CPU will wait for
+	 * the completion of set_bit() and cpumask_set_cpu() above as they
+	 * appear in program order before the SME access. The post-TLBI+DSB
+	 * read of the flag and cpumask will lead to the IPI being issued.
+	 *
+	 * https://lore.kernel.org/r/ablEXwhfKyJW1i7l@J2N7QTR9R3
+	 */
+}
+
+void sme_clear_active(unsigned int cpu)
+{
+	if (!cpumask_test_cpu(cpu, sme_dvmsync_cpus))
+		return;
+
+	/*
+	 * With SCTLR_EL1.IESB enabled, the SME memory transactions are
+	 * completed on entering EL1.
+	 */
+	cpumask_clear_cpu(cpu, sme_active_cpus);
+}
+
+static void sme_dvmsync_ipi(void *unused)
+{
+	/*
+	 * With SCTLR_EL1.IESB on, taking an exception is sufficient to ensure
+	 * the completion of the SME memory accesses, so no need for an
+	 * explicit DSB.
+	 */
+}
+
+void sme_do_dvmsync(void)
+{
+	/*
+	 * This is called from the TLB maintenance functions after the DSB ISH
+	 * to send hardware DVMSync message. If this CPU sees the mask as
+	 * empty, the remote CPU executing sme_set_active() would have seen
+	 * the DVMSync and no IPI required.
+	 */
+	if (cpumask_empty(sme_active_cpus))
+		return;
+
+	preempt_disable();
+	smp_call_function_many(sme_active_cpus, sme_dvmsync_ipi, NULL, true);
+	preempt_enable();
+}
+
+void sme_enable_dvmsync(void)
+{
+	if ((!cpumask_available(sme_dvmsync_cpus) &&
+	     !zalloc_cpumask_var(&sme_dvmsync_cpus, GFP_ATOMIC)) ||
+	    (!cpumask_available(sme_active_cpus) &&
+	     !zalloc_cpumask_var(&sme_active_cpus, GFP_ATOMIC)))
+		panic("Unable to allocate the cpumasks for SME DVMSync erratum");
+
+	cpumask_set_cpu(smp_processor_id(), sme_dvmsync_cpus);
+}
+
+#endif /* CONFIG_ARM64_ERRATUM_SME_DVMSYNC */
+
 /*
  * Trapped SME access
  *
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 489554931231..b322467f9397 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -471,6 +471,13 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 				ret = copy_thread_za(p, current);
 				if (ret)
 					return ret;
+				/*
+				 * Disable the SME DVMSync workaround for the
+				 * new process, it will be enabled on return
+				 * to user if TIF_SME is set.
+				 */
+				if (alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC))
+					p->mm->context.flags &= ~MMCF_SME_DVMSYNC;
 			} else {
 				p->thread.tpidr2_el0 = 0;
 				WARN_ON_ONCE(p->thread.svcr & SVCR_ZA_MASK);
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 7261553b644b..7d69d8a16eae 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -123,6 +123,7 @@ WORKAROUND_PMUV3_IMPDEF_TRAPS
 WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_QCOM_ORYON_CNTVOFF
 WORKAROUND_REPEAT_TLBI
+WORKAROUND_SME_DVMSYNC
 WORKAROUND_SPECULATIVE_AT
 WORKAROUND_SPECULATIVE_SSBS
 WORKAROUND_SPECULATIVE_UNPRIV_LOAD
