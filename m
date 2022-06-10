Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDB3C43334
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 09:35:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEB814B08B;
	Fri, 10 Jun 2022 05:35:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SXilHIK3OYp7; Fri, 10 Jun 2022 05:35:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B42564B0D9;
	Fri, 10 Jun 2022 05:35:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5BA24045D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id he7y7dY1-Cff for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 05:35:52 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EA884B390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:51 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0B05B61ED8;
 Fri, 10 Jun 2022 09:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656D9C34114;
 Fri, 10 Jun 2022 09:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654853750;
 bh=Y9Re+PzleYqLYTAnywwGvif4ouH1rfjI6sgzNtrNb3g=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=a4VfKo1ImapFmBgu6AE+w1VGwXx4h0mE2f5JJkcZ3XZ/2K+ev/zMnhAvfSBPCEBdt
 MtkxlyRCj/PQ0BttsusOfEsUE8VyC0xVutxiOyZOa3JUAk1EP739j0oeWhsuXgWirP
 ojIlpsxWSbuTFCRjrPzm/XvhM3IMI0Xq/wlo/51yyYlD+wFtPI+TqemA0uFdT96QFS
 Id2V0b+oj8IrYaYA6gEqse6TbA+fKocI5ahWc7edEpeSL6ncH95+mG3mNysJB0n60M
 yCmO1AnIlHnwi+GuFli6CQVQmNU4r+q0DJtW1VGaXDxD3wBs+ohACCjlqA1PI6/V33
 7zIaPLw/zvrIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzaws-00H6Dt-EW; Fri, 10 Jun 2022 10:28:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 19/19] KVM: arm64: Move the handling of !FP outside of the
 fast path
Date: Fri, 10 Jun 2022 10:28:38 +0100
Message-Id: <20220610092838.1205755-20-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 reijiw@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
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

We currently start by assuming that the host owns the FP unit
at load time, then check again whether this is the case as
we are about to run. Only at this point do we account for the
fact that there is a (vanishingly small) chance that we're running
on a system without a FPSIMD unit (yes, this is madness).

We can actually move this FPSIMD check as early as load-time,
and drop the check at run time.

No intended change in behaviour.

Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c    | 6 ++++++
 arch/arm64/kvm/fpsimd.c | 8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b9da9d30485..a9dd7ec38f38 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -328,6 +328,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
+	/*
+	 * Default value for the FP state, will be overloaded at load
+	 * time if we support FP (pretty likely)
+	 */
+	vcpu->arch.fp_state = FP_STATE_FREE;
+
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 557a96f8e06a..ec8e4494873d 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -77,6 +77,9 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	BUG_ON(!current->mm);
 	BUG_ON(test_thread_flag(TIF_SVE));
 
+	if (!system_supports_fpsimd())
+		return;
+
 	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
@@ -110,13 +113,10 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
  * FP while we were preemptible (such as off the back of an interrupt),
  * then neither the host nor the guest own the FP hardware (and it was the
  * responsibility of the code that used FP to save the existing state).
- *
- * Note that not supporting FP is basically the same thing as far as the
- * hypervisor is concerned (nothing to save).
  */
 void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
 {
-	if (!system_supports_fpsimd() || test_thread_flag(TIF_FOREIGN_FPSTATE))
+	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
 		vcpu->arch.fp_state = FP_STATE_FREE;
 }
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
