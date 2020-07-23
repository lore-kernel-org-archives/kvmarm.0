Return-Path: <SRS0=bqG1=BC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC5DC433E8
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 11:02:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C554F20888
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 11:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pYh+m6c2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C554F20888
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5904B31E;
	Thu, 23 Jul 2020 07:02:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a+k8qBJSrJTf; Thu, 23 Jul 2020 07:02:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8244B32D;
	Thu, 23 Jul 2020 07:02:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 826F54B2FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 07:02:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MfhwrtKpfdcl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jul 2020 07:02:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EF214B2E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 07:02:47 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6D68922B43;
 Thu, 23 Jul 2020 11:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595502166;
 bh=RGohuwH1Kr4sI6kOzVad8F1yLFTUAZVX36aipG0twzA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=pYh+m6c2MqBsL80u/3tab/oeksJl05188xJ8l+bDXgogc5nS1A9rRCTUHSNmtF8G/
 JYBshQBxqPsoama7Z12LDN/WVplZBpsP8hZQOVMiQ7+ZbST3A7QIz13gfupYaeIfXj
 G4uPg8sdPgN6Z2qYlz8pXyPc31DTBUn2j07y2fBg=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/3] KVM: arm64: Don't free memcache pages in
 kvm_phys_addr_ioremap()
Date: Thu, 23 Jul 2020 12:02:25 +0100
Message-Id: <20200723110227.16001-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200723110227.16001-1-will@kernel.org>
References: <20200723110227.16001-1-will@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, maz@kernel.org, kernel-team@android.com,
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

kvm_phys_addr_ioremap() unconditionally empties out the memcache pages
for the current vCPU on return. This causes subsequent topups to allocate
fresh pages and is at odds with the behaviour when mapping memory in
user_mem_abort().

Remove the call to mmu_free_memory_cache() from kvm_phys_addr_ioremap(),
allowing the cached pages to be used by a later mapping.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 31058e6e7c2a..9102373a9744 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1484,19 +1484,17 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 					     kvm_mmu_cache_min_pages(kvm),
 					     KVM_NR_MEM_OBJS);
 		if (ret)
-			goto out;
+			break;
 		spin_lock(&kvm->mmu_lock);
 		ret = stage2_set_pte(kvm, &cache, addr, &pte,
 						KVM_S2PTE_FLAG_IS_IOMAP);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
-			goto out;
+			break;
 
 		pfn++;
 	}
 
-out:
-	mmu_free_memory_cache(&cache);
 	return ret;
 }
 
-- 
2.28.0.rc0.105.gf9edc3c819-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
