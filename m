From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 06/12] KVM: arm64: guest debug, add SW break point
 support
Date: Fri, 8 May 2015 13:52:34 +0200
Message-ID: <20150508115234.GF24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430929407-3487-7-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF65050D63
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 07:43:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6UTT3ZpvAmfq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 May 2015 07:43:39 -0400 (EDT)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
 [209.85.217.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53D1E50D67
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 07:43:39 -0400 (EDT)
Received: by lbbzk7 with SMTP id zk7so51426463lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 May 2015 04:52:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1430929407-3487-7-git-send-email-alex.bennee@linaro.org>
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
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, marc.zyngier@arm.com, jan.kiszka@siemens.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, Catalin Marinas <catalin.marinas@arm.com>, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 06, 2015 at 05:23:21PM +0100, Alex Benn=E9e wrote:
> This adds support for SW breakpoints inserted by userspace.
> =

> We do this by trapping all guest software debug exceptions to the
> hypervisor (MDCR_EL2.TDE). The exit handler sets an exit reason of
> KVM_EXIT_DEBUG with the kvm_debug_exit_arch structure holding the
> exception syndrome information.
> =

> It will be up to userspace to extract the PC (via GET_ONE_REG) and
> determine if the debug event was for a breakpoint it inserted. If not
> userspace will need to re-inject the correct exception restart the
> hypervisor to deliver the debug exception to the guest.
> =

> Any other guest software debug exception (e.g. single step or HW
> assisted breakpoints) will cause an error and the VM to be killed. This
> is addressed by later patches which add support for the other debug
> types.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v2
>   - update to use new exit struct
>   - tweak for C setup
>   - do our setup in debug_setup/clear code
>   - fixed up comments
> v3:
>   - fix spacing in KVM_GUESTDBG_VALID_MASK
>   - fix and clarify wording on kvm_handle_guest_debug
>   - handle error case in kvm_handle_guest_debug
>   - re-word the commit message
> =

> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kv=
m/api.txt
> index 4b0132f..5ef937c 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2667,7 +2667,7 @@ when running. Common control bits are:
>  The top 16 bits of the control field are architecture specific control
>  flags which can include the following:
>  =

> -  - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86]
> +  - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86, arm64]
>    - KVM_GUESTDBG_USE_HW_BP:     using hardware breakpoints [x86, s390]
>    - KVM_GUESTDBG_INJECT_DB:     inject DB type exception [x86]
>    - KVM_GUESTDBG_INJECT_BP:     inject BP type exception [x86]
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 4a274e1..064c105 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -302,7 +302,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_arm_set_running_vcpu(NULL);
>  }
>  =

> -#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE)
> +#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_=
SW_BP)
>  =

>  /**
>   * kvm_arch_vcpu_ioctl_set_guest_debug - set up guest debugging
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index b1f8731..5bee676 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -75,6 +75,12 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  	else
>  		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
>  =

> +	/* Trap breakpoints? */
> +	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
> +		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
> +	else
> +		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDE;
> +

I also don't think you need the else-clause here.

>  }
>  =

>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 524fa25..27f38a9 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -82,6 +82,40 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struc=
t kvm_run *run)
>  	return 1;
>  }
>  =

> +/**
> + * kvm_handle_guest_debug - handle a debug exception instruction
> + *
> + * @vcpu:	the vcpu pointer
> + * @run:	access to the kvm_run structure for results
> + *
> + * We route all debug exceptions through the same handler. If both the
> + * guest and host are using the same debug facilities it will be up to
> + * userspace to re-inject the correct exception for guest delivery.
> + *
> + * @return: 0 (while setting run->exit_reason), -1 for error
> + */
> +static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run =
*run)
> +{
> +	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
> +	int ret =3D 0;
> +
> +	run->exit_reason =3D KVM_EXIT_DEBUG;
> +	run->debug.arch.hsr =3D hsr;
> +
> +	switch (hsr >> ESR_ELx_EC_SHIFT) {
> +	case ESR_ELx_EC_BKPT32:
> +	case ESR_ELx_EC_BRK64:
> +		break;
> +	default:
> +		kvm_err("%s: un-handled case hsr: %#08x\n",
> +			__func__, (unsigned int) hsr);
> +		ret =3D -1;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_ELx_EC_WFx]	=3D kvm_handle_wfx,
>  	[ESR_ELx_EC_CP15_32]	=3D kvm_handle_cp15_32,
> @@ -96,6 +130,8 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>  	[ESR_ELx_EC_SYS64]	=3D kvm_handle_sys_reg,
>  	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
> +	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
> +	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
>  };
>  =

>  static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
> -- =

> 2.3.5
> =


Besides the nit:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
