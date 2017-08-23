From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 5/8] KVM: arm/arm64: vgic: Handle mapped level
 sensitive SPIs
Date: Wed, 23 Aug 2017 09:25:01 +0200
Message-ID: <48c358da-45fe-5348-28a9-41107409345c@redhat.com>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-6-git-send-email-eric.auger@redhat.com>
 <f21e17b7-9437-ca96-6847-91e7ecee3af4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f21e17b7-9437-ca96-6847-91e7ecee3af4@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, christoffer.dall@linaro.org
Cc: drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 04/07/2017 14:15, Marc Zyngier wrote:
> Hi Eric,
> 
> On 15/06/17 13:52, Eric Auger wrote:
>> Currently, the line level of unmapped level sensitive SPIs is
>> toggled down by the maintenance IRQ handler/resamplefd mechanism.
>>
>> As mapped SPI completion is not trapped, we cannot rely on this
>> mechanism and the line level needs to be observed at distributor
>> level instead.
>>
>> This patch handles the physical IRQ case in vgic_validate_injection
>> and get the line level of a mapped SPI at distributor level.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v1 -> v2:
>> - renamed is_unshared_mapped into is_mapped_spi
>> - changes to kvm_vgic_map_phys_irq moved in the previous patch
>> - make vgic_validate_injection more readable
>> - reword the commit message
>> ---
>>  virt/kvm/arm/vgic/vgic.c | 16 ++++++++++++++--
>>  virt/kvm/arm/vgic/vgic.h |  7 ++++++-
>>  2 files changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index 075f073..2e35ac7 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -139,6 +139,17 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>>  	kfree(irq);
>>  }
>>  
>> +bool irq_line_level(struct vgic_irq *irq)
>> +{
>> +	bool line_level = irq->line_level;
>> +
>> +	if (unlikely(is_mapped_spi(irq)))
>> +		WARN_ON(irq_get_irqchip_state(irq->host_irq,
>> +					      IRQCHIP_STATE_PENDING,
>> +					      &line_level));
>> +	return line_level;
>> +}
>> +
>>  /**
>>   * kvm_vgic_target_oracle - compute the target vcpu for an irq
>>   *
>> @@ -236,13 +247,14 @@ static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
>>  
>>  /*
>>   * Only valid injection if changing level for level-triggered IRQs or for a
>> - * rising edge.
>> + * rising edge. Injection of virtual interrupts associated to physical
>> + * interrupts always is valid.
>>   */
>>  static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
>>  {
>>  	switch (irq->config) {
>>  	case VGIC_CONFIG_LEVEL:
>> -		return irq->line_level != level;
>> +		return (irq->line_level != level || unlikely(is_mapped_spi(irq)));
>>  	case VGIC_CONFIG_EDGE:
>>  		return level;
>>  	}
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index bba7fa2..da254ae 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -96,14 +96,19 @@
>>  /* we only support 64 kB translation table page size */
>>  #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
>>  
>> +bool irq_line_level(struct vgic_irq *irq);
>> +
>>  static inline bool irq_is_pending(struct vgic_irq *irq)
>>  {
>>  	if (irq->config == VGIC_CONFIG_EDGE)
>>  		return irq->pending_latch;
>>  	else
>> -		return irq->pending_latch || irq->line_level;
>> +		return irq->pending_latch || irq_line_level(irq);
> 
> I'm a bit concerned that an edge interrupt doesn't take the distributor
> state into account here. Why is that so? Once an SPI is forwarded to a
> guest, a large part of the edge vs level differences move into the HW,
> and are not that different anymore from a SW PoV.

As mentioned by Christoffer, When a physically mapped edge sensitive
vSPI is pending (irq->pending_latch set), the physical state can be
active or pending & active and maybe pending? (if the guest has
completed the vSPI and we have not folded the LR and a new pSPI
triggered). That's a real mess. Assuming I propagate the pending latch
to the pDIST do we really have an issue with state inconsistency?


So I would tend to think:
- I need to fix the issue of ISPENDRn/ICPENDRn and propagate the pending
state to the pDIST on those guest writes.
- Then raises the question of the save/restore (uaccess) of a physically
mapped SPI. I guess we should never try to save/restore state of a
physically mapped SPI?
- I need to prevent the lazy disable approach

Thoughts?

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
