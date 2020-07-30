Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCECC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0702D20838
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="G34fQb9M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0702D20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B483F4B163;
	Thu, 30 Jul 2020 11:34:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MnpGOMDl+bhp; Thu, 30 Jul 2020 11:34:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B55D4B439;
	Thu, 30 Jul 2020 11:34:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A3254B439
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7wTNknHEuDN5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:34:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 835D64B4F9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:46 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4D67321744;
 Thu, 30 Jul 2020 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596123285;
 bh=V1jkCubi7Ut94f6j9LP6M7guvABec4chryFC2WkIMxs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=G34fQb9M9uNxCcMxvrSExeGPtQaY93ZqaiEKbw6bpwTksjT7zphX3IYq5ALEQsTMu
 7wgzYMJpIFt6jqEs8cfBeZXfZEB8pWWdoODXe3RTiXuor6Tj/8/a8KrxBjDgGtWjuZ
 AWjvcIJ11x0dfOPwg4r90fA7Id6nvz8XyLoAVadE=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 13/20] KVM: arm64: Add support for stage-2 cache flushing in
 generic page-table
Date: Thu, 30 Jul 2020 16:33:59 +0100
Message-Id: <20200730153406.25136-14-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

Add support for cache flushing a range of the stage-2 address space to
the generic page-table code.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 12 ++++++++++++
 arch/arm64/kvm/pgtable.c             | 27 +++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index ce90432ec6b9..e4d99556a22f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -208,6 +208,18 @@ kvm_pte_t kvm_pgtable_stage2_mkold(void *cookie, u64 addr);
  */
 bool kvm_pgtable_stage2_is_young(void *cookie, u64 addr);
 
+/**
+ * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
+ * 				      of Coherency for guest stage-2 address
+ *				      range.
+ * @cookie:	Opaque cookie allocated by kvm_pgtable_stage2_alloc_cookie().
+ * @addr:	Intermediate physical address from which to flush.
+ * @size:	Size of the range.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_flush(void *cookie, u64 addr, u64 size);
+
 /**
  * kvm_pgtable_get_pgd_phys() - Get physical pgd pointer for a page-table.
  * @cookie:	Opaque cookie allocated by kvm_pgtable_*_alloc_cookie().
diff --git a/arch/arm64/kvm/pgtable.c b/arch/arm64/kvm/pgtable.c
index 52cb3d5f156e..eb41f162a36a 100644
--- a/arch/arm64/kvm/pgtable.c
+++ b/arch/arm64/kvm/pgtable.c
@@ -800,6 +800,33 @@ bool kvm_pgtable_stage2_is_young(void *cookie, u64 addr)
 	return !!(pte & KVM_PTE_LEAF_ATTR_LO_S2_AF);
 }
 
+
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
+int kvm_pgtable_stage2_flush(void *cookie, u64 addr, u64 size)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_flush_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		return 0;
+
+	return kvm_pgtable_walk(cookie, addr, size, &walker);
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
