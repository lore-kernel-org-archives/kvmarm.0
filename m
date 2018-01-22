From: Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [PATCH v9 7/9] KVM: arm/arm64: Provide a get_input_level for the
 arch timer
Date: Mon, 22 Jan 2018 13:32:57 +0100
Message-ID: <e55af9ff-b597-3b14-8e46-216aa20ede24@semihalf.com>
References: <20171220113606.7030-1-christoffer.dall@linaro.org>
 <20171220113606.7030-8-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171220113606.7030-8-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hello Christoffer,

Please see my observations/comments below.

On 20.12.2017 12:36, Christoffer Dall wrote:
> The VGIC can now support the life-cycle of mapped level-triggered
> interrupts, and we no longer have to read back the timer state on every
> exit from the VM if we had an asserted timer interrupt signal, because
> the VGIC already knows if we hit the unlikely case where the guest
> disables the timer without ACKing the virtual timer interrupt.
> 
> This means we rework a bit of the code to factor out the functionality
> to snapshot the timer state from vtimer_save_state(), and we can reuse
> this functionality in the sync path when we have an irqchip in
> userspace, and also to support our implementation of the
> get_input_level() function for the timer.
> 
> This change also means that we can no longer rely on the timer's view of
> the interrupt line to set the active state, because we no longer
> maintain this state for mapped interrupts when exiting from the guest.
> Instead, we only set the active state if the virtual interrupt is
> active, and otherwise we simply let the timer fire again and raise the
> virtual interrupt from the ISR.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>   include/kvm/arm_arch_timer.h |  2 ++
>   virt/kvm/arm/arch_timer.c    | 84 ++++++++++++++++++++------------------------
>   2 files changed, 40 insertions(+), 46 deletions(-)
> 
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 6e45608b2399..b1dcfde0a3ef 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -90,6 +90,8 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
>   
>   void kvm_timer_init_vhe(void);
>   
> +bool kvm_arch_timer_get_input_level(int vintid);
> +
>   #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
>   #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
>   
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index fb0533ed903d..d845d67b7062 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -343,6 +343,12 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>   	phys_timer_emulate(vcpu);
>   }
>   
> +static void __timer_snapshot_state(struct arch_timer_context *timer)
> +{
> +	timer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> +	timer->cnt_cval = read_sysreg_el0(cntv_cval);
> +}
> +
>   static void vtimer_save_state(struct kvm_vcpu *vcpu)
>   {
>   	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> @@ -354,10 +360,8 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
>   	if (!vtimer->loaded)
>   		goto out;
>   
> -	if (timer->enabled) {
> -		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> -		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
> -	}
> +	if (timer->enabled)
> +		__timer_snapshot_state(vtimer);
>   
>   	/* Disable the virtual timer */
>   	write_sysreg_el0(0, cntv_ctl);
> @@ -454,8 +458,7 @@ static void kvm_timer_vcpu_load_vgic(struct kvm_vcpu *vcpu)
>   	bool phys_active;
>   	int ret;
>   
> -	phys_active = vtimer->irq.level ||
> -		      kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
> +	phys_active = kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
>   
>   	ret = irq_set_irqchip_state(host_vtimer_irq,
>   				    IRQCHIP_STATE_ACTIVE,
> @@ -535,54 +538,27 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>   	set_cntvoff(0);
>   }
>   
> -static void unmask_vtimer_irq(struct kvm_vcpu *vcpu)
> +/*
> + * With a userspace irqchip we have to check if the guest de-asserted the
> + * timer and if so, unmask the timer irq signal on the host interrupt
> + * controller to ensure that we see future timer signals.
> + */
> +static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
>   {
>   	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>   
>   	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
> -		kvm_vtimer_update_mask_user(vcpu);
> -		return;
> -	}
> -
> -	/*
> -	 * If the guest disabled the timer without acking the interrupt, then
> -	 * we must make sure the physical and virtual active states are in
> -	 * sync by deactivating the physical interrupt, because otherwise we
> -	 * wouldn't see the next timer interrupt in the host.
> -	 */
> -	if (!kvm_vgic_map_is_active(vcpu, vtimer->irq.irq)) {
> -		int ret;
> -		ret = irq_set_irqchip_state(host_vtimer_irq,
> -					    IRQCHIP_STATE_ACTIVE,
> -					    false);
> -		WARN_ON(ret);
> +		__timer_snapshot_state(vtimer);
> +		if (!kvm_timer_should_fire(vtimer)) {
> +			kvm_timer_update_irq(vcpu, false, vtimer);
> +			kvm_vtimer_update_mask_user(vcpu);
> +		}
>   	}
>   }
>   
> -/**
> - * kvm_timer_sync_hwstate - sync timer state from cpu
> - * @vcpu: The vcpu pointer
> - *
> - * Check if any of the timers have expired while we were running in the guest,
> - * and inject an interrupt if that was the case.
> - */
>   void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>   {
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> -
> -	/*
> -	 * If we entered the guest with the vtimer output asserted we have to
> -	 * check if the guest has modified the timer so that we should lower
> -	 * the line at this point.
> -	 */
> -	if (vtimer->irq.level) {
> -		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> -		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
> -		if (!kvm_timer_should_fire(vtimer)) {
> -			kvm_timer_update_irq(vcpu, false, vtimer);
> -			unmask_vtimer_irq(vcpu);
> -		}
> -	}
> +	unmask_vtimer_irq_user(vcpu);
>   }

While testing your VHE optimization series [1] I noticed massive WFI 
exits on ThunderX2 so I bisected 'vhe-optimize-v3-with-fixes' branch of 
[2] down to this commit.

The host traps on WFI so that VCPU thread should be scheduled out for 
some time. However, this is not happening because kvm_vcpu_block() -> 
kvm_vcpu_check_block() gives negative value (vtimer->irq.level is 
asserted) and VCPU is woken up immediately. Nobody takes care about 
lowering the vtimer line in this case.

I reverted shape of above kvm_timer_sync_hwstate() and things are good 
now. Before I start digging I wanted to check with you. Can you please 
check on your side?

[1] https://www.spinics.net/lists/kvm/msg161941.html
[2] git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git

Thanks,
Tomasz
