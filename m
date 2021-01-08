Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80158C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F4107239EB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F4107239EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94F684B40C;
	Fri,  8 Jan 2021 07:15:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o1pHqlzMtDiU; Fri,  8 Jan 2021 07:15:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD7C84B386;
	Fri,  8 Jan 2021 07:15:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B7634B386
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yv6I8i3iojtw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:39 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADCE34B401
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:39 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id a11so8108942qto.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=RnVS1dxm1rUiQ69+GOF8g4XyZD3vGjLf2qqEDN7j3Lo=;
 b=qKQFpDva5vCwD+2vCXQv4j4NHIbTRh4DuhI12lK8an4HzjfYZf0L4m4KRXMerd4VVq
 JXBLYKcifAIqTcROob4gRiijxRSO0jbbl6041cyOTkWOjXS7kxmVJGzrAnvPKsXaO8KV
 AvFxYGZ71wUUr3wITObjCF0i4vvV20JPL5k6F618cmXCz8PoOekd9nDLmJ2/SYDMvCD0
 rWz6vGH0kWsCKtERSC1lM53aqzLucbC+BYD/+hJe6NG4bmktfEggbMOX0mrFQbzFSa/W
 0JQZ9PfI+slZiTBJC7n5CVwJCLy3mjRPFtVDDz2nds13rqYHV5OjD7yO2ydd12JTMLro
 JwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=RnVS1dxm1rUiQ69+GOF8g4XyZD3vGjLf2qqEDN7j3Lo=;
 b=T0elB6/Jizod68IEsMJvLuGILPalxJjegU3XWoWx0P85NZWoJiUnOwaBAb1XS7NlPd
 vh883VkQnb90yw60ST52mPyHT++45KDeQ93p91/51482Y5+dXbgTXqcVKDrdHbPXvtcy
 U4r2AcR7NL5FbhFLwJEwZMDkSZQ0IVh11biy+WWl/gHO8o6s9EKdvFM0VjfPPyCz9fNn
 oaKkQgxCdD0Ox4sgO4WO/0XcYijRvuD6lk4q1Ua2GQWZ4S7ZeymSCXlcA6OI7Qv0mKzI
 BkbPhkF3Vf+uPEoPCDkTgRphKpXwgDEMYWHdhIC5oY5kG/ZmvsyyezVE0MQNzaYZMPdn
 jPGQ==
X-Gm-Message-State: AOAM533ggw0o0G+J+dgew8M+1AyLZ0gUdl8eNy5MEn3dnE2HaqyJPvcd
 xHgLX3egs0s53vTAGbMNDO0g3tCTDt2/
X-Google-Smtp-Source: ABdhPJxijhg6fB4bKZxY4D8T4+b+1B7k67AqmxZN517ARS0IRBw3O4dazVCSCmEfVsjVwNaoW5mwpKc8g1LA
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:6a1:: with SMTP id
 s1mr3113241qvz.20.1610108139242; Fri, 08 Jan 2021 04:15:39 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:04 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-7-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 06/26] KVM: arm64: Factor memory allocation out of
 pgtable.c
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
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

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 32 +++++++++-
 arch/arm64/kvm/hyp/pgtable.c         | 90 +++++++++++++++++-----------
 arch/arm64/kvm/mmu.c                 | 70 +++++++++++++++++++++-
 3 files changed, 154 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 52ab38db04c7..45acc9dc6c45 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -13,17 +13,41 @@
 
 typedef u64 kvm_pte_t;
 
+/**
+ * struct kvm_pgtable_mm_ops - Memory management callbacks.
+ * @zalloc_page:	Allocate a zeroed memory page.
+ * @zalloc_pages_exact:	Allocate an exact number of zeroed memory pages.
+ * @free_pages_exact:	Free an exact number of memory pages.
+ * @get_page:		Increment the refcount on a page.
+ * @put_page:		Decrement the refcount on a page.
+ * @page_count:		Returns the refcount of a page.
+ * @phys_to_virt:	Convert a physical address into a virtual address.
+ * @virt_to_phys:	Convert a virtual address into a physical address.
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
@@ -86,10 +110,12 @@ struct kvm_pgtable_walker {
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
@@ -126,10 +152,12 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
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
index d7122c5eac24..61a8a34ddfdb 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -148,9 +148,9 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
 	return pte;
 }
 
-static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte)
+static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
 {
-	return __va(kvm_pte_to_phys(pte));
+	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
 }
 
 static void kvm_set_invalid_pte(kvm_pte_t *ptep)
@@ -159,9 +159,10 @@ static void kvm_set_invalid_pte(kvm_pte_t *ptep)
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
@@ -229,7 +230,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		goto out;
 	}
 
-	childp = kvm_pte_follow(pte);
+	childp = kvm_pte_follow(pte, data->pgt->mm_ops);
 	ret = __kvm_pgtable_walk(data, childp, level + 1);
 	if (ret)
 		goto out;
@@ -304,8 +305,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 }
 
 struct hyp_map_data {
-	u64		phys;
-	kvm_pte_t	attr;
+	u64				phys;
+	kvm_pte_t			attr;
+	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
 static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
@@ -355,6 +357,8 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			  enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	kvm_pte_t *childp;
+	struct hyp_map_data *data = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
 	if (hyp_map_walker_try_leaf(addr, end, level, ptep, arg))
 		return 0;
@@ -362,11 +366,11 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
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
 
@@ -376,6 +380,7 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 	int ret;
 	struct hyp_map_data map_data = {
 		.phys	= ALIGN_DOWN(phys, PAGE_SIZE),
+		.mm_ops	= pgt->mm_ops,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_map_walker,
@@ -393,16 +398,18 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
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
@@ -410,7 +417,9 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
 static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	put_page(virt_to_page(kvm_pte_follow(*ptep)));
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
+
+	mm_ops->put_page((void *)kvm_pte_follow(*ptep, mm_ops));
 	return 0;
 }
 
@@ -419,10 +428,11 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
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
 
@@ -434,6 +444,8 @@ struct stage2_map_data {
 
 	struct kvm_s2_mmu		*mmu;
 	struct kvm_mmu_memory_cache	*memcache;
+
+	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
 static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
@@ -501,12 +513,12 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 				struct stage2_map_data *data)
 {
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 	kvm_pte_t *childp, pte = *ptep;
-	struct page *page = virt_to_page(ptep);
 
 	if (data->anchor) {
 		if (kvm_pte_valid(pte))
-			put_page(page);
+			mm_ops->put_page(ptep);
 
 		return 0;
 	}
@@ -520,7 +532,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (!data->memcache)
 		return -ENOMEM;
 
-	childp = kvm_mmu_memory_cache_alloc(data->memcache);
+	childp = mm_ops->zalloc_page(data->memcache);
 	if (!childp)
 		return -ENOMEM;
 
@@ -532,13 +544,13 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (kvm_pte_valid(pte)) {
 		kvm_set_invalid_pte(ptep);
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
-		put_page(page);
+		mm_ops->put_page(ptep);
 	}
 
-	kvm_set_table_pte(ptep, childp);
+	kvm_set_table_pte(ptep, childp, mm_ops);
 
 out_get_page:
-	get_page(page);
+	mm_ops->get_page(ptep);
 	return 0;
 }
 
@@ -546,13 +558,14 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
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
@@ -607,6 +620,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.phys		= ALIGN_DOWN(phys, PAGE_SIZE),
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
+		.mm_ops		= pgt->mm_ops,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -643,7 +657,9 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
-	struct kvm_s2_mmu *mmu = arg;
+	struct kvm_pgtable *pgt = arg;
+	struct kvm_s2_mmu *mmu = pgt->mmu;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep, *childp = NULL;
 	bool need_flush = false;
 
@@ -651,9 +667,9 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 
 	if (kvm_pte_table(pte, level)) {
-		childp = kvm_pte_follow(pte);
+		childp = kvm_pte_follow(pte, mm_ops);
 
-		if (page_count(virt_to_page(childp)) != 1)
+		if (mm_ops->page_count(childp) != 1)
 			return 0;
 	} else if (stage2_pte_cacheable(pte)) {
 		need_flush = true;
@@ -666,15 +682,15 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
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
@@ -683,7 +699,7 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
-		.arg	= pgt->mmu,
+		.arg	= pgt,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
@@ -815,12 +831,13 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
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
 
@@ -829,6 +846,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_flush_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= pgt->mm_ops,
 	};
 
 	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
@@ -837,7 +855,8 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
+int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm,
+			    struct kvm_pgtable_mm_ops *mm_ops)
 {
 	size_t pgd_sz;
 	u64 vtcr = kvm->arch.vtcr;
@@ -846,12 +865,13 @@ int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
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
@@ -863,15 +883,16 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
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
@@ -883,10 +904,11 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
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
index 1f41173e6149..278e163beda4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -88,6 +88,48 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 	return !pfn_valid(pfn);
 }
 
+static void *stage2_memcache_alloc_page(void *arg)
+{
+	struct kvm_mmu_memory_cache *mc = arg;
+	kvm_pte_t *ptep = NULL;
+
+	/* Allocated with GFP_KERNEL_ACCOUNT, so no need to zero */
+	if (mc && mc->nobjs)
+		ptep = mc->objects[--mc->nobjs];
+
+	return ptep;
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
@@ -351,6 +393,17 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 	return 0;
 }
 
+static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
+	.zalloc_page		= stage2_memcache_alloc_page,
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
@@ -374,7 +427,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	if (!pgt)
 		return -ENOMEM;
 
-	err = kvm_pgtable_stage2_init(pgt, kvm);
+	err = kvm_pgtable_stage2_init(pgt, kvm, &kvm_s2_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
@@ -1198,6 +1251,19 @@ static int kvm_map_idmap_text(void)
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
@@ -1241,7 +1307,7 @@ int kvm_mmu_init(void)
 		goto out;
 	}
 
-	err = kvm_pgtable_hyp_init(hyp_pgtable, hyp_va_bits);
+	err = kvm_pgtable_hyp_init(hyp_pgtable, hyp_va_bits, &kvm_hyp_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
