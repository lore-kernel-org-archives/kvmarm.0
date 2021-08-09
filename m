Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0EEC4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D28E761078
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D28E761078
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 722494B105;
	Mon,  9 Aug 2021 11:25:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wMDuYybL3sIg; Mon,  9 Aug 2021 11:25:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8E734B0FA;
	Mon,  9 Aug 2021 11:25:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E676F4B101
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nX2NCLTGNE3h for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:14 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCACA40856
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:13 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 cb3-20020ad456230000b02903319321d1e3so11110096qvb.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=70o1p9T2yrXnR7kwCBzcsvYiWZbSw7GxMLQVcwsnfAk=;
 b=XdV5jZzO88qZVD7CT6bTH1V+RO7/ta+lS3AGiKGYxx2q/zbEX/XeIP043P2PvpaI42
 LhLQzSWzuaKN0AB2Hu4Dn/5gmOKR44PrV/e99ZLMhwr0nUXykbyi8jo5rqxSLxTZ7tu8
 M7WVnYNO7XOR8Io/u0e8grpvD/d4VVb/+pr0nA7UUlHRT3uvGQiREG8Zgx5YVCqHzUAx
 yILJCdHUv99cDWlcDuYnGPeg9+GO4ZGYtbegHSFmfIVnlDpJ9HJqInCbIBMA0DUz49Y3
 VRFPuu7rus9aySOAREFUtnE5uW07LJ0wOtyQnzitAYH7DWVtBCh6ZQAotzkjEkt4TQft
 Z6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=70o1p9T2yrXnR7kwCBzcsvYiWZbSw7GxMLQVcwsnfAk=;
 b=Maq/YKsfsswSaeGqa9qKFbtUxpFpbIIkp94Ofy4nVPqu3+/WMgpb3M1sEHp7loivqt
 lZ6c6Ir/EfUhac3MwU4uqZA4572lfEAPH/NE3FA4O3Q4l7k72s1Ks55Svo/CvuDd8u7j
 /iRT9z+h65w49GKzE3imxfFxQQ/ekj9ZIUUr338ThKTorY1afoqRd2PChMELPGpdt+F+
 1f9iUXhpMewAVs4avXyO11CdwiOI27gH+dZsP+Vpbp29I9sxuu+qjydcrd5k1mBuGe+p
 SSFJ17iy47h/mOzsjCez+GxfmAiI2Q20OiklcfOsowURjD+MfUho6fA6KcSJXWGJ0FsO
 YL4Q==
X-Gm-Message-State: AOAM533gfmW4Qsc1LqqiKUpbdqaZ3HquVWFVTmesvDB83tvzo6RaKnhG
 vqUlec+/qWLX3NZC/FA4m9JDKW31tU9w
X-Google-Smtp-Source: ABdhPJycvuemF1/YjunyxQTI+Hc1BBpUtCt6LUgKSmJpnGd04AlbbCnK/c5/bJkNsshxXK1v5uhMC1oLfHJF
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a0c:f28f:: with SMTP id
 k15mr3144025qvl.43.1628522713431; Mon, 09 Aug 2021 08:25:13 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:37 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-11-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 10/21] KVM: arm64: Enable forcing page-level stage-2
 mappings
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
cases, destroying a block mapping may lead to losing part of the state,
and confuse the user of those metadata (such as the hypervisor in nVHE
protected mode).

To avoid this, introduce a callback function in the pgtable struct which
is called during all map operations to determine whether the mappings
can use blocks, or should be forced to page granularity. This is used by
the hypervisor when creating the host stage-2 to force page-level
mappings when using non-default protection attributes.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 66 +++++++++++++++++----------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 34 ++++++++++++--
 arch/arm64/kvm/hyp/pgtable.c          | 29 ++++++++++--
 3 files changed, 94 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 83c5c97d9eac..2c090b0eee77 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -115,25 +115,6 @@ enum kvm_pgtable_stage2_flags {
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
@@ -149,11 +130,43 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
 };
 
-#define PAGE_HYP		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
+#define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
+#define KVM_PGTABLE_PROT_RWX	(KVM_PGTABLE_PROT_RW | KVM_PGTABLE_PROT_X)
+
+#define PKVM_HOST_MEM_PROT	KVM_PGTABLE_PROT_RWX
+#define PKVM_HOST_MMIO_PROT	KVM_PGTABLE_PROT_RW
+
+#define PAGE_HYP		KVM_PGTABLE_PROT_RW
 #define PAGE_HYP_EXEC		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_X)
 #define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
 #define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
 
+typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
+					   enum kvm_pgtable_prot prot);
+
+/**
+ * struct kvm_pgtable - KVM page-table.
+ * @ia_bits:		Maximum input address size, in bits.
+ * @start_level:	Level at which the page-table walk starts.
+ * @pgd:		Pointer to the first top-level entry of the page-table.
+ * @mm_ops:		Memory management callbacks.
+ * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
+ * @flags:		Stage-2 page-table flags.
+ * @force_pte_cb:	Function that returns true if page level mappings must
+ *			be used instead of block mappings.
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
+	kvm_pgtable_force_pte_cb_t		force_pte_cb;
+};
+
 /**
  * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
  * @KVM_PGTABLE_WALK_LEAF:		Visit leaf entries, including invalid
@@ -246,21 +259,24 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
 
 /**
- * kvm_pgtable_stage2_init_flags() - Initialise a guest stage-2 page-table.
+ * __kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
  * @arch:	Arch-specific KVM structure representing the guest virtual
  *		machine.
  * @mm_ops:	Memory management callbacks.
  * @flags:	Stage-2 configuration flags.
+ * @force_pte_cb: Function that returns true if page level mappings must
+ *		be used instead of block mappings.
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
-				  struct kvm_pgtable_mm_ops *mm_ops,
-				  enum kvm_pgtable_stage2_flags flags);
+int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
+			      struct kvm_pgtable_mm_ops *mm_ops,
+			      enum kvm_pgtable_stage2_flags flags,
+			      kvm_pgtable_force_pte_cb_t force_pte_cb);
 
 #define kvm_pgtable_stage2_init(pgt, arch, mm_ops) \
-	kvm_pgtable_stage2_init_flags(pgt, arch, mm_ops, 0)
+	__kvm_pgtable_stage2_init(pgt, arch, mm_ops, 0, NULL)
 
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2148d3968aa5..6fed6772c673 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -89,6 +89,8 @@ static void prepare_host_vtcr(void)
 					  id_aa64mmfr1_el1_sys_val, phys_shift);
 }
 
+static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot);
+
 int kvm_host_prepare_stage2(void *pgt_pool_base)
 {
 	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
@@ -101,8 +103,9 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 	if (ret)
 		return ret;
 
-	ret = kvm_pgtable_stage2_init_flags(&host_kvm.pgt, &host_kvm.arch,
-					    &host_kvm.mm_ops, KVM_HOST_S2_FLAGS);
+	ret = __kvm_pgtable_stage2_init(&host_kvm.pgt, &host_kvm.arch,
+					&host_kvm.mm_ops, KVM_HOST_S2_FLAGS,
+					host_stage2_force_pte_cb);
 	if (ret)
 		return ret;
 
@@ -270,15 +273,36 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 	return 0;
 }
 
+static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
+{
+	/*
+	 * Block mappings must be used with care in the host stage-2 as a
+	 * kvm_pgtable_stage2_map() operation targeting a page in the range of
+	 * an existing block will delete the block under the assumption that
+	 * mappings in the rest of the block range can always be rebuilt lazily.
+	 * That assumption is correct for the host stage-2 with RWX mappings
+	 * targeting memory or RW mappings targeting MMIO ranges (see
+	 * host_stage2_idmap() below which implements some of the host memory
+	 * abort logic). However, this is not safe for any other mappings where
+	 * the host stage-2 page-table is in fact the only place where this
+	 * state is stored. In all those cases, it is safer to use page-level
+	 * mappings, hence avoiding to lose the state because of side-effects in
+	 * kvm_pgtable_stage2_map().
+	 */
+	if (range_is_memory(addr, end))
+		return prot != PKVM_HOST_MEM_PROT;
+	else
+		return prot != PKVM_HOST_MMIO_PROT;
+}
+
 static int host_stage2_idmap(u64 addr)
 {
-	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
 	struct kvm_mem_range range;
 	bool is_memory = find_mem_range(addr, &range);
+	enum kvm_pgtable_prot prot;
 	int ret;
 
-	if (is_memory)
-		prot |= KVM_PGTABLE_PROT_X;
+	prot = is_memory ? PKVM_HOST_MEM_PROT : PKVM_HOST_MMIO_PROT;
 
 	hyp_spin_lock(&host_kvm.lock);
 	ret = host_stage2_adjust_range(addr, &range);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2689fcb7901d..e25d829587b9 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -452,6 +452,8 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	pgt->start_level	= KVM_PGTABLE_MAX_LEVELS - levels;
 	pgt->mm_ops		= mm_ops;
 	pgt->mmu		= NULL;
+	pgt->force_pte_cb	= NULL;
+
 	return 0;
 }
 
@@ -489,6 +491,9 @@ struct stage2_map_data {
 	void				*memcache;
 
 	struct kvm_pgtable_mm_ops	*mm_ops;
+
+	/* Force mappings to page granularity */
+	bool				force_pte;
 };
 
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
@@ -602,6 +607,15 @@ static bool stage2_pte_executable(kvm_pte_t pte)
 	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
 }
 
+static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
+					struct stage2_map_data *data)
+{
+	if (data->force_pte && (level < (KVM_PGTABLE_MAX_LEVELS - 1)))
+		return false;
+
+	return kvm_block_mapping_supported(addr, end, data->phys, level);
+}
+
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
@@ -611,7 +625,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	struct kvm_pgtable *pgt = data->mmu->pgt;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
-	if (!kvm_block_mapping_supported(addr, end, phys, level))
+	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
 		return -E2BIG;
 
 	if (kvm_phys_is_valid(phys))
@@ -655,7 +669,7 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	if (data->anchor)
 		return 0;
 
-	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
+	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
 		return 0;
 
 	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
@@ -785,6 +799,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
 		.mm_ops		= pgt->mm_ops,
+		.force_pte	= pgt->force_pte_cb && pgt->force_pte_cb(addr, addr + size, prot),
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -816,6 +831,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.memcache	= mc,
 		.mm_ops		= pgt->mm_ops,
 		.owner_id	= owner_id,
+		.force_pte	= true,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -1057,9 +1073,11 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch,
-				  struct kvm_pgtable_mm_ops *mm_ops,
-				  enum kvm_pgtable_stage2_flags flags)
+
+int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
+			      struct kvm_pgtable_mm_ops *mm_ops,
+			      enum kvm_pgtable_stage2_flags flags,
+			      kvm_pgtable_force_pte_cb_t force_pte_cb)
 {
 	size_t pgd_sz;
 	u64 vtcr = arch->vtcr;
@@ -1077,6 +1095,7 @@ int kvm_pgtable_stage2_init_flags(struct kvm_pgtable *pgt, struct kvm_arch *arch
 	pgt->mm_ops		= mm_ops;
 	pgt->mmu		= &arch->mmu;
 	pgt->flags		= flags;
+	pgt->force_pte_cb	= force_pte_cb;
 
 	/* Ensure zeroed PGD pages are visible to the hardware walker */
 	dsb(ishst);
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
