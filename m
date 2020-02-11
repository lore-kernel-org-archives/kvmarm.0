Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095CFC352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 13:52:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8472F206ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 13:52:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8472F206ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F36CB4AC68;
	Tue, 11 Feb 2020 08:52:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nepNrKwH2y3O; Tue, 11 Feb 2020 08:52:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8A5D4AE9E;
	Tue, 11 Feb 2020 08:52:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 746554A97D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 08:52:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HNgim5ZbtAhg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 08:52:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18A034A650
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 08:52:38 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A138230E;
 Tue, 11 Feb 2020 05:52:37 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14AC43F68F;
 Tue, 11 Feb 2020 05:52:36 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests v2] arm64: timer: Speed up gic-timer-state
 check
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20200211133705.1398-1-drjones@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <87b71045-a2cd-1434-c26d-e427d58e5d9b@arm.com>
Date: Tue, 11 Feb 2020 13:52:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200211133705.1398-1-drjones@redhat.com>
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

On 2/11/20 1:37 PM, Andrew Jones wrote:
> Let's bail out of the wait loop if we see the expected state
> to save over six seconds of run time. Make sure we wait a bit
> before reading the registers and double check again after,
> though, to somewhat mitigate the chance of seeing the expected
> state by accident.
>
> We also take this opportunity to push more IRQ state code to
> the library.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/timer.c       | 30 ++++++++++++------------------
>  lib/arm/asm/gic.h | 11 ++++++-----
>  lib/arm/gic.c     | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 51 insertions(+), 23 deletions(-)
>
> diff --git a/arm/timer.c b/arm/timer.c
> index f5cf775ce50f..3c4e27f20e2e 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -183,28 +183,22 @@ static bool timer_pending(struct timer_info *info)
>  		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
>  }
>  
> -static enum gic_state gic_timer_state(struct timer_info *info)
> +static bool gic_timer_check_state(struct timer_info *info,
> +				  enum gic_irq_state expected_state)
>  {
> -	enum gic_state state = GIC_STATE_INACTIVE;
>  	int i;
> -	bool pending, active;
>  
>  	/* Wait for up to 1s for the GIC to sample the interrupt. */
>  	for (i = 0; i < 10; i++) {
> -		pending = readl(gic_ispendr) & (1 << PPI(info->irq));
> -		active = readl(gic_isactiver) & (1 << PPI(info->irq));
> -		if (!active && !pending)
> -			state = GIC_STATE_INACTIVE;
> -		if (pending)
> -			state = GIC_STATE_PENDING;
> -		if (active)
> -			state = GIC_STATE_ACTIVE;
> -		if (active && pending)
> -			state = GIC_STATE_ACTIVE_PENDING;
>  		mdelay(100);
> +		if (gic_irq_state(info->irq) == expected_state) {
> +			mdelay(100);
> +			if (gic_irq_state(info->irq) == expected_state)
> +				return true;
> +		}
>  	}
>  
> -	return state;
> +	return false;
>  }
>  
>  static bool test_cval_10msec(struct timer_info *info)
> @@ -253,11 +247,11 @@ static void test_timer(struct timer_info *info)
>  	/* Enable the timer, but schedule it for much later */
>  	info->write_cval(later);
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
> -	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
> +	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
>  			"not pending before");
>  
>  	info->write_cval(now - 1);
> -	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_PENDING,
> +	report(timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_PENDING),
>  			"interrupt signal pending");
>  
>  	/* Disable the timer again and prepare to take interrupts */
> @@ -265,12 +259,12 @@ static void test_timer(struct timer_info *info)
>  	info->irq_received = false;
>  	set_timer_irq_enabled(info, true);
>  	report(!info->irq_received, "no interrupt when timer is disabled");
> -	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
> +	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
>  			"interrupt signal no longer pending");
>  
>  	info->write_cval(now - 1);
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
> -	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
> +	report(timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
>  			"interrupt signal not pending");
>  
>  	report(test_cval_10msec(info), "latency within 10 ms");
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index a72e0cde4e9c..922cbe95750c 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -47,11 +47,11 @@
>  #ifndef __ASSEMBLY__
>  #include <asm/cpumask.h>
>  
> -enum gic_state {
> -	GIC_STATE_INACTIVE,
> -	GIC_STATE_PENDING,
> -	GIC_STATE_ACTIVE,
> -	GIC_STATE_ACTIVE_PENDING,
> +enum gic_irq_state {
> +	GIC_IRQ_STATE_INACTIVE,
> +	GIC_IRQ_STATE_PENDING,
> +	GIC_IRQ_STATE_ACTIVE,
> +	GIC_IRQ_STATE_ACTIVE_PENDING,
>  };
>  
>  /*
> @@ -80,6 +80,7 @@ extern u32 gic_iar_irqnr(u32 iar);
>  extern void gic_write_eoir(u32 irqstat);
>  extern void gic_ipi_send_single(int irq, int cpu);
>  extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
> +extern enum gic_irq_state gic_irq_state(int irq);
>  
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM_GIC_H_ */
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 94301169215c..0563b31132c8 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -146,3 +146,36 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
>  	assert(gic_common_ops && gic_common_ops->ipi_send_mask);
>  	gic_common_ops->ipi_send_mask(irq, dest);
>  }
> +
> +enum gic_irq_state gic_irq_state(int irq)
> +{
> +	enum gic_irq_state state;
> +	bool pending = false, active = false;
> +	void *base;
> +
> +	assert(gic_common_ops);
> +
> +	switch (gic_version()) {
> +	case 2:
> +		base = gicv2_dist_base();
> +		pending = readl(base + GICD_ISPENDR) & (1 << PPI(irq));
> +		active = readl(base + GICD_ISACTIVER) & (1 << PPI(irq));
> +		break;
> +	case 3:
> +		base = gicv3_sgi_base();
> +		pending = readl(base + GICR_ISPENDR0) & (1 << PPI(irq));
> +		active = readl(base + GICR_ISACTIVER0) & (1 << PPI(irq));
> +		break;
> +	}
> +
> +	if (!active && !pending)
> +		state = GIC_IRQ_STATE_INACTIVE;
> +	if (pending)
> +		state = GIC_IRQ_STATE_PENDING;
> +	if (active)
> +		state = GIC_IRQ_STATE_ACTIVE;
> +	if (active && pending)
> +		state = GIC_IRQ_STATE_ACTIVE_PENDING;
> +
> +	return state;
> +}

Looks good. The gic_ispendr and gic_isactiver variables are not used anymore and
could be removed, but it's not a big deal. Either way:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
