Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7788EC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 18:28:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F2234B24C;
	Tue, 19 Apr 2022 14:28:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4dZgXGjWDULW; Tue, 19 Apr 2022 14:28:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C81954B293;
	Tue, 19 Apr 2022 14:28:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 006904B248
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:28:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mxKfGqMGaiVI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 14:28:08 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABCA34B234
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:28:08 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 350F361554;
 Tue, 19 Apr 2022 18:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A47AC385AD;
 Tue, 19 Apr 2022 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650392887;
 bh=oQRTKlELBR9tC/Xp7BPIS5voj097Bi1ZLaUJHVChP6w=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=TF8faUVZT0u497DD2Zekw5VWwkmz3xK65im8zkVNqc01O0B4v4tEjgyOJemeb+toS
 FTwRfab30eD+dvOJ4ycpeTcmMjIjF6ulen1RYMcL1Q7GIOct9H7uvlJTyBrhRaWl1B
 7Uuki1UUTymopsirV+x2Hwr3LzZiUKbsRNFFdl/MjsVXlyktuzy1YWs3NGT6N/Ib64
 9BKfuPtyOEzXXZYm+nUMhVJjF4OM/oqRpznegmDfBooLBOjvKe0OcUqq83DUlI2JVS
 iprkJsh5HA/TqeYb8FR69pKusyWgeVt8hFLzkt9o+qFmyd94afyQkUqzGw2Nzm2rIE
 v9nY1QVaXaZZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1ngsa5-005QYF-6B; Tue, 19 Apr 2022 19:28:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 04/10] KVM: arm64: Introduce kvm_counter_compute_delta()
 helper
Date: Tue, 19 Apr 2022 19:27:49 +0100
Message-Id: <20220419182755.601427-5-maz@kernel.org>
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

Refactor kvm_timer_compute_delta() and extract a helper that
compute the delta (in ns) between a given timer and an arbitrary
value.

No functional change expected.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 16dda1a383a6..c92a68190f6a 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -208,18 +208,16 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
+static u64 kvm_counter_compute_delta(struct arch_timer_context *timer_ctx,
+				     u64 val)
 {
-	u64 cval, now;
-
-	cval = timer_get_cval(timer_ctx);
-	now = kvm_phys_timer_read() - timer_get_offset(timer_ctx);
+	u64 now = kvm_phys_timer_read() - timer_get_offset(timer_ctx);
 
-	if (now < cval) {
+	if (now < val) {
 		u64 ns;
 
 		ns = cyclecounter_cyc2ns(timecounter->cc,
-					 cval - now,
+					 val - now,
 					 timecounter->mask,
 					 &timecounter->frac);
 		return ns;
@@ -228,6 +226,11 @@ static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 	return 0;
 }
 
+static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
+{
+	return kvm_counter_compute_delta(timer_ctx, timer_get_cval(timer_ctx));
+}
+
 static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 {
 	WARN_ON(timer_ctx && timer_ctx->loaded);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
