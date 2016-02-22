From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: next-20160222 build: 5 failures 9 warnings (next-20160222)
Date: Mon, 22 Feb 2016 12:00:40 +0000
Message-ID: <56CAF868.5020406@arm.com>
References: <E1aXlz4-000486-Pb@optimist>
 <20160222100832.GX18327@sirena.org.uk> <56CAE5E6.7030707@arm.com>
 <20160222115243.GA5779@e106950-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20160222115243.GA5779@e106950-lin.cambridge.arm.com>
Sender: linux-next-owner@vger.kernel.org
To: Brian Starkey <brian.starkey@arm.com>
Cc: Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linaro-kernel@lists.linaro.org, kvmarm@lists.cs.columbia.edu, linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-build-reports@lists.linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/02/16 11:52, Brian Starkey wrote:
> Hi Mark,
> 
> On Mon, Feb 22, 2016 at 10:41:42AM +0000, Marc Zyngier wrote:
>> I'm about to push the following patch on top of the KVM tree:
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 43688d9..31fe7d6 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -333,11 +333,6 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
>> 		     hyp_stack_ptr, vector_ptr);
>> }
>>
>> -static inline void __cpu_init_stage2(void)
>> -{
>> -	kvm_call_hyp(__init_stage2_translation);
>> -}
>> -
>> static inline void kvm_arch_hardware_disable(void) {}
>> static inline void kvm_arch_hardware_unsetup(void) {}
>> static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>> @@ -349,4 +344,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>> void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>> void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
>>
>> +/* #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__) */
>> +
>> +static inline void __cpu_init_stage2(void)
>> +{
>> +	kvm_call_hyp(__init_stage2_translation);
>> +}
>> +
>> #endif /* __ARM64_KVM_HOST_H__ */
>>
>> This will create a new conflict, but will make the resolution 100% clear.
> 
> I applied this, but arm64 defconfig wouldn't build until I uncommented
> the '#define kvm_call_hyp(...' line.
> 
> Is that right?

This patch is intended as a merge indication so that when you do the
merge with the arm64 tree, it conflicts and you can resolve it by going
the right thing (merging the non-comment version of this line).

So yes, uncommenting it is the right thing to do.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
