Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F5CC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2799820838
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="I19mpg89"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2799820838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4A104B4C6;
	Thu, 30 Jul 2020 11:34:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZPvdABW3Xf8c; Thu, 30 Jul 2020 11:34:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD3934B4CE;
	Thu, 30 Jul 2020 11:34:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE2A94B4CE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kYgXpqBp83ql for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:34:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B50894B163
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:38 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6539622B42;
 Thu, 30 Jul 2020 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596123278;
 bh=2GM58Wm9g1idig7X+ffyadAqjzM52YvyGT/Th3S3rB8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=I19mpg89CK8qe6RmLIBapp9fFu0i8o28+4BJhQfC1vUtMZI6ZD96tuexXPIvqeuXM
 vQYEU+cQ/NA31t5liBvLCjeNuTZx2SBl7KGlkYQqSedTMX/AugyBhnjMWVy4NmLuwB
 IC78DORQM5tq9u63itjkBsTO3ikLd8WUEFjty9oc=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 09/20] KVM: arm64: Add support for stage-2 page-aging in
 generic page-table
Date: Thu, 30 Jul 2020 16:33:55 +0100
Message-Id: <20200730153406.25136-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200730153406.25136-1-will@kernel.org>
References: <20200730153406.25136-1-will@kernel.org>
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
 arch/arm64/include/asm/kvm_pgtable.h | 38 +++++++++++++
 arch/arm64/kvm/pgtable.c             | 85 ++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 3e0f7df89fef..7bc55e874a90 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -155,6 +155,44 @@ int kvm_pgtable_stage2_map(void *cookie, u64 addr, u64 size, u64 phys,
  */
 int kvm_pgtable_stage2_unmap(void *cookie, u64 addr, u64 size);
 
+/**
+ * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
+ * @cookie:	Opaque cookie allocated by kvm_pgtable_stage2_alloc_cookie().
+ * @addr:	Intermediate physical address to identify the page-table entry.
+ *
+ * If there is a valid, leaf page-table entry used to translate @addr, then
+ * set the access flag in that entry.
+ *
+ * Return: The old page-table entry prior to setting the flag, 0 on failure.
+ */
+kvm_pte_t kvm_pgtable_stage2_mkyoung(void *cookie, u64 addr);
+
+/**
+ * kvm_pgtable_stage2_mkold() - Clear the access flag in a page-table entry.
+ * @cookie:	Opaque cookie allocated by kvm_pgtable_stage2_alloc_cookie().
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
+kvm_pte_t kvm_pgtable_stage2_mkold(void *cookie, u64 addr);
+
+/**
+ * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
+ *				   access flag set.
+ * @cookie:	Opaque cookie allocated by kvm_pgtable_stage2_alloc_cookie().
+ * @addr:	Intermediate physical address to identify the page-table entry.
+ *
+ * Return: True if the page-table entry has the access flag set, false otherwise.
+ */
+bool kvm_pgtable_stage2_is_young(void *cookie, u64 addr);
+
 /**
  * kvm_pgtable_get_pgd_phys() - Get physical pgd pointer for a page-table.
  * @cookie:	Opaque cookie allocated by kvm_pgtable_*_alloc_cookie().
diff --git a/arch/arm64/kvm/pgtable.c b/arch/arm64/kvm/pgtable.c
index 478f1a48ddc3..af15282d3df9 100644
--- a/arch/arm64/kvm/pgtable.c
+++ b/arch/arm64/kvm/pgtable.c
@@ -709,6 +709,91 @@ int kvm_pgtable_stage2_unmap(void *cookie, u64 addr, u64 size)
 
 	return kvm_pgtable_walk(cookie, addr, size, &walker);
 }
+
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
+	WRITE_ONCE(*ptep, pte);
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
+kvm_pte_t kvm_pgtable_stage2_mkyoung(void *cookie, u64 addr)
+{
+	kvm_pte_t pte = 0;
+	stage2_update_leaf_attrs(cookie, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
+				 &pte);
+	dsb(ishst);
+	return pte;
+}
+
+kvm_pte_t kvm_pgtable_stage2_mkold(void *cookie, u64 addr)
+{
+	kvm_pte_t pte = 0;
+	stage2_update_leaf_attrs(cookie, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
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
+bool kvm_pgtable_stage2_is_young(void *cookie, u64 addr)
+{
+	kvm_pte_t pte = 0;
+	stage2_update_leaf_attrs(cookie, addr, 1, 0, 0, &pte);
+	return !!(pte & KVM_PTE_LEAF_ATTR_LO_S2_AF);
+}
+
 void *kvm_pgtable_stage2_alloc_cookie(struct kvm *kvm)
 {
 	size_t pgd_sz;
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
