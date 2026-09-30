Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5C151476F
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789022; cv=none; b=nDVs3KfMt+Irx6bs9DukIiQGg/Jdr9oUNPbmtHBbjj68oWtByfzYd5qGnTXX0M7rTGjXzFRkPxcVMsMITx5XKH+TS3IMVd/Z+LAj0ClZPnCeFldf1NjkE3yZl9tCP0CKvTjqNazcyszN41370TiX/9JmC5CYIbbibyw3KuDDaAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789022; c=relaxed/simple;
	bh=Br5fuZ4ryUMLMGwj9gH1YIvLvzgbJoEJcgmiUYmIM+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZEAOKbtvmvpAAIhs1yhJRkb1/iYIKaRGD3RTl4B65ssEeo5qYl6KrzE5soQv6uMSJtGLoOs0OgGw0lnOs/mzFgiMy6jtFiV03wpGXs63RAr3aGV7U8Mz+xqX/ExvDG8zgTJTI/7NiE+w1od1mfx/dqeAkLbOrYKIlXBSgE8yog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z/uYw6/l; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z/uYw6/l"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 369F4143D;
	Wed, 30 Sep 2026 10:23:36 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B95D03F86F;
	Wed, 30 Sep 2026 10:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790789019; bh=Br5fuZ4ryUMLMGwj9gH1YIvLvzgbJoEJcgmiUYmIM+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/uYw6/l2jrEC4Fdn0qaIvThpjIvjR95Xmpk9kc4FaAXLcbQK4oWMU5DPDvXTDYMM
	 g/lWd0Lsmhmb1JvnjmJ+g429zdj12nlNGLON+zFh20ncv3c6AnVFB3CmtZME0M12Xe
	 gaaSm1ZGm8ntaX8mIUqkbgtBwYASeFLeWV+qgcw4=
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
Subject: [PATCH v4 1/3] KVM: arm64: Avoid re-testing walk_continue
Date: Wed, 30 Sep 2026 18:22:21 +0100
Message-ID: <20260930172226.2459423-3-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930172226.2459423-2-leo.bras@arm.com>
References: <20260930172226.2459423-2-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1905; i=leo.bras@arm.com; h=from:subject; bh=Br5fuZ4ryUMLMGwj9gH1YIvLvzgbJoEJcgmiUYmIM+E=; b=kA0DAAoW7HZo80cCoa8ByyZiAGq9RU2h0IdRfCiNcvabr5HQs/y9ucx40eg3mASTh9Qu7zzuu Ih1BAAWCgAdFiEEHeKfqgz3lGjE1Pig7HZo80cCoa8FAmq9RU0ACgkQ7HZo80cCoa8p0QEAhksf y8vzTm9mCl4nLyXCKjGIdJamwoWZTs4i4doprbsBAOBe3yX5vc+yIM7JChCUP45iFxcBk4Nzaky cgLN+0g0M
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

__kvm_pgtable_visit() performs a bunch of calls to
kvm_pgtable_walk_continue() to find out whether the walk can continue
further, and if not, 'goto out', which retests the possibility of
continuing the walk before exiting.

Given that it's testing the same ret variable again, there is no reason
the result of kvm_pgtable_walk_continue() would have changed since the
previous check. So turn this goto into an early return, simplifying the
code and paving the way for further rework."

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..7a51f78b6446 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -183,32 +183,32 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	 * Reload the page table after invoking the walker callback for leaf
 	 * entries or after pre-order traversal, to allow the walker to descend
 	 * into a newly installed or replaced table.
 	 */
 	if (reload) {
 		ctx.old = READ_ONCE(*ptep);
 		table = kvm_pte_table(ctx.old, level);
 	}
 
 	if (!kvm_pgtable_walk_continue(data->walker, ret))
-		goto out;
+		return ret;
 
 	if (!table) {
 		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
 		data->addr += kvm_granule_size(level);
 		goto out;
 	}
 
 	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
 	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
 	if (!kvm_pgtable_walk_continue(data->walker, ret))
-		goto out;
+		return ret;
 
 	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
 		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);
 
 out:
 	if (kvm_pgtable_walk_continue(data->walker, ret))
 		return 0;
 
 	return ret;
 }
-- 
2.55.0

