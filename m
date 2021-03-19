Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF5DC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB87464F53
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB87464F53
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CA504B74B;
	Fri, 19 Mar 2021 06:03:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6KBDRouU7Zxp; Fri, 19 Mar 2021 06:03:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EECBF4B75C;
	Fri, 19 Mar 2021 06:03:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5C0D4B739
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y1qo1YfwIsJc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:03:00 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E03294B74B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:58 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id bt20so22810811qvb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jPUwKLoGOv7H+vBTtIRQA3TxvDs+cpHpw/WyPTM1kxQ=;
 b=taax0WUISbjH2uEK2cTxjmMPGZxgHXpTHbELiqV+qB98dqsQV+8/2FGAeNhBYO0XQO
 NJtDzJRUarTHMWCtmOsFwNFVw+o27XtV9SSciKHNEc1pWRNZ8sv50SxCE521Z4sor87n
 uPRMEQR/2OMyR4V9cqohtTC1jzUi+CrlJYRgkWKFi+dnkMuy3nHKQR310IYgSmkxfMaz
 46AXhquHeQdkunjiEF2+6PTUWiRqLN70cXFkNAHdLOJGhELlbxqFpvuBR2GVJRjl8PwZ
 PuN+j6ABJr987DIOUTI2xN0FduQ7FPbV/7DGulf8o3mlf+BMdm7p/ghEHmh7sV9gDqhd
 pjsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jPUwKLoGOv7H+vBTtIRQA3TxvDs+cpHpw/WyPTM1kxQ=;
 b=RnYurdd3jU1UM25Y9ZThNXitQ7Hl8iLvxjLsq/EKdr2fXY/pALn1y+yvITK74R5LcZ
 8vE8JuJuNOEBdaN315aecYmJsa4mOz9jQIjlV6JmqYK7YOTDUkItLGHMgJJrKylOP5WG
 ebjM8WYu0jr57EFSia0ZEKCa+UHkIyM8x20HWG5burWCJXty+GmglOAvGm7ChRR5MI75
 ykAPs/9xdoYLjNNdqDSj6EDGKVdG3ayvx/3PGUgv0z2J/oz3Cbaw9rY+dSKY3F/Sqnr9
 AwxDbSXHrUOuDm+41ekWFgJvqYajyaL4WVZdnwp8Ec3xROeAG5h2A1wTXjXriRv/qsNY
 7xLg==
X-Gm-Message-State: AOAM530Tz4WpkGxSUMkboTa/jwVc9LVyoUarFMSwNnKSWiLzu7pouCSG
 kRxE4JH+lOINtTEJTyCnY7DnECBNcgBE
X-Google-Smtp-Source: ABdhPJx8xoWNL3hJlVZYX1WnazY6yKxnNiJ54YEiUGUjM1pjY8OsSaakd7hgma0+WLKZlz0ASx03sSr9GQ0M
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:21a5:: with SMTP id
 t5mr8428904qvc.20.1616148178499; Fri, 19 Mar 2021 03:02:58 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:40 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-33-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 32/38] KVM: arm64: Introduce KVM_PGTABLE_S2_NOFWB stage 2
 flag
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

In order to further configure stage 2 page-tables, pass flags to the
init function using a new enum.

The first of these flags allows to disable FWB even if the hardware
supports it as we will need to do so for the host stage 2.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 43 +++++++++++++-------
 arch/arm64/include/asm/pgtable-prot.h |  4 +-
 arch/arm64/kvm/hyp/pgtable.c          | 56 +++++++++++++++------------
 3 files changed, 62 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index e1fed14aee17..55452f4831d2 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -56,6 +56,15 @@ struct kvm_pgtable_mm_ops {
 	phys_addr_t	(*virt_to_phys)(void *addr);
 };
 
+/**
+ * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
+ * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
+ *				ARM64_HAS_STAGE2_FWB.
+ */
+enum kvm_pgtable_stage2_flags {
+	KVM_PGTABLE_S2_NOFWB			= BIT(0),
+};
+
 /**
  * struct kvm_pgtable - KVM page-table.
  * @ia_bits:		Maximum input address size, in bits.
@@ -72,6 +81,7 @@ struct kvm_pgtable {
 
 	/* Stage-2 only */
 	struct kvm_s2_mmu			*mmu;
+	enum kvm_pgtable_stage2_flags		flags;
 };
 
 /**
@@ -196,20 +206,25 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
 
 /**
- * kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
+ * kvm_pgtable_stage2_init_flags() - Initialise a guest stage-2 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
  * @arch:	Arch-specific KVM structure representing the guest virtual
  *		machine.
  * @mm_ops:	Memory management callbacks.
+ * @flags:	Stage-2 configuration flags.
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
-			    struct kvm_pgtable_mm_ops *mm_ops);
+int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
+				  struct kvm_pgtable_mm_ops *mm_ops,
+				  enum kvm_pgtable_stage2_flags flags);
+
+#define kvm_pgtable_stage2_init(pgt, arch, mm_ops) \
+	kvm_pgtable_stage2_init_flags(pgt, arch, mm_ops, 0)
 
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  *
  * The page-table is assumed to be unreachable by any hardware walkers prior
  * to freeing and therefore no TLB invalidation is performed.
@@ -218,7 +233,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address at which to place the mapping.
  * @size:	Size of the mapping.
  * @phys:	Physical address of the memory to map.
@@ -251,7 +266,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 /**
  * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
  *				    track ownership.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Base intermediate physical address to annotate.
  * @size:	Size of the annotated range.
  * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
@@ -270,7 +285,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 
 /**
  * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address from which to remove the mapping.
  * @size:	Size of the mapping.
  *
@@ -290,7 +305,7 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
 /**
  * kvm_pgtable_stage2_wrprotect() - Write-protect guest stage-2 address range
  *                                  without TLB invalidation.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address from which to write-protect,
  * @size:	Size of the range.
  *
@@ -307,7 +322,7 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
 /**
  * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
  *
  * The offset of @addr within a page is ignored.
@@ -321,7 +336,7 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
 
 /**
  * kvm_pgtable_stage2_mkold() - Clear the access flag in a page-table entry.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
  *
  * The offset of @addr within a page is ignored.
@@ -340,7 +355,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
 /**
  * kvm_pgtable_stage2_relax_perms() - Relax the permissions enforced by a
  *				      page-table entry.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
  * @prot:	Additional permissions to grant for the mapping.
  *
@@ -359,7 +374,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 /**
  * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
  *				   access flag set.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
  *
  * The offset of @addr within a page is ignored.
@@ -372,7 +387,7 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
  * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
  * 				      of Coherency for guest stage-2 address
  *				      range.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address from which to flush.
  * @size:	Size of the range.
  *
@@ -411,7 +426,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
  * kvm_pgtable_stage2_find_range() - Find a range of Intermediate Physical
  *				     Addresses with compatible permission
  *				     attributes.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Address that must be covered by the range.
  * @prot:	Protection attributes that the range must be compatible with.
  * @range:	Range structure used to limit the search space at call time and
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 9a65fb528110..079f4e9a3e84 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -71,10 +71,10 @@ extern bool arm64_use_ng_mappings;
 #define PAGE_KERNEL_EXEC	__pgprot(PROT_NORMAL & ~PTE_PXN)
 #define PAGE_KERNEL_EXEC_CONT	__pgprot((PROT_NORMAL & ~PTE_PXN) | PTE_CONT)
 
-#define PAGE_S2_MEMATTR(attr)						\
+#define PAGE_S2_MEMATTR(attr, has_fwb)					\
 	({								\
 		u64 __val;						\
-		if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))		\
+		if (has_fwb)						\
 			__val = PTE_S2_MEMATTR(MT_S2_FWB_ ## attr);	\
 		else							\
 			__val = PTE_S2_MEMATTR(MT_S2_ ## attr);		\
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index dc6ef2cfe3eb..b22b4860630c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -508,11 +508,22 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static int stage2_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
+static bool stage2_has_fwb(struct kvm_pgtable *pgt)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		return false;
+
+	return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
+}
+
+#define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
+
+static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
+				kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
-	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
-			    PAGE_S2_MEMATTR(NORMAL);
+	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
+			    KVM_S2_MEMATTR(pgt, NORMAL);
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
 
 	if (!(prot & KVM_PGTABLE_PROT_X))
@@ -749,7 +760,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
-	ret = stage2_set_prot_attr(prot, &map_data.attr);
+	ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
 	if (ret)
 		return ret;
 
@@ -784,18 +795,10 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-static void stage2_flush_dcache(void *addr, u64 size)
-{
-	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		return;
-
-	__flush_dcache_area(addr, size);
-}
-
-static bool stage2_pte_cacheable(kvm_pte_t pte)
+static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
 {
 	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
-	return memattr == PAGE_S2_MEMATTR(NORMAL);
+	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
 }
 
 static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
@@ -821,8 +824,8 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 		if (mm_ops->page_count(childp) != 1)
 			return 0;
-	} else if (stage2_pte_cacheable(pte)) {
-		need_flush = true;
+	} else if (stage2_pte_cacheable(pgt, pte)) {
+		need_flush = !stage2_has_fwb(pgt);
 	}
 
 	/*
@@ -833,7 +836,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
 
 	if (need_flush) {
-		stage2_flush_dcache(kvm_pte_follow(pte, mm_ops),
+		__flush_dcache_area(kvm_pte_follow(pte, mm_ops),
 				    kvm_granule_size(level));
 	}
 
@@ -979,13 +982,14 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	struct kvm_pgtable *pgt = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep;
 
-	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pte))
+	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
 		return 0;
 
-	stage2_flush_dcache(kvm_pte_follow(pte, mm_ops), kvm_granule_size(level));
+	__flush_dcache_area(kvm_pte_follow(pte, mm_ops), kvm_granule_size(level));
 	return 0;
 }
 
@@ -994,17 +998,18 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_flush_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
-		.arg	= pgt->mm_ops,
+		.arg	= pgt,
 	};
 
-	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+	if (stage2_has_fwb(pgt))
 		return 0;
 
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
-			    struct kvm_pgtable_mm_ops *mm_ops)
+int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
+				  struct kvm_pgtable_mm_ops *mm_ops,
+				  enum kvm_pgtable_stage2_flags flags)
 {
 	size_t pgd_sz;
 	u64 vtcr = arch->vtcr;
@@ -1021,6 +1026,7 @@ int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
 	pgt->mmu		= &arch->mmu;
+	pgt->flags		= flags;
 
 	/* Ensure zeroed PGD pages are visible to the hardware walker */
 	dsb(ishst);
@@ -1101,7 +1107,7 @@ int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
 	u32 level;
 	int ret;
 
-	ret = stage2_set_prot_attr(prot, &attr);
+	ret = stage2_set_prot_attr(pgt, prot, &attr);
 	if (ret)
 		return ret;
 	attr &= KVM_PTE_LEAF_S2_COMPAT_MASK;
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
