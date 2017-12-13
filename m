From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Wed, 13 Dec 2017 08:56:12 +0000
Message-ID: <b2d0234c-e763-d4c1-02f7-c50cd0914b13@arm.com>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Jia He <hejianet@gmail.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org, Jia He <jia.he@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jia,

On 13/12/17 07:00, Jia He wrote:
> In our Armv8a server (qualcomm Amberwing, non VHE), after applying
> Christoffer's timer optimizing patchset(Optimize arch timer register
> handling), the guest is hang during kernel booting.
> 
> The error root cause might be as follows:
> 1. in kvm_arch_timer_handler, it reset vtimer->cnt_ctl with current
> cntv_ctl register value. And then it missed some cases to update timer's
> irq (irq.level) when kvm_timer_irq_can_fire() is false
> 2. It causes kvm_vcpu_check_block return 0 instead of -EINTR
> 	kvm_vcpu_check_block
> 		kvm_cpu_has_pending_timer
> 			kvm_timer_is_pending
> 				kvm_timer_should_fire
> 3. Thus, the kvm hyp code can not break the loop in kvm_vcpu_block (halt
> poll process) and the guest is hang forever
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
>  		if (kvm_timer_irq_can_fire(vtimer))
>  			kvm_timer_update_irq(vcpu, true, vtimer);
>  	}
> 

Which patches are you looking at? The current code in mainline looks
like this:

	vtimer = vcpu_vtimer(vcpu);

	vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
	if (kvm_timer_irq_can_fire(vtimer))
		kvm_timer_update_irq(vcpu, true, vtimer);

I'd suggest you use mainline and report if this doesn't work.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
