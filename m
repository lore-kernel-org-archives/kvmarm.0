Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27941C12002
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDFFE6112D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDFFE6112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C6F4B0B2;
	Mon, 19 Jul 2021 06:48:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x4IZQRQXPAkg; Mon, 19 Jul 2021 06:48:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 955F84AC78;
	Mon, 19 Jul 2021 06:48:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBEB34AC78
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3QUEj50vOrGW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:47:57 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BEA04B098
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:57 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 q11-20020ad4434b0000b029030449450d37so8441357qvs.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xQPZWURbGoPTKgOKUpwXSewirNhESBxNhrKKCWt7434=;
 b=L8RdXw4ttae5Vs2K7NINOKLZoBbdFGwfjXFWn8bkET0oJOKxBfwAPfw/a3CCFAChd3
 rZ/mUyHzvmIR3hJe+r7LrLjJt56aB+o/eRqcS+1BSFUEs5hR1ChiyAxlcdn2Zz7cHnLt
 5J4W9Oqi9c3E6GF4M6WDvGahS3AwZti3tVxlOF8inYB3t//iiG9q4OHpoPpJgF4pxAZ7
 oGL8UyjLVBTJSTFqtMlARZktzU1Hwr6mrMMHZXqXSR75VYbVotw0Yfe5bjfFx4t8YYHa
 c19lmbnAmZIW+93r6iI3/FvOpyk5tTSdKVwTvq6eqA8GF1nxCYVLrPThZ2bTv9UbNbHu
 7LPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xQPZWURbGoPTKgOKUpwXSewirNhESBxNhrKKCWt7434=;
 b=MxiODlccRlEKeetNV9lwDfgMTsQ1RtYj6DRfw3zthx2ORGZvC4iJ65uYzCGLD0re6i
 eH3a1p2QMt8v3eYopdio8N8GbC6oHCcfRF8iTkEp+oFj+dYHH1Z5cPV7w2GnWhtOHKlx
 p9NMPVvq9ovmRlKE7YMvpznZKEvBIO2Xng0YEcHRdmAqwbI0V1diJGJO82vMHN8qBSBe
 O1ooiJ/Oz+rjb/1XnMxKpm3Lx8FyD8MvLkoEu9Vyvc/fxJs6HMNvpVoObe/iSqYc94nU
 RZgLc8bM/RIqw2i9J+VVrfDRwvasGMNU1hU9R5cbYJof1Mcgl02/3NIg3jBH2Vy8r78l
 U3Pw==
X-Gm-Message-State: AOAM531p3z7Chvx/NkMYgweCH3BtC+HuMGGsHEg43IjOdaGeWlpopVAw
 qcKzSBIKwFuBnuhfw3sAMyT+TK47uTyA
X-Google-Smtp-Source: ABdhPJyrkesxT86s4Tj/djq2B3CEsycyHyzOhzkaxyjOrOLuPXgOsyycOyHK+NTGbCGeSB4g1fJRBUf3HDlq
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a0c:9ac7:: with SMTP id
 k7mr24138746qvf.49.1626691677038; Mon, 19 Jul 2021 03:47:57 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:28 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-8-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 07/14] KVM: arm64: Enable forcing page-level stage-2 mappings
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

Much of the stage-2 manipulation logic relies on being able to destroy
block mappings if e.g. installing a smaller mapping in the range. The
rationale for this behaviour is that stage-2 mappings can always be
re-created lazily. However, this gets more complicated when the stage-2
page-table is used to store metadata about the underlying pages. In such
a case, destroying a block mapping may lead to losing part of the
state, and confuse the user of those metadata (such as the hypervisor in
nVHE protected mode).

To fix this, introduce a callback function in the pgtable struct which
is called during all map operations to determine whether the mappings
can us blocks, or should be forced to page-granularity level. This is
used by the hypervisor when creating the host stage-2 to force
page-level mappings when using non-default protection attributes.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 63 +++++++++++++++++----------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 16 +++++--
 arch/arm64/kvm/hyp/pgtable.c          | 20 +++++++--
 3 files changed, 69 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index af62203d2f7a..dd72653314c7 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -75,25 +75,6 @@ enum kvm_pgtable_stage2_flags {
 	KVM_PGTABLE_S2_IDMAP			= BIT(1),
 };
 
-/**
- * struct kvm_pgtable - KVM page-table.
- * @ia_bits:		Maximum input address size, in bits.
- * @start_level:	Level at which the page-table walk starts.
- * @pgd:		Pointer to the first top-level entry of the page-table.
- * @mm_ops:		Memory management callbacks.
- * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
- */
-struct kvm_pgtable {
-	u32					ia_bits;
-	u32					start_level;
-	kvm_pte_t				*pgd;
-	struct kvm_pgtable_mm_ops		*mm_ops;
-
-	/* Stage-2 only */
-	struct kvm_s2_mmu			*mmu;
-	enum kvm_pgtable_stage2_flags		flags;
-};
-
 /**
  * enum kvm_pgtable_prot - Page-table permissions and attributes.
  * @KVM_PGTABLE_PROT_X:		Execute permission.
@@ -109,11 +90,41 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
 };
 
-#define PAGE_HYP		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
+#define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
+#define KVM_PGTABLE_PROT_RWX	(KVM_PGTABLE_PROT_RW | KVM_PGTABLE_PROT_X)
+
+#define PAGE_HYP		KVM_PGTABLE_PROT_RW
 #define PAGE_HYP_EXEC		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_X)
 #define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
 #define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
 
+typedef bool (*kvm_pgtable_want_pte_cb_t)(u64 addr, u64 end,
+					  enum kvm_pgtable_prot prot);
+
+/**
+ * struct kvm_pgtable - KVM page-table.
+ * @ia_bits:		Maximum input address size, in bits.
+ * @start_level:	Level at which the page-table walk starts.
+ * @pgd:		Pointer to the first top-level entry of the page-table.
+ * @mm_ops:		Memory management callbacks.
+ * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
+ * @flags:		Stage-2 page-table flags.
+ * @want_pte_cb:	Callback function used during map operations to decide
+ *			whether block mappings can be used to map the given IPA
+ *			range.
+ */
+struct kvm_pgtable {
+	u32					ia_bits;
+	u32					start_level;
+	kvm_pte_t				*pgd;
+	struct kvm_pgtable_mm_ops		*mm_ops;
+
+	/* Stage-2 only */
+	struct kvm_s2_mmu			*mmu;
+	enum kvm_pgtable_stage2_flags		flags;
+	kvm_pgtable_want_pte_cb_t		want_pte_cb;
+};
+
 /**
  * struct kvm_mem_range - Range of Intermediate Physical Addresses
  * @start:	Start of the range.
@@ -216,21 +227,25 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
 
 /**
- * kvm_pgtable_stage2_init_flags() - Initialise a guest stage-2 page-table.
+ * kvm_pgtable_stage2_init_full() - Initialise a guest stage-2 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
  * @arch:	Arch-specific KVM structure representing the guest virtual
  *		machine.
  * @mm_ops:	Memory management callbacks.
  * @flags:	Stage-2 configuration flags.
+ * @want_pte_cb: Callback function used during map operations to decide
+ *		whether block mappings can be used to map the given IPA
+ *		range.
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
+int kvm_pgtable_stage2_init_full(struct kvm_pgtable *pgt, struct kvm_arch *arch,
 				  struct kvm_pgtable_mm_ops *mm_ops,
-				  enum kvm_pgtable_stage2_flags flags);
+				  enum kvm_pgtable_stage2_flags flags,
+				  kvm_pgtable_want_pte_cb_t want_pte_cb);
 
 #define kvm_pgtable_stage2_init(pgt, arch, mm_ops) \
-	kvm_pgtable_stage2_init_flags(pgt, arch, mm_ops, 0)
+	kvm_pgtable_stage2_init_full(pgt, arch, mm_ops, 0, NULL)
 
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 58edc62be6f7..cdace80d3e28 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -89,6 +89,7 @@ static void prepare_host_vtcr(void)
 					  id_aa64mmfr1_el1_sys_val, phys_shift);
 }
 
+static bool host_stage2_want_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot);
 int kvm_host_prepare_stage2(void *pgt_pool_base)
 {
 	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
@@ -101,8 +102,9 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 	if (ret)
 		return ret;
 
-	ret = kvm_pgtable_stage2_init_flags(&host_kvm.pgt, &host_kvm.arch,
-					    &host_kvm.mm_ops, KVM_HOST_S2_FLAGS);
+	ret = kvm_pgtable_stage2_init_full(&host_kvm.pgt, &host_kvm.arch,
+					   &host_kvm.mm_ops, KVM_HOST_S2_FLAGS,
+					   host_stage2_want_pte_cb);
 	if (ret)
 		return ret;
 
@@ -225,9 +227,17 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
 		__ret;							\
 	 })
 
+static bool host_stage2_want_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
+{
+	if (range_is_memory(addr, end))
+		return prot != KVM_PGTABLE_PROT_RWX;
+	else
+		return prot != KVM_PGTABLE_PROT_RW;
+}
+
 static int host_stage2_idmap(u64 addr)
 {
-	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_RW;
 	struct kvm_mem_range range;
 	bool is_memory = find_mem_range(addr, &range);
 	int ret;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 34cf67997a82..5bdbe7a31551 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -452,6 +452,8 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	pgt->start_level	= KVM_PGTABLE_MAX_LEVELS - levels;
 	pgt->mm_ops		= mm_ops;
 	pgt->mmu		= NULL;
+	pgt->want_pte_cb	= NULL;
+
 	return 0;
 }
 
@@ -491,6 +493,7 @@ struct stage2_map_data {
 	struct kvm_pgtable_mm_ops	*mm_ops;
 
 	int				ret;
+	bool				force_pte;
 };
 
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
@@ -613,6 +616,9 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	struct kvm_pgtable *pgt = data->mmu->pgt;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
+	if (data->force_pte && (level < (KVM_PGTABLE_MAX_LEVELS - 1)))
+		return -E2BIG;
+
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return -E2BIG;
 
@@ -660,6 +666,9 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	if (data->anchor)
 		return 0;
 
+	if (data->force_pte && (level < (KVM_PGTABLE_MAX_LEVELS - 1)))
+		return 0;
+
 	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
 		return 0;
 
@@ -791,6 +800,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.memcache	= mc,
 		.mm_ops		= pgt->mm_ops,
 		.ret		= 0,
+		.force_pte	= pgt->want_pte_cb && pgt->want_pte_cb(addr, addr + size, prot),
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -826,6 +836,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.mm_ops		= pgt->mm_ops,
 		.owner_id	= owner_id,
 		.ret		= 0,
+		.force_pte	= true,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -1070,9 +1081,11 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
-				  struct kvm_pgtable_mm_ops *mm_ops,
-				  enum kvm_pgtable_stage2_flags flags)
+
+int kvm_pgtable_stage2_init_full(struct kvm_pgtable *pgt, struct kvm_arch *arch,
+				 struct kvm_pgtable_mm_ops *mm_ops,
+				 enum kvm_pgtable_stage2_flags flags,
+				 kvm_pgtable_want_pte_cb_t want_pte_cb)
 {
 	size_t pgd_sz;
 	u64 vtcr = arch->vtcr;
@@ -1090,6 +1103,7 @@ int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch
 	pgt->mm_ops		= mm_ops;
 	pgt->mmu		= &arch->mmu;
 	pgt->flags		= flags;
+	pgt->want_pte_cb	= want_pte_cb;
 
 	/* Ensure zeroed PGD pages are visible to the hardware walker */
 	dsb(ishst);
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
