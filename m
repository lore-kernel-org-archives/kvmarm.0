Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D33A3DCDB0
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781249010; cv=none; b=uzi9ouHsFQW6VfTfVAE3MV1xPl57Fw/GpUWq/h68hCCOILadJmv6GzYjLQd0jtRUWeVHoE4oU0WFm7VQqlPUVRPKCd3B5Y9dBOH12Lqp/NzZ18xQJWbMGBgEA7iGdZ2WCQKogljm9zhT4gV8G4gZ5w64zig3WCWwMkYm3s3f3Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781249010; c=relaxed/simple;
	bh=zEg9wZvNziIJciATQCy5sMoZ3ufGTsaZvmC9spfygG0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aCVc/PbGV7HpvYFukAhhSBvEVb4+GRfb2NPfv6StkDQtVbpgYjYE7jfQBSlqUIonO2rvkadrZvAwcbz10dAO58koC/KFpcI/21GLa3BCfLqC23ulPHmuPhhbgDgf+RH1IExquA4MFAVe5tRbKRvys/5w1LoSopknasiGTTgCJcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/OFMIdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/OFMIdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6B31F000E9;
	Fri, 12 Jun 2026 07:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781249009;
	bh=agT/PGBi/rovNC1HfqdHwabkhknXEYr7YciXEfcx1yI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R/OFMIdUErdl9GbgQ9UBIjRXwQ8rqkcL6NhBA2ge0B2mKtLtjnC+3Xkzywnh8KukY
	 JkVahOBrUMfpP/M8NrmRJurVHz0pBQulR2KJwziwqM40zgK1eSYhtcMCOd67UsEojg
	 yHeMgdn2r8VS0Py3DfKUOc7MhZB4m3ar7oLrz9RUv+PqoHIuzISe2/PJqUOy4ZxTZW
	 go3OP3UGaZK6CY3JXiD1f2z5/7HA6bw3BIL5C9g4qKw5nz4AUatVE560J0/lPYaN8m
	 edpkGkg74aTDTzv2tMAZXfGOOjRpOWqfwJd3ypoNxnw861zzN/V2n5rAG7QpNP3cAx
	 dG7hYE0QqiITw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 10/11] KVM: arm64: Add primitives to flush/sync the
 VGIC state at EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: tabba@google.com
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260612065925.755562-11-tabba@google.com>
References: <20260612065925.755562-11-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 07:23:28 +0000
Message-Id: <20260612072328.BC6B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unconditional pinning of vgic_sre to SRE=3D1 breaks GICv2 emulatio=
n for non-protected guests.
--

commit 3d9e59afaa5e29a6ce57ece8ccacae434b38915d
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add primitives to flush/sync the VGIC state at EL2

This commit adds flush_hyp_vgic_state() and sync_hyp_vgic_state()
primitives to move per-vCPU VGIC state between the host and hypervisor
contexts for pKVM.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 2f165b6c7b071..23e644c24a03a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -99,6 +99,46 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
[ ... ]
> +static void flush_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> +	struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
> +	unsigned int used_lrs, max_lrs, i;
> +
> +	host_cpu_if	=3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> +	hyp_cpu_if	=3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> +
> +	max_lrs		=3D (read_gicreg(ICH_VTR_EL2) & ICH_VTR_EL2_ListRegs) + 1;
> +	used_lrs	=3D host_cpu_if->used_lrs;
> +	used_lrs	=3D min(used_lrs, max_lrs);
> +
> +	hyp_cpu_if->vgic_hcr	=3D host_cpu_if->vgic_hcr;
> +	/* Should be a one-off */
> +	hyp_cpu_if->vgic_sre	=3D (ICC_SRE_EL1_DIB |
> +				   ICC_SRE_EL1_DFB |
> +				   ICC_SRE_EL1_SRE);

[Severity: High]
Does hardcoding ICC_SRE_EL1_SRE here break GICv2 emulation for non-protected
guests?

When __vgic_v3_restore_state() executes on guest entry, it will program
ICC_SRE_EL1 with this value. Setting the SRE bit to 1 disables the GICv2
memory-mapped interface (GICV) for EL1. Non-protected guests configured to
use GICv2 rely on vgic_sre =3D=3D 0 to keep the memory-mapped interface ena=
bled.

Should this value be copied from the host-set values for non-protected VMs
rather than being unconditionally pinned?

> +	hyp_cpu_if->used_lrs	=3D used_lrs;
> +
> +	for (i =3D 0; i < used_lrs; i++)
> +		hyp_cpu_if->vgic_lr[i] =3D host_cpu_if->vgic_lr[i];
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.7555=
62-1-tabba@google.com?part=3D10
