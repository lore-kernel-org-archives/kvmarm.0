From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v8 3/9] KVM: arm/arm64: Don't cache the timer IRQ level
Date: Tue, 19 Dec 2017 14:17:38 +0000
Message-ID: <517ead96-a689-d6f6-564f-67b1cd020daf@arm.com>
References: <20171213104602.16383-1-christoffer.dall@linaro.org>
 <20171213104602.16383-4-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39EF649D46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 09:13:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EU6UmIc7Ijcj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Dec 2017 09:13:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D778D49D36
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 09:13:54 -0500 (EST)
In-Reply-To: <20171213104602.16383-4-christoffer.dall@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

A few nits in the commit message.

On 13/12/17 10:45, Christoffer Dall wrote:
> The timer was modeled after a strict idea of modelling an interrupt line

nit: modelling (also, modeled after a strict idea of modelling?)

> level in software, meaning that only transitions in the level needed to

s/needed/need/ ?

> be reported to the VGIC.  This works well for the timer, because the
> arch timer code is in complete control of the device and can track the
> transitions of the line.
> 
> However, as we are about to support using the HW bit in the VGIC not
> just for the timer, but also for VFIO which cannot track transitions of
> the interrupt line, we have to decide on an interface for level
> triggered mapped interrupts to the GIC, which both the timer and VFIO

"level triggered interrupts mapped to the GIC" ?

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
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

> ---
>   virt/kvm/arm/arch_timer.c | 20 +++++++++++++-------
>   1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4151250ce8da..dd5aca05c500 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -99,11 +99,9 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>   	}
>   	vtimer = vcpu_vtimer(vcpu);
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
>   	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
>   		kvm_vtimer_update_mask_user(vcpu);
> @@ -324,12 +322,20 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>   	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>   	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>   	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> +	bool level;
>   
>   	if (unlikely(!timer->enabled))
>   		return;
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
>   	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
>   		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
> 

-- 
Julien Thierry
