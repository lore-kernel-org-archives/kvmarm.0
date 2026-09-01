Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E6E48BD3C
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282977; cv=none; b=lkGBYsUgrw4Ai0v/eoFuQhrElXF0ZbAycdgE9uy7rNjlYqDKclMBeYDLMqeZVwoBQUDF7ZTaMCqNis9503pAvY+KMWvhmq9YW1fjOIjMQpeQpFC5uTOBrn4Wnge/KQOJ535pwAC9IHl783Y0WdXeZCMADdNuz5G+iI27R10wtTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282977; c=relaxed/simple;
	bh=3CGe1F+LaFTs7xAtVeUDK/XWlmbVwQMDD0/oEPgFnn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohswu6DmKAOF9nOtaBoxlXaaji4++wySKWGONfjgkMNvl2Rrpqnfgc94w07Cmv6LP5LoPP5u5XvkMOJWhjuMcqW5IqhcCszv0noVYg9anthNVh+CoY6I5XHn1cV39zVuFV/FI6SHv3JEnswyTE2z5I8puJ7EE65PhurGkdrw+qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Eup5dkhi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Eup5dkhi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B110E1BD0;
	Tue,  1 Sep 2026 10:16:11 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 73A6F3F7D8;
	Tue,  1 Sep 2026 10:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788282975; bh=3CGe1F+LaFTs7xAtVeUDK/XWlmbVwQMDD0/oEPgFnn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eup5dkhiD8c0LRwp6elhFfAFvt//5n+haLAYubBe3qFVjz+eSY181qwyjRuubusZM
	 cU5VboOU11ZdCIEGzAuoAJ2TjwzF0RmFRMEaGmZfrK0UATiPmycPs2qpHR300fIVa7
	 IKqVsD4Zx/H5Y2q6fb4RmuRoYuIoN38qeUBroo70=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on migration
Date: Tue,  1 Sep 2026 18:15:56 +0100
Message-ID: <20260901171558.2674031-6-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901171558.2674031-1-leo.bras@arm.com>
References: <20260901171558.2674031-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7932; i=leo.bras@arm.com; h=from:subject; bh=3CGe1F+LaFTs7xAtVeUDK/XWlmbVwQMDD0/oEPgFnn8=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKms83Lkllnu3TiZJG9dfqbo6Sco49m6y5duLrYSCnqx gVTfv1pHaUsDGJcDLJiiiyyj+av4vk+JePIlR8LYOawMoEMYeDiFICJWLAwMrzN+73BaqPVVf4l wUn/9fM/q/Deb1Qslzh1R9RzwsGPqh6MDDtK+if/l80++jD6wdfkSrGZL3jnsP+OZLv+QFvrbmf DU14A
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

When dirty-logging is disabled, even non-write faults make a page dirty,
which avoids a second fault when the page is actually written to.

On dirty-logging enable, this approach causes all (writable) pages on the
memslot to be marked clean, even if they were not written to, which can
take a lot of time, while holding the MMU lock, doing atomic writes to
PTEs.

Systems with HAFDBS can use HW to mark a writable-clean page as
writable-dirty when a write occurs, avoiding the mentioned second fault,
while keeping dirty only the pages that have been actually written to.

So, if the system supports VHE + HAFDBS, keep the non-write-faulted page as
writable-clean, and let HAFDBS update that on demand when a write happens.

When dirty-tracking actually starts, disable HAFDBS as having it on
avoids the same fault that is used for dirty-logging.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h    |  6 ++++++
 arch/arm64/include/asm/kvm_nested.h |  9 +++++++--
 arch/arm64/kvm/arm.c                |  7 +++++++
 arch/arm64/kvm/mmu.c                | 26 +++++++++++++++++++++++++-
 4 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6eae7e7e2a68..3defa1a988d3 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -383,20 +383,26 @@ static inline void kvm_fault_unlock(struct kvm *kvm)
  * and CMOs are NOP'd. This has the effect of no longer requiring a
  * KVA for addresses mapped into the S2. The presence of these features
  * are thus necessary to support cacheable S2 mapping of VM_PFNMAP.
  */
 static inline bool kvm_supports_cacheable_pfnmap(void)
 {
 	return cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
 	       cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
 }
 
+static inline bool kvm_supports_hafdbs(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_ARM64_HW_AFDBM) && has_vhe() &&
+		!kvm_vcpu_has_nv(kvm) && cpus_have_final_cap(ARM64_HW_DBM);
+}
+
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
 void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu);
 void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu);
 #else
 static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
 static inline void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu) {}
 static inline void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu) {}
 #endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 1ed708335809..9242b5d665af 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -1,24 +1,29 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __ARM64_KVM_NESTED_H
 #define __ARM64_KVM_NESTED_H
 
 #include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_pgtable.h>
 
-static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
+static inline bool kvm_vcpu_has_nv(const struct kvm *kvm)
 {
 	return (!__is_defined(__KVM_NVHE_HYPERVISOR__) &&
 		cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
-		vcpu_has_feature(vcpu, KVM_ARM_VCPU_HAS_EL2));
+		kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_HAS_EL2));
+}
+
+static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_has_nv(vcpu->kvm);
 }
 
 /* Translation helpers from non-VHE EL2 to EL1 */
 static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
 {
 	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_IPS_SHIFT;
 }
 
 static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
 {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1e528d53d093..76aebaa95cda 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1676,20 +1676,27 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
 	 * KVM_ARM_VCPU_PMU_V3_SET_PMU.
 	 */
 	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
 	    !kvm_vcpu_has_pmuv3_strict(vcpu))
 		ret = kvm_arm_set_default_pmu(kvm);
 
 	/* Prepare for nested if required */
 	if (!ret && vcpu_has_nv(vcpu))
 		ret = kvm_vcpu_init_nested(vcpu);
 
+	/* Enable HAFDBS by default if VHE && !nested  */
+	if (kvm_supports_hafdbs(kvm) &&
+	    atomic_read(&kvm->nr_memslots_dirty_logging) == 0)
+		kvm->arch.mmu.vtcr |= VTCR_EL2_HD;
+	else
+		kvm->arch.mmu.vtcr &= ~VTCR_EL2_HD;
+
 	return ret;
 }
 
 static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 				 const struct kvm_vcpu_init *init)
 {
 	unsigned long features = init->features[0];
 	struct kvm *kvm = vcpu->kvm;
 	int ret = -EINVAL;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9d4f70430bbe..94094ab56d90 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1982,21 +1982,22 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(s2fd->vcpu))) {
 		kvm_inject_dabt_excl_atomic(s2fd->vcpu, kvm_vcpu_get_hfar(s2fd->vcpu));
 		return 1;
 	}
 
 	*prot = KVM_PGTABLE_PROT_R;
 
 	if (s2vi->map_writable) {
 		*prot |= KVM_PGTABLE_PROT_W;
 
-		if (s2vi->device || !memslot_is_logging(s2fd->memslot) ||
+		if (s2vi->device ||
+		    !(memslot_is_logging(s2fd->memslot) || kvm_supports_hafdbs(kvm)) ||
 		    kvm_is_write_fault(s2fd->vcpu))
 			*prot |= KVM_PGTABLE_PROT_DIRTY;
 	}
 
 	if (s2fd->nested)
 		*prot = adjust_nested_fault_perms(s2fd->nested, *prot);
 
 	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
 		*prot |= KVM_PGTABLE_PROT_X;
 
@@ -2570,53 +2571,76 @@ int __init kvm_mmu_init(u32 hyp_va_bits)
 
 out_destroy_pgtable:
 	kvm_pgtable_hyp_destroy(hyp_pgtable);
 out_free_pgtable:
 	kfree(hyp_pgtable);
 	hyp_pgtable = NULL;
 out:
 	return err;
 }
 
+static void kvm_set_hafdbs(struct kvm *kvm, bool set)
+{
+	/* Check if no action required */
+	if (!!(kvm->arch.mmu.vtcr & VTCR_EL2_HD) == set)
+		return;
+
+	if (set)
+		kvm->arch.mmu.vtcr |= VTCR_EL2_HD;
+	else
+		kvm->arch.mmu.vtcr &= ~VTCR_EL2_HD;
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);
+}
+
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
 	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
 
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
 	if (log_dirty_pages) {
 
 		if (change == KVM_MR_DELETE)
 			return;
 
+		/* Disable HAFDBS when dirty-logging starts */
+		if (kvm_supports_hafdbs(kvm))
+			kvm_set_hafdbs(kvm, 0);
+
 		/*
 		 * Huge and normal pages are write-protected and split
 		 * on either of these two cases:
 		 *
 		 * 1. with initial-all-set: gradually with CLEAR ioctls,
 		 */
 		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
 			return;
 		/*
 		 * or
 		 * 2. without initial-all-set: all in one shot when
 		 *    enabling dirty logging.
 		 */
 		kvm_mmu_wp_memory_region(kvm, new->id);
 		kvm_mmu_split_memory_region(kvm, new->id);
 	} else {
+		/* If dirty-logging was canceled, set HAFDBS back on */
+		if (kvm_supports_hafdbs(kvm) &&
+		    atomic_read(&kvm->nr_memslots_dirty_logging) == 0)
+			kvm_set_hafdbs(kvm, 1);
+
 		/*
 		 * Free any leftovers from the eager page splitting cache. Do
 		 * this when deleting, moving, disabling dirty logging, or
 		 * creating the memslot (a nop). Doing it for deletes makes
 		 * sure we don't leak memory, and there's no need to keep the
 		 * cache around for any of the other cases.
 		 */
 		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
 }
-- 
2.55.0

