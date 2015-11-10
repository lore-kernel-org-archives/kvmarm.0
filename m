From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] KVM/arm64: enable enhanced armv8 fp/simd lazy switch
Date: Tue, 10 Nov 2015 12:18:22 +0100
Message-ID: <20151110111822.GC12968@cbox>
References: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
 <1446242193-8424-4-git-send-email-m.smarduch@samsung.com>
 <20151105150255.GD5819@cbox> <5641288B.90105@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E9AE497BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2015 06:18:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 56vPTFYULW8I for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2015 06:18:17 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 357E549630
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2015 06:18:16 -0500 (EST)
Received: by wmvv187 with SMTP id v187so2511072wmv.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2015 03:18:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <5641288B.90105@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 09, 2015 at 03:13:15PM -0800, Mario Smarduch wrote:
> 
> 
> On 11/5/2015 7:02 AM, Christoffer Dall wrote:
> > On Fri, Oct 30, 2015 at 02:56:33PM -0700, Mario Smarduch wrote:
> >> This patch enables arm64 lazy fp/simd switch, similar to arm described in
> >> second patch. Change from previous version - restore function is moved to
> >> host. 
> >>
> >> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> >> ---
> >>  arch/arm64/include/asm/kvm_host.h |  2 +-
> >>  arch/arm64/kernel/asm-offsets.c   |  1 +
> >>  arch/arm64/kvm/hyp.S              | 37 +++++++++++++++++++++++++++++++------
> >>  3 files changed, 33 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >> index 26a2347..dcecf92 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -251,11 +251,11 @@ static inline void kvm_arch_hardware_unsetup(void) {}
> >>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> >>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
> >>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> >> -static inline void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
> >>  
> >>  void kvm_arm_init_debug(void);
> >>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> >>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> >>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> >> +void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
> >>  
> >>  #endif /* __ARM64_KVM_HOST_H__ */
> >> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> >> index 8d89cf8..c9c5242 100644
> >> --- a/arch/arm64/kernel/asm-offsets.c
> >> +++ b/arch/arm64/kernel/asm-offsets.c
> >> @@ -124,6 +124,7 @@ int main(void)
> >>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
> >>    DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
> >>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
> >> +  DEFINE(VCPU_VFP_DIRTY,	offsetof(struct kvm_vcpu, arch.vfp_dirty));
> >>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
> >>    DEFINE(VCPU_HOST_DEBUG_STATE, offsetof(struct kvm_vcpu, arch.host_debug_state));
> >>    DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_ctl));
> >> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> >> index e583613..ed2c4cf 100644
> >> --- a/arch/arm64/kvm/hyp.S
> >> +++ b/arch/arm64/kvm/hyp.S
> >> @@ -36,6 +36,28 @@
> >>  #define CPU_SYSREG_OFFSET(x)	(CPU_SYSREGS + 8*x)
> >>  
> >>  	.text
> >> +
> >> +/**
> >> + * void kvm_restore_host_vfp_state(struct vcpu *vcpu) - Executes lazy
> >> + *	fp/simd switch, saves the guest, restores host. Called from host
> >> + *	mode, placed outside of hyp section.
> > 
> > same comments on style as previous patch
> > 
> >> + */
> >> +ENTRY(kvm_restore_host_vfp_state)
> >> +	push    xzr, lr
> >> +
> >> +	add     x2, x0, #VCPU_CONTEXT
> >> +	mov     w3, #0
> >> +	strb    w3, [x0, #VCPU_VFP_DIRTY]
> > 
> > I've been discussing with myself if it would make more sense to clear
> > the dirty flag in the C-code...
> > 
> >> +
> >> +	bl __save_fpsimd
> >> +
> >> +	ldr     x2, [x0, #VCPU_HOST_CONTEXT]
> >> +	bl __restore_fpsimd
> >> +
> >> +	pop     xzr, lr
> >> +	ret
> >> +ENDPROC(kvm_restore_host_vfp_state)
> >> +
> >>  	.pushsection	.hyp.text, "ax"
> >>  	.align	PAGE_SHIFT
> >>  
> >> @@ -482,7 +504,11 @@
> >>  99:
> >>  	msr     hcr_el2, x2
> >>  	mov	x2, #CPTR_EL2_TTA
> >> +
> >> +	ldrb	w3, [x0, #VCPU_VFP_DIRTY]
> >> +	tbnz    w3, #0, 98f
> >>  	orr     x2, x2, #CPTR_EL2_TFP
> >> +98:
> > 
> > mmm, don't you need to only set the fpexc32 when you're actually going
> > to trap the guest accesses?
> > 
> > also, you can consider only setting this in vcpu_load (jumping quickly
> > to EL2 to do so) if we're running a 32-bit guest.  Probably worth
> > measuring the difference between the extra EL2 jump on vcpu_load
> > compared to hitting this register on every entry/exit.
> > 
> > Code-wise, it will be nicer to do it on vcpu_load.
> Hi Christoffer, Marc -
>   just want to run this by you, I ran a test with typical number of
> fp threads and couple lmbench benchmarks  the stride and bandwidth ones. The
> ratio of exits to vcpu puts is high 50:1 or so. But of course that's subject
> to the loads you run.
> 
> I substituted:
> tbnz x2, #HCR_RW_SHIFT, 99f
> mov x3, #(1 << 30)
> msr fpexc32_el2, x3
> isb
> 
> with vcpu_load hyp call and check for 32 bit guest in C
> mov x1, #(1 << 30)
> msr fpexc32_el2, x3
> ret
> 
> And then
> skip_fpsimd_state x8, 2f
> mrs	x6, fpexec_el2
> str	x6, [x3, #16]
> 
> with vcpu_put hyp call with check for 32 bit guest in C this is called
> substantially less often then vcpu_load since fp/simd registers are not
> always dirty on vcpu_put
> 
> kern_hyp_va x0
> add x2, x0, #VCPU_CONTEXT
> mrs x1, fpexec32_el2
> str x1, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
> ret
> 
> Of course each hyp call has additional overhead, at a high exit to
> vcpu_put ratio hyp call appears better. But all this is very
> highly dependent on exit rate and fp/simd usage. IMO hyp call
> works better under extreme loads should be pretty close
> for general loads.
> 
> Any thoughts?
> 
I think the typical case will be lots of exits and few
vcpu_load/vcpu_put, and I think it's reasonable to write the code that
way.

That should also be much better for VHE.

So I would go that direction.

Thanks,
-Christoffer
