Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC8635
	for <kvmarm@lists.linux.dev>; Fri, 13 Jan 2023 03:50:06 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-4ce566db73eso146062717b3.11
        for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vmp1Kc4wx1CMTXvUGnc7kt4vfG7uXA3nNZdPoWjSPWk=;
        b=Sbe6PwDItRsJwuIWtuHakgH+nKZjoQozxzoc6Ffpja7NEX4l9tAAnCtB4g6D2pPj26
         +2fcDnDZHAwgvQfT9wlYY3i2HwfC34B6M0dvoQrrk1vmw8sONtY59ZGotBT5LRIFiiCn
         KtfRj8xXfJrxNjXJDb1o7qEETCIeU28yDE7E58WuqN6NuDZR5UC1J4VguZtnOr8+jRZ7
         9nYHyoYOaxo+v8+rll3rsB7DfdpVeKrny+ktV5HTpFo6/MQ6SIR5AK3ZdnUJjepo97sp
         DVQ91IUxCv75ztrKXMlPBuvHMpF+ZfkJPvrwYOuZf37RpmPUGJ/ptmKxLIWQAjDLX1yx
         c9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vmp1Kc4wx1CMTXvUGnc7kt4vfG7uXA3nNZdPoWjSPWk=;
        b=mGZlbEAC/37HvdL59yi1HbBIsZPWVwnZZIJ8iW9H5tL75j8goOrusgmvfwR4RT/dhA
         IuiNL5j9V2afkRXNaWfBHGYIyCeqLhulZvdIqIp89oXYqmOJRIfCvD334FiHVyXjabFK
         FGVsV7EaXfe9v+tO69+gi/xktU9f7kaBYeAy5A0R5SOIFBan8WY+6ssYezQupP6Z/YZX
         T1PmblRE2L5RDu3uNglQJWFBz1xWqplZlI0FZz8i94kwUnvzyHB2iO/tDDvR7k3Meo4Z
         kVJOJT5+i8WfqRUyr9DfL3JKXWAKAGtL01EB3j9vu/Lj84rGd9fFumXSgOhjGJKYuzV5
         hjWA==
X-Gm-Message-State: AFqh2kr+uS6GmLQjLT9eaOLAPKJNPIt9Q2F1vNelozLX6ke2t1jVtLqr
	RUaWRIM8V1zSQrlog/OKCpsBF1Rn9SRbSA==
X-Google-Smtp-Source: AMrXdXsQSZJtgtSeMsHcjfJu/cgQkQRfMArQC1Un94wlx6OadkveqwpLcA1ZoEyNU/jeLgk27DIYUuT2meetUw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:690c:68e:b0:4ce:6aab:6c39 with SMTP
 id bp14-20020a05690c068e00b004ce6aab6c39mr1931785ywb.90.1673581805824; Thu,
 12 Jan 2023 19:50:05 -0800 (PST)
Date: Fri, 13 Jan 2023 03:49:53 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-3-ricarkol@google.com>
Subject: [PATCH 2/9] KVM: arm64: Add helper for creating removed stage2 subtrees
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a stage2 helper, kvm_pgtable_stage2_create_removed(), for creating
removed tables (the opposite of kvm_pgtable_stage2_free_removed()).
Creating a removed table is useful for splitting block PTEs into
subtrees of 4K PTEs.  For example, a 1G block PTE can be split into 4K
PTEs by first creating a fully populated tree, and then use it to
replace the 1G PTE in a single step.  This will be used in a
subsequent commit for eager huge-page splitting (a dirty-logging
optimization).

No functional change intended. This new function will be used in a
subsequent commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 25 +++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 84a271647007..8ad78d61af7f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -450,6 +450,31 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  */
 void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
 
+/**
+ * kvm_pgtable_stage2_free_removed() - Create a removed stage-2 paging structure.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @new:	Unlinked stage-2 paging structure to be created.
+ * @phys:	Physical address of the memory to map.
+ * @level:	Level of the stage-2 paging structure to be created.
+ * @prot:	Permissions and attributes for the mapping.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
+ *
+ * Create a removed page-table tree of PAGE_SIZE leaf PTEs under *new.
+ * This new page-table tree is not reachable (i.e., it is removed) from the
+ * root pgd and it's therefore unreachableby the hardware page-table
+ * walker. No TLB invalidation or CMOs are performed.
+ *
+ * If device attributes are not explicitly requested in @prot, then the
+ * mapping will be normal, cacheable.
+ *
+ * Return: 0 only if a fully populated tree was created, negative error
+ * code on failure. No partially-populated table can be returned.
+ */
+int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
+				      kvm_pte_t *new, u64 phys, u32 level,
+				      enum kvm_pgtable_prot prot, void *mc);
+
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 87fd40d09056..0dee13007776 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1181,6 +1181,53 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
+/*
+ * map_data->force_pte is true in order to force creating PAGE_SIZE PTEs.
+ * data->addr is 0 because the IPA is irrelevant for a removed table.
+ */
+int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
+				      kvm_pte_t *new, u64 phys, u32 level,
+				      enum kvm_pgtable_prot prot, void *mc)
+{
+	struct stage2_map_data map_data = {
+		.phys		= phys,
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+		.force_pte	= true,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= stage2_map_walker,
+		.flags		= KVM_PGTABLE_WALK_LEAF |
+				  KVM_PGTABLE_WALK_REMOVED,
+		.arg		= &map_data,
+	};
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
+	ret = __kvm_pgtable_walk(&data, mm_ops, pgtable, level + 1);
+	if (ret) {
+		kvm_pgtable_stage2_free_removed(mm_ops, pgtable, level);
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
2.39.0.314.g84b9a713c41-goog

