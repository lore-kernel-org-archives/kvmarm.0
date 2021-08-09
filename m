Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDB0C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 002D46103B
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 002D46103B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 960AE4B106;
	Mon,  9 Aug 2021 11:25:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7lYrDFgumSVV; Mon,  9 Aug 2021 11:25:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 467D34A1FA;
	Mon,  9 Aug 2021 11:25:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD06849F6C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sOGsmqi6Xt-Z for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:06 -0400 (EDT)
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com
 [209.85.218.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48CAD4B105
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:05 -0400 (EDT)
Received: by mail-ej1-f74.google.com with SMTP id
 nb40-20020a1709071ca8b02905992266c319so4601757ejc.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=V6FXsDOTW6vekbs/rXCZ1qg9Zi2BQ8Ystt2E8nbUo50=;
 b=S39TUDBkvVCpPK7CjHvagYIL9jJP+3RrAyJHX7sacKU7lwHNVmQYS3eMcRisxm6eR7
 9fRa6hm639YDKJFTrY8Qeo3xl2hld6cFffTwoFR3r28lRSSnydTdpEEU9BVg09olwL0f
 MnUZ4qiCBGGtB6kKqc+SMQ/03BzhaoG0UONxUot4IL/qGlAWr84cQVOKoxRK4iHBeevS
 jgXEcdJCeOyoEyb1anUFDCyGqsJjnLqyLNpMrNa0Lty6cbXVmnROrMNQyoQjAqX2FkA1
 H5wa3f58y/1R21B2SEFLZGQHDp6MLiOuVEqXQZ8/QTOiKpOu7OlLS9T3OXW7hNtKarqh
 4cdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=V6FXsDOTW6vekbs/rXCZ1qg9Zi2BQ8Ystt2E8nbUo50=;
 b=ddZCnGiXOSTp5bZzD5ZeytUAcmaMrvaApSsdU9TFT2V43DDXnd/5yjRFPh4d1Ptamv
 u2zExCbeysW0l3djtaYImZ94vHMfdUnluHKHeLGYe6ezCJ8dZSv8I19XKhtCM+DBkE/A
 aBDXBE/nW6XLO2PWAKdq5hUp8JRpoFlF48HXoO5YiJNg4XV4YHLh4hSOkLN+0S3K4mAx
 VGpmjvwxSj1EOSjvgeo+DpPkZ1IP266xai4xvfmcC10L49ZNFay93U++4gY0u5rQWEw5
 aMrSP4zYo+dhFG6/wUjjOUG7DebMnvkKIY8HB7Ibl4yqccbL/d5T1/62ZHwYctlnAATb
 ak2Q==
X-Gm-Message-State: AOAM532O5yQKPI7KaMxlRqU3umHZQx6Zn1Dtmku8OvrAslEHQlgbBf3H
 JyOFdufkbLrv460PDRNZJR7xer/NzLWJ
X-Google-Smtp-Source: ABdhPJw9Ff26FcaF7JXa4LyfU3GCWK7Zy3K86lTJTMJcHdOfcHGrzRq10T4KxoJzQD+Vj7eG+XC/UGFBJRhv
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:6402:160c:: with SMTP id
 f12mr30717665edv.122.1628522704406; Mon, 09 Aug 2021 08:25:04 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:33 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-7-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 06/21] KVM: arm64: Optimize host memory aborts
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

The kvm_pgtable_stage2_find_range() function is used in the host memory
abort path to try and look for the largest block mapping that can be
used to map the faulting address. In order to do so, the function
currently walks the stage-2 page-table and looks for existing
incompatible mappings within the range of the largest possible block.
If incompatible mappings are found, it tries the same procedure again,
but using a smaller block range, and repeats until a matching range is
found (potentially up to page granularity). While this approach has
benefits (mostly in the fact that it proactively coalesces host stage-2
mappings), it can be slow if the ranges are fragmented, and it isn't
optimized to deal with CPUs faulting on the same IPA as all of them will
do all the work every time.

To avoid these issues, remove kvm_pgtable_stage2_find_range(), and walk
the page-table only once in the host_mem_abort() path to find the
closest leaf to the input address. With this, use the corresponding
range if it is invalid and not owned by another entity. If a valid leaf
is found, return -EAGAIN similar to what is done in the
kvm_pgtable_stage2_map() path to optimize concurrent faults.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 30 -----------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 45 +++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c          | 74 ---------------------------
 3 files changed, 44 insertions(+), 105 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 6938eac72c1f..83c5c97d9eac 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -154,16 +154,6 @@ enum kvm_pgtable_prot {
 #define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
 #define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
 
-/**
- * struct kvm_mem_range - Range of Intermediate Physical Addresses
- * @start:	Start of the range.
- * @end:	End of the range.
- */
-struct kvm_mem_range {
-	u64 start;
-	u64 end;
-};
-
 /**
  * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
  * @KVM_PGTABLE_WALK_LEAF:		Visit leaf entries, including invalid
@@ -490,24 +480,4 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
  */
 int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
 			 kvm_pte_t *ptep, u32 *level);
-
-/**
- * kvm_pgtable_stage2_find_range() - Find a range of Intermediate Physical
- *				     Addresses with compatible permission
- *				     attributes.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
- * @addr:	Address that must be covered by the range.
- * @prot:	Protection attributes that the range must be compatible with.
- * @range:	Range structure used to limit the search space at call time and
- *		that will hold the result.
- *
- * The offset of @addr within a page is ignored. An IPA is compatible with @prot
- * iff its corresponding stage-2 page-table entry has default ownership and, if
- * valid, is mapped with protection attributes identical to @prot.
- *
- * Return: 0 on success, negative error code on failure.
- */
-int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
-				  enum kvm_pgtable_prot prot,
-				  struct kvm_mem_range *range);
 #endif	/* __ARM64_KVM_PGTABLE_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 74280a753efb..2148d3968aa5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -159,6 +159,11 @@ static int host_stage2_unmap_dev_all(void)
 	return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
 }
 
+struct kvm_mem_range {
+	u64 start;
+	u64 end;
+};
+
 static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 {
 	int cur, left = 0, right = hyp_memblock_nr;
@@ -227,6 +232,44 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
 		__ret;							\
 	 })
 
+static inline bool range_included(struct kvm_mem_range *child,
+				  struct kvm_mem_range *parent)
+{
+	return parent->start <= child->start && child->end <= parent->end;
+}
+
+static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
+{
+	struct kvm_mem_range cur;
+	kvm_pte_t pte;
+	u32 level;
+	int ret;
+
+	hyp_assert_lock_held(&host_kvm.lock);
+	ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, &level);
+	if (ret)
+		return ret;
+
+	if (kvm_pte_valid(pte))
+		return -EAGAIN;
+
+	if (pte)
+		return -EPERM;
+
+	do {
+		u64 granule = kvm_granule_size(level);
+		cur.start = ALIGN_DOWN(addr, granule);
+		cur.end = cur.start + granule;
+		level++;
+	} while ((level < KVM_PGTABLE_MAX_LEVELS) &&
+			!(kvm_level_supports_block_mapping(level) &&
+			  range_included(&cur, range)));
+
+	*range = cur;
+
+	return 0;
+}
+
 static int host_stage2_idmap(u64 addr)
 {
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
@@ -238,7 +281,7 @@ static int host_stage2_idmap(u64 addr)
 		prot |= KVM_PGTABLE_PROT_X;
 
 	hyp_spin_lock(&host_kvm.lock);
-	ret = kvm_pgtable_stage2_find_range(&host_kvm.pgt, addr, prot, &range);
+	ret = host_stage2_adjust_range(addr, &range);
 	if (ret)
 		goto unlock;
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 49d768b92997..4dff2ad39ee4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1102,77 +1102,3 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
 	pgt->pgd = NULL;
 }
-
-#define KVM_PTE_LEAF_S2_COMPAT_MASK	(KVM_PTE_LEAF_ATTR_S2_PERMS | \
-					 KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | \
-					 KVM_PTE_LEAF_ATTR_S2_IGNORED)
-
-static int stage2_check_permission_walker(u64 addr, u64 end, u32 level,
-					  kvm_pte_t *ptep,
-					  enum kvm_pgtable_walk_flags flag,
-					  void * const arg)
-{
-	kvm_pte_t old_attr, pte = *ptep, *new_attr = arg;
-
-	/*
-	 * Compatible mappings are either invalid and owned by the page-table
-	 * owner (whose id is 0), or valid with matching permission attributes.
-	 */
-	if (kvm_pte_valid(pte)) {
-		old_attr = pte & KVM_PTE_LEAF_S2_COMPAT_MASK;
-		if (old_attr != *new_attr)
-			return -EEXIST;
-	} else if (pte) {
-		return -EEXIST;
-	}
-
-	return 0;
-}
-
-int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
-				  enum kvm_pgtable_prot prot,
-				  struct kvm_mem_range *range)
-{
-	kvm_pte_t attr;
-	struct kvm_pgtable_walker check_perm_walker = {
-		.cb		= stage2_check_permission_walker,
-		.flags		= KVM_PGTABLE_WALK_LEAF,
-		.arg		= &attr,
-	};
-	u64 granule, start, end;
-	u32 level;
-	int ret;
-
-	ret = stage2_set_prot_attr(pgt, prot, &attr);
-	if (ret)
-		return ret;
-	attr &= KVM_PTE_LEAF_S2_COMPAT_MASK;
-
-	for (level = pgt->start_level; level < KVM_PGTABLE_MAX_LEVELS; level++) {
-		granule = kvm_granule_size(level);
-		start = ALIGN_DOWN(addr, granule);
-		end = start + granule;
-
-		if (!kvm_level_supports_block_mapping(level))
-			continue;
-
-		if (start < range->start || range->end < end)
-			continue;
-
-		/*
-		 * Check the presence of existing mappings with incompatible
-		 * permissions within the current block range, and try one level
-		 * deeper if one is found.
-		 */
-		ret = kvm_pgtable_walk(pgt, start, granule, &check_perm_walker);
-		if (ret != -EEXIST)
-			break;
-	}
-
-	if (!ret) {
-		range->start = start;
-		range->end = end;
-	}
-
-	return ret;
-}
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
