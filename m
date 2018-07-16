From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: arm/arm64: Fix emulated physical timer IRQ injection
Date: Mon, 16 Jul 2018 18:35:15 +0100
Message-ID: <d2f5aa19-9107-7e6b-e0f0-8064e2eab2bf@arm.com>
References: <20180716172357.6121-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180716172357.6121-1-andre.przywara@arm.com>
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Stable <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/07/18 18:23, Andre Przywara wrote:
> When KVM emulates a physical timer, we keep track of the interrupt
> condition and try to inject an IRQ to the guest when needed.
> This works if the timer expires when either the guest is running or KVM
> does work on behalf of it, since it calls kvm_timer_update_state().
> However when the guest's VCPU is not scheduled (for instance because
> the guest issued a WFI instruction before), we miss injecting the interrupt
> when the VCPU's state gets restored back in kvm_timer_vcpu_load().
> 
> Fix this by moving the interrupt injection check into the
> phys_timer_emulate() function, so that all possible paths of execution
> are covered.
> 
> This fixes the physical timer emulation, which broke when it got changed
> in the 4.15 merge window.
> The respective kvm-unit-test check has been posted already.
> 
> Cc: Stable <stable@vger.kernel.org> # 4.15+
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/arch_timer.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index bd3d57f40f1b..1949fb0b80a4 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -294,17 +294,26 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu)
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
> +	/* If the timer cannot fire at all, then we don't need a soft timer. */
> +	if (!kvm_timer_irq_can_fire(ptimer)) {
> +		soft_timer_cancel(&timer->phys_timer, NULL);
> +		kvm_timer_update_irq(vcpu, false, ptimer);
> +		return;
> +	}
> +
>  	/*
> -	 * If the timer can fire now we have just raised the IRQ line and we
> -	 * don't need to have a soft timer scheduled for the future.  If the
> -	 * timer cannot fire at all, then we also don't need a soft timer.
> +	 * If the timer can fire now, we don't need to have a soft timer
> +	 * scheduled for the future, as we also raise the IRQ line.
>  	 */
> -	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
> +	if (kvm_timer_should_fire(ptimer)) {
>  		soft_timer_cancel(&timer->phys_timer, NULL);
> +		kvm_timer_update_irq(vcpu, true, ptimer);
> +
>  		return;
>  	}
>  
>  	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(ptimer));
> +	kvm_timer_update_irq(vcpu, false, ptimer);

I think this bit is wrong. The soft timer could have expired by the time
you get to lower the line, and you would just loose that interrupt.
Lowering the line *before* starting the soft timer would make a lot more
sense to me.

>  }
>  
>  /*
> @@ -316,7 +325,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> -	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  	bool level;
>  
>  	if (unlikely(!timer->enabled))
> @@ -332,9 +340,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  	level = kvm_timer_should_fire(vtimer);
>  	kvm_timer_update_irq(vcpu, level, vtimer);
>  
> -	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
> -		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
> -
>  	phys_timer_emulate(vcpu);
>  }
>  
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
