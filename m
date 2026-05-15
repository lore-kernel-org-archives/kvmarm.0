Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351AE38886C
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778875162; cv=none; b=AUHtNmyQ7rcCStfEEX4m+/MdxN/WEbcX4qqeUUv1BJ+FIWa9qEkO+92HUEoB/AVTmwaSg0K4QX5NlNjaphKcmnwSlJ9r9qHUfzfRi7/qssO7MhKeXj7XpeoF2+jw54p1oVOFRkB1IirRqR6fluX3/4MzmWytXbyJXRCOb7/VGZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778875162; c=relaxed/simple;
	bh=ANB+N5ALL8GrDgSnqrQPn2rmLF0xA2vzhIEyI0qmn+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzVzoCBn7Qb0ZfG/tyqkTM0PG5qb1AwxNjnYbY/WDSYrUjFxUp4v32QlzPd5mB54lT8O9UBKA9I157U44ijaVuLnFyV8SEYoE8t9Og9aBxROak0oDGXt9g9qJgQrY7hd9QtzTMh3ZPQ/pdokJDx35DXCFsFN/V5IMZXUV+9D0wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hItY5Zz0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hItY5Zz0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C66035E0;
	Fri, 15 May 2026 12:59:14 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98A0D3F85F;
	Fri, 15 May 2026 12:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778875159; bh=ANB+N5ALL8GrDgSnqrQPn2rmLF0xA2vzhIEyI0qmn+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hItY5Zz0SI1/y/zje5+NpG7/mkO/BP+jwI/OqEdg6t3y7cpHvbmRAEmpwXg36Ki8D
	 WxEhoQxQ7t9xT0ywXfhIdCCZU3xEQ/IeH5U0oMFWXHvGW41d+Bd9tiUTqeal79EazH
	 deSofA9HwSPn3C+oaJqx0Y/A5/qaBnHAHKKWHKvs=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] KVM: arm64: Improve splitting performance by using SKIP return values
Date: Fri, 15 May 2026 20:59:03 +0100
Message-ID: <20260515195904.2466381-3-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515195904.2466381-1-leo.bras@arm.com>
References: <20260515195904.2466381-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3112; i=leo.bras@arm.com; h=from:subject; bh=ANB+N5ALL8GrDgSnqrQPn2rmLF0xA2vzhIEyI0qmn+c=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLLYS7/7yJ05FLSn05FD/b/Uk02yf+Y+6Fh6fO2tw2wS3 CkL7BaWd5SyMIhxMciKKbLIPpq/iuf7lIwjV34sgJnDygQyhIGLUwAm8pmL4a+0QfeiOUIHLxue u/93fQxbBP+8WxcFF318mNj6cesX5k+5jAzvgpbdaZPzqNx/2fjUeys2zs17nukXWy7k36L0xPD 2DGY+AA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Splitting an S2 pagetable is needed when using dirty-bit tracking.

Currently, when splitting, all the child and sibling nodes will be walked,
with the walker just returning earlier if there is nothing to do. This
means all pagetable entries in the splitting range get a callback from the
walker function, even if it was just split, or it's a level-3 entry.

Optimize splitting in two cases:
- If a level-3 entry is walked, it means the parent level-2 entry is split,
  so avoid walking all level-3 siblings.
- If a split just succeeded in an table entry, it means all children nodes
  are already split, so skip walking this entry's children.

Optimization measured on a 1GB VM, running on the model, splitting all at
the beginning (no manual protect):
- Memory was already split (4k pages): 	-97.33% runtime (-172ms) - 20 runs
- THP backed memory: 			-19.82% runtime (-153ms) - 10 runs
- 1x1GB hugetlb memory:			-20.65% runtime (-150ms) - 10 runs

(Above runtime is measured on kvm_mmu_split_huge_pages(), using
ktime_get_real_ns() before and after function call)

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4e43339522bb..164c5bcd6026 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1502,23 +1502,27 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 	struct kvm_mmu_memory_cache *mc = ctx->arg;
 	struct kvm_s2_mmu *mmu;
 	kvm_pte_t pte = ctx->old, new, *childp;
 	enum kvm_pgtable_prot prot;
 	s8 level = ctx->level;
 	bool force_pte;
 	int nr_pages;
 	u64 phys;
 
-	/* No huge-pages exist at the last level */
+	/*
+	 * No huge-pages exist at the last level
+	 * Also, if one PTE exist in the last level, the whole block is already
+	 * split, so skip walking it's siblings.
+	 */
 	if (level == KVM_PGTABLE_LAST_LEVEL)
-		return 0;
+		return SKIP_SIBLINGS;
 
 	/* We only split valid block mappings */
 	if (!kvm_pte_valid(pte))
 		return 0;
 
 	nr_pages = stage2_block_get_nr_page_tables(level);
 	if (nr_pages < 0)
 		return nr_pages;
 
 	if (mc->nobjs >= nr_pages) {
@@ -1554,21 +1558,23 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 		return -EAGAIN;
 	}
 
 	/*
 	 * Note, the contents of the page table are guaranteed to be made
 	 * visible before the new PTE is assigned because stage2_make_pte()
 	 * writes the PTE using smp_store_release().
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
 	stage2_make_pte(ctx, new);
-	return 0;
+
+	/* All child entries are already split, so skip walking them */
+	return SKIP_CHILDREN;
 }
 
 int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			     struct kvm_mmu_memory_cache *mc)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_split_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 		.arg	= mc,
 	};
-- 
2.54.0

