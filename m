Return-Path: <SRS0=w8eh=K3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D1DC47093
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 10:40:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5CC92613B9
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 10:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CC92613B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0725240CF9;
	Tue,  1 Jun 2021 06:40:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oVBirQXAVqGz; Tue,  1 Jun 2021 06:40:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6761540878;
	Tue,  1 Jun 2021 06:40:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C39A9407EF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 06:40:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CfqB4wUgEfCk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Jun 2021 06:40:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87FD5407D1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 06:40:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C2DA4613AE;
 Tue,  1 Jun 2021 10:40:13 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lo1oi-004nNs-2e; Tue, 01 Jun 2021 11:40:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 2/9] KVM: arm64: Handle physical FIQ as an IRQ while
 running a guest
Date: Tue,  1 Jun 2021 11:39:58 +0100
Message-Id: <20210601104005.81332-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601104005.81332-1-maz@kernel.org>
References: <20210601104005.81332-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st,
 mark.rutland@arm.com, yuzenghui@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Hector Martin <marcan@marcan.st>
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

As we we now entertain the possibility of FIQ being used on the host,
treat the signalling of a FIQ while running a guest as an IRQ,
causing an exit instead of a HYP panic.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5f49df4ffdd8..9aa9b73475c9 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -76,6 +76,7 @@ el1_trap:
 	b	__guest_exit
 
 el1_irq:
+el1_fiq:
 	get_vcpu_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
@@ -131,7 +132,6 @@ SYM_CODE_END(\label)
 	invalid_vector	el2t_error_invalid
 	invalid_vector	el2h_irq_invalid
 	invalid_vector	el2h_fiq_invalid
-	invalid_vector	el1_fiq_invalid
 
 	.ltorg
 
@@ -179,12 +179,12 @@ SYM_CODE_START(__kvm_hyp_vector)
 
 	valid_vect	el1_sync		// Synchronous 64-bit EL1
 	valid_vect	el1_irq			// IRQ 64-bit EL1
-	invalid_vect	el1_fiq_invalid		// FIQ 64-bit EL1
+	valid_vect	el1_fiq			// FIQ 64-bit EL1
 	valid_vect	el1_error		// Error 64-bit EL1
 
 	valid_vect	el1_sync		// Synchronous 32-bit EL1
 	valid_vect	el1_irq			// IRQ 32-bit EL1
-	invalid_vect	el1_fiq_invalid		// FIQ 32-bit EL1
+	valid_vect	el1_fiq			// FIQ 32-bit EL1
 	valid_vect	el1_error		// Error 32-bit EL1
 SYM_CODE_END(__kvm_hyp_vector)
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
