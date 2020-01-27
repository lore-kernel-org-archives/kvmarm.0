Return-Path: <SRS0=6gnH=3Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778F4C32771
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jan 2020 11:08:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF67E214AF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jan 2020 11:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyjsE4Ti"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF67E214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F53B4AF20;
	Mon, 27 Jan 2020 06:07:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id piGjlxUovJ18; Mon, 27 Jan 2020 06:07:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2B134AF1D;
	Mon, 27 Jan 2020 06:07:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0CE44AEBE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jan 2020 06:07:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FYPOVnUkaQwW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jan 2020 06:07:55 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B05E4AEB9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jan 2020 06:07:55 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2B98C206A2;
 Mon, 27 Jan 2020 11:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1580123274;
 bh=XtPA8Ig4ryv+n4XTiVr/+miOFcjAr3IBN5e8V49V0oc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=oyjsE4Tia2Xnz3WM35PVEk56sRpDCe/euovB/pw+uefePlv5393JZDREcGK5b36Oj
 0zG68m2ZlSJU21o80OQgWbdzZlBN8L34HkpKrWL3ic1O1TqX+yJbtg6+gV7YfKI/8g
 b4agbuXpEZQGiSCylixAVF/Xfvith77Aw4v70OJ4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1iw2FE-001arU-EI; Mon, 27 Jan 2020 11:07:52 +0000
MIME-Version: 1.0
Date: Mon, 27 Jan 2020 11:07:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Treat emulated TVAL TimerValue as a signed
 32-bit integer
In-Reply-To: <20200127103652.2326-1-alexandru.elisei@arm.com>
References: <20200127103652.2326-1-alexandru.elisei@arm.com>
Message-ID: <5f633dfb2abe63059d75c0da58c69241@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alexandru,

On 2020-01-27 10:36, Alexandru Elisei wrote:
> According to the ARM ARM, registers CNT{P,V}_TVAL_EL0 have bits [63:32]
> RES0 [1]. When reading the register, the value is truncated to the 
> least
> significant 32 bits [2], and on writes, TimerValue is treated as a 
> signed
> 32-bit integer [1, 2].
> 
> When the guest behaves correctly and writes 32-bit values, treating 
> TVAL
> as an unsigned 64 bit register works as expected. However, things start
> to break down when the guest writes larger values, because
> (u64)0x1_ffff_ffff = 8589934591. but (s32)0x1_ffff_ffff = -1, and the
> former will cause the timer interrupt to be asserted in the future, but
> the latter will cause it to be asserted now.  Let's treat TVAL as a
> signed 32-bit register on writes, to match the behaviour described in
> the architecture, and the behaviour experimentally exhibited by the
> virtual timer on a non-vhe host.
> 
> [1] Arm DDI 0487E.a, section D13.8.18
> [2] Arm DDI 0487E.a, section D11.2.4
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Huhuh... Nice catch!

Fixes: 8fa761624871 ("KVM: arm/arm64: arch_timer: Fix CNTP_TVAL 
calculation")

(how many times are we doing to fix this???)

> ---
>  include/kvm/arm_arch_timer.h | 2 ++
>  virt/kvm/arm/arch_timer.c    | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/kvm/arm_arch_timer.h 
> b/include/kvm/arm_arch_timer.h
> index d120e6c323e7..be912176b7a3 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -10,6 +10,8 @@
>  #include <linux/clocksource.h>
>  #include <linux/hrtimer.h>
> 
> +#define ARCH_TIMER_TVAL_MASK	((1ULL << 32) - 1)
> +
>  enum kvm_arch_timers {
>  	TIMER_PTIMER,
>  	TIMER_VTIMER,
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index f182b2380345..5d40f17f7024 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -805,6 +805,7 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu 
> *vcpu,
>  	switch (treg) {
>  	case TIMER_REG_TVAL:
>  		val = timer->cnt_cval - kvm_phys_timer_read() + timer->cntvoff;
> +		val &= ARCH_TIMER_TVAL_MASK;

nit: Do we really need this mask? I'd rather see it written as

                 val = lower_32_bits(val);


>  		break;
> 
>  	case TIMER_REG_CTL:
> @@ -850,7 +851,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu 
> *vcpu,
>  {
>  	switch (treg) {
>  	case TIMER_REG_TVAL:
> -		timer->cnt_cval = kvm_phys_timer_read() - timer->cntvoff + val;
> +		timer->cnt_cval = kvm_phys_timer_read() - timer->cntvoff + (s32)val;
>  		break;
> 
>  	case TIMER_REG_CTL:

Otherwise, looks good to me. If you're OK with the above change, I'll
take it as a fix.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
