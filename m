Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA2953B6
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 16:58:59 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id z7-20020aa79587000000b00593f19705d5so6762849pfj.10
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 08:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lwDAN8xTdbSeYamNw9rt6CbOQWpvlazD5x5calnCoVc=;
        b=mtXtryOgkR93yN+xk/TEeiHfhjAjCQ2JxYPvvCu6Qt9hItX1GUcPhFa4L0K89IKwrY
         diOoruEAxsfZ6uZv7v1BnwmHuhP4zQjg5dttXdKCJGezPraDeutt0OWeDyYVuLPNhl8O
         2DdAI40mR8Tn1n+ztCr8ALnSS55XTkvfMXEMsezdzotFa/ifjdsTb7c9aDTJehYZrrqM
         qf5FGUZVkW0/AeXXONrTUqpCS41YKD7n3w5WrfOCWUXH0upfeLwET0UVZhct0vmVTrMT
         uEB+ikXwq65Ih/90/rzKpgwOwcZqSBhszqCS+/IwPDk/obaNNAc4BvemnYknYOpxARdr
         LHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lwDAN8xTdbSeYamNw9rt6CbOQWpvlazD5x5calnCoVc=;
        b=MUnZD/oUZ3KDD64b5UhjE5NDiqrbEH3Nx/ywuMEn0fNT/VPHSUCW5gUF6c81/M/qWC
         W/hzArPgnOm7+YJkZo2KKmoh2NTIs7UNnxQgxf2Vvknne2qn0GPQuCpYW5FEeMqRlfav
         cgGdr1siVak53ZglxKf4oySsJVe76cTD0byTuyfdnFfjLZenMYmfBP4m7xHETwY7d9Vf
         NckU/M0N+CsEOhC+R95ij7kbAgnMF4gLAUM2vn6ahAYOxx7e0cCFC+oDELgdXtZc0zj0
         +4jhecPhMfEmqS17vQsOSH/HCdEQgvfaaDLSj4jBlCsRgJjiklYGORvjt5iYgt0kZNGZ
         M6Iw==
X-Gm-Message-State: AO0yUKU5V6n5TLt4eicJu2PQfOoO3sxQTlPfWLOd4rBXgiPf1QnAlV7Q
	nvKhp9pT7PsIhWtQ2IMisU+dyfw0pPVJgQ==
X-Google-Smtp-Source: AK7set8g/AffBQcEBR6L6ii4YneuMXWLgtgjdWccaVr51I+0oupThprfYtwfKSK6XTTZAjErbmHc+iJlJMWADA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:eb92:b0:230:cbb4:b6ff with SMTP
 id o18-20020a17090aeb9200b00230cbb4b6ffmr483899pjy.30.1675702739082; Mon, 06
 Feb 2023 08:58:59 -0800 (PST)
Date: Mon,  6 Feb 2023 16:58:42 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-4-ricarkol@google.com>
Subject: [PATCH v2 03/12] KVM: arm64: Add helper for creating unlinked stage2 subtrees
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
index 7c45082e6c23..e94c92988745 100644
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
+ * true and @level is the PMD level, then the tree is mapped up to the
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
2.39.1.519.gcb327c4b5f-goog

