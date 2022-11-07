Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F80C43219
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 21:57:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A01214B8A2;
	Mon,  7 Nov 2022 16:57:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cFhTJvUjh6ki; Mon,  7 Nov 2022 16:57:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7390D4B8BC;
	Mon,  7 Nov 2022 16:57:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80D874B848
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:57:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UBj80Hur4QrJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 16:57:46 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DC9A4B88D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:57:45 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667858264;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CijDh/NESgjTQGJH5ONWx07mVyGCBO9tOwzI6gPR8CA=;
 b=r/CbLVzcnLu+9Na2yRhfaCpoueoZAXBOJ9xtZAo/3GwI4DCaRsE/O9FizgNgl0EqvdTR9k
 mTER/pEh9diPBnww1Kq4+Jzgdg0jO7JiRI4wH9Vf6yhqqshZ1rp5eabGIMfKTB2r9EIGIl
 hOjoq9n6GekKs/l28WLyYZSyyvbuLeE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 05/14] KVM: arm64: Add a helper to tear down unlinked
 stage-2 subtrees
Date: Mon,  7 Nov 2022 21:56:35 +0000
Message-Id: <20221107215644.1895162-6-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-1-oliver.upton@linux.dev>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
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
index a752793482cb..93b1feeaebab 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -333,6 +333,17 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
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
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
