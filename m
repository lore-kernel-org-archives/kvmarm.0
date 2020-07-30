Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32131C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC1BC22B42
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KB0czXdG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC1BC22B42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E7E4B4F7;
	Thu, 30 Jul 2020 11:34:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EliJui+mGz1k; Thu, 30 Jul 2020 11:34:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF594B51E;
	Thu, 30 Jul 2020 11:34:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B0BE4B439
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5YJS8gP2Uv98 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:34:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88A444B4C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:50 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 40B7622B42;
 Thu, 30 Jul 2020 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596123289;
 bh=fZtxzvhOzdyXaAUD31LH6x+TDWxF0GaTJ2KbdQyLKbc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=KB0czXdGBCexDuzVnPtg7/mCh6h7aT9IeEMov8rj1dzi1Aa1k9Vque37CLij0zfos
 Kviy0vEeOQ2NUB5ZXKS0T/3ii4xtTFu1sK0HXpsiGExu2JVMerhtZYg/s+4bFMqRJx
 1ZOVzqOKORIMkvdUV7eDFX1oWcrcLmMUkWfCD9hQ=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 15/20] KVM: arm64: Add support for relaxing stage-2 perms in
 generic page-table code
Date: Thu, 30 Jul 2020 16:34:01 +0100
Message-Id: <20200730153406.25136-16-will@kernel.org>
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

Add support for relaxing the permissions of a stage-2 mapping (i.e.
adding additional permissions) to the generic page-table code.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 17 +++++++++++++++++
 arch/arm64/kvm/pgtable.c             | 20 ++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index e4d99556a22f..36f0e9e88acd 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -198,6 +198,23 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(void *cookie, u64 addr);
  */
 kvm_pte_t kvm_pgtable_stage2_mkold(void *cookie, u64 addr);
 
+/**
+ * kvm_pgtable_stage2_relax_perms() - Relax the permissions enforced by a
+ *				      page-table entry.
+ * @cookie:	Opaque cookie allocated by kvm_pgtable_stage2_alloc_cookie().
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
+int kvm_pgtable_stage2_relax_perms(void *cookie, u64 addr,
+				   enum kvm_pgtable_prot prot);
+
 /**
  * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
  *				   access flag set.
diff --git a/arch/arm64/kvm/pgtable.c b/arch/arm64/kvm/pgtable.c
index eb41f162a36a..14d8a1b2c4c1 100644
--- a/arch/arm64/kvm/pgtable.c
+++ b/arch/arm64/kvm/pgtable.c
@@ -800,6 +800,26 @@ bool kvm_pgtable_stage2_is_young(void *cookie, u64 addr)
 	return !!(pte & KVM_PTE_LEAF_ATTR_LO_S2_AF);
 }
 
+int kvm_pgtable_stage2_relax_perms(void *cookie, u64 addr,
+				   enum kvm_pgtable_prot prot)
+{
+	int ret;
+	struct kvm_pgtable *pgt = cookie;
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
+	ret = stage2_update_leaf_attrs(cookie, addr, 1, set, clr, NULL);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, 0);
+	return ret;
+}
 
 static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
