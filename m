Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62572C55179
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF67620727
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zuDSqvuW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF67620727
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5EC4B572;
	Fri, 30 Oct 2020 12:40:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fj6iWHGNlzI5; Fri, 30 Oct 2020 12:40:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 014464B58A;
	Fri, 30 Oct 2020 12:40:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAFCD4B235
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HlBtcceovOAc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 12:40:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B2914B21B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E4E4520724;
 Fri, 30 Oct 2020 16:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604076025;
 bh=146kMw0dp/xuQdySBVEx7K+SEqVKrXEjw85Z2vaNF6o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=zuDSqvuWyEvS7ReTqUSkBV+8dFmeMhjNtlAUubTcoPCHo7tJNzTNkHVrUZ/Op6q65
 mtUaJ8LywIFrooTFNyhk04NJFVos0/ZtILwTyVsKjcwQIzb1ugnS7O8y8mSkJIgDjG
 G0j4/ZOBQiN4UX63n2kX3b5u1w6WcxPVWKW/vuAI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYXRv-005noK-1z; Fri, 30 Oct 2020 16:40:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 01/12] KVM: arm64: Don't corrupt tpidr_el2 on failed HVC call
Date: Fri, 30 Oct 2020 16:40:06 +0000
Message-Id: <20201030164017.244287-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com,
 james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com,
 qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com,
 will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 Qais Yousef <qais.yousef@arm.com>
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

The hyp-init code starts by stashing a register in TPIDR_EL2
in in order to free a register. This happens no matter if the
HVC call is legal or not.

Although nothing wrong seems to come out of it, it feels odd
to alter the EL2 state for something that eventually returns
an error.

Instead, use the fact that we know exactly which bits of the
__kvm_hyp_init call are non-zero to perform the check with
a series of EOR/ROR instructions, combined with a build-time
check that the value is the one we expect.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201026095116.72051-2-maz@kernel.org
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 47224dc62c51..b11a9d7db677 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -57,16 +57,25 @@ __do_hyp_init:
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.lo	__kvm_handle_stub_hvc
 
-	/* Set tpidr_el2 for use by HYP to free a register */
-	msr	tpidr_el2, x2
-
-	mov	x2, #KVM_HOST_SMCCC_FUNC(__kvm_hyp_init)
-	cmp	x0, x2
-	b.eq	1f
+	// We only actively check bits [24:31], and everything
+	// else has to be zero, which we check at build time.
+#if (KVM_HOST_SMCCC_FUNC(__kvm_hyp_init) & 0xFFFFFFFF00FFFFFF)
+#error Unexpected __KVM_HOST_SMCCC_FUNC___kvm_hyp_init value
+#endif
+
+	ror	x0, x0, #24
+	eor	x0, x0, #((KVM_HOST_SMCCC_FUNC(__kvm_hyp_init) >> 24) & 0xF)
+	ror	x0, x0, #4
+	eor	x0, x0, #((KVM_HOST_SMCCC_FUNC(__kvm_hyp_init) >> 28) & 0xF)
+	cbz	x0, 1f
 	mov	x0, #SMCCC_RET_NOT_SUPPORTED
 	eret
 
-1:	phys_to_ttbr x0, x1
+1:
+	/* Set tpidr_el2 for use by HYP to free a register */
+	msr	tpidr_el2, x2
+
+	phys_to_ttbr x0, x1
 alternative_if ARM64_HAS_CNP
 	orr	x0, x0, #TTBR_CNP_BIT
 alternative_else_nop_endif
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
