Received: from out-73.mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCDE23AA
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 00:03:49 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673395421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U9eN0QijdqjixC9XiiLLRZwsrIMqmoYrpNGMUYRYtVg=;
	b=LJOWuMn19pWEgAL4w4hEMCcg67W9vohKbKmHWboakIgUdjI5y+jCNDZhBxkqeDDnG0GU8j
	8wAvDtZQsI3oJQRFph8I5DyQX95ZeL5kXX9WZgqwUJiU794zk1DVkslNfNIapFkM3F0Ri9
	PxSPCh3prO2G9VIktqYxBoLFk9+qwFk=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5/5] KVM: arm64: Consistently use KVM's types/helpers in kvm_age_gfn()
Date: Wed, 11 Jan 2023 00:03:00 +0000
Message-Id: <20230111000300.2034799-6-oliver.upton@linux.dev>
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

There's no real need for indirection through the kernel's PTE types
here. Add a new helper to test if the access flag is set on a PTE and
use it to roll over kvm_age_gfn() to only using kvm_pte_t.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
 arch/arm64/kvm/hyp/pgtable.c         |  2 +-
 arch/arm64/kvm/mmu.c                 | 12 +++++-------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 81e04a24cc76..a81cd1ea64cb 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -86,6 +86,11 @@ static inline bool kvm_pte_valid(kvm_pte_t pte)
 	return pte & KVM_PTE_VALID;
 }
 
+static inline bool kvm_pte_young(kvm_pte_t pte)
+{
+	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
+}
+
 static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
 {
 	u64 pa = pte & KVM_PTE_ADDR_MASK;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 791f7e81671e..19f5094dfd93 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1085,7 +1085,7 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	kvm_pte_t attr_old = 0;
 	stage2_update_leaf_attrs(pgt, addr, size, 0, 0, &attr_old, NULL, 0);
-	return attr_old & KVM_PTE_LEAF_ATTR_LO_S2_AF;
+	return kvm_pte_young(attr_old);
 }
 
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0b8e2a57f81a..3297475dcfcc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1607,17 +1607,15 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
-	kvm_pte_t kpte;
-	pte_t pte;
+	kvm_pte_t pte;
 
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt,
-					range->start << PAGE_SHIFT,
-					size);
-	pte = __pte(kpte);
-	return pte_young(pte);
+	pte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt,
+				       range->start << PAGE_SHIFT,
+				       size);
+	return kvm_pte_young(pte);
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
-- 
2.39.0.314.g84b9a713c41-goog

