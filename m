Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F237C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D96264F6E
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D96264F6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00BEF4B4FC;
	Mon, 15 Mar 2021 10:36:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZOABSWUVq6RZ; Mon, 15 Mar 2021 10:35:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 415E04B5FA;
	Mon, 15 Mar 2021 10:35:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 694A54B5F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MsB-1Exq0oZn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:35:54 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 169B34B5E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:54 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id v5so8275967wml.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cfQPk0txhi6pRhrSzC5CCKI9y3kpD6aVqWU5MSiFxCU=;
 b=folW5WV82z0MoJmH+6AfLOY0GujsfA61h7ipx6Cy//Se0T3RcRPcHkrWu8qgTsvAgL
 L761MmjpZ/zF9ScBOWQtDiIKMdufI0zXgxUVJUutVryjlKGMOEKBhlkMkk5YCaSVqVCQ
 S4Q2sy1MpB88hMTRhLxjsR1h39IDnlGCNFo6WnUUGAKx8k0Qir/RjpqfA+qfXr9ONvkb
 mwNOpAMnk8TON4KHOVpfG0SeHzP+EuB0K+cw0wbFEv6hkeSFM8nz4NU6JwS5BYC/oN2W
 tw3rJ/VEsZ1HBIMkbefbmtNb3FrztlKx5TMKHG2MMTEhiQNPStvpYMNR1vMtZX0XplSp
 lmfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cfQPk0txhi6pRhrSzC5CCKI9y3kpD6aVqWU5MSiFxCU=;
 b=hcVIT2ZciOXyK57Q+sdQ0elGQE/ZlY25QBC0rc40uMkF1HaZVDCLgJ+Gbj+NsULAhH
 7vISqOmwttNXrinWZ9Mj/RGMh4B0trCt1hSMEn10WwiSC3xgITTyfTDFIyWWHoRCZDm0
 FKYKA9ixcbS2oaV4qrZpYaVKqlE0YuRJKnQUUuRPLC2tLlPc6TAQGYQDfT3Iw5V+QvvG
 gJUEH09GHQIPJp41MUMTjZPyRPzq0K7/TAcmlB2/G7UV9eKFX34B4wW3eF3qTPiQELTV
 7o3BEM7CmwMqaIq8Z/v8K9w2dc+ocQ3JVkqjlN6TFpR+YacNwlS2YHXkKi7DSnX4+f3B
 ZERw==
X-Gm-Message-State: AOAM533x97rRe4Xp8n7eBHaMBT9Xf63DQy/2ZvTbPZsvl7RDgbXrZPRa
 nKP7mJPefNqTYMc8v8B21wAAhAmaoVbZ
X-Google-Smtp-Source: ABdhPJxTpzoYocRpp+WJS2LcqtLjC5nJI6b2/K2566M717d0qEzRpLor4T9HPNWlJ4KWYOFduqzZJrw0QdMH
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:adf:ec0b:: with SMTP id
 x11mr26917355wrn.175.1615818953164; Mon, 15 Mar 2021 07:35:53 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:06 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-7-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 06/36] KVM: arm64: Factor memory allocation out of pgtable.c
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

In preparation for enabling the creation of page-tables at EL2, factor
all memory allocation out of the page-table code, hence making it
re-usable with any compatible memory allocator.

No functional changes intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 41 +++++++++++-
 arch/arm64/kvm/hyp/pgtable.c         | 98 +++++++++++++++++-----------
 arch/arm64/kvm/mmu.c                 | 66 ++++++++++++++++++-
 3 files changed, 163 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 8886d43cfb11..bbe840e430cb 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -13,17 +13,50 @@
 
 typedef u64 kvm_pte_t;
 
+/**
+ * struct kvm_pgtable_mm_ops - Memory management callbacks.
+ * @zalloc_page:	Allocate a single zeroed memory page. The @arg parameter
+ *			can be used by the walker to pass a memcache. The
+ *			initial refcount of the page is 1.
+ * @zalloc_pages_exact:	Allocate an exact number of zeroed memory pages. The
+ *			@size parameter is in bytes, and is rounded-up to the
+ *			next page boundary. The resulting allocation is
+ *			physically contiguous.
+ * @free_pages_exact:	Free an exact number of memory pages previously
+ *			allocated by zalloc_pages_exact.
+ * @get_page:		Increment the refcount on a page.
+ * @put_page:		Decrement the refcount on a page. When the refcount
+ *			reaches 0 the page is automatically freed.
+ * @page_count:		Return the refcount of a page.
+ * @phys_to_virt:	Convert a physical address into a virtual address mapped
+ *			in the current context.
+ * @virt_to_phys:	Convert a virtual address mapped in the current context
+ *			into a physical address.
+ */
+struct kvm_pgtable_mm_ops {
+	void*		(*zalloc_page)(void *arg);
+	void*		(*zalloc_pages_exact)(size_t size);
+	void		(*free_pages_exact)(void *addr, size_t size);
+	void		(*get_page)(void *addr);
+	void		(*put_page)(void *addr);
+	int		(*page_count)(void *addr);
+	void*		(*phys_to_virt)(phys_addr_t phys);
+	phys_addr_t	(*virt_to_phys)(void *addr);
+};
+
 /**
  * struct kvm_pgtable - KVM page-table.
  * @ia_bits:		Maximum input address size, in bits.
  * @start_level:	Level at which the page-table walk starts.
  * @pgd:		Pointer to the first top-level entry of the page-table.
+ * @mm_ops:		Memory management callbacks.
  * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
  */
 struct kvm_pgtable {
 	u32					ia_bits;
 	u32					start_level;
 	kvm_pte_t				*pgd;
+	struct kvm_pgtable_mm_ops		*mm_ops;
 
 	/* Stage-2 only */
 	struct kvm_s2_mmu			*mmu;
@@ -86,10 +119,12 @@ struct kvm_pgtable_walker {
  * kvm_pgtable_hyp_init() - Initialise a hypervisor stage-1 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
  * @va_bits:	Maximum virtual address bits.
+ * @mm_ops:	Memory management callbacks.
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits);
+int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
+			 struct kvm_pgtable_mm_ops *mm_ops);
 
 /**
  * kvm_pgtable_hyp_destroy() - Destroy an unused hypervisor stage-1 page-table.
@@ -126,10 +161,12 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
  * kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
  * @kvm:	KVM structure representing the guest virtual machine.
+ * @mm_ops:	Memory management callbacks.
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm);
+int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm,
+			    struct kvm_pgtable_mm_ops *mm_ops);
 
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 81fe032f34d1..b975a67d1f85 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -152,9 +152,9 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
 	return pte;
 }
 
-static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte)
+static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
 {
-	return __va(kvm_pte_to_phys(pte));
+	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
 }
 
 static void kvm_set_invalid_pte(kvm_pte_t *ptep)
@@ -163,9 +163,10 @@ static void kvm_set_invalid_pte(kvm_pte_t *ptep)
 	WRITE_ONCE(*ptep, pte & ~KVM_PTE_VALID);
 }
 
-static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp)
+static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
+			      struct kvm_pgtable_mm_ops *mm_ops)
 {
-	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(__pa(childp));
+	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
 
 	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
 	pte |= KVM_PTE_VALID;
@@ -227,7 +228,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		goto out;
 	}
 
-	childp = kvm_pte_follow(pte);
+	childp = kvm_pte_follow(pte, data->pgt->mm_ops);
 	ret = __kvm_pgtable_walk(data, childp, level + 1);
 	if (ret)
 		goto out;
@@ -302,8 +303,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 }
 
 struct hyp_map_data {
-	u64		phys;
-	kvm_pte_t	attr;
+	u64				phys;
+	kvm_pte_t			attr;
+	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
 static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
@@ -358,6 +360,8 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			  enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	kvm_pte_t *childp;
+	struct hyp_map_data *data = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
 	if (hyp_map_walker_try_leaf(addr, end, level, ptep, arg))
 		return 0;
@@ -365,11 +369,11 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
-	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
+	childp = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
 	if (!childp)
 		return -ENOMEM;
 
-	kvm_set_table_pte(ptep, childp);
+	kvm_set_table_pte(ptep, childp, mm_ops);
 	return 0;
 }
 
@@ -379,6 +383,7 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 	int ret;
 	struct hyp_map_data map_data = {
 		.phys	= ALIGN_DOWN(phys, PAGE_SIZE),
+		.mm_ops	= pgt->mm_ops,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_map_walker,
@@ -396,16 +401,18 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 	return ret;
 }
 
-int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
+int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
+			 struct kvm_pgtable_mm_ops *mm_ops)
 {
 	u64 levels = ARM64_HW_PGTABLE_LEVELS(va_bits);
 
-	pgt->pgd = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
+	pgt->pgd = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
 	pgt->ia_bits		= va_bits;
 	pgt->start_level	= KVM_PGTABLE_MAX_LEVELS - levels;
+	pgt->mm_ops		= mm_ops;
 	pgt->mmu		= NULL;
 	return 0;
 }
@@ -413,7 +420,9 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
 static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	put_page(virt_to_page(kvm_pte_follow(*ptep)));
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
+
+	mm_ops->put_page((void *)kvm_pte_follow(*ptep, mm_ops));
 	return 0;
 }
 
@@ -422,10 +431,11 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_free_walker,
 		.flags	= KVM_PGTABLE_WALK_TABLE_POST,
+		.arg	= pgt->mm_ops,
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-	put_page(virt_to_page(pgt->pgd));
+	pgt->mm_ops->put_page(pgt->pgd);
 	pgt->pgd = NULL;
 }
 
@@ -437,6 +447,8 @@ struct stage2_map_data {
 
 	struct kvm_s2_mmu		*mmu;
 	struct kvm_mmu_memory_cache	*memcache;
+
+	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
 static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
@@ -470,7 +482,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 {
 	kvm_pte_t new, old = *ptep;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
-	struct page *page = virt_to_page(ptep);
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return -E2BIG;
@@ -492,11 +504,11 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		 */
 		kvm_set_invalid_pte(ptep);
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
-		put_page(page);
+		mm_ops->put_page(ptep);
 	}
 
 	smp_store_release(ptep, new);
-	get_page(page);
+	mm_ops->get_page(ptep);
 	data->phys += granule;
 	return 0;
 }
@@ -526,13 +538,13 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 				struct stage2_map_data *data)
 {
-	int ret;
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 	kvm_pte_t *childp, pte = *ptep;
-	struct page *page = virt_to_page(ptep);
+	int ret;
 
 	if (data->anchor) {
 		if (kvm_pte_valid(pte))
-			put_page(page);
+			mm_ops->put_page(ptep);
 
 		return 0;
 	}
@@ -547,7 +559,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (!data->memcache)
 		return -ENOMEM;
 
-	childp = kvm_mmu_memory_cache_alloc(data->memcache);
+	childp = mm_ops->zalloc_page(data->memcache);
 	if (!childp)
 		return -ENOMEM;
 
@@ -559,11 +571,11 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (kvm_pte_valid(pte)) {
 		kvm_set_invalid_pte(ptep);
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
-		put_page(page);
+		mm_ops->put_page(ptep);
 	}
 
-	kvm_set_table_pte(ptep, childp);
-	get_page(page);
+	kvm_set_table_pte(ptep, childp, mm_ops);
+	mm_ops->get_page(ptep);
 
 	return 0;
 }
@@ -572,13 +584,14 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
 {
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 	int ret = 0;
 
 	if (!data->anchor)
 		return 0;
 
-	put_page(virt_to_page(kvm_pte_follow(*ptep)));
-	put_page(virt_to_page(ptep));
+	mm_ops->put_page(kvm_pte_follow(*ptep, mm_ops));
+	mm_ops->put_page(ptep);
 
 	if (data->anchor == ptep) {
 		data->anchor = NULL;
@@ -633,6 +646,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.phys		= ALIGN_DOWN(phys, PAGE_SIZE),
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
+		.mm_ops		= pgt->mm_ops,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -669,7 +683,9 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
-	struct kvm_s2_mmu *mmu = arg;
+	struct kvm_pgtable *pgt = arg;
+	struct kvm_s2_mmu *mmu = pgt->mmu;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep, *childp = NULL;
 	bool need_flush = false;
 
@@ -677,9 +693,9 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 
 	if (kvm_pte_table(pte, level)) {
-		childp = kvm_pte_follow(pte);
+		childp = kvm_pte_follow(pte, mm_ops);
 
-		if (page_count(virt_to_page(childp)) != 1)
+		if (mm_ops->page_count(childp) != 1)
 			return 0;
 	} else if (stage2_pte_cacheable(pte)) {
 		need_flush = true;
@@ -692,15 +708,15 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 */
 	kvm_set_invalid_pte(ptep);
 	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
-	put_page(virt_to_page(ptep));
+	mm_ops->put_page(ptep);
 
 	if (need_flush) {
-		stage2_flush_dcache(kvm_pte_follow(pte),
+		stage2_flush_dcache(kvm_pte_follow(pte, mm_ops),
 				    kvm_granule_size(level));
 	}
 
 	if (childp)
-		put_page(virt_to_page(childp));
+		mm_ops->put_page(childp);
 
 	return 0;
 }
@@ -709,7 +725,7 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
-		.arg	= pgt->mmu,
+		.arg	= pgt,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
@@ -841,12 +857,13 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	kvm_pte_t pte = *ptep;
 
 	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pte))
 		return 0;
 
-	stage2_flush_dcache(kvm_pte_follow(pte), kvm_granule_size(level));
+	stage2_flush_dcache(kvm_pte_follow(pte, mm_ops), kvm_granule_size(level));
 	return 0;
 }
 
@@ -855,6 +872,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_flush_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= pgt->mm_ops,
 	};
 
 	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
@@ -863,7 +881,8 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
+int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm,
+			    struct kvm_pgtable_mm_ops *mm_ops)
 {
 	size_t pgd_sz;
 	u64 vtcr = kvm->arch.vtcr;
@@ -872,12 +891,13 @@ int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
 	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
 
 	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
-	pgt->pgd = alloc_pages_exact(pgd_sz, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	pgt->pgd = mm_ops->zalloc_pages_exact(pgd_sz);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
 	pgt->ia_bits		= ia_bits;
 	pgt->start_level	= start_level;
+	pgt->mm_ops		= mm_ops;
 	pgt->mmu		= &kvm->arch.mmu;
 
 	/* Ensure zeroed PGD pages are visible to the hardware walker */
@@ -889,15 +909,16 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			      enum kvm_pgtable_walk_flags flag,
 			      void * const arg)
 {
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	kvm_pte_t pte = *ptep;
 
 	if (!kvm_pte_valid(pte))
 		return 0;
 
-	put_page(virt_to_page(ptep));
+	mm_ops->put_page(ptep);
 
 	if (kvm_pte_table(pte, level))
-		put_page(virt_to_page(kvm_pte_follow(pte)));
+		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
 
 	return 0;
 }
@@ -909,10 +930,11 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 		.cb	= stage2_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF |
 			  KVM_PGTABLE_WALK_TABLE_POST,
+		.arg	= pgt->mm_ops,
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
 	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
-	free_pages_exact(pgt->pgd, pgd_sz);
+	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
 	pgt->pgd = NULL;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 77cb2d28f2a4..4d41d7838d53 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -88,6 +88,44 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 	return !pfn_valid(pfn);
 }
 
+static void *stage2_memcache_zalloc_page(void *arg)
+{
+	struct kvm_mmu_memory_cache *mc = arg;
+
+	/* Allocated with __GFP_ZERO, so no need to zero */
+	return kvm_mmu_memory_cache_alloc(mc);
+}
+
+static void *kvm_host_zalloc_pages_exact(size_t size)
+{
+	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+}
+
+static void kvm_host_get_page(void *addr)
+{
+	get_page(virt_to_page(addr));
+}
+
+static void kvm_host_put_page(void *addr)
+{
+	put_page(virt_to_page(addr));
+}
+
+static int kvm_host_page_count(void *addr)
+{
+	return page_count(virt_to_page(addr));
+}
+
+static phys_addr_t kvm_host_pa(void *addr)
+{
+	return __pa(addr);
+}
+
+static void *kvm_host_va(phys_addr_t phys)
+{
+	return __va(phys);
+}
+
 /*
  * Unmapping vs dcache management:
  *
@@ -351,6 +389,17 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 	return 0;
 }
 
+static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
+	.zalloc_page		= stage2_memcache_zalloc_page,
+	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
+	.free_pages_exact	= free_pages_exact,
+	.get_page		= kvm_host_get_page,
+	.put_page		= kvm_host_put_page,
+	.page_count		= kvm_host_page_count,
+	.phys_to_virt		= kvm_host_va,
+	.virt_to_phys		= kvm_host_pa,
+};
+
 /**
  * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
  * @kvm:	The pointer to the KVM structure
@@ -374,7 +423,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	if (!pgt)
 		return -ENOMEM;
 
-	err = kvm_pgtable_stage2_init(pgt, kvm);
+	err = kvm_pgtable_stage2_init(pgt, kvm, &kvm_s2_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
@@ -1208,6 +1257,19 @@ static int kvm_map_idmap_text(void)
 	return err;
 }
 
+static void *kvm_hyp_zalloc_page(void *arg)
+{
+	return (void *)get_zeroed_page(GFP_KERNEL);
+}
+
+static struct kvm_pgtable_mm_ops kvm_hyp_mm_ops = {
+	.zalloc_page		= kvm_hyp_zalloc_page,
+	.get_page		= kvm_host_get_page,
+	.put_page		= kvm_host_put_page,
+	.phys_to_virt		= kvm_host_va,
+	.virt_to_phys		= kvm_host_pa,
+};
+
 int kvm_mmu_init(void)
 {
 	int err;
@@ -1251,7 +1313,7 @@ int kvm_mmu_init(void)
 		goto out;
 	}
 
-	err = kvm_pgtable_hyp_init(hyp_pgtable, hyp_va_bits);
+	err = kvm_pgtable_hyp_init(hyp_pgtable, hyp_va_bits, &kvm_hyp_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
