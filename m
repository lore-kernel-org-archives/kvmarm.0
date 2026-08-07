Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CE4280331;
	Fri,  7 Aug 2026 16:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786119655; cv=none; b=C7OY9NLH4uAJz/1CUlD8iWVztH8W4oGKue7BD2BW9F8dd4/ygN41o26PSUuyvty0OITUHjaRjNHYwj7onxJ/VIt6yP0iAcKbH6d08zeo0OdZV4LoMm2icc3z1oPekPlxYnWE6paKkqG5vQRH56dCPfWZJMbeDRReB0joeZ5mo4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786119655; c=relaxed/simple;
	bh=5Kq0D1VDgc/aeeEYkKiaKCkpRQ5bwuPl5hs+zY6tL/Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=seSxNVYWCbhmuQ/IyNqYEcd3bUxbcDv06kJdjDu4DVSwI12egPv2p8N13vIFRZhg1/LzT9HeVXkirDin5obZae6Mo6nMjsU9iGBwMabqGOJnDKONlJSbArNgj13ZxFrpcAbC7HVUXQu9bFwC8U+GsDNhjwQetmMv5oeBSxrhO6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtvC5wQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtvC5wQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEC71F000E9;
	Fri,  7 Aug 2026 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786119653;
	bh=5pMFsqQTHcQ+Rn9idFvDXGrE+yz2Oj3OwvnHW54vSWY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mtvC5wQZNmYssl/an8V+StmM3QW+waxkxShkolOw+JL2wRTArb96FxvIMq9Mp52zq
	 HCIkBTZUtLf/YTdHGl01a4mgUu/XSOx3PTl2Xm0BPygPLM7lkfLbOgeiECbEWp8xcs
	 KVLsUSCw3JrUDhm/N8EXxda0d/Uuilm4k4s+VxbSGtHEI7NsOJcBDovgLR/YSrXscU
	 24rGES7Gocr3s8caTRP0OeYhTbiRFEputonf8UQAxQ8vcJ5LFRHQKsXIdurixA42Qh
	 eUpq/M+unGrppO8lptPCUL9sW2OZVyWP0vbnXG8WAIYPesvaHXAHzjHIbix9usZtaJ
	 Um/F3IbnoVJLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 32/49] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260807111159.429128-33-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-33-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 16:20:52 +0000
Message-Id: <20260807162053.3AEC71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Userspace can inject an inconsistent state by setting IRS_IST_BASE=
R.valid=3D1 without allocating a host IST, leading to a CONSTRAINED UNPREDI=
CTABLE hardware state if the guest subsequently clears the valid bit.
--

--- Patch [32]: [PATCH v5 32/49] KVM: arm64: gic-v5: Handle userspace acces=
ses to IRS MMIO region ---
commit 24ee880222eb3e4ff06c9b27b1d655da134efd7a
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Date:   Fri Aug 7 11:28:54 2026 +0000

KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
   =20
As part of saving and restoring the state of a GICv5-based system,
userspace must save and restore the IRS MMIO registers. These include
important information such as the guest IST configuration, and KVM
must present consistent state to the guest after migration.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> index 095046c7959fa..212066b8d7ed5 100644
> --- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
[ ... ]
> +static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vcpu *vcpu, gpa_t a=
ddr,
> +					  unsigned int len, unsigned long val)
> +{
> +	struct vgic_dist *vgic =3D &vcpu->kvm->arch.vgic;
> +	struct vgic_v5_irs *irs_data =3D vgic->vgic_v5_irs_data;
> +	size_t offset =3D addr & (SZ_64K - 1);
> =20
> -		/* The address cannot be changed while the IST is valid. */
> -		if (irs->ist_baser.valid && valid)
> -			return;
> +	/*
> +	 * The following registers are ONLY settable via uaccesses. The guest
> +	 * cannot write them!
> +	 */
> =20
> -		/* Valid -> Invalid */
> -		if (irs->ist_baser.valid && !valid) {
> -			/* Make the LPI IST invalid and then ... */
> -			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
> -				break;
> +	switch (offset) {
[ ... ]
> +	case GICV5_IRS_IST_BASER:
> +		if (irs_data->ist_baser.valid &&
> +		    !vgic_v5_ist_baser_matches(irs_data, val))
> +			return -EINVAL;
> +
> +		vgic_v5_update_irs_ist_baser(irs_data, val);
> +		break;

[Severity: High]
Does this allow userspace to inject an inconsistent state?

If userspace sets the valid bit of GICV5_IRS_IST_BASER to 1 via
vgic_v5_mmio_uaccess_write_irs() but does not actually allocate a host LPI =
IST
(by omitting the KVM_DEV_ARM_VGIC_GRP_IST ioctl), the VM can still be start=
ed.

When the guest subsequently clears the valid bit, KVM's MMIO handler:

vgic_v5_write_irs_ist_baser() {
    ...
    if (irs->ist_baser.valid && !valid) {
        /* Make the LPI IST invalid and then ... */
        rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);

detects a Valid -> Invalid transition and issues the LPI_VIST_MAKE_INVALID
command. This sends an unmap command to the hardware for a VIST that was ne=
ver
mapped.

Since this results in CONSTRAINED UNPREDICTABLE hardware behavior, should K=
VM
reject uaccess writes that set the valid bit without a backing IST, or perh=
aps
verify IST presence before issuing the unmap command?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D32
