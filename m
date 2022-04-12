Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E615C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:14:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A092A4B27F;
	Tue, 12 Apr 2022 09:14:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8UHLTJQH6qMP; Tue, 12 Apr 2022 09:14:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 308514B2DB;
	Tue, 12 Apr 2022 09:14:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 689EE4B2A7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dPSr5iTPxWwF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:13:57 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79D794B263
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 8324AB81D07;
 Tue, 12 Apr 2022 13:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124A3C385AD;
 Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649769234;
 bh=oQRTKlELBR9tC/Xp7BPIS5voj097Bi1ZLaUJHVChP6w=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=axgCf/Y+uEov9odiuV3T5IncomHJYx0lWYKa0imV7kiy3lxDKvsMKquP/kLKixmmW
 RjXKYAmBwQQGEbAsszXM80ruru3tB+KJmbHidxhbRKO8S+WS4Rh0QzJwzvoENLXLCl
 U3LFcoe/t/RV+AEm3UVNmASBzBrDqjJ8Ksls/lJrPbQyy/NZo+DxiYUajpxoJ1A01u
 BArj+3HmswBAa9z94mCkz+0O9f9Xdczppw8/SJPfpyHp8ixgUgsBtyMtf0uYlh72PL
 FXquJTYXSehRlYyV9lIyHgWLLUzn7aw3rPHnu1CtqiO4ZCWY+UNLeMPi2sgi8RKQpl
 KsLO3ObeIf07w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1neGLA-003mvX-0z; Tue, 12 Apr 2022 14:13:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 04/10] KVM: arm64: Introduce kvm_counter_compute_delta() helper
Date: Tue, 12 Apr 2022 14:12:57 +0100
Message-Id: <20220412131303.504690-5-maz@kernel.org>
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
