Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4DA42EEC4;
	Mon,  5 Oct 2026 09:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191325; cv=none; b=hh0dDFaZTLbT8FLqLPtQZnQ5I5wAK4offjBtiz+Q/sNK+XdyIC2eWd5YG9sVXKJ0kcgUJyladMFR0q3/T1TkwU8JMdIvtAm5uU7tgnjxXHsZpb2/Jpo7JjFPAAkMoaRffT4lb8kHzV1coMDn8gKTQTgXqVxLhEYv/lU13jcGSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191325; c=relaxed/simple;
	bh=eqjl7qWOwsGiHAPrcoxDWMkRjkjCH26RWONLTxrAVMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pzddv/OwlxBTWuE33YT4CihogBV7qET7QTb4DgmWce9HT4dNYlAcqhSObJH7HwJdnWwa+/71l1NotOeXu6aIG+WsgDSbn+2zSB+lLu0/KragUnb0a5T8/GnA4Fit4XsR/GeHZEgTNmK0pXX3g16g70Ak5Eg8p+XVu+Z67bKYaOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dmAd+xEb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dmAd+xEb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A98A152B;
	Mon,  5 Oct 2026 02:08:39 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 05FED3FA7A;
	Mon,  5 Oct 2026 02:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191323; bh=eqjl7qWOwsGiHAPrcoxDWMkRjkjCH26RWONLTxrAVMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmAd+xEbXChGTW14/iTIlXOU386OEv39XH/cgt9zxdUq6E+5ok5TbCELPTSN9sYUL
	 xUzaopYn0YagFSitC8+DrXfXREnGc/1dlHAkrhaW7vPFfCRQ8ZXB+s5w4GugmDsrrh
	 26+rP/lXiiOqL3RtEaM0ueF6PCsggXNaXHzGlM6k=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v22 11/23] KVM: arm64: Add VM specific callback for S2 MMU operations
Date: Mon,  5 Oct 2026 10:07:42 +0100
Message-ID: <20261005090754.2140522-12-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add VM type specific S2 MMU operation backends which can be initialized per
VM flavor, to keep the handling cleaner.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Change since v21:
 - Define all vm_s2_ops call back. All calls are mandatory.
 - Define callback for each flavor, disjointing the non-protetcted pKVM and
   normal KVM (VHE & nVHE) and remove the KVM_PGT_FN() hacks.
 - Dropped Reviews due to the changes.
 - Add "no_age_gfn" and "no_stage2_unmap_range" for pKVM callbacks, no_age_*
   to be also reused by Realms later.
 - Move kvm_vm_s2_ops field to keep the structure packed
---
 arch/arm64/include/asm/kvm_host.h |  14 +++
 arch/arm64/kvm/mmu.c              | 173 +++++++++++++++++++++++++-----
 2 files changed, 160 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 839f5e9c7c65e..0778c308ce597 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -155,6 +155,19 @@ struct kvm_vcpu_ops {
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 };
 
+struct kvm_gfn_range;
+
+struct kvm_vm_s2_ops {
+	bool (*vm_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
+	bool (*vm_test_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
+	int (*vm_flush_remote_tlbs)(struct kvm *kvm);
+	int (*vm_flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
+					  u64 nr_pages);
+	void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
+				      phys_addr_t start, u64 size,
+				      bool may_block);
+};
+
 struct kvm_s2_mmu {
 	struct kvm_vmid vmid;
 
@@ -321,6 +334,7 @@ enum kvm_arm_vm_flavor {
 
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
+	const struct kvm_vm_s2_ops *vm_s2_ops;
 
 	enum kvm_arm_vm_flavor vm_flavor;
 	/* Mandated version of PSCI */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4ae3bb6baef1a..c046c76833876 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -37,6 +37,8 @@ static unsigned long __ro_after_init io_map_base;
 
 #define KVM_PGT_FN(fn)		(!is_protected_kvm_enabled() ? fn : p ## fn)
 
+static int kvm_vm_init_vm_s2_ops(struct kvm *kvm);
+
 static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
 					   phys_addr_t size)
 {
@@ -166,6 +168,18 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
 }
 
+static int pkvm_flush_remote_tlbs(struct kvm *kvm)
+{
+	kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
+	return 0;
+}
+
+static int kvm_vm_flush_remote_tlbs(struct kvm *kvm)
+{
+	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
+	return 0;
+}
+
 /**
  * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
  * @kvm:	pointer to kvm structure.
@@ -174,26 +188,31 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
-	if (is_protected_kvm_enabled())
-		kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
-	else
-		kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
-	return 0;
+	return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs(kvm);
 }
 
-int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
-				      gfn_t gfn, u64 nr_pages)
+static int pkvm_flush_remote_tlbs_range(struct kvm *kvm,
+					gfn_t gfn, u64 nr_pages)
+{
+	return pkvm_flush_remote_tlbs(kvm);
+}
+
+static int kvm_vm_flush_remote_tlbs_range(struct kvm *kvm,
+					 gfn_t gfn, u64 nr_pages)
 {
 	u64 size = nr_pages << PAGE_SHIFT;
 	u64 addr = gfn << PAGE_SHIFT;
 
-	if (is_protected_kvm_enabled())
-		kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
-	else
-		kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
+	kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
 	return 0;
 }
 
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+				     gfn_t gfn, u64 nr_pages)
+{
+	return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range(kvm, gfn, nr_pages);
+}
+
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_memory_cache *mc = arg;
@@ -289,6 +308,27 @@ static void invalidate_icache_guest_page(void *va, size_t size)
 	__invalidate_icache_guest_page(va, size);
 }
 
+static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
+				      phys_addr_t start,
+				      u64 size, bool may_block)
+{
+	WARN_ON(stage2_apply_range(mmu, start, start + size,
+				   kvm_pgtable_stage2_unmap, may_block));
+}
+
+static void pkvm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
+				    phys_addr_t start,
+				    u64 size, bool may_block)
+{
+	WARN_ON(stage2_apply_range(mmu, start, start + size,
+				   pkvm_pgtable_stage2_unmap, may_block));
+}
+
+static void no_stage2_unmap_range(struct kvm_s2_mmu *mmu,
+				  phys_addr_t start, u64 size, bool may_block)
+{
+}
+
 /*
  * Unmapping vs dcache management:
  *
@@ -329,15 +369,10 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 
-	if (kvm_vm_is_protected(kvm))
-		return;
-
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
 
-	WARN_ON(stage2_apply_range(mmu, start, start + size,
-				   KVM_PGT_FN(kvm_pgtable_stage2_unmap),
-				   may_block));
+	kvm->arch.vm_s2_ops->vm_stage2_unmap_range(mmu, start, size, may_block);
 }
 
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
@@ -977,6 +1012,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	int cpu, err;
 	struct kvm_pgtable *pgt;
 
+	/* Initialize the VM ops for the VM instance for the first time */
+	if (mmu == &kvm->arch.mmu) {
+		err = kvm_vm_init_vm_s2_ops(kvm);
+		if (err)
+			return err;
+	}
 	/*
 	 * If we already have our page tables in place, and that the
 	 * MMU context is the canonical one, we have a bug somewhere,
@@ -2441,34 +2482,68 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return false;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+static bool kvm_vm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
-	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
-		return false;
-
-	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
+	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, true);
+}
+
+static bool pkvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	u64 size = (range->end - range->start) << PAGE_SHIFT;
+
+	return pkvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
+						    range->start << PAGE_SHIFT,
+						    size, true);
+}
+
+static bool no_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	/* The hypervisor doesn't support aging */
+	return false;
+}
+
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	if (!kvm->arch.mmu.pgt)
+		return false;
+
+	return kvm->arch.vm_s2_ops->vm_age_gfn(kvm, range);
 	/*
 	 * TODO: Handle nested_mmu structures here using the reverse mapping in
 	 * a later version of patch series.
 	 */
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+static bool kvm_vm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
-	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
-		return false;
-
-	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
+	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, false);
 }
 
+static bool pkvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	u64 size = (range->end - range->start) << PAGE_SHIFT;
+
+	return pkvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
+						    range->start << PAGE_SHIFT,
+						    size, false);
+}
+
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	if (!kvm->arch.mmu.pgt)
+		return false;
+
+	return kvm->arch.vm_s2_ops->vm_test_age_gfn(kvm, range);
+}
+
 phys_addr_t kvm_mmu_get_httbr(void)
 {
 	return __pa(hyp_pgtable->pgd);
@@ -2790,3 +2865,47 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
+	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
+	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
+	.vm_age_gfn			= no_age_gfn,
+	.vm_test_age_gfn		= no_age_gfn,
+	.vm_stage2_unmap_range		= no_stage2_unmap_range,
+};
+
+static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
+	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
+	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
+	.vm_age_gfn			= pkvm_age_gfn,
+	.vm_test_age_gfn		= pkvm_test_age_gfn,
+	.vm_stage2_unmap_range		= pkvm_stage2_unmap_range,
+};
+
+static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
+	.vm_flush_remote_tlbs		= kvm_vm_flush_remote_tlbs,
+	.vm_flush_remote_tlbs_range	= kvm_vm_flush_remote_tlbs_range,
+	.vm_age_gfn			= kvm_vm_age_gfn,
+	.vm_test_age_gfn		= kvm_vm_test_age_gfn,
+	.vm_stage2_unmap_range		= kvm_vm_stage2_unmap_range,
+};
+
+#define KVM_VM_S2_OPS(flavor, ops)		\
+		[flavor] = &(ops)
+
+static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
+	KVM_VM_S2_OPS(VM_VHE, kvm_default_vm_s2_ops),
+	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
+	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
+	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
+};
+
+static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(arm64_vm_s2_ops) != VM_FLAVOR_MAX);
+
+	kvm->arch.vm_s2_ops = arm64_vm_s2_ops[kvm->arch.vm_flavor];
+	if (WARN_ON(!kvm->arch.vm_s2_ops))
+		return -EINVAL;
+	return 0;
+}
-- 
2.43.0

