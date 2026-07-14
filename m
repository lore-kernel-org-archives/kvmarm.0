Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C65D38D3ED
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 12:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784031617; cv=none; b=daOCpLBLVaMWcMRlkg8R1UJTfpmhuT6/wt4u3JQbkcLLMhw5fl/NC73YzbNGOXSMyVy7ezCsQcj4uAxCtyV3iLkCs5vHf4GhslscQzTvdmNMMkhaFizyiuv5LRqpPQ9R9rnSKLd2naq4yJ8r0ZOyPVQamz530+mHJ538d4SqlEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784031617; c=relaxed/simple;
	bh=TX1dlR/hfnVOljyju0mZfRReM3QerL+y/0GCLKoMcGI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M0/65YXF9CxP0swzPCG7ow+x/a7EpyilLXlPE/7YCLo6xHsn2TZITzf+YLJKmkGogr0gjNXoQMpfTRa55xjCmgtqJpvSIUZiLo+Ad8E/5UtanFuzsysK6L4/Yrl/eECVkpouwDaDNL7OiSykkHtiwNbqhz3K1ylZKtBs6bBfmbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDLZiWVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDLZiWVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCB71F000E9;
	Tue, 14 Jul 2026 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784031616;
	bh=P/zGieXjV7I9yYhllOnAzX3resmEgvClK/UvP4YqAUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JDLZiWVA+onFmPrkw+mL3dnzxZ3g3bOV3BaYHJkq90usrCsrqGbwehYuRQt1rTryJ
	 rVhtRxMgehuFaTYoXYD0mx5X+Plv1Qx94oVohFoHxDcgVEMUjhnWQekNagJz7opXdc
	 f4bbQB7MjlyNsB+U165r9iBgn07drOkpYI8ZmVnWpsBddr2Ho7NLlMXrZC2v1qVnVi
	 Ip9kHsEDJ7inm/J70Xyeft0eOvHjT6nYOjJBEs425NKYXChbcdt3RgFIffCvsRFKqA
	 w1xQUbWhFmEcECYGFwmBabse1xGnJ4ZuM5H9cX5n+KPYQu+D2wRfKL28cJL3vm/rlg
	 PZLlz/GXCjitg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 7/8] KVM: arm64: Add primitives to flush/sync the
 VGIC state at EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260714101601.4142645-8-fuad.tabba@linux.dev>
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-8-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 12:20:15 +0000
Message-Id: <20260714122015.EDCB71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Missing its_vpe copy in flush_hyp_vgic_state breaks GICv4 virtual =
LPI injection

Pre-existing issues:
- [High] KVM_SET_ONE_REG updates to GICv3 VMCR are silently dropped under p=
KVM during vcpu_put()
--

--- Patch [7]: [PATCH v5 7/8] KVM: arm64: Add primitives to flush/sync the =
VGIC state at EL2 ---
commit 5a3c12abf480537e61537f1e45492ee3e349846c
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add primitives to flush/sync the VGIC state at EL2

pKVM performs its own world switch for protected VMs but has no primitives
to move the per-vCPU VGIC state between the host and hypervisor vCPU
contexts. Add flush_hyp_vgic_state() and sync_hyp_vgic_state().

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index f3233ee343a39..2db56146ec493 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
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
> +	hyp_cpu_if->vgic_sre	=3D (ICC_SRE_EL1_DIB |
> +				   ICC_SRE_EL1_DFB |
> +				   ICC_SRE_EL1_SRE);
> +	hyp_cpu_if->used_lrs	=3D used_lrs;
> +
> +	for (i =3D 0; i < used_lrs; i++)
> +		hyp_cpu_if->vgic_lr[i] =3D host_cpu_if->vgic_lr[i];
> +}

[Severity: High]
Does this code miss copying the its_vpe struct?

Previously, this was a full struct assignment. By explicitly copying fields
instead, its_vpe is omitted, leaving its_vpe.its_vm as NULL in the
hypervisor vCPU state.

When the guest runs, __vgic_v3_activate_traps() executes at EL2 and relies
on this field:

arch/arm64/kvm/hyp/vgic-v3-sr.c:__vgic_v3_activate_traps() {
    if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
        cpu_if->its_vpe.its_vm || !cpu_if->vgic_sre)
        write_gicreg(vgic_ich_hcr_trap_bits() | ICH_HCR_EL2_En, ICH_HCR_EL2=
);
    ...
}

Since its_vm is NULL, ICH_HCR_EL2_En is not set. Could this break GICv4
direct virtual LPI injection for non-protected guests?

[ ... ]

> @@ -166,9 +199,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
>  static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> -	struct vgic_v3_cpu_if *hyp_cpu_if =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgi=
c_v3;
> -	struct vgic_v3_cpu_if *host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v=
3;
> -	unsigned int i;
> =20
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
> @@ -181,10 +211,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
> =20
>  	host_vcpu->arch.iflags		=3D hyp_vcpu->vcpu.arch.iflags;
> =20
> -	host_cpu_if->vgic_hcr		=3D hyp_cpu_if->vgic_hcr;
> -	host_cpu_if->vgic_vmcr		=3D hyp_cpu_if->vgic_vmcr;
> -	for (i =3D 0; i < hyp_cpu_if->used_lrs; ++i)
> -		host_cpu_if->vgic_lr[i] =3D hyp_cpu_if->vgic_lr[i];
> +	sync_hyp_vgic_state(hyp_vcpu);
>  }

[Severity: High]
This is a pre-existing issue, but does handle___vgic_v3_save_aprs()
silently drop userspace modifications to the GICv3 VMCR?

When userspace sets the VMCR register, vcpu_load() first calls
handle___vgic_v3_restore_vmcr_aprs(), which copies host_cpu_if->vgic_vmcr
to the hyp vCPU. KVM_SET_ONE_REG then updates the host copy of the register.

Finally, vcpu_put() calls handle___vgic_v3_save_aprs():

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v3_save_aprs() {
    ...
    hyp_cpu_if =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
    ...
    host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
    host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;
}

Doesn't this unconditionally overwrite the new host value (set by
KVM_SET_ONE_REG) with the old value stored in the hyp vCPU at load time,
potentially breaking VM migration and state restoration?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714101601.4142=
645-1-fuad.tabba@linux.dev?part=3D7
