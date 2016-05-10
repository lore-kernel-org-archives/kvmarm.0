From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 11/55] KVM: arm/arm64: pmu: abstract access to number
 of SPIs
Date: Tue, 10 May 2016 11:04:12 +0100
Message-ID: <5731B21C.9030205@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-12-git-send-email-andre.przywara@arm.com>
 <5731AF57.2040707@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5731AF57.2040707@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/05/16 10:52, Eric Auger wrote:
> Hi Andre,
> On 05/06/2016 12:45 PM, Andre Przywara wrote:
>> Currently the PMU uses a member of the struct vgic_dist directly,
>> which not only breaks abstraction, but will fail with the new VGIC.
>> Abstract this access in the VGIC header file.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/arm_vgic.h | 2 ++
>>  virt/kvm/arm/pmu.c     | 2 +-
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 452bb85..c14ff77 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -347,6 +347,8 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
>>  #define vgic_ready(k)		((k)->arch.vgic.ready)
>> +#define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
>> +				 ((i) < (k)->arch.vgic.nr_irqs))
>>  
>>  int vgic_v2_probe(struct device_node *vgic_node,
>>  		  const struct vgic_ops **ops,
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> index 575c7aa..bd2e872 100644
>> --- a/virt/kvm/arm/pmu.c
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -477,7 +477,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>>  		 * the interrupt number is the same for all vcpus, while as an
>>  		 * SPI it must be a separate number per vcpu.
>>  		 */
>> -		if (irq < VGIC_NR_SGIS || irq >= vcpu->kvm->arch.vgic.nr_irqs ||
>> +		if (irq < VGIC_NR_SGIS || !vgic_valid_spi(vcpu->kvm, irq) ||
>>  		    !irq_is_valid(vcpu->kvm, irq, irq < VGIC_NR_PRIVATE_IRQS))
>>  			return -EINVAL;
>>  
>>
> in case this is a PPI it will now return an error, right? I don't think
> this is what we expect.

Ouch. Good catch. I missed the ! too...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
