Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320DF36E
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:04 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id j125-20020a25d283000000b008f257b16d71so12743179ybg.15
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kZZEvh98SWD9tn0E0TdmaWcIXyV4ORxN7PNbtYHIGE8=;
        b=Wy5ar7FlY1cJem3SOk3mfW/K7als1Bqv/HgmrKNATViB0WDWrKwSQtn3yzECxRDBNz
         KEjzP0aagE292OG2LONhBe1ORH55XdY1aQXY252i+uR0PRXJrWmGDEiMMtx7yVOAO6/6
         zrJ6xybaBeGr7khtvcbrdIMFlAhTg1oX3WB8/30hsUmjfNTRs4dE2nZXsL4Vx/PLF+Aj
         fSVLA/ZN+KCkELeif3F1u4kCLPINFXNnEwg8rAbqpZ3fFZyM9XxsAzsOhDryQfKqiD8I
         3tEYoWRY80HVQf7QrNF3q9kMYKOiXLyvNkUTYkmnBZQ5iBWP679/4UUEBkA6Bmhg0MiA
         aDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kZZEvh98SWD9tn0E0TdmaWcIXyV4ORxN7PNbtYHIGE8=;
        b=jj4y8GpU0jgQX/Zrbfs844DPWqCUSNS1nhRSWRBP4yzbxsl+3IwPSfCF6iUf7fbX2s
         sVyIvsvqDnvNQp6h2BoJ/E9YJgtopqd9uAxPC7QmmT2owFoo3G2IFzhag1dBViatgbDt
         HexcCRG0gagWovE4rImnykf7kKCuRGegNTyn+g+4slHW2AyyJ9zzr/mYY1X+BKc3MLBb
         jM6/6/P6gvO6W7KEzotwBddTGO6a9ADXas9fM1/GtrLJOgREP08/qPBeuiM6K7iCqlXy
         Mam4PaWZHXeBv4s2TlmgK320LBMLanELrSm3a9M9lpW3cjB9yqQ987lkABYwa+i48BYZ
         FsqQ==
X-Gm-Message-State: AO0yUKUdRbG1Lc9T8fp/QnSBu+Nzsn/n8OA7LvYoZ3pJqFOZFcboMDg8
	WfGMFqn7rWDk7sjm2fOKSCApRsU3XOVSvw==
X-Google-Smtp-Source: AK7set/TlOGbjrfZ/FRa7XeKFoZJcOZbWo37lMuVG4MBEXSWmDYNbgrw81za954EtOiRMdZrY+ihG81LzHO1Zg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:208:b0:ace:1ae4:9dd2 with SMTP
 id j8-20020a056902020800b00ace1ae49dd2mr7814870ybs.8.1678160763234; Mon, 06
 Mar 2023 19:46:03 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:46 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-4-ricarkol@google.com>
Subject: [PATCH v6 03/12] KVM: arm64: Add helper for creating unlinked stage2 subtrees
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

Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
creating unlinked tables (which is the opposite of
kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
useful for splitting PMD and PUD blocks into subtrees of PAGE_SIZE
PTEs.  For example, a PUD can be split into PAGE_SIZE PTEs by first
creating a fully populated tree, and then use it to replace the PUD in
a single step.  This will be used in a subsequent commit for eager
huge-page splitting (a dirty-logging optimization).

No functional change intended. This new function will be used in a
subsequent commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 28 +++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 46 ++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c7a269cad053..b7b3fc0fa7a5 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -468,6 +468,34 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  */
 void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
 
+/**
+ * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @phys:	Physical address of the memory to map.
+ * @level:	Starting level of the stage-2 paging structure to be created.
+ * @prot:	Permissions and attributes for the mapping.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
+ * @force_pte:  Force mappings to PAGE_SIZE granularity.
+ *
+ * Returns an unlinked page-table tree. If @force_pte is true or
+ * @level is 2 (the PMD level), then the tree is mapped up to the
+ * PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise.
+ * This new page-table tree is not reachable (i.e., it is unlinked)
+ * from the root pgd and it's therefore unreachableby the hardware
+ * page-table walker. No TLB invalidation or CMOs are performed.
+ *
+ * If device attributes are not explicitly requested in @prot, then the
+ * mapping will be normal, cacheable.
+ *
+ * Return: The fully populated (unlinked) stage-2 paging structure, or
+ * an ERR_PTR(error) on failure.
+ */
+kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
+					      u64 phys, u32 level,
+					      enum kvm_pgtable_prot prot,
+					      void *mc, bool force_pte);
+
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4f703cc4cb03..6bdfcb671b32 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1212,6 +1212,52 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
+kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
+					      u64 phys, u32 level,
+					      enum kvm_pgtable_prot prot,
+					      void *mc, bool force_pte)
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
+	/* .addr (the IPA) is irrelevant for an unlinked table */
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
+		return ERR_PTR(ret);
+
+	pgtable = mm_ops->zalloc_page(mc);
+	if (!pgtable)
+		return ERR_PTR(-ENOMEM);
+
+	ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
+				 level + 1);
+	if (ret) {
+		kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
+		mm_ops->put_page(pgtable);
+		return ERR_PTR(ret);
+	}
+
+	return pgtable;
+}
 
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

