From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v1 1/2] KVM: arm64: handle single-stepping trapped
 instructions
Date: Fri, 13 Oct 2017 10:26:15 +0200
Message-ID: <20171013082615.GC8927@cbox>
References: <20171006113921.24880-1-alex.bennee@linaro.org>
 <20171006113921.24880-2-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2B9149D25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 04:25:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NQ7fpJ6hRWFp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Oct 2017 04:25:23 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9949E49D24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 04:25:23 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id k4so19579895wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 01:26:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171006113921.24880-2-alex.bennee@linaro.org>
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
Cc: kvm@vger.kernel.org, julien.thierry@arm.com, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 12:39:20PM +0100, Alex Benn=E9e wrote:
> If we are using guest debug to single-step the guest we need to ensure
> we exit after emulating the instruction. This only affects
> instructions completely emulated by the kernel. For userspace emulated
> instructions we need to exit and return to complete the emulation.
> =

> We fake debug.arch.hsr to contain ESR_ELx_EC_SOFTSTP_LOW so QEMU knows
> it was a single-step event (and without altering the userspace ABI).
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 48 +++++++++++++++++++++++++++++++-------=
------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> =

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 7debb74843a0..c918d291cb58 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -178,6 +178,39 @@ static exit_handle_fn kvm_get_exit_handler(struct kv=
m_vcpu *vcpu)
>  	return arm_exit_handlers[hsr_ec];
>  }
>  =

> +/*
> + * When handling traps we need to ensure exit the guest if we
> + * completely emulated the instruction while single-stepping. Stuff to
> + * be emulated in userspace needs to complete that first.
> + */

I really don't understand the first sentence here.  We are already out
of the guest, so do you mean a return to userspace?

I think the second sentence could be more clear as well.  Is 'stuff' not
actually 'MMIO emulation' or 'emulation' more broadly?

> +
> +static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run =
*run)
> +{
> +	int handled;
> +
> +	/*
> +	 * See ARM ARM B1.14.1: "Hyp traps on instructions
> +	 * that fail their condition code check"
> +	 */
> +	if (!kvm_condition_valid(vcpu)) {
> +		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> +		handled =3D 1;
> +	} else {
> +		exit_handle_fn exit_handler;
> +
> +		exit_handler =3D kvm_get_exit_handler(vcpu);
> +		handled =3D exit_handler(vcpu, run);
> +	}
> +
> +	if (handled && (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)) {

Don't you want if (handled =3D=3D 1) or if (handled > 0) ?

If there was an error I think we want to just return that to userspace
and not override it and present single-stepping.

> +		handled =3D 0;
> +		run->exit_reason =3D KVM_EXIT_DEBUG;
> +		run->debug.arch.hsr =3D ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT;
> +	}
> +
> +	return handled;
> +}
> +
>  /*
>   * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) =
on
>   * proper exit to userspace.
> @@ -185,8 +218,6 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm=
_vcpu *vcpu)
>  int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		       int exception_index)
>  {
> -	exit_handle_fn exit_handler;
> -
>  	if (ARM_SERROR_PENDING(exception_index)) {
>  		u8 hsr_ec =3D ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));
>  =

> @@ -214,18 +245,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_ru=
n *run,
>  		kvm_inject_vabt(vcpu);
>  		return 1;
>  	case ARM_EXCEPTION_TRAP:
> -		/*
> -		 * See ARM ARM B1.14.1: "Hyp traps on instructions
> -		 * that fail their condition code check"
> -		 */
> -		if (!kvm_condition_valid(vcpu)) {
> -			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> -			return 1;
> -		}
> -
> -		exit_handler =3D kvm_get_exit_handler(vcpu);
> -
> -		return exit_handler(vcpu, run);
> +		return handle_trap_exceptions(vcpu, run);
>  	case ARM_EXCEPTION_HYP_GONE:
>  		/*
>  		 * EL2 has been reset to the hyp-stub. This happens when a guest
> -- =

> 2.14.1
> =


Thanks,
-Christoffer
