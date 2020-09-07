Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182D3C2BB84
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:24:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD6AF21741
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vjboIDk/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD6AF21741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63F884B0CF;
	Mon,  7 Sep 2020 11:24:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zkKxBem+T49O; Mon,  7 Sep 2020 11:24:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25D124B519;
	Mon,  7 Sep 2020 11:24:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF7D74B4C9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:24:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0RAjqnzrntVw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 11:24:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE0024B512
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:24:31 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F075D2176B;
 Mon,  7 Sep 2020 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599492270;
 bh=CxTEBTNhsGYyFwV6lKSaP4zPrJN1nddWkXg7YQXAl4Y=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=vjboIDk/FE6yxV3qawGitfi2USNYJyUMZa2EDasKtQXfn9qeYEev9nKNNsz2hsepm
 ybgFsnCEVdG8W0mYnYSwCwV0qHL5olROzl2tavoC52VuFCX4PIFziPbhyr6lKrRVSG
 Ie/vXuieu7/le5H7B+rou3vckAXoHYxfFDyAZefs=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 16/21] KVM: arm64: Add support for relaxing stage-2 perms
 in generic page-table code
Date: Mon,  7 Sep 2020 16:23:39 +0100
Message-Id: <20200907152344.12978-17-will@kernel.org>
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

Add support for relaxing the permissions of a stage-2 mapping (i.e.
adding additional permissions) to the generic page-table code.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 17 +++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index a776bcf74316..5ab4f852a463 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -218,6 +218,23 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
  */
 kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
 
+/**
+ * kvm_pgtable_stage2_relax_perms() - Relax the permissions enforced by a
+ *				      page-table entry.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	Intermediate physical address to identify the page-table entry.
+ * @prot:	Additional permissions to grant for the mapping.
+ *
+ * If there is a valid, leaf page-table entry used to translate @addr, then
+ * relax the permissions in that entry according to the read, write and
+ * execute permissions specified by @prot. No permissions are removed, and
+ * TLB invalidation is performed after updating the entry.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
+				   enum kvm_pgtable_prot prot);
+
 /**
  * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
  *				   access flag set.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index ad18ce469041..df705533dc3f 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -782,6 +782,26 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
 	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
 }
 
+int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
+				   enum kvm_pgtable_prot prot)
+{
+	int ret;
+	kvm_pte_t set = 0, clr = 0;
+
+	if (prot & KVM_PGTABLE_PROT_R)
+		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
+
+	if (prot & KVM_PGTABLE_PROT_W)
+		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+
+	if (prot & KVM_PGTABLE_PROT_X)
+		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
+
+	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, 0);
+	return ret;
+}
+
 static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
-- 
2.28.0.526.ge36021eeef-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
