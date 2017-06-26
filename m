From: Jintack Lim <jintack.lim@linaro.org>
Subject: Re: [RFC 06/55] KVM: arm64: Add EL2 execution context for nesting
Date: Mon, 26 Jun 2017 10:33:23 -0400
Message-ID: <CAHyh4xjOvAgqQ+WLD3SHyNHXOFSuoKGu4sV+GaFm-LdEcoGYwA@mail.gmail.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-7-git-send-email-jintack@cs.columbia.edu> <20170222111017.GB26976@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170222111017.GB26976@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, vladimir.murzin@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, anna-maria@linutronix.de, Shih-Wei Li <shihwei@cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, KVM General <kvm@vger.kernel.org>, lkml
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Wed, Feb 22, 2017 at 6:10 AM, Christoffer Dall <cdall@linaro.org> wrote:
> On Mon, Jan 09, 2017 at 01:24:02AM -0500, Jintack Lim wrote:
>> With the nested virtualization support, the context of the guest
>> includes EL2 register states. The host manages a set of virtual EL2
>> registers.  In addition to that, the guest hypervisor supposed to run in
>> EL2 is now deprivilaged and runs in EL1. So, the host also manages a set
>> of shadow system registers to be able to run the guest hypervisor in
>> EL1.
>>
>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> ---
>>  arch/arm64/include/asm/kvm_host.h | 54 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 54 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index c0c8b02..ed78d73 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -146,6 +146,42 @@ enum vcpu_sysreg {
>>       NR_SYS_REGS     /* Nothing after this line! */
>>  };
>>
>> +enum el2_regs {
>> +     ELR_EL2,
>> +     SPSR_EL2,
>> +     SP_EL2,
>> +     AMAIR_EL2,
>> +     MAIR_EL2,
>> +     TCR_EL2,
>> +     TTBR0_EL2,
>> +     VTCR_EL2,
>> +     VTTBR_EL2,
>> +     VMPIDR_EL2,
>> +     VPIDR_EL2,      /* 10 */
>> +     MDCR_EL2,
>> +     CNTHCTL_EL2,
>> +     CNTHP_CTL_EL2,
>> +     CNTHP_CVAL_EL2,
>> +     CNTHP_TVAL_EL2,
>> +     CNTVOFF_EL2,
>> +     ACTLR_EL2,
>> +     AFSR0_EL2,
>> +     AFSR1_EL2,
>> +     CPTR_EL2,       /* 20 */
>> +     ESR_EL2,
>> +     FAR_EL2,
>> +     HACR_EL2,
>> +     HCR_EL2,
>> +     HPFAR_EL2,
>> +     HSTR_EL2,
>> +     RMR_EL2,
>> +     RVBAR_EL2,
>> +     SCTLR_EL2,
>> +     TPIDR_EL2,      /* 30 */
>> +     VBAR_EL2,
>> +     NR_EL2_REGS     /* Nothing after this line! */
>> +};
>
> Why do we have a separate enum and array for the EL2 regs and not simply
> expand vcpu_sysreg ?

We can expand vcpu_sysreg for the EL2 system registers. For SP_EL2,
SPSR_EL2, and ELR_EL2, where is the good place to locate them?.
SP_EL1, SPSR_EL1, and ELR_EL1 registers are saved in the kvm_regs
structure instead of sysregs[], so I wonder it's better to put them in
kvm_regs, too.

BTW, what's the reason that those EL1 registers are in kvm_regs
instead of sysregs[] in the first place?

>
>> +
>>  /* 32bit mapping */
>>  #define c0_MPIDR     (MPIDR_EL1 * 2) /* MultiProcessor ID Register */
>>  #define c0_CSSELR    (CSSELR_EL1 * 2)/* Cache Size Selection Register */
>> @@ -193,6 +229,23 @@ struct kvm_cpu_context {
>>               u64 sys_regs[NR_SYS_REGS];
>>               u32 copro[NR_COPRO_REGS];
>>       };
>> +
>> +     u64 el2_regs[NR_EL2_REGS];         /* only used for nesting */
>> +     u64 shadow_sys_regs[NR_SYS_REGS];  /* only used for virtual EL2 */
>> +
>> +     /*
>> +      * hw_* will be used when switching to a VM. They point to either
>> +      * the virtual EL2 or EL1/EL0 context depending on vcpu mode.
>
> don't they either point to the shadow sys regs or the the normal EL1
> sysregs?

Ah, this is a general comment for all three members below.

>
>> +      */
>> +
>> +     /* pointing shadow_sys_regs or sys_regs */
>
> that's what this comment seems to indicate, so there's some duplicity
> here.

And this comment is for hw_sys_regs specifically.

>
>> +     u64 *hw_sys_regs;
>> +
>> +     /* copy of either gp_regs.sp_el1 or el2_regs[SP_EL2] */
>> +     u64 hw_sp_el1;
>> +
>> +     /* pstate written to SPSR_EL2 */
>> +     u64 hw_pstate;
>>  };
>>
>>  typedef struct kvm_cpu_context kvm_cpu_context_t;
>> @@ -277,6 +330,7 @@ struct kvm_vcpu_arch {
>>
>>  #define vcpu_gp_regs(v)              (&(v)->arch.ctxt.gp_regs)
>>  #define vcpu_sys_reg(v,r)    ((v)->arch.ctxt.sys_regs[(r)])
>> +#define vcpu_el2_reg(v, r)   ((v)->arch.ctxt.el2_regs[(r)])
>>  /*
>>   * CP14 and CP15 live in the same array, as they are backed by the
>>   * same system registers.
>> --
>> 1.9.1
>>
>>
>
