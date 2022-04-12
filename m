Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E9BC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:13:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 747C44B2A0;
	Tue, 12 Apr 2022 09:13:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VJGejeSICytT; Tue, 12 Apr 2022 09:13:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA5E4B295;
	Tue, 12 Apr 2022 09:13:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13E514B2AB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NXxeCiZ-6Tfo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:13:56 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9A294B25A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1E40F6193E;
 Tue, 12 Apr 2022 13:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C68DC385AF;
 Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649769234;
 bh=WTSGbHSbmfmHWAy9D3aVTWCpO7YVxCypnvPY1Fp2Syo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=arkMe/9XQwq7CcV5FNDZno7iRJmY0WRX3XC+k6KH/Ib56NiuRwmn+RMG8mxKpgdu/
 NsLaoXBe+sHrMVw1kkT/ZRkaqb7Jk5ztYQoP6usQZpOxDPbFEu54ZP0WLvWZdhtF98
 tnBIwWW11mRuBGbjISGwQck5Xv7BP+gFOE0fSisqWcGjfAc0OYHWmuJfiGvhmKpu9x
 3xCHZkJw647YFQXatgN7lA3AM/XiPmY5GPLQa9JHlTuF2aX7iPSzDZA2KV+FE5I1jG
 TfjgvzNsnAiBVCYV9fx1XU70Qwr5jenN3IaOfdXUCwccsaqEZQ4FQbTmhDRUJ0uai7
 pBeTBWfG92E4Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1neGL9-003mvX-R4; Tue, 12 Apr 2022 14:13:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 03/10] KVM: arm64: Simplify kvm_cpu_has_pending_timer()
Date: Tue, 12 Apr 2022 14:12:56 +0100
Message-Id: <20220412131303.504690-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412131303.504690-1-maz@kernel.org>
References: <20220412131303.504690-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

kvm_cpu_has_pending_timer() ends up checking all the possible
timers for a wake-up cause. However, we already check for
pending interrupts whenever we try to wake-up a vcpu, including
the timer interrupts.

Obviously, doing the same work twice is once too many. Reduce
this helper to almost nothing, but keep it around, as we are
going to make use of it soon.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 10 ++--------
 arch/arm64/kvm/arm.c         |  5 -----
 include/kvm/arm_arch_timer.h |  2 --
 3 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6e542e2eae32..16dda1a383a6 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -350,15 +350,9 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 	return cval <= now;
 }
 
-bool kvm_timer_is_pending(struct kvm_vcpu *vcpu)
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	struct timer_map map;
-
-	get_timer_map(vcpu, &map);
-
-	return kvm_timer_should_fire(map.direct_vtimer) ||
-	       kvm_timer_should_fire(map.direct_ptimer) ||
-	       kvm_timer_should_fire(map.emul_ptimer);
+	return 0;
 }
 
 /*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..2122c699af06 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -356,11 +356,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_arm_vcpu_destroy(vcpu);
 }
 
-int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
-{
-	return kvm_timer_is_pending(vcpu);
-}
-
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 51c19381108c..cd6d8f260eab 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -76,8 +76,6 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 
-bool kvm_timer_is_pending(struct kvm_vcpu *vcpu);
-
 u64 kvm_phys_timer_read(void);
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
