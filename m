Received: from out-136.mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C399B4C8E
	for <kvmarm@lists.linux.dev>; Fri,  2 Dec 2022 20:04:19 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670007137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DotXXATh2xdtC3iIVT5NnRWrGz5Cdan4kCRiJ+W1n+E=;
	b=MzpkHqPQ3VskkGqUcudj5NRlAggncjx0SdgO8O/+0tAeK0c/ddUKQDLutnJu+G9j8VivWd
	7gY7H+zXwq74Dcvw3YxHkIqf+VUo+UbCQh+605YPvLVeore39m4c+9bYvNplDUb7IoyI+s
	1KSMKc/XU9K87xYkbvsz2hBEtFxDs9o=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] KVM: arm64: Ignore EAGAIN for walks outside of a fault
Date: Fri,  2 Dec 2022 18:51:52 +0000
Message-ID: <20221202185156.696189-3-oliver.upton@linux.dev>
In-Reply-To: <20221202185156.696189-1-oliver.upton@linux.dev>
References: <20221202185156.696189-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221202185152.ytRw-B-bA71XdqRwViXByAZ6WI2AGtzUaJGY-BSB6hM@z>

The page table walkers are invoked outside fault handling paths, such as
write protecting a range of memory. EAGAIN is generally used by the
walkers to retry execution due to races on a particular PTE, like taking
an access fault on a PTE being invalidated from another thread.

This early return behavior is undesirable for walkers that operate
outside a fault handler. Suppress EAGAIN and continue the walk if
operating outside a fault handler.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  3 +++
 arch/arm64/kvm/hyp/pgtable.c         | 30 +++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c                 |  4 +++-
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 192f33b88dc1..4cd6762bda80 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -193,12 +193,15 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					children.
  * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
  *					with other software walkers.
+ * @KVM_PGTABLE_WALK_HANDLE_FAULT:	Indicates the page-table walk was
+ *					invoked from a fault handler.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
+	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
 };
 
 struct kvm_pgtable_visit_ctx {
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11cf2c618a6..98818214a479 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -168,6 +168,25 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
 	return walker->cb(ctx, visit);
 }
 
+static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
+				      int r)
+{
+	/*
+	 * Visitor callbacks return EAGAIN when the conditions that led to a
+	 * fault are no longer reflected in the page tables due to a race to
+	 * update a PTE. In the context of a fault handler this is interpreted
+	 * as a signal to retry guest execution.
+	 *
+	 * Ignore the return code altogether for walkers outside a fault handler
+	 * (e.g. write protecting a range of memory) and chug along with the
+	 * page table walk.
+	 */
+	if (r == -EAGAIN)
+		return !(walker->flags & KVM_PGTABLE_WALK_HANDLE_FAULT);
+
+	return !r;
+}
+
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level);
 
@@ -200,7 +219,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		table = kvm_pte_table(ctx.old, level);
 	}
 
-	if (ret)
+	if (!kvm_pgtable_walk_continue(data->walker, ret))
 		goto out;
 
 	if (!table) {
@@ -211,13 +230,16 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 
 	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
 	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
-	if (ret)
+	if (!kvm_pgtable_walk_continue(data->walker, ret))
 		goto out;
 
 	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
 		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);
 
 out:
+	if (kvm_pgtable_walk_continue(data->walker, ret))
+		return 0;
+
 	return ret;
 }
 
@@ -1095,7 +1117,8 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				 &pte, NULL, 0);
+				 &pte, NULL,
+				 KVM_PGTABLE_WALK_HANDLE_FAULT);
 	dsb(ishst);
 	return pte;
 }
@@ -1141,6 +1164,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
+				       KVM_PGTABLE_WALK_HANDLE_FAULT |
 				       KVM_PGTABLE_WALK_SHARED);
 	if (!ret)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 886ad5ee767a..dd8c715f0775 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1381,7 +1381,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	else
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
-					     memcache, KVM_PGTABLE_WALK_SHARED);
+					     memcache,
+					     KVM_PGTABLE_WALK_HANDLE_FAULT |
+					     KVM_PGTABLE_WALK_SHARED);
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

