Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BB12D77E6;
	Fri,  3 Jul 2026 16:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096918; cv=none; b=oe+pM/XCJ/yogI32owjcFjrhYDINolJ/4I9ozTj74wR1AXxNDgfdtxExmrvYznKZMuF8sX5NRwjcxai9QEKqdun+Sc3YTvFmmAHLvIWd60oVRjvN30j2Qa6as9wcRaSMXecfFDMCcWacLCul5REH991yeW2EcRxQa1N1Q9rZuKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096918; c=relaxed/simple;
	bh=t+5dejYhWC/yQ5c54ZrF/LcxZgEg3wlAaDxTIRqe1uw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eJUIa/J8ULrsfNF4WVr43ZIHxjk79MfLnoBDruGzEpASQYV8GkqZEzNWIgn+8XIi0JZgEE9oNoiFkV7B5KnVK7Ay9C8sX9z2BytwfQJL9hogMSNcoqvIg96SVwdrVSfTQr98EjWBlgyLfh6/IUZxdiQHGTp3LnQ/EGt8NB5uBfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhJdjnPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhJdjnPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A794C1F000E9;
	Fri,  3 Jul 2026 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096917;
	bh=TzQE8IBlneVU+OhMIM9369M6AoW2gvnoBb0MU8ieuSg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YhJdjnPhOFxa0asTE7fd6/+pShLESVQCc0BRp2F5k6xIacOVKRJFHDH0s/Rz5wvPg
	 XFDZ3r0nMIsILsljv3vGDLwP8h9fHpgyAhhbzdecM2DqGAcASvcygyDOvESzbzPAdX
	 mpnEcJb3sURNf92RGg3vGtKdd4eqXSKZyVMqYalAVnqs3KYVgercI05D9goRupKqYY
	 IY0Y4STkjQSRfVYMIvd7TKShigeAEZBfSfmDv1HeV+On1Zeb0AU+AFC5if4bw/v/CP
	 /+/yynPJsORpMOhHOslgv/K4C2bXYeqw0N5dvSvHrbxeeCVqLl2kXcpBviCb5h+JZU
	 GrJZdhdmdj4cA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 27/40] KVM: arm64: gic-v5: Track SPI state for
 in-flight SPIs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-28-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-28-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:41:56 +0000
Message-Id: <20260703164156.A794C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] O(N^2) list iteration and hypercalls under a global lock causes se=
vere lock contention.
- [High] Level-triggered SPIs will permanently deadlock because the ack not=
ifier is gated behind `!irq_is_pending(irq)`.
- [High] Unconditional acquisition of the global `vgic_v5_spi_ap_list_lock`=
 in the vCPU fast-path creates severe lock contention.
--

commit 28a2c4a894df246c922d7f15a80a0ec24111b271
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Track SPI state for in-flight SPIs

This commit adds tracking for GICv5 SPI state to trigger deactivation
notifiers when SPIs are consumed by the guest. It synchronizes guest
PPI and SPI states back to KVM's shadow state during vCPU exits.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index ffb0500a4c9a7..20ae7daf4c451 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -1056,6 +1056,63 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
> +void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_dist *vgic_dist =3D &vcpu->kvm->arch.vgic;
> +	struct vgic_irq *irq;
> +
> +	/* Sync back the guest PPI state to the KVM shadow state */
> +	vgic_v5_fold_ppi_state(vcpu);
> +
> +	/*
> +	 * For SPIs, which are on the global AP list, we synchronise their state
> +	 * with the hardware state. If they have been deactivated, immediately
> +	 * pop them off the list. The notifier is called without the SPI AP list
> +	 * lock held to avoid deadlocks.
> +	 */
> +retry:
> +	raw_spin_lock(&vgic_dist->vgic_v5_spi_ap_list_lock);

[Severity: High]
The commit message states "When no SPIs are in flight, no SPI state is
queried", but does this code unconditionally acquire the global
vgic_v5_spi_ap_list_lock on every vCPU exit even if the list is empty?

Could this introduce cacheline bouncing and global lock contention
across all vCPUs during normal VM operation?

> +	list_for_each_entry(irq, &vgic_dist->vgic_v5_spi_ap_list_head, ap_list)=
 {
> +		bool pending;
> +		u32 intid;
> +		u64 icsr;
> +
> +		raw_spin_lock(&irq->irq_lock);
> +
> +		icsr =3D kvm_call_hyp_ret(__vgic_v5_vdrcfg, irq->intid);
> +
> +		irq->active =3D !!FIELD_GET(ICC_ICSR_EL1_Active, icsr);
> +		pending =3D !!FIELD_GET(ICC_ICSR_EL1_Pending, icsr);
> +
> +		if (irq->config =3D=3D VGIC_CONFIG_EDGE)
> +			irq->pending_latch =3D pending;
> +
> +		if (irq->config =3D=3D VGIC_CONFIG_LEVEL && !(pending || irq->active))
> +			irq->pending_latch =3D false;
> +
> +		/* Deactivated? */
> +		if (!irq->active && !pending && !irq_is_pending(irq)) {

[Severity: High]
Will this condition permanently block level-triggered SPIs from firing the
ack notifier?

For a level-triggered irqfd, irq_is_pending(irq) checks irq->line_level,
which stays high until the resampler runs. If kvm_notify_acked_irq() is
gated by this check, the resampler will never run to clear the software
line level, locking up the interrupt after its first injection.

> +			/* Use raw SPI index without type for the GSI */
> +			intid =3D FIELD_GET(GICV5_HWIRQ_ID, irq->intid);
> +
> +			/* And we're done with this SPI */
> +			list_del(&irq->ap_list);
> +			irq->vcpu =3D NULL;
> +
> +			raw_spin_unlock(&irq->irq_lock);
> +			raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
> +
> +			kvm_notify_acked_irq(vcpu->kvm, 0, intid);
> +			vgic_put_irq(vcpu->kvm, irq);
> +
> +			goto retry;

[Severity: High]
Does this goto retry result in an O(N^2) loop?

Whenever an SPI is deleted, the loop restarts from the head of
vgic_v5_spi_ap_list_head. This forces the code to re-evaluate all
previously visited SPIs using the __vgic_v5_vdrcfg hypercall
while holding the global list lock, which might heavily penalize=20
performance when multiple SPIs deactivate simultaneously.

> +		}
> +
> +		raw_spin_unlock(&irq->irq_lock);
> +	}
> +	raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D27
