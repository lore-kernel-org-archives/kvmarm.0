From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 5/8] KVM: arm/arm64: Support a vgic interrupt line
 level sample function
Date: Tue, 12 Dec 2017 09:40:47 +0100
Message-ID: <1696d751-7928-f283-3f94-0825704e2a66@redhat.com>
References: <20171207105418.22428-1-christoffer.dall@linaro.org>
 <20171207105418.22428-6-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFEED49DA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 03:37:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a1CWGcq7XjkC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Dec 2017 03:37:22 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5EF349D9D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 03:37:21 -0500 (EST)
In-Reply-To: <20171207105418.22428-6-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 07/12/17 11:54, Christoffer Dall wrote:
> The GIC sometimes need to sample the physical line of a mapped
> interrupt.  As we know this to be notoriously slow, provide a callback
> function for devices (such as the timer) which can do this much faster
> than talking to the distributor, for example by comparing a few
> in-memory values.  Fall back to the good old method of poking the
> physical GIC if no callback is provided.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  include/kvm/arm_vgic.h    | 13 ++++++++++++-
>  virt/kvm/arm/arch_timer.c |  3 ++-
>  virt/kvm/arm/vgic/vgic.c  | 12 +++++++++---
>  3 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 8c896540a72c..cdbd142ca7f2 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -130,6 +130,17 @@ struct vgic_irq {
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
> @@ -331,7 +342,7 @@ void kvm_vgic_init_cpu_hardware(void);
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level, void *owner);
>  int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> -			  u32 vintid);
> +			  u32 vintid, bool (*get_input_level)(int vindid));
>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
>  
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index dd5aca05c500..e78ba5e20f74 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -840,7 +840,8 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  		return -EINVAL;
>  	}
>  
> -	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq);
> +	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq,
> +				    NULL);
>  	if (ret)
>  		return ret;
>  
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 607cbbc27a1c..eadabb249d2a 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
Nit: the comment "Get the input level of a mapped IRQ directly from the
physical GIC" is not strictly correct anymore
> @@ -151,6 +151,9 @@ bool vgic_get_phys_line_level(struct vgic_irq *irq)
>  
>  	BUG_ON(!irq->hw);
>  
> +	if (irq->get_input_level)
> +		return irq->get_input_level(irq->intid);
> +
>  	WARN_ON(irq_get_irqchip_state(irq->host_irq,
>  				      IRQCHIP_STATE_PENDING,
>  				      &line_level));
> @@ -436,7 +439,8 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  
>  /* @irq->irq_lock must be held */
>  static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> -			    unsigned int host_irq)
> +			    unsigned int host_irq,
> +			    bool (*get_input_level)(int vindid))
>  {
>  	struct irq_desc *desc;
>  	struct irq_data *data;
> @@ -456,6 +460,7 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	irq->hw = true;
>  	irq->host_irq = host_irq;
>  	irq->hwintid = data->hwirq;
> +	irq->get_input_level = get_input_level;
>  	return 0;
>  }
>  
> @@ -464,10 +469,11 @@ static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
>  {
>  	irq->hw = false;
>  	irq->hwintid = 0;
> +	irq->get_input_level = NULL;
>  }
>  
>  int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> -			  u32 vintid)
> +			  u32 vintid, bool (*get_input_level)(int vindid))
>  {
>  	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
>  	unsigned long flags;
> @@ -476,7 +482,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
>  	BUG_ON(!irq);
>  
>  	spin_lock_irqsave(&irq->irq_lock, flags);
> -	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
> +	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, get_input_level);
>  	spin_unlock_irqrestore(&irq->irq_lock, flags);
>  	vgic_put_irq(vcpu->kvm, irq);
>  
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
