From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: Fix AArch64 guest userspace exception injection
Date: Tue, 12 Jan 2016 18:44:34 +0000
Message-ID: <56954992.7000307@arm.com>
References: <1452157416-9435-1-git-send-email-marc.zyngier@arm.com> <20160112182359.GA5795@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160112182359.GA5795@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hey Drew,

On 12/01/16 18:23, Andrew Jones wrote:
> On Thu, Jan 07, 2016 at 09:03:36AM +0000, Marc Zyngier wrote:
>> At the moment, our fault injection is pretty limited. We always
>> generate a SYNC exception into EL1, as if the fault was actually
>> from EL1h, no matter how it was generated.
>>
>> This is obviously wrong, as EL0 can generate faults of its own
>> (not to mention the pretty-much unused EL1t mode).
>>
>> This patch fixes it by implementing section D1.10.2 of the ARMv8 ARM,
>> and in particular table D1-7 ("Vector offsets from vector table base
>> address"), which describes which vector to use depending on the source
>> exception level and type (synchronous, IRQ, FIQ or SError).
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/inject_fault.c | 38 +++++++++++++++++++++++++++++++++++---
>>  1 file changed, 35 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
>> index 648112e..4d1ac81 100644
>> --- a/arch/arm64/kvm/inject_fault.c
>> +++ b/arch/arm64/kvm/inject_fault.c
>> @@ -27,7 +27,11 @@
>>  
>>  #define PSTATE_FAULT_BITS_64 	(PSR_MODE_EL1h | PSR_A_BIT | PSR_F_BIT | \
>>  				 PSR_I_BIT | PSR_D_BIT)
>> -#define EL1_EXCEPT_SYNC_OFFSET	0x200
>> +
>> +#define CURRENT_EL_SP_EL0_VECTOR	0x0
>> +#define CURRENT_EL_SP_ELx_VECTOR	0x200
>> +#define LOWER_EL_AArch64_VECTOR		0x400
>> +#define LOWER_EL_AArch32_VECTOR		0x600
>>  
>>  static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
>>  {
>> @@ -97,6 +101,34 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
>>  		*fsr = 0x14;
>>  }
>>  
>> +enum exception_type {
>> +	except_type_sync	= 0,
>> +	except_type_irq		= 0x80,
>> +	except_type_fiq		= 0x100,
>> +	except_type_serror	= 0x180,
>> +};
>> +
>> +static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
>> +{
>> +	u64 exc_offset;
>> +
>> +	switch (*vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
>> +	case PSR_MODE_EL1t:
>> +		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
>> +		break;
>> +	case PSR_MODE_EL1h:
>> +		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
>> +		break;
>> +	case PSR_MODE_EL0t:
>> +		exc_offset = LOWER_EL_AArch64_VECTOR;
>> +		break;
>> +	default:
>> +		exc_offset = LOWER_EL_AArch32_VECTOR;
>> +	}
>> +
>> +	return vcpu_sys_reg(vcpu, VBAR_EL1) + exc_offset + type;
>> +}
>> +
>>  static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
>>  {
>>  	unsigned long cpsr = *vcpu_cpsr(vcpu);
>> @@ -108,8 +140,8 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>>  	*vcpu_spsr(vcpu) = cpsr;
>>  	*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
>>  
>> +	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
>>  	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
>> -	*vcpu_pc(vcpu) = vcpu_sys_reg(vcpu, VBAR_EL1) + EL1_EXCEPT_SYNC_OFFSET;
>>  
>>  	vcpu_sys_reg(vcpu, FAR_EL1) = addr;
>>  
>> @@ -143,8 +175,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>>  	*vcpu_spsr(vcpu) = cpsr;
>>  	*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
>>  
>> +	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
>>  	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
>> -	*vcpu_pc(vcpu) = vcpu_sys_reg(vcpu, VBAR_EL1) + EL1_EXCEPT_SYNC_OFFSET;
>>  
>>  	/*
>>  	 * Build an unknown exception, depending on the instruction
> 
> Hi Marc,
> 
> Please shoot me if the following statement is false.

I wouldn't do that. Having had the privilege to waste 10 months of my
life doing a military service, I quickly discovered I didn't like
weapons nor those who carry them...

> Without this patch, if a guest that is running in, e.g. PSR_MODE_EL0t,
> tries to do, e.g. 'smc #0', then KVM will inject an undef exception,
> which should lead to the guest resuming at VBAR_EL1 + 0x400, but instead
> it resumes at VBAR_EL1 + 0x200.

Not quite. SMC is undefined at EL0 (see C6.6.165), so it is not trapped
to EL2, but to EL1. KVM is not in the loop at all in that case.

> Now, if you haven't started loading your gun to shoot me yet, then I'm
> quite confused as to why the unit test[1] I wrote for this works just
> fine without this patch.

If you want to exercise that path, you have to access something that
wouldn't trap to EL1, but that EL2 traps. I don't think we have much
stuff so far that can be used at EL0 and would be trapped to EL2,
unfortunately (the PMU code is probably the first thing we'll merge).

In the meantime, this test case is fairly pointless, I'm afraid...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
