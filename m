Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54891C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:51:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1314620848
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="v7zstlj+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1314620848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA854AEC1;
	Tue, 11 Feb 2020 12:51:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hqYJeuEa4UNl; Tue, 11 Feb 2020 12:51:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F12E94AE93;
	Tue, 11 Feb 2020 12:51:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99C4D4A97D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:51:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yQSshbyWAw+k for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 12:51:31 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C91844A944
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:51:30 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E6D7820661;
 Tue, 11 Feb 2020 17:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581443490;
 bh=LX+303+Rgi1tTyC2KS98Cz+aQmALLYRZoKsrqstynaI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=v7zstlj+OCH39Yrl6ZqpW/XuDf6iza6fP3AkLbgF8CadX4EyXI5aQCWW+ZK7okVXD
 OvodWB1Gu883JiyJlotyk8DFWL47H2UUZzyvVFOwd/BYcw+Dxx/QrEDtooYgXOY65f
 RqqMCR682gj8vat8dJX7L2xMkE5CZTwLKpqHmWf8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j1ZgG-004O7k-Ns; Tue, 11 Feb 2020 17:50:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 80/94] KVM: arm64: Use accessors for timer ctl/cval/offset
Date: Tue, 11 Feb 2020 17:49:24 +0000
Message-Id: <20200211174938.27809-81-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

Instead of directly accessing the various fields in the timer data
structures, add accessors that provide the same service. By making the
weak, we'll be able to override them in a subsequent patch, making it
possible to move them in the VNCR page, as they will be directly
accessed by the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/arch_timer.c | 104 +++++++++++++++++++++++++-------------
 1 file changed, 68 insertions(+), 36 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 3c88a4c0a296..d87e52f7e962 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -62,6 +62,36 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
 
+__weak u32 timer_get_ctl(struct arch_timer_context *ctxt)
+{
+	return ctxt->cnt_ctl;
+}
+
+__weak u64 timer_get_cval(struct arch_timer_context *ctxt)
+{
+	return ctxt->cnt_cval;
+}
+
+__weak u64 timer_get_offset(struct arch_timer_context *ctxt)
+{
+	return ctxt->cntvoff;
+}
+
+__weak void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
+{
+	ctxt->cnt_ctl = ctl;
+}
+
+__weak void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
+{
+	ctxt->cnt_cval = cval;
+}
+
+__weak void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
+{
+	ctxt->cntvoff = offset;
+}
+
 u64 kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
@@ -149,8 +179,8 @@ static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 {
 	u64 cval, now;
 
-	cval = timer_ctx->cnt_cval;
-	now = kvm_phys_timer_read() - timer_ctx->cntvoff;
+	cval = timer_get_cval(timer_ctx);
+	now = kvm_phys_timer_read() - timer_get_offset(timer_ctx);
 
 	if (now < cval) {
 		u64 ns;
@@ -169,8 +199,8 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 {
 	WARN_ON(timer_ctx && timer_ctx->loaded);
 	return timer_ctx &&
-	       !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
-		(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
+		((timer_get_ctl(timer_ctx) &
+		  (ARCH_TIMER_CTRL_IT_MASK | ARCH_TIMER_CTRL_ENABLE)) == ARCH_TIMER_CTRL_ENABLE);
 }
 
 /*
@@ -283,8 +313,8 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 	if (!kvm_timer_irq_can_fire(timer_ctx))
 		return false;
 
-	cval = timer_ctx->cnt_cval;
-	now = kvm_phys_timer_read() - timer_ctx->cntvoff;
+	cval = timer_get_cval(timer_ctx);
+	now = kvm_phys_timer_read() - timer_get_offset(timer_ctx);
 
 	return cval <= now;
 }
@@ -379,8 +409,8 @@ static void timer_save_state(struct arch_timer_context *ctx)
 	switch (index) {
 	case TIMER_VTIMER:
 	case TIMER_HVTIMER:
-		ctx->cnt_ctl = read_sysreg_el0(SYS_CNTV_CTL);
-		ctx->cnt_cval = read_sysreg_el0(SYS_CNTV_CVAL);
+		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTV_CTL));
+		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTV_CVAL));
 
 		/* Disable the timer */
 		write_sysreg_el0(0, SYS_CNTV_CTL);
@@ -389,8 +419,8 @@ static void timer_save_state(struct arch_timer_context *ctx)
 		break;
 	case TIMER_PTIMER:
 	case TIMER_HPTIMER:
-		ctx->cnt_ctl = read_sysreg_el0(SYS_CNTP_CTL);
-		ctx->cnt_cval = read_sysreg_el0(SYS_CNTP_CVAL);
+		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTP_CTL));
+		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTP_CVAL));
 
 		/* Disable the timer */
 		write_sysreg_el0(0, SYS_CNTP_CTL);
@@ -461,15 +491,15 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 	switch (index) {
 	case TIMER_VTIMER:
 	case TIMER_HVTIMER:
-		write_sysreg_el0(ctx->cnt_cval, SYS_CNTV_CVAL);
+		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTV_CVAL);
 		isb();
-		write_sysreg_el0(ctx->cnt_ctl, SYS_CNTV_CTL);
+		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
 		break;
 	case TIMER_PTIMER:
 	case TIMER_HPTIMER:
-		write_sysreg_el0(ctx->cnt_cval, SYS_CNTP_CVAL);
+		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTP_CVAL);
 		isb();
-		write_sysreg_el0(ctx->cnt_ctl, SYS_CNTP_CTL);
+		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTP_CTL);
 		break;
 	case NR_KVM_TIMERS:
 		BUG();
@@ -608,7 +638,7 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 		kvm_timer_vcpu_load_nogic(vcpu);
 	}
 
-	set_cntvoff(map.direct_vtimer->cntvoff);
+	set_cntvoff(timer_get_offset(map.direct_vtimer));
 
 	kvm_timer_unblocking(vcpu);
 
@@ -722,10 +752,10 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * resets the timer to be disabled and unmasked and is compliant with
 	 * the ARMv7 architecture.
 	 */
-	vcpu_vtimer(vcpu)->cnt_ctl = 0;
-	vcpu_ptimer(vcpu)->cnt_ctl = 0;
-	vcpu_hvtimer(vcpu)->cnt_ctl = 0;
-	vcpu_hptimer(vcpu)->cnt_ctl = 0;
+	timer_set_ctl(vcpu_vtimer(vcpu), 0);
+	timer_set_ctl(vcpu_ptimer(vcpu), 0);
+	timer_set_ctl(vcpu_hvtimer(vcpu), 0);
+	timer_set_ctl(vcpu_hptimer(vcpu), 0);
 
 	if (timer->enabled) {
 		kvm_timer_update_irq(vcpu, false, vcpu_vtimer(vcpu));
@@ -757,13 +787,13 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 
 	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, tmp, kvm)
-		vcpu_vtimer(tmp)->cntvoff = cntvoff;
+		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
 
 	/*
 	 * When called from the vcpu create path, the CPU being created is not
 	 * included in the loop above, so we just set it here as well.
 	 */
-	vcpu_vtimer(vcpu)->cntvoff = cntvoff;
+	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
 	mutex_unlock(&kvm->lock);
 }
 
@@ -777,9 +807,9 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 
 	/* Synchronize cntvoff across all vtimers of a VM. */
 	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
-	ptimer->cntvoff = 0;
-	hvtimer->cntvoff = 0;
-	hptimer->cntvoff = 0;
+	timer_set_offset(ptimer, 0);
+	timer_set_offset(hvtimer, 0);
+	timer_set_offset(hptimer, 0);
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	timer->bg_timer.function = kvm_bg_timer_expire;
@@ -862,10 +892,12 @@ static u64 read_timer_ctl(struct arch_timer_context *timer)
 	 * UNKNOWN when ENABLE bit is 0, so we chose to set ISTATUS bit
 	 * regardless of ENABLE bit for our implementation convenience.
 	 */
+	u32 ctl = timer_get_ctl(timer);
+
 	if (!kvm_timer_compute_delta(timer))
-		return timer->cnt_ctl | ARCH_TIMER_CTRL_IT_STAT;
-	else
-		return timer->cnt_ctl;
+		ctl |= ARCH_TIMER_CTRL_IT_STAT;
+
+	return ctl;
 }
 
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
@@ -901,8 +933,8 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 
 	switch (treg) {
 	case TIMER_REG_TVAL:
-		val = timer->cnt_cval - kvm_phys_timer_read() + timer->cntvoff;
-		val &= lower_32_bits(val);
+		val = timer_get_cval(timer) - kvm_phys_timer_read() + timer_get_offset(timer);
+		val = lower_32_bits(val);
 		break;
 
 	case TIMER_REG_CTL:
@@ -910,15 +942,15 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 		break;
 
 	case TIMER_REG_CVAL:
-		val = timer->cnt_cval;
+		val = timer_get_cval(timer);
 		break;
 
 	case TIMER_REG_CNT:
-		val = kvm_phys_timer_read() - timer->cntvoff;
+		val = kvm_phys_timer_read() - timer_get_offset(timer);
 		break;
 
 	case TIMER_REG_VOFF:
-		val = timer->cntvoff;
+		val = timer_get_offset(timer);
 		break;
 
 	default:
@@ -952,19 +984,19 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 {
 	switch (treg) {
 	case TIMER_REG_TVAL:
-		timer->cnt_cval = kvm_phys_timer_read() - timer->cntvoff + (s32)val;
+		timer_set_cval(timer, kvm_phys_timer_read() - timer_get_offset(timer) + (s32)val);
 		break;
 
 	case TIMER_REG_CTL:
-		timer->cnt_ctl = val & ~ARCH_TIMER_CTRL_IT_STAT;
+		timer_set_ctl(timer, val & ~ARCH_TIMER_CTRL_IT_STAT);
 		break;
 
 	case TIMER_REG_CVAL:
-		timer->cnt_cval = val;
+		timer_set_cval(timer, val);
 		break;
 
 	case TIMER_REG_VOFF:
-		timer->cntvoff = val;
+		timer_set_offset(timer, val);
 		break;
 
 	default:
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
