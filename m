Return-Path: <SRS0=snoh=CD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94055C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B5CF2074D
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9o+PBYI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B5CF2074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7EAA4C063;
	Tue, 25 Aug 2020 05:40:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IUTEPxist8fJ; Tue, 25 Aug 2020 05:40:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83BB74C071;
	Tue, 25 Aug 2020 05:40:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 378ED4C071
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HpTMxzZH3OoQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Aug 2020 05:40:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B5E24C06F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:16 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E42D320706;
 Tue, 25 Aug 2020 09:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1598348415;
 bh=nIGDYpNoWWxY7MPVaRW9pKKoU/AVN9L/5xMhnYCA5xg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=s9o+PBYI1t/FWbany+UIStn8Vpt8b1G0FS4KAEmS2KWQ8ZZsi1xrwjmElq4pch5u2
 owozvmY1CqBnFM7Iaw5v4msQRjovAUYSAHL/P0hvzbnuGNK7SzPAcOfwHnBfla/YcJ
 IJEgLd3RsXuFe0KyVHH48U4ncjfW6XqpgPCrYLEY=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 06/21] KVM: arm64: Add support for stage-2 map()/unmap() in
 generic page-table
Date: Tue, 25 Aug 2020 10:39:38 +0100
Message-Id: <20200825093953.26493-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200825093953.26493-1-will@kernel.org>
References: <20200825093953.26493-1-will@kernel.org>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Add stage-2 map() and unmap() operations to the generic page-table code.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h |  39 ++++
 arch/arm64/kvm/hyp/pgtable.c         | 262 +++++++++++++++++++++++++++
 2 files changed, 301 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 3389f978d573..8ab0d5f43817 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -134,6 +134,45 @@ int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm);
  */
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
+/**
+ * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address at which to place the mapping.
+ * @size:	Size of the mapping.
+ * @phys:	Physical address of the memory to map.
+ * @prot:	Permissions and attributes for the mapping.
+ * @mc:		Cache of pre-allocated GFP_PGTABLE_USER memory from which to
+ *		allocate page-table pages.
+ *
+ * If device attributes are not explicitly requested in @prot, then the
+ * mapping will be normal, cacheable.
+ *
+ * Note that this function will both coalesce existing table entries and split
+ * existing block mappings, relying on page-faults to fault back areas outside
+ * of the new mapping lazily.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			   u64 phys, enum kvm_pgtable_prot prot,
+			   struct kvm_mmu_memory_cache *mc);
+
+/**
+ * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address from which to remove the mapping.
+ * @size:	Size of the mapping.
+ *
+ * TLB invalidation is performed for each page-table entry cleared during the
+ * unmapping operation and the reference count for the page-table page
+ * containing the cleared entry is decremented, with unreferenced pages being
+ * freed. Unmapping a cacheable page will ensure that it is clean to the PoC if
+ * FWB is not supported by the CPU.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b8550ccaef4d..41ee8f3c0369 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -32,10 +32,19 @@
 #define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
 #define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
 
+#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
+#define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
+
 #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 
+#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -420,6 +429,259 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 	pgt->pgd = NULL;
 }
 
+struct stage2_map_data {
+	u64				phys;
+	kvm_pte_t			attr;
+
+	kvm_pte_t			*anchor;
+
+	struct kvm_s2_mmu		*mmu;
+	struct kvm_mmu_memory_cache	*memcache;
+};
+
+static kvm_pte_t *stage2_memcache_alloc_page(struct stage2_map_data *data)
+{
+	kvm_pte_t *ptep = NULL;
+	struct kvm_mmu_memory_cache *mc = data->memcache;
+
+	/* Allocated with GFP_PGTABLE_USER, so no need to zero */
+	if (mc && mc->nobjs)
+		ptep = mc->objects[--mc->nobjs];
+
+	return ptep;
+}
+
+static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
+				    struct stage2_map_data *data)
+{
+	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
+	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
+			    PAGE_S2_MEMATTR(NORMAL);
+	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
+
+	if (!(prot & KVM_PGTABLE_PROT_X))
+		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
+	else if (device)
+		return -EINVAL;
+
+	if (prot & KVM_PGTABLE_PROT_R)
+		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
+
+	if (prot & KVM_PGTABLE_PROT_W)
+		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+
+	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
+	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+	data->attr = attr;
+	return 0;
+}
+
+static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
+				       kvm_pte_t *ptep,
+				       struct stage2_map_data *data)
+{
+	u64 granule = kvm_granule_size(level), phys = data->phys;
+
+	if (!kvm_block_mapping_supported(addr, end, phys, level))
+		return false;
+
+	if (kvm_set_valid_leaf_pte(ptep, phys, data->attr, level))
+		goto out;
+
+	kvm_set_invalid_pte(ptep);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+	kvm_set_valid_leaf_pte(ptep, phys, data->attr, level);
+out:
+	data->phys += granule;
+	return true;
+}
+
+static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
+				     kvm_pte_t *ptep,
+				     struct stage2_map_data *data)
+{
+	if (data->anchor)
+		return 0;
+
+	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
+		return 0;
+
+	kvm_set_invalid_pte(ptep);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, 0);
+	data->anchor = ptep;
+	return 0;
+}
+
+static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+				struct stage2_map_data *data)
+{
+	kvm_pte_t *childp, pte = *ptep;
+	struct page *page = virt_to_page(ptep);
+
+	if (data->anchor) {
+		if (kvm_pte_valid(pte))
+			put_page(page);
+
+		return 0;
+	}
+
+	if (stage2_map_walker_try_leaf(addr, end, level, ptep, data))
+		goto out_get_page;
+
+	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
+		return -EINVAL;
+
+	childp = stage2_memcache_alloc_page(data);
+	if (!childp)
+		return -ENOMEM;
+
+	/*
+	 * If we've run into an existing block mapping then replace it with
+	 * a table. Accesses beyond 'end' that fall within the new table
+	 * will be mapped lazily.
+	 */
+	if (kvm_pte_valid(pte)) {
+		kvm_set_invalid_pte(ptep);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+		put_page(page);
+	}
+
+	kvm_set_table_pte(ptep, childp);
+
+out_get_page:
+	get_page(page);
+	return 0;
+}
+
+static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
+				      kvm_pte_t *ptep,
+				      struct stage2_map_data *data)
+{
+	int ret = 0;
+
+	if (!data->anchor)
+		return 0;
+
+	free_page((unsigned long)kvm_pte_follow(*ptep));
+	put_page(virt_to_page(ptep));
+
+	if (data->anchor == ptep) {
+		data->anchor = NULL;
+		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
+	}
+
+	return ret;
+}
+
+static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			     enum kvm_pgtable_walk_flags flag, void * const arg)
+{
+	struct stage2_map_data *data = arg;
+
+	switch (flag) {
+	case KVM_PGTABLE_WALK_TABLE_PRE:
+		return stage2_map_walk_table_pre(addr, end, level, ptep, data);
+	case KVM_PGTABLE_WALK_LEAF:
+		return stage2_map_walk_leaf(addr, end, level, ptep, data);
+	case KVM_PGTABLE_WALK_TABLE_POST:
+		return stage2_map_walk_table_post(addr, end, level, ptep, data);
+	}
+
+	return -EINVAL;
+}
+
+int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			   u64 phys, enum kvm_pgtable_prot prot,
+			   struct kvm_mmu_memory_cache *mc)
+{
+	int ret;
+	struct stage2_map_data map_data = {
+		.phys		= ALIGN_DOWN(phys, PAGE_SIZE),
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= stage2_map_walker,
+		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
+				  KVM_PGTABLE_WALK_LEAF |
+				  KVM_PGTABLE_WALK_TABLE_POST,
+		.arg		= &map_data,
+	};
+
+	ret = stage2_map_set_prot_attr(prot, &map_data);
+	if (ret)
+		return ret;
+
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	dsb(ishst);
+	return ret;
+}
+
+static void stage2_flush_dcache(void *addr, u64 size)
+{
+	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		return;
+
+	__flush_dcache_area(addr, size);
+}
+
+static bool stage2_pte_cacheable(kvm_pte_t pte)
+{
+	u64 memattr = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR, pte);
+	return memattr == PAGE_S2_MEMATTR(NORMAL);
+}
+
+static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			       enum kvm_pgtable_walk_flags flag,
+			       void * const arg)
+{
+	struct kvm_s2_mmu *mmu = arg;
+	kvm_pte_t pte = *ptep, *childp = NULL;
+	bool need_flush = false;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	if (kvm_pte_table(pte, level)) {
+		childp = kvm_pte_follow(pte);
+
+		if (page_count(virt_to_page(childp)) != 1)
+			return 0;
+	} else if (stage2_pte_cacheable(pte)) {
+		need_flush = true;
+	}
+
+	/*
+	 * This is similar to the map() path in that we unmap the entire
+	 * block entry and rely on the remaining portions being faulted
+	 * back lazily.
+	 */
+	kvm_set_invalid_pte(ptep);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
+	put_page(virt_to_page(ptep));
+
+	if (need_flush) {
+		stage2_flush_dcache(kvm_pte_follow(pte),
+				    kvm_granule_size(level));
+	}
+
+	if (childp)
+		free_page((unsigned long)childp);
+
+	return 0;
+}
+
+int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_unmap_walker,
+		.arg	= pgt->mmu,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+	};
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
+}
+
 int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
 {
 	size_t pgd_sz;
-- 
2.28.0.297.g1956fa8f8d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
