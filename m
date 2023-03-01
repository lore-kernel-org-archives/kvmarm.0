Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC088BEF
	for <kvmarm@lists.linux.dev>; Wed,  1 Mar 2023 21:09:38 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id cj27-20020a056a00299b00b005f1ef2e4e1aso6110473pfb.6
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 13:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UXlqkXdQ57535COU40bhXXPdK69DMqOVmCbRf71v1wo=;
        b=okvialHfqoT3ej0yJmCEiD4loMwg5foTgzLUZaDEFtdjRh0CiJaJqjAtRsDTYrbZtn
         aBm2bcxiXStkha31Kch/Z3yTKx3ss0tZRiDT6aaM+4JQCGGCAjaJUxT1esO8B6nHpXgQ
         XoZrMGwwu2mQOacwkKAO88tArbrdO4/b9zhJyUHmHn/Au77aahZ08pUcfVy+0fHZGnyP
         Cp4wBTH5zW2YIhF+S81H+qs0iiM/9EjZd9iCD0QFIWlpt/dOvUW7NAsD1Q85bYttkgPH
         CYWSuwyM5LqXYBudX1kEw27LmNm+z8UZtpEY9GKdefz03STorQI/BRBIgqr2HLwhmsE6
         YuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UXlqkXdQ57535COU40bhXXPdK69DMqOVmCbRf71v1wo=;
        b=xI2wkygV82dFpJHdhRYi1Pe3+0nRQvkOa7EAlG//sFVGelt/XPY4bL9jVzGxMwTBtn
         WoxJGcVe3TmsBrttZEZIXXp0koa95+ePZ6oez0pegeIWRRgQ1E0mQUk3zDwg0Oa/mSiX
         4618nUaPf3cyzTeOkUViC/+pEC2YAvTVTcjB63eLSdkXpHIbLLRBeztqbdQ3zytHx3C+
         DDtBpe40rkfRo9tVz1vzT6XKHC27pLQGZmaRHawgasg/dninQT9x8ulaOKP/5/gZYnV5
         OYJr61K4CGY9yGqoBtuEgylI95dAzK/ERhMvs2tLn/vd7zSd47Nr+jo7/MIWAq9eBgTr
         xjIg==
X-Gm-Message-State: AO0yUKXCG/zBZ+b5GWrrHCJWoCtyhYhN9/vXU6gZRJfiY9V5wxOWSU5N
	JtWbFYqfKIg1CLsimJAbDTED6fxO87E0AQ==
X-Google-Smtp-Source: AK7set9R9fCov/cUPwxBPh4IR7WQbWxZQlFt1DS4knCiN0CUXr55ieEgvqthD3+dvbvaKKYYX8d8XoICE7rjxg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:d3ca:b0:237:9cbe:22ad with SMTP
 id d10-20020a17090ad3ca00b002379cbe22admr3132878pjw.5.1677704978261; Wed, 01
 Mar 2023 13:09:38 -0800 (PST)
Date: Wed,  1 Mar 2023 21:09:20 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-5-ricarkol@google.com>
Subject: [PATCH v5 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
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
---
 arch/arm64/include/asm/kvm_pgtable.h |  30 +++++++
 arch/arm64/kvm/hyp/pgtable.c         | 113 +++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2b98357a5497..ce0a8e17fb6d 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -657,6 +657,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
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
index 3554b74e13c6..75726edba2f3 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1228,6 +1228,119 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
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
2.39.2.722.g9855ee24e9-goog

