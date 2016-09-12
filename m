From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 5/8] KVM: arm: vgic: Support 64-bit data manipulation
 on 32-bit host systems
Date: Mon, 12 Sep 2016 10:25:24 +0100
Message-ID: <57D67484.3030604@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-6-git-send-email-vladimir.murzin@arm.com>
 <57D2E96B.70909@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3341D40F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:16:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4B1DEi72CbdX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 05:16:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79BFE40C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:16:46 -0400 (EDT)
In-Reply-To: <57D2E96B.70909@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/09/16 17:55, Marc Zyngier wrote:
> On 08/09/16 17:06, Vladimir Murzin wrote:
>> We have couple of 64-bit registers defined in GICv3 architecture, so
>> unsigned long accesses to these registers will only access a single
>> 32-bit part of that regitser. On the other hand these registers can't
>> be accessed as 64-bit with a single instruction like ldrd/strd or
>> ldmia/stmia if we run a 32-bit host because KVM does not support
>> access to MMIO space done by these instructions.
>>
>> It means that a 32-bit guest accesses these registers in 32-bit
>> chunks, so the only thing we need to do is to ensure that
>> extract_bytes() always takes 64-bit data.
>>
>> Since we are here fix couple of other width related issues catched by
>> gcc
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c |    6 +++---
>>  virt/kvm/arm/vgic/vgic-mmio.h    |    2 +-
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index acbe691..0d3c76a 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -23,7 +23,7 @@
>>  #include "vgic-mmio.h"
>>  
>>  /* extract @num bytes at @offset bytes offset in data */
>> -unsigned long extract_bytes(unsigned long data, unsigned int offset,
>> +unsigned long extract_bytes(u64 data, unsigned int offset,
>>  			    unsigned int num)
>>  {
>>  	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
>> @@ -181,7 +181,7 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>>  	int target_vcpu_id = vcpu->vcpu_id;
>>  	u64 value;
>>  
>> -	value = (mpidr & GENMASK(23, 0)) << 32;
>> +	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
>>  	value |= ((target_vcpu_id & 0xffff) << 8);
>>  	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
>>  		value |= GICR_TYPER_LAST;
>> @@ -611,7 +611,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
>>  	bool broadcast;
>>  
>>  	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
>> -	broadcast = reg & BIT(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
>> +	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
>>  	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
>>  	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
>>  	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
>> index 0b3ecf9..80f92ce 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.h
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
>> @@ -96,7 +96,7 @@ unsigned long vgic_data_mmio_bus_to_host(const void *val, unsigned int len);
>>  void vgic_data_host_to_mmio_bus(void *buf, unsigned int len,
>>  				unsigned long data);
>>  
>> -unsigned long extract_bytes(unsigned long data, unsigned int offset,
>> +unsigned long extract_bytes(u64 data, unsigned int offset,
>>  			    unsigned int num);
>>  
>>  u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
>>
> 
> My personal preference would be to split this in two patches. One that
> changes extract_bytes to work on 64bit quantities, and another one that
> addresses the 64bit issues. Not a big deal though.
> 

Anyway I have to resend, so I'll split it per your preference ;)

> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks!

Vladimir

> Thanks,
> 
> 	M.
> 
