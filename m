Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A78C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Mar 2022 13:59:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77D3F49F3E;
	Fri,  4 Mar 2022 08:59:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Aqz9NDxrUlC9; Fri,  4 Mar 2022 08:59:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6865F49F40;
	Fri,  4 Mar 2022 08:59:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45D3749F38
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 08:59:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h85-oaL-49Ti for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Mar 2022 08:59:28 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14A3E49F33
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 08:59:28 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A73A6B829B9;
 Fri,  4 Mar 2022 13:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBCDC340E9;
 Fri,  4 Mar 2022 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1646402365;
 bh=aDDUTrSaHUg2O24fF8jlt5pGcEdXVX897YYvC2Z3OSk=;
 h=From:To:Cc:Subject:Date:From;
 b=gJnJDN56QZOinBigwwaFXm+Tz098AzwejnLtLn604qUkIuSYasb+6HfChp1Yv9a2p
 YKSoziHjOCSCsGXgLg+iehGdjlDxUwOnbtc/MxvUzO1daqLr6gBJDezshs3KgxYZ5o
 BfrNrzkJCkcIZF5bSLapQdXEAL1Tg2sQAggcDBrmND4Z0RI4SWAjp8okF213SecSh6
 yZlKq4Otrc21MpJDSvL/Fng18EYlGH5nlgaP1I4xClxibLID//z3HGRUgpPBjPISV8
 0GtwrZl5dqz6+FBMmFcMMPkuomab15a3a/w+QDIiwK/veCADBrQmz18cpyhAGoLAix
 NsIhMTXzYeDKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nQ8So-00CEVb-Vn; Fri, 04 Mar 2022 13:59:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH] KVM: arm64: Only open the interrupt window on exit due to an
 interrupt
Date: Fri,  4 Mar 2022 13:59:14 +0000
Message-Id: <20220304135914.1464721-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com
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

Now that we properly account for interrupts taken whilst the guest
was running, it becomes obvious that there is no need to open
this accounting window if we didn't exit because of an interrupt.

This saves a number of system register accesses and other barriers
if we exited for any other reason (such as a trap, for example).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fefd5774ab55..f49ebdd9c990 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -887,9 +887,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * context synchronization event) is necessary to ensure that
 		 * pending interrupts are taken.
 		 */
-		local_irq_enable();
-		isb();
-		local_irq_disable();
+		if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) {
+			local_irq_enable();
+			isb();
+			local_irq_disable();
+		}
 
 		guest_timing_exit_irqoff();
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
