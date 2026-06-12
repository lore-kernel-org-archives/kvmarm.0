Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04772EFDAF;
	Fri, 12 Jun 2026 19:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293826; cv=none; b=tpJViWnSG0DxK2hdCTIKftKTqoBsSsLDXD5EW1dSJi7hBhyNyqiJRM2td+twKSMiuJt4ovoV98W7pSK4dgsZxrI3iC9+vUIPzRZ0+vUtngED0Nl+c5wpBAVuVBpX1o2w238tYr4UBenVcqmRJ/P5RRGRo2h1BZQ9P9FNqxJ0M5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293826; c=relaxed/simple;
	bh=sJqzWKaXVyY2zInxFX1qj67f+VGazCN72KH4o4NzY8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W+PgF/yCsFkiV3Hv9Rrl0ZH3Q9bWnKR8/faSps4Cr9DuN2Vb7Cx+lp41QYlbdFRl+2voDmtFLSlka+/GenuN2pYzVXrPFtdDqAVq9e5R2HQdN1KQecFDGHlhNE9KbWw/V2NOKJF9nRbCOlqTSYtgFfg30+Up5f7Ai1cMvTcb6zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eJpcG+EE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eJpcG+EE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB8D1F000E9;
	Fri, 12 Jun 2026 19:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781293825;
	bh=bDSkpjE/19RNXTBxmKZoNJ2esJXCUuQO/L3yYWswiM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eJpcG+EEBvFlwUOlCHarKTl+6t5Dfok6V/69FxLJVd92ajC+tWPfcBOl7c2FrC4YO
	 agYtEA/IQMLbUkmfugUiQnaLBp6efuJVIy54jw9CK3uSv2J/sxwuE2we49GAn4mX8v
	 mgX5gAyz89klj5lz0kEmAcFobzIg7+7H9+RwdWBjAJYVtkWCU4s1XcGxhYAbxjebei
	 4TCRXW0EF6AsYBKIU/yLiXD7DapG610Synh/nFqYNVa1Q9vmUUIZkZIlOzETJPxzjU
	 U79+Q3qVaTbPOO1vdDe3ZRMLns6zdWb4LAEIFgwxR2YKWaOIdBN4mr1C2BsYjaHiMw
	 /lvg4eXg+PZsA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/21] KVM: arm64: Apply dynamic guest counter
 reservations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260612192909.1153907-15-coltonlewis@google.com>
References: <20260612192909.1153907-15-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:50:24 +0000
Message-Id: <20260612195025.1EB8D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Data race and state corruption of the global `arm_pmu->cntr_ma=
sk` when dynamically reserving guest PMU counters.
- [High] Lockless access to `cpuc->events[idx]` in `kvm_pmu_set_guest_count=
ers()` can cause a NULL pointer dereference (kernel oops) if interrupted by=
 a concurrent perf IPI.
--

commit 4f21c28ed6e1adfadba5b0251c4089bb44f7b7b3
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Apply dynamic guest counter reservations

Apply dynamic guest counter reservations by checking if the requested
guest mask collides with any events the host has scheduled and calling
pmu_perf_resched_update() with a hook that updates the mask of
available counters in between schedule out and schedule in.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 49f1feb5d280c..044f011c9c84b 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -87,6 +87,73 @@ u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
>  		ARMV8_PMU_PMCR_N);
>  }
> =20
> +/* Callback to update counter mask between perf scheduling */
> +static void kvm_pmu_update_mask(struct pmu *pmu, void *data)
> +{
> +	struct arm_pmu *arm_pmu =3D to_arm_pmu(pmu);
> +	unsigned long *new_mask =3D data;
> +
> +	bitmap_copy(arm_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);

[Severity: Critical]
Does this locklessly overwrite the shared arm_pmu->cntr_mask?

Since struct arm_pmu and its cntr_mask are shared across all CPUs in a PMU
cluster, altering it dynamically from a per-CPU context without cross-CPU
locking can cause torn writes and clobber reservations for other CPUs shari=
ng
the PMU.

> +}
> +
> +/**
> + * kvm_pmu_set_guest_counters() - Handle dynamic counter reservations
> + * @cpu_pmu: struct arm_pmu to potentially modify
> + * @guest_mask: new guest mask for the pmu

[ ... ]

> +	if (guest_mask) {
> +		/* Subtract guest counters from available host mask */
> +		bitmap_andnot(new_mask, new_mask, guest_bitmap, ARMPMU_MAX_HWEVENTS);
> +
> +		/* Did we collide with an active host event? */
> +		if (bitmap_intersects(cpuc->used_mask, guest_bitmap, ARMPMU_MAX_HWEVEN=
TS)) {
> +			int idx;
> +
> +			need_resched =3D true;
> +			cpuc->host_squeezed =3D true;
> +
> +			/* Look for pinned events that are about to be preempted */
> +			for_each_set_bit(idx, guest_bitmap, ARMPMU_MAX_HWEVENTS) {
> +				if (test_bit(idx, cpuc->used_mask) && cpuc->events[idx] &&
> +				    cpuc->events[idx]->attr.pinned) {

[Severity: High]
Can this result in a NULL pointer dereference?

The function iterates over cpuc->events[idx] with preemption disabled but
local IRQs enabled. If a concurrent perf IPI interrupts KVM between the two
compiler-generated loads of cpuc->events[idx] and frees the event slot
(setting it to NULL), the subsequent dereference of ->attr.pinned will caus=
e a
fatal kernel oops.

Using READ_ONCE() for the load would ensure the compiler reads it only once.

> +					pr_warn_once("perf: Pinned host event squeezed out by KVM guest PMU=
 partition\n");
> +					break;
> +				}
> +			}
> +		}
> +	} else {

[ ... ]

> +	if (need_resched) {
> +		/* Collision: run full perf reschedule */
> +		perf_pmu_resched_update(&cpu_pmu->pmu, kvm_pmu_update_mask, new_mask);
> +	} else {
> +		/* Host was never using guest counters anyway */
> +		bitmap_copy(cpu_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);

[Severity: Critical]
Does this restoration also silently destroy active reservations for other
CPUs in the cluster?

When one CPU exits a guest (kvm_pmu_put()), this unconditionally restores
cntr_mask to hw_cntr_impl, which would remove any active PMU counter
reservations for guests concurrently running on other CPUs. This might allow
the host perf subsystem to allocate those guest-reserved counters, leading =
to
PMU register corruption and interrupt storms.

> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D14
