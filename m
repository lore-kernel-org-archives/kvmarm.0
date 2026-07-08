Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5162E7376
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 13:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783518075; cv=none; b=gHqoHLYwc09jDQ6Ylodc+pEZPgwl22Lt+ThYPMnt0WY1PWXwk2h5LBjUJANw6LzoAdtqU8yIJ6kf7TMoPFkRSCk6hYfIeeAvl9bY/iISyOlzhAjvfStQ+Q4q2RmLMuvwminim11zartY4e7oyzrH9KJZagqITHbZS6t9Qrpu1Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783518075; c=relaxed/simple;
	bh=YbDjQDMMoWQhmCCvZio0JqviA+23kdltKgARyyYRlkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No0bAyLAGNei1bGqDwqgTqdQ7O3QtTVSVA/5Q+ZVsqn1UZiqo0QtvWUye/3yjZtSwE1IuiPB/nQoWVUPFp/2wqdImYZLu2YdEwbhn4vkObe5nuwKM5u8/IkqtiQ9kWisIulmctqZBbd3jy7QHQo8OIS6tFk5xRJubljt2SB8Fvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=A/B1z5eK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="A/B1z5eK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 070D21D34;
	Wed,  8 Jul 2026 06:41:09 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4E763F66F;
	Wed,  8 Jul 2026 06:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783518073; bh=YbDjQDMMoWQhmCCvZio0JqviA+23kdltKgARyyYRlkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/B1z5eKtfF8PlrI9UvIRNnXqBa5Qt7I7N1pq9PF/LpwD8Vtyt3Xomt3UKOAD8Frf
	 QvZnnpDH6NIYEA5oImmN/tDUJa9v2MEIlU6HnJuOiWj2v4T8Ul308VMKpNRgpizwud
	 2WTOyrX1PB1GgBLkb0sIFLm6bFcADQKGNqXZMa/A=
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
Subject: [PATCH v3 1/3] KVM: arm64: Avoid re-testing walk_continue
Date: Wed,  8 Jul 2026 14:40:57 +0100
Message-ID: <20260708134101.2514759-2-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260708134101.2514759-1-leo.bras@arm.com>
References: <20260708134101.2514759-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1682; i=leo.bras@arm.com; h=from:subject; bh=YbDjQDMMoWQhmCCvZio0JqviA+23kdltKgARyyYRlkA=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLL8/GfOEzi3dWtSZ5R5rHUa116DbxmaascZHWbzB2X1f pkSwynfUcrCIMbFICumyCL7aP4qnu9TMo5c+bEAZg4rE8gQBi5OAZiI8Q9GhrOFWoanjypYx1V/ Ob51vpLTRi8plnlfElRlJpzbl7xR8Dwjw6nll2RmiT4/LLTnxt39p+KLxdo8bycfW5JbeThNvvv GLEYA
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

In __kvm_pgtable_visit(), a couple tests for kvm_pgtable_walk_continue()
will 'goto out' if it should not continue. This means the same test will be
ran again before returning ret, which is unnecessary.

Return ret directly instead.
This will simplify next patch.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 91a7dfad6686..4be1d51a6ac5 100644
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

