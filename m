From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Wed, 13 Dec 2017 10:18:03 +0100
Message-ID: <20171213091803.GQ910@cbox>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 199F949D75
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 04:14:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5-lJSDAn1geO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Dec 2017 04:14:40 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20D1240651
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 04:14:40 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id b199so3577769wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 01:18:11 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jia He <hejianet@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jia He <jia.he@hxt-semitech.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 12, 2017 at 11:00:07PM -0800, Jia He wrote:
> In our Armv8a server (qualcomm Amberwing, non VHE), after applying
> Christoffer's timer optimizing patchset(Optimize arch timer register
> handling), the guest is hang during kernel booting.
> 
> The error root cause might be as follows:
> 1. in kvm_arch_timer_handler, it reset vtimer->cnt_ctl with current
> cntv_ctl register value. And then it missed some cases to update timer's
> irq (irq.level) when kvm_timer_irq_can_fire() is false

Why should it set the irq level to true when the timer cannot fire?

> 2. It causes kvm_vcpu_check_block return 0 instead of -EINTR
> 	kvm_vcpu_check_block
> 		kvm_cpu_has_pending_timer
> 			kvm_timer_is_pending
> 				kvm_timer_should_fire
> 3. Thus, the kvm hyp code can not break the loop in kvm_vcpu_block (halt
> poll process) and the guest is hang forever

This is just a polling loop which will expire after some time, so it
shouldn't halt the guest indefinitely, but merely slow it down for some
while, if we have a bug.  Is that the behavior you're seeing or are you
seeing the guest coming to a complete halt?

> 
> Fixes: b103cc3f10c0 ("KVM: arm/arm64: Avoid timer save/restore in vcpu entry/exit")
> Signed-off-by: Jia He <jia.he@hxt-semitech.com>
> ---
>  virt/kvm/arm/arch_timer.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index f9555b1..bb86433 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -100,7 +100,6 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>  	vtimer = vcpu_vtimer(vcpu);
>  
>  	if (!vtimer->irq.level) {
> -		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);

This fix is clearly not correct, as it would prevent forwarding timer
interrupts in some cases.

>  		if (kvm_timer_irq_can_fire(vtimer))
>  			kvm_timer_update_irq(vcpu, true, vtimer);
>  	}
> -- 
> 2.7.4
> 

I actually don't see how the above scenario you painted can happen.

If you're in the polling loop, that means that the timer state is loaded
on the vcpu, and that means you can take interrupts from the timer, and
when you take interrupts, you will set the irq.level.

And here's the first bit of logic in kvm_timer_is_pending():

	if (vtimer->irq.level || ptimer->irq.level)
		return true;

So that would break the loop.

I'm not able to reproduce on my side with a non-VHE platform.

What is the workload you're running to reproduce this, and what is the
exact kernel tree and kernel configuration you're using?

Thanks,
-Christoffer
