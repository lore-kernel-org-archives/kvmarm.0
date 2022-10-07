Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DE8C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  7 Oct 2022 23:32:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0141849F01;
	Fri,  7 Oct 2022 19:32:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fZRSEIvs49XN; Fri,  7 Oct 2022 19:32:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD21643C8C;
	Fri,  7 Oct 2022 19:32:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 119D643C8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 19:32:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id osH6+Pfe2Sgw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Oct 2022 19:32:45 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9800410AD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 19:32:45 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
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
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 14/15] KVM: arm64: Make table->block changes parallel-aware
Date: Fri,  7 Oct 2022 23:32:26 +0000
Message-Id: <20221007233226.460179-1-oliver.upton@linux.dev>
In-Reply-To: <20221007232818.459650-1-oliver.upton@linux.dev>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
