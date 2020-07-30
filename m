Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A55CC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4A0722B42
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xVE1R4My"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4A0722B42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CEB74B506;
	Thu, 30 Jul 2020 11:34:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YjgNSTPIIO9f; Thu, 30 Jul 2020 11:34:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCF8D4B4F9;
	Thu, 30 Jul 2020 11:34:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FB9D4B480
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4PZowY3NVftp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:34:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F56E4B500
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:42 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 59BFE2082E;
 Thu, 30 Jul 2020 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596123281;
 bh=DwM1hbt8coZsE1uiYZtal06l3PSCMfgsmt7mKWgFqcM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=xVE1R4MySAp3LOSsLwMf7Z079vN/+vhDDYEu6N7/kSgwB39+Gn/NOcqsWYUN/aEjZ
 Bo3PEGSa0biyj3rN/bkCziHjkISEbQR8jZEcMBZs/qcBRos/Gsy2DQdSLWu5BgmXet
 yhuKAwUO3GSa2LLVepeLNM6qKMdlfXn6zSAga23I=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 11/20] KVM: arm64: Add support for stage-2 write-protect in
 generic page-table
Date: Thu, 30 Jul 2020 16:33:57 +0100
Message-Id: <20200730153406.25136-12-will@kernel.org>
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

Add a stage-2 wrprotect() operation to the generic page-table code.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 15 +++++++++++++++
 arch/arm64/kvm/pgtable.c             |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 7bc55e874a90..ce90432ec6b9 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -155,6 +155,21 @@ int kvm_pgtable_stage2_map(void *cookie, u64 addr, u64 size, u64 phys,
  */
 int kvm_pgtable_stage2_unmap(void *cookie, u64 addr, u64 size);
 
+/**
+ * kvm_pgtable_stage2_wrprotect() - Write-protect guest stage-2 address range
+ *                                  without TLB invalidation.
+ * @cookie:	Opaque cookie allocated by kvm_pgtable_stage2_alloc_cookie().
+ * @addr:	Intermediate physical address from which to write-protect,
+ * @size:	Size of the range.
+ *
+ * Note that it is the caller's responsibility to invalidate the TLB after
+ * calling this function to ensure that the updated permissions are visible
+ * to the CPUs.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_wrprotect(void *cookie, u64 addr, u64 size);
+
 /**
  * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
  * @cookie:	Opaque cookie allocated by kvm_pgtable_stage2_alloc_cookie().
diff --git a/arch/arm64/kvm/pgtable.c b/arch/arm64/kvm/pgtable.c
index af15282d3df9..52cb3d5f156e 100644
--- a/arch/arm64/kvm/pgtable.c
+++ b/arch/arm64/kvm/pgtable.c
@@ -764,6 +764,12 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 	return 0;
 }
 
+int kvm_pgtable_stage2_wrprotect(void *cookie, u64 addr, u64 size)
+{
+	return stage2_update_leaf_attrs(cookie, addr, size, 0,
+					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W, NULL);
+}
+
 kvm_pte_t kvm_pgtable_stage2_mkyoung(void *cookie, u64 addr)
 {
 	kvm_pte_t pte = 0;
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
