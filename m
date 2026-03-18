Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BAD73F0771
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773862083; cv=none; b=JP7Nc7UIedFFNGqRB3e2bllik0IZKJIZ5akMgs8ZsrEnz5yInFSHhHCvVMCpZWOLEUiG643ZBM2EcqZOXFPTzhosp9+8nlwTmzQkVTg8Y3qZ6EuW8PhWTxhyDvkwBzUa1tdY+NiV5pg/JXBqHdflobxu+al428Zru5V7B9wKcOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773862083; c=relaxed/simple;
	bh=G7V2jHSLO7TRgckxjFpvay3xbQLRYkcXGDBWBsjh85U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctMDFWwggEdCBGM79Qzg0qTzr0S3yiFlsLF/9NMH9O/2+NWiQyIsJMikAG2K6X/ozddFTlYYOGK6KAF/LbLgBbzED+L9GMd5G02YtGQlSdczjlX6geg1mQ77pS2i0Tunb6jhoVSZf24BOQdfZPvXAblf0+VxlY0ARXa9CpzMH78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D41A1BF7;
	Wed, 18 Mar 2026 12:27:54 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E85D13F73B;
	Wed, 18 Mar 2026 12:27:58 -0700 (PDT)
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
Subject: [RFC PATCH] arm64: errata: Use mm_cpumask() for the CME DVMSync workaround
Date: Wed, 18 Mar 2026 19:22:34 +0000
Message-ID: <20260318192757.2654235-1-catalin.marinas@arm.com>
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

The original workaround is using a global sme_active_cpus mask on the
assumption that SME is rarely used by more than one application at the
same time. If this assumption changes, an alternative way to track
which CPUs need an IPI is using a per-mm mask (mm_cpumask() is unused on
arm64). TLB batching still issues a single IPI per affected CPU at the
batch flush time but arch_tlbbatch_add_pending() now requires a DSB and
tracking which mm_cpumask() need interrupting. The actual TLBI batching
no longer happens even on CPUs on the same SoC that are not affected.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
---

As I mentioned in the cover letter, I'm not keen on this patch or some
form of it being upstreamed (or rather folded into patch 3). We could
hack it further to track an mm in arch_tlbflush_unmap_batch instead a
cpumask, hoping that TTU only happens for a single mm but then we also
need a global sme_active_cpus mask to avoid IPI'ing all CPUs.

My assumption is that we won't have many apps using SME simultaneously
(it wouldn't be efficient either with the CPUs sharing a CME unit), so
fine-grained tracking is just additional cost. We can revive this
discussion based on how people will use it in the field but I'd also
expect that fixed CPUs will start to turn up in products.

 arch/arm64/include/asm/tlbbatch.h | 10 +++++--
 arch/arm64/include/asm/tlbflush.h | 47 ++++++++++++++++++++++++++-----
 arch/arm64/kernel/fpsimd.c        | 19 ++++++-------
 arch/arm64/kernel/process.c       | 37 ++++++++++++++++++++++++
 4 files changed, 93 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/tlbbatch.h b/arch/arm64/include/asm/tlbbatch.h
index fedb0b87b8db..cc317d0f2362 100644
--- a/arch/arm64/include/asm/tlbbatch.h
+++ b/arch/arm64/include/asm/tlbbatch.h
@@ -2,11 +2,17 @@
 #ifndef _ARCH_ARM64_TLBBATCH_H
 #define _ARCH_ARM64_TLBBATCH_H
 
+#include <linux/cpumask.h>
+
 struct arch_tlbflush_unmap_batch {
+#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
 	/*
-	 * For arm64, HW can do tlb shootdown, so we don't
-	 * need to record cpumask for sending IPI
+	 * Track CPUs that need SME DVMSync on completion of this batch.
+	 * Otherwise, the arm64 HW can do tlb shootdown, so we don't need to
+	 * record cpumask for sending IPI
 	 */
+	cpumask_var_t cpumask;
+#endif
 };
 
 #endif /* _ARCH_ARM64_TLBBATCH_H */
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 59a9f501a6cb..2d57a8f80c3c 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -80,7 +80,9 @@ static inline unsigned long get_trans_granule(void)
 	}
 }
 
-void sme_do_dvmsync(void);
+#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
+
+void sme_do_dvmsync(const struct cpumask *mask);
 
 static inline void sme_dvmsync(struct mm_struct *mm)
 {
@@ -89,17 +91,47 @@ static inline void sme_dvmsync(struct mm_struct *mm)
 	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &mm->context.flags))
 		return;
 
-	sme_do_dvmsync();
+	sme_do_dvmsync(mm_cpumask(mm));
 }
 
-static inline void sme_dvmsync_batch(void)
+static inline void sme_dvmsync_add_pending(struct arch_tlbflush_unmap_batch *batch,
+					   struct mm_struct *mm)
 {
 	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC))
 		return;
 
-	sme_do_dvmsync();
+	/*
+	 * Send the DVMSync message before checking the MMCF_SME_DVMSYNC flag.
+	 */
+	dsb(ish);
+	if (test_bit(ilog2(MMCF_SME_DVMSYNC), &mm->context.flags))
+		cpumask_or(batch->cpumask, batch->cpumask, mm_cpumask(mm));
 }
 
+static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
+{
+	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC))
+		return;
+
+	sme_do_dvmsync(batch->cpumask);
+	cpumask_clear(batch->cpumask);
+}
+
+#else
+
+static inline void sme_dvmsync(struct mm_struct *mm)
+{
+}
+static inline void sme_dvmsync_add_pending(struct arch_tlbflush_unmap_batch *batch,
+					   struct mm_struct *mm)
+{
+}
+static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
+{
+}
+
+#endif /* CONFIG_ARM64_ERRATUM_SME_DVMSYNC */
+
 /*
  * Level-based TLBI operations.
  *
@@ -212,11 +244,11 @@ static inline void __tlbi_sync_s1ish(struct mm_struct *mm)
 	sme_dvmsync(mm);
 }
 
-static inline void __tlbi_sync_s1ish_batch(void)
+static inline void __tlbi_sync_s1ish_batch(struct arch_tlbflush_unmap_batch *batch)
 {
 	dsb(ish);
 	__repeat_tlbi_sync(vale1is, 0);
-	sme_dvmsync_batch();
+	sme_dvmsync_batch(batch);
 }
 
 static inline void __tlbi_sync_s1ish_kernel(void)
@@ -419,7 +451,7 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
  */
 static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
-	__tlbi_sync_s1ish_batch();
+	__tlbi_sync_s1ish_batch(batch);
 }
 
 /*
@@ -624,6 +656,7 @@ static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *b
 		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	__flush_tlb_range_nosync(mm, start, end, PAGE_SIZE, true, 3);
+	sme_dvmsync_add_pending(batch, mm);
 }
 
 static inline bool __pte_flags_need_flush(ptdesc_t oldval, ptdesc_t newval)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 4cfa362d37f8..ef81e80667a5 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1366,7 +1366,6 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
  * SME/CME erratum handling
  */
 static cpumask_var_t sme_dvmsync_cpus;
-static cpumask_var_t sme_active_cpus;
 
 void sme_set_active(unsigned int cpu)
 {
@@ -1376,7 +1375,7 @@ void sme_set_active(unsigned int cpu)
 	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags))
 		set_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags);
 
-	cpumask_set_cpu(cpu, sme_active_cpus);
+	cpumask_set_cpu(cpu, mm_cpumask(current->mm));
 
 	/*
 	 * A subsequent (post ERET) SME access may use a stale address
@@ -1398,7 +1397,7 @@ void sme_clear_active(unsigned int cpu)
 	 * With SCTLR_EL1.IESB enabled, the SME memory transactions are
 	 * completed on entering EL1.
 	 */
-	cpumask_clear_cpu(cpu, sme_active_cpus);
+	cpumask_clear_cpu(cpu, mm_cpumask(current->mm));
 }
 
 static void sme_dvmsync_ipi(void *unused)
@@ -1410,28 +1409,26 @@ static void sme_dvmsync_ipi(void *unused)
 	 */
 }
 
-void sme_do_dvmsync(void)
+void sme_do_dvmsync(const struct cpumask *mask)
 {
 	/*
 	 * This is called from the TLB maintenance functions after the DSB ISH
-	 * to send hardware DVMSync message. If this CPU sees the mask as
+	 * to send the hardware DVMSync message. If this CPU sees the mask as
 	 * empty, the remote CPU executing sme_set_active() would have seen
 	 * the DVMSync and no IPI required.
 	 */
-	if (cpumask_empty(sme_active_cpus))
+	if (cpumask_empty(mask))
 		return;
 
 	preempt_disable();
-	smp_call_function_many(sme_active_cpus, sme_dvmsync_ipi, NULL, true);
+	smp_call_function_many(mask, sme_dvmsync_ipi, NULL, true);
 	preempt_enable();
 }
 
 void sme_enable_dvmsync(void)
 {
-	if ((!cpumask_available(sme_dvmsync_cpus) &&
-	     !zalloc_cpumask_var(&sme_dvmsync_cpus, GFP_ATOMIC)) ||
-	    (!cpumask_available(sme_active_cpus) &&
-	     !zalloc_cpumask_var(&sme_active_cpus, GFP_ATOMIC)))
+	if (!cpumask_available(sme_dvmsync_cpus) &&
+	    !zalloc_cpumask_var(&sme_dvmsync_cpus, GFP_ATOMIC))
 		panic("Unable to allocate the cpumasks for SME DVMSync erratum");
 
 	cpumask_set_cpu(smp_processor_id(), sme_dvmsync_cpus);
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index b322467f9397..5700d35fd05e 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/cpumask.h>
 #include <linux/cpu.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
@@ -339,8 +340,41 @@ void flush_thread(void)
 	flush_gcs();
 }
 
+#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
+
+static int arch_dup_tlbbatch_mask(struct task_struct *dst)
+{
+	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC))
+		return 0;
+
+	if (!zalloc_cpumask_var(&dst->tlb_ubc.arch.cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void arch_release_tlbbatch_mask(struct task_struct *tsk)
+{
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC))
+		free_cpumask_var(tsk->tlb_ubc.arch.cpumask);
+}
+
+#else
+
+static int arch_dup_tlbbatch_mask(struct task_struct *dst)
+{
+	return 0;
+}
+
+static void arch_release_tlbbatch_mask(struct task_struct *tsk)
+{
+}
+
+#endif /* ARM64_ERRATUM_SME_DVMSYNC */
+
 void arch_release_task_struct(struct task_struct *tsk)
 {
+	arch_release_tlbbatch_mask(tsk);
 	fpsimd_release_task(tsk);
 }
 
@@ -356,6 +390,9 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 
 	*dst = *src;
 
+	if (arch_dup_tlbbatch_mask(dst))
+		return -ENOMEM;
+
 	/*
 	 * Drop stale reference to src's sve_state and convert dst to
 	 * non-streaming FPSIMD mode.
