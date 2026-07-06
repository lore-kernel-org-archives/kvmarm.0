Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5822035898
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783333699; cv=none; b=qgfqt3VnezPwLzUIBuR3S/nQHdaARYEUwMqIejDpYLA7xIGahKVgpuDQMCo015dGI5E4qjumb0EV2gqVfTMhVUmh9/+GPfI1OOl1eaSdOBX7KdJ08BkqZ2biYX+Z7bnx2a4x8Yigaj+t1hdh4gnNx0nZqP6CrDGFjr161XGPH+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783333699; c=relaxed/simple;
	bh=DzjH+op0vdYWAQwFjAPVFEOtihdBghYJbsQcvZfnrV4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D7PBebpfs/uGinDjNbqIFSIT2d9soZEWvZjikKYdTSWX5d/QHGXMHzOJo033G0mKFuU4cDQqeqs9cUQD7yo8iWit7iNcAFd8iRPYq0RIC/2u3Wc/x84LirVMZWBA8MihLqsDEdkxMN5Ty/ofXzUmHDBXaLBh9LGeA9KjiKA/acE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4HEr02m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4HEr02m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03AF1F000E9;
	Mon,  6 Jul 2026 10:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783333698;
	bh=pUueC1DW9LQjWeluElUjTkI/YzyggSRew61VqtYFPy4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I4HEr02mm4RNKVJenvOoP8yk9OJIr1ZPQVFgaQ7o4e+z846JTjn1h9MMxnlmBgHgp
	 Ivk63cCuqNLSqnoQH+0e5YtGnNuXH9DOEF7vGGvYtEhdV4Jtid5Uh9+FQjzTRtjHdD
	 OSWiB4AfCNamWf1HtNcIzIL+WOMjP0n3GEHtqjeyVibTelPWE/dNqvaVr+tz/JG5dL
	 CznvOBldaBbRr+vF2C+ixPYv/I5znGrfreHE2D2la276G058+XEirj8VZaX2vThiU6
	 d+0/Qafw1SPM83XLJAeVBc7Y2rNdIFQCp/n0KzGTbdq+cGGoIcnAOFXvYOcDqvpEjd
	 ZNRudGr6ELGpA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260706095927.560795-7-fuad.tabba@linux.dev>
References: <20260706095927.560795-1-fuad.tabba@linux.dev>
 <20260706095927.560795-7-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 10:28:17 +0000
Message-Id: <20260706102817.B03AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Userspace KVM_SET_ONE_REG modifications to ICC_VMCR_EL1 and Active=
 Priority Registers (APRs) are silently overwritten and lost on vcpu_put() =
under pKVM.
--

commit 8bda67fe364c44ad574acb3da5de4bf16e0ccbbf
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Minimise EL2's exposure of host VGIC state during world switch

This commit avoids exposing the host's entire vgic_v3_cpu_if to EL2 by
copying only the necessary vgic_vmcr and active priority registers during
save and restore operations.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 45d717889f6ea..f3233ee343a39 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -508,16 +520,63 @@ static void handle___vgic_v3_save_aprs(struct kvm_c=
pu_context *host_ctxt)
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

[Severity: High]
Does this sequence risk clobbering userspace writes to ICC_VMCR_EL1 and the
Active Priority Registers?

When userspace modifies the GIC CPU interface via KVM_SET_ONE_REG, the
ioctl is wrapped by vcpu_load() and vcpu_put().

Under pKVM, vcpu_load() calls __vgic_v3_restore_vmcr_aprs, which restores
the hardware with the current values.

The ioctl then updates host_cpu_if in memory with the new userspace values.

Finally, vcpu_put() issues the __vgic_v3_save_aprs hypercall.

Since the hardware and hyp_cpu_if only have the pre-ioctl stale values,
will this explicit copy back to host_cpu_if overwrite the new values set
by userspace? This could cause state restoration or live migration to
silently lose these register updates.

> +	} else {
> +		__vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> +	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706095927.5607=
95-1-fuad.tabba@linux.dev?part=3D6
