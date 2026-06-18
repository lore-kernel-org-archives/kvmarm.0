Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7AF3F823D
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 13:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781788505; cv=none; b=fSBRhJzQ2h7iszlsuZGLAc0zO2YMVxYWIQPviBzEfiFpdQCVn1pvaHPa+xCV5vA7pRO8fvCxtmWEqYOJn702uJqLs3s76u/QTvCjdnq3bK2hxVe+uyccQXs4mQ8fMgAcFy2rLSUeo9/wEx4EnWJhMvDqAq1Knr46nSlI3DcEaJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781788505; c=relaxed/simple;
	bh=dUkILoZJI/RNijTUFLYa3jizknsO8qivApkZa+N0csA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZR0OSr0ERpudYNPKfX9THCSEX/g++SoNUDVw/Q4Rj9h6qFtyKqCx0yeJxWAUKgB94/Ais6/fTH2bDuLWKTbBR3HcTs8rC5z6LjZO3P/NMl2uoi3A34k6o78ou1pmrWV4BO/2vHZGRt0W4rEDEFhVgXKodvdFSd99vF79A/goDJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h8tUGLH8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h8tUGLH8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D93E5293B;
	Thu, 18 Jun 2026 06:14:56 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D68D33F915;
	Thu, 18 Jun 2026 06:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781788501; bh=dUkILoZJI/RNijTUFLYa3jizknsO8qivApkZa+N0csA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8tUGLH8YhHfADsJHrnePcrz5Icl6qNns8+brYjstpiJKFsDznyqPtCh/QY7zQvgA
	 TfjaTNLe7alu0fMbDYk8GpgAXaFROIZwTN+d/FzDE+T98YZcoOZd1QVabGPi8ajO8o
	 g0ohSiHbmGH8xGPT1rlUb6Xu3royOpz9zofNBPcw=
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
Subject: [PATCH v2 1/3] KVM: arm64: Avoid re-testing walk_continue
Date: Thu, 18 Jun 2026 14:14:42 +0100
Message-ID: <20260618131447.764085-2-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618131447.764085-1-leo.bras@arm.com>
References: <20260618131447.764085-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1682; i=leo.bras@arm.com; h=from:subject; bh=dUkILoZJI/RNijTUFLYa3jizknsO8qivApkZa+N0csA=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKM3/E+lNK5GLfeielSyew/U2uiov+sP3zgXmHICtHFC +wn7nA83VHKwiDGxSArpsgi+2j+Kp7vUzKOXPmxAGYOKxPIEAYuTgGYSPE1ht9slcImp/1/Tui4 xZ3nyPlzy5dDLkznlPmXXe/Xmd37XHAOw1+peavy3VrerpZmPukR2MT1mkfP0ibWqu7qjDNftA5 cuskCAA==
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
2.54.0

