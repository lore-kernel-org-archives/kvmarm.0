Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050FE305677;
	Fri,  3 Jul 2026 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096455; cv=none; b=t0p1fjYi9HSEqb/Q1SKy01LUNF9XGt5/5DmYcoTGuzTrer1G2PRoNIURU1MZjApfwwcrL+PClxDi78cpGVJ7c2wa8D8UZ74M6RcstRu/ieM01U4dandkMDhhnKZ9o59THKmQD0SxLqjly7kGUqEvlzL0+RnUYsRzyUV3ovVbF50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096455; c=relaxed/simple;
	bh=pe6gkrreVYnYsriQti8ReTj6X2u5qAp6O+9Y4fHIXvc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GffUfEb8wPIICXrQwggepQKwEt1zrQMOM9L6vdKzaE8IPaG7QfgWHfhUoah7ASXb7N1H80czwj+Z+fvDoPGC/H1Ob4rFsfK8ePykRhx3vwH158zXjG1uVvGYkiiA2l5VjYFRkYl+FIkLY9kF5ciTq9Pk5nAnxtQrMjYJI34AKTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ya9/iCCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ya9/iCCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5351F000E9;
	Fri,  3 Jul 2026 16:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096453;
	bh=vVbGrt6o2huN74QeFnFapbrPCgbsKWT5mkYtg03WQ/w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ya9/iCCDhIpJwKyiX1cHib2hToYsCK/7bEEOZQt+gX+XQoW83GIxQ1rRP94wqeDqx
	 dlOkUPVpIu2Sa8qe0fWscUlMkw8illR4WzzPimvsKQBf7xvFA9gBHgU8KzRBZUlmrA
	 gwQHVWn4RJE6pw+hDh4yXp1mQmiMID+9j/imP+ljZMYL5KbaloqL+1cALOViOIkiNk
	 +XeNVhHwAjmsvjeOB58Abl2rixUVxL/kOvORMn1Qarww3YXqjqHaVGOysSZ5avxmoK
	 lgzhEKf1msypaQfOSoU1TKGM4JvVYpJrgrXxP6XU5gHtrjpCS0b+IcdGDyA89sCvRn
	 kDbSmXvOPCRcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 23/40] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260703154811.3355680-24-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-24-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:34:12 +0000
Message-Id: <20260703163413.4C5351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The GICv5 ICH_CONTEXTR_EL2.IRICHPPIDIS hardware state becomes stal=
e when the guest dynamically changes the IRS enable state.
--

commit d313992de37684fea236b00103b87412260608d1
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state

This commit updates the GICv5 ICH_CONTEXTR_EL2 register's IRICHPPIDIS field
to reflect the hypervisor's IRS enable state. It applies this state during
vgic_v5_load() to control the delivery of SPIs and LPIs to the guest.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 2df61426cc714..ffb0500a4c9a7 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1058,6 +1058,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
> =20
>  void vgic_v5_load(struct kvm_vcpu *vcpu)
>  {
> +	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;
>  	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
>  	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
>  	u16 vpe =3D vgic_v5_vpe_id(vcpu);

[ ... ]

>  	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
> +				FIELD_PREP(ICH_CONTEXTR_EL2_IRICHPPIDIS, irichppidis) |
>  				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
>  				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);

[Severity: High]
Does this leave the hardware state stale when the guest dynamically changes
the IRS enable state?

When the guest toggles the IRS enable state by writing to GICV5_IRS_CR0,
the MMIO handler triggers a sequence like this:

vgic_v5_mmio_write_irs_misc()
    kvm_arm_halt_guest(vcpu->kvm);
    vgic->enabled =3D !!(val & GICV5_IRS_CR0_IRSEN);
    kvm_arm_resume_guest(vcpu->kvm);

Because kvm_arm_halt_guest() simply sends KVM_REQ_SLEEP and
kvm_arm_resume_guest() immediately clears the pause flag, running vCPUs
that exit to handle the request will see pause =3D=3D false in
kvm_vcpu_sleep().

They will then re-enter the guest without calling schedule(), which
bypasses kvm_arch_vcpu_put() and kvm_arch_vcpu_load(). This means
vgic_v5_load() is never called to update cpu_if->vgic_contextr with the
new irichppidis state.

Should there be a mechanism to force a GICv5 context reload (similar to
KVM_REQ_RELOAD_GICv4) to ensure the updated register value is applied?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D23
