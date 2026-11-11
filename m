Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409147;
	b=QdwCDxRsJJv2HZf42Ue89pTv6aUzdw8BI8YasNG+T80iQktk6wDDuuqJC5bHn2tiuZIb
	 a2aebr2Z7L+rKGM8MJxSyXjMGSDAHNQUPLBk4M3ebL8s1ZsJHaCc3ELtxrxZg4+SiqNn1
	 QNPireDE0EtBopyxbz06HiL+lr0yTxuyBfRhEvIW8+poUG3HlUBbVvbmhDZH2gsTsrCvg
	 UK2T+0nL1z4tndvWbZQsM6fHyq6DVD69bH2IhgKrwQH3WuM41IWtQ5gQ+Vl8bpzZZi4Za
	 3xdzOAKDektEqLderRJ79aiGjg3/I+YAflRILxJqTLnbKLvWgoA0RhErHDZN9OcXyVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409147;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5epL05d/zXdqFfKKgKmTj79d/4BNz/hvF2GqxOln1e0=;
	b=PQ+LQX9zQFx6vUz3fKE2iEQFTOX3AecYx8LCdor+U+TOT2HuDtlzjRph5J84k5NadrDd
	 aCYZwfJs5aXGd8hSSAlVy/3rraS/FraZC5hTMvTznE56gCHYIake2Lu4nN6bhAlyM/eVR
	 6AMQGKvqFNZBprf5wDhEWEv/Pj/T4lq1qMCdFD/qKkpiZ3jTkoSV29mVPhWvOhf3ZXN2I
	 9klqDVQTkTVMLuL9/LdOklBj5Qv7XDbCHjOYX1b9IUg2BxJJXXyaoMLo+vM9bihCXJyEX
	 boqzRT/67mceRsIoc/uWiwlozq13+YEnN8P1XnyukkeEInmxdlafJPRT6OagndFhVTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=m8AjYu33;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44886606A8AF;
	Wed, 11 Nov 2026 14:59:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44886606A8AF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=m8AjYu33
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BF041C2B;
	Wed, 11 Nov 2026 06:59:02 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DFC83F632;
	Wed, 11 Nov 2026 06:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794409145; bh=jVRRFJkiKvQQn3EguPkimezjfrpF4N26iYshgaxqGzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8AjYu331KqoMb/gpr8eounkNfdP3xaCpsKd2oeA6Uvabfwg6I2h1c2TJTUUv//oS
	 W6Jp3s+8sKZ5Y1b4LqSZ1srM3yqmAlfVhb4QUetljr/JbiZX1oFRD/G3lANsjUUF2w
	 b+kHT+iQHrVsq+yK7t8lElsFnBNyden4zIDh/Yc8=
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
Subject: [PATCH v2 11/12] KVM: arm64: CCA: Support runtime faulting of memory
Date: Wed, 11 Nov 2026 14:57:55 +0000
Message-ID: <20261111145758.217946-12-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111145758.217946-1-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
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
The RMM then maps the page into the realm and initializes its contents
to zero.

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

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v1:
- Use the write side of mmu_lock and top up the MMU cache for Realm
  faults that may create RTTs. Skip unnecessary cache flushing,
  disable Realm pre-faulting, and tighten memory-fault and mapping
  retry handling.
---
 arch/arm64/include/asm/kvm_emulate.h |  13 ++
 arch/arm64/include/asm/kvm_mmu.h     |   4 +-
 arch/arm64/include/asm/kvm_rmi.h     |   6 +
 arch/arm64/kvm/mmu.c                 | 115 +++++++++++--
 arch/arm64/kvm/rmi.c                 | 235 +++++++++++++++++++++++++++
 5 files changed, 353 insertions(+), 20 deletions(-)

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
index e64c3bcce160..d1ba0c325bb0 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -6,6 +6,7 @@
 #ifndef __ASM_KVM_RMI_H
 #define __ASM_KVM_RMI_H
 
+#include <asm/kvm_pgtable.h>
 #include <linux/arm-smccc-rmi.h>
 #include <linux/kvm.h>
 
@@ -89,6 +90,11 @@ void kvm_realm_unmap_range_filter(struct kvm *kvm,
 				  bool may_block,
 				  enum kvm_gfn_range_filter attr_filter);
 
+int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
+		  kvm_pfn_t pfn, unsigned long map_size,
+		  enum kvm_pgtable_prot prot,
+		  struct kvm_mmu_memory_cache *memcache);
+
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
 {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e550360fc94d..b6c61d7890c8 100644
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
 
@@ -1222,6 +1226,10 @@ void stage2_unmap_vm(struct kvm *kvm)
 	struct kvm_memory_slot *memslot;
 	int idx, bkt;
 
+	/* For realms this is handled by the RMM so nothing to do here */
+	if (kvm_vm_is_realm(kvm))
+		return;
+
 	idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(current->mm);
 	write_lock(&kvm->mmu_lock);
@@ -1791,12 +1799,18 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 	void *memcache = NULL;
 	gfn_t canonical_gfn;
 	int ret;
+	bool is_private = false;
 
-	if (!perm_fault) {
+	if (KVM_BUG_ON(!kvm_slot_has_gmem(s2fd->memslot), kvm))
+		return -EINVAL;
+
+	if (!perm_fault || kvm_arch_has_private_mem(kvm)) {
 		memcache = get_mmu_memcache(s2fd->vcpu);
 		ret = topup_mmu_memcache(s2fd->mmu, memcache);
 		if (ret)
 			return ret;
+	}
+	if (!perm_fault) {
 		if (kvm_is_nested_s2_mmu(kvm, pgt->mmu)) {
 			mapping = kmalloc_obj(struct kvm_guest_s2_mapping, GFP_KERNEL_ACCOUNT);
 			if (!mapping)
@@ -1805,7 +1819,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 	}
 
 	s2vi.vma_pagesize = PAGE_SIZE;
-	s2vi.gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi.vma_pagesize) >> PAGE_SHIFT;
+	s2vi.gfn = gpa_to_gfn(kvm_gpa_from_fault(kvm, s2fd->fault_ipa));
 	canonical_gfn = get_canonical_gfn(s2fd, &s2vi);
 
 	write_fault = kvm_s2_fault_is_write(s2fd);
@@ -1817,13 +1831,35 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
+	if (kvm_arch_has_private_mem(kvm)) {
+		switch (kvm->arch.vm_flavor) {
+		case VM_REALM:
+			is_private = kvm_realm_is_private_address(&kvm->arch.realm,
+								  s2fd->fault_ipa);
+			break;
+		default:
+			break;
+		}
+
+		if (is_private != kvm_gmem_is_private_gfn(kvm, canonical_gfn)) {
+			if (!result)
+				kvm_prepare_memory_fault_exit(s2fd->vcpu,
+							      gfn_to_gpa(canonical_gfn),
+							      PAGE_SIZE,
+							      write_fault, exec_fault,
+							      is_private);
+			kfree(mapping);
+			return -EFAULT;
+		}
+	}
+
 	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, NULL);
 	if (ret) {
 		/* If result is non-NULL this is a synthetic fault. */
 		if (!result)
 			kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(canonical_gfn),
 						      s2vi.vma_pagesize, write_fault, exec_fault,
-						      false);
+						      is_private);
 		kfree(mapping);
 		return ret;
 	}
@@ -1846,6 +1882,16 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 		goto out_unlock;
 	}
 
+	switch (kvm->arch.vm_flavor) {
+	case VM_REALM:
+		prot &= ~KVM_PGTABLE_PROT_X;
+		ret = realm_map_ipa(kvm, s2fd->fault_ipa, s2vi.pfn,
+				    PAGE_SIZE, prot, memcache);
+		goto out_unlock;
+	default:
+		break;
+	}
+
 	if (perm_fault) {
 		/*
 		 * Drop the SW bits in favour of those stored in the
@@ -2047,7 +2093,8 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
 	 * mapping size to ensure we find the right PFN and lay down the
 	 * mapping in the right place.
 	 */
-	s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
+	s2vi->gfn = kvm_gfn_from_fault(kvm, ALIGN_DOWN(s2fd->fault_ipa,
+						       s2vi->vma_pagesize));
 
 	s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
 
@@ -2227,7 +2274,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	 * possible.
 	 */
 	if (mapping_size == PAGE_SIZE && s2vi->max_map_size != PAGE_SIZE) {
-		if (perm_fault_granule > PAGE_SIZE) {
+		if (perm_fault_granule > PAGE_SIZE && !kvm_vm_is_realm(kvm)) {
 			mapping_size = perm_fault_granule;
 		} else {
 			mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
@@ -2242,12 +2289,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
 		sanitise_mte_tags(kvm, pfn, mapping_size);
 
-	/*
-	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-	 * permissions only if mapping_size equals perm_fault_granule. Otherwise,
-	 * kvm_pgtable_stage2_map() should be called to change block size.
-	 */
-	if (mapping_size == perm_fault_granule) {
+	if (kvm_vm_is_realm(kvm)) {
+		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
+				    prot, memcache);
+	} else if (mapping_size == perm_fault_granule) {
+		/*
+		 * Under the premise of getting a FSC_PERM fault, we just need to relax
+		 * permissions only if mapping_size equals perm_fault_granule. Otherwise,
+		 * kvm_pgtable_stage2_map() should be called to change block size.
+		 */
 		/*
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
@@ -2306,15 +2356,16 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
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
+	    is_protected_kvm_enabled() || kvm_vm_is_realm(s2fd->vcpu->kvm)) {
 		ret = topup_mmu_memcache(s2fd->mmu, memcache);
 		if (ret)
 			return ret;
@@ -2340,13 +2391,40 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
 	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
 }
 
+static bool private_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa)
+{
+	return kvm_vm_is_realm(kvm) &&
+		kvm_realm_is_private_address(&kvm->arch.realm, fault_ipa);
+}
+
+/* Decide if an abort should be handled by the gmem */
+static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
+				    const struct kvm_s2_fault_desc *s2fd)
+{
+	if (!kvm_slot_has_gmem(s2fd->memslot))
+		return false;
+	if (kvm_memslot_is_gmem_only(s2fd->memslot))
+		return true;
+	/*
+	 * For Realms, all private faults must be backed by GMEM.
+	 * TODO: Handle Trusted device private memory mappings.
+	 */
+	if (private_ipa_fault(kvm, s2fd->fault_ipa))
+		return true;
+	return false;
+}
+
 static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	VM_WARN_ON_ONCE(kvm_s2_fault_is_perm(s2fd) &&
 			!esr_abt_is_write_fault(s2fd->esr) &&
 			!kvm_s2_fault_is_exec(s2fd));
 
-	if (kvm_slot_has_gmem(s2fd->memslot))
+	if (private_ipa_fault(s2fd->vcpu->kvm, s2fd->fault_ipa) &&
+	    !kvm_slot_has_gmem(s2fd->memslot))
+		return -EINVAL;
+
+	if (kvm_fault_is_gmem_abort(s2fd->vcpu->kvm, s2fd))
 		return gmem_abort(s2fd, NULL);
 	else
 		return user_mem_abort(s2fd, NULL);
@@ -2458,10 +2536,10 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
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
@@ -2554,8 +2632,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		nested = &nested_trans;
 	}
 
-	gfn = ipa >> PAGE_SHIFT;
+	gfn = kvm_gfn_from_fault(kvm, ipa);
 	memslot = gfn_to_memslot(kvm, gfn);
+
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = esr_abt_is_write_fault(esr);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
@@ -2598,7 +2677,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * of the page size.
 		 */
 		ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
-		ret = io_mem_abort(vcpu, ipa);
+		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(kvm, ipa));
 		goto out_unlock;
 	}
 
@@ -3156,7 +3235,7 @@ pre_fault_bytes_consumed(gpa_t gpa, unsigned long granule_size,
 
 int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
 {
-	if (is_protected_kvm_enabled())
+	if (is_protected_kvm_enabled() || kvm_vm_is_realm(vcpu->kvm))
 		return -EOPNOTSUPP;
 	if (!kvm_vcpu_initialized(vcpu))
 		return -ENOEXEC;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 5aa34d68de59..682ed7005d57 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -551,6 +551,241 @@ void kvm_realm_unmap_range_filter(struct kvm *kvm, unsigned long start,
 		realm_unmap_private_range(kvm, start, end, may_block);
 }
 
+static unsigned long addr_range_desc(unsigned long ipa, unsigned long phys,
+				     unsigned long size, unsigned long state)
+{
+	unsigned long count = 1;
+	unsigned long out;
+	int rmi_size;
+
+	for (rmi_size = KVM_PGTABLE_LAST_LEVEL; rmi_size >= 0; rmi_size--) {
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
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	phys_addr_t delegated_phys;
+	unsigned long base_ipa = ipa;
+	unsigned long ipa_top;
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
+		unsigned long range_desc = addr_range_desc(ipa, phys, ipa_top - ipa,
+							   RMI_OP_MEM_DELEGATED);
+		unsigned long out_top;
+
+		ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags, range_desc,
+				       &out_top);
+		if (ret < 0)
+			goto err_undelegate;
+
+		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RESULT_DATA_LEVEL(ret);
+
+			if (WARN_ON(level >= KVM_PGTABLE_LAST_LEVEL))
+				goto err_undelegate;
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      level + 1,
+						      memcache);
+			if (ret)
+				goto err_undelegate;
+
+			continue;
+		}
+
+		if (WARN_ON(ret))
+			goto err_undelegate;
+
+		/* An IRQ can stop the RMM before it maps the first entry. */
+		if (out_top == ipa) {
+			ret = -EAGAIN;
+			goto err_undelegate;
+		}
+		if (WARN_ON_ONCE(out_top < ipa || out_top > ipa_top)) {
+			ret = -ENXIO;
+			goto err_undelegate;
+		}
+
+		phys += out_top - ipa;
+		ipa = out_top;
+	}
+
+	return 0;
+
+err_undelegate:
+	realm_unmap_private_range(kvm, base_ipa, ipa, false);
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
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	phys_addr_t phys = __pfn_to_phys(pfn);
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
+	if (prot & KVM_PGTABLE_PROT_R)
+		flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP_MASK, RMI_S2AP_DIRECT_READ);
+	if (prot & KVM_PGTABLE_PROT_W)
+		flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP_MASK, RMI_S2AP_DIRECT_WRITE);
+
+	/* TODO: Batch mappings with RMI_ADDR_TYPE_LIST. */
+	flags |= RMI_ADDR_TYPE_SINGLE;
+
+	while (ipa < ipa_top) {
+		unsigned long range_desc = addr_range_desc(ipa, phys, ipa_top - ipa,
+							   RMI_OP_MEM_UNDELEGATED);
+		unsigned long call_top = ipa + RMI_ADDR_RANGE_COUNT(range_desc) *
+			rmi_addr_block_size_to_bytes(RMI_ADDR_RANGE_BLOCK_SIZE(range_desc));
+		unsigned long out_top;
+
+		ret = rmi_rtt_unprot_map(rd, ipa, call_top, flags, range_desc,
+					 &out_top);
+		if (ret < 0)
+			return ret;
+
+		if (ret) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RESULT_DATA_LEVEL(ret);
+			int req_level = KVM_PGTABLE_LAST_LEVEL -
+				RMI_ADDR_RANGE_BLOCK_SIZE(range_desc);
+
+			if (RMI_RESULT_STATUS(ret) != RMI_ERROR_RTT ||
+			    ++retries > KVM_PGTABLE_LAST_LEVEL + 2)
+				return -ENXIO;
+
+			/* Replace an existing mapping to update its permissions. */
+			if (level >= req_level) {
+				realm_unmap_shared_range(kvm, ipa, ipa_top, false);
+				continue;
+			}
+
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      req_level,
+						      memcache);
+			if (ret)
+				return ret;
+
+			continue;
+		}
+
+		/* Retry the fault after releasing mmu_lock to service the IRQ. */
+		if (out_top == ipa)
+			return -EAGAIN;
+		if (WARN_ON_ONCE(out_top < ipa || out_top > call_top))
+			return -ENXIO;
+
+		phys += out_top - ipa;
+		ipa = out_top;
+		retries = 0;
+	}
+
+	return 0;
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

