From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 4/4] KVM: arm/arm64: Provide a vgic interrupt line
 level sample function
Date: Sat, 02 Sep 2017 12:20:34 +0100
Message-ID: <86tw0ltkhp.fsf@arm.com>
References: <20170829093902.15379-1-cdall@linaro.org>
 <20170829093902.15379-5-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3176D49C13
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Sep 2017 07:18:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p4ciqcVppBXo for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Sep 2017 07:18:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E14E740C5A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Sep 2017 07:18:20 -0400 (EDT)
In-Reply-To: <20170829093902.15379-5-cdall@linaro.org> (Christoffer Dall's
 message of "Tue, 29 Aug 2017 11:39:02 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 29 2017 at 11:39:02 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> The GIC sometimes need to sample the physical line of a mapped
> interrupt.  As we know this to be notoriously slow, provide a callback
> function for devices (such as the timer) which can do this much faster
> than talking to the distributor, for example by comparing a few
> in-memory values.  Fall back to the good old method of poking the
> physical GIC if no callback is provided.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  include/kvm/arm_vgic.h    | 13 ++++++++++++-
>  virt/kvm/arm/arch_timer.c | 16 +++++++++++++++-
>  virt/kvm/arm/vgic/vgic.c  |  7 ++++++-
>  3 files changed, 33 insertions(+), 3 deletions(-)
>
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 53f631b..a52990b 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -125,6 +125,17 @@ struct vgic_irq {
>  	u8 priority;
>  	enum vgic_irq_config config;	/* Level or edge */
>  
> +	/*
> +	 * Callback function pointer to in-kernel devices that can tell us the
> +	 * state of the input level of mapped level-triggered IRQ faster than
> +	 * peaking into the physical GIC.
> +	 *
> +	 * Always called in non-preemptible section and the functions can use
> +	 * kvm_arm_get_running_vcpu() to get the vcpu pointer for private
> +	 * IRQs.
> +	 */
> +	bool (*get_input_level)(int vintid);
> +
>  	void *owner;			/* Opaque pointer to reserve an interrupt
>  					   for in-kernel devices. */
>  };
> @@ -309,7 +320,7 @@ void kvm_vgic_init_cpu_hardware(void);
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level, void *owner);
>  int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> -			  u32 vintid);
> +			  u32 vintid, bool (*callback)(int vindid));
>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
>  
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index b24e2f7..82169ef 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -643,6 +643,19 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static bool timer_get_input_level(int vintid)
> +{
> +	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
> +	struct arch_timer_context *timer;
> +
> +	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
> +		timer = vcpu_vtimer(vcpu);
> +	else
> +		BUG(); /* We only map the vtimer so far */
> +
> +	return kvm_timer_should_fire(timer);
> +}
> +
>  int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> @@ -664,7 +677,8 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  		return -EINVAL;
>  	}
>  
> -	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq);
> +	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq,
> +				    &timer_get_input_level);

nit: no need for a & here.

>  	if (ret)
>  		return ret;
>  
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index e3ce2fa..0466c10 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -147,6 +147,9 @@ bool vgic_irq_line_level(struct vgic_irq *irq)
>  
>  	BUG_ON(!irq->hw);
>  
> +	if (irq->get_input_level)
> +		return irq->get_input_level(irq->intid);
> +
>  	WARN_ON(irq_get_irqchip_state(irq->host_irq,
>  				      IRQCHIP_STATE_PENDING,
>  				      &line_level));
> @@ -429,7 +432,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  }
>  
>  int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> -			  u32 vintid)
> +			  u32 vintid, bool (*callback)(int vindid))

nit #2: "callback" is a very non-descriptive name for a callback... ;-)
How about calling it "get_input_level", matching the vgic_irq field?

>  {
>  	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
>  	struct irq_desc *desc;
> @@ -456,6 +459,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
>  	irq->hw = true;
>  	irq->host_irq = host_irq;
>  	irq->hwintid = data->hwirq;
> +	irq->get_input_level = callback;
>  
>  out:
>  	spin_unlock(&irq->irq_lock);
> @@ -476,6 +480,7 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
>  	spin_lock(&irq->irq_lock);
>  	irq->hw = false;
>  	irq->hwintid = 0;
> +	irq->get_input_level = NULL;
>  	spin_unlock(&irq->irq_lock);
>  	vgic_put_irq(vcpu->kvm, irq);

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
