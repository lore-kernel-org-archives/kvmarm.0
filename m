From: Jia He <hejianet@gmail.com>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Thu, 21 Dec 2017 17:16:48 +0800
Message-ID: <b38aaf58-ea00-f5ef-a307-56cdfd84bd64@gmail.com>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
 <20171213091803.GQ910@cbox> <dc95b58c-ee6c-e5c7-1f37-8f69c789a1fc@gmail.com>
 <20171214130954.GV910@cbox> <5615f3e1-756e-0537-f0b6-20ae8626ac87@gmail.com>
 <20171214154518.GX910@cbox> <e5ccbf1c-6078-4c43-8aa3-fc226ed358f7@gmail.com>
 <20171215100451.GY910@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2225C49D9E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Dec 2017 04:13:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id glozWpZIenKw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Dec 2017 04:13:08 -0500 (EST)
Received: from mail-io0-f194.google.com (mail-io0-f194.google.com
 [209.85.223.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F34D549D40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Dec 2017 04:13:07 -0500 (EST)
Received: by mail-io0-f194.google.com with SMTP id d16so20355855iob.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Dec 2017 01:16:59 -0800 (PST)
In-Reply-To: <20171215100451.GY910@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jia He <jia.he@hxt-semitech.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer

Sorry for the late, I ever thought you would send out v2 with isb(). It 
seems not.


On 12/15/2017 6:04 PM, Christoffer Dall Wrote:
> On Fri, Dec 15, 2017 at 10:27:02AM +0800, Jia He wrote:
>
> [...]
[...]
>
> Meanwhile, I think I thought of a cleaner way to do this.  Could you
> test the following two patches on your platform as well?
>
> >From 3a594a3aa222bd64a86f6c6afcb209c9be20d5c5 Mon Sep 17 00:00:00 2001
> From: Christoffer Dall <christoffer.dall@linaro.org>
> Date: Thu, 14 Dec 2017 19:54:50 +0100
> Subject: [PATCH 1/2] KVM: arm/arm64: Properly handle arch-timer IRQs after
>   vtimer_save_state
>
> The recent timer rework was assuming that once the timer was disabled,
> we should no longer see any interrupts from the timer.  This assumption
> turns out to not be true, and instead we have to handle the case when
> the timer ISR runs even after the timer has been disabled.
>
> This requires a couple of changes:
>
> First, we should never overwrite the cached guest state of the timer
> control register when the ISR runs, because KVM may have disabled its
> timers when doing vcpu_put(), even though the guest still had the timer
> enabled.
>
> Second, we shouldn't assume that the timer is actually firing just
> because we see an ISR, but we should check the ISTATUS field of the
> timer control register to understand if the hardware timer is really
> firing or not.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Signed-off-by: Jia He <jia.he@hxt-semitech.com>

> ---
>   virt/kvm/arm/arch_timer.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index aa9adfafe12b..792bcf6277b6 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -92,16 +92,21 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>   {
>   	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
>   	struct arch_timer_context *vtimer;
> +	u32 cnt_ctl;
>   
> -	if (!vcpu) {
> -		pr_warn_once("Spurious arch timer IRQ on non-VCPU thread\n");
> -		return IRQ_NONE;
> -	}
> -	vtimer = vcpu_vtimer(vcpu);
> +	/*
> +	 * We may see a timer interrupt after vcpu_put() has been called which
> +	 * sets the CPU's vcpu pointer to NULL, because even though the timer
> +	 * has been disabled in vtimer_save_state(), the singal may not have
> +	 * been retired from the interrupt controller yet.
> +	 */
> +	if (!vcpu)
> +		return IRQ_HANDLED;
>   
> +	vtimer = vcpu_vtimer(vcpu);
>   	if (!vtimer->irq.level) {
> -		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> -		if (kvm_timer_irq_can_fire(vtimer))
> +		cnt_ctl = read_sysreg_el0(cntv_ctl);
> +		if (cnt_ctl & ARCH_TIMER_CTRL_IT_STAT)
>   			kvm_timer_update_irq(vcpu, true, vtimer);
>   	}
>   
>
>
> >From ed96302b47d209024814df116994f64dc8f07c96 Mon Sep 17 00:00:00 2001
> From: Christoffer Dall <christoffer.dall@linaro.org>
> Date: Fri, 15 Dec 2017 00:30:12 +0100
> Subject: [PATCH 2/2] KVM: arm/arm64: Fix timer enable flow
>
> When enabling the timer on the first run, we fail to ever restore the
> state and mark it as loaded.  That means, that in the initial entry to
> the VCPU ioctl, unless we exit to userspace for some reason such as a
> pending signal, if the guest programs a timer and blocks, we will wait
> forever, because we never read back the hardware state (the loaded flag
> is not set), and so we think the timer is disabled, and we never
> schedule a background soft timer.
>
> The end result?  The VCPU blocks forever, and the only solution is to
> kill the thread.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>   virt/kvm/arm/arch_timer.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 792bcf6277b6..8869658e6983 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -843,10 +843,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>   no_vgic:
>   	preempt_disable();
>   	timer->enabled = 1;
> -	if (!irqchip_in_kernel(vcpu->kvm))
> -		kvm_timer_vcpu_load_user(vcpu);
> -	else
> -		kvm_timer_vcpu_load_vgic(vcpu);
> +	kvm_timer_vcpu_load(vcpu);
>   	preempt_enable();
>   
>   	return 0;
>
>
> Thanks,
> -Christoffer
>
I have tested your 2 patches in my QDF2400 server for 10 times, the 
guest can be boot up without any issues.
Without this patch, the guest will always hang in booting stages.

-- 
Cheers,
Jia
