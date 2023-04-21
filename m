Received: from out-53.mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1CD1843
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 07:16:28 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1682061386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1M/Xbh2NUTiePAv5S6sydFAP8unfilkkDIxWUoi01MY=;
	b=crLwzPUJ5oO4UfIlBXXxpqvtjRvlqUxrWLWGL8m+Dmfy2zW2PtkztIVME74YdEbwdvKs+l
	c03v/60aipOUeQ5W/yBzN9gUrQQbj0ycrF6Qh4Rf8nqvxdhtXy+O4DC3mmXHOGslv4kYH6
	hmuYThGFQVfVjMHTOdttu/YJinvBqt0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	David Matlack <dmatlack@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: Infer PA offset from VA in hyp map walker
Date: Fri, 21 Apr 2023 07:16:06 +0000
Message-ID: <20230421071606.1603916-3-oliver.upton@linux.dev>
In-Reply-To: <20230421071606.1603916-1-oliver.upton@linux.dev>
References: <20230421071606.1603916-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Similar to the recently fixed stage-2 walker, the hyp map walker
increments the PA and VA of a walk separately. Unlike stage-2, there is
no bug here as the map walker has exclusive access to the stage-1 page
tables.

Nonetheless, in the interest of continuity throughout the page table
code, tweak the hyp map walker to avoid incrementing the PA and instead
use the VA as the authoritative source of how far along a table walk has
gotten. Calculate the PA to use for a leaf PTE by adding the offset of
the VA from the start of the walk to the starting PA.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 140f82300db5..356a3fd5220c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -410,13 +410,12 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
 static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				    struct hyp_map_data *data)
 {
+	u64 phys = data->phys + (ctx->addr - ctx->start);
 	kvm_pte_t new;
-	u64 granule = kvm_granule_size(ctx->level), phys = data->phys;
 
 	if (!kvm_block_mapping_supported(ctx, phys))
 		return false;
 
-	data->phys += granule;
 	new = kvm_init_valid_leaf_pte(phys, data->attr, ctx->level);
 	if (ctx->old == new)
 		return true;
-- 
2.40.0.634.g4ca3ef3211-goog

