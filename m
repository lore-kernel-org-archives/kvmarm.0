From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 19/21] arm64: KVM: Move most of the fault decoding to C
Date: Tue, 2 Feb 2016 16:50:16 +0100
Message-ID: <20160202155016.GG6190@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-20-git-send-email-marc.zyngier@arm.com>
 <20160201152122.GY1478@cbox> <56B0BC10.40309@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4177240BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2016 10:44:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UWs9PGq-lzbi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2016 10:44:28 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A91DF40402
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2016 10:44:28 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id p63so124353800wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Feb 2016 07:49:50 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <56B0BC10.40309@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 02, 2016 at 02:24:16PM +0000, Marc Zyngier wrote:
> On 01/02/16 15:21, Christoffer Dall wrote:
> > On Mon, Jan 25, 2016 at 03:53:53PM +0000, Marc Zyngier wrote:
> >> The fault decoding process (including computing the IPA in the case
> >> of a permission fault) would be much better done in C code, as we
> >> have a reasonable infrastructure to deal with the VHE/non-VHE
> >> differences.
> >>
> >> Let's move the whole thing to C, including the workaround for
> >> erratum 834220, and just patch the odd ESR_EL2 access remaining
> >> in hyp-entry.S.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/kernel/asm-offsets.c |  3 --
> >>  arch/arm64/kvm/hyp/hyp-entry.S  | 69 +++--------------------------------------
> >>  arch/arm64/kvm/hyp/switch.c     | 54 ++++++++++++++++++++++++++++++++
> >>  3 files changed, 59 insertions(+), 67 deletions(-)
> >>
> >> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> >> index fffa4ac6..b0ab4e9 100644
> >> --- a/arch/arm64/kernel/asm-offsets.c
> >> +++ b/arch/arm64/kernel/asm-offsets.c
> >> @@ -110,9 +110,6 @@ int main(void)
> >>    DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
> >>    DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
> >>    DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
> >> -  DEFINE(VCPU_ESR_EL2,		offsetof(struct kvm_vcpu, arch.fault.esr_el2));
> >> -  DEFINE(VCPU_FAR_EL2,		offsetof(struct kvm_vcpu, arch.fault.far_el2));
> >> -  DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_el2));
> >>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
> >>  #endif
> >>  #ifdef CONFIG_CPU_PM
> >> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> >> index 9e0683f..213de52 100644
> >> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> >> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> >> @@ -19,7 +19,6 @@
> >>  
> >>  #include <asm/alternative.h>
> >>  #include <asm/assembler.h>
> >> -#include <asm/asm-offsets.h>
> >>  #include <asm/cpufeature.h>
> >>  #include <asm/kvm_arm.h>
> >>  #include <asm/kvm_asm.h>
> >> @@ -67,7 +66,11 @@ ENDPROC(__vhe_hyp_call)
> >>  el1_sync:				// Guest trapped into EL2
> >>  	save_x0_to_x3
> >>  
> >> +alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> >>  	mrs	x1, esr_el2
> >> +alternative_else
> >> +	mrs	x1, esr_el1
> >> +alternative_endif
> > 
> > I suppose this is not technically part of what the patch description
> > says it does, but ok...
> 
> That's what the "... and just patch the odd ESR_EL2 access remaining in
> hyp-entry.S." meant. Would you prefer this as a separate patch?
> 

I guess I stopped reading at ", and" for some reason, sorry.

It's fine to keep it in this patch.

> > 
> >>  	lsr	x2, x1, #ESR_ELx_EC_SHIFT
> >>  
> >>  	cmp	x2, #ESR_ELx_EC_HVC64
> >> @@ -103,72 +106,10 @@ el1_trap:
> >>  	cmp	x2, #ESR_ELx_EC_FP_ASIMD
> >>  	b.eq	__fpsimd_guest_restore
> >>  
> >> -	cmp	x2, #ESR_ELx_EC_DABT_LOW
> >> -	mov	x0, #ESR_ELx_EC_IABT_LOW
> >> -	ccmp	x2, x0, #4, ne
> >> -	b.ne	1f		// Not an abort we care about
> >> -
> >> -	/* This is an abort. Check for permission fault */
> >> -alternative_if_not ARM64_WORKAROUND_834220
> >> -	and	x2, x1, #ESR_ELx_FSC_TYPE
> >> -	cmp	x2, #FSC_PERM
> >> -	b.ne	1f		// Not a permission fault
> >> -alternative_else
> >> -	nop			// Use the permission fault path to
> >> -	nop			// check for a valid S1 translation,
> >> -	nop			// regardless of the ESR value.
> >> -alternative_endif
> >> -
> >> -	/*
> >> -	 * Check for Stage-1 page table walk, which is guaranteed
> >> -	 * to give a valid HPFAR_EL2.
> >> -	 */
> >> -	tbnz	x1, #7, 1f	// S1PTW is set
> >> -
> >> -	/* Preserve PAR_EL1 */
> >> -	mrs	x3, par_el1
> >> -	stp	x3, xzr, [sp, #-16]!
> >> -
> >> -	/*
> >> -	 * Permission fault, HPFAR_EL2 is invalid.
> >> -	 * Resolve the IPA the hard way using the guest VA.
> >> -	 * Stage-1 translation already validated the memory access rights.
> >> -	 * As such, we can use the EL1 translation regime, and don't have
> >> -	 * to distinguish between EL0 and EL1 access.
> >> -	 */
> >> -	mrs	x2, far_el2
> >> -	at	s1e1r, x2
> >> -	isb
> >> -
> >> -	/* Read result */
> >> -	mrs	x3, par_el1
> >> -	ldp	x0, xzr, [sp], #16	// Restore PAR_EL1 from the stack
> >> -	msr	par_el1, x0
> >> -	tbnz	x3, #0, 3f		// Bail out if we failed the translation
> >> -	ubfx	x3, x3, #12, #36	// Extract IPA
> >> -	lsl	x3, x3, #4		// and present it like HPFAR
> >> -	b	2f
> >> -
> >> -1:	mrs	x3, hpfar_el2
> >> -	mrs	x2, far_el2
> >> -
> >> -2:	mrs	x0, tpidr_el2
> >> -	str	w1, [x0, #VCPU_ESR_EL2]
> >> -	str	x2, [x0, #VCPU_FAR_EL2]
> >> -	str	x3, [x0, #VCPU_HPFAR_EL2]
> >> -
> >> +	mrs	x0, tpidr_el2
> >>  	mov	x1, #ARM_EXCEPTION_TRAP
> >>  	b	__guest_exit
> >>  
> >> -	/*
> >> -	 * Translation failed. Just return to the guest and
> >> -	 * let it fault again. Another CPU is probably playing
> >> -	 * behind our back.
> >> -	 */
> >> -3:	restore_x0_to_x3
> >> -
> >> -	eret
> >> -
> >>  el1_irq:
> >>  	save_x0_to_x3
> >>  	mrs	x0, tpidr_el2
> >> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >> index 0cadb7f..df2cce9 100644
> >> --- a/arch/arm64/kvm/hyp/switch.c
> >> +++ b/arch/arm64/kvm/hyp/switch.c
> >> @@ -15,6 +15,7 @@
> >>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> >>   */
> >>  
> >> +#include <linux/types.h>
> >>  #include <asm/kvm_asm.h>
> >>  
> >>  #include "hyp.h"
> >> @@ -150,6 +151,55 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
> >>  	__vgic_call_restore_state()(vcpu);
> >>  }
> >>  
> >> +static hyp_alternate_value(__check_arm_834220,
> >> +			   false, true,
> >> +			   ARM64_WORKAROUND_834220);
> >> +
> >> +static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
> >> +{
> >> +	u64 esr = read_sysreg_el2(esr);
> >> +	u8 ec = esr >> ESR_ELx_EC_SHIFT;
> >> +	u64 hpfar, far;
> >> +
> >> +	vcpu->arch.fault.esr_el2 = esr;
> >> +
> >> +	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
> >> +		return true;
> >> +
> >> +	far = read_sysreg_el2(far);
> >> +
> >> +	if (!(esr & ESR_ELx_S1PTW) &&
> >> +	    (__check_arm_834220() || (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
> > 
> > this is really hard to read.  How do you feel about putting the below
> > block into its own function and changing to something like this:
> > 
> > /*
> >  * The HPFAR can be invalid if the stage 2 fault did not happen during a
> >  * stage 1 page table walk (the ESR_EL2.S1PTW bit is clear) and one of
> >  * the two following cases are true:
> >  *   1. The fault was due to a permission fault
> >  *   2. The processor carries errata 834220
> >  *
> >  * Therefore, for all non S1PTW faults where we either have a permission
> >  * fault or the errata workaround is enabled, we resolve the IPA using
> >  * the AT instruction.
> >  */
> > if (!(esr & ESR_ELx_S1PTW) &&
> >     (__check_arm_834220() || (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
> >     	if (!__translate_far_to_ipa(&hpfar))
> > 		return false; /* Translation failed, back to guest */
> > } else {
> > 	hpfar = read_sysreg(hpfar_el2);
> > }
> > 
> > not sure if it helps that much, perhaps it's just complicated by nature.
> > 
> >> +		u64 par, tmp;
> >> +
> >> +		/*
> >> +		 * Permission fault, HPFAR_EL2 is invalid. Resolve the
> >> +		 * IPA the hard way using the guest VA.
> >> +		 * Stage-1 translation already validated the memory
> >> +		 * access rights. As such, we can use the EL1
> >> +		 * translation regime, and don't have to distinguish
> >> +		 * between EL0 and EL1 access.
> >> +		 */
> >> +		par = read_sysreg(par_el1);
> > 
> > in any cas I think we also need the comment about preserving par_el1
> > here, which is only something we do because we may return early, IIUC.
> 
> Not only. At that point, we still haven't saved the vcpu sysregs, so we
> most save/restore it in order to save it later for good. Not the fastest
> thing, but I guess that everything sucks so much when we take a page
> fault that it really doesn't matter.
> 

right.  I was a bit confued by reading this code in the C version, but
on the other hand, this code is the kind of code you shouldn't try to
think you can easily understand, but you really have to know what you're
doing here, so perhaps I'm creating too much fuss for nothing.

> > 
> >> +		asm volatile("at s1e1r, %0" : : "r" (far));
> >> +		isb();
> >> +
> >> +		tmp = read_sysreg(par_el1);
> >> +		write_sysreg(par, par_el1);
> >> +
> >> +		if (unlikely(tmp & 1))
> >> +			return false; /* Translation failed, back to guest */
> >> +
> > 
> > nit: add comment /* Convert PAR to HPFAR format */
> > 
> >> +		hpfar = ((tmp >> 12) & ((1UL << 36) - 1)) << 4;
> >> +	} else {
> >> +		hpfar = read_sysreg(hpfar_el2);
> >> +	}
> >> +
> >> +	vcpu->arch.fault.far_el2 = far;
> >> +	vcpu->arch.fault.hpfar_el2 = hpfar;
> >> +	return true;
> >> +}
> >> +
> >>  static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
> >>  {
> >>  	struct kvm_cpu_context *host_ctxt;
> >> @@ -181,9 +231,13 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
> >>  	__debug_restore_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
> >>  
> >>  	/* Jump in the fire! */
> >> +again:
> >>  	exit_code = __guest_enter(vcpu, host_ctxt);
> >>  	/* And we're baaack! */
> >>  
> >> +	if (exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
> >> +		goto again;
> >> +
> >>  	fp_enabled = __fpsimd_enabled();
> >>  
> >>  	__sysreg_save_guest_state(guest_ctxt);
> >> -- 
> >> 2.1.4
> >>
> > The good news are that I couldn't find any bugs in the code.
> 
> Right. So I've applied most of your comments directly, because they
> definitely made sense. let's see how it looks on round 3.
> 
ok, sounds great.

Thanks,
-Christoffer
