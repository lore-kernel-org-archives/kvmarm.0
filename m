Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61A68BEF
	for <kvmarm@lists.linux.dev>; Wed,  1 Mar 2023 21:09:36 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id m9-20020a17090a7f8900b0023769205928so246445pjl.6
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 13:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UB+v1KXfYv/jq1MVixM+5dSTAYoM6sVXzmmlPxOdc9M=;
        b=tfaYY9Orf8PMpLOU5PYzEPoa4q54eqwuLJvLYe1xBdGlf0VmD6YZ4QCnm3REyv8UeZ
         JdlUGstzUqkoSXO+JDGyhlXZCYz5iEWW+hAEvWJfJ5ERMIKcZ/AHA+RevjY14CHtglLE
         ml41KPrpGEM/g4Nmz2X8iU2+iFNlK3xuc2EM9YygqOXZWQWD5SZHwlm0EVrbBSB8jU3R
         VW74ddI6S+AvCoPfCN6ezecAEZz790a+FeaZGCHWdV11canB8lwxdiJTkaIdddQR7y18
         KpXDawM9KIMRbJS4TNqbNHQAILbB+rceVdAHmNQag6632CphAIQWNmwZueEW1frI1MUa
         BaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UB+v1KXfYv/jq1MVixM+5dSTAYoM6sVXzmmlPxOdc9M=;
        b=JmR8H49/aXRy1GAC0vnEMjPbNu2eSJ0UYuS9ejw9upWYfwBC7gI88ZpFt65DJ9pLa9
         1s/TG8mKgOwv39+Anbzfl/SGvRCuOVRd4Nsbn9Y7gGfM+S9P8SRvVFxPLr+ovuYF90w5
         aZKgHhICds+A2Z6fGrPf/vnYEgHyjCJ09g6vAaSRp6QO4KibhKwHXdvBwV3/NoCLlwaB
         PLpqoTWfVFtKeeFqPMCoGEbkm2dOcfoPxRc8gQvURWPJZx+8UsR5MvvDbb7sfn/MlrGt
         gEoManT+pgw6GrzxjQku5wcp/3nF8mVDyGWqCINsZcgTZTmLTH3/u7O0jrk/6SbwPKKq
         cOIA==
X-Gm-Message-State: AO0yUKVb5PwzYBN0FTtuftpSvQFnDIFWMHyT0xrEFIa3mlRocHjpazbO
	o6K5plB3jlqChRIJIhPpSaprQOnAn/aFUg==
X-Google-Smtp-Source: AK7set+fOUhI/s8CCfJxuDPTO2RqICMUFLBxG1ByShr+Fzf0Ju8g3a0Fo12lxZhawKm/jPXDNOpTuyq4bxOG6g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:274b:b0:233:bada:17b5 with SMTP
 id qi11-20020a17090b274b00b00233bada17b5mr4782888pjb.4.1677704976349; Wed, 01
 Mar 2023 13:09:36 -0800 (PST)
Date: Wed,  1 Mar 2023 21:09:19 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-4-ricarkol@google.com>
Subject: [PATCH v5 03/12] KVM: arm64: Add helper for creating unlinked stage2 subtrees
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
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
---
 arch/arm64/include/asm/kvm_pgtable.h | 28 +++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 46 ++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index dcd3aafd3e6c..2b98357a5497 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -460,6 +460,34 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
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
index 0a5ef9288371..3554b74e13c6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1181,6 +1181,52 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
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
2.39.2.722.g9855ee24e9-goog

