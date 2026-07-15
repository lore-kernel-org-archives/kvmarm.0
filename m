Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41BE27E049
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 08:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104631; cv=none; b=mKxvHeYhJjXCl8xJ8aGqwtHZugw1WSwKYtwNRK1JdelgTjvDrEEnwxHioepxoZsN9XGsnxH0H4nRbWkvrxxTgQP6P7VN/7AajFvVHFq/LyQrTvb7bChdtq1oKWFTo5nRJxNmzeGlhbhrtqh1oO0AJZUPJIny6AaOfEGqRfag7zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104631; c=relaxed/simple;
	bh=+U67pFrRhlItsF7dZNwn6CJ7yd5WzFsbvmTuiBahFms=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XvOc7WQszTT6sW1ZWYhyjZx+cu0F+J9jEGhdXLLsJfjt3P5XfvlqOWD8u4oahXwwzAihhyzWVHKAUZC1jMOh+aUyBbnrHRf8pRmV3CFkC74rTUPhIXZB+1zUZljg/zJ4U54vXapqxKcTrH/Mx1X4/5L9qVt7be19FIoKSdNUzgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSoaIsgo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSoaIsgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D2A1F000E9;
	Wed, 15 Jul 2026 08:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784104629;
	bh=E+0b4jp6gcJW2tSmmiyImy49qsI+LLKpXsZOob6eJG8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TSoaIsgoDmglUvaMk9FExMPvOEIkLkvbkoxnUoMGPyP4XKQMz+deLWJLXBCHABtJd
	 pCUENpVPtdRP9jincYeQRcO0ubnO6BGbZrNje4z4CZtmY+JzF9slsGfre+hHCJglmw
	 bTCReFzF+NpLv9p49lv6ie5k9xHevVkbj1pjqyx1RHXugQ2foUGmIms++oUvJOhWGa
	 JMOnncbGnHj+RSTegGj9dABcWYx20JkByYenqBlAkJ5JpZvpnVpbvSOYPMvZAeKubH
	 xRkg+QgA4N8nMxjY7d2BiHqW3+ney3h6IY4BvEkueyAC5OYctlBY54MKeN83fP6HjR
	 6FAHxBZ51abGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260715081238.1891918-7-fuad.tabba@linux.dev>
References: <20260715081238.1891918-1-fuad.tabba@linux.dev>
 <20260715081238.1891918-7-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 08:37:07 +0000
Message-Id: <20260715083708.68D2A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] handle___vgic_v3_save_aprs silently overwrites host modifications =
to vgic_vmcr with a stale value.

Pre-existing issues:
- [Critical] The patch addresses the host-pointer trust vulnerability for G=
ICv3 but leaves the identical vulnerability open for GICv5.
--

--- Patch [6]: [PATCH v6 6/8] KVM: arm64: Minimise EL2's exposure of host V=
GIC state during world switch ---
commit d47381d6be1828e59e8906a9d69d3c104d673dc3
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Minimise EL2's exposure of host VGIC state during world switch

This commit modifies the world switch to stop EL2 from dereferencing the ho=
st's
vgic_v3_cpu_if pointer wholesale. It copies only vgic_vmcr and active prior=
ity=20
registers to the hyp-side state.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 45d717889f6ea..f3233ee343a39 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -508,16 +520,63 @@ static void handle___vgic_v3_init_lrs(struct kvm_cp=
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
> +
> +	if (unlikely(hyp_vcpu)) {
> +		struct vgic_v3_cpu_if *hyp_cpu_if, *host_cpu_if;
> +		int i;
> +
> +		hyp_cpu_if =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> +		__vgic_v3_save_aprs(hyp_cpu_if);
> +
> +		host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> +		host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;

[Severity: High]
Does this assignment overwrite host modifications to vgic_vmcr with a stale
value?

When userspace modifies a VMCR field (like SYS_ICC_PMR_EL1) via
KVM_SET_ONE_REG, the execution flow modifies the host state:

kvm_vcpu_ioctl()
  vcpu_load()
    handle___vgic_v3_restore_vmcr_aprs()
  // ioctl modifies host_cpu_if->vgic_vmcr
  vcpu_put()
    handle___vgic_v3_save_aprs()

Since __vgic_v3_save_aprs() does not read ICH_VMCR_EL2 from the hardware,
hyp_cpu_if->vgic_vmcr contains the old value. Does copying it back to
host_cpu_if->vgic_vmcr here cause the userspace changes to be lost?

> +		for (i =3D 0; i < ARRAY_SIZE(host_cpu_if->vgic_ap0r); i++) {
> +			host_cpu_if->vgic_ap0r[i] =3D hyp_cpu_if->vgic_ap0r[i];
> +			host_cpu_if->vgic_ap1r[i] =3D hyp_cpu_if->vgic_ap1r[i];
> +		}
> +	} else {
> +		__vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> +	}
>  }
[ ... ]

[Severity: Critical]
This is a pre-existing issue and was not introduced by the patch under revi=
ew,
but does the same pattern remain open for GICv5?

Looking at handle___vgic_v5_save_apr():

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_save_apr() {
	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
}

And similarly in handle___vgic_v5_restore_vmcr_apr():

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_restore_vmcr_apr() {
	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
}

Since these handlers apply kern_hyp_va() to an untrusted host pointer witho=
ut
validation, and kern_hyp_va() is idempotent for already-hyp-tagged pointers,
could a malicious host provide a pointer to EL2 private metadata?

Could this allow the host to arbitrarily read or write EL2 memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715081238.1891=
918-1-fuad.tabba@linux.dev?part=3D6
