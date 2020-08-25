Return-Path: <SRS0=snoh=CD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2264AC433DF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 975432078A
	for <kvmarm@archiver.kernel.org>; Tue, 25 Aug 2020 09:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IkTe9yD6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 975432078A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CFA84C06F;
	Tue, 25 Aug 2020 05:40:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SkbZRx6GbNs9; Tue, 25 Aug 2020 05:40:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCA484C057;
	Tue, 25 Aug 2020 05:40:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ACF24BE45
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qRxkQNsRy8Va for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Aug 2020 05:40:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 417534BE82
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2020 05:40:05 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D897320706;
 Tue, 25 Aug 2020 09:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1598348404;
 bh=EDeMcvRAUr+HAFxgfQOErnPVmot6600cdhrl5sfJBT8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=IkTe9yD6qc8wuayc4Zu8pWdFUBPnIbKP8xC2gYtcLAJ+E1S5kUj1Df5yzMk2Xh8/a
 pRZClsnXRmSW0HT/EEP87yTtPtooQQRhBdLHIIawJVZgkBADMoAn8RTx7A811Wu0/9
 Kp55ULmbhJ82chZLgSjw3oK6paT+8+MtkKpKt8IE=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 01/21] KVM: arm64: Remove kvm_mmu_free_memory_caches()
Date: Tue, 25 Aug 2020 10:39:33 +0100
Message-Id: <20200825093953.26493-2-will@kernel.org>
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

kvm_mmu_free_memory_caches() is only called by kvm_arch_vcpu_destroy(),
so inline the implementation and get rid of the extra function.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 2 --
 arch/arm64/kvm/arm.c             | 2 +-
 arch/arm64/kvm/mmu.c             | 5 -----
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 189839c3706a..0f078b1920ff 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -141,8 +141,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
-void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
-
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 46dc3d75cf13..262a0afbcc27 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -283,7 +283,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
-	kvm_mmu_free_memory_caches(vcpu);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ba00bcc0c884..935f8f689433 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2324,11 +2324,6 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 				 kvm_test_age_hva_handler, NULL);
 }
 
-void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
-{
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
-}
-
 phys_addr_t kvm_mmu_get_httbr(void)
 {
 	if (__kvm_cpu_uses_extended_idmap())
-- 
2.28.0.297.g1956fa8f8d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
