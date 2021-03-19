Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E87C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 92E7664F45
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92E7664F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6734B759;
	Fri, 19 Mar 2021 06:02:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ad2xmGXPUm+t; Fri, 19 Mar 2021 06:02:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 790844B74B;
	Fri, 19 Mar 2021 06:02:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B19C64B69B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1yz5QRbWD+mb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:53 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE9914B705
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:52 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id k4so31803199qvf.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uCWaKIwzXkMUWV4TXTc6fuBvn95K6ENl+7zmrkMsYKU=;
 b=voVuh6lKagDBbK299gD9zexiJXKdx/1gsFA5KHSr/a0OcRRw1WRVeBzwdlUQNk5u0M
 CimMB0zYFi4maQjvBNrmIKuNTgF/83Q8EafGeFapark1hQ9hkULjDr09XkxRAjDZZbGr
 3XBm96qOdasW/F7QDHuA6K5pHM+h0JxBqPRBmWpyrleMgSJvj6f6IdZVZtWKPJ92Tiaf
 f0vt8qQjMg6yOyL50L7oWLl1GfjGVIlRsUhKXFFiILKuiPxYwe4clmfJ/2Uv/xkd3I73
 yxlBFd2kx4eWL3761iEQ60o/qntV2/UKsDoR/sD9if7QnNCUTGEocuQLoieqTtKSmzgi
 rk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uCWaKIwzXkMUWV4TXTc6fuBvn95K6ENl+7zmrkMsYKU=;
 b=AahSh47QtF9cbpwJoec84mO1uAFopZF3FkQwOjfCstpepqw+FldtYVm5BdoGGtJNMw
 zfRQq+tGhJ6NeGpUgO0lgoJtObzAHnfmvWqWCSRu9ZJbo444o14UUqVGkBIGqE0P3qLC
 Qt8C9vXgf59SAY8zLny1+Yeavw5nEQ2c0XxyGzu1ySHhwS+eVAq0ADvI44L0EwMJILHI
 UZyFNod9PhNe10KCzwnzl6NY7ZF/DM5ltcuzlxdlBaZBB4+ZcPNuJZVwk52imhT2yb3+
 m6fwCKonPNMDvMD1NLhWw3fwvU2X9wjSPMg2Wey/8QqivNl3Tcc3i8c2g2mn037zwlTj
 TU+Q==
X-Gm-Message-State: AOAM531NFYhYISyK1fb+Mrhdyrkd8C1TwImxrlRD4Kox3ou+DKX7+T0h
 D4stLiTvPc+4+kjtGpqD8hQ+0gKHzBP8
X-Google-Smtp-Source: ABdhPJwho0DSrbAXjQ4jt3+4ejQVzacls+UTFuXVXx3EfafMKuxJkx11oYM3bOEu/Fsj0zr2pmUHGrxRN3im
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:b27:: with SMTP id
 w7mr8504807qvj.34.1616148172409; Fri, 19 Mar 2021 03:02:52 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:37 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-30-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 29/38] KVM: arm64: Use page-table to track page ownership
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
 arch/arm64/include/asm/kvm_pgtable.h |  20 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 126 ++++++++++++++++++++++-----
 2 files changed, 122 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4ae19247837b..eea2e2b0acaa 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -238,6 +238,26 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
 			   void *mc);
 
+/**
+ * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
+ *				    track ownership.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Base intermediate physical address to annotate.
+ * @size:	Size of the annotated range.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
+ * @owner_id:	Unique identifier for the owner of the page.
+ *
+ * By default, all page-tables are owned by identifier 0. This function can be
+ * used to mark portions of the IPA space as owned by other entities. When a
+ * stage 2 is used with identity-mappings, these annotations allow to use the
+ * page-table data structure as a simple rmap.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				 void *mc, u8 owner_id);
+
 /**
  * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0a674010afb6..eefb226e1d1e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -48,6 +48,9 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
+#define KVM_MAX_OWNER_ID		1
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -67,6 +70,13 @@ static u64 kvm_granule_size(u32 level)
 	return BIT(kvm_granule_shift(level));
 }
 
+#define KVM_PHYS_INVALID (-1ULL)
+
+static bool kvm_phys_is_valid(u64 phys)
+{
+	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_PARANGE_MAX));
+}
+
 static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
 {
 	u64 granule = kvm_granule_size(level);
@@ -81,7 +91,10 @@ static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
 	if (granule > (end - addr))
 		return false;
 
-	return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
+	if (kvm_phys_is_valid(phys) && !IS_ALIGNED(phys, granule))
+		return false;
+
+	return IS_ALIGNED(addr, granule);
 }
 
 static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
@@ -186,6 +199,11 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
 	return pte;
 }
 
+static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
+{
+	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
+}
+
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
@@ -441,6 +459,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 struct stage2_map_data {
 	u64				phys;
 	kvm_pte_t			attr;
+	u8				owner_id;
 
 	kvm_pte_t			*anchor;
 	kvm_pte_t			*childp;
@@ -507,6 +526,39 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	return 0;
 }
 
+static bool stage2_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
+{
+	if (!kvm_pte_valid(old) || !kvm_pte_valid(new))
+		return true;
+
+	return ((old ^ new) & (~KVM_PTE_LEAF_ATTR_S2_PERMS));
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
+static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
+			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
+{
+	/*
+	 * Clear the existing PTE, and perform break-before-make with
+	 * TLB maintenance if it was valid.
+	 */
+	if (kvm_pte_valid(*ptep)) {
+		kvm_clear_pte(ptep);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
+	}
+
+	mm_ops->put_page(ptep);
+}
+
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
@@ -518,29 +570,29 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return -E2BIG;
 
-	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (kvm_pte_valid(old)) {
+	if (kvm_phys_is_valid(phys))
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
+		if (!stage2_pte_needs_update(old, new))
 			return -EAGAIN;
 
-		/*
-		 * There's an existing different valid leaf entry, so perform
-		 * break-before-make.
-		 */
-		kvm_clear_pte(ptep);
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
-		mm_ops->put_page(ptep);
+		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
 	}
 
 	smp_store_release(ptep, new);
-	mm_ops->get_page(ptep);
-	data->phys += granule;
+	if (stage2_pte_is_counted(new))
+		mm_ops->get_page(ptep);
+	if (kvm_phys_is_valid(phys))
+		data->phys += granule;
 	return 0;
 }
 
@@ -575,7 +627,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	int ret;
 
 	if (data->anchor) {
-		if (kvm_pte_valid(pte))
+		if (stage2_pte_is_counted(pte))
 			mm_ops->put_page(ptep);
 
 		return 0;
@@ -600,11 +652,8 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
-	if (kvm_pte_valid(pte)) {
-		kvm_clear_pte(ptep);
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
-		mm_ops->put_page(ptep);
-	}
+	if (stage2_pte_is_counted(pte))
+		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
 	mm_ops->get_page(ptep);
@@ -702,6 +751,32 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
+int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				 void *mc, u8 owner_id)
+{
+	int ret;
+	struct stage2_map_data map_data = {
+		.phys		= KVM_PHYS_INVALID,
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+		.mm_ops		= pgt->mm_ops,
+		.owner_id	= owner_id,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= stage2_map_walker,
+		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
+				  KVM_PGTABLE_WALK_LEAF |
+				  KVM_PGTABLE_WALK_TABLE_POST,
+		.arg		= &map_data,
+	};
+
+	if (owner_id > KVM_MAX_OWNER_ID)
+		return -EINVAL;
+
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	return ret;
+}
+
 static void stage2_flush_dcache(void *addr, u64 size)
 {
 	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
@@ -726,8 +801,13 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
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
@@ -743,9 +823,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	kvm_clear_pte(ptep);
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
-	mm_ops->put_page(ptep);
+	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
 
 	if (need_flush) {
 		stage2_flush_dcache(kvm_pte_follow(pte, mm_ops),
@@ -949,7 +1027,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	kvm_pte_t pte = *ptep;
 
-	if (!kvm_pte_valid(pte))
+	if (!stage2_pte_is_counted(pte))
 		return 0;
 
 	mm_ops->put_page(ptep);
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
