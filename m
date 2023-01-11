Received: from out-128.mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4913B442
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 00:03:45 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673395417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9DaZ0SEJg/u0gD0sqTLBat7vEekCCjd/sgW7siDQbQc=;
	b=g/DwgKH8bvg45KPU6YRLGlNUG4UZsdxoNT/dwf28ZG+d3UWG/DlpfhRgo0ONAzBRCdX03F
	s7ACXEEgRPFxncHXpaNmzVrVTyrzlqLFaasd0vJ9MGAxAYKDNrkLQbq+dM0DOrJgKgwZ4S
	1FoFzTi5+7HIsqHTX6RHJTV2DIQKmls=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/5] KVM: arm64: Only return attributes from stage2_update_leaf_attrs()
Date: Wed, 11 Jan 2023 00:02:58 +0000
Message-Id: <20230111000300.2034799-4-oliver.upton@linux.dev>
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

Returning a single PTE from stage2_update_leaf_attrs() doesn't make a
great deal of sense given that the function could be used to apply a
change to a range of PTEs. Instead, return a bitwise OR of attributes
from all the visited PTEs.

As the walker is no longer returning the full PTE, drop the check for a
valid PTE in kvm_age_gfn().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 32 +++++++++++++++++---------------
 arch/arm64/kvm/mmu.c         |  2 +-
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 26f61462527d..a3d599e3af60 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -980,7 +980,7 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 struct stage2_attr_data {
 	kvm_pte_t			attr_set;
 	kvm_pte_t			attr_clr;
-	kvm_pte_t			pte;
+	kvm_pte_t			attr_old;
 	u32				level;
 };
 
@@ -995,7 +995,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
 		return 0;
 
 	data->level = ctx->level;
-	data->pte = pte;
+	data->attr_old |= pte & KVM_PTE_LEAF_ATTRS;
 	pte &= ~data->attr_clr;
 	pte |= data->attr_set;
 
@@ -1004,7 +1004,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * but worst-case the access flag update gets lost and will be
 	 * set on the next access instead.
 	 */
-	if (data->pte != pte) {
+	if (ctx->old != pte) {
 		/*
 		 * Invalidate instruction cache before updating the guest
 		 * stage-2 PTE if we are going to add executable permission.
@@ -1023,7 +1023,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 				    u64 size, kvm_pte_t attr_set,
-				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
+				    kvm_pte_t attr_clr, kvm_pte_t *attr_old,
 				    u32 *level, enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
@@ -1041,11 +1041,12 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 	if (ret)
 		return ret;
 
-	if (orig_pte)
-		*orig_pte = data.pte;
+	if (attr_old)
+		*attr_old = data.attr_old;
 
 	if (level)
 		*level = data.level;
+
 	return 0;
 }
 
@@ -1058,32 +1059,33 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
-	kvm_pte_t pte = 0;
+	kvm_pte_t attr_old = 0;
+
 	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				 &pte, NULL, 0);
+				 &attr_old, NULL, 0);
 	dsb(ishst);
-	return pte;
+	return attr_old;
 }
 
 kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 {
-	kvm_pte_t pte = 0;
+	kvm_pte_t attr_old = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
-				 &pte, NULL, 0);
+				 &attr_old, NULL, 0);
 	/*
 	 * "But where's the TLBI?!", you scream.
 	 * "Over in the core code", I sigh.
 	 *
 	 * See the '->clear_flush_young()' callback on the KVM mmu notifier.
 	 */
-	return pte;
+	return attr_old;
 }
 
 bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
 {
-	kvm_pte_t pte = 0;
-	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, 0);
-	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
+	kvm_pte_t attr_old = 0;
+	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &attr_old, NULL, 0);
+	return attr_old & KVM_PTE_LEAF_ATTR_LO_S2_AF;
 }
 
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 31d7fa4c7c14..0741f3a8ddca 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1618,7 +1618,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt,
 					range->start << PAGE_SHIFT);
 	pte = __pte(kpte);
-	return pte_valid(pte) && pte_young(pte);
+	return pte_young(pte);
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
-- 
2.39.0.314.g84b9a713c41-goog

