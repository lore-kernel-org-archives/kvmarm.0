Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7517B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 22:18:37 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666909115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=idSRQAElol+Egahbimkv75lr1vkA5HgSWPUQXob46xw=;
	b=CxHkwtObJ6MfCsQdYt8q7XEjpRgM4D4iTiasckafH8iN80C0UPzF4NxotfQZFZIyP5wpe4
	oMfe9t9P5KaqjVZcu1IbyHjJm6qcnQoPNPYImMUye2/GyEQcWTAky/LAXa6hwL0lXhaynS
	YYTFO0kXTvdBziZesbwzIHgPHX1QEQI=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>,
	Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 04/15] KVM: arm64: Don't pass kvm_pgtable through kvm_pgtable_walk_data
Date: Thu, 27 Oct 2022 22:17:41 +0000
Message-ID: <20221027221752.1683510-5-oliver.upton@linux.dev>
In-Reply-To: <20221027221752.1683510-1-oliver.upton@linux.dev>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221027221741.Av-LA0rQeqU6-MJgsxkqZF7O_Yj03kHY5eNs8JAVG0o@z>

In order to tear down page tables from outside the context of
kvm_pgtable (such as an RCU callback), stop passing a pointer through
kvm_pgtable_walk_data.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index db25e81a9890..93989b750a26 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -50,7 +50,6 @@
 #define KVM_MAX_OWNER_ID		1
 
 struct kvm_pgtable_walk_data {
-	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
 
 	u64				addr;
@@ -88,7 +87,7 @@ static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
 	return (data->addr >> shift) & mask;
 }
 
-static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
+static u32 kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
 {
 	u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
 	u64 mask = BIT(pgt->ia_bits) - 1;
@@ -96,11 +95,6 @@ static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
 	return (addr & mask) >> shift;
 }
 
-static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
-{
-	return __kvm_pgd_page_idx(data->pgt, data->addr);
-}
-
 static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
 {
 	struct kvm_pgtable pgt = {
@@ -108,7 +102,7 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
 		.start_level	= start_level,
 	};
 
-	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
+	return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
 }
 
 static bool kvm_pte_table(kvm_pte_t pte, u32 level)
@@ -255,11 +249,10 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 	return ret;
 }
 
-static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
+static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_data *data)
 {
 	u32 idx;
 	int ret = 0;
-	struct kvm_pgtable *pgt = data->pgt;
 	u64 limit = BIT(pgt->ia_bits);
 
 	if (data->addr > limit || data->end > limit)
@@ -268,7 +261,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
 	if (!pgt->pgd)
 		return -EINVAL;
 
-	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
+	for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
 		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
 
 		ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
@@ -283,13 +276,12 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		     struct kvm_pgtable_walker *walker)
 {
 	struct kvm_pgtable_walk_data walk_data = {
-		.pgt	= pgt,
 		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
 		.end	= PAGE_ALIGN(walk_data.addr + size),
 		.walker	= walker,
 	};
 
-	return _kvm_pgtable_walk(&walk_data);
+	return _kvm_pgtable_walk(pgt, &walk_data);
 }
 
 struct leaf_walk_data {
-- 
2.38.1.273.g43a17bfeac-goog

