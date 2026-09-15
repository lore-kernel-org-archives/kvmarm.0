Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F814BD0E0;
	Tue, 15 Sep 2026 16:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488143; cv=none; b=MsVQ5eUM3S5a5US5pOuetYL3AGIqxPZ+NYvd6SEmO0REFBavnPn+T0sWrfhRmdjz1M0tUTAlO8DyGFOXeOzm6pGzIuXTVFYsDPZWHh72CvyabfZt/4kbsTuZHiivMcWDYIDw6B50Dm0V9kOEyaARM9hZTtYPOhY/KUgxmWxD5Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488143; c=relaxed/simple;
	bh=3VMx5MwIoQDjnI9Qu/OvOYrvB82xGQiLBVLLsk3Gcx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Irln6XKfjMiMANUhcCIgtoqBz9Wv6yzIfVrr3fKc/INvMXq2pcNkMStWWn6u8QWTG9GKEA5EgrQPsNp+D1m89lJHqDauCLeD4HmaWPtnDYR3T8yquAzkrbG+fShlVHimsQEDUn39O/cmQC4+euPU5O2zLdxOb12ZfPopWjBrFJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DRI2zR/s; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DRI2zR/s"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A339315A1;
	Tue, 15 Sep 2026 09:02:16 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8BF253F882;
	Tue, 15 Sep 2026 09:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789488140; bh=3VMx5MwIoQDjnI9Qu/OvOYrvB82xGQiLBVLLsk3Gcx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRI2zR/sQ3OywYBjEfa4m7sT3HReSjGgyJzGexBbYZDleQIwmFPXMqlmDoJ6xJUaj
	 p1/mMOHS7nQ+bpt7azVo5UigJZT3UVCLXn+MypdoF+UD9nXc53fDfDjWfKleebBR0O
	 yxGQc+1uEyevJQtq7QWD5k1fj+qG36Q38bwM8ENU=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v18 09/23] KVM: arm64: Add VM specific callback for S2 MMU operations
Date: Tue, 15 Sep 2026 17:01:27 +0100
Message-ID: <20260915160141.3543048-10-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915160141.3543048-1-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add VM type specific S2 MMU operation backends which can be initialized per VM
flavor, to keep the handling cleaner. Realm VM ops will be added gradually.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  15 ++++
 arch/arm64/kvm/mmu.c              | 137 +++++++++++++++++++++++++-----
 2 files changed, 131 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8601103717643..ad3b34ba0b805 100644
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
 
@@ -331,6 +344,8 @@ struct kvm_arch {
 	 */
 	u64 fgu[__NR_FGT_GROUP_IDS__];
 
+	const struct kvm_vm_s2_ops *vm_s2_ops;
+
 	/*
 	 * Stage 2 paging state for VMs with nested S2 using a virtual
 	 * VMID.
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 67852acf7a6f8..3d8b6e5b811ed 100644
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
@@ -174,26 +188,36 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
-	if (is_protected_kvm_enabled())
-		kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
-	else
-		kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
-	return 0;
+	if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs)
+		return 1;
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
+	if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range)
+		return 1;
+
+	return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range(kvm, gfn, nr_pages);
+}
+
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_memory_cache *mc = arg;
@@ -337,13 +361,20 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 				   may_block));
 }
 
+static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
+				      phys_addr_t start,
+				      u64 size, bool may_block)
+{
+	__unmap_stage2_range(mmu, start, size, may_block);
+}
+
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 			    u64 size, bool may_block)
 {
-	if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
-		return;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 
-	__unmap_stage2_range(mmu, start, size, may_block);
+	if (kvm->arch.vm_s2_ops->vm_stage2_unmap_range)
+		kvm->arch.vm_s2_ops->vm_stage2_unmap_range(mmu, start, size, may_block);
 }
 
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
@@ -983,6 +1014,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
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
@@ -2447,34 +2484,46 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return false;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+static bool kvm_vm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
-	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
-		return false;
-
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, true);
+}
+
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	if (!kvm->arch.mmu.pgt || !kvm->arch.vm_s2_ops->vm_age_gfn)
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
 
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, false);
 }
 
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+
+	if (!kvm->arch.mmu.pgt || !kvm->arch.vm_s2_ops->vm_test_age_gfn)
+		return false;
+
+	return kvm->arch.vm_s2_ops->vm_test_age_gfn(kvm, range);
+}
+
 phys_addr_t kvm_mmu_get_httbr(void)
 {
 	return __pa(hyp_pgtable->pgd);
@@ -2796,3 +2845,49 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
+	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
+	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
+	/*
+	 * Not supported for Protected VMs under pKVM
+	 * .vm_age_gfn
+	 * .vm_test_age_gfn
+	 * .vm_stage2_unmap_range
+	 */
+};
+
+static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
+	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
+	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
+	.vm_age_gfn			= kvm_vm_age_gfn,
+	.vm_test_age_gfn		= kvm_vm_test_age_gfn,
+	.vm_stage2_unmap_range		= kvm_vm_stage2_unmap_range,
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
+		[flavor] = ops
+static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
+	KVM_VM_S2_OPS(VM_VHE, &kvm_default_vm_s2_ops),
+	KVM_VM_S2_OPS(VM_NVHE, &kvm_default_vm_s2_ops),
+	KVM_VM_S2_OPS(VM_PKVM, &pkvm_vm_s2_ops),
+	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, &protected_pkvm_vm_s2_ops),
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

