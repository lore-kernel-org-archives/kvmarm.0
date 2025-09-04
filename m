Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D2C42050
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 16:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757004692; cv=none; b=FZvragu0YoQ8vgT+27ieMJNZdOsFsD1S6tJciWasJ4mOXUxdZ7jqGBm8RBku2VKJoSgT65DlqOhyOHg69Dp0GyYXc8+pUyuihEdUkg4SiOqePWhcrT0PPZXv4chW/HjLzM/YDYw0jknAYmhyythRXfbxWZGj4h/79f44Dwm2WXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757004692; c=relaxed/simple;
	bh=l5lgFoDZbCT7aEpdASwAdOWR5eLqS0eW0rJlKyKKkjg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IkY7ewe+kTgsV/j/qQ3A3gvmYnQxFFxWSHpPoUm7i64AgopgAmPcfPv0LR1w2WDFTdOUNWGrEdPQLgQdLw2LKuCWm6rLInstoFuFAs/SPeAHlWCNyhvjslQ5vFIMK6XgZ9xYxdodMzBzrJKbBBNtGjkz+oVgTbr0HYbKXL0btTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qb/6RS97; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qb/6RS97"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757004688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MMBOfSu2Dnfc8ONLo0WI724VdCjsjyKQzLS2ZyrrWyE=;
	b=Qb/6RS97uOA1ldAHeUkAcY0t4SSv3Ucs9hFybuBSaspENdSzF+8vHYZNvTGJCaAUWKBMzi
	y46L+KV57qsNUDUFHh6WFc8KVldeIVzcvDJ+TIBsVdxYe3YTzt8Vq0zd6v4W8WVom+ecfB
	EK4IY531g3b5VZvpbjPqXmKEwZKPLro=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Only free fully unmapped tables in stage2_free_walker()
Date: Thu,  4 Sep 2025 03:17:46 -0700
Message-Id: <20250904101746.275795-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

syzkaller caught a terminal use-after-free in the free walker resulting
from a premature put_page() on a partially unmapped page table.
Previously KVM performed a single walk covering the entire IPA space,
but now that the range of the walk is up to KVM_PGTABLE_MIN_BLOCK_LEVEL
worth of memory it is possibly to only partially free a table.

Fix it by only dropping the table reference if the page count of the
table is 1 (i.e. no longer contains valid PTEs).

Fixes: e9abe311f356 ("KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c36f282a175d..50b8fb7cc59f 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1535,20 +1535,41 @@ size_t kvm_pgtable_stage2_pgd_size(u64 vtcr)
 	return kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
 }
 
-static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
-			      enum kvm_pgtable_walk_flags visit)
+static int stage2_free_leaf(const struct kvm_pgtable_visit_ctx *ctx)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
-	if (!stage2_pte_is_counted(ctx->old))
+	mm_ops->put_page(ctx->ptep);
+	return 0;
+}
+
+static int stage2_free_table_post(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	kvm_pte_t *childp = kvm_pte_follow(ctx->old, mm_ops);
+
+	if (mm_ops->page_count(childp) != 1)
 		return 0;
 
 	mm_ops->put_page(ctx->ptep);
+	mm_ops->put_page(childp);
+	return 0;
+}
 
-	if (kvm_pte_table(ctx->old, ctx->level))
-		mm_ops->put_page(kvm_pte_follow(ctx->old, mm_ops));
+static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			      enum kvm_pgtable_walk_flags visit)
+{
+	if (!stage2_pte_is_counted(ctx->old))
+		return 0;
 
-	return 0;
+	switch (visit) {
+	case KVM_PGTABLE_WALK_LEAF:
+		return stage2_free_leaf(ctx);
+	case KVM_PGTABLE_WALK_TABLE_POST:
+		return stage2_free_table_post(ctx);
+	default:
+		return -EINVAL;
+	}
 }
 
 void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-- 
2.39.5

