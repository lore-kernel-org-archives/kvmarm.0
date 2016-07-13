From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v9 06/17] KVM: arm/arm64: VGIC: add refcounting for IRQs
Date: Wed, 13 Jul 2016 14:50:25 +0100
Message-ID: <f9aeb32e-ff1a-ab2e-945c-0e8e531e43b9@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-7-andre.przywara@arm.com> <578630E4.3000305@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A39E1499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 09:43:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dv48SCpez1Te for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jul 2016 09:43:49 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1843A48531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 09:43:47 -0400 (EDT)
In-Reply-To: <578630E4.3000305@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 13/07/16 13:15, Marc Zyngier wrote:
> On 13/07/16 02:58, Andre Przywara wrote:
>> In the moment our struct vgic_irq's are statically allocated at guest
>> creation time. So getting a pointer to an IRQ structure is trivial and
>> safe. LPIs are more dynamic, they can be mapped and unmapped at any time
>> during the guest's _runtime_.
>> In preparation for supporting LPIs we introduce reference counting for
>> those structures using the kernel's kref infrastructure.
>> Since private IRQs and SPIs are statically allocated, the refcount never
>> drops to 0 at the moment, but we increase it when an IRQ gets onto a VCPU
>> list and decrease it when it gets removed.
>> This introduces vgic_put_irq(), which wraps kref_put and hides the
>> release function from the callers.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/arm_vgic.h           |  1 +
>>  virt/kvm/arm/vgic/vgic-init.c    |  2 ++
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  8 ++++++
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 20 +++++++++------
>>  virt/kvm/arm/vgic/vgic-mmio.c    | 25 ++++++++++++++++++-
>>  virt/kvm/arm/vgic/vgic-v2.c      |  1 +
>>  virt/kvm/arm/vgic/vgic-v3.c      |  1 +
>>  virt/kvm/arm/vgic/vgic.c         | 53 ++++++++++++++++++++++++++++++++--------
>>  virt/kvm/arm/vgic/vgic.h         |  1 +
>>  9 files changed, 94 insertions(+), 18 deletions(-)
> 
> [...]
> 
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -48,13 +48,20 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
>>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>  			      u32 intid)
>>  {
>> -	/* SGIs and PPIs */
>> -	if (intid <= VGIC_MAX_PRIVATE)
>> -		return &vcpu->arch.vgic_cpu.private_irqs[intid];
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	struct vgic_irq *irq;
>>  
>> -	/* SPIs */
>> -	if (intid <= VGIC_MAX_SPI)
>> -		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
>> +	if (intid <= VGIC_MAX_PRIVATE) {        /* SGIs and PPIs */
>> +		irq = &vcpu->arch.vgic_cpu.private_irqs[intid];
>> +		kref_get(&irq->refcount);
>> +		return irq;
>> +	}
>> +
>> +	if (intid <= VGIC_MAX_SPI) {            /* SPIs */
>> +		irq = &dist->spis[intid - VGIC_NR_PRIVATE_IRQS];
>> +		kref_get(&irq->refcount);
>> +		return irq;
>> +	}
> 
> I'm a bit concerned by the fact that we perform the refcounting on 
> objects that shouldn't be concerned by it. None of the static interrupts
> should have to suffer from the overhead, as they cannot be freed. 
> So I came up with the following patch:
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index c7cd1a3..6bbff9a 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -91,19 +91,12 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> -	struct vgic_irq *irq;
>  
> -	if (intid <= VGIC_MAX_PRIVATE) {        /* SGIs and PPIs */
> -		irq = &vcpu->arch.vgic_cpu.private_irqs[intid];
> -		kref_get(&irq->refcount);
> -		return irq;
> -	}
> +	if (intid <= VGIC_MAX_PRIVATE)		/* SGIs and PPIs */
> +		return &vcpu->arch.vgic_cpu.private_irqs[intid];
>  
> -	if (intid <= VGIC_MAX_SPI) {            /* SPIs */
> -		irq = &dist->spis[intid - VGIC_NR_PRIVATE_IRQS];
> -		kref_get(&irq->refcount);
> -		return irq;
> -	}
> +	if (intid <= VGIC_MAX_SPI)		/* SPIs */
> +		return &dist->spis[intid - VGIC_NR_PRIVATE_IRQS];
>  
>  	if (intid >= VGIC_MIN_LPI)		/* LPIs */
>  		return vgic_get_lpi(kvm, intid);
> @@ -112,6 +105,14 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  	return NULL;
>  }
>  
> +static void vgic_get_irq_kref(struct vgic_irq *irq)
> +{
> +	if (irq->intid < VGIC_MIN_LPI)
> +		return;
> +
> +	kref_get(&irq->refcount);
> +}
> +
>  /*
>   * We can't do anything in here, because we lack the kvm pointer to
>   * lock and remove the item from the lpi_list. So we keep this function
> @@ -125,10 +126,10 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  {
>  	struct vgic_dist *dist;
>  
> -	if (!kref_put(&irq->refcount, vgic_irq_release))
> +	if (irq->intid < VGIC_MIN_LPI)
>  		return;
>  
> -	if (irq->intid < VGIC_MIN_LPI)
> +	if (!kref_put(&irq->refcount, vgic_irq_release))
>  		return;
>  
>  	dist = &kvm->arch.vgic;
> @@ -313,7 +314,11 @@ retry:
>  		goto retry;
>  	}
>  
> -	kref_get(&irq->refcount);
> +	/*
> +	 * Grab a reference to the irq to reflect the fact that it is
> +	 * now in the ap_list.
> +	 */
> +	vgic_get_irq_kref(irq);
>  	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
>  	irq->vcpu = vcpu;
>  
> @@ -473,8 +478,11 @@ retry:
>  			spin_unlock(&irq->irq_lock);
>  
>  			/*
> -			 * This put matches the get when we added the LPI to
> -			 * the ap_list. We now drop the reference from the list.
> +			 * This vgic_put_irq call matches the
> +			 * vgic_get_irq_kref in vgic_queue_irq_unlock,
> +			 * where we added the LPI to the ap_list. As
> +			 * we remove the irq from the list, we drop
> +			 * also drop the refcount.
>  			 */
>  			vgic_put_irq(vcpu->kvm, irq);
>  			continue;
> 
> Thoughts?

Looks good to me, I checked the code and quickly tested it as well,
without any issues.
I'd integrate this in next respin.

Thanks!
Andre.
