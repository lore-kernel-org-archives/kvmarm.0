From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 19/28] ARM: KVM: Add panic handling code
Date: Wed, 10 Feb 2016 16:03:48 +0000
Message-ID: <56BB5F64.8070708@arm.com>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-20-git-send-email-marc.zyngier@arm.com>
 <20160209184503.GV5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160209184503.GV5171@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 09/02/16 18:45, Christoffer Dall wrote:
> On Thu, Feb 04, 2016 at 11:00:36AM +0000, Marc Zyngier wrote:
>> Instead of spinning forever, let's "properly" handle any unexpected
>> exception ("properly" meaning "print a spat on the console and die").
>>
>> This has proved useful quite a few times...
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/kvm/hyp/hyp-entry.S | 28 +++++++++++++++++++++-------
>>  arch/arm/kvm/hyp/switch.c    | 38 ++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 59 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
>> index 44bc11f..ca412ad 100644
>> --- a/arch/arm/kvm/hyp/hyp-entry.S
>> +++ b/arch/arm/kvm/hyp/hyp-entry.S
>> @@ -75,15 +75,29 @@ __kvm_hyp_vector:
>>  
>>  .macro invalid_vector label, cause
>>  	.align
>> -\label:	b	.
>> +\label:	mov	r0, #\cause
>> +	b	__hyp_panic
>>  .endm
>>  
>> -	invalid_vector	hyp_reset
>> -	invalid_vector	hyp_undef
>> -	invalid_vector	hyp_svc
>> -	invalid_vector	hyp_pabt
>> -	invalid_vector	hyp_dabt
>> -	invalid_vector	hyp_fiq
>> +	invalid_vector	hyp_reset	ARM_EXCEPTION_RESET
>> +	invalid_vector	hyp_undef	ARM_EXCEPTION_UNDEFINED
>> +	invalid_vector	hyp_svc		ARM_EXCEPTION_SOFTWARE
>> +	invalid_vector	hyp_pabt	ARM_EXCEPTION_PREF_ABORT
>> +	invalid_vector	hyp_dabt	ARM_EXCEPTION_DATA_ABORT
>> +	invalid_vector	hyp_fiq		ARM_EXCEPTION_FIQ
>> +
>> +ENTRY(__hyp_do_panic)
>> +	mrs	lr, cpsr
>> +	bic	lr, lr, #MODE_MASK
>> +	orr	lr, lr, #SVC_MODE
>> +THUMB(	orr	lr, lr, #PSR_T_BIT	)
>> +	msr	spsr_cxsf, lr
>> +	ldr	lr, =panic
>> +	msr	ELR_hyp, lr
>> +	ldr	lr, =kvm_call_hyp
>> +	clrex
>> +	eret
>> +ENDPROC(__hyp_do_panic)
>>  
>>  hyp_hvc:
>>  	/*
>> diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
>> index 8bfd729..67f3944 100644
>> --- a/arch/arm/kvm/hyp/switch.c
>> +++ b/arch/arm/kvm/hyp/switch.c
>> @@ -188,3 +188,41 @@ again:
>>  }
>>  
>>  __alias(__guest_run) int __weak __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>> +
>> +static const char * const __hyp_panic_string[] = {
>> +	[ARM_EXCEPTION_RESET]      = "\nHYP panic: RST?? PC:%08x CPSR:%08x",
>> +	[ARM_EXCEPTION_UNDEFINED]  = "\nHYP panic: UNDEF PC:%08x CPSR:%08x",
>> +	[ARM_EXCEPTION_SOFTWARE]   = "\nHYP panic: SVC?? PC:%08x CPSR:%08x",
>> +	[ARM_EXCEPTION_PREF_ABORT] = "\nHYP panic: PABRT PC:%08x CPSR:%08x",
>> +	[ARM_EXCEPTION_DATA_ABORT] = "\nHYP panic: DABRT PC:%08x ADDR:%08x",
>> +	[ARM_EXCEPTION_IRQ]        = "\nHYP panic: IRQ?? PC:%08x CPSR:%08x",
>> +	[ARM_EXCEPTION_FIQ]        = "\nHYP panic: FIQ?? PC:%08x CPSR:%08x",
>> +	[ARM_EXCEPTION_HVC]        = "\nHYP panic: HVC?? PC:%08x CPSR:%08x",
> 
> Why the question marks?

Ah, that was me wondering how we'd get those! I'll remove them.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
