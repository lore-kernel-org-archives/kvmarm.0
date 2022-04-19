Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0003AC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 18:49:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6889E4B190;
	Tue, 19 Apr 2022 14:49:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id clOOm+rWo8-g; Tue, 19 Apr 2022 14:49:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5B84B1A0;
	Tue, 19 Apr 2022 14:49:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 121634B18A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:49:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m7cqsZTjY8-d for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 14:49:56 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E90BE4B162
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:49:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6F764B818E3;
 Tue, 19 Apr 2022 18:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE55C385A7;
 Tue, 19 Apr 2022 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650394193;
 bh=NsQzBnqyQikJz4t5vv6/pIfEg6KlxVdCJGyHvursnek=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PsLZPyeR7NEosrxFAH6xo9aVOEo6xXUnhE0ADprj/RG8wklR6ikAnBz7hQ+9OLSXl
 HHgdTY7IfFkZUoVq2EeG/HvVtxxvENLGsyOewpM8GPBxlGo4q1wfJ9zI8vWAChkfKu
 3YBW4VpWYO2vqgSyIM/S8lNvXcX+ibogecHS/l4Fo+pEgPRpC04qWELX/lIunJFHv/
 YbzkjzijOxaOU55uM3q5P2bvFuned33fzZoacKbSHw/bntB/pytKsNkzAygbOpFH73
 QZbR4KQiY2YMF98jIHplltBySjBtq7QXoI4L1k7t8aCoKDFcoIxF2Toq3wYchN978F
 /O9RSgkhYi2Rg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1ngsa7-005QYF-Vt; Tue, 19 Apr 2022 19:28:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 10/10] arm64: Use WFxT for __delay() when possible
Date: Tue, 19 Apr 2022 19:27:55 +0100
Message-Id: <20220419182755.601427-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419182755.601427-1-maz@kernel.org>
References: <20220419182755.601427-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, joey.gouly@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Joey Gouly <joey.gouly@arm.com>, Will Deacon <will@kernel.org>
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
