From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v5 3/8] KVM: arm/arm64: Don't cache the timer IRQ level
Date: Fri, 1 Dec 2017 18:04:55 +0000
Message-ID: <bf436ce1-1908-ff74-386b-45870c04a133@arm.com>
References: <20171120191649.17290-1-christoffer.dall@linaro.org>
 <20171120191649.17290-4-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171120191649.17290-4-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 20/11/17 19:16, Christoffer Dall wrote:
> The timer was modeled after a strict idea of modelling an interrupt line
> level in software, meaning that only transitions in the level needed to
> be reported to the VGIC.  This works well for the timer, because the
> arch timer code is in complete control of the device and can track the
> transitions of the line.
> 
> However, as we are about to support using the HW bit in the VGIC not
> just for the timer, but also for VFIO which cannot track transitions of
> the interrupt line, we have to decide on an interface for level
> triggered mapped interrupts to the GIC, which both the timer and VFIO
> can use.
> 
> VFIO only sees an asserting transition of the physical interrupt line,
> and tells the VGIC when that happens.  That means that part of the
> interrupt flow is offloaded to the hardware.
> 
> To use the same interface for VFIO devices and the timer, we therefore
> have to change the timer (we cannot change VFIO because it doesn't know
> the details of the device it is assigning to a VM).
> 
> Luckily, changing the timer is simple, we just need to stop 'caching'
> the line level, but instead let the VGIC know the state of the timer
> every time there is a potential change in the line level, and when the
> line level should be asserted from the timer ISR.  The VGIC can ignore
> extra notifications using its validate mechanism.

Indeed vgic_validate_injection() should take care of that change.

> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  virt/kvm/arm/arch_timer.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 190c99ed1b73..5f8ad8e3f3ff 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -99,11 +99,9 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>  	}
>  	vtimer = vcpu_vtimer(vcpu);
>  
> -	if (!vtimer->irq.level) {
> -		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> -		if (kvm_timer_irq_can_fire(vtimer))
> -			kvm_timer_update_irq(vcpu, true, vtimer);
> -	}
> +	vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> +	if (kvm_timer_irq_can_fire(vtimer))
> +		kvm_timer_update_irq(vcpu, true, vtimer);
>  
>  	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
>  		kvm_vtimer_update_mask_user(vcpu);
> @@ -324,12 +322,20 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> +	bool level;
>  
>  	if (unlikely(!timer->enabled))
>  		return;
>  
> -	if (kvm_timer_should_fire(vtimer) != vtimer->irq.level)
> -		kvm_timer_update_irq(vcpu, !vtimer->irq.level, vtimer);
> +	/*
> +	 * The vtimer virtual interrupt is a 'mapped' interrupt, meaning part
> +	 * of its lifecycle is offloaded to the hardware, and we therefore may
> +	 * not have lowered the irq.level value before having to signal a new
> +	 * interrupt, but have to signal an interrupt every time the level is
> +	 * asserted.
> +	 */
> +	level = kvm_timer_should_fire(vtimer);
> +	kvm_timer_update_irq(vcpu, level, vtimer);
>  
>  	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
>  		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
> 
