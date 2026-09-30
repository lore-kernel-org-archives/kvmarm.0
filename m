Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9672C51B182
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789025; cv=none; b=NbH4Bh7sz3fEIfIAPO9vQFmQ0RzqtQiSeVEZSzrEAXkU4Tv+GBuYPOScTJI/3o5fN+/i421HNDX0kMnRZFGdyiYf4FqDq9fqbzPU0Dv1ewZThrICQQPlUIoY3BayRrvsVm/oV8BwxRcY3Apeq7gDLqmn5fmAOACpsVdwg9twAW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789025; c=relaxed/simple;
	bh=Hl+8S3N2mqoCQjLHJajTSd+0DIMoIu1+UBhREoQ7E5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDr9czOi6IoIx4YVJVUQLi9ZgxfYZqTyi09Qnw6/daBop8Ax/RT0X13KtktyoepnuyN6pWVxr+RB7jCNiKYmH0aGw/j2fDRweGcYXwX3dDUclefdjvr0IaQgaiqEdrO1tb4PBxbZrpUUblQTo/ZWJQBcWNCarlK4FHAf93lDPhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=A0J2Ev4z; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="A0J2Ev4z"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 904551596;
	Wed, 30 Sep 2026 10:23:40 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C33C3F86F;
	Wed, 30 Sep 2026 10:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790789024; bh=Hl+8S3N2mqoCQjLHJajTSd+0DIMoIu1+UBhREoQ7E5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0J2Ev4zxOvmeICuM6sr2SP/MNQJJAzkgT+mHgYrRrAM0xjPkd/j3G4KgK+8CWqOL
	 jpODEMDtc4lxLc1kvAIUYNLR3OGi4d7rwN1p2r+Qr2dVIF5v0+ygyVo/a2HtTKGmgY
	 yWVbrXH4eclnM6BEJE9zo36al3QFL8HSr2j7YRmU=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] KVM: arm64: Make stage2_split_walker() skip unnecessary walks
Date: Wed, 30 Sep 2026 18:22:23 +0100
Message-ID: <20260930172226.2459423-5-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930172226.2459423-2-leo.bras@arm.com>
References: <20260930172226.2459423-2-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1489; i=leo.bras@arm.com; h=from:subject; bh=Hl+8S3N2mqoCQjLHJajTSd+0DIMoIu1+UBhREoQ7E5E=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLL2uvqpX3YSb36wrWWSz+clXRLKsrEP3wU7Vp60fr4oN ehKaY5KRykLgxgXg6yYIovso/mreL5PyThy5ccCmDmsTCBDGLg4BWAi9QWMDEctfK7M+Mjfahge ps2/a0Vk0fw5flv3/InYPGdS4+e+5ysY/gcrXC6PvXsqKeCtstDvLUc0y5/Mr1S+1/jl+wwh5d0 PN/IBAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Currently, when splitting, all the child nodes will be walked, with the
walker just returning earlier if there is nothing to do. This means all
pagetable entries in the splitting range get a callback from the walker
function, even if it was a level-3 entry.

Optimize splitting by skipping all level-3 entries, as they are already the
smallest block size and can't be split any further.
(i.e. set flag KVM_PGTABLE_WALK_SKIP_LEVEL3)

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 80744478c810..f75cb666a103 100644
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
2.55.0

