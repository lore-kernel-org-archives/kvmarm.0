Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9020175A8B
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781249097; cv=none; b=AsIeIVbu0Ngv2OoUtEXfWWyw2qavS9fwIuNMnU6MIoWDJ90i98pyQcd80Bi/0hXMYWqzGH3sLyE+OmkRqHC9msrbHKfn8MQAChcP71mMGnPmUNPS+W6O0uMalgsDs86sBZRzE9o8wOn+LXBNjxGjPvF0sVQf6PjR8CTgLWy/tz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781249097; c=relaxed/simple;
	bh=upf/Fyv1bxQEBYO1HXinG9+jrOIsrKsdIcmXG6n9x5M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T9CdQF2kB7j3YVBP4JKkiKR9ihL5hDb0qvhIvrAGDUUN3toYnUmvSpj866VVj3jdPuw4iqMq4rqu6+VI/qWQUYVemL5nsPgmvXX93G67L4KNdfQr2aA2qF0H1qwZn5hBk4YCoJyOW2c7XmKSYhFMvLvmsTVfbUsigkm/XI/Pf8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hz4zj/Rx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hz4zj/Rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4D01F000E9;
	Fri, 12 Jun 2026 07:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781249096;
	bh=4o44d2Nduh4aoVuir6aqNMR13L2+rzo+QvM6V2akcRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hz4zj/Rxg2YK17GN/LdSARjLr+k4hMfWSnltPKPlRCQIYrcvg6/mu3bE6m2UaY/l+
	 LtqQbcBnQAXuWLzwhv4kGmAl8+KuVVVstfozJGcjGN1Vh9j/yT4vNq/MSUGs34uMuh
	 71GnM1H58UGGAe0HxbvFafRnRfBzplqaEI4xAecNw3JQDg3YaeKkBfacaAzM8ZpwP6
	 noE41Kfk86cu6BzogQI32YOGbVOJEQm0U5WrSmgnQLjj8hqqJ+Yh1WtjuwhjjSTjfC
	 duglxnpV0LQsxQ6qCku09crq8qJFsrImYr1x+b8k+wLkUw7/VtJX/D+r6F7jLh154Z
	 l6y3HZNF3rZvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 09/11] KVM: arm64: Minimise EL2's exposure of host
 VGIC state during world switch
Reply-To: sashiko-reviews@lists.linux.dev
To: tabba@google.com
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260612065925.755562-10-tabba@google.com>
References: <20260612065925.755562-10-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 07:24:55 +0000
Message-Id: <20260612072456.0F4D01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The GICv5 equivalents of the VGIC save/restore hypercalls (`ha=
ndle___vgic_v5_save_apr` and `handle___vgic_v5_restore_vmcr_apr`) directly =
dereference host-provided pointers without validation, allowing a complete =
bypass of pKVM isolation.
- [Critical] The `handle___kvm_adjust_pc` hypercall directly dereferences a=
 host-provided `vcpu` pointer without validation, granting the host an arbi=
trary memory corruption primitive against the hypervisor.
--

commit a5d2ecd901c7ff6f71119eb6ee605aaa1a3fee90
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Minimise EL2's exposure of host VGIC state during world switch

The host passes a vgic_v3_cpu_if pointer to the __vgic_v3_save_aprs and
__vgic_v3_restore_vmcr_aprs hypercalls, which EL2 dereferences
wholesale. That exposes the host's full VGIC emulation state to the
hypervisor, against pKVM's isolation goals.

Recover the host vCPU from the supplied cpu_if via container_of() and
copy only vgic_vmcr and the active priority registers between EL2's
hyp-side state and the host vCPU, so EL2 no longer dereferences the
host's vgic_v3_cpu_if directly.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 420fb19a64760..2f165b6c7b071 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -489,16 +501,63 @@ static void handle___vgic_v3_init_lrs(struct kvm_cp=
u_context *host_ctxt)
> =20
>  static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
>  {
> -	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *host_vcpu;
> =20
> -	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> +	host_vcpu =3D get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1,
> +							   &hyp_vcpu);
> +	if (!host_vcpu)
> +		return;

[ ... ]

> +	} else {
> +		__vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> +	}
>  }

[Severity: Critical]
This is a pre-existing issue, but while this patch addresses the VGIC v3 ho=
st
pointer dereference bypass by using get_host_hyp_vcpus_from_vgic_v3_cpu_if(=
),
does the same pKVM isolation bypass exist in the GICv5 equivalents?

Looking at handle___vgic_v5_save_apr() and handle___vgic_v5_restore_vmcr_ap=
r()
in arch/arm64/kvm/hyp/nvhe/hyp-main.c:

handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt) {
    DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
    __vgic_v5_save_apr(kern_hyp_va(cpu_if));
}

These handlers appear to take a cpu_if pointer directly from the untrusted
host context and apply kern_hyp_va() without validation. Could a malicious
host provide an address that translates to an arbitrary EL2-private memory
location, granting an arbitrary write or read primitive when
__vgic_v5_save_apr() or __vgic_v5_restore_vmcr_apr() is invoked?

[Severity: Critical]
This is also a pre-existing issue, but does a similar arbitrary memory
corruption primitive exist in handle___kvm_adjust_pc()?

Looking at handle___kvm_adjust_pc() in arch/arm64/kvm/hyp/nvhe/hyp-main.c:

static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt) {
    DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
    __kvm_adjust_pc(kern_hyp_va(vcpu));
}

And __kvm_adjust_pc() in arch/arm64/kvm/hyp/exception.c:

void __kvm_adjust_pc(struct kvm_vcpu *vcpu) {
    if (vcpu_get_flag(vcpu, PENDING_EXCEPTION)) {
        kvm_inject_exception(vcpu);
        vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
        vcpu_clear_flag(vcpu, EXCEPT_MASK);
    }
    ...
}

It seems the host-provided vcpu pointer is converted via kern_hyp_va()
without the __get_host_hyp_vcpus() validation barrier. Could a malicious
host inject a pointer that translates into EL2-private memory (like
hypervisor page tables) and set the PENDING_EXCEPTION bit, forcing
__kvm_adjust_pc() to write exception vector addresses and clear flags at
specific offsets within the target structure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.7555=
62-1-tabba@google.com?part=3D9
