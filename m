Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB2037E314
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 13:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783518079; cv=none; b=ERh3I1Ybbz+6HKVHmw7Z5g47/AyscB/JAufScWpq1IRk4/CLLhpxF37BtbVvdDCcATdSJm4p5Knlj3u/gAtiVSyCJmz8kmd3JLxj8nggL0fZPNDVLpGnZAxv1bkBhamAylFJZv2OexuiGTsPEHQCA8vvqVOpXl2cA18nmxpTvGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783518079; c=relaxed/simple;
	bh=37qsuxHn+9a5WP4Y016vE3e5beoR08skROVo25BsKcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klnXmDjHgZtRz2y7U0YQ79Q346Rb2xNwVt3EMcDXFzdL5288Utha79BJnWXb8Eo7V3ONFXMrACPHXzG/XFIQmABEhagtofRvyFnZZ6nePu/t2nr4/4RDQYLPzCksk4XERvvFTJNDrEcvbLqNiqi54Zt7O48wpraPAXYEfbVf9I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tmKAQl+t; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tmKAQl+t"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E07F31D14;
	Wed,  8 Jul 2026 06:41:12 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D4C03F915;
	Wed,  8 Jul 2026 06:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783518077; bh=37qsuxHn+9a5WP4Y016vE3e5beoR08skROVo25BsKcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmKAQl+tmvRMJvGOtuZsqalTjyELWpJrQ7fCdlCI5WM5t4IBoNVeyqiJnjLtoD/gV
	 ZhW8W2iFTWBStDKW8L0xNXYOoPiJnJfBp/k3JzQl84DF4yexqXvx0nKaBf8NkApfdA
	 xDoI2a2fvKCAD8AterddJutiMZY/4BD2cgVh8KKA=
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
Subject: [PATCH v3 3/3] KVM: arm64: Make stage2_split_walker() skip unnecessary walks
Date: Wed,  8 Jul 2026 14:40:59 +0100
Message-ID: <20260708134101.2514759-4-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260708134101.2514759-1-leo.bras@arm.com>
References: <20260708134101.2514759-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2022; i=leo.bras@arm.com; h=from:subject; bh=37qsuxHn+9a5WP4Y016vE3e5beoR08skROVo25BsKcs=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLL8/Gf5c+u87Fk/a3He2eJH4Wq7UqL8d35P8koy/nPs7 H3f45t1O0pZGMS4GGTFFFlkH81fxfN9SsaRKz8WwMxhZQIZwsDFKQATUbvJ8D/dnMM1SU1J+Wu/ /X1t9eyttkldnOpOvOEcrg8VWKOLFjP8d8wQvXDBh7FpQ4feQptt5xrOGGdf387V3bRtx/4Ziu+ cmQA=
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Currently, when splitting, all the child and sibling nodes will be walked,
with the walker just returning earlier if there is nothing to do. This
means all pagetable entries in the splitting range get a callback from the
walker function, even if it was a level-3 entry.

Optimize splitting by skipping all level-3 entries, as they are already the
smallest block size and can't be split any further.
(i.e. set flag KVM_PGTABLE_WALK_SKIP_LEVEL3)

Optimization measured on a 64GB VM, with eager splitting, no manual protect
(splitting all memory at once on dirty-track enalble):
- Memory was already split (4k pages):  -97.33% runtime (-172ms) - 20 runs
- THP backed memory:                    -19.82% runtime (-153ms) - 10 runs
- 64x1GB hugetlb memory:                -20.65% runtime (-150ms) - 10 runs

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
2.55.0

