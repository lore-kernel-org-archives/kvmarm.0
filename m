From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 15/21] arm64: KVM: Add panic handling
Date: Mon, 16 Nov 2015 16:57:32 +0000
Message-ID: <564A0AFC.7070204@arm.com>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>	<1447679519-17888-16-git-send-email-marc.zyngier@arm.com> <CAKv+Gu-4OCaoFp4myi3YNGNeoSmhw7pURqmgW_gb5kSQCGoFQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-4OCaoFp4myi3YNGNeoSmhw7pURqmgW_gb5kSQCGoFQA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <marc.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, KVM devel mailing list <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/11/15 15:53, Ard Biesheuvel wrote:
> On 16 November 2015 at 14:11, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> Add the panic handler, together with the small bits of assembly
>> code to call the kernel's panic implementation.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/hyp-entry.S | 11 ++++++++++-
>>  arch/arm64/kvm/hyp/hyp.h       |  1 +
>>  arch/arm64/kvm/hyp/switch.c    | 35 +++++++++++++++++++++++++++++++++++
>>  3 files changed, 46 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
>> index e11a129..7218eed 100644
>> --- a/arch/arm64/kvm/hyp/hyp-entry.S
>> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
>> @@ -141,7 +141,16 @@ el1_irq:
>>         mov     x1, #ARM_EXCEPTION_IRQ
>>         b       __guest_exit
>>
>> -.macro invalid_vector  label, target = __kvm_hyp_panic
>> +ENTRY(__hyp_do_panic)
>> +       mov     lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
>> +                     PSR_MODE_EL1h)
>> +       msr     spsr_el2, lr
>> +       ldr     lr, =panic
>> +       msr     elr_el2, lr
>> +       eret
>> +ENDPROC(__hyp_do_panic)
>> +
>> +.macro invalid_vector  label, target = __hyp_panic
>>         .align  2
>>  \label:
>>         b \target
>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>> index 240fb79..d5d500d 100644
>> --- a/arch/arm64/kvm/hyp/hyp.h
>> +++ b/arch/arm64/kvm/hyp/hyp.h
>> @@ -74,6 +74,7 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
>>  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>>
>>  u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
>> +void __noreturn __hyp_do_panic(unsigned long, ...);
>>
>>  #endif /* __ARM64_KVM_HYP_H__ */
>>
>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index 06d3e20..cdc2a96 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -140,3 +140,38 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>>
>>         return exit_code;
>>  }
>> +
>> +static const char *__hyp_panic_string = "HYP panic:\nPS:%08x PC:%p ESR:%p\nFAR:%p HPFAR:%p PAR:%p\nVCPU:%p\n";
>> +
> 
> Re separating the HYP text from the kernel proper: this is exactly the
> thing that is likely to cause trouble when you execute the kernel text
> from HYP.
> 
> __hyp_panic_string is a non-const char pointer containing the absolute
> address of the string in the initializer, as seen from the high kernel
> virtual mapping.
> Better use 'static const char __hyp_panic_string[]' instead.

Definitely.

> (If it currenty works fine, it is only because the compiler optimizes
> the entire variable away, and performs a relative access in the place
> where the variable is referenced.)

That, and the fact that only panic() gets passed a pointer to this
string, so it doesn't really matter where it lives in this case.

But you do have a point here, and I'll address this for the next round.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
