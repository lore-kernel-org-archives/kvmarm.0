From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Tue, 1 Sep 2015 14:52:15 +0100
Message-ID: <55E5AD8F.80304@arm.com>
References: <cover.1440766141.git.p.fedin@samsung.com>
 <cb311e13e56311c535362f32177313850c51af66.1440766141.git.p.fedin@samsung.com>
 <20150830164237.GD24113@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150830164237.GD24113@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Pavel Fedin <p.fedin@samsung.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

...

>> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
>> index e661e7f..b3847e1 100644
>> --- a/virt/kvm/arm/vgic-v3-emul.c
>> +++ b/virt/kvm/arm/vgic-v3-emul.c
...
>> @@ -1000,40 +1102,95 @@ static void vgic_v3_destroy(struct kvm_device *dev)
>>  	kfree(dev);
>>  }
>>  
>> +static u32 vgic_v3_get_reg_size(struct kvm_device_attr *attr)
>> +{
>> +	u32 offset;
>> +
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>> +		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
>> +		if (offset >= GICD_IROUTER && offset <= 0x7FD8)
> 
> eh, 0x7FD8 ?
> 
>> +			return 8;
>> +		else
>> +			return 4;
>> +		break;
>> +
>> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
>> +		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
>> +		if ((offset == GICR_TYPER) ||
>> +		    (offset >= GICR_SETLPIR && offset <= GICR_INVALLR))
>> +			return 8;
>> +		else
>> +			return 4;
>> +		break;
>> +
>> +	default:
>> +		return -ENXIO;
>> +	}
>> +}
> 
> this feels wrong.

I agree on this, actually I consider this dangerous. Currently the
memory behind addr in QEMU (hw/intc/arm_gic_kvm.c:kvm_arm_gic_get() for
instance) is only uint32_t, so you have to take care to provide uint64_t
backing for those registers, which means that there must be a match
between the register size the kernel knows and the size userland thinks
of. So I'd rather see the access size controlled by userland, probably
using Christoffer's suggestion below.

Also the GIC specification says that everything must be accessible with
32-bit accesses. Correct me if I am wrong on this, but vCPUs are not
supposed to run while you are getting/setting VGIC registers, right? So
there shouldn't be any issues with non-atomic accesses to 64-bit
registers, which means you could just go ahead and do everything in
32-bit only. This would also help with supporting 32-bit userland and/or
kernel later.

Cheers,
Andre.
