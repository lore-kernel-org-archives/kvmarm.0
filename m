From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH] kvm: arm64: handle single-step of hyp emulated mmio
 instructions
Date: Wed, 22 Nov 2017 21:41:58 +0100
Message-ID: <20171122204158.GW28855@cbox>
References: <20171122170747.12192-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 286E249D09
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 15:39:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6owHx0qPQMS7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Nov 2017 15:39:13 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBF6B40FB0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 15:39:12 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id r68so12798911wmr.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Nov 2017 12:41:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171122170747.12192-1-alex.bennee@linaro.org>
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
Cc: kvm@vger.kernel.org, julien.thierry@arm.com, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, David Daney <david.daney@cavium.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 22, 2017 at 05:07:46PM +0000, Alex Benn=E9e wrote:
> There is a fast-path of MMIO emulation inside hyp mode. The handling
> of single-step is broadly the same as kvm_arm_handle_step_debug()
> except we just setup ESR/HSR so handle_exit() does the correct thing
> as we exit.
> =

> For the case of an emulated illegal access causing an SError we signal
> to handle_exit() by clearing the DBG_SPSR_SS bit as would have
> actually happened had the hardware really single-stepped the
> instruction.
> =

> [AJB: currently compile tested only]
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  arch/arm64/kvm/handle_exit.c |  8 +++++++-
>  arch/arm64/kvm/hyp/switch.c  | 37 ++++++++++++++++++++++++++++++-------
>  2 files changed, 37 insertions(+), 8 deletions(-)
> =

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index af1c804742f6..128120f04e0e 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -28,6 +28,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_psci.h>
> +#include <asm/debug-monitors.h>
>  =

>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
> @@ -242,7 +243,12 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_ru=
n *run,
>  		return 1;
>  	case ARM_EXCEPTION_EL1_SERROR:
>  		kvm_inject_vabt(vcpu);
> -		return 1;
> +		/* We may still need to return for single-step */
> +		if (!(*vcpu_cpsr(vcpu) & DBG_SPSR_SS)
> +			&& kvm_arm_handle_step_debug(vcpu, run))
> +			return 0;
> +		else
> +			return 1;

I think you need to describe in the commit message that this is actually
fixing an additional potential problem, not necessarily related to mmio
emulation.  Hmmm, maybe it is easier to see this in two separate patches
after all, introducing this logic first to plug the "debug step
exception vs. SError from guest priority is implementation defined"
problem, and then using it afterwards for the mmio emulation as well.

Come to think of it, we should probably expand on the comment above as
well.

>  	case ARM_EXCEPTION_TRAP:
>  		return handle_trap_exceptions(vcpu, run);
>  	case ARM_EXCEPTION_HYP_GONE:
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 945e79c641c4..a6712f179b52 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -22,6 +22,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/fpsimd.h>
> +#include <asm/debug-monitors.h>
>  =

>  static bool __hyp_text __fpsimd_enabled_nvhe(void)
>  {
> @@ -263,7 +264,11 @@ static bool __hyp_text __populate_fault_info(struct =
kvm_vcpu *vcpu)
>  	return true;
>  }
>  =

> -static void __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
> +/* Skip an instruction which has been emulated. Returns true if
> + * execution can continue or false if we need to exit hyp mode because
> + * single-step was in effect.
> + */
> +static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
>  {
>  	*vcpu_pc(vcpu) =3D read_sysreg_el2(elr);
>  =

> @@ -276,6 +281,14 @@ static void __hyp_text __skip_instr(struct kvm_vcpu =
*vcpu)
>  	}
>  =

>  	write_sysreg_el2(*vcpu_pc(vcpu), elr);
> +
> +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> +		vcpu->arch.fault.esr_el2 =3D
> +			(ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT) | 0x22;
> +		return false;
> +	} else {
> +		return true;
> +	}
>  }
>  =

>  int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> @@ -336,13 +349,21 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  			int ret =3D __vgic_v2_perform_cpuif_access(vcpu);
>  =

>  			if (ret =3D=3D 1) {
> -				__skip_instr(vcpu);
> -				goto again;
> +				if (__skip_instr(vcpu))
> +					goto again;
> +				else
> +					exit_code =3D ARM_EXCEPTION_TRAP;
>  			}
>  =

>  			if (ret =3D=3D -1) {
> -				/* Promote an illegal access to an SError */
> -				__skip_instr(vcpu);
> +				/* Promote an illegal access to an
> +				 * SError. If we would be returning
> +				 * due to single-step clear the SS
> +				 * bit so handle_exit knows what to
> +				 * do after dealing with the error.
> +				 */
> +				if (!__skip_instr(vcpu))
> +					*vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;

Could this be overriding guest state if the guest is debugging itself
and we don't have (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) ?

>  				exit_code =3D ARM_EXCEPTION_EL1_SERROR;
>  			}
>  =

> @@ -357,8 +378,10 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  		int ret =3D __vgic_v3_perform_cpuif_access(vcpu);
>  =

>  		if (ret =3D=3D 1) {
> -			__skip_instr(vcpu);
> -			goto again;
> +			if (__skip_instr(vcpu))
> +				goto again;
> +			else
> +				exit_code =3D ARM_EXCEPTION_TRAP;
>  		}
>  =

>  		/* 0 falls through to be handled out of EL2 */
> -- =

> 2.15.0
> =


Other than that, this looks good.

Thanks,
-Christoffer
