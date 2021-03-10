Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40580C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFA7D64FB5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFA7D64FB5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61A834B41F;
	Wed, 10 Mar 2021 12:59:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7lu5ymBnMJyb; Wed, 10 Mar 2021 12:59:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1D364B65C;
	Wed, 10 Mar 2021 12:58:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 379244B686
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XwRFnVzJn2vP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:57 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F28464B687
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:56 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id b21so13549219qtr.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=oJAEWGythqEowVh0n8HMKtwcniboC/S1aRtheNM7IbE=;
 b=cJzFnkrAT9fGjpNBXYhuuJPuJr8xf3G3JewcI+WPvURd6Io9t0i5rlaNRjeWqYPx/Y
 eka8vAXibXBnvp1mXYExjSyRNZKktSJI4VnhbJcjj7XalIQPeivVnmJRgECvhF7yYktc
 QH+jTNqGz17MxFaT24apKPJgDPJ84YCqDw0AQKQoJBDrUW4FUxuafKRVaqUASQCJgt4W
 zDXjXTbKU655Hi06aEooIs+AEcvNKClEJAQFk4k07xLpfajULWPSGUyKHd3q96HcDkfC
 OiBee+YVNUnM9DkSFpdLAcxla0asRJhapKsob7jGQ++zkQptlutrfxjQG2DUIKPAUHlR
 +Avw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=oJAEWGythqEowVh0n8HMKtwcniboC/S1aRtheNM7IbE=;
 b=jVCR8V5sbpip5Sp5QANApTNkbKUnb+feWIKx75JPeG8pmNjIaopib+/9D/9hKp9vVN
 N/xm5DUke0rMJioUafNbkwRpmU6unqBztfwveIuZhJFpsMfmpRyboJJE+iNVFG9MpzL0
 hyR5yrL8xM7IIYkeS5DzaUmbTI2CA1HVlVXB+ikmeGO++l2BFndMmqwEvn36bUXWoSsb
 kwpugoi3jpfwp7gE8CSmcMmpu9rrcRdGdvX8QU4FI5e9LqnQ6p5Ui9iHZcy+2vzPr6Nw
 qM7UW4wfNKZpWJPGaF3LTR2icMLkv2d/j28Nd4qDf3+icSRnQ1NzilPQIdUyhwZuWB7Z
 mJOA==
X-Gm-Message-State: AOAM533Q+G71EYXK9C4bHnCeb+APz2Arb23lt1XMOsdy5xCPUTuB99Xd
 +8NjFSOpzN9uZQCwNqdJ3tof8dT9G2mn
X-Google-Smtp-Source: ABdhPJzEM5vQ7ta5jwY/6r7uIre+Ch2NIuo2JzdxZFwKwwT7Uiy3AfJO64LToZY/HChaNQ0THAG1P5zpU4GU
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:b92f:: with SMTP id
 u47mr4092501qvf.8.1615399136610; Wed, 10 Mar 2021 09:58:56 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:45 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-29-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 28/34] KVM: arm64: Use page-table to track page ownership
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

As the host stage 2 will be identity mapped, all the .hyp memory regions
and/or memory pages donated to protected guestis will have to marked
invalid in the host stage 2 page-table. At the same time, the hypervisor
will need a way to track the ownership of each physical page to ensure
memory sharing or donation between entities (host, guests, hypervisor) is
legal.

In order to enable this tracking at EL2, let's use the host stage 2
page-table itself. The idea is to use the top bits of invalid mappings
to store the unique identifier of the page owner. The page-table owner
(the host) gets identifier 0 such that, at boot time, it owns the entire
IPA space as the pgd starts zeroed.

Provide kvm_pgtable_stage2_set_owner() which allows to modify the
ownership of pages in the host stage 2. It re-uses most of the map()
logic, but ends up creating invalid mappings instead. This impacts
how we do refcount as we now need to count invalid mappings when they
are used for ownership tracking.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 21 +++++++
 arch/arm64/kvm/hyp/pgtable.c         | 92 ++++++++++++++++++++++++----
 2 files changed, 101 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4ae19247837b..b09af4612656 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -238,6 +238,27 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
 			   void *mc);
 
+/**
+ * kvm_pgtable_stage2_set_owner() - Annotate invalid mappings with metadata
+ *				    encoding the ownership of a page in the
+ *				    IPA space.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address at which to place the annotation.
+ * @size:	Size of the IPA range to annotate.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
+ * @owner_id:	Unique identifier for the owner of the page.
+ *
+ * The page-table owner has identifier 0. This function can be used to mark
+ * portions of the IPA space as owned by other entities. When a stage 2 is used
+ * with identity-mappings, these annotations allow to use the page-table data
+ * structure as a simple rmap.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				 void *mc, u32 owner_id);
+
 /**
  * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f37b4179b880..e4670b639726 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -48,6 +48,8 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 32)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -186,6 +188,11 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
 	return pte;
 }
 
+static kvm_pte_t kvm_init_invalid_leaf_owner(u32 owner_id)
+{
+	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
+}
+
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
@@ -440,6 +447,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 struct stage2_map_data {
 	u64				phys;
 	kvm_pte_t			attr;
+	u32				owner_id;
 
 	kvm_pte_t			*anchor;
 	kvm_pte_t			*childp;
@@ -506,6 +514,24 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	return 0;
 }
 
+static bool stage2_is_permission_change(kvm_pte_t old, kvm_pte_t new)
+{
+	if (!kvm_pte_valid(old) || !kvm_pte_valid(new))
+		return false;
+
+	return !((old ^ new) & (~KVM_PTE_LEAF_ATTR_S2_PERMS));
+}
+
+static bool stage2_pte_is_counted(kvm_pte_t pte)
+{
+	/*
+	 * The refcount tracks valid entries as well as invalid entries if they
+	 * encode ownership of a page to another entity than the page-table
+	 * owner, whose id is 0.
+	 */
+	return !!pte;
+}
+
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
@@ -517,28 +543,36 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return -E2BIG;
 
-	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (kvm_pte_valid(old)) {
+	if (kvm_pte_valid(data->attr))
+		new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+	else
+		new = kvm_init_invalid_leaf_owner(data->owner_id);
+
+	if (stage2_pte_is_counted(old)) {
 		/*
 		 * Skip updating the PTE if we are trying to recreate the exact
 		 * same mapping or only change the access permissions. Instead,
 		 * the vCPU will exit one more time from guest if still needed
 		 * and then go through the path of relaxing permissions.
 		 */
-		if (!((old ^ new) & (~KVM_PTE_LEAF_ATTR_S2_PERMS)))
+		if (stage2_is_permission_change(old, new))
 			return -EAGAIN;
 
 		/*
-		 * There's an existing different valid leaf entry, so perform
-		 * break-before-make.
+		 * Clear the existing PTE, and perform break-before-make with
+		 * TLB maintenance if it was valid.
 		 */
 		kvm_clear_pte(ptep);
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+		if (kvm_pte_valid(old)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr,
+				     level);
+		}
 		mm_ops->put_page(ptep);
 	}
 
 	smp_store_release(ptep, new);
-	mm_ops->get_page(ptep);
+	if (stage2_pte_is_counted(new))
+		mm_ops->get_page(ptep);
 	data->phys += granule;
 	return 0;
 }
@@ -574,7 +608,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	int ret;
 
 	if (data->anchor) {
-		if (kvm_pte_valid(pte))
+		if (stage2_pte_is_counted(pte))
 			mm_ops->put_page(ptep);
 
 		return 0;
@@ -599,9 +633,10 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
-	if (kvm_pte_valid(pte)) {
+	if (stage2_pte_is_counted(pte)) {
 		kvm_clear_pte(ptep);
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+		if (kvm_pte_valid(pte))
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
 		mm_ops->put_page(ptep);
 	}
 
@@ -683,6 +718,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
 		.mm_ops		= pgt->mm_ops,
+		.owner_id	= 0,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -696,6 +732,33 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	if (ret)
 		return ret;
 
+	/* Set the valid flag to distinguish with the set_owner() path. */
+	map_data.attr |= KVM_PTE_VALID;
+
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	dsb(ishst);
+	return ret;
+}
+
+int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				 void *mc, u32 owner_id)
+{
+	int ret;
+	struct stage2_map_data map_data = {
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+		.mm_ops		= pgt->mm_ops,
+		.owner_id	= owner_id,
+		.attr		= 0,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= stage2_map_walker,
+		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
+				  KVM_PGTABLE_WALK_LEAF |
+				  KVM_PGTABLE_WALK_TABLE_POST,
+		.arg		= &map_data,
+	};
+
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
 	dsb(ishst);
 	return ret;
@@ -725,8 +788,13 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	kvm_pte_t pte = *ptep, *childp = NULL;
 	bool need_flush = false;
 
-	if (!kvm_pte_valid(pte))
+	if (!kvm_pte_valid(pte)) {
+		if (stage2_pte_is_counted(pte)) {
+			kvm_clear_pte(ptep);
+			mm_ops->put_page(ptep);
+		}
 		return 0;
+	}
 
 	if (kvm_pte_table(pte, level)) {
 		childp = kvm_pte_follow(pte, mm_ops);
@@ -948,7 +1016,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	kvm_pte_t pte = *ptep;
 
-	if (!kvm_pte_valid(pte))
+	if (!stage2_pte_is_counted(pte))
 		return 0;
 
 	mm_ops->put_page(ptep);
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
