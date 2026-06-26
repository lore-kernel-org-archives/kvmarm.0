Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877E93D3001
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782458870; cv=none; b=ppYf0fhkWiqXhi+oGjJA/yRDPnfSGSXplDu4EMTdahmCviwkolWfbmeWHGOGHjpJ7JIrz+2rKQIlHjABgWjETbCV3XesPXtR2DeUtO8sLjaHdVHJYLTPCCs5Og3HDgIkl1XoJchr8/95F8z0JY46xo2lEq639u/4UvcU7/cR9EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782458870; c=relaxed/simple;
	bh=X+8ERvxrukJLGdd73lCHqpLM3kdGeC2oa+4OhHTbTxA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BqdXHpUziN8//iQ3rzMAzHlgmr/kcp6r88TRKnSbxY5lKstxQD0a3PAMRL9BXBuhBDphd80V/AYEqO6sKOC+ULv2MewfEm0McKzC940sBgHa53f3CJdWpb+ws0gEBxYwUsMJ4o5zRC6Q9fXkT5QW5bxU+74s6hAZtG7Hb+tMeaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFnSRb3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFnSRb3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D791F000E9;
	Fri, 26 Jun 2026 07:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782458869;
	bh=V9qo5rYkmiIjqudhyHQJ34qhwFUAJXWYfegHv47ePpQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gFnSRb3AvBvq+XZhQkbGXqz97kEloBaL090jK2KhFQL9EmYLFR6b8oe9oIieRL1Ju
	 quN0Ezj6KCcIPmBsT9sWEzu28+j6P8Py7btTZTvz0Gp9d1/8PttD8EKtkBBa6iix+I
	 IFGCM4urG6ppWESaRFo3L8Jq2hzHFhzdlRJrpodX82Qf1wx8crDRfRuCTXHD/swQvd
	 hMoC8KZt+0/LSqw7JN7LwkYBaDOpiJzqKS3urqaYbm+AND+UgVRe3aCQ9JzTi10MXA
	 SCCAjAeBsPTErBFYSbnJDeA6JWApA8Z5lWFJ/2fO8e/ycyNCrIR3sH3f7vTGaMBuBH
	 tIdj7O+MTy/Jg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/8] KVM: arm64: Add primitives to flush/sync the
 VGIC state at EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260626070408.3420953-8-fuad.tabba@linux.dev>
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
 <20260626070408.3420953-8-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 07:27:48 +0000
Message-Id: <20260626072748.C9D791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Host updates to vgic_vmcr during MMIO emulation are silently disca=
rded and reverted due to missing flush on vCPU entry and unconditional over=
write on vCPU exit.
- [High] flush_hyp_vgic_state() hardcodes vgic_sre to GICv3 values, permane=
ntly breaking GICv2 emulation by preventing ICH_VMCR_EL2 from being written.
--

commit 7488e8d4b40f79a0ec0bb726d02c6676c9426897
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add primitives to flush/sync the VGIC state at EL2

This commit introduces flush_hyp_vgic_state() and sync_hyp_vgic_state() to
move per-vCPU VGIC state between host and hypervisor vCPU contexts for
protected VMs. It bounds used_lrs and hardcodes vgic_sre to a fixed value,
replacing the previous direct struct copy.

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

[Severity: High]
Does this code lose host-side updates to vgic_vmcr?

When a guest triggers a GICv2 MMIO trap, the host KVM run loop processes
it synchronously and updates host_cpu_if->vgic_vmcr. Because
flush_hyp_vgic_state() does not copy vgic_vmcr into the hypervisor state,
the hypervisor retains its stale value.=20

When the guest exits, sync_hyp_vgic_state() copies the stale hypervisor
value back, which will permanently overwrite and clobber the host's update.
Could this lead to broken GICv2 CPU interface emulation and lost interrupts?

> +	/* Should be a one-off */
> +	hyp_cpu_if->vgic_sre	=3D (ICC_SRE_EL1_DIB |
> +				   ICC_SRE_EL1_DFB |
> +				   ICC_SRE_EL1_SRE);

[Severity: High]
Can hardcoding vgic_sre to GICv3 values here break GICv2 emulation?

For VMs using GICv2 emulation on GICv3 hardware, the host sets vgic_sre =3D=
 0
to enable compatibility mode. By unconditionally overriding it to GICv3
values here, the !cpu_if->vgic_sre check will evaluate to false in
__vgic_v3_activate_traps(), which prevents the hypervisor from writing to
ICH_VMCR_EL2.=20

This appears to leave the hardware with a stale or zeroed VMCR and masks
guest interrupts. Is this intended?

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
As mentioned above, this unconditionally overwrites the host's vgic_vmcr
with the hypervisor's copy, which was never flushed from the host on entry.
Could this cause the host's MMIO emulation updates to be discarded?

> +
> +	for (i =3D 0; i < hyp_cpu_if->used_lrs; i++)
> +		host_cpu_if->vgic_lr[i] =3D hyp_cpu_if->vgic_lr[i];
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626070408.3420=
953-1-fuad.tabba@linux.dev?part=3D7
