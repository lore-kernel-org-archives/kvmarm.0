Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB3930F927
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781853682; cv=none; b=B7athy5kbvEZqJq3TKSOIICPKx23+FNtQYKL73RUSQANk+ZbosRrMeI5Qr1mNtURdIdyZt0inTEmSX0exYr/a9T90n3k3ThQxJI3E+uM4Pn2QPTYA/j9IH9WkZGcPrN/tM45KjcEt7PKZDdtUzpLkGCmCMbQqH0DE1VGp+TGTPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781853682; c=relaxed/simple;
	bh=9VNM0lYaLdlJSK96F9ugRgYdfY1BZl66dVEyM3QMhYs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H21AY8jUkoGqL29c2Sm28DWT7gwcofX6A7A3xaHF/TDy4iIHkK8VXKPyW234liwtKCOb9p0OsUkxKrIxVSZRbyPlr24AIUheReKr19TFn5ljP5knCWzLVpHl8DgeokDnTpOB8aMlSl7Z6N1YWD403dg+LdfmAkjO3LdU0b7GXGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6RQSsrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6RQSsrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395E71F000E9;
	Fri, 19 Jun 2026 07:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781853681;
	bh=7YVOXGVVoq3hpbL3Q8+rojfc33BJx1gXfurCWa52PAg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S6RQSsrMeWfHO12yeVx97L6QJkDlBmR149+IvIWmqFhEwESZLWY4WgFDxwS0g/Zr5
	 vg659JZHc3nMujIcfHCTTxy4YqchGQ9noHmA7Xa50DNw+AZdPvZko6CnYWJ2WRwqlJ
	 AhQ7XyXaUR5z2tLPXPDqaz4EjyDmEk4SFR31i37e1Xn2AFSLru5lBcisFXN06t1Em1
	 mWmlTUhxSS1KgnyR7mx9kQi0dwnMGvw0ydgXivqt4/pLfV/gBogQpdroqQmuHo+q6f
	 gHqctNbPxec8t8z2UGpMOZ2gVbIFaQ/MO+3suzZYFrWIQnIkT27/F+zLmMB+xdIgSM
	 /YXQr6wzAfamw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/8] KVM: arm64: Add primitives to flush/sync the
 VGIC state at EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260619070719.812227-8-tabba@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-8-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 07:21:20 +0000
Message-Id: <20260619072121.395E71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] flush_hyp_vgic_state() fails to copy vgic_vmcr from the host vCPU =
to the hyp vCPU, causing host-side VMCR updates to be silently lost and sub=
sequently clobbered.

Pre-existing issues:
- [High] flush_hyp_vcpu() unconditionally copies mdcr_el2 from the untruste=
d host vCPU, allowing the host to control debug trap configurations for pro=
tected VMs.
--

commit 5eaa1440f7e2f022736f913bec34aaa0cbd53a5d
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add primitives to flush/sync the VGIC state at EL2

pKVM performs its own world switch for protected VMs but has no primitives
to move the per-vCPU VGIC state between the host and hypervisor vCPU
contexts. Add flush_hyp_vgic_state() and sync_hyp_vgic_state() to handle
the required copying.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index f3233ee343a39..2db56146ec493 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -104,6 +104,45 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
>  	*host_data_ptr(fp_owner) =3D FP_STATE_HOST_OWNED;
>  }
> =20
> +static void flush_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> +	struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
> +	unsigned int used_lrs, i;
> +
> +	host_cpu_if	=3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> +	hyp_cpu_if	=3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> +
> +	used_lrs	=3D host_cpu_if->used_lrs;
> +	used_lrs	=3D min(used_lrs, hyp_gicv3_nr_lr);
> +
> +	hyp_cpu_if->vgic_hcr	=3D host_cpu_if->vgic_hcr;
> +	/* Should be a one-off */

[Severity: High]
Does flush_hyp_vgic_state() need to copy vgic_vmcr from the host vCPU to the
hyp vCPU here?

For GICv2-on-GICv3 emulation, guest writes to GICC_VMCR and GICC_CTLR trap
to the host (EL1) as MMIO.=20

The host updates the host_vcpu's vgic_vmcr and resumes the guest loop
without a full vcpu_put/load cycle.=20

By omitting the copy here, the hypervisor will re-enter the guest with the
old hardware VMCR state.

> +	hyp_cpu_if->vgic_sre	=3D (ICC_SRE_EL1_DIB |
> +				   ICC_SRE_EL1_DFB |
> +				   ICC_SRE_EL1_SRE);
> +	hyp_cpu_if->used_lrs	=3D used_lrs;
> +
> +	for (i =3D 0; i < used_lrs; i++)
> +		hyp_cpu_if->vgic_lr[i] =3D host_cpu_if->vgic_lr[i];
> +}
> +
> +static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> +	struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
> +	unsigned int i;
> +
> +	host_cpu_if	=3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> +	hyp_cpu_if	=3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> +
> +	host_cpu_if->vgic_hcr =3D hyp_cpu_if->vgic_hcr;
> +	host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;

[Severity: High]
Will this unconditionally overwrite the host's vgic_vmcr with the hyperviso=
r's
stale copy?

Since flush_hyp_vgic_state() doesn't bring the updated vgic_vmcr into the
hyp vCPU on entry, syncing it back to the host here appears to permanently
clobber the guest's MMIO write.

This missing synchronization could break GICv2 priority masking and group
enables.

> +
> +	for (i =3D 0; i < hyp_cpu_if->used_lrs; i++)
> +		host_cpu_if->vgic_lr[i] =3D hyp_cpu_if->vgic_lr[i];
> +}
[ ... ]
> @@ -152,13 +191,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp=
_vcpu)

[Severity: High]
This is a pre-existing issue, but does flush_hyp_vcpu() unconditionally copy
mdcr_el2 from the untrusted host vCPU?

Currently, flush_hyp_vcpu() contains:

    hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;

In pKVM, the host memory is untrusted. By manipulating the host_vcpu's
mdcr_el2, could a compromised host configure debug traps (e.g., MDCR_EL2.TD=
A,
TDE) for protected VMs?=20

This would bypass the pKVM threat model, which requires trap configuration
registers to be initialized in an EL2-private context to ensure guest
confidentiality and integrity.

> =20
>  	hyp_vcpu->vcpu.arch.vsesr_el2	=3D host_vcpu->arch.vsesr_el2;
> =20
> -	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 =3D host_vcpu->arch.vgic_cpu.vgic_=
v3;
> -
> -	/* Bound used_lrs by the number of implemented list registers. */
> -	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =3D
> -		min_t(unsigned int,
> -		      hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
> -		      hyp_gicv3_nr_lr);
> +	flush_hyp_vgic_state(hyp_vcpu);
> =20
>  	hyp_vcpu->vcpu.arch.pid =3D host_vcpu->arch.pid;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070719.8122=
27-1-tabba@google.com?part=3D7
