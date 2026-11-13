Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564066;
	b=LaIFAvFAmozasp3I5jPkPyauhuk0W0TFUDcUt3xuD+d7zfbXxfJQeknOUNqvNSFMndUl
	 +q+gZ6+ldbSAM5s27NrzT86IqgZaa5JAMcJXaTWOwbLNrpaxDaW/kyQGXujPtv9FX2puA
	 PxCiFP+ikUP1uydY1gbeXmUEc9LzzntXOFkwGzkD4Uh9bEyzcyTiP8rXsEwIU6VLmu2xI
	 JFSmAmbeXIJDZ7LxOgWmI6fI70zBdS/pWPiuulJ8uDrmIXGW4YIp/eehD4IM0uNNgqqBo
	 OA7ONJS6NMkMrVpwmXzMGuklUfPX1z3uStzTuLN9Hjctddh6qQRa1/zegUHNENnb3yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564066;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hd7fUprEi2Y+4iIQNx6DIQGgCg9D//Xh4pvhFlRA0ko=;
	b=Bg6LdWzqEnIHWSzYwSFlfhksAdVSajvazHrlTV16fm55OzhMzzAJpYzMbqL1VgrivG44
	 lVk48rWjGP+Jkiv0pTnAYkoXv1FFdWyCdQLkFZr6d/U59F7ak96WdvYnNxycHBgJB9QoK
	 L3GvPLyYo2gvTf+0EHrOoRcCCAskSqgurm+HkTiuCbzn8/UxjwSfd6PwyAppja1WR5ms1
	 +NvBegPtWBwnNmT+D37WZaZdYNfGNzjUhFsb9JKyW5Zi7voyvlbQhMrDfvNy57Z8RreTY
	 J273uVdtHGtPJ5XUHJ9kPYKjfPLAk/cGCbb42Sj8oP4gWQwa7bSEutqJTNolzrZ6ZPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AzGeZNUI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E82E606A321
	for <kvmarm@lists.linux.dev>; Fri, 13 Nov 2026 10:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AzGeZNUI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00891F000C4;
	Fri, 13 Nov 2026 10:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794564065;
	bh=hd7fUprEi2Y+4iIQNx6DIQGgCg9D//Xh4pvhFlRA0ko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AzGeZNUI/OScS19QhQoR5aWcF1t+OG+WPTYDT8abLwVcDFZX1UiPSl87WypDDX5F4
	 UimcEo04W7B2K0eHu7wPaEG303tnfraK072/TZGb3TLCShHBgOua7ET8X7yYl7L7Qw
	 Mw5E8h0GLviolUfIPsTqdRI9PWPoh0JVzEYWZU7B5Qvg+PHkTI/HmsCECV/D5EUV6q
	 m1jTYAEn8nYn+umRYRkTmhtW4Ul5GchD57a0qLD6OzZ5INQtUZ64pogY05b/pNiDKV
	 rOtSUs1g4xC3tv6OEyAegFtbL4ZntMg4uO9J6X1vbHweGRwQ4+3gtlbj5DpN0d08s+
	 9zf8RQcLzwWfw==
Message-ID: <sashiko-outbox-212593@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Register irq_bypass consumers only when
 direct MSIs are possible
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinqian Yang" <yangjinqian1@huawei.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261113093840.1034795-1-yangjinqian1@huawei.com>
References: <20261113093840.1034795-1-yangjinqian1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 10:01:05 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: irq_bypass skipped if vITS is created after
  KVM_IRQFD
--

commit 3a0bd42f42a6d2802fe72bb1bc5c8b719382be8f
Author: Jinqian Yang <yangjinqian1@huawei.com>

KVM: arm64: Register irq_bypass consumers only when direct MSIs are possible

This commit passes struct kvm to kvm_arch_has_irq_bypass() and gates
arm64 irq_bypass consumer registration on vgic_supports_direct_msis(kvm).

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 97332ffcb1300..da86646b67097 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1742,9 +1742,9 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u6=
4 val);
>  #define kvm_has_sctlr2(k)				\
>  	(kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
> =20
> -static inline bool kvm_arch_has_irq_bypass(void)
> +static inline bool kvm_arch_has_irq_bypass(struct kvm *kvm)
>  {
> -	return true;
> +	return vgic_supports_direct_msis(kvm);
>  }
> =20
>  void kvm_idregs_enforce_dependencies(struct kvm *kvm);

[Severity: Medium]
Can kvm_irqfd_assign() skip irq_bypass_register_consumer() when userspace
creates the virtual ITS after initializing the VGICv3 distributor and
assigning irqfds?

kvm_irqfd_assign() only requires kvm_arch_intc_initialized(kvm)
(vgic_initialized(kvm)) and evaluates kvm_arch_has_irq_bypass(kvm) once
without holding kvm->arch.config_lock.  vgic_supports_direct_msis(kvm)
checks vgic_has_its(kvm), which tests dist->its_model, but vgic_its_create()
explicitly allows creating a KVM_DEV_TYPE_ARM_VGIC_ITS device after the
VGIC is already initialized:

arch/arm64/kvm/vgic/vgic-its.c:vgic_its_create() {
	...
	if (vgic_initialized(dev->kvm)) {
		ret =3D vgic_v4_init(dev->kvm);
	...
	dev->kvm->arch.vgic.msis_require_devid =3D true;
	dev->kvm->arch.vgic.its_model =3D KVM_DEV_TYPE_ARM_VGIC_V3;
}

If userspace initializes the VGICv3 distributor, assigns an irqfd via
KVM_IRQFD, and then creates the ITS and configures MSI routing,
vgic_supports_direct_msis(kvm) returns false during kvm_irqfd_assign().
Because vgic_its_create() does not register existing irqfds as irq_bypass
consumers, GICv4 direct vLPI forwarding is never enabled for those irqfds
and interrupts silently fall back to software injection.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113093840.1034=
795-1-yangjinqian1@huawei.com?part=3D1
