From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v5 2/5] arm64/kvm: preserve host HCR_EL2/MDCR_EL2 value
Date: Thu, 14 Feb 2019 15:19:56 +0530
Message-ID: <89da2a5f-a41b-8847-87be-91b411075677@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-3-git-send-email-amit.kachhap@arm.com>
 <e773a26d-98d1-fc01-5c04-cd5a258d85ec@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e773a26d-98d1-fc01-5c04-cd5a258d85ec@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


Hi James,

Little late in replying as some issue in my mail settings.
On 1/31/19 9:52 PM, James Morse wrote:
> Hi Amit,
> 
> On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
>> When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
>> is a constant value. This works today, as the host HCR_EL2 value is
>> always the same, but this will get in the way of supporting extensions
>> that require HCR_EL2 bits to be set conditionally for the host.
>>
>> To allow such features to work without KVM having to explicitly handle
>> every possible host feature combination, this patch has KVM save/restore
>> the host HCR when switching to/from a guest HCR. The saving of the
>> register is done once during cpu hypervisor initialization state and is
>> just restored after switch from guest.
>>
>> For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
>> kvm_call_hyp and is helpful in NHVE case.
> 
>> For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
>> to toggle the TGE bit with a RMW sequence, as we already do in
>> __tlb_switch_to_guest_vhe().
> 
> 
>> While at it, host MDCR_EL2 value is fetched in a similar way and restored
>> after every switch from host to guest. There should not be any change in
>> functionality due to this.
> 
> Could this step be done as a separate subsequent patch? It would make review
> easier! The MDCR stuff would be a simplification if done second, done in one go
> like this its pretty noisy.
Ok, agree.
> 
> There ought to be some justification for moving hcr/mdcr into the cpu_context in
> the commit message.
ohh I missed adding in commit. Just added in cover letter.
> 
> 
> If you're keeping Mark's 'Signed-off-by' its would be normal to keep Mark as the
> author in git. This shows up a an extra 'From:' when you post the patch, and
> gets picked up when the maintainer runs git-am.
> 
> This patch has changed substantially from Mark's version:
> https://lkml.org/lkml/2017/11/27/675
> 
> If you keep the signed-off-by, could you add a [note] in the signed-off area
> with a terse summary. Something like:
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> [ Move hcr to cpu_context, added __cpu_copy_hyp_conf()]
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> 
> (9c06602b1b92 is a good picked-at-random example for both of these)
Thanks for the information.
> 
> 
>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>> index f5b79e9..2da6e43 100644
>> --- a/arch/arm64/include/asm/kvm_asm.h
>> +++ b/arch/arm64/include/asm/kvm_asm.h
>> @@ -80,6 +80,8 @@ extern void __vgic_v3_init_lrs(void);
>>   
>>   extern u32 __kvm_get_mdcr_el2(void);
>>   
>> +extern u64 __kvm_get_hcr_el2(void);
> 
> Do we need these in separate helpers? For non-vhe this means two separate trips
> to EL2. Something like kvm_populate_host_context(void), and an __ version for
> the bit at EL2?
yes one wrapper for each of them will do.
> 
> We don't need to pass the host-context to EL2 as once kvm is loaded we can
> access host per-cpu variables at EL2 using __hyp_this_cpu_read(). This will save
> passing the vcpu around.
> 
> 
>> @@ -458,6 +457,25 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>   
>>   static inline void __cpu_init_stage2(void) {}
>>   
>> +/**
>> + * __cpu_copy_hyp_conf - copy the boot hyp configuration registers
>> + *
>> + * It is called once per-cpu during CPU hyp initialisation.
>> + */
>> +static inline void __cpu_copy_hyp_conf(void)
>> +{
>> +	kvm_cpu_context_t *host_cxt = this_cpu_ptr(&kvm_host_cpu_state);
>> +
>> +	host_cxt->hcr_el2 = kvm_call_hyp(__kvm_get_hcr_el2);
>> +
>> +	/*
>> +	 * Retrieve the initial value of mdcr_el2 so we can preserve
>> +	 * MDCR_EL2.HPMN which has presumably been set-up by some
>> +	 * knowledgeable bootcode.
>> +	 */
>> +	host_cxt->mdcr_el2 = kvm_call_hyp(__kvm_get_mdcr_el2);
>> +}
> 
> Its strange to make this an inline in a header. kvm_arm_init_debug() is a
> static-inline for arch/arm, but a regular C function for arch/arm64. Can't we do
> the same?
> 
> 
>> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
>> index 68d6f7c..22c854a 100644
>> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
>> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
>> @@ -316,3 +316,14 @@ void __hyp_text __kvm_enable_ssbs(void)
>>   	"msr	sctlr_el2, %0"
>>   	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
>>   }
>> +
>> +/**
>> + * __read_hyp_hcr_el2 - Returns hcr_el2 register value
>> + *
>> + * This function acts as a function handler parameter for kvm_call_hyp and
>> + * may be called from EL1 exception level to fetch the register value.
>> + */
>> +u64 __hyp_text __kvm_get_hcr_el2(void)
>> +{
>> +	return read_sysreg(hcr_el2);
>> +}
> 
> While I'm all in favour of kernel-doc comments for functions, it may be
> over-kill in this case!
> 
> 
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 9e350fd3..2d65ada 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -1327,10 +1327,10 @@ static void cpu_hyp_reinit(void)
>>   	else
>>   		cpu_init_hyp_mode(NULL);
>>   
>> -	kvm_arm_init_debug();
>> -
>>   	if (vgic_present)
>>   		kvm_vgic_init_cpu_hardware();
>> +
>> +	__cpu_copy_hyp_conf();
>>   }
> 
> Was there a reason to make this call later than it originally was?
> (kvm_vgic_init_cpu_hardware() doesn't use any of those values, so its fine, just
> curious!)
Yes. Can be moved before.

//Amit D
> 
> 
> Thanks,
> 
> James
> 
