Return-Path: <SRS0=snoh=CD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E045FC433DF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95A0520782
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0dKwW74"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95A0520782
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F1DD4C07D;
	Tue, 25 Aug 2020 05:40:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D-Zg6ie0YjQv; Tue, 25 Aug 2020 05:40:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 078EA4C07C;
	Tue, 25 Aug 2020 05:40:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5EE4C06B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xtr8rMc12d8A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Aug 2020 05:40:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF3B14C05A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:24 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8F28D2078A;
 Tue, 25 Aug 2020 09:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1598348424;
 bh=KvBiAONZnae6Je3KxPVZerswPK1Rl7iHLEi8rmQAhd4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=K0dKwW74gKnd9VzwW+h5gqilnQXFulE/gq+5ZojW0HmKfxkup2j9eQFJQOmdfH+or
 wRkAXOftYZAmQfy5ox8Nr432mE1mw1oerzPf8pT8u6eKgyHk73kv8ustJ1gJr7BUDZ
 2TUJiS6p+qUzgf5rCB16KflQTIVJmbGveP6+uu4A=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 10/21] KVM: arm64: Add support for stage-2 page-aging in
 generic page-table
Date: Tue, 25 Aug 2020 10:39:42 +0100
Message-Id: <20200825093953.26493-11-will@kernel.org>
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

Add stage-2 mkyoung(), mkold() and is_young() operations to the generic
page-table code.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 38 ++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 86 ++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 8ab0d5f43817..ae56534f87a0 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -173,6 +173,44 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
  */
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
+/**
+ * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address to identify the page-table entry.
+ *
+ * If there is a valid, leaf page-table entry used to translate @addr, then
+ * set the access flag in that entry.
+ *
+ * Return: The old page-table entry prior to setting the flag, 0 on failure.
+ */
+kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
+
+/**
+ * kvm_pgtable_stage2_mkold() - Clear the access flag in a page-table entry.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address to identify the page-table entry.
+ *
+ * If there is a valid, leaf page-table entry used to translate @addr, then
+ * clear the access flag in that entry.
+ *
+ * Note that it is the caller's responsibility to invalidate the TLB after
+ * calling this function to ensure that the updated permissions are visible
+ * to the CPUs.
+ *
+ * Return: The old page-table entry prior to clearing the flag, 0 on failure.
+ */
+kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
+
+/**
+ * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
+ *				   access flag set.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address to identify the page-table entry.
+ *
+ * Return: True if the page-table entry has the access flag set, false otherwise.
+ */
+bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 6f65d3841ec9..30713eb773e0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -670,6 +670,92 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
+struct stage2_attr_data {
+	kvm_pte_t	attr_set;
+	kvm_pte_t	attr_clr;
+	kvm_pte_t	pte;
+};
+
+static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			      enum kvm_pgtable_walk_flags flag,
+			      void * const arg)
+{
+	kvm_pte_t pte = *ptep;
+	struct stage2_attr_data *data = arg;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	data->pte = pte;
+	pte &= ~data->attr_clr;
+	pte |= data->attr_set;
+
+	/*
+	 * We may race with the CPU trying to set the access flag here,
+	 * but worst-case the access flag update gets lost and will be
+	 * set on the next access instead.
+	 */
+	if (data->pte != pte)
+		WRITE_ONCE(*ptep, pte);
+
+	return 0;
+}
+
+static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
+				    u64 size, kvm_pte_t attr_set,
+				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte)
+{
+	int ret;
+	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
+	struct stage2_attr_data data = {
+		.attr_set	= attr_set & attr_mask,
+		.attr_clr	= attr_clr & attr_mask,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= stage2_attr_walker,
+		.arg		= &data,
+		.flags		= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	if (ret)
+		return ret;
+
+	if (orig_pte)
+		*orig_pte = data.pte;
+	return 0;
+}
+
+kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
+{
+	kvm_pte_t pte = 0;
+	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
+				 &pte);
+	dsb(ishst);
+	return pte;
+}
+
+kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
+{
+	kvm_pte_t pte = 0;
+	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
+				 &pte);
+	/*
+	 * "But where's the TLBI?!", you scream.
+	 * "Over in the core code", I sigh.
+	 *
+	 * See the '->clear_flush_young()' callback on the KVM mmu notifier.
+	 */
+	return pte;
+}
+
+bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
+{
+	kvm_pte_t pte = 0;
+	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte);
+	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
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
