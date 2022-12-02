Received: from out-136.mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D17480
	for <kvmarm@lists.linux.dev>; Fri,  2 Dec 2022 20:04:19 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670007140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p0G2k7kswoLiP2SpEr1E5NK57Rotg3EVnFBgR0I4F3I=;
	b=eCd/6YTIdgNLrnwSwiWJGcww3hgEmBKfKAvGafrp8UOmQ8M7RWmBMHLU7/9MoNFNay6G8S
	yVt6FFkHbzpvEXwXFLXVaUFyS2MFoJgmVsptp5ChP1IWoXkjs0rfzAUfwQcr+ReyjY+0v2
	sdb951ZVTYiLT9uRYhjOv9fbV9xgyvo=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] KVM: arm64: Return EAGAIN for invalid PTE in attr walker
Date: Fri,  2 Dec 2022 18:51:53 +0000
Message-ID: <20221202185156.696189-4-oliver.upton@linux.dev>
In-Reply-To: <20221202185156.696189-1-oliver.upton@linux.dev>
References: <20221202185156.696189-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221202185153.16ERblFtpa2bbD6gwk5XZxSgTbON1JX2yrZwz0Yf54Q@z>

Return EAGAIN for invalid PTEs in the attr walker, signaling to the
caller that any serialization and/or invalidation can be elided.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 98818214a479..204e59e05674 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1048,7 +1048,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
 	if (!kvm_pte_valid(ctx->old))
-		return 0;
+		return -EAGAIN;
 
 	data->level = ctx->level;
 	data->pte = pte;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

