From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 09/13] arm64: KVM: VHE: Add alternatives for VHE-enabled
 world-switch
Date: Thu, 09 Jul 2015 09:06:21 +0100
Message-ID: <559E2B7D.7030807@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com> <1436372356-30410-10-git-send-email-marc.zyngier@arm.com> <559DCE90.5030209@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <559DCE90.5030209@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mario,

On 09/07/15 02:29, Mario Smarduch wrote:
> On 07/08/2015 09:19 AM, Marc Zyngier wrote:
>> In order to switch between host and guest, a VHE-enabled kernel
>> must use different accessors for certain system registers.
>>
>> This patch uses runtime patching to use the right instruction
>> when required...
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_asm.h |  40 ++++++--
>>  arch/arm64/kvm/hyp.S             | 210 ++++++++++++++++++++++++++-------------
>>  arch/arm64/kvm/vhe-macros.h      |  18 ++++
>>  3 files changed, 191 insertions(+), 77 deletions(-)
>>
> [....]
>>   * Author: Marc Zyngier <marc.zyngier@arm.com>
>>   *
>>   * This program is free software; you can redistribute it and/or modify
>> @@ -67,40 +67,52 @@
>>       stp     x29, lr, [x3, #80]
>>
>>       mrs     x19, sp_el0
>> -     mrs     x20, elr_el2            // pc before entering el2
>> -     mrs     x21, spsr_el2           // pstate before entering el2
>> +     str     x19, [x3, #96]
>> +.endm
>>
>> -     stp     x19, x20, [x3, #96]
>> -     str     x21, [x3, #112]
> 
> Hi Marc,
> 
>   trying to make a little sense out of this :)

Don't even try, it hurts... ;-)

> In the case of VHE kernel the two 'mrs_hyp()' and 'mrs_el1()'
> calls would  be accessing same registers - namely EL1 variants?
> For non VHE EL2, EL1?
> 
> The mrs_s and sysreg_EL12 are new, not sure what these mean.

mrs_s and msr_s are just macros to that deal with system registers that
the assembler doesn't know about (yet). They have been in (moderate) use
for about a year, and have been introduced with the GICv3 support.

See arch/arm64/include/asm/sysreg.h for the gory details.

Now, on to sysreg_EL12: The main idea with VHE is that anything that
used to run at EL1 (the kernel) can now run unmodified at EL2, and that
it is the EL2 software that has to change to deal with it.

So when the kernel uses VHE and runs at EL2, an access to sysreg_EL1
really accesses sysreg_EL2, transparently. This is what makes it
possible to run the kernel at EL2 without any change.

But when the KVM world switch wants to access a guest register, it
cannot use sysreg_EL1 anymore (that would hit on the EL2 register
because of the above rule). For this, it must use sysreg_EL12 which
effectively means "access the EL1 register from EL2".

As a consequence, we have the following rules:
- non-VHE: msr_el1 uses EL1, msr_hyp uses EL2
- VHE: msr_el1 uses EL12, msr_hyp uses EL1

Does this help?

	M.

> - Mario
> 
>> +.macro save_el1_state
>> +     mrs_hyp(x20, ELR)               // pc before entering el2
>> +     mrs_hyp(x21, SPSR)              // pstate before entering el2
>>
>>       mrs     x22, sp_el1
>> -     mrs     x23, elr_el1
>> -     mrs     x24, spsr_el1
>> +
>> +     mrs_el1(x23, elr)
>> +     mrs_el1(x24, spsr)
>> +
>> +     add     x3, x2, #CPU_XREG_OFFSET(31)    // SP_EL0
>> +     stp     x20, x21, [x3, #8]      // HACK: Store to the regs after SP_EL0
>>
>>       str     x22, [x2, #CPU_GP_REG_OFFSET(CPU_SP_EL1)]
>>       str     x23, [x2, #CPU_GP_REG_OFFSET(CPU_ELR_EL1)]
>>       str     x24, [x2, #CPU_SPSR_OFFSET(KVM_SPSR_EL1)]
>>  .endm
>>
>> -.macro restore_common_regs
>> +.macro restore_el1_state
>>       // x2: base address for cpu context
>>       // x3: tmp register
>>
>> +     add     x3, x2, #CPU_XREG_OFFSET(31)    // SP_EL0
>> +     ldp     x20, x21, [x3, #8] // Same hack again, get guest PC and pstate
>> +
>>       ldr     x22, [x2, #CPU_GP_REG_OFFSET(CPU_SP_EL1)]
>>       ldr     x23, [x2, #CPU_GP_REG_OFFSET(CPU_ELR_EL1)]
>>       ldr     x24, [x2, #CPU_SPSR_OFFSET(KVM_SPSR_EL1)]
>>
>> +     msr_hyp(ELR, x20)               // pc on return from el2
>> +     msr_hyp(SPSR, x21)              // pstate on return from el2
>> +
>>       msr     sp_el1, x22
>> -     msr     elr_el1, x23
>> -     msr     spsr_el1, x24
>>
>> -     add     x3, x2, #CPU_XREG_OFFSET(31)    // SP_EL0
>> -     ldp     x19, x20, [x3]
>> -     ldr     x21, [x3, #16]
>> +     msr_el1(elr, x23)
>> +     msr_el1(spsr, x24)
>> +.endm
>>
>> +.macro restore_common_regs
>> +     // x2: base address for cpu context
>> +     // x3: tmp register
>> +
>> +     ldr     x19, [x2, #CPU_XREG_OFFSET(31)] // SP_EL0
>>       msr     sp_el0, x19
>> -     msr     elr_el2, x20            // pc on return from el2
>> -     msr     spsr_el2, x21           // pstate on return from el2
>>
>>       add     x3, x2, #CPU_XREG_OFFSET(19)
>>       ldp     x19, x20, [x3]
>> @@ -113,9 +125,15 @@
>>
>>  .macro save_host_regs
>>       save_common_regs
>> +ifnvhe       nop,                                    "b      skip_el1_save"
>> +     save_el1_state
>> +skip_el1_save:
>>  .endm
>>
>>  .macro restore_host_regs
>> +ifnvhe       nop,                                    "b      skip_el1_restore"
>> +     restore_el1_state
>> +skip_el1_restore:
>>       restore_common_regs
>>  .endm
>>
>> @@ -159,6 +177,7 @@
>>       stp     x6, x7, [x3, #16]
>>
>>       save_common_regs
>> +     save_el1_state
>>  .endm
>>
>>  .macro restore_guest_regs
>> @@ -184,6 +203,7 @@
>>       ldr     x18, [x3, #144]
>>
>>       // x19-x29, lr, sp*, elr*, spsr*
>> +     restore_el1_state
>>       restore_common_regs
>>
>>       // Last bits of the 64bit state
>> @@ -203,6 +223,38 @@
>>   * In other words, don't touch any of these unless you know what
>>   * you are doing.
>>   */
>> +
>> +.macro save_shared_sysregs
>> +     // x2: base address for cpu context
>> +     // x3: tmp register
>> +
>> +     add     x3, x2, #CPU_SYSREG_OFFSET(TPIDR_EL0)
>> +
>> +     mrs     x4, tpidr_el0
>> +     mrs     x5, tpidrro_el0
>> +     mrs     x6, tpidr_el1
>> +     mrs     x7, actlr_el1
>> +
>> +     stp     x4, x5, [x3]
>> +     stp     x6, x7, [x3, #16]
>> +.endm
>> +
>> +.macro restore_shared_sysregs
>> +     // x2: base address for cpu context
>> +     // x3: tmp register
>> +
>> +     add     x3, x2, #CPU_SYSREG_OFFSET(TPIDR_EL0)
>> +
>> +     ldp     x4, x5, [x3]
>> +     ldp     x6, x7, [x3, #16]
>> +
>> +     msr     tpidr_el0,      x4
>> +     msr     tpidrro_el0,    x5
>> +     msr     tpidr_el1,      x6
>> +     msr     actlr_el1,      x7
>> +.endm
>> +
>> +
>>  .macro save_sysregs
>>       // x2: base address for cpu context
>>       // x3: tmp register
>> @@ -211,26 +263,27 @@
>>
>>       mrs     x4,     vmpidr_el2
>>       mrs     x5,     csselr_el1
>> -     mrs     x6,     sctlr_el1
>> -     mrs     x7,     actlr_el1
>> -     mrs     x8,     cpacr_el1
>> -     mrs     x9,     ttbr0_el1
>> -     mrs     x10,    ttbr1_el1
>> -     mrs     x11,    tcr_el1
>> -     mrs     x12,    esr_el1
>> -     mrs     x13,    afsr0_el1
>> -     mrs     x14,    afsr1_el1
>> -     mrs     x15,    far_el1
>> -     mrs     x16,    mair_el1
>> -     mrs     x17,    vbar_el1
>> -     mrs     x18,    contextidr_el1
>> -     mrs     x19,    tpidr_el0
>> -     mrs     x20,    tpidrro_el0
>> -     mrs     x21,    tpidr_el1
>> -     mrs     x22,    amair_el1
>> -     mrs     x23,    cntkctl_el1
>> -     mrs     x24,    par_el1
>> -     mrs     x25,    mdscr_el1
>> +     mrs_el1(x6,     sctlr)
>> +     mrs_el1(x7,     amair)
>> +     mrs_el1(x8,     cpacr)
>> +     mrs_el1(x9,     ttbr0)
>> +     mrs_el1(x10,    ttbr1)
>> +     mrs_el1(x11,    tcr)
>> +     mrs_el1(x12,    esr)
>> +     mrs_el1(x13,    afsr0)
>> +     mrs_el1(x14,    afsr1)
>> +     mrs_el1(x15,    far)
>> +     mrs_el1(x16,    mair)
>> +     mrs_el1(x17,    vbar)
>> +     mrs_el1(x18,    contextidr)
>> +     mrs_el1(x19,    cntkctl)
>> +     mrs     x20,    par_el1
>> +     mrs     x21,    mdscr_el1
>> +
>> +     mrs     x22,    tpidr_el0
>> +     mrs     x23,    tpidrro_el0
>> +     mrs     x24,    tpidr_el1
>> +     mrs     x25,    actlr_el1
>>
>>       stp     x4, x5, [x3]
>>       stp     x6, x7, [x3, #16]
>> @@ -460,26 +513,27 @@
>>
>>       msr     vmpidr_el2,     x4
>>       msr     csselr_el1,     x5
>> -     msr     sctlr_el1,      x6
>> -     msr     actlr_el1,      x7
>> -     msr     cpacr_el1,      x8
>> -     msr     ttbr0_el1,      x9
>> -     msr     ttbr1_el1,      x10
>> -     msr     tcr_el1,        x11
>> -     msr     esr_el1,        x12
>> -     msr     afsr0_el1,      x13
>> -     msr     afsr1_el1,      x14
>> -     msr     far_el1,        x15
>> -     msr     mair_el1,       x16
>> -     msr     vbar_el1,       x17
>> -     msr     contextidr_el1, x18
>> -     msr     tpidr_el0,      x19
>> -     msr     tpidrro_el0,    x20
>> -     msr     tpidr_el1,      x21
>> -     msr     amair_el1,      x22
>> -     msr     cntkctl_el1,    x23
>> -     msr     par_el1,        x24
>> -     msr     mdscr_el1,      x25
>> +     msr_el1(sctlr,          x6)
>> +     msr_el1(amair,          x7)
>> +     msr_el1(cpacr,          x8)
>> +     msr_el1(ttbr0,          x9)
>> +     msr_el1(ttbr1,          x10)
>> +     msr_el1(tcr,            x11)
>> +     msr_el1(esr,            x12)
>> +     msr_el1(afsr0,          x13)
>> +     msr_el1(afsr1,          x14)
>> +     msr_el1(far,            x15)
>> +     msr_el1(mair,           x16)
>> +     msr_el1(vbar,           x17)
>> +     msr_el1(contextidr,     x18)
>> +     msr_el1(cntkctl,        x19)
>> +     msr     par_el1,        x20
>> +     msr     mdscr_el1,      x21
>> +
>> +     msr     tpidr_el0,      x22
>> +     msr     tpidrro_el0,    x23
>> +     msr     tpidr_el1,      x24
>> +     msr     actlr_el1,      x25
>>  .endm
>>
>>  .macro restore_debug
>> @@ -779,8 +833,11 @@
>>  .macro activate_traps
>>       ldr     x2, [x0, #VCPU_HCR_EL2]
>>       msr     hcr_el2, x2
>> -     mov     x2, #CPTR_EL2_TTA
>> -     msr     cptr_el2, x2
>> +     adr     x3, __kvm_hyp_vector
>> +ifnvhe       nop,                                    "msr    vbar_el1, x3"
>> +ifnvhe       nop,                                    "mrs    x2, cpacr_el1"
>> +ifnvhe _S_(ldr       x2, =(CPTR_EL2_TTA)),           "orr x2, x2, #(1 << 28)"
>> +ifnvhe "msr  cptr_el2, x2",                  "msr    cpacr_el1, x2"
>>
>>       mov     x2, #(1 << 15)  // Trap CP15 Cr=15
>>       msr     hstr_el2, x2
>> @@ -803,12 +860,20 @@
>>  ifnvhe _S_(mov       x2, #HCR_RW),                   _S_(mov x2, #HCR_RW|HCR_TGE)
>>  ifnvhe       nop,                                    _S_(orr x2, x2, #HCR_E2H)
>>       msr     hcr_el2, x2
>> -     msr     cptr_el2, xzr
>> +
>> +ifnvhe       nop,                                    "mrs    x2, cpacr_el1"
>> +ifnvhe       nop,                                    "movn   x3, #(1 << 12), lsl #16"
>> +ifnvhe       nop,                                    "and    x2, x2, x3"
>> +ifnvhe "msr  cptr_el2, xzr",                 "msr    cpacr_el1, x2"
>>       msr     hstr_el2, xzr
>>
>>       mrs     x2, mdcr_el2
>>       and     x2, x2, #MDCR_EL2_HPMN_MASK
>>       msr     mdcr_el2, x2
>> +
>> +     adrp    x2, vectors
>> +     add     x2, x2, #:lo12:vectors
>> +ifnvhe       nop,                                    "msr    vbar_el1, x2"
>>  .endm
>>
>>  .macro activate_vm
>> @@ -853,15 +918,15 @@ ifnvhe  nop,                                    _S_(orr x2, x2, #HCR_E2H)
>>       ldr     w3, [x2, #KVM_TIMER_ENABLED]
>>       cbz     w3, 1f
>>
>> -     mrs     x3, cntv_ctl_el0
>> +     mrs_el0(x3, cntv_ctl)
>>       and     x3, x3, #3
>>       str     w3, [x0, #VCPU_TIMER_CNTV_CTL]
>>       bic     x3, x3, #1              // Clear Enable
>> -     msr     cntv_ctl_el0, x3
>> +     msr_el0(cntv_ctl, x3)
>>
>>       isb
>>
>> -     mrs     x3, cntv_cval_el0
>> +     mrs_el0(x3, cntv_cval)
>>       str     x3, [x0, #VCPU_TIMER_CNTV_CVAL]
>>
>>  1:
>> @@ -871,7 +936,7 @@ ifnvhe    nop,                                    _S_(orr x2, x2, #HCR_E2H)
>>       msr     cnthctl_el2, x2
>>
>>       // Clear cntvoff for the host
>> -     msr     cntvoff_el2, xzr
>> +ifnvhe "msr  cntvoff_el2, xzr",              nop
>>  .endm
>>
>>  .macro restore_timer_state
>> @@ -891,12 +956,12 @@ ifnvhe  nop,                                    _S_(orr x2, x2, #HCR_E2H)
>>       ldr     x3, [x2, #KVM_TIMER_CNTVOFF]
>>       msr     cntvoff_el2, x3
>>       ldr     x2, [x0, #VCPU_TIMER_CNTV_CVAL]
>> -     msr     cntv_cval_el0, x2
>> +     msr_el0(cntv_cval, x2)
>>       isb
>>
>>       ldr     w2, [x0, #VCPU_TIMER_CNTV_CTL]
>>       and     x2, x2, #3
>> -     msr     cntv_ctl_el0, x2
>> +     msr_el0(cntv_ctl, x2)
>>  1:
>>  .endm
>>
>> @@ -945,8 +1010,10 @@ ENTRY(__kvm_vcpu_run)
>>
>>       save_host_regs
>>       bl __save_fpsimd
>> -     bl __save_sysregs
>> -
>> +ifnvhe "bl   __save_sysregs",                nop
>> +ifnvhe "b    1f",                            nop
>> +     save_shared_sysregs
>> +1:
>>       compute_debug_state 1f
>>       bl      __save_debug
>>  1:
>> @@ -997,7 +1064,10 @@ __kvm_vcpu_return:
>>       ldr     x2, [x0, #VCPU_HOST_CONTEXT]
>>       kern_hyp_va x2
>>
>> -     bl __restore_sysregs
>> +ifnvhe "bl   __restore_sysregs",             nop
>> +ifnvhe "b    1f",                            nop
>> +     restore_shared_sysregs
>> +1:
>>       bl __restore_fpsimd
>>
>>       skip_debug_state x3, 1f
>> @@ -1104,6 +1174,8 @@ __kvm_hyp_panic:
>>       mrs     x6, par_el1
>>       mrs     x7, tpidr_el2
>>
>> +ifnvhe       nop,                                    "b      panic"
>> +
>>       mov     lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
>>                     PSR_MODE_EL1h)
>>       msr     spsr_el2, lr
>> @@ -1248,7 +1320,7 @@ el1_trap:
>>        * As such, we can use the EL1 translation regime, and don't have
>>        * to distinguish between EL0 and EL1 access.
>>        */
>> -     mrs     x2, far_el2
>> +ifnvhe "mrs  x2, far_el2",                   "mrs    x2, far_el1"
>>       at      s1e1r, x2
>>       isb
>>
>> @@ -1262,7 +1334,7 @@ el1_trap:
>>       b       2f
>>
>>  1:   mrs     x3, hpfar_el2
>> -     mrs     x2, far_el2
>> +ifnvhe "mrs  x2, far_el2",                   "mrs    x2, far_el1"
>>
>>  2:   mrs     x0, tpidr_el2
>>       str     w1, [x0, #VCPU_ESR_EL2]
>> diff --git a/arch/arm64/kvm/vhe-macros.h b/arch/arm64/kvm/vhe-macros.h
>> index da7f9da..1e94235 100644
>> --- a/arch/arm64/kvm/vhe-macros.h
>> +++ b/arch/arm64/kvm/vhe-macros.h
>> @@ -31,6 +31,24 @@
>>       alternative_insn        "\nonvhe", "\vhe", ARM64_HAS_VIRT_HOST_EXTN
>>  .endm
>>
>> +#define mrs_el0(reg, sysreg) \
>> +     ifnvhe  _S_(mrs reg, sysreg##_EL0), _S_(mrs_s reg, sysreg##_EL02)
>> +
>> +#define msr_el0(sysreg, reg) \
>> +     ifnvhe  _S_(msr sysreg##_EL0, reg), _S_(msr_s sysreg##_EL02, reg)
>> +
>> +#define mrs_el1(reg, sysreg) \
>> +     ifnvhe  _S_(mrs reg, sysreg##_EL1), _S_(mrs_s reg, sysreg##_EL12)
>> +
>> +#define msr_el1(sysreg, reg) \
>> +     ifnvhe  _S_(msr sysreg##_EL1, reg), _S_(msr_s sysreg##_EL12, reg)
>> +
>> +#define mrs_hyp(reg, sysreg) \
>> +     ifnvhe  _S_(mrs reg, sysreg##_EL2), _S_(mrs reg, sysreg##_EL1)
>> +
>> +#define msr_hyp(sysreg, reg) \
>> +     ifnvhe  _S_(msr sysreg##_EL2, reg), _S_(msr sysreg##_EL1, reg)
>> +
>>  #endif
>>
>>  #endif       /*__ARM64_VHE_MACROS_H__  */
>>
> 


-- 
Jazz is not dead. It just smells funny...
