From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH 3/3] arm: KVM: Add VFP lazy switch hooks in Host KVM
Date: Mon, 06 Jul 2015 11:35:56 -0700
Message-ID: <559ACA8C.3080308@samsung.com>
References: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
 <1435203028-23142-4-git-send-email-m.smarduch@samsung.com>
 <20150705193745.GC3869@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150705193745.GC3869@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, pbonzini@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 07/05/2015 12:37 PM, Christoffer Dall wrote:
> On Wed, Jun 24, 2015 at 08:30:28PM -0700, Mario Smarduch wrote:
>> This patch implements host KVM interface to Hyp mode VFP function to 
>> switch out guest and switch in host.
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm/kvm/arm.c |   15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index d9631ec..77b41f5 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -105,6 +105,17 @@ void kvm_arch_check_processor_compat(void *rtn)
>>  	*(int *)rtn = 0;
>>  }
>>  
>> +/**
>> + * kvm_switch_vp_regs() - switch guest/host VFP registers
>> + * @vcpu:	pointer to vcpu structure.
>> + *
>> + * HYP interface functions to save guest and restore host VFP registers
> 
> Not sure I understand what you mean to say with this line, how about:
> 
> Calls an assembly routine in HYP mode to actually perform the state
> save/restore.
> 
> However, why do we actually need to do this in hyp mode?  Can't we just
> as well do this in SVC mode or are we changing some trap settings here?

Yes it should be since non hyp registers are accessed.
I reuse it since all the code was there to do the switch.

> 
>> + */
>> +static void kvm_switch_fp_regs(struct kvm_vcpu *vcpu)
> 
> should probalby be called kvm_vcpu_put_fp_regs
> 
>> +{
>> +	if (vcpu->arch.vfp_guest_saved == 1)
>> +		kvm_call_hyp(__kvm_restore_host_vfp_state, vcpu);
>> +}
>>  
>>  /**
>>   * kvm_arch_init_vm - initializes a VM data structure
>> @@ -292,6 +303,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>  
>>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  {
>> +
>> +	/* Check if Guest accessed VFP registers */
>> +	kvm_switch_fp_regs(vcpu);
>> +
>>  	/*
>>  	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
>>  	 * if the vcpu is no longer assigned to a cpu.  This is used for the
>> -- 
>> 1.7.9.5
> 
> How are we sure that the kernel never touches VFP registers between VCPU
> exit and kvm_arch_vcpu_put?  Can a kernel-side memcpy implementation use
> the FP regs or something like that?

Exceptions, interrupts - don't save any VFP context, if
these VFP registers are touched by the kernel they should
be saved/restored. The x86 version appears to the same.

> 
> Thanks,
> -Christoffer
> 

