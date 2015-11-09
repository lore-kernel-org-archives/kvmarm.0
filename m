From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH 3/3] KVM/arm64: enable enhanced armv8 fp/simd lazy switch
Date: Mon, 09 Nov 2015 15:13:15 -0800
Message-ID: <5641288B.90105@samsung.com>
References: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
 <1446242193-8424-4-git-send-email-m.smarduch@samsung.com>
 <20151105150255.GD5819@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C3B1412E6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2015 18:13:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nD+K8f8B2i23 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2015 18:13:14 -0500 (EST)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19909411E3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2015 18:13:13 -0500 (EST)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NXK00CQ3LU4M160@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 09 Nov 2015 18:13:16 -0500 (EST)
In-reply-to: <20151105150255.GD5819@cbox>
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
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 11/5/2015 7:02 AM, Christoffer Dall wrote:
> On Fri, Oct 30, 2015 at 02:56:33PM -0700, Mario Smarduch wrote:
>> This patch enables arm64 lazy fp/simd switch, similar to arm described in
>> second patch. Change from previous version - restore function is moved to
>> host. 
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm64/include/asm/kvm_host.h |  2 +-
>>  arch/arm64/kernel/asm-offsets.c   |  1 +
>>  arch/arm64/kvm/hyp.S              | 37 +++++++++++++++++++++++++++++++------
>>  3 files changed, 33 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 26a2347..dcecf92 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -251,11 +251,11 @@ static inline void kvm_arch_hardware_unsetup(void) {}
>>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>> -static inline void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
>>  
>>  void kvm_arm_init_debug(void);
>>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
>> +void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
>>  
>>  #endif /* __ARM64_KVM_HOST_H__ */
>> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
>> index 8d89cf8..c9c5242 100644
>> --- a/arch/arm64/kernel/asm-offsets.c
>> +++ b/arch/arm64/kernel/asm-offsets.c
>> @@ -124,6 +124,7 @@ int main(void)
>>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>>    DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
>>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>> +  DEFINE(VCPU_VFP_DIRTY,	offsetof(struct kvm_vcpu, arch.vfp_dirty));
>>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
>>    DEFINE(VCPU_HOST_DEBUG_STATE, offsetof(struct kvm_vcpu, arch.host_debug_state));
>>    DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_ctl));
>> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
>> index e583613..ed2c4cf 100644
>> --- a/arch/arm64/kvm/hyp.S
>> +++ b/arch/arm64/kvm/hyp.S
>> @@ -36,6 +36,28 @@
>>  #define CPU_SYSREG_OFFSET(x)	(CPU_SYSREGS + 8*x)
>>  
>>  	.text
>> +
>> +/**
>> + * void kvm_restore_host_vfp_state(struct vcpu *vcpu) - Executes lazy
>> + *	fp/simd switch, saves the guest, restores host. Called from host
>> + *	mode, placed outside of hyp section.
> 
> same comments on style as previous patch
> 
>> + */
>> +ENTRY(kvm_restore_host_vfp_state)
>> +	push    xzr, lr
>> +
>> +	add     x2, x0, #VCPU_CONTEXT
>> +	mov     w3, #0
>> +	strb    w3, [x0, #VCPU_VFP_DIRTY]
> 
> I've been discussing with myself if it would make more sense to clear
> the dirty flag in the C-code...
> 
>> +
>> +	bl __save_fpsimd
>> +
>> +	ldr     x2, [x0, #VCPU_HOST_CONTEXT]
>> +	bl __restore_fpsimd
>> +
>> +	pop     xzr, lr
>> +	ret
>> +ENDPROC(kvm_restore_host_vfp_state)
>> +
>>  	.pushsection	.hyp.text, "ax"
>>  	.align	PAGE_SHIFT
>>  
>> @@ -482,7 +504,11 @@
>>  99:
>>  	msr     hcr_el2, x2
>>  	mov	x2, #CPTR_EL2_TTA
>> +
>> +	ldrb	w3, [x0, #VCPU_VFP_DIRTY]
>> +	tbnz    w3, #0, 98f
>>  	orr     x2, x2, #CPTR_EL2_TFP
>> +98:
> 
> mmm, don't you need to only set the fpexc32 when you're actually going
> to trap the guest accesses?
> 
> also, you can consider only setting this in vcpu_load (jumping quickly
> to EL2 to do so) if we're running a 32-bit guest.  Probably worth
> measuring the difference between the extra EL2 jump on vcpu_load
> compared to hitting this register on every entry/exit.
> 
> Code-wise, it will be nicer to do it on vcpu_load.
Hi Christoffer, Marc -
  just want to run this by you, I ran a test with typical number of
fp threads and couple lmbench benchmarks  the stride and bandwidth ones. The
ratio of exits to vcpu puts is high 50:1 or so. But of course that's subject
to the loads you run.

I substituted:
tbnz x2, #HCR_RW_SHIFT, 99f
mov x3, #(1 << 30)
msr fpexc32_el2, x3
isb

with vcpu_load hyp call and check for 32 bit guest in C
mov x1, #(1 << 30)
msr fpexc32_el2, x3
ret

And then
skip_fpsimd_state x8, 2f
mrs	x6, fpexec_el2
str	x6, [x3, #16]

with vcpu_put hyp call with check for 32 bit guest in C this is called
substantially less often then vcpu_load since fp/simd registers are not
always dirty on vcpu_put

kern_hyp_va x0
add x2, x0, #VCPU_CONTEXT
mrs x1, fpexec32_el2
str x1, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
ret

Of course each hyp call has additional overhead, at a high exit to
vcpu_put ratio hyp call appears better. But all this is very
highly dependent on exit rate and fp/simd usage. IMO hyp call
works better under extreme loads should be pretty close
for general loads.

Any thoughts?

- Mario

> 
>>  	msr	cptr_el2, x2
>>  
>>  	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
>> @@ -669,14 +695,12 @@ __restore_debug:
>>  	ret
>>  
>>  __save_fpsimd:
>> -	skip_fpsimd_state x3, 1f
>>  	save_fpsimd
>> -1:	ret
>> +	ret
>>  
>>  __restore_fpsimd:
>> -	skip_fpsimd_state x3, 1f
>>  	restore_fpsimd
>> -1:	ret
>> +	ret
>>  
>>  switch_to_guest_fpsimd:
>>  	push	x4, lr
>> @@ -688,6 +712,9 @@ switch_to_guest_fpsimd:
>>  
>>  	mrs	x0, tpidr_el2
>>  
>> +	mov     w2, #1
>> +	strb    w2, [x0, #VCPU_VFP_DIRTY]
> 
> hmm, just noticing this.  Are you not writing a 32-bit value to a
> potentially 8-bit field (ignoring padding in the struct), as the dirty
> flag is declared a bool.
> 
> Are you also doing this on the 32-bit side?
> 
>> +
>>  	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
>>  	kern_hyp_va x2
>>  	bl __save_fpsimd
>> @@ -763,7 +790,6 @@ __kvm_vcpu_return:
>>  	add	x2, x0, #VCPU_CONTEXT
>>  
>>  	save_guest_regs
>> -	bl __save_fpsimd
>>  	bl __save_sysregs
>>  
>>  	skip_debug_state x3, 1f
>> @@ -784,7 +810,6 @@ __kvm_vcpu_return:
>>  	kern_hyp_va x2
>>  
>>  	bl __restore_sysregs
>> -	bl __restore_fpsimd
>>  	/* Clear FPSIMD and Trace trapping */
>>  	msr     cptr_el2, xzr
>>  
>> -- 
>> 1.9.1
>>
> 
> Thanks,
> -Christoffer
> 
