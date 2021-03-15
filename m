Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64C2C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CA2764FE3
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CA2764FE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D6AB4B710;
	Mon, 15 Mar 2021 10:36:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L3Q18aSQmzOs; Mon, 15 Mar 2021 10:36:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A01F04B6F4;
	Mon, 15 Mar 2021 10:36:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B85E34B48E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n-ZWf+iLKK9a for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:44 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1B694B6F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:44 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id d15so23049418qvn.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=oSa5nQ5TRlraqujpYRgaEKu68QmnAw6JfLcGOrtBwDQ=;
 b=IkHjmQc37ByoSQ7JCQesGFNWRPZ4qzmfCcNl42JzDURSrZ/hzLoUAIq32I36dNUfyI
 sb48OylggHAcF1zAvhlSqzDyppLvC/ps9Nns7ZH9oxgfjBLVW2qYQIjibR1utE7dL4Jb
 7VV0229E/1psjIEG0hHAnZ6j/eVPMuwIGQJfZvKlB/ZvqPry5pkGx03noNzs0koBdbNS
 bk3YVnXDBwSfXKQwXm03HJVFTW2meIE+/FjiS1zJT7ryHGuroxaPJXvweSYnboEjSJVw
 ng5YLs4jFvTSlP9R/86arkk9SeztZpmrdfFTyo2ing9quGEtoZXKP7C9yBfXjof6FJLI
 r8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=oSa5nQ5TRlraqujpYRgaEKu68QmnAw6JfLcGOrtBwDQ=;
 b=KkEnAp9M/2QQKcKgmn9CKPOskQCBdaF3BcuzwPolLDrGvZHbA3LWRT22pYzp2uB5Lc
 Z+RhW4XNdA+zsWwdnaXhQVF5axf7XVlZDOZvtwbyRDxf8Fyk8qY8Ed35kAmojcG8qlW5
 E9RqH//uF2MZLNZQigxsi2kTItJB3QYQdrEDXBaObUHOrorJuE1ksJhIlojHT1uWNaH9
 7Yp1aN2Enw0H0wmc4lWa1Cx1etOU93fakTDZAvxV4UPqU5DZRsD+eIaaBg6oGYPYxT48
 GPkj7YU8V+QWCfhMroK0PzFzE4+fnc4xiK6/nzOwTIz3lMsguHZPRLxbJsbtZSkiNJIG
 lBbw==
X-Gm-Message-State: AOAM532XXMp+pdJgN0Wqhn6s3hC08zGx7zJHU/jWDxbrk2xxeshGA8m2
 mgU0nMsctGvjJjCwndGGV4FP2LHOwDDT
X-Google-Smtp-Source: ABdhPJz3qouHcnsTqCQso8N5m5LsotinYEn4t0+zh9uQjly2dIAW6gnS8LV9waksnceOkOm10Ln3p1jAUjju
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:ea29:: with SMTP id
 t9mr25070734qvp.52.1615819004175; Mon, 15 Mar 2021 07:36:44 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:31 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-32-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 31/36] KVM: arm64: Add kvm_pgtable_stage2_find_range()
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Since the host stage 2 will be identity mapped, and since it will own
most of memory, it would preferable for performance to try and use large
block mappings whenever that is possible. To ease this, introduce a new
helper in the KVM page-table code which allows to search for large
ranges of available IPA space. This will be used in the host memory
abort path to greedily idmap large portion of the PA space.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 29 +++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 89 ++++++++++++++++++++++++++--
 2 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 683e96abdc24..b93a2a3526ab 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -94,6 +94,16 @@ enum kvm_pgtable_prot {
 #define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
 #define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
 
+/**
+ * struct kvm_mem_range - Range of Intermediate Physical Addresses
+ * @start:	Start of the range.
+ * @end:	End of the range.
+ */
+struct kvm_mem_range {
+	u64 start;
+	u64 end;
+};
+
 /**
  * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
  * @KVM_PGTABLE_WALK_LEAF:		Visit leaf entries, including invalid
@@ -398,4 +408,23 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		     struct kvm_pgtable_walker *walker);
 
+/**
+ * kvm_pgtable_stage2_find_range() - Find a range of Intermediate Physical
+ *				     Addresses with compatible permission
+ *				     attributes.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Address that must be covered by the range.
+ * @prot:	Protection attributes that the range must be compatible with.
+ * @range:	Range structure used to limit the search space at call time and
+ *		that will hold the result.
+ *
+ * The offset of @addr within a page is ignored. An IPA is compatible with @prot
+ * iff its corresponding stage-2 page-table entry has default ownership and, if
+ * valid, is mapped with protection attributes identical to @prot.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
+				  enum kvm_pgtable_prot prot,
+				  struct kvm_mem_range *range);
 #endif	/* __ARM64_KVM_PGTABLE_H__ */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a5347d78293f..3a971df278bd 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -48,6 +48,8 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
+#define KVM_PTE_LEAF_ATTR_S2_IGNORED	GENMASK(58, 55)
+
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
 #define KVM_MAX_OWNER_ID		1
 
@@ -77,15 +79,20 @@ static bool kvm_phys_is_valid(u64 phys)
 	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_PARANGE_MAX));
 }
 
-static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
+static bool kvm_level_supports_block_mapping(u32 level)
 {
-	u64 granule = kvm_granule_size(level);
-
 	/*
 	 * Reject invalid block mappings and don't bother with 4TB mappings for
 	 * 52-bit PAs.
 	 */
-	if (level == 0 || (PAGE_SIZE != SZ_4K && level == 1))
+	return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
+}
+
+static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
+{
+	u64 granule = kvm_granule_size(level);
+
+	if (!kvm_level_supports_block_mapping(level))
 		return false;
 
 	if (granule > (end - addr))
@@ -1053,3 +1060,77 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
 	pgt->pgd = NULL;
 }
+
+#define KVM_PTE_LEAF_S2_COMPAT_MASK	(KVM_PTE_LEAF_ATTR_S2_PERMS | \
+					 KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | \
+					 KVM_PTE_LEAF_ATTR_S2_IGNORED)
+
+static int stage2_check_permission_walker(u64 addr, u64 end, u32 level,
+					  kvm_pte_t *ptep,
+					  enum kvm_pgtable_walk_flags flag,
+					  void * const arg)
+{
+	kvm_pte_t old_attr, pte = *ptep, *new_attr = arg;
+
+	/*
+	 * Compatible mappings are either invalid and owned by the page-table
+	 * owner (whose id is 0), or valid with matching permission attributes.
+	 */
+	if (kvm_pte_valid(pte)) {
+		old_attr = pte & KVM_PTE_LEAF_S2_COMPAT_MASK;
+		if (old_attr != *new_attr)
+			return -EEXIST;
+	} else if (pte) {
+		return -EEXIST;
+	}
+
+	return 0;
+}
+
+int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
+				  enum kvm_pgtable_prot prot,
+				  struct kvm_mem_range *range)
+{
+	kvm_pte_t attr;
+	struct kvm_pgtable_walker check_perm_walker = {
+		.cb		= stage2_check_permission_walker,
+		.flags		= KVM_PGTABLE_WALK_LEAF,
+		.arg		= &attr,
+	};
+	u64 granule, start, end;
+	u32 level;
+	int ret;
+
+	ret = stage2_set_prot_attr(prot, &attr);
+	if (ret)
+		return ret;
+	attr &= KVM_PTE_LEAF_S2_COMPAT_MASK;
+
+	for (level = pgt->start_level; level < KVM_PGTABLE_MAX_LEVELS; level++) {
+		granule = kvm_granule_size(level);
+		start = ALIGN_DOWN(addr, granule);
+		end = start + granule;
+
+		if (!kvm_level_supports_block_mapping(level))
+			continue;
+
+		if (start < range->start || range->end < end)
+			continue;
+
+		/*
+		 * Check the presence of existing mappings with incompatible
+		 * permissions within the current block range, and try one level
+		 * deeper if one is found.
+		 */
+		ret = kvm_pgtable_walk(pgt, start, granule, &check_perm_walker);
+		if (ret != -EEXIST)
+			break;
+	}
+
+	if (!ret) {
+		range->start = start;
+		range->end = end;
+	}
+
+	return ret;
+}
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
