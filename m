Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F8A4ADD8A
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487021; cv=none; b=vEVcXplduHjNBk1xTep8W2EQ84pCQrUpjL+acD6mECeIwoYAOvEcxyvYFENrlVxzUxLcNNJ5ZKwbB+lCrDF7DmASaGhzN4whzQP3InoWTtAZyR70hvF6uJfFCF+J9TipIr/pbXDKU6Axw9PhYN3aB5M5GcP3k2TGsaDmYelq4nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487021; c=relaxed/simple;
	bh=rqDS6V7DvqdfA5AoACvmacEkIMzAVYCsbPwYHmwBTAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfIekRUqUriRK95vr3IwpHkp/udwOKewvuegQcok3CKKraQ9uORgsbn5pKJS9jlSlrzK9l/UJ1lb/LwKR/2rNOYds11s7nOZ8F0bDtKrlPAiL3HvL0RWzGTXuPCjwfSjTQzGgKqOVB3jKhgYssBehPiaRu+vUBx0H36wN8v0oQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nrP6SZfe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nrP6SZfe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDDDD1570;
	Tue, 15 Sep 2026 08:43:27 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D516A3F882;
	Tue, 15 Sep 2026 08:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789487011; bh=rqDS6V7DvqdfA5AoACvmacEkIMzAVYCsbPwYHmwBTAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrP6SZfeoPQ0keW6mYi+VmmTXacW6AkR5tsVkPJ1X7tw5qUchAykTFF8HhscaoxyQ
	 pXalQd3xN7yJcFwMeu4ql+yO4tFejHdAanobVdkbrmHJBkdVi+LFpraHRpFjYgUwDL
	 059ypKflXgWoyxOIGOeYGfJ9ExplrzONy202uFl0=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v6 3/7] KVM: arm64: nv: Track guest stage-2 mapping creation
Date: Tue, 15 Sep 2026 16:43:01 +0100
Message-ID: <20260915154305.3852871-4-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915154305.3852871-1-weilin.chang@arm.com>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During shadow stage-2 faults, in addition to creating mappings in the
shadow page tables, also allocate kvm_guest_s2_mapping objects, record
the mapping ranges, and insert them into the canonical and nested mmu's
guest_s2_mappings tree.

Note that because we allow parallel faulting, the interval trees could
store mappings that are not live in the shadow page tables. Storing a
superset of the live mappings is fine because we will only over-unmap
when we use this information later to do the targeted MMU notifier
unmap.

The mapping is also added to the interval trees if
kvm_pgtable_stage2_map() returns -EAGAIN. This is required for example,
when a 2M block map (A) races with a 4K page map (B):

1. (A) maps the 2M block in kvm_pgtable_visitor_cb()
2. (B) breaks that block into a table and maps 4K
3. (A) reloads and finds the table after kvm_pgtable_visitor_cb(),
   then descends into it.
4. (A) maps some 4K, but before it finishes it reads the entry mapped by
   (B).
5. (A) returns -EAGAIN although it had mapped a few pages.

In this case, we don't know what subrange is mapped, just track the
whole requested mapping range.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_nested.h |  3 +++
 arch/arm64/kvm/mmu.c                | 39 +++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c             | 25 ++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 586026e85903..2d71f686064a 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -78,6 +78,9 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 				       const union tlbi_info *info,
 				       void (*)(struct kvm_s2_mmu *,
 						const union tlbi_info *));
+extern void kvm_record_guest_s2_mapping(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
+					gpa_t nested_ipa, size_t map_size,
+					struct kvm_guest_s2_mapping *mapping);
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 061cd1e09af2..9bc799553ce9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1636,6 +1636,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
+	struct kvm_guest_s2_mapping *mapping = NULL;
 	unsigned long mmu_seq;
 	struct page *page;
 	struct kvm *kvm = s2fd->vcpu->kvm;
@@ -1649,6 +1650,11 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
 		if (ret)
 			return ret;
+		if (kvm_is_nested_s2_mmu(kvm, pgt->mmu)) {
+			mapping = kmalloc_obj(struct kvm_guest_s2_mapping, GFP_KERNEL_ACCOUNT);
+			if (!mapping)
+				return -ENOMEM;
+		}
 	}
 
 	if (s2fd->nested)
@@ -1669,6 +1675,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	if (ret) {
 		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
 					      write_fault, exec_fault, false);
+		kfree(mapping);
 		return ret;
 	}
 
@@ -1702,11 +1709,22 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
 							 __pfn_to_phys(pfn), prot,
 							 memcache, flags);
+		/*
+		 * -EAGAIN from kvm_pgtable_stage2_map() can install mappings.
+		 * We don't know which subrange is installed, track the whole
+		 * thing.
+		 */
+		if ((ret == 0 || ret == -EAGAIN) && kvm_is_nested_s2_mmu(kvm, pgt->mmu)) {
+			kvm_record_guest_s2_mapping(pgt->mmu, gfn << PAGE_SHIFT,
+						    s2fd->fault_ipa, PAGE_SIZE, mapping);
+			mapping = NULL;
+		}
 	}
 
 out_unlock:
 	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);
+	kfree(mapping);
 
 	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
 		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
@@ -2043,6 +2061,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 			    void *memcache)
 {
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
+	struct kvm_guest_s2_mapping *mapping = NULL;
 	bool writable = prot & KVM_PGTABLE_PROT_W;
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	phys_addr_t canonical_ipa;
@@ -2053,6 +2072,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	gfn_t gfn;
 	int ret;
 
+	if (kvm_is_nested_s2_mmu(kvm, s2fd->vcpu->arch.hw_mmu)) {
+		mapping = kmalloc_obj(struct kvm_guest_s2_mapping,
+				      GFP_KERNEL_ACCOUNT);
+		if (!mapping) {
+			kvm_release_page_unused(s2vi->page);
+			return -ENOMEM;
+		}
+	}
+
 	kvm_fault_lock(kvm);
 	pgt = s2fd->vcpu->arch.hw_mmu->pgt;
 	ret = -EAGAIN;
@@ -2106,11 +2134,22 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
 							 __pfn_to_phys(pfn), prot,
 							 memcache, flags);
+		/*
+		 * -EAGAIN from kvm_pgtable_stage2_map() can install mappings.
+		 * We don't know which subrange is installed, track the whole
+		 * thing.
+		 */
+		if ((ret == 0 || ret == -EAGAIN) && kvm_is_nested_s2_mmu(kvm, pgt->mmu)) {
+			kvm_record_guest_s2_mapping(pgt->mmu, canonical_ipa,
+						    gfn_to_gpa(gfn), mapping_size, mapping);
+			mapping = NULL;
+		}
 	}
 
 out_unlock:
 	kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
 	kvm_fault_unlock(kvm);
+	kfree(mapping);
 
 	/*
 	 * Mark the page dirty only if the fault is handled successfully,
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index b7bed02e38f7..d9acff507fd2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/interval_tree.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
@@ -872,6 +873,30 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	return s2_mmu;
 }
 
+void kvm_record_guest_s2_mapping(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
+				 gpa_t nested_ipa, size_t map_size,
+				 struct kvm_guest_s2_mapping *mapping)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	canonical_ipa = ALIGN_DOWN(canonical_ipa, map_size);
+	nested_ipa = ALIGN_DOWN(nested_ipa, map_size);
+
+	mapping->canonical.start = canonical_ipa;
+	mapping->canonical.last  = canonical_ipa + map_size - 1;
+
+	mapping->nested.start    = nested_ipa;
+	mapping->nested.last     = nested_ipa + map_size - 1;
+
+	mapping->nested_mmu      = mmu;
+
+	guard(spinlock)(&kvm->arch.guest_s2_tracking_lock);
+	interval_tree_insert(&mapping->nested, &mmu->guest_s2_mappings);
+	interval_tree_insert(&mapping->canonical, &kvm->arch.mmu.guest_s2_mappings);
+}
+
 void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 {
 	/* CnP being set denotes an invalid entry */
-- 
2.43.0

