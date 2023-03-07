Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE462391
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:05 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id o3-20020a257303000000b00a131264017aso12879162ybc.20
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LorRr0tSpPV/HiTkZVHPusAZFDDTrzxf4iYCwZK3qzw=;
        b=I4a8SUlrLvvojeYvcmMiC2zUZqQybK5hGvCBgIlFENN8OH8+w84QrNNMzLTtRLSVEb
         WB3rMuNT6MTPDlJMFlx+wdo3vij0qvyB70IktGwAjhfI2pwmEGOfb04kkUfIahgMOaEz
         8KdaZzF/EkLndc/l8jvYzuDJ1cbuyHrP3M4TgOS87Aq+CkknLjsq2GitR7FI1i1qtGfF
         FB7wRha45vW03qg9Aj3CNRg/vgnwf0ALVefC0xV/SnGKua9CbSIsx+Uxd4ifh3YMpaH3
         +YQVnukhAMoOQeAKxtkmKr7bf4RvZH99JIUE0comNzweFbr97OlTkFal3jvJpsmwDu5+
         Ef/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LorRr0tSpPV/HiTkZVHPusAZFDDTrzxf4iYCwZK3qzw=;
        b=N+RaZf8WpfELG9ABHlP8ROMrZbBlaw179lC/krll0/x8CrSpkTNTx2HI2gdfU4Hinz
         RH86NhBSmC5oGSkUk0Mqv0ZuGtjSSRrw4AShWm3EtjdMGngt0SZgozOcFq9S4QGZWbkB
         FtT3ThwXLjBp9CTItxmuTgc8rdSEBoK8TP+4h46rj2ew2sJEtmsZJJk5Qf+Mr8H/2g4a
         uAEIfQxoPC71xnblk2ahYVqCu7ZmPzhUaZL5vxd9Tn8QZZUw3izfTZvqEdwAfUovoDSP
         IxrJxqX9mPgCfF0B2kWfZhSGjRuS7STeAz855p0occK6B6dQ6gSr+aBHL8kqeMKle43C
         bseQ==
X-Gm-Message-State: AO0yUKWD7t3+eim2oHBpHmaMo0JaA5SUHYp+YjN7oQzr2sZaWQXFRUjq
	orbZOo9vR4/08uIfmUAJZ2gUYdxqtj2tsw==
X-Google-Smtp-Source: AK7set/nYKOurqX7+27yzQnB5T3x7aiLZyUfSTSEnkwHX6VlUk/ecQNoH6NrmKl7u68atLnyiVZm6gc+BTPPFg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:70c:0:b0:a30:38fb:a0b8 with SMTP id
 g12-20020a5b070c000000b00a3038fba0b8mr7892121ybq.9.1678160764841; Mon, 06 Mar
 2023 19:46:04 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:47 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-5-ricarkol@google.com>
Subject: [PATCH v6 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
range of huge pages. This will be used for eager-splitting huge pages
into PAGE_SIZE pages. The goal is to avoid having to split huge pages
on write-protection faults, and instead use this function to do it
ahead of time for large ranges (e.g., all guest memory in 1G chunks at
a time).

No functional change intended. This new function will be used in a
subsequent commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  30 +++++++
 arch/arm64/kvm/hyp/pgtable.c         | 113 +++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index b7b3fc0fa7a5..40e323a718fc 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -665,6 +665,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
  */
 int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
+/**
+ * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
+ *				to PAGE_SIZE guest pages.
+ * @pgt:	 Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	 Intermediate physical address from which to split.
+ * @size:	 Size of the range.
+ * @mc:		 Cache of pre-allocated and zeroed memory from which to allocate
+ *		 page-table pages.
+ * @mc_capacity: Number of pages in @mc.
+ *
+ * @addr and the end (@addr + @size) are effectively aligned down and up to
+ * the top level huge-page block size. This is an example using 1GB
+ * huge-pages and 4KB granules.
+ *
+ *                          [---input range---]
+ *                          :                 :
+ * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
+ *                          :                 :
+ *                   [--2MB--][--2MB--][--2MB--][--2MB--]
+ *                          :                 :
+ *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
+ *                          :                 :
+ *
+ * Return: 0 on success, negative error code on failure. Note that
+ * kvm_pgtable_stage2_split() is best effort: it tries to break as many
+ * blocks in the input range as allowed by @mc_capacity.
+ */
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			     void *mc, u64 mc_capacity);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 6bdfcb671b32..3149b98d1701 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1259,6 +1259,119 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
 	return pgtable;
 }
 
+struct stage2_split_data {
+	struct kvm_s2_mmu		*mmu;
+	void				*memcache;
+	u64				mc_capacity;
+};
+
+/*
+ * Get the number of page-tables needed to replace a block with a
+ * fully populated tree, up to the PTE level, at particular level.
+ */
+static inline int stage2_block_get_nr_page_tables(u32 level)
+{
+	if (WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
+			 level >= KVM_PGTABLE_MAX_LEVELS))
+		return -EINVAL;
+
+	switch (level) {
+	case 1:
+		return PTRS_PER_PTE + 1;
+	case 2:
+		return 1;
+	case 3:
+		return 0;
+	default:
+		return -EINVAL;
+	};
+}
+
+static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			       enum kvm_pgtable_walk_flags visit)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	struct stage2_split_data *data = ctx->arg;
+	kvm_pte_t pte = ctx->old, new, *childp;
+	enum kvm_pgtable_prot prot;
+	void *mc = data->memcache;
+	u32 level = ctx->level;
+	bool force_pte;
+	int nr_pages;
+	u64 phys;
+
+	/* No huge-pages exist at the last level */
+	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
+		return 0;
+
+	/* We only split valid block mappings */
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	nr_pages = stage2_block_get_nr_page_tables(level);
+	if (nr_pages < 0)
+		return nr_pages;
+
+	if (data->mc_capacity >= nr_pages) {
+		/* Build a tree mapped down to the PTE granularity. */
+		force_pte = true;
+	} else {
+		/*
+		 * Don't force PTEs. This requires a single page of PMDs at the
+		 * PUD level, or a single page of PTEs at the PMD level. If we
+		 * are at the PUD level, the PTEs will be created recursively.
+		 */
+		force_pte = false;
+		nr_pages = 1;
+	}
+
+	if (data->mc_capacity < nr_pages)
+		return -ENOMEM;
+
+	phys = kvm_pte_to_phys(pte);
+	prot = kvm_pgtable_stage2_pte_prot(pte);
+
+	childp = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, phys,
+						    level, prot, mc, force_pte);
+	if (IS_ERR(childp))
+		return PTR_ERR(childp);
+
+	if (!stage2_try_break_pte(ctx, data->mmu)) {
+		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
+		mm_ops->put_page(childp);
+		return -EAGAIN;
+	}
+
+	/*
+	 * Note, the contents of the page table are guaranteed to be made
+	 * visible before the new PTE is assigned because stage2_make_pte()
+	 * writes the PTE using smp_store_release().
+	 */
+	new = kvm_init_table_pte(childp, mm_ops);
+	stage2_make_pte(ctx, new);
+	dsb(ishst);
+	data->mc_capacity -= nr_pages;
+	return 0;
+}
+
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			     void *mc, u64 mc_capacity)
+{
+	struct stage2_split_data split_data = {
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+		.mc_capacity	= mc_capacity,
+	};
+
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_split_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &split_data,
+	};
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
+}
+
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
 			      enum kvm_pgtable_stage2_flags flags,
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

