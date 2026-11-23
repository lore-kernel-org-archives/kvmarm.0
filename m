Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430615;
	b=kifj8prBrI0JUTUmoyWwqBEHLw18XeZacvdbIbrAhUrNZzwPjY9B8gh1u8IxmJLerMvV
	 91gZLYDD82LCXBSNODZ1mpdcEt/VaDS05LAcJQALI0AvNBytUsEz0wOx0qSnOHz4Izds5
	 01Nbs2r+Okd0XzmvEu//qMlffhvsP0GBOa0pXaDdzd8zeOnxDsAsIxR9ebQo/H7AKsTKr
	 lRnwz7IMYSb18onjakW+8W969VcYYtM1EOjI6pkC1M8WtMGouKhlORK71788VfpVBk+sQ
	 xiLm648pBcjxwCyt6bReJJGcWwFlrtqnPEuOkjg7UqGazO3kfXpa7QqjYtGrdFdufRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430615;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=i803MTwZVBKyx9JC7SEHz7JZ9fDX9MdaE2X/HvSOFbc=;
	b=1vGQAcb3kc7l8nroRSqreSLxhVesl4Zp7SYzrjPOL4mtA7t8rwa1BYbdYZxGQ5kgi2zn
	 1uCaDJdYLXtNzCl82qATKXjhRV5Kfmf1DfYA6VKn2HwS/Knu6jiB6CbRaCJPikyQuPLdu
	 HAoXPIZ4ER9rK0HlRVoK+3vRa2itoqqViRAwBEOHoPfFj5BzFmtKrAXtkWegjFXJ1+Ij4
	 eEfQ5q0ySKTdLcTNgt4d2DVtd1ZprzvA6Vlv7fTaSt2Mt+2QIwyzKJfsV8z6nf1elzWo1
	 DbyNps/3PSt3g0e4iIAWFIvBTHXisWxQJSJt4zJYIFXBvLQTl0q+Rl8EiVM1zwdoYtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UvtiMrtl;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2BB1606A6A4;
	Mon, 23 Nov 2026 10:43:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2BB1606A6A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UvtiMrtl
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 793C4143D;
	Mon, 23 Nov 2026 02:43:31 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2122E3F632;
	Mon, 23 Nov 2026 02:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795430614; bh=SaaIrrvYRo4fkpFXfki2v+vOEFIHq9kUFX5p2zNuvqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvtiMrtlMx/XQsmkagCfeETLr5UpNcBHyCUD4ZEI7910xN9FKre/+MsRc5/eYXJoY
	 oLNYZfhY0zoPQ1jt8wPjEcvFwxbfXm1sTlG4f1OHXR7jGvORna8mc09/ZSMBqA1Brp
	 DRwfBSH3jIqLPUBWM/wCLZo+yLSvHW5xs9eGV578=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [PATCH v4 10/11] KVM: arm64: CCA: Support runtime faulting of memory
Date: Mon, 23 Nov 2026 10:42:30 +0000
Message-ID: <20261123104233.95710-11-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123104233.95710-1-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At runtime, if the realm guest accesses an IPA without a stage-2
mapping, then KVM fixes up the stage-2 mapping for the backing memory.

For memory in the lower (protected) region of IPA, verify that the
corresponding guest_memfd page is private before delegating to the RMM.
The RMM then maps the delegated page into the Realm.

For memory in the upper (shared) IPA region, map the backing page as
non-secure memory. Check that a guest_memfd page is shared when the
fault uses guest_memfd; ordinary userspace-backed memslots can only be
mapped at unprotected IPAs and follow the normal user memory fault path.

If the fault IPA and guest_memfd attributes disagree then exit to
userspace with KVM_EXIT_MEMORY_FAULT so the VMM can perform the required
conversion. If a shared IPA has no memslot, KVM follows the existing
MMIO or abort-injection path. The latter can result in injecting a SEA
to the guest.

Realm faults may need to create RTTs, including when updating a
mapping after a permission fault. Take the write side of mmu_lock
and top up the MMU cache for these faults. Do not pre-fault Realm
memory.

The lock helpers are in a header compiled by nVHE too. Make
kvm_vm_hyp_is_distrusting() available there for the lock choice.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v3:
- Split Realm faults into dedicated guest_memfd and userspace
  mapping paths, leaving the native fault paths unchanged.
- Unmap earlier shared mappings if a later RMI map call fails.
- Clarify that runtime RMI data mapping does not guarantee zeroed
  contents.

Changes since v2:
- Route all guest_memfd faults through gmem_abort(). Bound each
  protected RMI map call to its encoded range, create the required
  RTT levels, and tighten retry and error handling.

Changes since v1:
- Use the write side of mmu_lock and top up the MMU cache for Realm
  faults that may create RTTs. Skip unnecessary cache flushing,
  disable Realm pre-faulting, and tighten memory-fault and mapping
  retry handling.
---
 arch/arm64/include/asm/kvm_emulate.h |  13 ++
 arch/arm64/include/asm/kvm_host.h    |   4 +-
 arch/arm64/include/asm/kvm_mmu.h     |   4 +-
 arch/arm64/include/asm/kvm_rmi.h     |  12 ++
 arch/arm64/kvm/mmu.c                 | 174 +++++++++++++++--
 arch/arm64/kvm/rmi.c                 | 268 +++++++++++++++++++++++++++
 6 files changed, 459 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 32021bdf2610..8a71fddfdb85 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -847,4 +847,17 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
 	return kvm_vm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
 }
 
+static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t ipa)
+{
+	if (!kvm_vm_is_realm(kvm))
+		return ipa;
+
+	return ipa & ~BIT(kvm->arch.realm.ia_bits - 1);
+}
+
+static inline gfn_t kvm_gfn_from_fault(struct kvm *kvm, phys_addr_t ipa)
+{
+	return gpa_to_gfn(kvm_gpa_from_fault(kvm, ipa));
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 55673d08e3eb..505c0c5b7dbb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1601,12 +1601,12 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
-#define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
-
 #endif	/* __KVM_NVHE_HYPERVISOR__ */
 
 #define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
 
+#define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
+
 #define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)
 
 #define kvm_has_mte(kvm)					\
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 32392abf2e21..a70f8bd4b2b9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -371,7 +371,7 @@ static inline bool kvm_is_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 
 static inline void kvm_fault_lock(struct kvm *kvm)
 {
-	if (is_protected_kvm_enabled())
+	if (kvm_vm_hyp_is_distrusting(kvm))
 		write_lock(&kvm->mmu_lock);
 	else
 		read_lock(&kvm->mmu_lock);
@@ -379,7 +379,7 @@ static inline void kvm_fault_lock(struct kvm *kvm)
 
 static inline void kvm_fault_unlock(struct kvm *kvm)
 {
-	if (is_protected_kvm_enabled())
+	if (kvm_vm_hyp_is_distrusting(kvm))
 		write_unlock(&kvm->mmu_lock);
 	else
 		read_unlock(&kvm->mmu_lock);
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 8a136fb67318..697964b5b4e4 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -6,6 +6,7 @@
 #ifndef __ASM_KVM_RMI_H
 #define __ASM_KVM_RMI_H
 
+#include <asm/kvm_pgtable.h>
 #include <linux/arm-smccc-rmi.h>
 #include <linux/kvm.h>
 
@@ -90,4 +91,15 @@ void kvm_realm_unmap_range_filter(struct kvm *kvm,
 				  bool may_block,
 				  enum kvm_gfn_range_filter attr_filter);
 
+int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
+		  kvm_pfn_t pfn, unsigned long map_size,
+		  enum kvm_pgtable_prot prot,
+		  struct kvm_mmu_memory_cache *memcache);
+
+static inline bool kvm_realm_is_private_address(struct realm *realm,
+						unsigned long addr)
+{
+	return !(addr & BIT(realm->ia_bits - 1));
+}
+
 #endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9af5fe6d87f0..870dc7e2699b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -450,6 +450,10 @@ static void stage2_flush_vm(struct kvm *kvm)
 	struct kvm_memory_slot *memslot;
 	int idx, bkt;
 
+	/* The RMM requires FWB, so Realm stage-2 mappings need no cache flush. */
+	if (kvm_vm_is_realm(kvm))
+		return;
+
 	idx = srcu_read_lock(&kvm->srcu);
 	write_lock(&kvm->mmu_lock);
 
@@ -1225,6 +1229,10 @@ void stage2_unmap_vm(struct kvm *kvm)
 	struct kvm_memory_slot *memslot;
 	int idx, bkt;
 
+	/* For realms this is handled by the RMM so nothing to do here */
+	if (kvm_vm_is_realm(kvm))
+		return;
+
 	idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(current->mm);
 	write_lock(&kvm->mmu_lock);
@@ -1800,6 +1808,8 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 		ret = topup_mmu_memcache(s2fd->mmu, memcache);
 		if (ret)
 			return ret;
+	}
+	if (!perm_fault) {
 		if (kvm_is_nested_s2_mmu(kvm, pgt->mmu)) {
 			mapping = kmalloc_obj(struct kvm_guest_s2_mapping, GFP_KERNEL_ACCOUNT);
 			if (!mapping)
@@ -1808,7 +1818,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 	}
 
 	s2vi.vma_pagesize = PAGE_SIZE;
-	s2vi.gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi.vma_pagesize) >> PAGE_SHIFT;
+	s2vi.gfn = gpa_to_gfn(s2fd->fault_ipa);
 	canonical_gfn = get_canonical_gfn(s2fd, &s2vi);
 
 	write_fault = kvm_s2_fault_is_write(s2fd);
@@ -1890,6 +1900,66 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 	return ret;
 }
 
+static int realm_gmem_abort(const struct kvm_s2_fault_desc *s2fd)
+{
+	struct kvm *kvm = s2fd->vcpu->kvm;
+	bool write_fault = kvm_s2_fault_is_write(s2fd);
+	bool exec_fault = kvm_s2_fault_is_exec(s2fd);
+	bool is_private;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	u64 mmu_seq;
+	void *memcache;
+	int ret;
+
+	memcache = get_mmu_memcache(s2fd->vcpu);
+	ret = topup_mmu_memcache(s2fd->mmu, memcache);
+	if (ret)
+		return ret;
+
+	gfn = kvm_gfn_from_fault(kvm, s2fd->fault_ipa);
+	is_private = kvm_realm_is_private_address(&kvm->arch.realm,
+						  s2fd->fault_ipa);
+	VM_WARN_ON_ONCE(write_fault && exec_fault);
+
+	mmu_seq = kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
+
+	if (is_private != kvm_gmem_is_private_gfn(kvm, gfn)) {
+		kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(gfn),
+					      PAGE_SIZE, write_fault, exec_fault,
+					      is_private);
+		return -EFAULT;
+	}
+
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, NULL);
+	if (ret) {
+		kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(gfn),
+					      PAGE_SIZE, write_fault, exec_fault,
+					      is_private);
+		return ret;
+	}
+
+	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
+		prot |= KVM_PGTABLE_PROT_W;
+
+	kvm_fault_lock(kvm);
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+		ret = -EAGAIN;
+	} else {
+		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, PAGE_SIZE,
+				    prot, memcache);
+	}
+	kvm_fault_unlock(kvm);
+
+	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
+		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
+
+	return ret == -EAGAIN ? 0 : ret;
+}
+
 static int protected_pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
@@ -2050,7 +2120,8 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
 	 * mapping size to ensure we find the right PFN and lay down the
 	 * mapping in the right place.
 	 */
-	s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
+	s2vi->gfn = kvm_gfn_from_fault(kvm, ALIGN_DOWN(s2fd->fault_ipa,
+						       s2vi->vma_pagesize));
 
 	s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
 
@@ -2297,8 +2368,67 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	return ret;
 }
 
+static int realm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
+			      const struct kvm_s2_fault_vma_info *s2vi,
+			      enum kvm_pgtable_prot prot,
+			      void *memcache,
+			      struct kvm_s2_fault_result *result)
+{
+	struct kvm *kvm = s2fd->vcpu->kvm;
+	bool writable = prot & KVM_PGTABLE_PROT_W;
+	phys_addr_t canonical_ipa = gfn_to_gpa(s2vi->gfn);
+	long mapping_size = s2vi->vma_pagesize;
+	kvm_pfn_t pfn = s2vi->pfn;
+	gfn_t gfn = s2vi->gfn;
+	int ret = -EAGAIN;
+
+	kvm_fault_lock(kvm);
+	if (mmu_invalidate_retry(kvm, s2vi->mmu_seq))
+		goto out_unlock;
+
+	if (mapping_size == PAGE_SIZE && s2vi->max_map_size != PAGE_SIZE) {
+		mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
+		if (mapping_size < 0) {
+			ret = mapping_size;
+			goto out_unlock;
+		}
+		canonical_ipa = ALIGN_DOWN(canonical_ipa, mapping_size);
+	}
+
+	if (!kvm_s2_fault_is_perm(s2fd) && !s2vi->map_non_cacheable &&
+	    kvm_has_mte(kvm))
+		sanitise_mte_tags(kvm, pfn, mapping_size);
+
+	ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
+			    prot, memcache);
+
+out_unlock:
+	kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
+	kvm_fault_unlock(kvm);
+
+	if (writable && !ret)
+		mark_page_dirty_in_slot(kvm, s2fd->memslot,
+					gpa_to_gfn(canonical_ipa));
+
+	if (ret == -EAGAIN)
+		return result ? ret : 0;
+
+	if (result && !ret)
+		result->mapping_size = mapping_size;
+
+	return ret;
+}
+
+typedef int (*kvm_s2_fault_map_fn)(const struct kvm_s2_fault_desc *s2fd,
+				   const struct kvm_s2_fault_vma_info *s2vi,
+				   enum kvm_pgtable_prot prot,
+				   void *memcache,
+				   struct kvm_s2_fault_result *result);
+
 static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
-			  struct kvm_s2_fault_result *result)
+			  struct kvm_s2_fault_result *result,
+			  kvm_s2_fault_map_fn fault_map,
+			  bool topup_on_perm_fault)
 {
 	bool perm_fault = kvm_s2_fault_is_perm(s2fd);
 	struct kvm_s2_fault_vma_info s2vi = {};
@@ -2309,15 +2439,16 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
 	/*
 	 * Permission faults just need to update the existing leaf entry,
 	 * and so normally don't require allocations from the memcache. The
-	 * only exception to this is when dirty logging is enabled at runtime
+	 * exceptions are when dirty logging is enabled at runtime
 	 * and a fault needs to collapse a block entry into a table.
+	 * Realms can also require new RTT levels when replacing a mapping.
 	 * Under pKVM a permission fault can also collapse pages into a block,
 	 * which needs a fresh mapping object, and the hypervisor requires the
 	 * min-pages memcache even when the install allocates nothing.
 	 */
 	memcache = get_mmu_memcache(s2fd->vcpu);
 	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
-	    is_protected_kvm_enabled()) {
+	    is_protected_kvm_enabled() || topup_on_perm_fault) {
 		ret = topup_mmu_memcache(s2fd->mmu, memcache);
 		if (ret)
 			return ret;
@@ -2340,7 +2471,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
 		return ret;
 	}
 
-	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
+	return fault_map(s2fd, &s2vi, prot, memcache, result);
 }
 
 static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
@@ -2352,7 +2483,25 @@ static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	if (kvm_slot_has_gmem(s2fd->memslot))
 		return gmem_abort(s2fd, NULL);
 	else
-		return user_mem_abort(s2fd, NULL);
+		return user_mem_abort(s2fd, NULL, kvm_s2_fault_map, false);
+}
+
+static int __maybe_unused realm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+{
+	struct kvm *kvm = s2fd->vcpu->kvm;
+
+	VM_WARN_ON_ONCE(kvm_s2_fault_is_perm(s2fd) &&
+			!esr_abt_is_write_fault(s2fd->esr) &&
+			!kvm_s2_fault_is_exec(s2fd));
+
+	if (kvm_realm_is_private_address(&kvm->arch.realm, s2fd->fault_ipa) &&
+	    !kvm_slot_has_gmem(s2fd->memslot))
+		return -EINVAL;
+
+	if (kvm_slot_has_gmem(s2fd->memslot))
+		return realm_gmem_abort(s2fd);
+	else
+		return user_mem_abort(s2fd, NULL, realm_s2_fault_map, true);
 }
 
 /* Resolve the access fault by making the page young again. */
@@ -2461,10 +2610,10 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
  */
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct kvm_s2_trans nested_trans, *nested = NULL;
 	unsigned long esr = kvm_vcpu_get_esr(vcpu);
 	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
-	struct kvm *kvm = vcpu->kvm;
 	phys_addr_t fault_ipa; /* The address we faulted on */
 	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	struct kvm_memory_slot *memslot;
@@ -2557,8 +2706,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		nested = &nested_trans;
 	}
 
-	gfn = ipa >> PAGE_SHIFT;
+	gfn = kvm_gfn_from_fault(kvm, ipa);
 	memslot = gfn_to_memslot(kvm, gfn);
+
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = esr_abt_is_write_fault(esr);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
@@ -2601,7 +2751,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * of the page size.
 		 */
 		ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
-		ret = io_mem_abort(vcpu, ipa);
+		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(kvm, ipa));
 		goto out_unlock;
 	}
 
@@ -3124,7 +3274,7 @@ static long __pre_fault_s2(struct kvm_s2_mmu *mmu, struct kvm_vcpu *vcpu,
 	if (is_gmem)
 		ret = gmem_abort(&s2fd, &result);
 	else
-		ret = user_mem_abort(&s2fd, &result);
+		ret = user_mem_abort(&s2fd, &result, kvm_s2_fault_map, false);
 	if (IS_ERR_VALUE(ret))
 		return ret;
 	return result.mapping_size;
@@ -3160,7 +3310,7 @@ pre_fault_bytes_consumed(gpa_t gpa, unsigned long granule_size,
 
 int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
 {
-	if (is_protected_kvm_enabled())
+	if (is_protected_kvm_enabled() || kvm_vm_is_realm(vcpu->kvm))
 		return -EOPNOTSUPP;
 	if (!kvm_vcpu_initialized(vcpu))
 		return -ENOEXEC;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index b34f5320b50b..ab606a2dc2f5 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -593,6 +593,274 @@ void kvm_realm_unmap_range_filter(struct kvm *kvm, unsigned long start,
 	}
 }
 
+static unsigned long addr_range_desc(struct realm *realm,
+				     unsigned long ipa, unsigned long phys,
+				     unsigned long size, unsigned long state)
+{
+	unsigned long count = 1;
+	unsigned long out;
+	int rmi_size;
+
+	for (rmi_size = KVM_PGTABLE_LAST_LEVEL - realm->start_level;
+	     rmi_size >= 0; rmi_size--) {
+		unsigned long entry_size = rmi_addr_block_size_to_bytes(rmi_size);
+
+		if (size >= entry_size && IS_ALIGNED(ipa, entry_size) &&
+		    IS_ALIGNED(phys, entry_size))
+			break;
+	}
+
+	if (rmi_size == 0) {
+		/*
+		 * Stop at the next block boundary so that a later iteration can
+		 * use a larger mapping when both addresses are aligned.
+		 */
+		count = MIN(size >> PAGE_SHIFT, PTRS_PER_PTE - 1);
+		count = min(count, (PMD_SIZE - (ipa & (PMD_SIZE - 1))) >> PAGE_SHIFT);
+		count = min(count, (PMD_SIZE - (phys & (PMD_SIZE - 1))) >> PAGE_SHIFT);
+	}
+
+	WARN_ON(phys & ~PAGE_MASK);
+
+	out = FIELD_PREP(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, rmi_size) |
+	      FIELD_PREP(RMI_ADDR_RANGE_COUNT_MASK, count) |
+	      FIELD_PREP(RMI_ADDR_RANGE_STATE_MASK, state);
+	out |= phys & PAGE_MASK;
+
+	return out;
+}
+
+static int realm_map_protected(struct kvm *kvm,
+			       unsigned long ipa,
+			       kvm_pfn_t pfn,
+			       unsigned long map_size,
+			       struct kvm_mmu_memory_cache *memcache)
+{
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t phys = __pfn_to_phys(pfn);
+	phys_addr_t base_phys = phys;
+	phys_addr_t rd = realm->rd_phys;
+	phys_addr_t delegated_phys;
+	unsigned long base_ipa = ipa;
+	unsigned long ipa_top;
+	unsigned int retries = 0;
+	long ret = 0;
+
+	if (WARN_ON(!IS_ALIGNED(map_size, PAGE_SIZE) ||
+		    !IS_ALIGNED(ipa, map_size)))
+		return -EINVAL;
+
+	if (rmi_delegate_range(phys, map_size, &delegated_phys)) {
+		if (delegated_phys == phys) {
+			/*
+			 * It's likely we raced with another VCPU on the same
+			 * fault. Assume the other VCPU has handled the fault
+			 * and return to the guest.
+			 */
+			return 0;
+		}
+		/* Partial delegation - map as much as we can */
+		map_size = delegated_phys - phys;
+	}
+
+	ipa_top = ipa + map_size;
+
+	while (ipa < ipa_top) {
+		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
+		unsigned long range_desc = addr_range_desc(realm, ipa, phys,
+							   ipa_top - ipa,
+							   RMI_OP_MEM_DELEGATED);
+		unsigned long call_top = ipa + RMI_ADDR_RANGE_COUNT(range_desc) *
+			rmi_addr_block_size_to_bytes(RMI_ADDR_RANGE_BLOCK_SIZE(range_desc));
+		unsigned long out_top;
+
+		ret = rmi_rtt_data_map(rd, ipa, call_top, flags, range_desc,
+				       &out_top);
+		if (ret < 0)
+			goto err_undelegate;
+
+		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RESULT_DATA_LEVEL(ret);
+			int req_level = KVM_PGTABLE_LAST_LEVEL -
+				RMI_ADDR_RANGE_BLOCK_SIZE(range_desc);
+
+			if (++retries > KVM_PGTABLE_LAST_LEVEL + 2 ||
+			    level < realm->start_level || level >= req_level) {
+				ret = -ENXIO;
+				goto err_undelegate;
+			}
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      req_level,
+						      memcache);
+			if (ret)
+				goto err_undelegate;
+
+			continue;
+		}
+
+		if (ret) {
+			ret = RMI_RESULT_STATUS(ret) == RMI_BLOCKED ? -EAGAIN : -ENXIO;
+			goto err_undelegate;
+		}
+
+		/* An IRQ can stop the RMM before it maps the first entry. */
+		if (out_top == ipa) {
+			ret = -EAGAIN;
+			goto err_undelegate;
+		}
+		if (WARN_ON_ONCE(out_top < ipa || out_top > call_top)) {
+			ret = -ENXIO;
+			goto err_undelegate;
+		}
+
+		phys += out_top - ipa;
+		ipa = out_top;
+		retries = 0;
+	}
+
+	return 0;
+
+err_undelegate:
+	realm_unmap_private_range(kvm, base_ipa, ipa, false, memcache);
+	/* A range which cannot be undelegated remains owned by the RMM. */
+	WARN_ON(rmi_undelegate_range(base_phys, map_size));
+	return ret < 0 ? ret : -ENXIO;
+}
+
+static int realm_map_unprotected(struct kvm *kvm,
+				 unsigned long ipa,
+				 kvm_pfn_t pfn,
+				 unsigned long size,
+				 enum kvm_pgtable_prot prot,
+				 struct kvm_mmu_memory_cache *memcache)
+{
+	struct realm *realm = &kvm->arch.realm;
+	unsigned long attr, flags = 0;
+	phys_addr_t rd = realm->rd_phys;
+	phys_addr_t phys = __pfn_to_phys(pfn);
+	unsigned long base_ipa = ipa;
+	unsigned long ipa_top = ipa + size;
+	unsigned int retries = 0;
+	long ret;
+
+	if (WARN_ON(!IS_ALIGNED(size, PAGE_SIZE)))
+		return -EINVAL;
+
+	switch (prot & (KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC)) {
+	case KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC:
+		return -EINVAL;
+	case KVM_PGTABLE_PROT_DEVICE:
+		attr = MT_S2_FWB_DEVICE_nGnRE;
+		break;
+	case KVM_PGTABLE_PROT_NORMAL_NC:
+		attr = MT_S2_FWB_NORMAL_NC;
+		break;
+	default:
+		attr = MT_S2_FWB_NORMAL;
+	}
+
+	flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_MEMATTR_MASK, attr);
+
+	/*
+	 * An instruction fetch from an unprotected IPA takes a Synchronous
+	 * External Abort in the Realm. KVM never handles an execute permission
+	 * fault for an unprotected mapping.
+	 */
+	if (prot & KVM_PGTABLE_PROT_R)
+		flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP_MASK, RMI_S2AP_DIRECT_READ);
+	if (prot & KVM_PGTABLE_PROT_W)
+		flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP_MASK, RMI_S2AP_DIRECT_WRITE);
+
+	/* TODO: Batch mappings with RMI_ADDR_TYPE_LIST. */
+	flags |= RMI_ADDR_TYPE_SINGLE;
+
+	while (ipa < ipa_top) {
+		unsigned long range_desc = addr_range_desc(realm, ipa, phys,
+							   ipa_top - ipa,
+							   RMI_OP_MEM_UNDELEGATED);
+		unsigned long call_top = ipa + RMI_ADDR_RANGE_COUNT(range_desc) *
+			rmi_addr_block_size_to_bytes(RMI_ADDR_RANGE_BLOCK_SIZE(range_desc));
+		unsigned long out_top;
+
+		ret = rmi_rtt_unprot_map(rd, ipa, call_top, flags, range_desc,
+					 &out_top);
+		if (ret < 0)
+			goto err_unmap;
+
+		if (ret) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RESULT_DATA_LEVEL(ret);
+			int req_level = KVM_PGTABLE_LAST_LEVEL -
+				RMI_ADDR_RANGE_BLOCK_SIZE(range_desc);
+
+			if (RMI_RESULT_STATUS(ret) != RMI_ERROR_RTT ||
+			    ++retries > KVM_PGTABLE_LAST_LEVEL + 2) {
+				ret = -ENXIO;
+				goto err_unmap;
+			}
+
+			/* Replace an existing mapping to update its permissions. */
+			if (level >= req_level) {
+				realm_unmap_shared_range(kvm, ipa, ipa_top, false,
+							 memcache);
+				continue;
+			}
+
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      req_level,
+						      memcache);
+			if (ret)
+				goto err_unmap;
+
+			continue;
+		}
+
+		/* Retry the fault after releasing mmu_lock to service the IRQ. */
+		if (out_top == ipa) {
+			ret = -EAGAIN;
+			goto err_unmap;
+		}
+		if (WARN_ON_ONCE(out_top < ipa || out_top > call_top)) {
+			ret = -ENXIO;
+			goto err_unmap;
+		}
+
+		phys += out_top - ipa;
+		ipa = out_top;
+		retries = 0;
+	}
+
+	return 0;
+
+err_unmap:
+	/* Earlier iterations may have installed a writable mapping. */
+	realm_unmap_shared_range(kvm, base_ipa, ipa, false, memcache);
+	return ret;
+}
+
+int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
+		  kvm_pfn_t pfn, unsigned long map_size,
+		  enum kvm_pgtable_prot prot,
+		  struct kvm_mmu_memory_cache *memcache)
+{
+	struct realm *realm = &kvm->arch.realm;
+
+	if (kvm_realm_state(kvm) != REALM_STATE_ACTIVE)
+		return -EBUSY;
+
+	ipa = ALIGN_DOWN(ipa, map_size);
+	if (!kvm_realm_is_private_address(realm, ipa)) {
+		return realm_map_unprotected(kvm, ipa, pfn, map_size, prot,
+					    memcache);
+	}
+
+	/* It's impossible to map protected pages read-only. */
+	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
+		return -EFAULT;
+	return realm_map_protected(kvm, ipa, pfn, map_size, memcache);
+}
+
 void kvm_destroy_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
-- 
2.43.0

