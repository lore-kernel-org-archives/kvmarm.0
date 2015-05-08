From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 04/12] KVM: arm: guest debug, add stub
 KVM_SET_GUEST_DEBUG ioctl
Date: Fri, 8 May 2015 13:52:17 +0200
Message-ID: <20150508115217.GD24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430929407-3487-5-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430929407-3487-5-git-send-email-alex.bennee@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 06, 2015 at 05:23:19PM +0100, Alex Benn=E9e wrote:
> This commit adds a stub function to support the KVM_SET_GUEST_DEBUG
> ioctl. Any unsupported flag will return -EINVAL. For now, only
> KVM_GUESTDBG_ENABLE is supported, although it won't have any effects.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>.
>=20
> ---
> v2
>   - simplified form of the ioctl (stuff will go into setup_debug)
> v3
>  - KVM_GUESTDBG_VALID->KVM_GUESTDBG_VALID_MASK
>  - move mask check to the top of function
>  - add ioctl doc header
>  - split capability into separate patch
>  - tweaked commit wording w.r.t return of -EINVAL
>=20
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> index cb90025..4b0132f 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2645,7 +2645,7 @@ handled.
>  4.87 KVM_SET_GUEST_DEBUG
> =20
>  Capability: KVM_CAP_SET_GUEST_DEBUG
> -Architectures: x86, s390, ppc
> +Architectures: x86, s390, ppc, arm64
>  Type: vcpu ioctl
>  Parameters: struct kvm_guest_debug (in)
>  Returns: 0 on success; -1 on error
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d9631ec..52a1d4d38 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -302,10 +302,31 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_arm_set_running_vcpu(NULL);
>  }
> =20
> +#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE)
> +
> +/**
> + * kvm_arch_vcpu_ioctl_set_guest_debug - set up guest debugging
> + * @kvm:	pointer to the KVM struct
> + * @kvm_guest_debug: the ioctl data buffer
> + *
> + * This sets up and enables the VM for guest debugging. Userspace
> + * passes in a control flag to enable different debug types and
> + * potentially other architecture specific information in the rest o=
f
> + * the structure.
> + */
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
>  {
> -	return -EINVAL;
> +	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
> +		return -EINVAL;
> +
> +	if (dbg->control & KVM_GUESTDBG_ENABLE) {
> +		vcpu->guest_debug =3D dbg->control;
> +	} else {
> +		/* If not enabled clear all flags */
> +		vcpu->guest_debug =3D 0;
> +	}
> +	return 0;
>  }
> =20

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
