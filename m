Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D0EC352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 12:49:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF9EF20637
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 12:49:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF9EF20637
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 522CF4AEBB;
	Tue, 11 Feb 2020 07:49:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id usIYjuhXvTIf; Tue, 11 Feb 2020 07:49:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E94D84AC83;
	Tue, 11 Feb 2020 07:49:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E94AC4A59B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:49:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kiOz2x-+vb3j for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 07:49:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B47E04A578
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:49:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC3521FB;
 Tue, 11 Feb 2020 04:49:25 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D8CC3F6CF;
 Tue, 11 Feb 2020 04:49:25 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] arm64: timer: Speed up gic-timer-state
 check
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20200211123521.13637-1-drjones@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <bba0ce4f-15c6-aa14-4bd8-ce6598b45fd4@arm.com>
Date: Tue, 11 Feb 2020 12:49:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200211123521.13637-1-drjones@redhat.com>
Content-Language: en-US
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

Hi,

On 2/11/20 12:35 PM, Andrew Jones wrote:
> Let's bail out of the wait loop if we see the expected state
> to save about seven seconds of run time. Make sure we wait a
> bit before reading the registers, though, to somewhat mitigate
> the chance of the expected state being stale.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/timer.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/arm/timer.c b/arm/timer.c
> index f5cf775ce50f..c2262c112c09 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -183,7 +183,8 @@ static bool timer_pending(struct timer_info *info)
>  		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
>  }
>  
> -static enum gic_state gic_timer_state(struct timer_info *info)
> +static bool gic_timer_check_state(struct timer_info *info,
> +				  enum gic_state expected_state)
>  {
>  	enum gic_state state = GIC_STATE_INACTIVE;
>  	int i;
> @@ -191,6 +192,7 @@ static enum gic_state gic_timer_state(struct timer_info *info)
>  
>  	/* Wait for up to 1s for the GIC to sample the interrupt. */
>  	for (i = 0; i < 10; i++) {
> +		mdelay(100);
>  		pending = readl(gic_ispendr) & (1 << PPI(info->irq));
>  		active = readl(gic_isactiver) & (1 << PPI(info->irq));
>  		if (!active && !pending)
> @@ -201,10 +203,11 @@ static enum gic_state gic_timer_state(struct timer_info *info)
>  			state = GIC_STATE_ACTIVE;
>  		if (active && pending)
>  			state = GIC_STATE_ACTIVE_PENDING;
> -		mdelay(100);
> +		if (state == expected_state)
> +			return true;
>  	}
>  
> -	return state;
> +	return false;
>  }

The first version I wrote looked similar. However I decided to wait the entire 1s
because I could imagine a situation where the interrupt was pending, but if I were
to wait a bit longer, it would have become active and pending, which is not what
we would want. Same thing with inactive.

How about after the state matches what we expect, we wait for an extra 100ms and
check that the state hasn't changed?

Also, you probably also want to lower the timeout in arm/unittests.cfg.

Thanks,
Alex
>  
>  static bool test_cval_10msec(struct timer_info *info)
> @@ -253,11 +256,11 @@ static void test_timer(struct timer_info *info)
>  	/* Enable the timer, but schedule it for much later */
>  	info->write_cval(later);
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
> -	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
> +	report(!timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INACTIVE),
>  			"not pending before");
>  
>  	info->write_cval(now - 1);
> -	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_PENDING,
> +	report(timer_pending(info) && gic_timer_check_state(info, GIC_STATE_PENDING),
>  			"interrupt signal pending");
>  
>  	/* Disable the timer again and prepare to take interrupts */
> @@ -265,12 +268,12 @@ static void test_timer(struct timer_info *info)
>  	info->irq_received = false;
>  	set_timer_irq_enabled(info, true);
>  	report(!info->irq_received, "no interrupt when timer is disabled");
> -	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
> +	report(!timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INACTIVE),
>  			"interrupt signal no longer pending");
>  
>  	info->write_cval(now - 1);
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
> -	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
> +	report(timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INACTIVE),
>  			"interrupt signal not pending");
>  
>  	report(test_cval_10msec(info), "latency within 10 ms");
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
