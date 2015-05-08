From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 07/12] KVM: arm64: guest debug, add support for
 single-step
Date: Fri, 8 May 2015 13:52:42 +0200
Message-ID: <20150508115242.GG24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430929407-3487-8-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6715C50C39
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 07:43:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lDtNbpohOU6v for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 May 2015 07:43:48 -0400 (EDT)
Received: from mail-la0-f48.google.com (mail-la0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E13A4FFF0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 07:43:47 -0400 (EDT)
Received: by labbd9 with SMTP id bd9so50922220lab.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 May 2015 04:52:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1430929407-3487-8-git-send-email-alex.bennee@linaro.org>
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

On Wed, May 06, 2015 at 05:23:22PM +0100, Alex Benn=E9e wrote:
> This adds support for single-stepping the guest. To do this we need to
> manipulate the guests PSTATE.SS and MDSCR_EL1.SS bits which we do in the
> kvm_arm_setup/clear_debug() so we don't affect the apparent state of the
> guest. Additionally while the host is debugging the guest we suppress
> the ability of the guest to single-step itself.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v2
>   - Move pstate/mdscr manipulation into C
>   - don't export guest_debug to assembly
>   - add accessor for saved_debug regs
>   - tweak save/restore of mdscr_el1
> v3
>   - don't save PC in debug information struct
>   - rename debug_saved_regs->guest_debug_state
>   - save whole value, only use bits in restore
>   - add save/restore_guest-debug_regs helper functions
>   - simplify commit message for clarity
>   - rm vcpu_debug_saved_reg access fn
> =

> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 064c105..9b3ed6d 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -302,7 +302,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_arm_set_running_vcpu(NULL);
>  }
>  =

> -#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_=
SW_BP)
> +#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE |    \
> +			    KVM_GUESTDBG_USE_SW_BP | \
> +			    KVM_GUESTDBG_SINGLESTEP)
>  =

>  /**
>   * kvm_arch_vcpu_ioctl_set_guest_debug - set up guest debugging
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 7cb99b5..b60fa7a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -123,6 +123,12 @@ struct kvm_vcpu_arch {
>  	 * here.
>  	 */
>  =

> +	/* Guest registers we preserve during guest debugging */
> +	struct {
> +		u32	pstate;

This could do a with a comment: /* preserve SPSR_DEBUG_MASK bits */

> +		u32	mdscr_el1;
> +	} guest_debug_state;
> +
>  	/* Don't run the guest */
>  	bool pause;
>  =

> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 5bee676..19346e8 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -19,11 +19,42 @@
>  =

>  #include <linux/kvm_host.h>
>  =

> +#include <asm/debug-monitors.h>
> +#include <asm/kvm_asm.h>
>  #include <asm/kvm_arm.h>
> +#include <asm/kvm_emulate.h>
> +
> +/* These are the bits of MDSCR_EL1 we may manipulate */
> +#define MDSCR_EL1_DEBUG_MASK	(DBG_MDSCR_SS | \
> +				DBG_MDSCR_KDE | \
> +				DBG_MDSCR_MDE)
> +
> +#define SPSR_DEBUG_MASK DBG_SPSR_SS
>  =

>  static DEFINE_PER_CPU(u32, mdcr_el2);
>  =

>  /**
> + * save/restore_guest_debug_regs
> + *
> + * For some debug operations we need to tweak some guest registers. As
> + * a result we need to save the state of those registers before we
> + * make those modifications.
> + */
> +static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.guest_debug_state.pstate =3D *vcpu_cpsr(vcpu);
> +	vcpu->arch.guest_debug_state.mdscr_el1 =3D vcpu_sys_reg(vcpu, MDSCR_EL1=
);
> +}
> +
> +static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
> +{
> +	*vcpu_cpsr(vcpu) |=3D
> +		(vcpu->arch.guest_debug_state.pstate & SPSR_DEBUG_MASK);
> +	vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D
> +		(vcpu->arch.guest_debug_state.mdscr_el1 & MDSCR_EL1_DEBUG_MASK);

This doesn't look right.  Don't you need to also clear the values if
they were set by us for single-stepping the guest?  At least for the
MDSCR_EL1.SS bit.

What if we're single-stepping through guest code that modifies the SS bits
of these register for the guest state?  Is that possible and do we capture
this somehow?

> +}
> +
> +/**
>   * kvm_arm_init_debug - grab what we need for debug
>   *
>   * Currently the sole task of this function is to retrieve the initial
> @@ -38,7 +69,6 @@ void kvm_arm_init_debug(void)
>  	__this_cpu_write(mdcr_el2, kvm_call_hyp(__kvm_get_mdcr_el2));
>  }
>  =

> -
>  /**
>   * kvm_arm_setup_debug - set up debug related stuff
>   *
> @@ -75,15 +105,37 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  	else
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
>  =

> -	/* Trap breakpoints? */
> -	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
> +	/* Is Guest debugging in effect? */
> +	if (vcpu->guest_debug) {

you could have just checked the field like this in the original patch,
but ok.

>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
> -	else
> -		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;


>  =

> +		/* Save guest debug state */
> +		save_guest_debug_regs(vcpu);
> +
> +		/*
> +		 * Single Step (ARM ARM D2.12.3 The software step state
> +		 * machine)
> +		 *
> +		 * If we are doing Single Step we need to manipulate
> +		 * MDSCR_EL1.SS and PSTATE.SS. If not we need to
> +		 * suppress the guests ability to trigger single step itself.
> +		 */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> +			*vcpu_cpsr(vcpu) |=3D  DBG_SPSR_SS;
> +			vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D DBG_MDSCR_SS;
> +		} else {
> +			*vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;

why must we clear PSTATE.SS when we have MDSCR_EL1.SS =3D=3D 0 ?

> +			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
> +		}
> +
> +	} else {
> +		/* Debug operations can go straight to the guest */
> +		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;

still don't think you need this.

> +	}
>  }
>  =

>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>  {
> -	/* Nothing to do yet */
> +	if (vcpu->guest_debug)
> +		restore_guest_debug_regs(vcpu);
>  }
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 27f38a9..e9de13e 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -103,6 +103,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vc=
pu, struct kvm_run *run)
>  	run->debug.arch.hsr =3D hsr;
>  =

>  	switch (hsr >> ESR_ELx_EC_SHIFT) {
> +	case ESR_ELx_EC_SOFTSTP_LOW:
>  	case ESR_ELx_EC_BKPT32:
>  	case ESR_ELx_EC_BRK64:
>  		break;
> @@ -130,6 +131,7 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_ELx_EC_SYS64]	=3D kvm_handle_sys_reg,
>  	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
> +	[ESR_ELx_EC_SOFTSTP_LOW]=3D kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
>  };
> -- =

> 2.3.5
> =


Thanks,
-Christoffer
