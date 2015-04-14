From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug, add SW break point
 support
Date: Tue, 14 Apr 2015 10:25:58 +0200
Message-ID: <20150414082558.GS6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 31, 2015 at 04:08:04PM +0100, Alex Benn=E9e wrote:
> This adds support for SW breakpoints inserted by userspace.
>=20
> We do this by trapping all BKPT exceptions in the
> hypervisor (MDCR_EL2_TDE).

you mean trapping all exceptions in the guest to the hypervisor?

> The kvm_debug_exit_arch carries the address
> of the exception.

why?  can userspace not simply read out the PC using GET_ONE_REG?

> If user-space doesn't know of the breakpoint then we
> have a guest inserted breakpoint and the hypervisor needs to start ag=
ain
> and deliver the exception to guest.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
> ---
> v2
>   - update to use new exit struct
>   - tweak for C setup
>   - do our setup in debug_setup/clear code
>   - fixed up comments
>=20
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> index 06c5064..17d4f9c 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2626,7 +2626,7 @@ when running. Common control bits are:
>  The top 16 bits of the control field are architecture specific contr=
ol
>  flags which can include the following:
> =20
> -  - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86]
> +  - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86, arm=
64]
>    - KVM_GUESTDBG_USE_HW_BP:     using hardware breakpoints [x86, s39=
0]
>    - KVM_GUESTDBG_INJECT_DB:     inject DB type exception [x86]
>    - KVM_GUESTDBG_INJECT_BP:     inject BP type exception [x86]
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 7ea8b0e..d3bc8dc 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -304,7 +304,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_arm_set_running_vcpu(NULL);
>  }
> =20
> -#define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE)
> +#define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE|KVM_GUESTDBG_USE_SW_=
BP)

nit: spaces around the operator

> =20
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 8a29d0b..cff0475 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -45,11 +45,18 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM | MDCR_EL2_TPMCR);
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TDRA | MDCR_EL2_TDOSA);
> =20
> +	/* Trap debug register access? */

other patch

>  	if (!vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
>  	else
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
> =20
> +	/* Trap breakpoints? */
> +	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
> +		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
> +	else
> +		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;

so now you're trapping all debug exceptions, right?

what happens if the guest is using the hardware to debug debug stuff an=
d
generates other kinds of debug exceptions, like a hardware breakpoint,
will we not see an unhandled exception and the guest being forcefully
killed?

> +
>  }
> =20
>  void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exi=
t.c
> index 524fa25..ed1bbb4 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -82,6 +82,37 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, s=
truct kvm_run *run)
>  	return 1;
>  }
> =20
> +/**
> + * kvm_handle_debug_exception - handle a debug exception instruction

handle a software breadkpoint exception

> + *
> + * @vcpu:	the vcpu pointer
> + * @run:	access to the kvm_run structure for results
> + *
> + * We route all debug exceptions through the same handler as we

all debug exceptions?  software breakpoints and all?  then why the abov=
e
shot text?

> + * just need to report the PC and the HSR values to userspace.
> + * Userspace may decide to re-inject the exception and deliver it to
> + * the guest if it wasn't for the host to deal with.

now I'm confused - does userspace setup the guest to receive an
exception or does it tell KVM to emulate an exception for the guest or
do we execute the breakpoint without trapping the debug exception?

> + */
> +static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_=
run *run)
> +{
> +	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
> +
> +	run->exit_reason =3D KVM_EXIT_DEBUG;
> +	run->debug.arch.hsr =3D hsr;
> +
> +	switch (hsr >> ESR_ELx_EC_SHIFT) {
> +	case ESR_ELx_EC_BKPT32:
> +	case ESR_ELx_EC_BRK64:
> +		run->debug.arch.pc =3D *vcpu_pc(vcpu);
> +		break;
> +	default:
> +		kvm_err("%s: un-handled case hsr: %#08x\n",
> +			__func__, (unsigned int) hsr);

this should never happen right?

> +		break;
> +	}
> +	return 0;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_ELx_EC_WFx]	=3D kvm_handle_wfx,
>  	[ESR_ELx_EC_CP15_32]	=3D kvm_handle_cp15_32,
> @@ -96,6 +127,8 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_ELx_EC_SYS64]	=3D kvm_handle_sys_reg,
>  	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
> +	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
> +	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
>  };
> =20
>  static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
> --=20
> 2.3.4
>=20
