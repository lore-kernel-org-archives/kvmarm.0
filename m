From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 27/56] KVM: arm/arm64: vgic-new: Add ACTIVE registers
 handlers
Date: Thu, 19 May 2016 11:12:55 +0100
Message-ID: <92adb318-35e3-81f0-5d5c-73d1728a4e82@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-28-git-send-email-andre.przywara@arm.com>
 <20160518130139.GG3827@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E72941145
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 06:09:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8O7wEIT7jiAj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2016 06:09:04 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1926410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 06:09:03 -0400 (EDT)
In-Reply-To: <20160518130139.GG3827@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

can you have a quick look below?

On 18/05/16 14:01, Christoffer Dall wrote:
>> +
>> +void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>> +			     gpa_t addr, unsigned int len,
>> +			     unsigned long val)
>> +{
>> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>> +	int i;
>> +
>> +	kvm_arm_halt_guest(vcpu->kvm);
>> +	for_each_set_bit(i, &val, len * 8) {
>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +		spin_lock(&irq->irq_lock);
>> +		/*
>> +		 * If this virtual IRQ was written into a list register, we
>> +		 * have to make sure the CPU that runs the VCPU thread has
>> +		 * synced back LR state to the struct vgic_irq.  We can only
>> +		 * know this for sure, when either this irq is not assigned to
>> +		 * anyone's AP list anymore, or the VCPU thread is not
>> +		 * running on any CPUs.
>> +		 *
>> +		 * In the opposite case, we know the VCPU thread may be on its
>> +		 * way back from the guest and still has to sync back this
>> +		 * IRQ, so we release and re-acquire the spin_lock to let the
>> +		 * other thread sync back the IRQ.
>> +		 */
>> +		while (irq->vcpu && /* IRQ may have state in an LR somewhere */
>> +		       irq->vcpu->cpu != -1) /* VCPU thread is running */
>> +			cond_resched_lock(&irq->irq_lock);
>> +
>> +		irq->active = false;
>> +		spin_unlock(&irq->irq_lock);
>> +	}
>> +	kvm_arm_resume_guest(vcpu->kvm);
>> +}
>> +
>> +void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
>> +			     gpa_t addr, unsigned int len,
>> +			     unsigned long val)
>> +{
>> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>> +	int i;
>> +
>> +	for_each_set_bit(i, &val, len * 8) {
>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		/*
>> +		 * If the IRQ was already active or it was on a VCPU before
>> +		 * or there is no target VCPU assigned at the moment, then
>> +		 * just proceed.
>> +		 */
>> +		if (irq->active || irq->vcpu || !irq->target_vcpu) {
> 
> why is it that we don't care if this IRQ is on a LR, for example being
> just pending and not active, and we thereby loose this active state when
> the vcpu syncs back the state?

Mmmh, good question. I don't remember anymore why this irq->vcpu check
was added.
Marc, can you confirm that this is OK to be removed?
I think it's an optimization anyway.

Thanks,
Andre,

> 
> We care for the case where we clear the active state, but not when we
> set it.  Perhaps we discussed this in the past, but now I've forgotten,
> so that should at least be documented somehow.
> 
>> +			irq->active = true;
>> +
>> +			spin_unlock(&irq->irq_lock);
>> +			continue;
>> +		}
>> +
>> +		irq->active = true;
>> +		vgic_queue_irq_unlock(vcpu->kvm, irq);
> 
> this won't work just yet, but I think all that's needed to make it work
> is this patchlet:
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index c22f7e2..27204f22 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -81,7 +81,7 @@ static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
>  
>  	/* If the interrupt is active, it must stay on the current vcpu */
>  	if (irq->active)
> -		return irq->vcpu;
> +		return irq->vcpu ? : irq->target_vcpu;
>  
>  	/*
>  	 * If the IRQ is not active but enabled and pending, we should direct
> 
> 
> Thanks,
> -Christoffer
> 
