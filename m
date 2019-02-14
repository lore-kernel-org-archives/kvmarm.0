From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v5 3/5] arm64/kvm: context-switch ptrauth registers
Date: Thu, 14 Feb 2019 16:36:27 +0530
Message-ID: <ee8669f7-5c3d-ada3-49f2-0c9b37559553@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-4-git-send-email-amit.kachhap@arm.com>
 <0a2df488-a80d-ef08-6241-7f4695f2a578@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0a2df488-a80d-ef08-6241-7f4695f2a578@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2/13/19 11:04 PM, Kristina Martsenko wrote:
> Hi Amit,
> 
> (Please always Cc: everyone who commented on previous versions of the
> series.)
> 
> On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
>> When pointer authentication is supported, a guest may wish to use it.
>> This patch adds the necessary KVM infrastructure for this to work, with
>> a semi-lazy context switch of the pointer auth state.
>>
>> Pointer authentication feature is only enabled when VHE is built
>> into the kernel and present into CPU implementation so only VHE code
>> paths are modified.
>>
>> When we schedule a vcpu, we disable guest usage of pointer
>> authentication instructions and accesses to the keys. While these are
>> disabled, we avoid context-switching the keys. When we trap the guest
>> trying to use pointer authentication functionality, we change to eagerly
>> context-switching the keys, and enable the feature. The next time the
>> vcpu is scheduled out/in, we start again.
>>
>> Pointer authentication consists of address authentication and generic
>> authentication, and CPUs in a system might have varied support for
>> either. Where support for either feature is not uniform, it is hidden
>> from guests via ID register emulation, as a result of the cpufeature
>> framework in the host.
>>
>> Unfortunately, address authentication and generic authentication cannot
>> be trapped separately, as the architecture provides a single EL2 trap
>> covering both. If we wish to expose one without the other, we cannot
>> prevent a (badly-written) guest from intermittently using a feature
>> which is not uniformly supported (when scheduled on a physical CPU which
>> supports the relevant feature). When the guest is scheduled on a
>> physical CPU lacking the feature, these attempts will result in an UNDEF
>> being taken by the guest.
> 
> [...]
> 
>>   /*
>> + * Handle the guest trying to use a ptrauth instruction, or trying to access a
>> + * ptrauth register.
>> + */
>> +void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
>> +{
>> +	if (has_vhe() && kvm_supports_ptrauth())
>> +		kvm_arm_vcpu_ptrauth_enable(vcpu);
>> +	else
>> +		kvm_inject_undefined(vcpu);
>> +}
>> +
>> +/*
>>    * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
>> - * a NOP).
>> + * a NOP), or guest EL1 access to a ptrauth register.
> 
> Doesn't guest EL1 access of ptrauth registers go through trap_ptrauth
> instead?
Yes you are right.
> 
>>    */
>>   static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   {
>> -	/*
>> -	 * We don't currently support ptrauth in a guest, and we mask the ID
>> -	 * registers to prevent well-behaved guests from trying to make use of
>> -	 * it.
>> -	 *
>> -	 * Inject an UNDEF, as if the feature really isn't present.
>> -	 */
>> -	kvm_inject_undefined(vcpu);
>> +	kvm_arm_vcpu_ptrauth_trap(vcpu);
>>   	return 1;
>>   }
>>   
> 
> [...]
> 
>> +static __always_inline bool __hyp_text __ptrauth_is_enabled(struct kvm_vcpu *vcpu)
>> +{
>> +	return IS_ENABLED(CONFIG_ARM64_PTR_AUTH) &&
>> +			vcpu->arch.ctxt.hcr_el2 & (HCR_API | HCR_APK);
>> +}
>> +
>> +void __no_ptrauth __hyp_text __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
>> +					  struct kvm_cpu_context *host_ctxt,
>> +					  struct kvm_cpu_context *guest_ctxt)
>> +{
>> +	if (!__ptrauth_is_enabled(vcpu))
>> +		return;
>> +
>> +	ptrauth_keys_store((struct ptrauth_keys *) &host_ctxt->sys_regs[APIAKEYLO_EL1]);
>> +	ptrauth_keys_switch((struct ptrauth_keys *) &guest_ctxt->sys_regs[APIAKEYLO_EL1]);
>> +}
>> +
>> +void __no_ptrauth __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
> 
> We don't call this code in the !VHE case anymore, so are the __hyp_text
> annotations still needed?
Yes they can be removed.
> 
>> +					 struct kvm_cpu_context *host_ctxt,
>> +					 struct kvm_cpu_context *guest_ctxt)
>> +{
>> +	if (!__ptrauth_is_enabled(vcpu))
>> +		return;
>> +
>> +	ptrauth_keys_store((struct ptrauth_keys *) &guest_ctxt->sys_regs[APIAKEYLO_EL1]);
>> +	ptrauth_keys_switch((struct ptrauth_keys *) &host_ctxt->sys_regs[APIAKEYLO_EL1]);
>> +}
> 
> [...]
> 
>> @@ -1040,14 +1066,6 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
>>   			kvm_debug("SVE unsupported for guests, suppressing\n");
>>   
>>   		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
>> -	} else if (id == SYS_ID_AA64ISAR1_EL1) {
>> -		const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
>> -					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
>> -					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
>> -					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
>> -		if (val & ptrauth_mask)
>> -			kvm_debug("ptrauth unsupported for guests, suppressing\n");
>> -		val &= ~ptrauth_mask;
> 
> If all CPUs support address authentication, but no CPUs support generic
> authentication, then I think the guest will still see address auth in
> the ID register and try to use it, but since kvm_supports_ptrauth() ==
> false, then kvm will enable trapping and inject an undef. So I think we
> still need to zero the ID register bits here if !kvm_supports_ptrauth().
Yes even James Morse suggested same thing.
> 
> In the following patch, I think we also need to zero the bits if
> !kvm_arm_vcpu_ptrauth_allowed(), as done in v4 [1], because otherwise
> the guest will see that ptrauth is available, but will receive an undef
> when it tries to use it.
ok.
> 
> Regarding the patch in v4, most of the work is passing the vcpu down to
> read_id_reg(). Dave has a similar patch in his SVE series [2]. I think
> it might make sense to rebase onto that patch and mention that patch as
> a dependency in the cover letter.
Yes it is helpful. Will check it.

//Amit D
> 
> [1] https://lore.kernel.org/linux-arm-kernel/1545119810-12182-5-git-send-email-amit.kachhap@arm.com/
> [2] https://lore.kernel.org/linux-arm-kernel/1547757219-19439-11-git-send-email-Dave.Martin@arm.com/
> 
> Thanks,
> Kristina
> 
