Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827A97B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:40:55 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id o11-20020a170902778b00b0019ad833d8a4so268801pll.15
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cQtjMLcaWAgp0T6APgmrwtt5xcUUSoS68M+T3DPnBSg=;
        b=fGRqgafVBnh4Vg/xDgKoTR4UjKgkI1w1lw2oP5aibSrNCkv+jnYXLQHtuzB1AOK3qV
         8I5fzjUqN1OiZ+/hQ/VRIzvKtVY0oUTjrDp3p3IQmq7qAw9Ry+JH7SRJVeXVs05afM/q
         sj0o1p5XfMeL7vR4jhHWZtAPtfJQpKOGRiq0QeIAeeoDnmpVTMa5QiWxlo0+XjE4L8jx
         vincJvy85aUCMaHZ5ZrKESyIjkfsXLgG8KWCQ5B0FrNhB04fKMrLp1ljpG+Be5Vdm886
         I/L3mZHIzl05aeJe08AqQ2d4EGBsbt79+SKvTB/QhyFTJIRAbjE1dKgt7S6mv0iCSEBB
         lCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cQtjMLcaWAgp0T6APgmrwtt5xcUUSoS68M+T3DPnBSg=;
        b=QtUeiAuNX1hRuLKT10P8w+6VW1cC39oSH6be2szVICXoexir4eXAWekvYdUfhtRK7e
         3dHdeszd/pjp81Go7DMbjSi/tlSxKStFQAjpgC2ktnpSDMpP/DJct4jamrwi3jCWxvaX
         lGP7MlS+FU9dK33Xe0yiqNziYZrethJfBTkjo5W0+AkO3GlW5VpRfzyRLA4S6GFL3+fj
         ZmdMf/FXULTTzmmKTGy03E01scbDIweWuJ9AHIO56Uk6OGD5/FjWTHr6gDha4Af+3JK/
         gBLsSivUBMSmZ+wzZArGqv40aKTUHQAjIy6TZe1+58hPBgm9B6XyPahEctsixp+TPfsI
         xD0g==
X-Gm-Message-State: AO0yUKXcL3Bf7rmYUq1Rv/RYUBGgWhvjobYlsMVJNv8SF6Eycqje9FJf
	MUIDYJ2D1ZyWfXWLtE80tIXYDLu4Z4trdw==
X-Google-Smtp-Source: AK7set/3vqwPR2CT24pnoesdYEaR4/kEvMgccAPEW6OM4qs5nsOhRcat8TXFwAiz5X99GI2uQg9LHhaHsQSFVg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:5d03:0:b0:4da:a1d0:3f3f with SMTP id
 r3-20020a635d03000000b004daa1d03f3fmr493223pgb.5.1676482854957; Wed, 15 Feb
 2023 09:40:54 -0800 (PST)
Date: Wed, 15 Feb 2023 17:40:37 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-4-ricarkol@google.com>
Subject: [PATCH v3 03/12] KVM: arm64: Add helper for creating unlinked stage2 subtrees
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for creating
unlinked tables (the opposite of kvm_pgtable_stage2_free_unlinked()).
Creating an unlinked table is useful for splitting block PTEs into
subtrees of 4K PTEs.  For example, a 1G block PTE can be split into 4K
PTEs by first creating a fully populated tree, and then use it to
replace the 1G PTE in a single step.  This will be used in a
subsequent commit for eager huge-page splitting (a dirty-logging
optimization).

No functional change intended. This new function will be used in a
subsequent commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 29 +++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 7c45082e6c23..2ea397ad3e63 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -460,6 +460,35 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  */
 void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
 
+/**
+ * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @new:	Unlinked stage-2 paging structure to be created.
+ * @phys:	Physical address of the memory to map.
+ * @level:	Level of the stage-2 paging structure to be created.
+ * @prot:	Permissions and attributes for the mapping.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
+ * @force_pte:  Force mappings to PAGE_SIZE granularity.
+ *
+ * Create an unlinked page-table tree under @new. If @force_pte is
+ * true or @level is the PMD level, then the tree is mapped up to the
+ * PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise. This
+ * new page-table tree is not reachable (i.e., it is removed) from the
+ * root pgd and it's therefore unreachableby the hardware page-table
+ * walker. No TLB invalidation or CMOs are performed.
+ *
+ * If device attributes are not explicitly requested in @prot, then the
+ * mapping will be normal, cacheable.
+ *
+ * Return: 0 only if a fully populated tree was created (all memory
+ * under @level is mapped), negative error code on failure.
+ */
+int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
+				       kvm_pte_t *new, u64 phys, u32 level,
+				       enum kvm_pgtable_prot prot, void *mc,
+				       bool force_pte);
+
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0a5ef9288371..fed314f2b320 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1181,6 +1181,53 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
+int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
+				      kvm_pte_t *new, u64 phys, u32 level,
+				      enum kvm_pgtable_prot prot, void *mc,
+				      bool force_pte)
+{
+	struct stage2_map_data map_data = {
+		.phys		= phys,
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+		.force_pte	= force_pte,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= stage2_map_walker,
+		.flags		= KVM_PGTABLE_WALK_LEAF |
+				  KVM_PGTABLE_WALK_SKIP_BBM |
+				  KVM_PGTABLE_WALK_SKIP_CMO,
+		.arg		= &map_data,
+	};
+	/* .addr (the IPA) is irrelevant for a removed table */
+	struct kvm_pgtable_walk_data data = {
+		.walker	= &walker,
+		.addr	= 0,
+		.end	= kvm_granule_size(level),
+	};
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
+	kvm_pte_t *pgtable;
+	int ret;
+
+	ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
+	if (ret)
+		return ret;
+
+	pgtable = mm_ops->zalloc_page(mc);
+	if (!pgtable)
+		return -ENOMEM;
+
+	ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
+				 level + 1);
+	if (ret) {
+		kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
+		mm_ops->put_page(pgtable);
+		return ret;
+	}
+
+	*new = kvm_init_table_pte(pgtable, mm_ops);
+	return 0;
+}
 
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
-- 
2.39.1.637.g21b0678d19-goog

