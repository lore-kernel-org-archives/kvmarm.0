From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 07/10] KVM: arm64: guest debug, add support for
 single-step
Date: Tue, 14 Apr 2015 10:27:02 +0200
Message-ID: <20150414082702.GT6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-8-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 071A74CFF0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 04:19:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WkXzu96GQPgH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2015 04:19:07 -0400 (EDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
 [209.85.217.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 841E74CFDB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 04:19:07 -0400 (EDT)
Received: by lbbqq2 with SMTP id qq2so2113119lbb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 01:26:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1427814488-28467-8-git-send-email-alex.bennee@linaro.org>
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
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, Catalin Marinas <catalin.marinas@arm.com>, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On Tue, Mar 31, 2015 at 04:08:05PM +0100, Alex Benn=E9e wrote:
> This adds support for single-stepping the guest. As userspace can and
> will manipulate guest registers before restarting any tweaking of the
> registers has to occur just before control is passed back to the guest.

this sentence is hard to read.  Do you mean:

(a) As userspace can and will manipulate guest register, we must ensure
that any tweaking of the registers before restarting the guest happens
immediately before...

or

(b) As userspace manipulates guest registers before restarting the
guest, we must ensure that any tweaking of the register happens
immediately before...

> Furthermore while guest debugging is in effect we need to squash the

Furthermore, while guest debugging is in effect,
(commas)

> ability of the guest to single-step itself as we have no easy way of
> re-entering the guest after the exception has been delivered to the
> hypervisor.

I'm not sure I understand this last part of the sentence.  Is the point
that if we trap on a guest single-step exception we cannot easily inject
such an exception back into the guest and therefore we trap the guest if
it tries to set itself up for single-stepping?

What is our recourse then?  To just ignore the single-step setting of
the guest and execute it as normal (while single-stepping the guest from
the outside)?

> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v2
>   - Move pstate/mdscr manipulation into C
>   - don't export guest_debug to assembly
>   - add accessor for saved_debug regs
>   - tweak save/restore of mdscr_el1
> =

> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d3bc8dc..c1ed8cb 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -304,7 +304,21 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_arm_set_running_vcpu(NULL);
>  }
>  =

> -#define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE|KVM_GUESTDBG_USE_SW_BP)
> +#define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE |    \
> +			    KVM_GUESTDBG_USE_SW_BP | \
> +			    KVM_GUESTDBG_SINGLESTEP)
> +
> +/**
> + * kvm_arch_vcpu_ioctl_set_guest_debug - Setup guest debugging
> + * @kvm:	pointer to the KVM struct
> + * @kvm_guest_debug: the ioctl data buffer
> + *
> + * This sets up the VM for guest debugging. Care has to be taken when
> + * manipulating guest registers as these will be set/cleared by the
> + * hyper-visor controller, typically before each kvm_run event. As a

which guest registers are set/cleared by userspace exactly?

s/by the hyper-visor controller/by userspace/

> + * result modification of the guest registers needs to take place

As a result, (comma)

s/needs to/must/

> + * after they have been restored in the hyp.S trampoline code.

trampoline code?  The trampoline code we are referring to is in
hyp-init.S.  Do you mean in EL2?  Then just sya in hyp.S or say in EL2
or in hyp mode.

> + */
>  =

>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 0631840..6a33647 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -121,6 +121,13 @@ struct kvm_vcpu_arch {
>  	 * here.
>  	 */
>  =

> +	/* Registers pre any guest debug manipulations */

I couldn't find 'pre' as an independent word in any English
dictionaries.  I'm also not entirely sure what you mean?  Who modifies
this when, and why do we need to store this?

> +	struct {
> +		u32	pstate_ss_bit;
> +		u32	mdscr_el1_bits;
> +
> +	} debug_saved_regs;

If I understood this state correctly (see below), then guest_debug_state
is probably a better name for this struct.

> +
>  	/* Don't run the guest */
>  	bool pause;
>  =

> @@ -143,6 +150,7 @@ struct kvm_vcpu_arch {
>  =

>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  #define vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
> +#define vcpu_debug_saved_reg(v, r) ((v)->arch.debug_saved_regs.r)

hmm, not sure this is warranted if the 'saved_regs' is not the current
state of the VM, which is sort of what the vcpu_gp_regs() and friends
hint at.  Maybe I'm just not getting exactly what piece of state it is.

>  /*
>   * CP14 and CP15 live in the same array, as they are backed by the
>   * same system registers.
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index cff0475..b32362c 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -19,8 +19,16 @@
>  =

>  #include <linux/kvm_host.h>
>  =

> +#include <asm/debug-monitors.h>
> +#include <asm/kvm_asm.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_host.h>
> +#include <asm/kvm_emulate.h>
> +
> +/* These are the bits of MDSCR_EL1 we may mess with */

we may mess with?  Can you be more specific?

> +#define MDSCR_EL1_DEBUG_BITS	(DBG_MDSCR_SS | \
> +				DBG_MDSCR_KDE | \
> +				DBG_MDSCR_MDE)
>  =

>  /**
>   * kvm_arch_setup_debug - set-up debug related stuff
> @@ -51,15 +59,46 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  	else
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
>  =

> -	/* Trap breakpoints? */
> -	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
> +	/* Is Guest debugging in effect? */
> +	if (vcpu->guest_debug) {
>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
> -	else
> -		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;
>  =

> +		/* Save pstate/mdscr */
> +		vcpu_debug_saved_reg(vcpu, pstate_ss_bit) =3D
> +			*vcpu_cpsr(vcpu) & DBG_SPSR_SS;
> +		vcpu_debug_saved_reg(vcpu, mdscr_el1_bits) =3D
> +			vcpu_sys_reg(vcpu, MDSCR_EL1) & MDSCR_EL1_DEBUG_BITS;

nit: add blank line

> +		/*
> +		 * Single Step (ARM ARM D2.12.3 The software step state
> +		 * machine)
> +		 *
> +		 * If we are doing Single Step we need to manipulate
> +		 * MDSCR_EL1.SS and PSTATE.SS. If not we need to
> +		 * suppress the guest from messing with it.

If not, we must prevent the guest from modifying them.
     ^^^    ^^^    ^^^                            ^^^

Why must we prevent the guest from modifying them if we're not
single-stepping the guest?


> +		 */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> +			*vcpu_cpsr(vcpu) |=3D  DBG_SPSR_SS;
> +			vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D DBG_MDSCR_SS;
> +		} else {
> +			*vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;
> +			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
> +		}
> +
> +	} else {
> +		/* Debug operations can go straight to the guest */
> +		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;
> +	}
>  }
>  =

>  void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
>  {
> -	/* Nothing to do yet */
> +	if (vcpu->guest_debug) {
> +		/* Restore pstate/mdscr bits we may have messed with */

Can you be more specific than "messed with"?  "... bits that may have
been modified if we were debugging the guest" ?

Drew's suggestion may make this easier to read...


> +		*vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;
> +		*vcpu_cpsr(vcpu) |=3D vcpu_debug_saved_reg(vcpu, pstate_ss_bit);
> +
> +		vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~MDSCR_EL1_DEBUG_BITS;
> +		vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D
> +			vcpu_debug_saved_reg(vcpu, mdscr_el1_bits);

So the debug_saved_reg is simply the guest's view of the debug
registers?  In that case I think vcpu_guest_dbg_reg() is more clear.



> +	}
>  }
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index ed1bbb4..16accae 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -101,6 +101,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vc=
pu, struct kvm_run *run)
>  	run->debug.arch.hsr =3D hsr;
>  =

>  	switch (hsr >> ESR_ELx_EC_SHIFT) {
> +	case ESR_ELx_EC_SOFTSTP_LOW:
>  	case ESR_ELx_EC_BKPT32:
>  	case ESR_ELx_EC_BRK64:
>  		run->debug.arch.pc =3D *vcpu_pc(vcpu);
> @@ -127,6 +128,7 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_ELx_EC_SYS64]	=3D kvm_handle_sys_reg,
>  	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
> +	[ESR_ELx_EC_SOFTSTP_LOW]=3D kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
>  };
> -- =

> 2.3.4
> =
