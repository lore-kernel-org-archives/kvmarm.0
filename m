From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 6/9] KVM: arm/arm64: Introduce an allocator for
 in-kernel irq lines
Date: Thu, 8 Jun 2017 16:09:31 +0100
Message-ID: <125804d9-8022-cb4a-deac-84d1b144f486@arm.com>
References: <20170608133446.3875-1-cdall@linaro.org>
 <20170608133446.3875-7-cdall@linaro.org> <87bmpyine0.fsf@arm.com>
 <20170608145938.GA6378@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E153D40A66
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 11:05:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l+BSBAS6FzBE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 11:05:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4B8405DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 11:05:25 -0400 (EDT)
In-Reply-To: <20170608145938.GA6378@cbox>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/06/17 15:59, Christoffer Dall wrote:
> On Thu, Jun 08, 2017 at 03:07:19PM +0100, Marc Zyngier wrote:
>> On Thu, Jun 08 2017 at  3:34:43 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
>>> Having multiple devices being able to signal the same interrupt line is
>>> very confusing and almost certainly guarantees a configuration error.
>>>
>>> Therefore, introduce a very simple allocator which allows a device to
>>> claim an interrupt line from the vgic for a given VM.
>>>
>>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
>>> ---
>>>  include/kvm/arm_vgic.h   |  5 +++++
>>>  virt/kvm/arm/vgic/vgic.c | 33 +++++++++++++++++++++++++++++++++
>>>  2 files changed, 38 insertions(+)
>>>
>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>> index dde59fb..5d5b345 100644
>>> --- a/include/kvm/arm_vgic.h
>>> +++ b/include/kvm/arm_vgic.h
>>> @@ -121,6 +121,9 @@ struct vgic_irq {
>>>  	u8 source;			/* GICv2 SGIs only */
>>>  	u8 priority;
>>>  	enum vgic_irq_config config;	/* Level or edge */
>>> +
>>> +	void *owner;			/* Opaque pointer to reserve an interrupt
>>> +					   for in-kernel devices. */
>>>  };
>>>  
>>>  struct vgic_register_region;
>>> @@ -340,4 +343,6 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
>>>   */
>>>  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
>>>  
>>> +int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner);
>>> +
>>>  #endif /* __KVM_ARM_VGIC_H */
>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>>> index c66feac..9628945 100644
>>> --- a/virt/kvm/arm/vgic/vgic.c
>>> +++ b/virt/kvm/arm/vgic/vgic.c
>>> @@ -435,6 +435,39 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>>>  }
>>>  
>>>  /**
>>> + * kvm_vgic_set_owner - Set the owner of an interrupt for a VM
>>> + *
>>> + * @vcpu:   Pointer to the VCPU (used for PPIs)
>>> + * @intid:  The virtual INTID identifying the interrupt (PPI or SPI)
>>> + * @owner:  Opaque pointer to the owner
>>> + *
>>> + * Returns 0 if intid is not already used by another in-kernel device and the
>>> + * owner is set, otherwise returns an error code.
>>> + */
>>> +int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
>>> +{
>>> +	struct vgic_irq *irq;
>>> +	int ret = 0;
>>> +
>>> +	if (!vgic_initialized(vcpu->kvm))
>>> +		return -EAGAIN;
>>> +
>>> +	/* SGIs and LPIs cannot be wired up to any device */
>>> +	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
>>> +		return -EINVAL;
>>> +
>>> +	irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
>>> +	spin_lock(&irq->irq_lock);
>>> +	if (irq->owner && irq->owner != owner)
>>> +		ret = -EEXIST;
>>> +	else
>>> +		irq->owner = owner;
>>
>> Is there any case where you'd end-up setting the owner multiple times?
>> Or is that just convenient?
>>
> 
> I think the timer code ended up doing that in some sequence, but maybe
> not.  In any case, I'm not sure if it makes much of a difference?

None whatsoever.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
