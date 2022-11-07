Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227A5C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 21:57:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D112B4B847;
	Mon,  7 Nov 2022 16:57:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BE8Pqg55JyWS; Mon,  7 Nov 2022 16:57:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E6D54B864;
	Mon,  7 Nov 2022 16:57:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11B0D4B864
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:57:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RdVKIf4j4wmS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 16:57:49 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7720C4B89F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:57:48 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667858267;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=rWJndB7fu413z11rk+TC01dagV6yYCYGaFaZ/RQHeOw=;
 b=PnJbg1tdeqJq26LWa8IGY/R+NIbq4Zm7jpJOYKix+7jcH4gEPaB9NUDPGTE9nDUiWh7m9w
 a382Hw6/jQ99nVPLxDNxenWEMHBVbl9g588tN5xZktovXDnyg4Rjb7F7yk+5BbFq7xfcav
 /wcFwS2SdyBeMnKFbiN5mQj2Xc6Q8HA=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 06/14] KVM: arm64: Use an opaque type for pteps
Date: Mon,  7 Nov 2022 21:56:36 +0000
Message-Id: <20221107215644.1895162-7-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-1-oliver.upton@linux.dev>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Use an opaque type for pteps and require visitors explicitly dereference
the pointer before using. Protecting page table memory with RCU requires
that KVM dereferences RCU-annotated pointers before using. However, RCU
is not available for use in the nVHE hypervisor and the opaque type can
be conditionally annotated with RCU for the stage-2 MMU.

Call the type a 'pteref' to avoid a naming collision with raw pteps. No
functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  9 ++++++++-
 arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++-------------
 arch/arm64/kvm/mmu.c                 |  2 +-
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 93b1feeaebab..cbd2851eefc1 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -37,6 +37,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
 
 typedef u64 kvm_pte_t;
 
+typedef kvm_pte_t *kvm_pteref_t;
+
+static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
+{
+	return pteref;
+}
+
 #define KVM_PTE_VALID			BIT(0)
 
 #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
@@ -175,7 +182,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
 struct kvm_pgtable {
 	u32					ia_bits;
 	u32					start_level;
-	kvm_pte_t				*pgd;
+	kvm_pteref_t				pgd;
 	struct kvm_pgtable_mm_ops		*mm_ops;
 
 	/* Stage-2 only */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 363a5cce7e1a..7511494537e5 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -175,13 +175,14 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
-			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level);
+			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level);
 
 static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 				      struct kvm_pgtable_mm_ops *mm_ops,
-				      kvm_pte_t *ptep, u32 level)
+				      kvm_pteref_t pteref, u32 level)
 {
 	enum kvm_pgtable_walk_flags flags = data->walker->flags;
+	kvm_pte_t *ptep = kvm_dereference_pteref(pteref, false);
 	struct kvm_pgtable_visit_ctx ctx = {
 		.ptep	= ptep,
 		.old	= READ_ONCE(*ptep),
@@ -193,7 +194,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		.flags	= flags,
 	};
 	int ret = 0;
-	kvm_pte_t *childp;
+	kvm_pteref_t childp;
 	bool table = kvm_pte_table(ctx.old, level);
 
 	if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE))
@@ -214,7 +215,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		goto out;
 	}
 
-	childp = kvm_pte_follow(ctx.old, mm_ops);
+	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
 	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
 	if (ret)
 		goto out;
@@ -227,7 +228,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
-			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level)
+			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level)
 {
 	u32 idx;
 	int ret = 0;
@@ -236,12 +237,12 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 		return -EINVAL;
 
 	for (idx = kvm_pgtable_idx(data, level); idx < PTRS_PER_PTE; ++idx) {
-		kvm_pte_t *ptep = &pgtable[idx];
+		kvm_pteref_t pteref = &pgtable[idx];
 
 		if (data->addr >= data->end)
 			break;
 
-		ret = __kvm_pgtable_visit(data, mm_ops, ptep, level);
+		ret = __kvm_pgtable_visit(data, mm_ops, pteref, level);
 		if (ret)
 			break;
 	}
@@ -262,9 +263,9 @@ static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_da
 		return -EINVAL;
 
 	for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
-		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
+		kvm_pteref_t pteref = &pgt->pgd[idx * PTRS_PER_PTE];
 
-		ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
+		ret = __kvm_pgtable_walk(data, pgt->mm_ops, pteref, pgt->start_level);
 		if (ret)
 			break;
 	}
@@ -507,7 +508,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 {
 	u64 levels = ARM64_HW_PGTABLE_LEVELS(va_bits);
 
-	pgt->pgd = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
+	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_page(NULL);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
@@ -544,7 +545,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-	pgt->mm_ops->put_page(pgt->pgd);
+	pgt->mm_ops->put_page(kvm_dereference_pteref(pgt->pgd, false));
 	pgt->pgd = NULL;
 }
 
@@ -1157,7 +1158,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
 
 	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
-	pgt->pgd = mm_ops->zalloc_pages_exact(pgd_sz);
+	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
@@ -1200,7 +1201,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
 	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
-	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
+	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(pgt->pgd, false), pgd_sz);
 	pgt->pgd = NULL;
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 60ee3d9f01f8..5e197ae190ef 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -640,7 +640,7 @@ static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
 static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 {
 	struct kvm_pgtable pgt = {
-		.pgd		= (kvm_pte_t *)kvm->mm->pgd,
+		.pgd		= (kvm_pteref_t)kvm->mm->pgd,
 		.ia_bits	= VA_BITS,
 		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
 				   CONFIG_PGTABLE_LEVELS),
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
