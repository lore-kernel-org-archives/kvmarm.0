Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967983DEAC0
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782458686; cv=none; b=NrLWzS2Y9X0ZeghpWZX49s6g8f1avHekfx08FfPPKKn/BjIQXLyIZWYrmZDXh/G9ykEecErxxRlu8fWns7X6nSOhEORR0Ydx/YMm5d6BaTmQLMyh78zZgoKhKbhj1U3p/uT+ebDEGwLw+9TthhzhTfRuNyzB9eeyVukoJzXs834=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782458686; c=relaxed/simple;
	bh=o+pXMM3fYIMfkuc08lMr+WbSWmHJMxflldt0QNHRj/I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OlJLp6hyZjFB/5IsXR5bXB0UAqAvJBrx6qQ+DWst087zBvQq82pmFa76BTqleDc3l4O7CtziWrDWr71USTmQMch2KqAp5EKwrnMJRhwTLJqIp2sJS4cy9FuuN/RXlIO8Qy8gE30fSAXvQ5OuQGgFEDPMRRMGM3e/xw3pGBF28Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QPe3Q9tD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QPe3Q9tD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EA31F000E9;
	Fri, 26 Jun 2026 07:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782458685;
	bh=GwOPMKNDbBlLhidfP2nJzaUKmaAUanSbl/3RW1Q/kA4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QPe3Q9tDvmaN0FkzBJLnPN/H+6UxZqJze/WHbtnAeN3qO6WWYR+RgBs/NDi0jEEE+
	 v3rxgDo7b/GsbF2IwDhFDEqQtScw1zGxj9tlCmwTfsFXW9BQ4fpELAwVlk2AEX9jdD
	 RzE+ARLUh+2lGVOdrUsdNv2BA6TcrN1iOo6Hyj1f288n9K/3gdxVKGKilohc/q/F8s
	 L/P+QpJPyS/k9wxqYhezs3lYVFjPva1lQy8qVhrpx9bhFQ/UcfB0//7hqCcIFdshrN
	 SDc3M8PfUXIPb9Ipp2h0D0cGt2P30cjgK5ZCdGUHu1Ei4bwHaB3FfM+0UhT7zsD7dr
	 5tbk3kaF6Gakg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260626070408.3420953-7-fuad.tabba@linux.dev>
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
 <20260626070408.3420953-7-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 07:24:44 +0000
Message-Id: <20260626072444.F1EA31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch correctly fixes TOCTOU and arbitrary read/write vuln=
erabilities for GICv3 by preventing EL2 from directly dereferencing host-pr=
ovided pointers in `handle___vgic_v3_save_aprs` and `handle___vgic_v3_resto=
re_vmcr_aprs`. However, it leaves the exact same vulnerability unpatched in=
 the GICv5 equivalents: `handle___vgic_v5_save_apr` and `handle___vgic_v5_r=
estore_vmcr_apr`. These functions take a host-supplied pointer (`cpu_if`), =
which they pass directly to the inner save/restore functions via `kern_hyp_=
va`. Because `kern_hyp_va` is idempotent for hypervisor linear-map pointers=
, the untrusted host (which is an adversary in the pKVM threat model) can p=
ass an arbitrary EL2 memory address. This allows the host to execute arbitr=
ary memory reads and writes in the hypervisor (e.g., writing the value of `=
SYS_ICH_APR_EL2` to arbitrary EL2 memory or reading arbitrary memory into s=
ysregs), completely bypassing pKVM isolation.
--

commit 815e460f9f860b3c06ec7eb259e1f2d75d196c33
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Minimise EL2's exposure of host VGIC state during world switch

The host passes a vgic_v3_cpu_if pointer to the __vgic_v3_save_aprs and
__vgic_v3_restore_vmcr_aprs hypercalls, which EL2 dereferences
wholesale. That exposes the host's full VGIC emulation state to the
hypervisor, against pKVM's isolation goals.

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
> +		for (i =3D 0; i < ARRAY_SIZE(host_cpu_if->vgic_ap0r); i++) {
> +			host_cpu_if->vgic_ap0r[i] =3D hyp_cpu_if->vgic_ap0r[i];
> +			host_cpu_if->vgic_ap1r[i] =3D hyp_cpu_if->vgic_ap1r[i];
> +		}
> +	} else {
> +		__vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> +	}
>  }
> =20
>  static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *h=
ost_ctxt)
>  {
> -	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *host_vcpu;
> +
> +	host_vcpu =3D get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1,
> +							   &hyp_vcpu);
> +	if (!host_vcpu)
> +		return;
> =20
> -	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
> +	if (unlikely(hyp_vcpu)) {
> +		struct vgic_v3_cpu_if *hyp_cpu_if, *host_cpu_if;
> +		int i;
> +
> +		hyp_cpu_if =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> +		host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> +
> +		hyp_cpu_if->vgic_vmcr =3D host_cpu_if->vgic_vmcr;
> +		/* Should be a one-off */
> +		hyp_cpu_if->vgic_sre =3D (ICC_SRE_EL1_DIB |
> +					ICC_SRE_EL1_DFB |
> +					ICC_SRE_EL1_SRE);
> +		for (i =3D 0; i < ARRAY_SIZE(host_cpu_if->vgic_ap0r); i++) {
> +			hyp_cpu_if->vgic_ap0r[i] =3D host_cpu_if->vgic_ap0r[i];
> +			hyp_cpu_if->vgic_ap1r[i] =3D host_cpu_if->vgic_ap1r[i];
> +		}
> +
> +		__vgic_v3_restore_vmcr_aprs(hyp_cpu_if);
> +	} else {
> +		__vgic_v3_restore_vmcr_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> +	}
>  }

[Severity: Critical]
This is a pre-existing issue, but while this patch correctly fixes the TOCT=
OU
and arbitrary read/write vulnerabilities for GICv3, it seems the same patte=
rn
remains unpatched in the GICv5 equivalents:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_save_apr() {
	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
}

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_restore_vmcr_apr() {
	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
}

Since kern_hyp_va() is idempotent for hypervisor linear-map pointers, could
the untrusted host (which is an adversary in the pKVM threat model) pass an
arbitrary EL2 memory address here?

Would this allow the host to execute arbitrary memory reads and writes in t=
he
hypervisor (for example, writing the value of SYS_ICH_APR_EL2 to arbitrary
EL2 memory or reading arbitrary memory into sysregs), which might bypass pK=
VM
isolation?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626070408.3420=
953-1-fuad.tabba@linux.dev?part=3D6
