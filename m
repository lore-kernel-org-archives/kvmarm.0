Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27E6C433E2
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:24:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5714621741
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:24:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0aG6TaU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5714621741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08ED84B503;
	Mon,  7 Sep 2020 11:24:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TxGZcYgduldr; Mon,  7 Sep 2020 11:24:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D686A4B4BA;
	Mon,  7 Sep 2020 11:24:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2373B4B3DD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:24:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IS-+F2+tUF1E for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 11:24:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 041E74B511
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:24:27 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 545622177B;
 Mon,  7 Sep 2020 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599492266;
 bh=RKm9OuhrWYr5xuNO6ms7pJL8Du4vu3z6DexqeH0OaS4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=h0aG6TaUPgtOHx/1nMZ3HY3aSQrAeOPDgshkXjppWKLCR00DVXYQe6NYA4bnZ1kmj
 ppS+usZhWMO96bTmOMydr21dkDtDXSSmbcLCqUKuE0Jtm3Rsw+7iFZ79FGH1/ROuOD
 Jt6LwuHL2bzmaGSf05rfJ6QImVd/d44FGlVEEysM=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 14/21] KVM: arm64: Add support for stage-2 cache flushing
 in generic page-table
Date: Mon,  7 Sep 2020 16:23:37 +0100
Message-Id: <20200907152344.12978-15-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200907152344.12978-1-will@kernel.org>
References: <20200907152344.12978-1-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

Add support for cache flushing a range of the stage-2 address space to
the generic page-table code.

Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 12 ++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 26 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index e9491c91bd06..a776bcf74316 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -228,6 +228,18 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
  */
 bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
 
+/**
+ * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
+ * 				      of Coherency for guest stage-2 address
+ *				      range.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address from which to flush.
+ * @size:	Size of the range.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index fee282f8690d..ad18ce469041 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -782,6 +782,32 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
 	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
 }
 
+static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			       enum kvm_pgtable_walk_flags flag,
+			       void * const arg)
+{
+	kvm_pte_t pte = *ptep;
+
+	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pte))
+		return 0;
+
+	stage2_flush_dcache(kvm_pte_follow(pte), kvm_granule_size(level));
+	return 0;
+}
+
+int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_flush_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		return 0;
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
+}
+
 int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
 {
 	size_t pgd_sz;
-- 
2.28.0.526.ge36021eeef-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
