Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED645380
	for <kvmarm@lists.linux.dev>; Fri,  7 Oct 2022 23:32:46 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1665185565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOuk4eVGVEVWUN1bV4vF+FEmeHUfqlni6DbXnJIs1VM=;
	b=TOwPYi7Na1aVtwybas0i4fv5NH3dlAKOu/DkoMLuSnJ3ACg06qc7Frp0aGut4M6d1tGS3r
	1ccN5hceeF9/Fto5lOz93V25bXYTDvRr437V7HcIaRWwI0edMCcwJLDlomnswnRjt87LTY
	AvL9k8sj0yZnFubvhCmhG7I5QRNynsc=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>,
	Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 14/15] KVM: arm64: Make table->block changes parallel-aware
Date: Fri,  7 Oct 2022 23:32:26 +0000
Message-ID: <20221007233226.460179-1-oliver.upton@linux.dev>
In-Reply-To: <20221007232818.459650-1-oliver.upton@linux.dev>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221007233226.gmU6Cgnz7Kz9psoBGrEqQWzfEnpLYqbacNy16Xo99Hg@z>

stage2_map_walk_leaf() and friends now handle stage-2 PTEs generically,
and perform the correct flush when a table PTE is removed. Additionally,
they've been made parallel-aware, using an atomic break to take
ownership of the PTE.

Stop clearing the PTE in the pre-order callback and instead let
stage2_map_walk_leaf() deal with it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index adeece227495..d951829c3876 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -841,21 +841,12 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!stage2_leaf_mapping_allowed(ctx, data))
 		return 0;
 
-	kvm_clear_pte(ctx->ptep);
-
-	/*
-	 * Invalidate the whole stage-2, as we may have numerous leaf
-	 * entries below us which would otherwise need invalidating
-	 * individually.
-	 */
-	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
-
 	ret = stage2_map_walk_leaf(ctx, data);
+	if (ret)
+		return ret;
 
-	mm_ops->put_page(ctx->ptep);
 	mm_ops->free_removed_table(childp, ctx->level + 1);
-
-	return ret;
+	return 0;
 }
 
 static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
-- 
2.38.0.rc1.362.ged0d419d3c-goog

