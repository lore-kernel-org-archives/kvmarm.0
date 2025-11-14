Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BC62741A6
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136535; cv=none; b=Ttra6qhudkbY9ETtwp9IxU95aRaMfCzYW5Pq2Jkrh/w/ieoB95BdfWMCCnY5o8/rBK0BuCbO2/u8mhqycCzoVio5P6aMswplxDaUqKpgp5crVtsxHuTKCl3TOl6N3FLcUx63XC7KKr/0gTtohlGzve9++eXh6MEDB7WSTcIgDLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136535; c=relaxed/simple;
	bh=HCFglPVeWpVmClo7DZRejRuwmvt5GCTzB9XQg1loSoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUwdmQenBEzQvkN0Uok6wwCg/bJl3yybk8V0zH/SUhIVezqpV6UGjEz71sqWAcM01pkd++jotl7tTFv3rnMFBgO8FeUzYy06Po7XW+Eip1fFO2xjfFbOH7T1KNj2b4LJbEY2HTyOb8pVVdXOdRQ6QkMKPzeRBQ5wtudeOEM4YPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E61F21BD0;
	Fri, 14 Nov 2025 08:08:44 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67B7B3F5A1;
	Fri, 14 Nov 2025 08:08:50 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 31/35] KVM: arm64: Handle MMU notifiers for the SPE buffer
Date: Fri, 14 Nov 2025 16:07:12 +0000
Message-ID: <20251114160717.163230-32-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM makes changes to the stage 2 for two reasons: to mirror the changes
that happen to the host's stage 1, and when userspace makes a direct
change to the memory of the virtual machine.

Explicit changes made to the VM by userspace - like changing a memslot or
clearing the list of dirty pages, are immediately honored when it comes to
memory pinned and mapped at stage 2 for the SPE buffer. The only caveat is
when it comes to making the buffer pages read-only: to avoid a blackout
window, KVM skips making the affected buffer pages readonly and instead
immediately redirties them.

Changes to the host's stage 1 that affect the stage 2 entries for the
buffer broadly fall in two categories: changes that are attempted, but
never executed because the memory is pinned, and changes that are
committed.

The first type of changes share a similar cause: the reference count for a
page or folio is incremented with page table spinlock held, but the MMU
notifiers must be invoked from preemptible contexts. As a result, features
like THP collapse (khugepaged),  automatic NUMA balancing, KSM, etc. use
the following pattern for modifying the host's stage 1:

	mmu_notifier_invalidate_range_start(&range)
	pte = pte_offset_map_lock(.., &ptl)
	if (page_maybe_dma_pinned(page))
		goto out_unlock
	/* do stuff */

out_unlock:
	spin_unlock(ptl)
	mmu_notifier_invalidate_range_end(&range)

It is safe for KVM to ignore these type of changes, because the host's page
table won't be modified.

Changes to the host's stage 1 that are committed will be reflected in the
buffer stage 2 entries. The only exception is the access flag, for the same
reasoning as making the entries read-only.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/asm/kvm_mmu.h  |   7 +-
 arch/arm64/include/asm/kvm_spe.h  |  19 +++
 arch/arm64/kvm/arm.c              |  14 +-
 arch/arm64/kvm/mmu.c              | 125 ++++++++++++----
 arch/arm64/kvm/nested.c           |   9 +-
 arch/arm64/kvm/spe.c              | 232 +++++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         |   5 +-
 arch/arm64/kvm/vgic/vgic-its.c    |   4 +-
 include/kvm/arm_vgic.h            |   2 +
 include/linux/kvm_host.h          |   2 +
 11 files changed, 380 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 876957320672..e79ec480d1d1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -351,6 +351,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_GUEST_HAS_SVE			9
 	/* MIDR_EL1, REVIDR_EL1, and AIDR_EL1 are writable from userspace */
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
+	/* Statistical Profiling Extension enabled for the guest */
+#define KVM_ARCH_FLAG_SPE_ENABLED			11
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 37b84e9d4337..a4a0e00d1bbb 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -100,6 +100,10 @@ alternative_cb_end
 #include <asm/kvm_host.h>
 #include <asm/kvm_nested.h>
 
+#define KVM_MMU_NOTIFY_CMO		KVM_MMU_NOTIFY_ARCH1
+#define KVM_MMU_NOTIFY_SHADOW_S2	KVM_MMU_NOTIFY_ARCH2
+#define KVM_MMU_NOTIFY_SPLIT_HUGE_PAGE	KVM_MMU_NOTIFY_ARCH3
+
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
 void kvm_compute_layout(void);
@@ -168,8 +172,9 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr);
 void __init free_hyp_pgds(void);
 
+enum kvm_mmu_notifier_event;
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
-			    u64 size, bool may_block);
+			    u64 size, bool may_block, enum kvm_mmu_notifier_event event);
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 6c091fbfc95d..59a0e825a226 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -8,6 +8,8 @@
 
 #include <linux/kvm.h>
 
+#include <asm/stage2_pgtable.h>
+
 #ifdef CONFIG_KVM_ARM_SPE
 
 struct kvm_spe {
@@ -15,6 +17,7 @@ struct kvm_spe {
 	struct arm_spe_pmu *arm_spu;
 	u64 max_buffer_size;	/* Maximum per VCPU buffer size */
 	u64 guest_pmscr_el2;
+	bool dirtying_pages;
 };
 
 struct kvm_vcpu_spe {
@@ -35,6 +38,9 @@ static __always_inline bool kvm_supports_spe(void)
 #define vcpu_has_spe(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
 
+#define kvm_has_spe(kvm)					\
+	(test_bit(KVM_ARCH_FLAG_SPE_ENABLED, &(kvm)->arch.flags))
+
 /* Implements the function ProfilingBufferEnabled() from ARM DDI0487K.a */
 static inline bool kvm_spe_profiling_buffer_enabled(u64 pmblimitr_el1, u64 pmbsr_el1)
 {
@@ -47,6 +53,14 @@ void kvm_spe_destroy_vm(struct kvm *kvm);
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 void kvm_spe_vcpu_destroy(struct kvm_vcpu *vcpu);
 
+bool kvm_spe_allow_write_without_running_vcpu(struct kvm *kvm);
+
+enum kvm_mmu_notifier_event;
+phys_addr_t kvm_spe_adjust_range_start(struct kvm *kvm, phys_addr_t start, phys_addr_t end,
+				       enum kvm_mmu_notifier_event event);
+phys_addr_t kvm_spe_adjust_range_end(struct kvm *kvm, phys_addr_t start, phys_addr_t end,
+				     enum kvm_mmu_notifier_event event);
+
 u8 kvm_spe_get_pmsver_limit(void);
 
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
@@ -72,6 +86,7 @@ struct kvm_vcpu_spe {
 
 #define kvm_supports_spe()	false
 #define vcpu_has_spe(vcpu)	false
+#define kvm_has_spe(kvm)	false
 
 static inline void kvm_spe_init_vm(struct kvm *kvm)
 {
@@ -86,6 +101,10 @@ static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 static inline void kvm_spe_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 }
+static inline bool kvm_spe_allow_write_without_running_vcpu(struct kvm *kvm)
+{
+	return false;
+}
 static inline u8 kvm_spe_get_pmsver_limit(void)
 {
 	return 0;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8da772690173..d05dbb6d2d7a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -777,6 +777,16 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
 }
 
+/*
+ * kvm_arch_allow_write_without_running_vcpu - allow writing guest memory
+ * without a running VCPU when dirty ring is enabled.
+ */
+bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
+{
+       return kvm_vgic_allow_write_without_running_vcpu(kvm) ||
+	      kvm_spe_allow_write_without_running_vcpu(kvm);
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return vcpu_mode_priv(vcpu);
@@ -1275,8 +1285,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_has_pmu(vcpu))
 			kvm_pmu_sync_hwstate(vcpu);
 
-		kvm_spe_sync_hwstate(vcpu);
-
 		/*
 		 * Sync the vgic state before syncing the timer state because
 		 * the timer code needs to know if the virtual timer
@@ -1326,6 +1334,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		preempt_enable();
 
+		kvm_spe_sync_hwstate(vcpu);
+
 		/*
 		 * The ARMv8 architecture doesn't give the hypervisor
 		 * a mechanism to prevent a guest from dropping to AArch32 EL0
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8abba9619c58..de48fb7c0fff 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -37,6 +37,22 @@ static unsigned long __ro_after_init io_map_base;
 
 #define KVM_PGT_FN(fn)		(!is_protected_kvm_enabled() ? fn : p ## fn)
 
+#ifndef CONFIG_KVM_ARM_SPE
+static inline phys_addr_t
+kvm_spe_adjust_range_start(struct kvm *kvm, phys_addr_t start, phys_addr_t end,
+			   enum kvm_mmu_notifier_event event)
+{
+	return start;
+}
+
+static inline phys_addr_t
+kvm_spe_adjust_range_end(struct kvm *kvm, phys_addr_t start, phys_addr_t end,
+			 enum kvm_mmu_notifier_event event)
+{
+	return end;
+}
+#endif
+
 static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
 					   phys_addr_t size)
 {
@@ -62,10 +78,10 @@ static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
 static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 			      phys_addr_t end,
 			      int (*fn)(struct kvm_pgtable *, u64, u64),
-			      bool resched)
+			      bool resched, enum kvm_mmu_notifier_event event)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
-	int ret;
+	int ret = 0;
 	u64 next;
 
 	do {
@@ -73,7 +89,15 @@ static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 		if (!pgt)
 			return -EINVAL;
 
+		if (kvm_has_spe(kvm)) {
+			addr = kvm_spe_adjust_range_start(kvm, addr, end, event);
+			if (addr == end)
+				break;
+		}
+
 		next = stage2_range_addr_end(addr, end);
+		if (kvm_has_spe(kvm))
+			next = kvm_spe_adjust_range_end(kvm, addr, next, event);
 		ret = fn(pgt, addr, next - addr);
 		if (ret)
 			break;
@@ -85,8 +109,8 @@ static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 	return ret;
 }
 
-#define stage2_apply_range_resched(mmu, addr, end, fn)			\
-	stage2_apply_range(mmu, addr, end, fn, true)
+#define stage2_apply_range_resched(mmu, addr, end, fn, event)		\
+	stage2_apply_range(mmu, addr, end, fn, true, event)
 
 /*
  * Get the maximum number of page-tables pages needed to split a range
@@ -122,8 +146,9 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
 {
 	struct kvm_mmu_memory_cache *cache;
 	struct kvm_pgtable *pgt;
-	int ret, cache_capacity;
 	u64 next, chunk_size;
+	int cache_capacity;
+	int ret = 0;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -152,7 +177,18 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
 		if (!pgt)
 			return -EINVAL;
 
+		if (kvm_has_spe(kvm)) {
+			addr = kvm_spe_adjust_range_start(kvm, addr, end,
+					KVM_MMU_NOTIFY_SPLIT_HUGE_PAGE);
+			if (addr == end)
+				break;
+		}
+
 		next = __stage2_range_addr_end(addr, end, chunk_size);
+		if (kvm_has_spe(kvm)) {
+			next = kvm_spe_adjust_range_end(kvm, addr, next,
+							KVM_MMU_NOTIFY_SPLIT_HUGE_PAGE);
+		}
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_split)(pgt, addr, next - addr, cache);
 		if (ret)
 			break;
@@ -319,6 +355,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
  * @may_block: Whether or not we are permitted to block
+ * @event: MMU notifier event
  *
  * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
  * be called while holding mmu_lock (unless for freeing the stage2 pgd before
@@ -326,7 +363,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * with things behind our backs.
  */
 static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
-				 bool may_block)
+				 bool may_block, enum kvm_mmu_notifier_event event)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	phys_addr_t end = start + size;
@@ -334,18 +371,19 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
 	WARN_ON(stage2_apply_range(mmu, start, end, KVM_PGT_FN(kvm_pgtable_stage2_unmap),
-				   may_block));
+				   may_block, event));
 }
 
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
-			    u64 size, bool may_block)
+			    u64 size, bool may_block, enum kvm_mmu_notifier_event event)
 {
-	__unmap_stage2_range(mmu, start, size, may_block);
+	__unmap_stage2_range(mmu, start, size, may_block, event);
 }
 
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
-	stage2_apply_range_resched(mmu, addr, end, KVM_PGT_FN(kvm_pgtable_stage2_flush));
+	stage2_apply_range_resched(mmu, addr, end, KVM_PGT_FN(kvm_pgtable_stage2_flush),
+				   KVM_MMU_NOTIFY_CMO);
 }
 
 static void stage2_flush_memslot(struct kvm *kvm,
@@ -1028,7 +1066,8 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, vm_end - vm_start, true);
+			kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, vm_end - vm_start, true,
+					       KVM_MMU_NOTIFY_MEMSLOT);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -1187,7 +1226,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
  */
 void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
-	stage2_apply_range_resched(mmu, addr, end, KVM_PGT_FN(kvm_pgtable_stage2_wrprotect));
+	stage2_apply_range_resched(mmu, addr, end, KVM_PGT_FN(kvm_pgtable_stage2_wrprotect),
+				   KVM_MMU_NOTIFY_WP);
 }
 
 /**
@@ -2100,22 +2140,63 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 
 	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
 			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
+			     range->may_block, range->event);
 
 	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+static bool kvm_test_age_range(struct kvm *kvm, struct kvm_gfn_range *range,
+			       bool mkold)
 {
-	u64 size = (range->end - range->start) << PAGE_SHIFT;
+	phys_addr_t range_start = range->start << PAGE_SHIFT;
+	phys_addr_t range_end = range->end << PAGE_SHIFT;
+	enum kvm_mmu_notifier_event event = range->event;
+	phys_addr_t start, end;
+	bool was_young = false;
+
+	if (!kvm_has_spe(kvm)) {
+		return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
+							   range->start,
+							   range->end - range->start,
+							   mkold);
+	}
 
+       /* Prime the first iteration */
+       start = end = range_start;
+       do {
+	       start = kvm_spe_adjust_range_start(kvm, start, range_end, event);
+	       /*
+		* 'start' is initialised to 'end' at the beginning of each
+		* iteration.  They can only be different because
+		* kvm_spe_adjust_range_start() detected at least one page in use
+		* for SPE.
+		*/
+	       if (start != end)
+		       was_young = true;
+	       if (start == range_end)
+		       break;
+
+               end = kvm_spe_adjust_range_end(kvm, start, range_end, event);
+               if (end != range_end)
+                      was_young = true;
+
+               was_young |= KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
+									    start, end - start,
+									    mkold);
+	       start = end;
+       } while (end != range_end);
+
+       return was_young;
+}
+
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
-						   range->start << PAGE_SHIFT,
-						   size, true);
+	return kvm_test_age_range(kvm, range, true);
+
 	/*
 	 * TODO: Handle nested_mmu structures here using the reverse mapping in
 	 * a later version of patch series.
@@ -2124,14 +2205,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	u64 size = (range->end - range->start) << PAGE_SHIFT;
-
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
-						   range->start << PAGE_SHIFT,
-						   size, false);
+	return kvm_test_age_range(kvm, range, false);
 }
 
 phys_addr_t kvm_mmu_get_httbr(void)
@@ -2386,7 +2463,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	write_lock(&kvm->mmu_lock);
-	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
+	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true, KVM_MMU_NOTIFY_MEMSLOT);
 	kvm_nested_s2_unmap(kvm, true);
 	write_unlock(&kvm->mmu_lock);
 }
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 92e94bb96bcc..73e09dcef3ca 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1076,8 +1076,10 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
-		if (kvm_s2_mmu_valid(mmu))
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
+		if (kvm_s2_mmu_valid(mmu)) {
+			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block,
+					       KVM_MMU_NOTIFY_SHADOW_S2);
+		}
 	}
 
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
@@ -1787,7 +1789,8 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		write_lock(&vcpu->kvm->mmu_lock);
 		if (mmu->pending_unmap) {
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
+			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true,
+					       KVM_MMU_NOTIFY_SHADOW_S2);
 			mmu->pending_unmap = false;
 		}
 		write_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 35848e4ff68b..f80ef8cdb1d8 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -30,11 +30,13 @@ struct pinned_page {
 	DECLARE_BITMAP(vcpus, KVM_MAX_VCPUS);	/* The page is pinned on these VCPUs */
 	struct page *page;
 	gfn_t gfn;
+	bool unmap_after_unpin;			/* Unmap the page after the buffer is unpinned */
 	bool writable;				/* Is the page mapped as writable? */
 };
 
 static u64 max_buffer_size_to_pmbidr_el1(u64 size);
 static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level);
+static void kvm_spe_unpin_page(struct kvm *kvm, struct pinned_page *pinned_page);
 static void kvm_spe_unpin_buffer(struct kvm_vcpu *vcpu);
 
 static u64 pmblimitr_el1_res0_mask = GENMASK_ULL(11, 8) | GENMASK_ULL(6, 3);
@@ -146,6 +148,172 @@ void kvm_spe_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_spe_unpin_buffer(vcpu);
 }
 
+bool kvm_spe_allow_write_without_running_vcpu(struct kvm *kvm)
+{
+	return kvm->arch.kvm_spe.dirtying_pages;
+}
+
+static bool kvm_spe_allow_stage2_change(enum kvm_mmu_notifier_event event)
+{
+	switch (event) {
+	/* Host table entry will be reverted because the page is pinned. */
+	case KVM_MMU_NOTIFY_CLEAR:
+	/*
+	 * MMU_NOTIFY_PROTECTION_VMA is generated for the mprotect() call, but
+	 * also for benign reasons, like automatic NUMA balancing. In the latter
+	 * case, the changes to the host's stage 1 will be reverted when it is
+	 * observed that the page is pinned.
+	 *
+	 * In the mprotect() case, it is userspace that is explicitely changing
+	 * the protection for the VMA. Because KVM cannot distinguish between
+	 * mprotect() and the other cases, the buffer pages will be marked for
+	 * unmapping from the host's stage 1 when the guest disables the buffer.
+	 */
+	case KVM_MMU_NOTIFY_PROTECTION_VMA:
+	/* Don't allow buffer pages to be made read-only at stage 2. */
+	case KVM_MMU_NOTIFY_SOFT_DIRTY:
+	/* Host page migration will fail because the page is pinned. */
+	case KVM_MMU_NOTIFY_MIGRATE:
+	/*
+	 * SPE can write to the buffer at any time, treat the pinned pages as
+	 * young.
+	 */
+	case KVM_MMU_NOTIFY_AGE:
+	/*
+	 * This event is generated when a memslot is marked for dirty page
+	 * logging. The buffer pages will be kept mapped at stage 2 and they
+	 * will be immediately marked as dirty because KVM, without SPE
+	 * reporting a fault, has no means of detecting when a record is written
+	 * to memory.
+	 */
+	case KVM_MMU_NOTIFY_WP:
+	/*
+	 * All buffer pages are mapped with PAGE_SIZE granularity at stage 2,
+	 * it's safe to skip them.
+	 */
+	case KVM_MMU_NOTIFY_SPLIT_HUGE_PAGE:
+		return false;
+
+	/* Userspace munmap'ed the VMA. */
+	case KVM_MMU_NOTIFY_UNMAP:
+	/*
+	 * pin_user_pages() does not return a PFN without an associated struct
+	 * page, so the event shouldn't apply to a buffer page. Be conservative
+	 * and allow the stage 2 changes.
+	 */
+	case KVM_MMU_NOTIFY_PROTECTION_PAGE:
+	/*
+	 * KVM doesn't propagate this event to the architecture code because the
+	 * MMU notifier is unregistered when the VM is being destroyed and no
+	 * VCPUs should be running. Also, after the notifier is released, the
+	 * stage 2 will be destroyed. It makes little difference if we allow or
+	 * don't allow the buffer to be unmapped here, but put the event in the
+	 * allow group anyway in case anything changes.
+	 *
+	 * The buffer for each VCPU will be unpinned in the next stage of the VM
+	 * cleanup process, when the VCPUs are destroyed.
+	 */
+	case KVM_MMU_NOTIFY_RELEASE:
+	/* Same as KVM_MMU_NOTIFY_PROTECTION_PAGE. */
+	case KVM_MMU_NOTIFY_EXCLUSIVE:
+	/* x86-specific, but be conservative. */
+	case KVM_MMU_NOTIFY_MEMORY_ATTRIBUTES:
+	/* Userspace is changing a memslot while the buffer is enabled. */
+	case KVM_MMU_NOTIFY_MEMSLOT:
+	/* CMOs don't change stage 2 entries. */
+	case KVM_MMU_NOTIFY_CMO:
+	/* SPE is not yet compatible with nested virt, but be conservative. */
+	case KVM_MMU_NOTIFY_SHADOW_S2:
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+
+	return true;
+}
+
+phys_addr_t kvm_spe_adjust_range_start(struct kvm *kvm, phys_addr_t start, phys_addr_t end,
+				       enum kvm_mmu_notifier_event event)
+{
+	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
+	struct xarray *pinned_pages = &kvm_spe->pinned_pages;
+	struct pinned_page *pinned_page;
+	kvm_pfn_t gfn;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	if (kvm_spe_allow_stage2_change(event))
+		return start;
+
+	xa_lock(pinned_pages);
+	for (gfn = PHYS_PFN(start); gfn < PHYS_PFN(end); gfn++) {
+		pinned_page = xa_load(pinned_pages, gfn);
+		if (!pinned_page)
+			break;
+
+		pinned_page->unmap_after_unpin = true;
+		if (event == KVM_MMU_NOTIFY_WP && pinned_page->writable) {
+			kvm_spe->dirtying_pages = true;
+			mark_page_dirty(kvm, gfn);
+			kvm_spe->dirtying_pages = false;
+		}
+	}
+	xa_unlock(pinned_pages);
+
+	return PFN_PHYS(gfn);
+}
+
+/*
+ * Ignores pinned_page->unmap_after_unpin() because it is called only from the
+ * MMU notifiers, before changes are allowed to be made to stage 2.
+ */
+static void kvm_spe_unpin_page_range(struct kvm *kvm, phys_addr_t start, phys_addr_t end)
+{
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+	struct pinned_page *pinned_page;
+	kvm_pfn_t gfn;
+
+	xa_lock(pinned_pages);
+	for (gfn = PHYS_PFN(start); gfn < PHYS_PFN(end); gfn++) {
+		pinned_page = xa_load(pinned_pages, gfn);
+		if (!pinned_page)
+			continue;
+
+		kvm_spe_unpin_page(kvm, pinned_page);
+		kfree(pinned_page);
+	}
+	xa_unlock(pinned_pages);
+}
+
+phys_addr_t kvm_spe_adjust_range_end(struct kvm *kvm, phys_addr_t start, phys_addr_t end,
+				     enum kvm_mmu_notifier_event event)
+{
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+	kvm_pfn_t gfn;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	if (kvm_spe_allow_stage2_change(event)) {
+		if (event != KVM_MMU_NOTIFY_CMO)
+			kvm_spe_unpin_page_range(kvm, start, end);
+		return end;
+	}
+
+	xa_lock(pinned_pages);
+	/*
+	 * We know that @start is not a buffer page. Stop at the first buffer
+	 * page in the range [@start + PAGE_SIZE, @end) - this page will be
+	 * handled in the following call to kvm_spe_adjust_range_start().
+	 */
+	for (gfn = PHYS_PFN(start + PAGE_SIZE); gfn < PHYS_PFN(end); gfn++) {
+		if (xa_load(pinned_pages, gfn))
+			break;
+	}
+	xa_unlock(pinned_pages);
+
+	return PFN_PHYS(gfn);
+}
+
 u8 kvm_spe_get_pmsver_limit(void)
 {
 	unsigned int pmsver;
@@ -231,29 +399,78 @@ static void kvm_spe_inject_data_abort(struct kvm_vcpu *vcpu, u8 fst, bool s2)
 	kvm_spe_update_irq_level(vcpu, true);
 }
 
+static void kvm_spe_unpin_page(struct kvm *kvm, struct pinned_page *pinned_page)
+{
+	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
+
+	__xa_erase(pinned_pages, pinned_page->gfn);
+	unpin_user_pages_dirty_lock(&pinned_page->page, 1, pinned_page->writable);
+}
+
 static void kvm_spe_unpin_buffer(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct xarray *pinned_pages = &kvm->arch.kvm_spe.pinned_pages;
 	struct pinned_page *pinned_page;
-	unsigned long gfn;
+	int unmap_count, unmap_resched;
+	bool write_locked = false;
+	struct kvm_pgtable *pgt;
 	int idx;
 
+	XA_STATE(xas, pinned_pages, 0);
+
+	might_sleep();
+
+	/* Copy what stage2_apply_range() does */
+	unmap_resched = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL) >> PAGE_SHIFT;
+	unmap_count = 0;
+
 	idx = srcu_read_lock(&kvm->srcu);
-	xa_lock(pinned_pages);
+	xas_lock(&xas);
+
+	xas_for_each(&xas, pinned_page, ULONG_MAX) {
+		if (xas_retry(&xas, pinned_page))
+			continue;
 
-	xa_for_each(pinned_pages, gfn, pinned_page) {
 		if (!test_bit(vcpu->vcpu_idx, pinned_page->vcpus))
 			continue;
 
 		clear_bit(vcpu->vcpu_idx, pinned_page->vcpus);
-		if (bitmap_empty(pinned_page->vcpus, KVM_MAX_VCPUS)) {
-			__xa_erase(pinned_pages, pinned_page->gfn);
-			unpin_user_pages_dirty_lock(&pinned_page->page, 1, pinned_page->writable);
+		if (!bitmap_empty(pinned_page->vcpus, KVM_MAX_VCPUS))
+			continue;
+
+		kvm_spe_unpin_page(kvm, pinned_page);
+		if (!pinned_page->unmap_after_unpin)
+			goto free_continue;
+
+		if (!write_locked) {
+			xas_pause(&xas);
+			xas_unlock(&xas);
+			write_lock(&kvm->mmu_lock);
+			xas_lock(&xas);
+			write_locked = true;
+			pgt = vcpu->arch.hw_mmu->pgt;
+		}
+
+		if (!pgt)
+			goto free_continue;
+
+		kvm_pgtable_stage2_unmap(pgt, PFN_PHYS(pinned_page->gfn), PAGE_SIZE);
+		unmap_count++;
+		if (unmap_count == unmap_resched) {
+			xas_pause(&xas);
+			xas_unlock(&xas);
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+			xas_lock(&xas);
+			unmap_count = 0;
 		}
+free_continue:
+		kfree(pinned_page);
 	}
 
-	xa_unlock(pinned_pages);
+	xas_unlock(&xas);
+	if (write_locked)
+		write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -1314,6 +1531,7 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 			return -ENXIO;
 
 		vcpu_spe->initialized = true;
+		set_bit(KVM_ARCH_FLAG_SPE_ENABLED, &kvm->arch.flags);
 		return 0;
 	}
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index db86d1dcd148..e8fd1688abba 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3947,7 +3947,8 @@ static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
 	 * the L1 needs to put its stage-2 in a consistent state before doing
 	 * the TLBI.
 	 */
-	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size, true);
+	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size, true,
+			       KVM_MMU_NOTIFY_SHADOW_S2);
 }
 
 static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
@@ -4026,7 +4027,7 @@ static void s2_mmu_unmap_ipa(struct kvm_s2_mmu *mmu,
 	 * See comment in s2_mmu_unmap_range() for why this is allowed to
 	 * reschedule.
 	 */
-	kvm_stage2_unmap_range(mmu, base_addr, max_size, true);
+	kvm_stage2_unmap_range(mmu, base_addr, max_size, true, KVM_MMU_NOTIFY_SHADOW_S2);
 }
 
 static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ce3e3ed3f29f..fb36f1b4fdae 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2706,7 +2706,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 }
 
 /*
- * kvm_arch_allow_write_without_running_vcpu - allow writing guest memory
+ * kvm_vgic_allow_write_without_running_vcpu - allow writing guest memory
  * without the running VCPU when dirty ring is enabled.
  *
  * The running VCPU is required to track dirty guest pages when dirty ring
@@ -2715,7 +2715,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
  * bitmap is used to track the dirty guest pages due to the missed running
  * VCPU in the period.
  */
-bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
+bool kvm_vgic_allow_write_without_running_vcpu(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7a0b972eb1b1..4c0f4f80e8ef 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -446,6 +446,8 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
 
 void kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq);
 
+bool kvm_vgic_allow_write_without_running_vcpu(struct kvm *kvm);
+
 int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 772e75d13af1..273ee3339468 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -274,6 +274,8 @@ enum kvm_mmu_notifier_event {
 	KVM_MMU_NOTIFY_EXCLUSIVE        = MMU_NOTIFY_EXCLUSIVE,
 	KVM_MMU_NOTIFY_AGE		= 32,
 	KVM_MMU_NOTIFY_MEMORY_ATTRIBUTES,
+	KVM_MMU_NOTIFY_MEMSLOT,
+	KVM_MMU_NOTIFY_WP,
 	KVM_MMU_NOTIFY_ARCH1,
 	KVM_MMU_NOTIFY_ARCH2,
 	KVM_MMU_NOTIFY_ARCH3,
-- 
2.51.2

