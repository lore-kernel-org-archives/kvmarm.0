From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 10/18] KVM: arm64: Optimise FPSIMD handling to reduce
 guest/host thrashing
Date: Thu, 24 May 2018 11:18:39 +0100
Message-ID: <20180524101838.GT13470@e103592.cambridge.arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-11-git-send-email-Dave.Martin@arm.com>
 <877enttlfl.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F00B4A0D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 06:08:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TdLMQwgRu2kY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 06:08:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 599724A0C5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 06:08:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <877enttlfl.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 24, 2018 at 11:09:02AM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > This patch refactors KVM to align the host and guest FPSIMD
> > save/restore logic with each other for arm64.  This reduces the
> > number of redundant save/restore operations that must occur, and
> > reduces the common-case IRQ blackout time during guest exit storms
> > by saving the host state lazily and optimising away the need to
> > restore the host state before returning to the run loop.
> >
> > Four hooks are defined in order to enable this:
> >
> >  * kvm_arch_vcpu_run_map_fp():
> >    Called on PID change to map necessary bits of current to Hyp.
> >
> >  * kvm_arch_vcpu_load_fp():
> >    Set up FP/SIMD for entering the KVM run loop (parse as
> >    "vcpu_load fp").
> >
> >  * kvm_arch_vcpu_ctxsync_fp():
> >    Get FP/SIMD into a safe state for re-enabling interrupts after a
> >    guest exit back to the run loop.
> >
> >    For arm64 specifically, this involves updating the host kernel's
> >    FPSIMD context tracking metadata so that kernel-mode NEON use
> >    will cause the vcpu's FPSIMD state to be saved back correctly
> >    into the vcpu struct.  This must be done before re-enabling
> >    interrupts because kernel-mode NEON may be used by softirqs.
> >
> >  * kvm_arch_vcpu_put_fp():
> >    Save guest FP/SIMD state back to memory and dissociate from the
> >    CPU ("vcpu_put fp").
> >
> > Also, the arm64 FPSIMD context switch code is updated to enable it
> > to save back FPSIMD state for a vcpu, not just current.  A few
> > helpers drive this:
> >
> >  * fpsimd_bind_state_to_cpu(struct user_fpsimd_state *fp):
> >    mark this CPU as having context fp (which may belong to a vcpu)
> >    currently loaded in its registers.  This is the non-task
> >    equivalent of the static function fpsimd_bind_to_cpu() in
> >    fpsimd.c.
> >
> >  * task_fpsimd_save():
> >    exported to allow KVM to save the guest's FPSIMD state back to
> >    memory on exit from the run loop.
> >
> >  * fpsimd_flush_state():
> >    invalidate any context's FPSIMD state that is currently loaded.
> >    Used to disassociate the vcpu from the CPU regs on run loop exit.
> >
> > These changes allow the run loop to enable interrupts (and thus
> > softirqs that may use kernel-mode NEON) without having to save the
> > guest's FPSIMD state eagerly.
> >
> > Some new vcpu_arch fields are added to make all this work.  Because
> > host FPSIMD state can now be saved back directly into current's
> > thread_struct as appropriate, host_cpu_context is no longer used
> > for preserving the FPSIMD state.  However, it is still needed for
> > preserving other things such as the host's system registers.  To
> > avoid ABI churn, the redundant storage space in host_cpu_context is
> > not removed for now.
> >
> > arch/arm is not addressed by this patch and continues to use its
> > current save/restore logic.  It could provide implementations of
> > the helpers later if desired.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> >
> > ---
> >
> > Reviewers note: tags retained because this delta is straightforward by
> > itself.  Please shout if you're not happy!
> >
> > Changes since v9:
> >
> >  * Remove redundant set_thread_flag(TIF_FOREIGN_FPSTATE) that is now
> >    implicit in fpsimd_flush_cpu_state().
> > ---
> >  arch/arm/include/asm/kvm_host.h   |   8 +++
> >  arch/arm64/include/asm/fpsimd.h   |   6 +++
> >  arch/arm64/include/asm/kvm_host.h |  21 ++++++++
> >  arch/arm64/kernel/fpsimd.c        |  17 ++++--
> >  arch/arm64/kvm/Kconfig            |   1 +
> >  arch/arm64/kvm/Makefile           |   2 +-
> >  arch/arm64/kvm/fpsimd.c           | 111 ++++++++++++++++++++++++++++++=
++++++++
> >  arch/arm64/kvm/hyp/switch.c       |  51 +++++++++---------
> >  virt/kvm/arm/arm.c                |   4 ++
> >  9 files changed, 191 insertions(+), 30 deletions(-)
> >  create mode 100644 arch/arm64/kvm/fpsimd.c
> >
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm=
_host.h
> > index c7c28c8..ac870b2 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -303,6 +303,14 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vc=
pu,
> >  int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> >  			       struct kvm_device_attr *attr);
> >
> > +/*
> > + * VFP/NEON switching is all done by the hyp switch code, so no need to
> > + * coordinate with host context handling for this state:
> > + */
> > +static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
> > +static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
> > +static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
> > +
> >  /* All host FP/SIMD state is restored on guest exit, so nothing to sav=
e: */
> >  static inline void kvm_fpsimd_flush_cpu_state(void) {}
> >
> > diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/f=
psimd.h
> > index aa7162a..3e00f70 100644
> > --- a/arch/arm64/include/asm/fpsimd.h
> > +++ b/arch/arm64/include/asm/fpsimd.h
> > @@ -41,6 +41,8 @@ struct task_struct;
> >  extern void fpsimd_save_state(struct user_fpsimd_state *state);
> >  extern void fpsimd_load_state(struct user_fpsimd_state *state);
> >
> > +extern void fpsimd_save(void);
> > +
> >  extern void fpsimd_thread_switch(struct task_struct *next);
> >  extern void fpsimd_flush_thread(void);
> >
> > @@ -49,7 +51,11 @@ extern void fpsimd_preserve_current_state(void);
> >  extern void fpsimd_restore_current_state(void);
> >  extern void fpsimd_update_current_state(struct user_fpsimd_state const=
 *state);
> >
> > +extern void fpsimd_bind_task_to_cpu(void);
> > +extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state);
> > +
> >  extern void fpsimd_flush_task_state(struct task_struct *target);
> > +extern void fpsimd_flush_cpu_state(void);
> >  extern void sve_flush_cpu_state(void);
> >
> >  /* Maximum VL that SVE VL-agnostic software can transparently support =
*/
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 146c167..b3fe730 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -30,6 +30,7 @@
> >  #include <asm/kvm.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_mmio.h>
> > +#include <asm/thread_info.h>
> >
> >  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> >
> > @@ -238,6 +239,10 @@ struct kvm_vcpu_arch {
> >
> >  	/* Pointer to host CPU context */
> >  	kvm_cpu_context_t *host_cpu_context;
> > +
> > +	struct thread_info *host_thread_info;	/* hyp VA */
> > +	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
> > +
> >  	struct {
> >  		/* {Break,watch}point registers */
> >  		struct kvm_guest_debug_arch regs;
> > @@ -295,6 +300,9 @@ struct kvm_vcpu_arch {
> >
> >  /* vcpu_arch flags field values: */
> >  #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
> > +#define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
> > +#define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded
> >  */
> =

> I may be descending into bike-shedding territory here but it seems a
> little incongruous to have _ENABLED =3D guest FP state when we have _HOST
> for host FP state. Why not KVM_ARM64_FP_GUEST?

I thought about this, but wanted to retain the clear relationship
between the _ENABLED flag and the state of the FPSIMD trap controls.

The HOST flag has no direct relationship with trap controls, so these
seemed different enough things to justify different names, though the
inconsistency was a bit annoying.

[...]

> Minor bike-shedding aside:
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks.  I'll probably leave it as is, but shout if you're unhappy with
this.

Cheers
---Dave
