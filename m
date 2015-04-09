From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 07/10] KVM: arm64: guest debug, add support for
 single-step
Date: Thu, 9 Apr 2015 15:24:43 +0200
Message-ID: <20150409132442.GE3212@hawk.usersys.redhat.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-8-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427814488-28467-8-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 31, 2015 at 04:08:05PM +0100, Alex Benn=E9e wrote:
> This adds support for single-stepping the guest. As userspace can and
> will manipulate guest registers before restarting any tweaking of the
> registers has to occur just before control is passed back to the gues=
t.
> Furthermore while guest debugging is in effect we need to squash the
> ability of the guest to single-step itself as we have no easy way of
> re-entering the guest after the exception has been delivered to the
> hypervisor.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
> ---
> v2
>   - Move pstate/mdscr manipulation into C
>   - don't export guest_debug to assembly
>   - add accessor for saved_debug regs
>   - tweak save/restore of mdscr_el1
>=20
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d3bc8dc..c1ed8cb 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -304,7 +304,21 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_arm_set_running_vcpu(NULL);
>  }
> =20
> -#define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE|KVM_GUESTDBG_USE_SW_=
BP)
> +#define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE |    \
> +			    KVM_GUESTDBG_USE_SW_BP | \
> +			    KVM_GUESTDBG_SINGLESTEP)
> +
> +/**
> + * kvm_arch_vcpu_ioctl_set_guest_debug - Setup guest debugging
> + * @kvm:	pointer to the KVM struct
> + * @kvm_guest_debug: the ioctl data buffer
> + *
> + * This sets up the VM for guest debugging. Care has to be taken whe=
n
> + * manipulating guest registers as these will be set/cleared by the
> + * hyper-visor controller, typically before each kvm_run event. As a
> + * result modification of the guest registers needs to take place
> + * after they have been restored in the hyp.S trampoline code.
> + */
> =20
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> index 0631840..6a33647 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -121,6 +121,13 @@ struct kvm_vcpu_arch {
>  	 * here.
>  	 */
> =20
> +	/* Registers pre any guest debug manipulations */
> +	struct {
> +		u32	pstate_ss_bit;
> +		u32	mdscr_el1_bits;
> +
> +	} debug_saved_regs;

Hmm, you have a struct called "regs", but then each member is
suffixed with _bit(s). This looks awkward.


> +
>  	/* Don't run the guest */
>  	bool pause;
> =20
> @@ -143,6 +150,7 @@ struct kvm_vcpu_arch {
> =20
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  #define vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
> +#define vcpu_debug_saved_reg(v, r) ((v)->arch.debug_saved_regs.r)
>  /*
>   * CP14 and CP15 live in the same array, as they are backed by the
>   * same system registers.
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index cff0475..b32362c 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -19,8 +19,16 @@
> =20
>  #include <linux/kvm_host.h>
> =20
> +#include <asm/debug-monitors.h>
> +#include <asm/kvm_asm.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_host.h>
> +#include <asm/kvm_emulate.h>
> +
> +/* These are the bits of MDSCR_EL1 we may mess with */
> +#define MDSCR_EL1_DEBUG_BITS	(DBG_MDSCR_SS | \
> +				DBG_MDSCR_KDE | \
> +				DBG_MDSCR_MDE)

_MASK instead of _BITS ?

> =20
>  /**
>   * kvm_arch_setup_debug - set-up debug related stuff
> @@ -51,15 +59,46 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  	else
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
> =20
> -	/* Trap breakpoints? */
> -	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
> +	/* Is Guest debugging in effect? */
> +	if (vcpu->guest_debug) {
>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
> -	else
> -		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;
> =20
> +		/* Save pstate/mdscr */
> +		vcpu_debug_saved_reg(vcpu, pstate_ss_bit) =3D
> +			*vcpu_cpsr(vcpu) & DBG_SPSR_SS;
> +		vcpu_debug_saved_reg(vcpu, mdscr_el1_bits) =3D
> +			vcpu_sys_reg(vcpu, MDSCR_EL1) & MDSCR_EL1_DEBUG_BITS;

I think it would be clearer if we embed the masks into helper
functions, and, assuming we drop the _bits concept too, then

#define SPSR_DEBUG_MASK DBG_SPSR_SS

vcpu_debug_save_regs(vcpu)
{
  vcpu->arch.debug_saved_regs.pstate =3D *vcpu_cpsr(vcpu);
  vcpu->arch.debug_saved_regs.mdscr_el1 =3D vcpu_sys_reg(vcpu, MDSCR_EL=
1);
}

vcpu_debug_restore_regs(vcpu)
{
  *vcpu_cpsr(vcpu) |=3D
       (vcpu->arch.debug_saved_regs.pstate & SPSR_DEBUG_MASK);
  vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D
       (vcpu->arch.debug_saved_regs.mdscr_el1 & MDSCR_EL1_DEBUG_MASK)
}

> +		/*
> +		 * Single Step (ARM ARM D2.12.3 The software step state
> +		 * machine)
> +		 *
> +		 * If we are doing Single Step we need to manipulate
> +		 * MDSCR_EL1.SS and PSTATE.SS. If not we need to
> +		 * suppress the guest from messing with it.
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
> =20
>  void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
>  {
> -	/* Nothing to do yet */

This would now just be

  if (vcpu->guest_debug)
     vcpu_debug_restore_regs(vcpu);

> +	if (vcpu->guest_debug) {
> +		/* Restore pstate/mdscr bits we may have messed with */
> +		*vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;
> +		*vcpu_cpsr(vcpu) |=3D vcpu_debug_saved_reg(vcpu, pstate_ss_bit);
> +
> +		vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~MDSCR_EL1_DEBUG_BITS;
> +		vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D
> +			vcpu_debug_saved_reg(vcpu, mdscr_el1_bits);
> +	}
>  }
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exi=
t.c
> index ed1bbb4..16accae 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -101,6 +101,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu=
 *vcpu, struct kvm_run *run)
>  	run->debug.arch.hsr =3D hsr;
> =20
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
> --=20
> 2.3.4
>=20
