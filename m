From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 1/5] arm: KVM: export vcpi->pause state via MP_STATE
 ioctls
Date: Mon, 9 Mar 2015 14:50:55 +0100
Message-ID: <20150309135055.GC20559@cbox>
References: <1425302944-6276-1-git-send-email-alex.bennee@linaro.org>
 <1425302944-6276-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D89BA481AA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 09:44:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cqpht1Fj8KYC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2015 09:44:25 -0400 (EDT)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com
 [209.85.217.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BF0A481BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 09:44:24 -0400 (EDT)
Received: by lbiz11 with SMTP id z11so45165009lbi.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Mar 2015 06:50:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1425302944-6276-2-git-send-email-alex.bennee@linaro.org>
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
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, marc.zyngier@arm.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

The subject of this change has a typo, and I also think it's not about
exposing the pause state (that's just an internal name/concept), but
about exposing the PSCI state, or simply the VCPU power state.

On Mon, Mar 02, 2015 at 01:29:00PM +0000, Alex Benn=E9e wrote:
> To cleanly restore an SMP VM we need to ensure that the current pause
> state of each vcpu is correctly recorded. Things could get confused if
> the CPU starts running after migration restore completes when it was
> paused before it state was captured.
> =

> We use the existing KVM_GET/SET_MP_STATE ioctl to do this. The arm/arm64
> interface is a lot simpler as the only valid states are
> KVM_MP_STATE_RUNNABLE and KVM_MP_STATE_HALTED.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kv=
m/api.txt
> index b112efc..602156f 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -997,7 +997,7 @@ for vm-wide capabilities.
>  4.38 KVM_GET_MP_STATE
>  =

>  Capability: KVM_CAP_MP_STATE
> -Architectures: x86, s390
> +Architectures: x86, s390, arm, arm64
>  Type: vcpu ioctl
>  Parameters: struct kvm_mp_state (out)
>  Returns: 0 on success; -1 on error
> @@ -1027,15 +1027,21 @@ Possible values are:
>   - KVM_MP_STATE_LOAD:            the vcpu is in a special load/startup s=
tate
>                                   [s390]
>  =

> -On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
> -in-kernel irqchip, the multiprocessing state must be maintained by users=
pace on
> +For x86:
> +
> +This ioctl is only useful after KVM_CREATE_IRQCHIP.  Without an in-kernel
> +irqchip, the multiprocessing state must be maintained by userspace on

Nit: I would not taint the git log with this change but instead just
introduce a paragraph below starting with "On arm/arm64, " and you would
get the same effect.

>  these architectures.
>  =

> +For arm/arm64:
> +
> +The only states that are valid are KVM_MP_STATE_HALTED and
> +KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.

As suggested on the QEMU series, HALTED is probably not the right thing
to use.

>  =

>  4.39 KVM_SET_MP_STATE
>  =

>  Capability: KVM_CAP_MP_STATE
> -Architectures: x86, s390
> +Architectures: x86, s390, arm, arm64
>  Type: vcpu ioctl
>  Parameters: struct kvm_mp_state (in)
>  Returns: 0 on success; -1 on error
> @@ -1043,10 +1049,16 @@ Returns: 0 on success; -1 on error
>  Sets the vcpu's current "multiprocessing state"; see KVM_GET_MP_STATE for
>  arguments.
>  =

> -On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
> -in-kernel irqchip, the multiprocessing state must be maintained by users=
pace on
> +For x86:
> +
> +This ioctl is only useful after KVM_CREATE_IRQCHIP.  Without an in-kernel
> +irqchip, the multiprocessing state must be maintained by userspace on
>  these architectures.
>  =

> +For arm/arm64:
> +
> +The only states that are valid are KVM_MP_STATE_HALTED and
> +KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.

same as above

>  =

>  4.40 KVM_SET_IDENTITY_MAP_ADDR
>  =

> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 5560f74..8531536 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -183,6 +183,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
>  	case KVM_CAP_ARM_PSCI:
>  	case KVM_CAP_ARM_PSCI_0_2:
>  	case KVM_CAP_READONLY_MEM:
> +	case KVM_CAP_MP_STATE:
>  		r =3D 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -313,13 +314,29 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_=
vcpu *vcpu,
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>  				    struct kvm_mp_state *mp_state)
>  {
> -	return -EINVAL;
> +	if (vcpu->arch.pause)
> +		mp_state->mp_state =3D KVM_MP_STATE_HALTED;
> +	else
> +		mp_state->mp_state =3D KVM_MP_STATE_RUNNABLE;
> +
> +	return 0;
>  }
>  =

>  int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  				    struct kvm_mp_state *mp_state)
>  {
> -	return -EINVAL;
> +	switch (mp_state->mp_state) {
> +	case KVM_MP_STATE_RUNNABLE:
> +		vcpu->arch.pause =3D false;
> +		break;
> +	case KVM_MP_STATE_HALTED:
> +		vcpu->arch.pause =3D true;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
>  }
>  =

>  /**

Are we capturing the vcpu features in some way or do we expect userspace
to migrate these on its own?  The reason I'm asking, is if you create
multiple VCPUs, where all the non-primary VCPUs are started in power off
mode, and then you boot your guest which powers on all VCPUs, and then
you restart your guest (with PSCI RESET), the system will not power on
all the non-primary VCPUs but hold them in power-off.

We need to make sure this behavior is preserved for a reboot across a
migration.  Is it?

Thanks,
-Christoffer
