From: David Hildenbrand <dahi@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 04/10] KVM: arm: guest debug, add stub
 KVM_SET_GUEST_DEBUG ioctl
Date: Wed, 1 Apr 2015 17:55:29 +0200
Message-ID: <20150401175529.642f64af@thinkpad-w530>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
	<1427814488-28467-5-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427814488-28467-5-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

> This commit adds a stub function to support the KVM_SET_GUEST_DEBUG
> ioctl. Currently any operation flag will return EINVAL. Actual

Well it won't return -EINVAL if you push in KVM_GUESTDBG_ENABLE or 0.

"Any unsupported flag will return -EINVAL. For now, only KVM_GUESTDBG_E=
NABLE is
supported, although it won't have any effects."

> functionality will be added with further patches.
>=20
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>.
>=20
> ---
> v2
>   - simplified form of the ioctl (stuff will go into setup_debug)
>=20
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> index b112efc..06c5064 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2604,7 +2604,7 @@ handled.
>  4.87 KVM_SET_GUEST_DEBUG
>=20
>  Capability: KVM_CAP_SET_GUEST_DEBUG
> -Architectures: x86, s390, ppc
> +Architectures: x86, s390, ppc, arm64
>  Type: vcpu ioctl
>  Parameters: struct kvm_guest_debug (in)
>  Returns: 0 on success; -1 on error
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 5560f74..445933d 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -183,6 +183,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
>  	case KVM_CAP_ARM_PSCI:
>  	case KVM_CAP_ARM_PSCI_0_2:
>  	case KVM_CAP_READONLY_MEM:
> +	case KVM_CAP_SET_GUEST_DEBUG:
>  		r =3D 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -303,10 +304,21 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_arm_set_running_vcpu(NULL);
>  }
>=20
> +#define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE)

That makes me rather think that it is another flag.

We(s390x) use VALID_GUESTDBG_FLAGS, what about that or KVM_GUESTDBG_VAL=
ID_MASK?

> +
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
>  {
> -	return -EINVAL;
> +	if (dbg->control & KVM_GUESTDBG_ENABLE) {
> +		if (dbg->control & ~KVM_GUESTDBG_VALID)
> +			return -EINVAL;

I'd move that check directly to the start of the function and bail out =
on any
unsupported flag.

> +
> +		vcpu->guest_debug =3D dbg->control;
> +	} else {
> +		/* If not enabled clear all flags */
> +		vcpu->guest_debug =3D 0;
> +	}
> +	return 0;
>  }
>=20
>=20

David
