Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FA1C43217
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 08:17:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A39814B83D;
	Sat, 12 Nov 2022 03:17:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hDbYccG6yt7u; Sat, 12 Nov 2022 03:17:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FFB24B83A;
	Sat, 12 Nov 2022 03:17:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F29B34B7ED
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6xzABV9SRY-g for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 03:17:23 -0500 (EST)
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com
 [209.85.161.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C99874B7F6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:23 -0500 (EST)
Received: by mail-oo1-f74.google.com with SMTP id
 g28-20020a4a251c000000b0049c515643ecso2252583ooa.14
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 00:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=sW8yzYiLN0rvycCwgJfhQm/Ug+OWU4SUgCCWanJUNo8=;
 b=NbEJZXpP3Niw2dcw2EFmfW807+eCgBhUP0IckjhfQgbDN6XAO7jbT/35Ci5xi5xeSs
 zn9W0/x22dmHzoZ6AWoIkI2NGtOx9xOJb+AHT6r/QPU5fcVH+a6kDgTqnjJPshRkr+1R
 7P+TsLw5WN8Pg88KlWtGd2iYqOIMV1GLr4yzT/OTOSkK10DO82XVg1HERphKc5xt4VCQ
 +QIepxX4REPEeHTMDE2Ko/Kwn42KiuTqAYmnpQ07EewoG9rBKhwXYPQO2RCUQ+mLKmqn
 sSChsTrHLbTnpBGs52o+GqmW0idTx3OoJYIv2WyTV7QAFpp1V9UPyuHNNQqbc6E/aohs
 sqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=sW8yzYiLN0rvycCwgJfhQm/Ug+OWU4SUgCCWanJUNo8=;
 b=DYMkIqd29M51Dzo+7/FXSn0qOyoShbpj3z33XSxBK8cVyxAXKiGvxbDW/00pVWaTX0
 npBW74qymvW3PhMs7jtnle5PZfsofiebcSGaKiOf0uwYRq5wJ3mFJ2H3RP5rqEeeooJW
 7+UqF6VN80eQtGvKnW7Ppk2s1o2HxaY6Y6l14vqZxZ/qZ9tjr9jNy5zcb/QMWLrX5JBv
 7Aujx6OlPFBVupPXv+q89Z2LNqs/RLhCQxy6K8jgC9OrISsYQ2Sy8a4RBss1grFXYCvM
 vm7ghZYfmlX632UvCmErL6U56JLx1k/rooSe0vWGnMZEqHYG8q422UqePpxIdb1YT3HK
 DqBg==
X-Gm-Message-State: ANoB5pm21oWyDb4ABCI+ZNUdSaN8x796Un0pL3VhS+/owDw7qj9avzNn
 wJtJD2v8FURqXqj3TipkM6nhqY1TN4rC5A==
X-Google-Smtp-Source: AA0mqf6EmkVjDnUjkfNydVITp129iuw75i59sTZNS9in26BWrESzvhDqoX1KVMnkFyFaUWkj5fnscxncp0QoTA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aca:210c:0:b0:343:ad7:4a49 with SMTP id
 12-20020aca210c000000b003430ad74a49mr2383552oiz.278.1668241043060; Sat, 12
 Nov 2022 00:17:23 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:05 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-4-ricarkol@google.com>
Subject: [RFC PATCH 03/12] KVM: arm64: Add stage2_create_removed()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
 dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
 andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
 reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvmarm@lists.linux.dev, ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

Add a new stage2 function, stage2_create_removed(), for creating removed
tables (the opposite of kvm_pgtable_stage2_free_removed()).  Creating a
removed table is useful for splitting block PTEs into tables.  For example,
a 1G block PTE can be split into 4K PTEs by first creating a fully
populated tree, and then use it to replace the 1G PTE in a single step.
This will be used in a subsequent commit for eager huge page splitting.

No functional change intended. This new function will be used in a
subsequent commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 93 ++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1b371f6dbac2..d1f309128118 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1173,6 +1173,99 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
+struct stage2_create_removed_data {
+	void				*memcache;
+	struct kvm_pgtable_mm_ops	*mm_ops;
+	u64				phys;
+	kvm_pte_t			attr;
+};
+
+/*
+ * This flag should only be used by the create_removed walker, as it would
+ * be misinterpreted it in an installed PTE.
+ */
+#define KVM_INVALID_PTE_NO_PAGE		BIT(9)
+
+/*
+ * Failure to allocate a table results in setting the respective PTE with a
+ * valid block PTE instead of a table PTE.
+ */
+static int stage2_create_removed_walker(const struct kvm_pgtable_visit_ctx *ctx,
+					enum kvm_pgtable_walk_flags visit)
+{
+	struct stage2_create_removed_data *data = ctx->arg;
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	u64 granule = kvm_granule_size(ctx->level);
+	kvm_pte_t attr = data->attr;
+	kvm_pte_t *childp = NULL;
+	u32 level = ctx->level;
+	int ret = 0;
+
+	if (level < KVM_PGTABLE_MAX_LEVELS - 1) {
+		childp = mm_ops->zalloc_page(data->memcache);
+		ret = childp ? 0 : -ENOMEM;
+	}
+
+	if (childp)
+		*ctx->ptep = kvm_init_table_pte(childp, mm_ops);
+
+	/*
+	 * Create a block PTE if we are at the max level, or if we failed
+	 * to create a table (we are not at max level).
+	 */
+	if (level == KVM_PGTABLE_MAX_LEVELS - 1 || !childp) {
+		*ctx->ptep = kvm_init_valid_leaf_pte(data->phys, attr, level);
+		data->phys += granule;
+	}
+
+	if (ctx->old != KVM_INVALID_PTE_NO_PAGE)
+		mm_ops->get_page(ctx->ptep);
+
+	return ret;
+}
+
+/*
+ * Create a removed page-table tree of PAGE_SIZE leaf PTEs under *ptep.
+ * This new page-table tree is not reachable (i.e., it is removed) from the
+ * root (the pgd).
+ *
+ * This function will try to create as many entries in the tree as allowed
+ * by the memcache capacity. It always writes a valid PTE into *ptep. In
+ * the best case, it returns 0 and a fully populated tree under *ptep. In
+ * the worst case, it returns -ENOMEM and *ptep will contain a valid block
+ * PTE covering the expected level, or any other valid combination (e.g., a
+ * 1G table PTE pointing to half 2M block PTEs and half 2M table PTEs).
+ */
+static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
+				 kvm_pte_t attr, void *memcache,
+				 struct kvm_pgtable_mm_ops *mm_ops)
+{
+	struct stage2_create_removed_data alloc_data = {
+		.phys		= phys,
+		.memcache	= memcache,
+		.mm_ops		= mm_ops,
+		.attr		= attr,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_create_removed_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &alloc_data,
+	};
+	struct kvm_pgtable_walk_data data = {
+		.walker	= &walker,
+
+		/* The IPA is irrelevant for a removed table. */
+		.addr	= 0,
+		.end	= kvm_granule_size(level),
+	};
+
+	/*
+	 * The walker should not try to get a reference to the memory
+	 * holding this ptep (it's not a page).
+	 */
+	*ptep = KVM_INVALID_PTE_NO_PAGE;
+	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
+}
 
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
