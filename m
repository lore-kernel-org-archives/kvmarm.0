Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C774B04AC;
	Fri,  7 Aug 2026 16:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121304; cv=none; b=FwF8XbzdrhejuD5PgDYaCeboJTMYDAU77tg6iMXqzriXcr+U5NMXICTv3nc3WwtnPlCLCBIhngAWDskppCy4dSjVIaqco3wAPddpga83ZJSUp4JtBKbTnxY6QTQ6ETu25KmZ+5rvp4l8TvrPjg64NSO5mEpcyMtRsOK6WkpjOIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121304; c=relaxed/simple;
	bh=OZGCueMEQz7ZfN31r/EDPQ6qwjd4+ZD91LHHnQBbV1k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pdnbTpfTFL1/1l2wuem/sNKStsNc9Ej8uSXB6QB5DQhaOmCqoHB6gFxlgM15I/jm4hJ7UOAkltFDzq0xcGbqLHZ9lyj65r8OXJyRKSduzi7SZK4dcsc4ldipokLqJ9+5ac+W3MHtNMHd21k1DBCKNti9l749Eu3zYazY5XvbfoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C9lU59Lx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C9lU59Lx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE59D1F000E9;
	Fri,  7 Aug 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786121301;
	bh=rPGQaj//E8w7+S155f0B6nBDe5TIiVGBXJMoPKddpGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C9lU59LxCGKetRHVwC38vnjQJo3Sa57/uOVSEBHYlXGIYemPQClMmLQfZ5BZpphiI
	 Z5CL2Y+hp1i1NKQGzWoPGarh0sN6tGuu+SyZAIOXvpjTfl2mSQfa5dQb0nJioDesm6
	 i/Od0Un+Qbg6VGd3qtzw0wLF8rAVeG75wt17I2woxXpxAr9HwzM+cFCKaCdIPIlagr
	 b0EU/uHRpS3KoNO8tyUEzh3tCgiCe4OLSSodqGUOTosrVJSKxlJWsXkEw6hfPuz78b
	 OPz/L73L9R24HVJoD/CScsWCCGFoPCGLDtp3ZQTit+8cAY/G8PXVcV+ACfUBA/4dNq
	 MmI22ydoz+TWQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 35/49] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-36-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-36-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 16:48:19 +0000
Message-Id: <20260807164820.DE59D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Restoration of GICv5 IRS registers and IST state unconditionally f=
ails before the VM runs.
- [High] Missing memory barrier between DMA memory reads and MMIO writes in=
 IST save paths allows hardware to corrupt IST state.
- [Medium] Early returns in `vgic_v5_vmte_release` leak VM memory structure=
s if IST freeing fails.
--

--- Patch [35]: [PATCH v5 35/49] KVM: arm64: gic-v5: Implement save/restore=
 mechanisms for ISTs ---
commit 32376ab3f3a6714615e18eef70c631afa3b5cd05
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs

This patch adds support for saving and restoring GICv5 Interrupt State Tabl=
es
(ISTs) during virtual machine migration. It introduces interfaces to export
the internal SPI and LPI IST states to userspace and inject pending
interrupts upon restoration. The state is checked for hardware quiescence
during the save operation.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
[ ... ]
> @@ -646,13 +661,23 @@ static int vgic_v5_mmio_uaccess_write_irs(struct kv=
m_vcpu *vcpu, gpa_t addr,
>  			return -EINVAL;
>  		break;
>  	case GICV5_IRS_IST_BASER:
> -		if (irs_data->ist_baser.valid &&
> -		    !vgic_v5_ist_baser_matches(irs_data, val))
> +		ret =3D vgic_v5_lpi_ist_exists(vcpu->kvm);
> +		if (ret < 0)
> +			return ret;

[Severity: High]
Is this check going to unconditionally fail during live migration?

Userspace typically restores registers before the first KVM_RUN. However,
vgic_v5_lpi_ist_exists() requires the vmi structure to be present in the
vm_info XArray, which is only allocated in vgic_v5_vmte_init() (triggered by
the first KVM_RUN).

Will this cause -ENXIO to be returned when restoring GICV5_IRS_IST_BASER?

[ ... ]
> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
[ ... ]
> @@ -604,6 +662,9 @@ int vgic_v5_vmte_release(struct kvm *kvm)
>  	if (!vmi)
>  		goto no_vmi;
> =20
> +	/* Unlikely, but possible. Avoid leaking the memory. */
> +	vgic_v5_drain_pending_irqs(kvm, vmi, false);
> +
>  	/* If we have an LPI IST, free it */
>  	if (vmi->h_lpi_ist) {
>  		ret =3D vgic_v5_lpi_ist_free(kvm);

[Severity: Medium]
Does returning early from vgic_v5_vmte_release() cause a memory leak?

If vgic_v5_lpi_ist_free() or vgic_v5_spi_ist_free() fails, the function
returns immediately without freeing vmi->vped_base, vmi->vpet_base,
vmi->vmd_base, and the vmi structure itself.

Should these teardown paths make a best-effort attempt to free the remaining
resources rather than aborting?

[ ... ]
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -1267,3 +1300,292 @@ void vgic_v5_save_state(struct kvm_vcpu *vcpu)
[ ... ]
> +	/* Save the SPI IST to the userspace buffer. */
> +	ret =3D vgic_v5_save_spi_ist(kvm, &ist_attr);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret =3D vgic_v5_irs_is_quiesced(vm_id);

[Severity: High]
Can the hardware corrupt the IST state during the read loop?

The vgic_v5_save_spi_ist() function reads from DMA memory. It is immediately
followed by a call to vgic_v5_irs_is_quiesced(), which uses writeq_relaxed()
to issue an MMIO write.

Since raw_spin_lock_irqsave() only provides an ACQUIRE barrier, is there
anything preventing the CPU from reordering the relaxed MMIO write before
the DMA reads complete? If reordered, the hardware could break quiescence a=
nd
modify the ISTs concurrently, while the software mistakenly concludes the VM
remained quiesced.

Would adding a dma_rmb() or rmb() ensure the DMA reads complete before
checking the hardware status?

[ ... ]
> +int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *at=
tr)
> +{
[ ... ]
> +	ret =3D vgic_v5_lpi_ist_exists(kvm);
> +	if (ret) {
> +		if (ret > 0)
> +			ret =3D -EBUSY;
> +		goto out_unlock;
> +	}

[Severity: High]
Does this have the same migration failure as vgic_v5_mmio_uaccess_write_irs=
()?

Since vmi hasn't been allocated by the first KVM_RUN yet,
vgic_v5_lpi_ist_exists() will return -ENXIO, causing the restoration to
fail unconditionally.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D35
