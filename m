From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 2/3] KVM/arm/arm64: enable enhanced armv7 fp/simd lazy
 switch
Date: Fri, 6 Nov 2015 12:37:18 +0100
Message-ID: <20151106113718.GH5819@cbox>
References: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
 <1446242193-8424-3-git-send-email-m.smarduch@samsung.com>
 <20151105144848.GC5819@cbox> <563BF30D.1040101@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6985F4985B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2015 06:33:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BxbCo5Z0uqzm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2015 06:33:57 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6C0C49857
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2015 06:33:56 -0500 (EST)
Received: by wmll128 with SMTP id l128so38364746wml.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Nov 2015 03:37:14 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <563BF30D.1040101@samsung.com>
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

On Thu, Nov 05, 2015 at 04:23:41PM -0800, Mario Smarduch wrote:
> 
> 
> On 11/5/2015 6:48 AM, Christoffer Dall wrote:
> > On Fri, Oct 30, 2015 at 02:56:32PM -0700, Mario Smarduch wrote:
> >> This patch tracks vfp/simd hardware state with a vcpu lazy flag. vCPU lazy 
> >> flag is set on guest access and traps to vfp/simd hardware switch handler. On 
> >> vm-enter if lazy flag is set skip trap enable and save host fpexc. On 
> >> vm-exit if flag is set skip hardware context switch and return to host with 
> >> guest context. In vcpu_put check if vcpu lazy flag is set, and execute a 
> >> hardware context switch to restore host.
> >>
> >> Also some arm64 field and empty function are added to compile for arm64.
> >>
> >> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> >> ---
> >>  arch/arm/include/asm/kvm_host.h   |  1 +
> >>  arch/arm/kvm/arm.c                |  6 ++++
> >>  arch/arm/kvm/interrupts.S         | 60 ++++++++++++++++++++++++++++-----------
> >>  arch/arm/kvm/interrupts_head.S    | 14 +++++----
> >>  arch/arm64/include/asm/kvm_host.h |  4 +++
> >>  5 files changed, 63 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> >> index f1bf551..a9e86e0 100644
> >> --- a/arch/arm/include/asm/kvm_host.h
> >> +++ b/arch/arm/include/asm/kvm_host.h
> >> @@ -227,6 +227,7 @@ int kvm_perf_teardown(void);
> >>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
> >>  
> >>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> >> +void kvm_restore_host_vfp_state(struct kvm_vcpu *);
> >>  
> >>  static inline void kvm_arch_hardware_disable(void) {}
> >>  static inline void kvm_arch_hardware_unsetup(void) {}
> >> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >> index dc017ad..11a56fe 100644
> >> --- a/arch/arm/kvm/arm.c
> >> +++ b/arch/arm/kvm/arm.c
> >> @@ -296,6 +296,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >>  {
> >>  	/*
> >> +	 * If fp/simd registers are dirty save guest, restore host before
> > 
> > If the fp/simd registers are dirty, then restore the host state before
> I'd drop 'releasing the cpu', the vcpu thread may be returning to
> user mode.
> > 
> >> +	 * releasing the cpu.
> >> +	 */
> >> +	if (vcpu->arch.vfp_dirty)
> >> +		kvm_restore_host_vfp_state(vcpu);
> >> +	/*
> >>  	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
> >>  	 * if the vcpu is no longer assigned to a cpu.  This is used for the
> >>  	 * optimized make_all_cpus_request path.
> >> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> >> index 900ef6d..ca25314 100644
> >> --- a/arch/arm/kvm/interrupts.S
> >> +++ b/arch/arm/kvm/interrupts.S
> >> @@ -28,6 +28,32 @@
> >>  #include "interrupts_head.S"
> >>  
> >>  	.text
> >> +/**
> >> + * void kvm_restore_host_vfp_state(struct vcpu *vcpu) - Executes lazy
> > 
> > nit: Can you move the multi-line description of the function into a
> > separate paragraph?
> Sure.
> > 
> >> + * 	fp/simd switch, saves the guest, restores host. Called from host
> >> + *	mode, placed outside of hyp region start/end.
> > 
> > Put the description in a separate paragraph and get rid of the "executes
> > lazy fp/simd swithch" part, that doesn't help understanding.  Just say
> > that this funciton restores the host state.
> Sure.
> > 
> >> + */
> >> +ENTRY(kvm_restore_host_vfp_state)
> >> +#ifdef CONFIG_VFPv3
> >> +	push    {r4-r7}
> >> +
> >> +	add     r7, vcpu, #VCPU_VFP_GUEST
> >> +	store_vfp_state r7
> >> +
> >> +	add     r7, vcpu, #VCPU_VFP_HOST
> >> +	ldr     r7, [r7]
> >> +	restore_vfp_state r7
> >> +
> >> +	ldr     r3, [vcpu, #VCPU_VFP_HOST_FPEXC]
> >> +	VFPFMXR FPEXC, r3
> >> +
> >> +	mov     r3, #0
> >> +	strb    r3, [vcpu, #VCPU_VFP_DIRTY]
> >> +
> >> +	pop     {r4-r7}
> >> +#endif
> >> +	bx      lr
> >> +ENDPROC(kvm_restore_host_vfp_state)
> >>  
> >>  __kvm_hyp_code_start:
> >>  	.globl __kvm_hyp_code_start
> >> @@ -119,11 +145,16 @@ ENTRY(__kvm_vcpu_run)
> >>  	@ If the host kernel has not been configured with VFPv3 support,
> >>  	@ then it is safer if we deny guests from using it as well.
> >>  #ifdef CONFIG_VFPv3
> >> -	@ Set FPEXC_EN so the guest doesn't trap floating point instructions
> >> +	@ fp/simd register file has already been accessed, so skip host fpexc
> >> +	@ save and access trap enable.
> >> +	vfp_inlazy_mode r7, skip_guest_vfp_trap
> > 
> > So, why do we need to touch this register at all on every CPU exit?
> > 
> > Is it not true that we can only be in one of two state:
> >  1) The register file is not dirty (not touched by the guest) and we
> >     should trap
> >  2) The register file is dirty, and we should not trap to EL2?
> > 
> > Only in the first case do we need to set the FPEXC, and couldn't we just
> > do that on vcpu_load and git rid of all this?  (except HCPTR_TCP which
> > we still need to adjust).
> 
> I'm trying to think what happens if you're preempted after you saved
> the FPEXC and set the FPEXC_EN bit in kvm_arch_vcpu_load(). Could some
> thread pick up a bad FPEXC? May be possible to undo in the vcpu_put().

If you're preempted, vcpu_put will be called.  See kvm_preempt_ops in
virt/kvm/kvm_main.c.

> 
> > 
> >> +
> >>  	VFPFMRX r2, FPEXC		@ VMRS
> >> -	push	{r2}
> >> +	str     r2, [vcpu, #VCPU_VFP_HOST_FPEXC]
> >>  	orr	r2, r2, #FPEXC_EN
> >>  	VFPFMXR FPEXC, r2		@ VMSR
> >> +	set_hcptr vmentry, (HCPTR_TCP(10) | HCPTR_TCP(11))
> >> +skip_guest_vfp_trap:
> >>  #endif
> >>  
> >>  	@ Configure Hyp-role
> >> @@ -131,7 +162,7 @@ ENTRY(__kvm_vcpu_run)
> >>  
> >>  	@ Trap coprocessor CRx accesses
> >>  	set_hstr vmentry
> >> -	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
> >> +	set_hcptr vmentry, (HCPTR_TTA)
> > 
> > based on the above I think you can rework this to set the mask based on
> > the dirty flag and only hit the HCPTR once.
> 
> Not sure how to do this, tracing always needs to be enabled, and it's
> independent of FP dirty state.

here, you do:

	ldr r4, HCPTR_TTA
	vfp_skip_if_dirty skip_vfp_trap
	orr r4, r4, #(HCPTR_TCP(10) | HCPTR_TCP(11))
skip_vfp_trap:
	set_hcptr vmentry, r4

if that works with the necessary rework of set_hcptr to take a register,
if the orr can be encoded propertly etc.  Maybe it's not worth it, it
just feels weird to touch this registers twice.  Perhaps the nicer fix
is to just rename/refactor set_hcptr to be two functions, set_hcptr_bits
and clear_hcptr_bits.

Thanks,
-Christoffer
