From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm64: timer: Avoid IRQ race in timer test
Date: Wed, 26 Jul 2017 15:18:10 +0200
Message-ID: <3d9e6aff-4b82-410f-3bbd-45ea4d33ca2e@redhat.com>
References: <20170726114249.17774-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170726114249.17774-1-cdall@linaro.org>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Andrew Jones <drjones@redhat.com>, Alexander Graf <agraf@suse.de>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 26/07/2017 13:42, Christoffer Dall wrote:
> The current timer test relies on testing the pending state of the timer
> before the interrupt handler has run which could lower the pending
> signal again (because it masks the timer output signal).
> 
> What we really want is to make sure the output signal from the timer as
> perceived by the virtual interrupt controller is low when the timer is
> programmed some time far in the future.  The proper way to do that is to
> disable the timer interrupt on the distributor and then reading its
> pending state.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  arm/timer.c | 41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 33dfc6f..e824338 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -96,6 +96,23 @@ static struct timer_info ptimer_info = {
>  	.write_ctl = write_ptimer_ctl,
>  };
>  
> +static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
> +{
> +	u32 val = 0;
> +
> +	if (enabled)
> +		val = 1 << PPI(info->irq);
> +
> +	switch (gic_version()) {
> +	case 2:
> +		writel(val, gicv2_dist_base() + GICD_ISENABLER + 0);
> +		break;
> +	case 3:
> +		writel(val, gicv3_sgi_base() + GICR_ISENABLER0);
> +		break;
> +	}
> +}
> +
>  static void irq_handler(struct pt_regs *regs)
>  {
>  	struct timer_info *info;
> @@ -133,6 +150,8 @@ static bool test_cval_10msec(struct timer_info *info)
>  	/* Program timer to fire in 10 ms */
>  	before_timer = info->read_counter();
>  	info->write_cval(before_timer + time_10ms);
> +	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
> +	isb();
>  
>  	/* Wait for the timer to fire */
>  	while (!(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS))
> @@ -159,13 +178,25 @@ static void test_timer(struct timer_info *info)
>  	u64 time_10s = read_sysreg(cntfrq_el0) * 10;
>  	u64 later = now + time_10s;
>  
> +	/* We don't want the irq handler to fire because that will change the
> +	 * timer state and we want to test the timer output signal.  We can
> +	 * still read the pending state even if it's disabled. */
> +	set_timer_irq_enabled(info, false);
>  
> -	/* Enable the timer, but schedule it for much later*/
> +	/* Enable the timer, but schedule it for much later */
>  	info->write_cval(later);
> -	isb();
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
> -
> +	isb();
>  	report("not pending before", !gic_timer_pending(info));
> +
> +	info->write_cval(now - 1);
> +	isb();
> +	report("interrupt signal pending", gic_timer_pending(info));
> +
> +	/* Disable the timer again and prepare to take interrupts */
> +	info->write_ctl(0);
> +	set_timer_irq_enabled(info, true);
> +
>  	report("latency within 10 ms", test_cval_10msec(info));
>  	report("interrupt received", info->irq_received);
>  
> @@ -211,13 +242,9 @@ static void test_init(void)
>  
>  	switch (gic_version()) {
>  	case 2:
> -		writel(1 << PPI(vtimer_info.irq), gicv2_dist_base() + GICD_ISENABLER + 0);
> -		writel(1 << PPI(ptimer_info.irq), gicv2_dist_base() + GICD_ISENABLER + 0);
>  		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
>  		break;
>  	case 3:
> -		writel(1 << PPI(vtimer_info.irq), gicv3_sgi_base() + GICR_ISENABLER0);
> -		writel(1 << PPI(ptimer_info.irq), gicv3_sgi_base() + GICR_ISENABLER0);
>  		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
>  		break;
>  	}
> 


Applied, thanks.

Paolo
