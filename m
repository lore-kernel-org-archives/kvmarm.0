Return-Path: <SRS0=/ewP=63=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBC6C2D0FA
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 12:15:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9125B206D6
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 12:15:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7AbQPKg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9125B206D6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26D9E4B2E4;
	Wed, 13 May 2020 08:15:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MUQDFSRxIyHW; Wed, 13 May 2020 08:15:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 158B64B2E3;
	Wed, 13 May 2020 08:15:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74D234B2E3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 08:15:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id upVs7xlxCu5e for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 May 2020 08:15:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2EEF54B2E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 08:15:44 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 06B57206D6;
 Wed, 13 May 2020 12:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1589372143;
 bh=OFXMCfgg4QqvOju+IW8sguzu0zPnRXnwQP6ptWcD06o=;
 h=From:To:Cc:Subject:Date:From;
 b=V7AbQPKgWJK6PakqeqU1LoITqszt4ASQ0z0pTXUY0NNsOaMoL9t0daWUpgx4oLM0Y
 2ht5Hbpe+SAGdYjs1pamcS00ro46OAHdHHR0JUoJe1EmRtvmlrhAYJYvBroFwq2sIl
 c2rj3Urk/Mqqdmgzmt2UAuD0Kjsmsplvns3EUbJM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jYqIX-00BxoR-Df; Wed, 13 May 2020 13:15:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: Simplify __kvm_timer_set_cntvoff implementation
Date: Wed, 13 May 2020 13:15:37 +0100
Message-Id: <20200513121537.77546-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

Now that this function isn't constrained by the 32bit PCS,
let's simplify it by taking a single 64bit offset instead
of two 32bit parameters.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  2 +-
 virt/kvm/arm/arch_timer.c        | 12 +-----------
 virt/kvm/arm/hyp/timer-sr.c      |  3 +--
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 7c7eeeaab9fa..59e314f38e43 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -64,7 +64,7 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
 
-extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
+extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
 extern int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 93bd59b46848..487eba9f87cd 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -451,17 +451,7 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 
 static void set_cntvoff(u64 cntvoff)
 {
-	u32 low = lower_32_bits(cntvoff);
-	u32 high = upper_32_bits(cntvoff);
-
-	/*
-	 * Since kvm_call_hyp doesn't fully support the ARM PCS especially on
-	 * 32-bit systems, but rather passes register by register shifted one
-	 * place (we put the function address in r0/x0), we cannot simply pass
-	 * a 64-bit value as an argument, but have to split the value in two
-	 * 32-bit halves.
-	 */
-	kvm_call_hyp(__kvm_timer_set_cntvoff, low, high);
+	kvm_call_hyp(__kvm_timer_set_cntvoff, cntvoff);
 }
 
 static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, bool active)
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index ff76e6845fe4..fb5c0be33223 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -10,9 +10,8 @@
 
 #include <asm/kvm_hyp.h>
 
-void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
+void __hyp_text __kvm_timer_set_cntvoff(u64 cntvoff)
 {
-	u64 cntvoff = (u64)cntvoff_high << 32 | cntvoff_low;
 	write_sysreg(cntvoff, cntvoff_el2);
 }
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
