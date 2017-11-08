From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 13/26] KVM: arm/arm64: GICv4: Propagate affinity
 changes to the physical ITS
Date: Wed, 8 Nov 2017 12:05:21 +0000
Message-ID: <cc8aac2e-3b13-b6e4-97de-ecf16bbf6283@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-14-marc.zyngier@arm.com>
 <52c64fa1-f662-2703-53c5-d2024ef12254@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52c64fa1-f662-2703-53c5-d2024ef12254@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/11/17 21:01, Auger Eric wrote:
> Hi Marc,
> 
> On 27/10/2017 16:28, Marc Zyngier wrote:
>> When the guest issues an affinity change, we need to tell the physical
>> ITS that we're now targetting a new vcpu.  This is done by extracting
>> the current mapping, updating the target, and reapplying the mapping.
>>
>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index c9b1c0967426..42ffb9084bb7 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -337,11 +337,25 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
>>  
>>  static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
>>  {
>> +	int ret = 0;
>> +
>>  	spin_lock(&irq->irq_lock);
>>  	irq->target_vcpu = vcpu;
>>  	spin_unlock(&irq->irq_lock);
>>  
>> -	return 0;
>> +	if (irq->hw) {
>> +		struct its_vlpi_map map;
>> +
>> +		ret = its_get_vlpi(irq->host_irq, &map);
>> +		if (ret)
>> +			return ret;
>> +
>> +		map.vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>> +
>> +		ret = its_map_vlpi(irq->host_irq, &map);
> Do we check somewhere the virtual LPI ID does not exceed the capacity of
> the VPT. I fail to find that in the irq-gic-v3-its.c driver.

The worse case is that we end-up with a VMAPVI that silently fails, and
the guest doesn't gets its interrupts. The real issue here is that we
don't expose the size of the VPT allocation to the guest. I'll see how
to address this.

> Also in case the hw part fails, should we still have the irq->target_cpu
> set to the new value. In other words shouldn't we first do the hw block
> and upon success set the target_vcpu?

Sure. But given that we'll never use target_vcpu for anything either (we
keep the vlpi mapped), I'm not sure what this gets us...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
