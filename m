Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49E842587B;
	Fri, 24 Jul 2026 11:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784893285; cv=none; b=AWzOIhmhy4Evtzul2oOqq+x8zJ9xHIu1L23LOT56xRTD9ugLqe9uXzFgudlCxBbfdnV/mMFZvF6w74I2fYLr1ZbEWTdh0UufNbirYP+RPa8/QJxz048VCCojAWhiKiyOO59NXS9z4B7ginXVHx5J6jbj6lVoA8t3OGsvOqkdVVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784893285; c=relaxed/simple;
	bh=8hjDFeciKTyP9qssE+xz39l7zwKLYhlYyEppoq1QKYE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G/9Ej1q2RZlnS+HzYGPRiloK0E96vBnzF4Wn4ACc8b14jwKBPQAvZr5n5LvsDfgfWJ+vBlGcDAUpnRo+GtfnyJKRaFXNub5vKqHM80jNje4waD3wS/pluERh5lpKGCbIyiBhuweIDkmxLU8gr2m/Hhr2yAY12F1p84l1QdU88S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k2LnP0ev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k2LnP0ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44D51F000E9;
	Fri, 24 Jul 2026 11:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784893272;
	bh=X7PSfCisyjnVL4iscriT4x24TnT9ldxwOj3yveQEkRI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k2LnP0evwJFgsushPFD+opmOeoRy6f4m1O5TnbQWnL322x6Du7/Q8y3TOPLAyD25g
	 hhcvDq82U77MTzuG27wtwbaz7lKonxkdT1eqAUEF+i80RiaigX/OKt3LcBRnFAAv4f
	 iKPGdreJqg1HxolABPzznJcCdcuDv1gazEOx9lHGFMtdA8MkD0U8y3QZxs0YTH4HLs
	 SIgF6n+BCefQgLdx4T2B7vGt6vLJbZH9p5YGwsoBUZEVSrbiu2jaoclbpS3yiIvISO
	 ayBkgc1b/dANO1CsbIGFFJxGl1Vo0F+3uFZAdJzogfEerTAxD+ekL6tCqdfsFjpurT
	 eYQ3CWV5nO49g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 16/48] KVM: arm64: gic-v5: Request doorbells when
 VPEs enter WFI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-17-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-17-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:41:11 +0000
Message-Id: <20260724114111.E44D51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Stale `db_fired` state causes an infinite loop bypassing WFI sleep=
, pegging the host CPU to 100%.
- [High] Incorrect GICv5 doorbell priority mask (DBPM) calculation drops pr=
eempting interrupts and vNMIs.
--

--- Patch [16]: [PATCH v4 16/48] KVM: arm64: gic-v5: Request doorbells when=
 VPEs enter WFI ---
commit 4c69e1e71f915cfc6ba78559fe449983dee20dd6
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI

This commit requests a GICv5 VPE doorbell when a vcpu enters WFI, allowing=
=20
KVM to be notified when an SPI or LPI becomes pending. It also calculates=20
a doorbell priority mask (DBPM) from the virtual priority state to avoid=20
waking the guest for masked interrupts.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> +		/*
> +		 * Request a doorbell *unless* the priority is 0, indicating
> +		 * that no interrupt can wake the CPU up.
> +		 */
> +		if (priority_mask) {

[Severity: High]
Does skipping the doorbell request when the priority is 0 break vNMI wakeup=
s?

Architectural semantics dictate that vNMIs have superpriority and must wake
a vCPU even when the running priority is 0.

> +			int db_irq =3D vgic_v5_vpe_db(vcpu);
> +			struct irq_data *d =3D irq_get_irq_data(db_irq);
> +			const struct cpumask *aff =3D irq_data_get_effective_affinity_mask(d);
> +			int cpu =3D smp_processor_id();
> +
> +			dbpm =3D priority_mask - 1;

[Severity: High]
Does subtracting 1 from the priority mask drop valid preempting interrupts?

The hardware doorbell condition triggers when the pending priority is less
than the threshold. If the highest active priority is 5, the vCPU should
be woken by any interrupt with a priority less than 5, for example, 4.

If the priority mask is 5, this code sets the DBPM to 4. The hardware
condition then becomes priority < 4. An interrupt with priority 4 will
not signal the doorbell, despite having a higher priority than the active
interrupt, causing missed wakeups and guest hangs.

> +			cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_DB, 1) |
> +						FIELD_PREP(ICH_CONTEXTR_EL2_DBPM, dbpm);
[ ... ]
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
[ ... ]
> @@ -1227,8 +1227,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcp=
u)
>  	unsigned long flags;
>  	struct vgic_vmcr vmcr;
> =20
> -	if (vgic_is_v5(vcpu->kvm))
> +	if (vgic_is_v5(vcpu->kvm)) {
> +		if (READ_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired))
> +			return true;

[Severity: High]
Can a stale db_fired state cause an infinite loop bypassing WFI sleep?

The db_fired flag is cleared only in __vgic_v5_make_non_resident(), which
executes during schedule-out.

If a doorbell fires, db_fired becomes true and the vCPU wakes up to enter
the guest. When the vCPU subsequently re-enters WFI without a schedule-out,
kvm_vcpu_block() evaluates kvm_vgic_vcpu_pending_irq(). Because db_fired
remains true, this instantly returns without sleeping.

This leaves the vCPU in an infinite loop returning from WFI and pegging
the host CPU at 100% until a host timer tick forces preemption.

> +
>  		return vgic_v5_has_pending_ppi(vcpu);
> +	}
> =20
>  	if (!vcpu->kvm->arch.vgic.enabled)
>  		return false;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D16
