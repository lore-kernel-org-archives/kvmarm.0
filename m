Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06CEC2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:35:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7895C2466D
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvtp4Ghn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7895C2466D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 260BF4B1E5;
	Mon, 26 Oct 2020 09:35:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NYr15PJJFRhI; Mon, 26 Oct 2020 09:35:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7293D4B49A;
	Mon, 26 Oct 2020 09:35:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF954B172
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:35:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O6Kqkc+AXSZE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 09:35:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 154FD4B4E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:35:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1BA8124641;
 Mon, 26 Oct 2020 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603719305;
 bh=728XYeIVEe91tr8jUABFBLzP2IHWs5kpZFIXWOsVUaE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=uvtp4GhnalvfJq8ktJ4Cr1h1RPF1l3SOH60kTwFmHjmnHmAyujJ0Ixw1McgG3vB4o
 f3IBK3c7wC8i1FN9sxE26VIuFrSbTMHNGVxLwWZrsow/iG9LCdktjcnV8aISBTvjSR
 U8uuupYw9p46zsArpR+sF7UXX0267PssLJxFSY9Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kX2eN-004Kjh-F0; Mon, 26 Oct 2020 13:35:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 04/11] KVM: arm64: Move PC rollback on SError to HYP
Date: Mon, 26 Oct 2020 13:34:43 +0000
Message-Id: <20201026133450.73304-5-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026133450.73304-1-maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, qperret@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

Instead of handling the "PC rollback on SError during HVC" at EL1 (which
requires disclosing PC to a potentially untrusted kernel), let's move
this fixup to ... fixup_guest_exit(), which is where we do all fixups.

Isn't that neat?

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c            | 17 -----------------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d4e00a864ee6..f79137ee4274 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -241,23 +241,6 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 {
 	struct kvm_run *run = vcpu->run;
 
-	if (ARM_SERROR_PENDING(exception_index)) {
-		u8 esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
-
-		/*
-		 * HVC already have an adjusted PC, which we need to
-		 * correct in order to return to after having injected
-		 * the SError.
-		 *
-		 * SMC, on the other hand, is *trapped*, meaning its
-		 * preferred return address is the SMC itself.
-		 */
-		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
-			*vcpu_pc(vcpu) -= 4;
-
-		return 1;
-	}
-
 	exception_index = ARM_EXCEPTION_CODE(exception_index);
 
 	switch (exception_index) {
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d687e574cde5..668f02c7b0b3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -411,6 +411,21 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
+	if (ARM_SERROR_PENDING(*exit_code)) {
+		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
+
+		/*
+		 * HVC already have an adjusted PC, which we need to
+		 * correct in order to return to after having injected
+		 * the SError.
+		 *
+		 * SMC, on the other hand, is *trapped*, meaning its
+		 * preferred return address is the SMC itself.
+		 */
+		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
+			*vcpu_pc(vcpu) -= 4;
+	}
+
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
