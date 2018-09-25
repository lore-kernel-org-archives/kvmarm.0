From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 14/18] vgic: Add support for 52bit guest physical
 address
Date: Tue, 25 Sep 2018 11:49:19 +0100
Message-ID: <79adfcd4-cab0-cc29-5c12-ffcad325be70@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-15-suzuki.poulose@arm.com>
 <e308a66d-c426-81c0-0c79-ce97773fa090@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e308a66d-c426-81c0-0c79-ce97773fa090@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric

On 09/21/2018 03:57 PM, Auger Eric wrote:
> Hi Suzuki,
> 
> On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
>> From: Kristina Martsenko <kristina.martsenko@arm.com>
>>
>> Add support for handling 52bit guest physical address to the
>> VGIC layer. So far we have limited the guest physical address
>> to 48bits, by explicitly masking the upper bits. This patch
>> removes the restriction. We do not have to check if the host
>> supports 52bit as the gpa is always validated during an access.
>> (e.g, kvm_{read/write}_guest, kvm_is_visible_gfn()).
>> Also, the ITS table save-restore is also not affected with
>> the enhancement. The DTE entries already store the bits[51:8]
>> of the ITT_addr (with a 256byte alignment).
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <cdall@kernel.org>
>> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
>> [ Macro clean ups, fix PROPBASER and PENDBASER accesses ]
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   include/linux/irqchip/arm-gic-v3.h |  5 +++++
>>   virt/kvm/arm/vgic/vgic-its.c       | 36 +++++++++---------------------
>>   virt/kvm/arm/vgic/vgic-mmio-v3.c   |  2 --
>>   3 files changed, 15 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index 8bdbb5f29494..e961f40992d7 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -357,6 +357,8 @@
>>   #define GITS_CBASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWt)
>>   #define GITS_CBASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWb)
>>   
>> +#define GITS_CBASER_ADDRESS(cbaser)	((cbaser) & GENMASK_ULL(52, 12))
> nit GENMASK_ULL(51, 12), bit 52 is RES0

I will fix this.

>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index a2a175b08b17..b3d1f0985117 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -364,7 +364,6 @@ static u64 vgic_sanitise_pendbaser(u64 reg)
>>   				  vgic_sanitise_outer_an);
>>   
>>   	reg &= ~PENDBASER_RES0_MASK;
>> -	reg &= ~GENMASK_ULL(51, 48);
>>   
>>   	return reg;
>>   }
>> @@ -382,7 +381,6 @@ static u64 vgic_sanitise_propbaser(u64 reg)
>>   				  vgic_sanitise_outer_cacheability);
>>   
>>   	reg &= ~PROPBASER_RES0_MASK;
>> -	reg &= ~GENMASK_ULL(51, 48);
>>   	return reg;
>>   }
>>   
>>
> Besides looks good to me.
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks
Suzuki
