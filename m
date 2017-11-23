From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v1 2/2] kvm: arm64: handle single-step of hyp emulated
 mmio instructions
Date: Thu, 23 Nov 2017 13:39:01 +0100
Message-ID: <20171123123901.GZ28855@cbox>
References: <20171123121134.11050-1-alex.bennee@linaro.org>
 <20171123121134.11050-3-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A46C49D64
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 07:36:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VdLNTBE4-Ju8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Nov 2017 07:36:14 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 631FD49D46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 07:36:14 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id 128so16243219wmo.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 04:38:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171123121134.11050-3-alex.bennee@linaro.org>
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
Cc: kvm@vger.kernel.org, julien.thierry@arm.com, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 23, 2017 at 12:11:34PM +0000, Alex Benn=E9e wrote:
> There is a fast-path of MMIO emulation inside hyp mode. The handling
> of single-step is broadly the same as kvm_arm_handle_step_debug()
> except we just setup ESR/HSR so handle_exit() does the correct thing
> as we exit.
> =

> For the case of an emulated illegal access causing an SError we will
> exit via the ARM_EXCEPTION_EL1_SERROR path in handle_exit(). We behave
> as we would during a real SError and clear the DBG_SPSR_SS bit for the
> emulated instruction.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c | 37 ++++++++++++++++++++++++++++++-------
>  1 file changed, 30 insertions(+), 7 deletions(-)
> =

> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 525c01f48867..f7c651f3a8c0 100644
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
> @@ -269,7 +270,11 @@ static bool __hyp_text __populate_fault_info(struct =
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

> @@ -282,6 +287,14 @@ static void __hyp_text __skip_instr(struct kvm_vcpu =
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
> @@ -342,13 +355,21 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
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
>  				exit_code =3D ARM_EXCEPTION_EL1_SERROR;
>  			}
>  =

> @@ -363,8 +384,10 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
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

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
