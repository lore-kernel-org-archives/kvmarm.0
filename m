Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BFE305E10;
	Fri,  3 Jul 2026 16:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096529; cv=none; b=K5fYdg6OCVQZBvLr3uwbMYjmeFerM+8CMRPPHP6+hfBL0gWoHu1XnHlywkQVNnrJpkURUPpIa0dSTyuscJjitsrOSbGJAHftP7+BY/pBFoZzE3cVSjosC+KSfpjneQ4JviZkmt9S6vJErjCsEGDw9p0TTJcsmpMpZ50heSAWzwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096529; c=relaxed/simple;
	bh=yi+DLSnmT+mi/82GwLFvpebN0mC1/a2IuGqpJhaiIlU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xc7sveh+GPDMxSXaRUCyvYBBa1gvIP4kJNdLBlDcqzULmLxIyM9ITV5v5lAo8yzpfATSdwRgKbXzkQB79BmNIEbIbTrHSBym8s7CX38Ymt6CT7kuSjGDJCnLrZ5cFm7Czmb7oKcLkaJAq15IDdcxl+KrLZcbEtalVB5CydCttck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbNk6fqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbNk6fqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C871F000E9;
	Fri,  3 Jul 2026 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096527;
	bh=IhVi9BRJTTUVMGvhFSIJv1u/AlHjo6mFZNe/aNx8C+I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hbNk6fqit9bW3ddPussy/ARGVE4vK7ShWv2z+miLeCV6hvbKZF/lJeP795j+v4v04
	 HkGni1w7rJeuOJYvuYj3jOe7gntRAOiJWmZkyer3xWNNi4vNEC5lM+oSg8/tdCZNmo
	 VCstXCGXRCJpU0X09LjDnMga6PSNrCrLDaJBVpOCJpVM0d+1NlLwmsProyTZA/Guu/
	 YxZRP0yCivckg/0YyCmCiO01sJ25E9UKJK+/Jza/34b057V2bgaaLRK6Xb3Q6jiTLC
	 m/J9xQSyAs/sLkpJWkazhRF3k1WCQttpfN6AJyEiGZWMQfwlHAiKBzRE1fArXCs86x
	 tyUiyWZoIC+Gg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 16/40] KVM: arm64: gic-v5: Request doorbells when
 VPEs enter WFI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260703154811.3355680-17-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-17-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:35:27 +0000
Message-Id: <20260703163527.76C871F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Use of `WARN_ON()` wrapping the fallible `irq_set_affinity()` API =
on a guest-driven WFI path allows a malicious guest to trigger a host denia=
l of service.
- [High] Off-by-one error when computing the Doorbell Priority Mask (DBPM) =
causes the hardware to miss doorbell signals for valid pending interrupts.
--

commit a810e1cc5f94c1f25b127b180419f6917b92c803
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI

This commit adds support for requesting GICv5 VPE doorbells when a vCPU
enters WFI and the VPE becomes non-resident. It sets the doorbell priority
mask to avoid unnecessary wakeups. It also routes the doorbell interrupt to
the current CPU and updates the pending check to observe the doorbell
fired state.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 9c383b6864270..6e976162ec3c2 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1094,6 +1094,46 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
>  	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
> =20
>  	cpu_if->vgic_contextr =3D 0;
> +	if (vcpu_get_flag(vcpu, IN_WFI)) {
> +		u32 priority_mask;
> +		int dbpm;
> +
> +		/*
> +		 * Find the virtual running priority and use this to calculate
> +		 * the doorbell priority mask. We combine the highest active
> +		 * priority and the CPU's priority mask. The guest can't handle
> +		 * interrupts with priorities less than or equal to the virtual
> +		 * running priority, so there's literally no point in waking the
> +		 * guest for these.
> +		 *
> +		 * The priority needs to be higher than the mask to signal, so
> +		 * pick the next higher priority (subtract 1).
> +		 */
> +		priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
> +
> +		/*
> +		 * Request a doorbell *unless* the priority is 0, indicating
> +		 * that no interrupt can wake the CPU up.
> +		 */
> +		if (priority_mask) {
> +			int db_irq =3D vgic_v5_vpe_db(vcpu);
> +			struct irq_data *d =3D irq_get_irq_data(db_irq);
> +			const struct cpumask *aff =3D irq_data_get_effective_affinity_mask(d);
> +			int cpu =3D smp_processor_id();
> +
> +			dbpm =3D priority_mask - 1;
> +			cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_DB, 1) |
> +						FIELD_PREP(ICH_CONTEXTR_EL2_DBPM, dbpm);

[Severity: High]
Does this subtraction configure the mask too strictly? Since the hardware
already evaluates using a strictly-less-than check (Priority < DBPM), would
setting it to priority_mask - 1 cause the hardware to miss doorbell signals
for interrupts arriving at the lowest unmasked priority level?

> +
> +			/*
> +			 * Make the doorbell affine to this CPU, if it isn't
> +			 * already. Actively check the cpumask first as it is
> +			 * cheaper than changing the affinity every time.
> +			 */
> +			if (!cpumask_test_cpu(cpu, aff))
> +				WARN_ON(irq_set_affinity(db_irq, cpumask_of(cpu)));

[Severity: High]
Should we handle the failure of irq_set_affinity() here without using a
WARN_ON()?

Because this is a fallible API and the WFI path is driven directly by the
guest, a malicious guest could execute WFI in a tight loop to trigger this
warning continuously. This could lead to a host denial of service either
through severe log spam or a panic if panic_on_warn is enabled.

> +		}
> +	}
> =20
>  	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D16
