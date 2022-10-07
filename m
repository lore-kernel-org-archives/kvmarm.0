Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0166C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  7 Oct 2022 23:29:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B6244B18F;
	Fri,  7 Oct 2022 19:29:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6RJCaeIdYZZG; Fri,  7 Oct 2022 19:29:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3972C4B121;
	Fri,  7 Oct 2022 19:29:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0964087B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 19:29:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DvsDl4U4oTLO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Oct 2022 19:29:11 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E44444B0AC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 19:29:10 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1665185350;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DMlfLraIfxKoAfKWffUQ8x5yWUgtg6FSzUwE4xlCVLg=;
 b=ShgFpzO59AKzXbfkgiE//+GakASc0vV0aJy5LR94m9zLqXpXOQ/ipros/q3GcEITA9pFTp
 3fd40cKnj5gRXt0N61a42jCWLyDYZDKIwSKaAZ99+tD+sl4HNKY9LbgxYq2P7pG8Swcf41
 rFzNfsA1QVUKN0rtnM+526KCv99iCZE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 05/15] KVM: arm64: Add a helper to tear down unlinked
 stage-2 subtrees
Date: Fri,  7 Oct 2022 23:28:08 +0000
Message-Id: <20221007232818.459650-6-oliver.upton@linux.dev>
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

A subsequent change to KVM will move the tear down of an unlinked
stage-2 subtree out of the critical path of the break-before-make
sequence.

Introduce a new helper for tearing down unlinked stage-2 subtrees.
Leverage the existing stage-2 free walkers to do so, with a deep call
into __kvm_pgtable_walk() as the subtree is no longer reachable from the
root.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 23 +++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 51acdef1b80a..71b7d154b78a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -325,6 +325,17 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
  */
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
+/**
+ * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
+ * @mm_ops:	Memory management callbacks.
+ * @pgtable:	Unlinked stage-2 paging structure to be freed.
+ * @level:	Level of the stage-2 paging structure to be freed.
+ *
+ * The page-table is assumed to be unreachable by any hardware walkers prior to
+ * freeing and therefore no TLB invalidation is performed.
+ */
+void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
+
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 93989b750a26..363a5cce7e1a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1203,3 +1203,26 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
 	pgt->pgd = NULL;
 }
+
+void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
+{
+	kvm_pte_t *ptep = (kvm_pte_t *)pgtable;
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_free_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF |
+			  KVM_PGTABLE_WALK_TABLE_POST,
+	};
+	struct kvm_pgtable_walk_data data = {
+		.walker	= &walker,
+
+		/*
+		 * At this point the IPA really doesn't matter, as the page
+		 * table being traversed has already been removed from the stage
+		 * 2. Set an appropriate range to cover the entire page table.
+		 */
+		.addr	= 0,
+		.end	= kvm_granule_size(level),
+	};
+
+	WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level));
+}
-- 
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
