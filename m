From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 07/15] KVM: arm64: Optimise FPSIMD handling to reduce
 guest/host thrashing
Date: Wed, 9 May 2018 10:17:04 +0100
Message-ID: <20180509091701.GM7753@e103592.cambridge.arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
 <1525797900-5548-8-git-send-email-Dave.Martin@arm.com>
 <cd45aff8-66dd-b6bc-ada0-189b45e09d17@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <cd45aff8-66dd-b6bc-ada0-189b45e09d17@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 09, 2018 at 09:24:36AM +0100, Marc Zyngier wrote:
> On 08/05/18 17:44, Dave Martin wrote:
> > This patch refactors KVM to align the host and guest FPSIMD
> > save/restore logic with each other for arm64.  This reduces the

[...]

> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 9699c13..6429eb6 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -33,6 +33,8 @@
> >  /* vcpu_arch flags field values: */
> >  #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
> >  #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
> 
> At some point, we could remove KVM_ARM64_DEBUG_DIRTY_SHIFT as it is not
> used anymore (since 1ea66d27e7b0). Do not respin on this account though.

I wondered about this...  I presume this was used from assembly once
upon a time.

Since I need to repost for something else anyway, shall I delete that
and move the defines to kvm_host.h?  There's no longer an obvious reason
for them to be in a different header.

[...]

> > diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> > new file mode 100644
> > index 0000000..7059275
> > --- /dev/null
> > +++ b/arch/arm64/kvm/fpsimd.c
> > @@ -0,0 +1,111 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * arch/arm64/kvm/fpsimd.c: Guest/host FPSIMD context coordination helpers
> > + *
> > + * Copyright 2018 Arm Limited
> > + * Author: Dave Martin <Dave.Martin@arm.com>
> > + */
> > +#include <linux/bottom_half.h>
> > +#include <linux/sched.h>
> > +#include <linux/thread_info.h>
> > +#include <linux/kvm_host.h>
> > +#include <asm/kvm_asm.h>
> > +#include <asm/kvm_host.h>
> > +#include <asm/kvm_mmu.h>
> > +
> > +/*
> > + * Called on entry to KVM_RUN unless this vcpu previously ran at least
> > + * once and the most recent prior KVM_RUN for this vcpu was called from
> > + * the same task as current (highly likely).
> > + *
> > + * This is guaranteed to execute before kvm_arch_vcpu_load_fp(vcpu),
> > + * such that on entering hyp the relevant parts of current are already
> > + * mapped.
> > + */
> > +int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
> > +{
> > +	int ret;
> > +
> > +	struct thread_info *ti = &current->thread_info;
> > +	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
> > +
> > +	/*
> > +	 * Make sure the host task thread flags and fpsimd state are
> > +	 * visible to hyp:
> > +	 */
> > +	ret = create_hyp_mappings(ti, ti + 1, PAGE_HYP);
> > +	if (ret)
> > +		goto error;
> > +
> > +	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
> > +	if (ret)
> > +		goto error;
> > +
> > +	vcpu->arch.host_thread_info = kern_hyp_va(ti);
> > +	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
> 
> Since we assign host_fpsimd_state here, and that "map" is guaranteed to
> execute before "load"...
> 
> > +error:
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
> > + * The actual loading is done by the FPSIMD access trap taken to hyp.
> > + *
> > + * Here, we just set the correct metadata to indicate that the FPSIMD
> > + * state in the cpu regs (if any) belongs to current, and where to write
> > + * it back to if/when a FPSIMD access trap is taken.
> > + *
> > + * TIF_SVE is backed up here, since it may get clobbered with guest state.
> > + * This flag is restored by kvm_arch_vcpu_put_fp(vcpu).
> > + */
> > +void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> > +{
> > +	BUG_ON(system_supports_sve());
> > +	BUG_ON(!current->mm);
> > +
> > +	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_HOST_SVE_IN_USE);
> > +	if (test_thread_flag(TIF_SVE))
> > +		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
> > +
> > +	vcpu->arch.host_fpsimd_state =
> > +		kern_hyp_va(&current->thread.uw.fpsimd_state);
> 
> ... what is the purpose of this assignment? I don't think it is harmful
> in any way, but I'm just wondering if I'm missing in the actual flow.

The pointer will be NULLed by __hyp_switch_fpsimd() when loading the
guest state in, to indicate that there is no longer any host state to
save.  Perhaps it would have been clearer to have a separate flag to
represent this change of state.

As things stand I think you're right: the assignments are redundant.  
We certainly need the pointer to reflect the current task, which is
the motivation for doing it here -- but in fact we need to do it
more often, at every vcpu_load().

I think the most appropriate thing is to delete the assignment from
_map_fp().

The alternative would be to add a flag for the "no host state to save"
case, and fpsimd_host_state only in the pid_change hook.

[...]

> > +/*
> > + * Write back the vcpu FPSIMD regs if they are dirty, and invalidate the
> > + * cpu FPSIMD regs so that they can't be spuriously reused if this vcpu
> > + * disappears and another task or vcpu appears that recycles the same
> > + * struct fpsimd_state.
> > + */
> > +void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> > +{
> > +	local_bh_disable();
> > +
> > +	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> > +		fpsimd_save();
> > +		fpsimd_flush_cpu_state();
> > +		set_thread_flag(TIF_FOREIGN_FPSTATE);
> > +	}
> > +
> > +	update_thread_flag(TIF_SVE,
> > +			   vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE);
> 
> Does this indicate anything about the validity of the SVE registers? Or
> is it for the sole purpose of userspace not having to trap to re-enable SVE?

This is the host task's "SVE registers exist" flag.  It's essential to
restore this correctly before re-enabling preemption, because it
controls where the regs are saved/restored from:
current->thread.fpsimd_state, or the dynamically allocated buffer
current->thread.sve_state (TIF_SVE set indicates the latter).

TIF_FOREIGN_FPSTATE is orthogonal to this, and indicates whether the
regs are actually loaded in the hardware.  Obviously they aren't if
we had loaded the guest's regs meanwhile.

[...]

> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index c0796c4..75c3b65 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -27,15 +27,16 @@
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/fpsimd.h>
> >  #include <asm/debug-monitors.h>
> > +#include <asm/thread_info.h>
> >  
> > -static bool __hyp_text __fpsimd_enabled_nvhe(void)
> > +static bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
> >  {
> > -	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
> > -}
> > +	if (vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE) {
> > +		vcpu->arch.host_fpsimd_state = NULL;
> > +		vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
> > +	}
> 
> I must confess I don't get this bit. If we started off with an invalid
> host state (which is how I interpret TIF_FOREIGN_FPSTATE), why didn't we
> simply zero the pointer at load time? The thread flag cannot change in
> the meantime, right? Or did I get that wrong?

The host kernel can take interrupts in the run loop while outside the
guest, causing this flag to get set.  So we really do need to re-check
on each entry to the guest.

I can add a one-line comment documenting the purpose of this function,
which should help understanding here, something like:

/* Check whether the FP regs were dirtied while in the host-side run loop */

[...]

> It otherwise looks good, and I don't think the above nits are
> problematic on their own.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks.

I will probably address the nits since I need to fix another build break
issue with CONFIG_KVM=n.  That will be a pretty trivial respin.

Happy to keep your Reviewed-by with the discussed changes?

Cheers
---Dave
