Return-Path: <SRS0=bqG1=BC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72310C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 11:02:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B6D620888
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 11:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EgBgnx3P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B6D620888
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C89904B312;
	Thu, 23 Jul 2020 07:02:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X2qLfuRZ52zs; Thu, 23 Jul 2020 07:02:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A5E74B31B;
	Thu, 23 Jul 2020 07:02:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CB084B2F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 07:02:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KXRkV1pafPut for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jul 2020 07:02:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 380324B2E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 07:02:51 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 13B3D22B49;
 Thu, 23 Jul 2020 11:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595502170;
 bh=vnxV2at0yNF7SZXAp8UJrz+ILyMv6iv9WyDBZVhM+hk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EgBgnx3PFT3fTH5HWivi/a8dDjqSJkwSzjr4JntmtV3LyC3MpkLgsUkJ126QZjxXM
 wCJAfUaXoDpqshUQzYTpq99AmFMWM62fNGNpTJv/lt3dqw6RBd2De2gKtPfnc5gzo8
 w9448Y8BzY3vPKOd+kVZN6Zz4TmHXhiL2jlSX5rs=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/3] KVM: arm64: Remove mmu_free_memory_cache()
Date: Thu, 23 Jul 2020 12:02:27 +0100
Message-Id: <20200723110227.16001-4-will@kernel.org>
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

mmu_free_memory_cache() is only called by kvm_mmu_free_memory_caches(),
so inline the implementation and get rid of the extra function.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e55a28178164..df2a8025ec8a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -143,8 +143,10 @@ static int mmu_topup_memory_cache(struct kvm *kvm,
 	return 0;
 }
 
-static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
+	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_page_cache;
+
 	while (mc->nobjs)
 		free_page((unsigned long)mc->objects[--mc->nobjs]);
 }
@@ -2302,11 +2304,6 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 				 kvm_test_age_hva_handler, NULL);
 }
 
-void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
-{
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
-}
-
 phys_addr_t kvm_mmu_get_httbr(void)
 {
 	if (__kvm_cpu_uses_extended_idmap())
-- 
2.28.0.rc0.105.gf9edc3c819-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
