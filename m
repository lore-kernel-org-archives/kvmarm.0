Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A8237269C;
	Fri, 12 Jun 2026 19:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293356; cv=none; b=iJTdGd1HEskEm7+drnW1qmQolqCzTeAkqoFOItW9DRRg84JWosC/tuibm634l2uBo3UydxGI4iB6neKWYncX52CKvfEjIUrStQ5TABToc4DO+vyE04QuiZLuYc8jfQXq2pxZx0vnj9OClGA0seRkqh6M3QxjY1nywLrVzdxi/Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293356; c=relaxed/simple;
	bh=nRbLSM47Oz/MZuTyZSC8Udu+L32ai2E4NJpu2LRqt+E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z85HvyLsEKG6JWbco0O33FTwaMkvnf3V1e70ZhT9XVG+8rrKvkfhOyOYDnZos5+BkCB0rJN9TvhbhTYkz5KFzjTzg5rYuY9LXhi37udAUYuWFNkrUhDjXNnLBbU9i0cho2Pfs1+S/lN17XZqki0kd93d411OvMMqCff3xj67JlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVy87tUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVy87tUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5081F000E9;
	Fri, 12 Jun 2026 19:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781293355;
	bh=uD2A+PHodxqymkqefL8vL+Iwx4XbNYOdObAbfGszjDs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YVy87tUCe4EeHpc0E0EHcLtSYkURXCsFItJa52JAgD6jo8BGFxXSjeTDuaXafcE1C
	 hmcrUUEyeHyUqSRqGWvw3jQ+DRM/W/O3BEjrz3jnTeltFfVhk7YBELGCDwJVRa+1AO
	 XI7kX34PAoBkJqHJ9sO9tUzjQwyYjGnM2Wdq4gWo3pPTENY2SqBV7a1S6ugD3DrPfG
	 Ps6cB5kJxm6mbVRePx81wNa/4rcpXx5Oc8BWSvr9z+f8Y2OEyoquH4t4XiZtpc94RP
	 RYXscghxwxGNBZfcIlSbdJZbNC/KihksjEWVl5S9SYa/IkIRl2B7+9YFKRs4QY12Ch
	 pW06Ac+KQU5kw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/21] perf: arm_pmuv3: Check cntr_mask before using
 pmccntr
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260612192909.1153907-6-coltonlewis@google.com>
References: <20260612192909.1153907-6-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:42:34 +0000
Message-Id: <20260612194235.1E5081F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A 64-bit user-access CPU_CYCLES event can bypass hardware width va=
lidation and be incorrectly mapped to a 32-bit general-purpose counter if a=
rmv8pmu_can_use_pmccntr() returns false.
--

commit d0aacbccd4b0e735717836a5d526ad70a89f9f39
Author: Colton Lewis <coltonlewis@google.com>

perf: arm_pmuv3: Check cntr_mask before using pmccntr

Check cntr_mask before using pmccntr to ensure it's available. With a
partitioned PMU, there may be instances where pmccntr is being used by
the guest and will be absent from cntr_mask.

> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 1cceb1f614515..17bb1cfdc271c 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -1028,7 +1028,8 @@ static int armv8pmu_get_event_idx(struct pmu_hw_eve=
nts *cpuc,
> =20
>  	/* Always prefer to place a cycle counter into the cycle counter. */
>  	if (armv8pmu_can_use_pmccntr(cpuc, event)) {
> -		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
> +		if (test_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->cntr_mask) &&
> +		    !test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
>  			return ARMV8_PMU_CYCLE_IDX;
>  		else if (armv8pmu_event_is_64bit(event) &&
>  			   armv8pmu_event_want_user_access(event) &&

[Severity: High]
This isn't a bug introduced by this patch, but is it possible for a 64-bit
user-access CPU_CYCLES event to bypass hardware width validation here?

Because the -EAGAIN rejection logic is nested inside the=20
armv8pmu_can_use_pmccntr() check, if that function returns false (for examp=
le,
if threshold counting is enabled or the system has SMT), this validation is
entirely skipped.

It looks like the event would then fall through to armv8pmu_get_single_idx()
and potentially be allocated a 32-bit general-purpose counter. Userspace pe=
rf
tools reading the userpage pmc_width as 64 would then treat a 32-bit counter
as 64-bit, leading to unhandled wraparounds.

Looking at __armv8_pmuv3_map_event(), CPU_CYCLES events are explicitly
exempted from the 64-bit unsupported check:

__armv8_pmuv3_map_event()
        if (armv8pmu_event_is_64bit(event) &&
            (hw_event_id !=3D ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
            !armv8pmu_has_long_event(armpmu))
                return -EOPNOTSUPP;

Does this code incorrectly map 64-bit CPU_CYCLES events to 32-bit counters
when the dedicated 64-bit PMCCNTR is unavailable?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D5
