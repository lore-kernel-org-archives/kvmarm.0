Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491B2A42
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:17:25 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id k15-20020a170902c40f00b001887cd71fe6so5045515plk.5
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WvQqbOcRRIz/a65YfrYqybuwAR7lzCQSMUK3wSeET0M=;
        b=LkFfKClWZ3DQ8LNaYJFEYJMH70YWUdqSFByma4dpsP65aCuCHTkXXM1y1a8uHQWgsQ
         C6oQq887h12aD6a3qPKeYmOV/TyUIvHDsQxoxbF3TTQpgtjjKFptWMqn9kTP/TomejZz
         NGr6lKfMW+/956h4TSvkm41L1g52Ri5Phi+4K0xyyrwsAG/m+zEPa6rjt9mUFh/GTMsW
         9/mCvDVmwzr23PW9gvU5F8acyAcqEJvw6xm1SAy71DaSxI11NOFK6NYEwJ+/6OfqJgpa
         X/+qaFPJfb3gRYGJvsgQlPNYWEs4RE0EjGkq8C0U43XFVMlyfAY90JSpoBZByzfdITp4
         pFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WvQqbOcRRIz/a65YfrYqybuwAR7lzCQSMUK3wSeET0M=;
        b=B9D+BYOwAa5ik/4H/mS2WUuNbebSu+IsKKezvZR9cu2XZUMTtN0Ht8noZgWUadieTS
         qx1NoBL/CCBnBF8i+KFsPc5zEC7VkkxLmUDXud22IwMCMIWyaswp9tpudFBh9gM+jnI1
         FVMianUELdCjxtOBCKdzNqCDx9svqrKkyIoqiudhTSc0aov25WXonAHGAdPSDLUtaDzF
         ZYVrmi1JvDEk18idphSxPWzNKDQwzf6q5KFCE5pypRhlzmapBcpC1oWuzq8AuW54vswO
         YE5MBkBAEebvYC5wDEZO0g1529edKmVSscaNl1GRr4D83gV/6FtkS4ZZAKt5xV3TqO6O
         gV0Q==
X-Gm-Message-State: ANoB5pmrYFJOYzGa7dUrj+N159/lwKUuxe2EUjd9R6NoIw59QrjFK1no
	2EfKIrLdjKwe/Exa5sFkHcoFoOrm1QMK2A==
X-Google-Smtp-Source: AA0mqf5CBaojmhCyotBHoWR2qMVyeqzR1Pjirb9yO8vur3R/1ist1s7bbeFg75RVf1LANl9XifIznNL9Xa2a0g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:8617:0:b0:56e:7424:bc0f with SMTP id
 p23-20020aa78617000000b0056e7424bc0fmr6225324pfn.11.1668241044591; Sat, 12
 Nov 2022 00:17:24 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:06 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-5-ricarkol@google.com>
Subject: [RFC PATCH 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112081706.-hfmoUfAe-g58sH84swvMxZFqc8ayh7a0WPZC1vaJRM@z>

Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
range of huge pages. This will be used for eager-splitting huge pages into
PAGE_SIZE pages. The goal is to avoid having to split huge pages on
write-protection faults, and instead use this function to do it ahead of
time for large ranges (e.g., all guest memory in 1G chunks at a time).

No functional change intended. This new function will be used in a

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 29 +++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 74 ++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index d2e4a5032146..396ebb0949fb 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -594,6 +594,35 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
  */
 int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
+/**
+ * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
+ *				to PAGE_SIZE guest pages.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @addr:	Intermediate physical address from which to split.
+ * @size:	Size of the range.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
+ *
+ * @addr and the end (@addr + @size) are effectively aligned down and up to
+ * the top level huge-page block size. This is an exampe using 1GB
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
+ * blocks in the input range as allowed by the size of the memcache. It
+ * will fail it wasn't able to break any block.
+ */
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d1f309128118..9c42eff6d42e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1267,6 +1267,80 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
 	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
 }
 
+struct stage2_split_data {
+	struct kvm_s2_mmu		*mmu;
+	void				*memcache;
+	struct kvm_pgtable_mm_ops	*mm_ops;
+};
+
+static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			       enum kvm_pgtable_walk_flags visit)
+{
+	struct stage2_split_data *data = ctx->arg;
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	kvm_pte_t pte = ctx->old, attr, new;
+	enum kvm_pgtable_prot prot;
+	void *mc = data->memcache;
+	u32 level = ctx->level;
+	u64 phys;
+
+	if (WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
+		return -EINVAL;
+
+	/* Nothing to split at the last level */
+	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
+		return 0;
+
+	/* We only split valid block mappings */
+	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
+		return 0;
+
+	phys = kvm_pte_to_phys(pte);
+	prot = kvm_pgtable_stage2_pte_prot(pte);
+	stage2_set_prot_attr(data->mmu->pgt, prot, &attr);
+
+	/*
+	 * Eager page splitting is best-effort, so we can ignore the error.
+	 * The returned PTE (new) will be valid even if this call returns
+	 * error: new will be a single (big) block PTE.  The only issue is
+	 * that it will affect dirty logging performance, as the huge-pages
+	 * will have to be split on fault, and so we WARN.
+	 */
+	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
+
+	stage2_put_pte(ctx, data->mmu, mm_ops);
+
+	/*
+	 * Note, the contents of the page table are guaranteed to be made
+	 * visible before the new PTE is assigned because
+	 * stage2_make__pte() writes the PTE using smp_store_release().
+	 */
+	stage2_make_pte(ctx, new);
+	dsb(ishst);
+	return 0;
+}
+
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt,
+			     u64 addr, u64 size, void *mc)
+{
+	int ret;
+
+	struct stage2_split_data split_data = {
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+		.mm_ops		= pgt->mm_ops,
+	};
+
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_split_walker,
+		.flags	= KVM_PGTABLE_WALK_POST,
+		.arg	= &split_data,
+	};
+
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	return ret;
+}
+
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
 			      enum kvm_pgtable_stage2_flags flags,
-- 
2.38.1.431.g37b22c650d-goog

