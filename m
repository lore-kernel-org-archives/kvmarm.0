Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9EA4E2F25;
	Thu, 24 Sep 2026 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271892; cv=none; b=e70f/9LRoVy6BIMI97V2n+n80xUUlevKn9PYddW7pp/doEv3jfLj7H9Z108vm3JLlW9e3CHvY+qu32rHu2Ev+0K4/+7a5KN7CvYQvexAFSOIFomnd+ixExeWf74MokINM499AP39euxe3y2m8PM1VjP1SXUEy4BLun7J+lpWId0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271892; c=relaxed/simple;
	bh=R+t7SzU6EpWbvPLxzKN/KewFgHYoqgLkKNdXYCdezrQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GBzIp4uf16eTQ/RYUdhB6rb1trXWi+9m55ls/y/VAMMuoJaRHlIr0VK4jgPA4PqTGbRRNo6u+NY/m207IJtz6TAdgZEHueAAeEfHyWeWIluNmTWC+G11SOTXkEbjvCZBDNIn/kAcijIaxiZfwAkx7srOJWHoX6fiCMF+Nl5HsHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvvK7x0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvvK7x0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C661F0089C;
	Thu, 24 Sep 2026 17:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271890;
	bh=qKlYpDZvrG+7/A9FnSu2CoclXWVtbHX4dEJvyEYBOSY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IvvK7x0IjLept1D2FKiU7V+jRT/xNQKHmgQnMmdtITAfSX3guhhz5cz3GlGXqmX2i
	 Sr7T5oZ9xRc1MoRXyxfHcTblWNrtf6qXpopnB63kY4W47GUfKZafVXdZfVi5Hc/rco
	 PgFHsPa2yXF6BJvwMZWfKlP1iOPOficmGNCwDTBh0qLPCv0Aq++keZpHCOQPNm7BUQ
	 bImb/kS7Aj7SIEVaMH/EEIDtDlwiNDqJTer8Bv0Dp8nsSy8BzLFbvGUUmkdOHrW7N8
	 i/dKN7wHHKUTOLqsdYiz36/LxrjzN9sBj6kwpg8qiCg6/byJY8kEzvm+gaIBM03shB
	 Y6ZYwKKeZW8Ew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 05/22] perf: arm_pmuv3: Move counter allocation mask
 to per-CPU struct pmu_hw_events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260924172928.2110956-6-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-6-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:44:49 +0000
Message-Id: <20260924174449.B3C661F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] perf: arm_pmuv3: info leak of KVM guest counters to host userspace
- [Low] perf: arm_pmu: incomplete migration to per-CPU cntr_mask in cpu_pm_=
pmu_setup()
--

commit 44148c2c0e2e2ea859f2a156493d6c82c8cca8a9
Author: Colton Lewis <coltonlewis@google.com>

perf: arm_pmuv3: Move counter allocation mask to per-CPU struct pmu_hw_even=
ts

This commit introduces a per-CPU counter allocation mask (`cntr_mask`) to
prepare for dynamic PMU partitioning with KVM. It initializes the per-CPU
mask from the global mask and updates the allocation functions to use it.

> diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
> index 1150695653892..344adcd3521d0 100644
> --- a/drivers/perf/arm_pmu.c
> +++ b/drivers/perf/arm_pmu.c
[ ... ]
> @@ -717,6 +719,7 @@ bool arm_pmu_irq_is_nmi(void)
>  static int arm_perf_starting_cpu(unsigned int cpu, struct hlist_node *no=
de)
>  {
>  	struct arm_pmu *pmu =3D hlist_entry_safe(node, struct arm_pmu, node);
> +	struct pmu_hw_events *cpuc =3D per_cpu_ptr(pmu->hw_events, cpu);
>  	int irq;
> =20
>  	if (!cpumask_test_cpu(cpu, &pmu->supported_cpus))
> @@ -724,6 +727,8 @@ static int arm_perf_starting_cpu(unsigned int cpu, st=
ruct hlist_node *node)
>  	if (pmu->reset)
>  		pmu->reset(pmu);
> =20
> +	bitmap_copy(cpuc->cntr_mask, pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
> +
>  	irq =3D armpmu_get_cpu_irq(pmu, cpu);
>  	if (irq)
>  		per_cpu(cpu_irq_ops, cpu)->enable_pmuirq(irq);

[Severity: Low]
Is there a missing update to cpu_pm_pmu_setup() in this file?

Looking at cpu_pm_pmu_setup(), it continues to use the global mask rather
than the newly introduced per-CPU mask:

drivers/perf/arm_pmu.c:cpu_pm_pmu_setup() {
    ...
	for_each_set_bit(idx, armpmu->cntr_mask, ARMPMU_MAX_HWEVENTS) {
		event =3D hw_events->events[idx];
		if (!event)
			continue;
    ...
}

While hw_events->events[idx] safely evaluates to NULL for counters
partitioned to KVM, should this loop be updated to iterate over
hw_events->cntr_mask for consistency with the new per-CPU abstractions
introduced here?

> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 4a6c1f3bcea1f..49289e5993dd7 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
[ ... ]
> @@ -813,7 +813,7 @@ static void armv8pmu_enable_user_access(struct arm_pm=
u *cpu_pmu)
>  		write_pmuacr(mask);
>  	} else {
>  		/* Clear any unused counters to avoid leaking their contents */
> -		for_each_andnot_bit(i, cpu_pmu->cntr_mask, cpuc->used_mask,
> +		for_each_andnot_bit(i, cpuc->cntr_mask, cpuc->used_mask,
>  				    ARMPMU_MAX_HWEVENTS) {
>  			if (i =3D=3D ARMV8_PMU_CYCLE_IDX)
>  				write_pmccntr(0);

[Severity: High]
Does this change create an information leak across VM boundaries?

On pre-v3.9 hardware, armv8pmu_enable_user_access() enables EL0 counter
access globally. It clears unused counters to prevent leaking kernel state.
However, by changing the loop to iterate over the per-CPU cpuc->cntr_mask
instead of the global cpu_pmu->cntr_mask, counters reserved for KVM (which
are dynamically removed from cpuc->cntr_mask) will be skipped.

Since KVM does not zero hardware counters on vcpu_put, won't this allow
unprivileged host userspace to read the leftover guest counter values?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D5
