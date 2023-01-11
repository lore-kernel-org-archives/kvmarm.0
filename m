Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59446180
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 00:23:23 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673395419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=397Jy7uSB1uDMzXmYRvevSqw1dMvXvfkhIV+co0tmnk=;
	b=T8V3oIjebb7+PX4tq7GM3laLCNdWilyuSIIRQoLfnJJt2qicUqMjXAHQ0Bcx3evc1Oy5Gk
	lcdkIZq0LNKrNIK62cstT5UmpKkWkuF/IgStn9JZ8vDB/lw+kXux9QHBA3JCwUWfji15pe
	4voQ84VROadNhccb0pAcyPc/qGuHprk=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 4/5] KVM: arm64: Correctly handle page aging notifiers for unaligned memlsot
Date: Wed, 11 Jan 2023 00:02:59 +0000
Message-Id: <20230111000300.2034799-5-oliver.upton@linux.dev>
In-Reply-To: <20230111000300.2034799-1-oliver.upton@linux.dev>
References: <20230111000300.2034799-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Userspace is allowed to select any PAGE_SIZE aligned hva to back guest
memory. This is even the case with hugepages, although it is a rather
suboptimal configuration as PTE level mappings are used at stage-2.

The page aging notifiers have an assumption that the spefified range
is exactly one page/block of memory, which in the aforementioned case is
not necessarily true. All together this leads to a rather obvious kernel
WARN when using an unaligned memslot:

However, the WARN is only part of the issue as the table walkers visit
at most a single leaf PTE. For hugepage-backed memory that is at a
suboptimal alignment in the memslot, page aging entirely misses accesses
to the hugepage at an offset greater than PAGE_SIZE.

Pass through the size of the notifier range to the table walkers and
traverse the full range of memory requested. While at it, drop the WARN
from before as it is clearly a valid condition.

Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 24 ++++++++++++++----------
 arch/arm64/kvm/hyp/pgtable.c         |  8 ++++----
 arch/arm64/kvm/mmu.c                 | 10 ++++++----
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index f8f6b4d2735a..81e04a24cc76 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -584,22 +584,24 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
 kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
 
 /**
- * kvm_pgtable_stage2_mkold() - Clear the access flag in a page-table entry.
+ * kvm_pgtable_stage2_mkold() - Clear the access flag in a range of page-table
+ *				entries.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
- * @addr:	Intermediate physical address to identify the page-table entry.
+ * @addr:	Intermediate physical address to identify the start of the
+ *		range.
  *
  * The offset of @addr within a page is ignored.
  *
- * If there is a valid, leaf page-table entry used to translate @addr, then
- * clear the access flag in that entry.
+ * If there is a valid, leaf page-table entry used to translate the specified
+ * range, then clear the access flag in that entry.
  *
  * Note that it is the caller's responsibility to invalidate the TLB after
  * calling this function to ensure that the updated permissions are visible
  * to the CPUs.
  *
- * Return: The old page-table entry prior to clearing the flag, 0 on failure.
+ * Return: Bitwise-OR of the prior to clearing the flag, 0 on failure.
  */
-kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
+kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
 /**
  * kvm_pgtable_stage2_relax_perms() - Relax the permissions enforced by a
@@ -622,16 +624,18 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 				   enum kvm_pgtable_prot prot);
 
 /**
- * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
- *				   access flag set.
+ * kvm_pgtable_stage2_is_young() - Test whether a range of page-table entries
+ *				   have the access flag set.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
+ * @size:	Size of the range to test.
  *
  * The offset of @addr within a page is ignored.
  *
- * Return: True if the page-table entry has the access flag set, false otherwise.
+ * Return: True if any of the page-table entries within the range have the
+ * access flag, false otherwise.
  */
-bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
+bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
 /**
  * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a3d599e3af60..791f7e81671e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1067,10 +1067,10 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 	return attr_old;
 }
 
-kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
+kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	kvm_pte_t attr_old = 0;
-	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
+	stage2_update_leaf_attrs(pgt, addr, size, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
 				 &attr_old, NULL, 0);
 	/*
 	 * "But where's the TLBI?!", you scream.
@@ -1081,10 +1081,10 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 	return attr_old;
 }
 
-bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
+bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	kvm_pte_t attr_old = 0;
-	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &attr_old, NULL, 0);
+	stage2_update_leaf_attrs(pgt, addr, size, 0, 0, &attr_old, NULL, 0);
 	return attr_old & KVM_PTE_LEAF_ATTR_LO_S2_AF;
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0741f3a8ddca..0b8e2a57f81a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1613,21 +1613,23 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
-
 	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt,
-					range->start << PAGE_SHIFT);
+					range->start << PAGE_SHIFT,
+					size);
 	pte = __pte(kpte);
 	return pte_young(pte);
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	u64 size = (range->end - range->start) << PAGE_SHIFT;
+
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
 	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt,
-					   range->start << PAGE_SHIFT);
+					   range->start << PAGE_SHIFT,
+					   size);
 }
 
 phys_addr_t kvm_mmu_get_httbr(void)
-- 
2.39.0.314.g84b9a713c41-goog

