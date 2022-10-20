Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D12BC43219
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 09:16:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5524B91F;
	Thu, 20 Oct 2022 05:16:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OpB913utU80x; Thu, 20 Oct 2022 05:16:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4C2F4B97D;
	Thu, 20 Oct 2022 05:16:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53AD14B952
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NxnfMDBiN2kQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 05:16:43 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 378934B90B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:43 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 4CC78B826AB;
 Thu, 20 Oct 2022 09:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5829C433D7;
 Thu, 20 Oct 2022 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666257401;
 bh=3UxipA3fUndbyMhU66PV9SVzAL9vSse9sjm0ZKv3n0o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=T5gYd3isuT46pK01Hv3XBUd9AI69TE/tQb5/fsIwaZC6uc0z47hLtsYfOKz75OXBV
 guzyJ0vuD9Tfl5cnnnQ3n/WjsVwIo463cBu1M+nH7ivYzvAXDSx4jkQDp4kLrbJYbp
 RZTIN/CersEUlMxXuABUVxWM2gtQRbnGqGiTqYawQW026rdVA6qWqw2aHC9whwXIYt
 Wa20A2wrC5bFi1IlF3xYUMPzhKh04SbOkiE1KvALYHzpPfHhz3DgnVJiGNbZJytuaZ
 BusEtPp4agaNKM9VYQTCOyxWQMk2o188gOJXuZ6vFdO7E5uhZ6CVsZtDUTDFZDbWYB
 jQQzS5GUDPmkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1olRWc-000Buf-4L;
 Thu, 20 Oct 2022 10:07:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/17] KVM: arm64: Program the timer traps with VHE layout in
 hVHE mode
Date: Thu, 20 Oct 2022 10:07:24 +0100
Message-Id: <20221020090727.3669908-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>
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

Just like the rest of the timer code, we need to shift the enable
bits around when HCR_EL2.E2H is set, which is the case in hVHE mode.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..143cdc1d107f 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -16,33 +16,39 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
 }
 
 /*
- * Should only be called on non-VHE systems.
+ * Should only be called on non-VHE or hVHE setups.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
 void __timer_disable_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val, shift = 0;
+
+	if (has_hvhe())
+		shift = 10;
 
 	/* Allow physical timer/counter access for the host */
 	val = read_sysreg(cnthctl_el2);
-	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
+	val |= (CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN) << shift;
 	write_sysreg(val, cnthctl_el2);
 }
 
 /*
- * Should only be called on non-VHE systems.
+ * Should only be called on non-VHE or hVHE setups.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
 void __timer_enable_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val, shift = 0;
 
 	/*
 	 * Disallow physical timer access for the guest
 	 * Physical counter access is allowed
 	 */
+	if (has_hvhe())
+		shift = 10;
+
 	val = read_sysreg(cnthctl_el2);
-	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
+	val &= ~(CNTHCTL_EL1PCEN << shift);
+	val |= CNTHCTL_EL1PCTEN << shift;
 	write_sysreg(val, cnthctl_el2);
 }
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
