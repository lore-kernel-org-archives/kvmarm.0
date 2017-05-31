From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 17/31] KVM: arm64: vgic-v3: Enable trapping of Group-1
 system registers
Date: Wed, 31 May 2017 08:43:12 +0200
Message-ID: <fb99e0dd-c4ae-98b5-a46a-90f78120535d@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-18-marc.zyngier@arm.com>
 <bf094e11-1555-a1bf-5655-9093867adb90@redhat.com>
 <47409634-110c-eb5c-1bbc-2ee9dea4f3d4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <47409634-110c-eb5c-1bbc-2ee9dea4f3d4@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 30/05/2017 16:32, Marc Zyngier wrote:
> On 30/05/17 10:07, Auger Eric wrote:
>> Hi Marc,
>>
>> On 03/05/2017 12:45, Marc Zyngier wrote:
>>> In order to be able to trap Group-1 GICv3 system registers, we need to
>>> set ICH_HCR_EL2.TALL1 begore entering the guest. This is conditionnaly
>> before, conditionally
>>> done after having restored the guest's state, and cleared on exit.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  include/linux/irqchip/arm-gic-v3.h | 1 +
>>>  virt/kvm/arm/hyp/vgic-v3-sr.c      | 7 +++++++
>>>  virt/kvm/arm/vgic/vgic-v3.c        | 4 ++++
>>>  3 files changed, 12 insertions(+)
>>>
>>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>>> index c56d9bc2c904..a1739843343e 100644
>>> --- a/include/linux/irqchip/arm-gic-v3.h
>>> +++ b/include/linux/irqchip/arm-gic-v3.h
>>> @@ -403,6 +403,7 @@
>>>  
>>>  #define ICH_HCR_EN			(1 << 0)
>>>  #define ICH_HCR_UIE			(1 << 1)
>>> +#define ICH_HCR_TALL1			(1 << 12)
>>>  #define ICH_HCR_EOIcount_SHIFT		27
>>>  #define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
>>>  
>>> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
>>> index a521e105ade1..a27671b1e9af 100644
>>> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
>>> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
>>> @@ -257,6 +257,9 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>>>  			cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
>>>  		}
>>>  	} else {
>>> +		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
>>> +			write_gicreg(0, ICH_HCR_EL2);
>> Not directly related to this patch but this is not obvious to me why we
>> reset the ICH_HCR_EL2 only when used_lrs != 0.
> 
> That's because if there is no interrupt to inject, then we've never
> enabled the virtual CPU interface, and we've only configured VMCR.
> 
>>> +
>>>  		cpu_if->vgic_elrsr = 0xffff;
>>>  		cpu_if->vgic_ap0r[0] = 0;
>>>  		cpu_if->vgic_ap0r[1] = 0;
>>> @@ -329,6 +332,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>>>  
>>>  		for (i = 0; i < used_lrs; i++)
>>>  			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
>>> +	} else {
>>> +		/* Always write ICH_HCR_EL2 to enable trapping */
>> "always" is a bit weird as this is conditional
> 
> Ah, true. How about:
> 		/*
>                  * If we don't have any interrupt to inject, but that
> 		 * trapping is enabled, write the ICH_HCR_EL2 config.
> 		 */
yes thanks
> 
>>> +		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
>>> +			write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
>> and same question here. Why don't we always restore the ICH_HCR_EL2.
>> Assuming when exiting the guest the vCPU I/F was enabled and used_lrs=0,
> 
> That case doesn't exist. The only case where we enable the virtual cpuif
> is when we have something to inject (hence used_lrs != 0).

I got it. Thanks for the explanation.

Eric
> 
>> when restoring don't we leave the vCPU I/F disabled? I must miss
>> something but I don't find who is re-enabling the vCPU I/F in that case?
> 
> See above. This case shouldn't exist, and is only introduced here for
> the benefit of the trapping.
> 
>>>  	}
>>>  
>>>  	/*
>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>>> index 063526443781..547b8374fb64 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>>> @@ -21,6 +21,8 @@
>>>  
>>>  #include "vgic.h"
>>>  
>>> +static bool group1_trap;
>>> +
>>>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
>>> @@ -239,6 +241,8 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>>>  
>>>  	/* Get the show on the road... */
>>>  	vgic_v3->vgic_hcr = ICH_HCR_EN;
>>> +	if (group1_trap)
>> I don't remember the rationale behind using the bool here and using
>> static_branch_unlikely in the other cases.
> 
> That's just the initial config path, before setting the static key.
> 
>>
>> May be good to squash the next patch to understand how group1_trap is set.
> 
> Sure, I'll have a look at that.
> 
> Thanks,
> 
> 	M.
> 
