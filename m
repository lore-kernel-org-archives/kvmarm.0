Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6763CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:19:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEEB14B2A8;
	Tue, 12 Apr 2022 09:19:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z4O7SFrbEMOJ; Tue, 12 Apr 2022 09:19:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A90FC4B162;
	Tue, 12 Apr 2022 09:19:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F7004A4BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:19:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hCQIqvo3HFmh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:19:52 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 096074B216
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:19:51 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1BE64619D0;
 Tue, 12 Apr 2022 13:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A31C385A5;
 Tue, 12 Apr 2022 13:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649769590;
 bh=NsQzBnqyQikJz4t5vv6/pIfEg6KlxVdCJGyHvursnek=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=O0k74iqoL5o7Qwdl/g2m0Wt2gcW6UwwG9JM0tdNoZBChhIqxXmFt7DCzgWDdtVBZ2
 be1ONXbHXUzWgYVCw4H2oeoGXfD0SnlqV2genWUInfDRGphVmwh+O1aamoOJnu/qym
 TatiUUwL1cuwnE7wc9DiebmqnFDbWZU9rEgY5NUyV5Njfh+weSyag6pY9FAiazsWH/
 etzpOuPgi+RBCGw4+Q2I+f3j/1lvSfj3Ed176dXUhPxI5FIVfLu+52sbqfw/kLVzvJ
 m3OSuBNxNv9Y7pLyGPAFU1qSWWa0YXh4/KGheeP63OWL7C6iTYcPHYkijY9tCNAhqM
 x4t0tODjfxj3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1neGLC-003mvX-8X; Tue, 12 Apr 2022 14:13:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 10/10] arm64: Use WFxT for __delay() when possible
Date: Tue, 12 Apr 2022 14:13:03 +0100
Message-Id: <20220412131303.504690-11-maz@kernel.org>
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

Marginally optimise __delay() by using a WFIT/WFET sequence.
It probably is a win if no interrupt fires during the delay.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/lib/delay.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
index 1688af0a4c97..5b7890139bc2 100644
--- a/arch/arm64/lib/delay.c
+++ b/arch/arm64/lib/delay.c
@@ -27,7 +27,17 @@ void __delay(unsigned long cycles)
 {
 	cycles_t start = get_cycles();
 
-	if (arch_timer_evtstrm_available()) {
+	if (cpus_have_const_cap(ARM64_HAS_WFXT)) {
+		u64 end = start + cycles;
+
+		/*
+		 * Start with WFIT. If an interrupt makes us resume
+		 * early, use a WFET loop to complete the delay.
+		 */
+		wfit(end);
+		while ((get_cycles() - start) < cycles)
+			wfet(end);
+	} else 	if (arch_timer_evtstrm_available()) {
 		const cycles_t timer_evt_period =
 			USECS_TO_CYCLES(ARCH_TIMER_EVT_STREAM_PERIOD_US);
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
