From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v5 2/3] KVM/arm/arm64: enable enhanced armv7 fp/simd lazy
 switch
Date: Fri, 18 Dec 2015 16:54:15 -0800
Message-ID: <5674AAB7.6050106@samsung.com>
References: <1449450434-2929-1-git-send-email-m.smarduch@samsung.com>
 <1449450434-2929-3-git-send-email-m.smarduch@samsung.com>
 <20151218134924.GG32720@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9981449761
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 19:51:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pJLGpjQLteSl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2015 19:51:48 -0500 (EST)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E46741390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 19:51:47 -0500 (EST)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NZK00EORYIHM190@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 18 Dec 2015 19:54:17 -0500 (EST)
In-reply-to: <20151218134924.GG32720@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/18/2015 5:49 AM, Christoffer Dall wrote:
> On Sun, Dec 06, 2015 at 05:07:13PM -0800, Mario Smarduch wrote:
>> This patch tracks armv7 fp/simd hardware state with hcptr register.
>> On vcpu_load saves host fpexc, enables FP access, and sets trapping
>> on fp/simd access. On first fp/simd access trap to handler to save host and 
>> restore guest context, clear trapping bits to enable vcpu lazy mode. On 
>> vcpu_put if trap bits are cleared save guest and restore host context and 
>> always restore host fpexc.
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm/include/asm/kvm_emulate.h   | 50 ++++++++++++++++++++++++++++++++++++
>>  arch/arm/include/asm/kvm_host.h      |  1 +
>>  arch/arm/kvm/Makefile                |  2 +-
>>  arch/arm/kvm/arm.c                   | 13 ++++++++++
>>  arch/arm/kvm/fpsimd_switch.S         | 46 +++++++++++++++++++++++++++++++++
>>  arch/arm/kvm/interrupts.S            | 32 +++++------------------
>>  arch/arm/kvm/interrupts_head.S       | 33 ++++++++++--------------
>>  arch/arm64/include/asm/kvm_emulate.h |  9 +++++++
>>  arch/arm64/include/asm/kvm_host.h    |  1 +
>>  9 files changed, 142 insertions(+), 45 deletions(-)
>>  create mode 100644 arch/arm/kvm/fpsimd_switch.S
>>
>> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
>> index a9c80a2..3de11a2 100644
>> --- a/arch/arm/include/asm/kvm_emulate.h
>> +++ b/arch/arm/include/asm/kvm_emulate.h
>> @@ -243,4 +243,54 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
>>  	}
>>  }
>>  
>> +#ifdef CONFIG_VFPv3
>> +/* Called from vcpu_load - save fpexc and enable guest access to fp/simd unit */
> 
> are you really enabling guest access here or just fiddling with fpexc to
> ensure you trap accesses to hyp ?

That's the end goal, but it is setting the fp enable bit? Your later comment of
combining functions and remove assembler should work.

> 
>> +static inline void kvm_enable_vcpu_fpexc(struct kvm_vcpu *vcpu)
>> +{
>> +	u32 fpexc;
>> +
>> +	asm volatile(
>> +	 "mrc p10, 7, %0, cr8, cr0, 0\n"
>> +	 "str %0, [%1]\n"
>> +	 "mov %0, #(1 << 30)\n"
>> +	 "mcr p10, 7, %0, cr8, cr0, 0\n"
>> +	 "isb\n"
> 
> why do you need an ISB here?  won't there be an implicit one from the
> HVC call later before you need this to take effect?

I would think so, but besides B.2.7.3  I can't find other references on
visibility of context altering instructions.
> 
>> +	 : "+r" (fpexc)
>> +	 : "r" (&vcpu->arch.host_fpexc)
>> +	);
> 
> this whole bit can be rewritten something like:
> 
> fpexc = fmrx(FPEXC);
> vcpu->arch.host_fpexc = fpexc;
> fpexc |= FPEXC_EN;
> fmxr(FPEXC, fpexc);

Didn't know about fmrx/fmxr functions - much better.
> 
>> +}
>> +
>> +/* Called from vcpu_put - restore host fpexc */
>> +static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu)
>> +{
>> +	asm volatile(
>> +	 "mcr p10, 7, %0, cr8, cr0, 0\n"
>> +	 :
>> +	 : "r" (vcpu->arch.host_fpexc)
>> +	);
> 
> similarly here
Ok.
> 
>> +}
>> +
>> +/* If trap bits are reset then fp/simd registers are dirty */
>> +static inline bool kvm_vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
>> +{
>> +	return !!(~vcpu->arch.hcptr & (HCPTR_TCP(10) | HCPTR_TCP(11)));
> 
> this looks complicated, how about:
> 
> return !(vcpu->arch.hcptr & (HCPTR_TCP(10) | HCPTR_TCP(11)));

Yeah, I twisted the meaning of bool.
> 
>> +}
>> +
>> +static inline void vcpu_reset_cptr(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->arch.hcptr |= (HCPTR_TTA | HCPTR_TCP(10)  | HCPTR_TCP(11));
>> +}
>> +#else
>> +static inline void kvm_enable_vcpu_fpexc(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
>> +static inline bool kvm_vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +static inline void vcpu_reset_cptr(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->arch.hcptr = HCPTR_TTA;
>> +}
>> +#endif
>> +
>>  #endif /* __ARM_KVM_EMULATE_H__ */
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 09bb1f2..ecc883a 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -227,6 +227,7 @@ int kvm_perf_teardown(void);
>>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>>  
>>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>> +void kvm_restore_host_vfp_state(struct kvm_vcpu *);
>>  
>>  static inline void kvm_arch_hardware_disable(void) {}
>>  static inline void kvm_arch_hardware_unsetup(void) {}
>> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
>> index c5eef02c..411b3e4 100644
>> --- a/arch/arm/kvm/Makefile
>> +++ b/arch/arm/kvm/Makefile
>> @@ -19,7 +19,7 @@ kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vf
>>  
>>  obj-y += kvm-arm.o init.o interrupts.o
>>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
>> -obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
>> +obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o fpsimd_switch.o
>>  obj-y += $(KVM)/arm/vgic.o
>>  obj-y += $(KVM)/arm/vgic-v2.o
>>  obj-y += $(KVM)/arm/vgic-v2-emul.o
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index dc017ad..1de07ab 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -291,10 +291,23 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>  	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
>>  
>>  	kvm_arm_set_running_vcpu(vcpu);
>> +
>> +	/*  Save and enable FPEXC before we load guest context */
>> +	kvm_enable_vcpu_fpexc(vcpu);
> 
> hmmm, not really sure the 'enable' part of this name is the right choice
> when looking at this.  kvm_prepare_vcpu_fpexc ?
> 
>> +
>> +	/* reset hyp cptr register to trap on tracing and vfp/simd access*/
>> +	vcpu_reset_cptr(vcpu);
> 
> alternatively you could combine the two functions above into a single
> function called something like "vcpu_trap_vfp_enable()" or
> "vcpu_load_configure_vfp()"
> 
> (I sort of feel like we have reserved the _reset_ namespace for stuff we
> actually do at VCPU reset.)

Related to earlier comment I would be in favor of combining and use
'vcpu_trap_vfp_enable()'.

> 
> 
>>  }
>>  
>>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  {
>> +	/* If the fp/simd registers are dirty save guest, restore host. */
>> +	if (kvm_vcpu_vfp_isdirty(vcpu))
>> +		kvm_restore_host_vfp_state(vcpu);
>> +
>> +	/* Restore host FPEXC trashed in vcpu_load */
>> +	kvm_restore_host_fpexc(vcpu);
>> +
>>  	/*
>>  	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
>>  	 * if the vcpu is no longer assigned to a cpu.  This is used for the
>> diff --git a/arch/arm/kvm/fpsimd_switch.S b/arch/arm/kvm/fpsimd_switch.S
>> new file mode 100644
>> index 0000000..d297c54
>> --- /dev/null
>> +++ b/arch/arm/kvm/fpsimd_switch.S
>> @@ -0,0 +1,46 @@
>> +/*
>> + * Copyright (C) 2012 - Virtual Open Systems and Columbia University
>> + * Author: Christoffer Dall <c.dall@virtualopensystems.com>
> 
> Not quite, this is new code, so you should just claim copyright and
> authorship I believe.
Ok didn't know.
> 
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License, version 2, as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +#include <linux/linkage.h>
>> +#include <linux/const.h>
>> +#include <asm/unified.h>
>> +#include <asm/page.h>
>> +#include <asm/ptrace.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/kvm_asm.h>
>> +#include <asm/kvm_arm.h>
>> +#include <asm/vfpmacros.h>
>> +#include "interrupts_head.S"
>> +
>> +	.text
>> +/**
>> +  * void kvm_restore_host_vfp_state(struct vcpu *vcpu) -
>> +  *     This function is called from host to save the guest, and restore host
>> +  *     fp/simd hardware context. It's placed outside of hyp start/end region.
>> +  */
>> +ENTRY(kvm_restore_host_vfp_state)
>> +#ifdef CONFIG_VFPv3
>> +	push	{r4-r7}
>> +
>> +	add	r7, r0, #VCPU_VFP_GUEST
>> +	store_vfp_state r7
>> +
>> +	add	r7, r0, #VCPU_VFP_HOST
>> +	ldr	r7, [r7]
>> +	restore_vfp_state r7
>> +
>> +	pop	{r4-r7}
>> +#endif
>> +	bx	lr
>> +ENDPROC(kvm_restore_host_vfp_state)
>> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
>> index 900ef6d..8e25431 100644
>> --- a/arch/arm/kvm/interrupts.S
>> +++ b/arch/arm/kvm/interrupts.S
>> @@ -116,22 +116,15 @@ ENTRY(__kvm_vcpu_run)
>>  	read_cp15_state store_to_vcpu = 0
>>  	write_cp15_state read_from_vcpu = 1
>>  
>> -	@ If the host kernel has not been configured with VFPv3 support,
>> -	@ then it is safer if we deny guests from using it as well.
>> -#ifdef CONFIG_VFPv3
>> -	@ Set FPEXC_EN so the guest doesn't trap floating point instructions
>> -	VFPFMRX r2, FPEXC		@ VMRS
>> -	push	{r2}
>> -	orr	r2, r2, #FPEXC_EN
>> -	VFPFMXR FPEXC, r2		@ VMSR
>> -#endif
>> +	@ Enable tracing and possibly fp/simd trapping
> 
> Configure trapping of access to tracing and fp/simd registers
ok.
> 
>> +	ldr r4, [vcpu, #VCPU_HCPTR]
>> +	set_hcptr vmentry, #0, r4
> 
> if we store something called HCPTR on the VCPU, then that should really
> be HCPTR, so I don't see why we need a macro and this is not just a
> write to the HCPTR directly?

The macro handled some corner cases, but it's getting messy. I'll remove it.
> 
>>  
>>  	@ Configure Hyp-role
>>  	configure_hyp_role vmentry
>>  
>>  	@ Trap coprocessor CRx accesses
>>  	set_hstr vmentry
>> -	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
>>  	set_hdcr vmentry
>>  
>>  	@ Write configured ID register into MIDR alias
>> @@ -170,23 +163,12 @@ __kvm_vcpu_return:
>>  	@ Don't trap coprocessor accesses for host kernel
>>  	set_hstr vmexit
>>  	set_hdcr vmexit
>> -	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11)), after_vfp_restore
>>  
>> -#ifdef CONFIG_VFPv3
>> -	@ Switch VFP/NEON hardware state to the host's
>> -	add	r7, vcpu, #VCPU_VFP_GUEST
>> -	store_vfp_state r7
>> -	add	r7, vcpu, #VCPU_VFP_HOST
>> -	ldr	r7, [r7]
>> -	restore_vfp_state r7
>> +	/* Preserve HCPTR across exits */
>> +	mrc     p15, 4, r2, c1, c1, 2
>> +	str     r2, [vcpu, #VCPU_HCPTR]
> 
> can't you do this in the trap handler so you avoid this on every exit
Ah right you could, updated register is retained until next vcpu_load.

> 
>>  
>> -after_vfp_restore:
>> -	@ Restore FPEXC_EN which we clobbered on entry
>> -	pop	{r2}
>> -	VFPFMXR FPEXC, r2
>> -#else
>> -after_vfp_restore:
>> -#endif
>> +	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
> 
> again here, I don't think you need a macro, just clear the bits and
> store the register.
> 
>>  
>>  	@ Reset Hyp-role
>>  	configure_hyp_role vmexit
>> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
>> index 51a5950..7701ccd 100644
>> --- a/arch/arm/kvm/interrupts_head.S
>> +++ b/arch/arm/kvm/interrupts_head.S
>> @@ -593,29 +593,24 @@ ARM_BE8(rev	r6, r6  )
>>   * (hardware reset value is 0). Keep previous value in r2.
>>   * An ISB is emited on vmexit/vmtrap, but executed on vmexit only if
>>   * VFP wasn't already enabled (always executed on vmtrap).
>> - * If a label is specified with vmexit, it is branched to if VFP wasn't
>> - * enabled.
>>   */
>> -.macro set_hcptr operation, mask, label = none
>> -	mrc	p15, 4, r2, c1, c1, 2
>> -	ldr	r3, =\mask
>> +.macro set_hcptr operation, mask, reg
>> +	mrc     p15, 4, r2, c1, c1, 2
>>  	.if \operation == vmentry
>> -	orr	r3, r2, r3		@ Trap coproc-accesses defined in mask
>> +	mov     r3, \reg              @ Trap coproc-accesses defined in mask
>>  	.else
>> -	bic	r3, r2, r3		@ Don't trap defined coproc-accesses
>> -	.endif
>> -	mcr	p15, 4, r3, c1, c1, 2
>> -	.if \operation != vmentry
>> -	.if \operation == vmexit
>> -	tst	r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
>> -	beq	1f
>> -	.endif
>> -	isb
>> -	.if \label != none
>> -	b	\label
>> -	.endif
>> +        ldr     r3, =\mask
>> +        bic     r3, r2, r3            @ Don't trap defined coproc-accesses
>> +        .endif
>> +        mcr     p15, 4, r3, c1, c1, 2
>> +        .if \operation != vmentry
>> +        .if \operation == vmexit
>> +        tst     r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
>> +        beq     1f
>> +        .endif
>> +        isb
>>  1:
>> -	.endif
>> +        .endif
> 
> there are white-space issues here, but I think you can rid of this macro
> entirely now.
> 
>>  .endm
>>  
>>  /* Configures the HDCR (Hyp Debug Configuration Register) on entry/return
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 17e92f0..8dccbd7 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -290,4 +290,13 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
>>  	return data;		/* Leave LE untouched */
>>  }
>>  
>> +static inline void kvm_enable_vcpu_fpexc(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
>> +static inline void vcpu_reset_cptr(struct kvm_vcpu *vcpu) {}
>> +
>> +static inline bool kvm_vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +
>>  #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 4562459..e16fd39 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -248,6 +248,7 @@ static inline void kvm_arch_hardware_unsetup(void) {}
>>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>> +static inline void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
>>  
>>  void kvm_arm_init_debug(void);
>>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>> -- 
>> 1.9.1
>>
> 
> Thanks,
> -Christoffer
> 
