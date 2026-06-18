Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED943AFCF6
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 13:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781788509; cv=none; b=l70MhN12eFgqn5AB/fJO3GAmfCWVEDp613Wnh6dBwGmst4n+c9QdwB322TohnOsuQGugfBtb2qFEPvjNmL1YYMjsWzyh37j0/bULcFakaZO4dHVWlxiZJ15XZdsq2dAr0a7drM175TS6qX+eqajTDvKEVedFJgQHrHdyFKq9L84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781788509; c=relaxed/simple;
	bh=25u6iOGbg9fNy6qgll3Uzb90+VukHpHTe6XSwkGqFSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEj+8IL4FiAR9nJO/cA+P9uBoWnL/bs4JiMZmJA1rq9y+ZkHe22AgsS4jBEHxbP5dNANZo2/MN7xeECARgnBCO14rgznnC/0IdGIi1lLKl9iGwfCfCQ6RLG/vbZOUTgMFI3nwVpiPaFDHPWI/3J38srRqwjx50cQhDjpF5Jc3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FyiBBvos; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FyiBBvos"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C78E02BCD;
	Thu, 18 Jun 2026 06:15:00 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C328B3F915;
	Thu, 18 Jun 2026 06:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781788505; bh=25u6iOGbg9fNy6qgll3Uzb90+VukHpHTe6XSwkGqFSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyiBBvoseEo0De+YmrlHGvcvRb/ht1q2BR+GQCrh3eYOr8IpmmO0Ll9XtkpHhfpQz
	 24mXB+tnR6pypDksU420wAdSGojwSLvtkoyXPnRY0r1PBry3VYk3HLqo8XRmaHU0B+
	 jGvTqDPs3CZhX7zQ70VfOv1ZM15xzE84jS4tSiLo=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
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
Subject: [PATCH v2 3/3] KVM: arm64: Make stage2_split_walker() skip unnecessary walks
Date: Thu, 18 Jun 2026 14:14:44 +0100
Message-ID: <20260618131447.764085-4-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618131447.764085-1-leo.bras@arm.com>
References: <20260618131447.764085-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1659; i=leo.bras@arm.com; h=from:subject; bh=25u6iOGbg9fNy6qgll3Uzb90+VukHpHTe6XSwkGqFSg=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKM3/GZzrDIklmk7eecpX8uJoPT6c7EDZPc5125fn7rA /mAK8d2dJSyMIhxMciKKbLIPpq/iuf7lIwjV34sgJnDygQyhIGLUwAmsmguw1+BJau4/qoclnVp SXxts6yw6/nJn3q370gwLPmm9aTv8QEbRobnZdu3P7DT4BH/b7BV70/4zL6wtpbbL6O2Te+4vvT O292sAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Currently, when splitting, all the child and sibling nodes will be walked,
with the walker just returning earlier if there is nothing to do. This
means all pagetable entries in the splitting range get a callback from the
walker function, even if it was a level-3 entry.

Optimize splitting by skipping all level-3 entries, as they are already the
smallest block size and can't be split any further.
(i.e. set flag KVM_PGTABLE_WALK_SKIP_LEVEL3)

kvm_mmu_split_huge_pages called in
	kvm_clear_dirty_log_protect() - manual - 64-page granularity
	kvm_mmu_split_memory_region() - no manual - all memory

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b9a2078efc51..9ae4d9d7ed56 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1565,21 +1565,22 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	new = kvm_init_table_pte(childp, mm_ops);
 	stage2_make_pte(ctx, new);
 	return 0;
 }
 
 int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			     struct kvm_mmu_memory_cache *mc)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_split_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.flags	= KVM_PGTABLE_WALK_LEAF |
+			  KVM_PGTABLE_WALK_SKIP_LEVEL3,
 		.arg	= mc,
 	};
 	int ret;
 
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
 	dsb(ishst);
 	return ret;
 }
 
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
-- 
2.54.0

