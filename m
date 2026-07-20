Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E776431D372
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 19:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784574199; cv=none; b=uty7mg9qIUyY/Vkw0LuzH9luf5cyNUSpvnRZDMmUtu/looeWmzhlyJH9ZjgeGhiPW+CIGV5sgDQKNYHuM50hC8gFHhvoV4wcXSpu4X9a/bW0MGB0FaKjQV0qVOjKnPDeZ+4YiDW6V2OKjlExQGDc9g34Gu9p6pY9Kn9cFlWIoFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784574199; c=relaxed/simple;
	bh=QYr4nVhM+IlGF4bQ7cAwdrajmGcDEXSKZExy1eOgkSE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CEIkIHN1Q1wkxnF4bqCPd+wBM3+2DQFQSZQloufqwKQyzQm9pq2dqykE7Q3Oi8TfJaU7UDPwSiE1N9s2hVbR8DyLZ+gLQr1VDojoE2utf/tA8uLQJmepbR07Q58PdHNrXRguumyYxrOtG/nc3sFhwkDyfx3PDeQ/+4fhhFZycio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GsDtPqzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GsDtPqzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC8C1F00A3A;
	Mon, 20 Jul 2026 19:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784574197;
	bh=Qq8fsJGy+gdWa8AMKzkKkajMNeqLeG4AeUJtQuWQeXM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GsDtPqzA4YXxoimTxUH4zZ9Y9DjD7LYupD1c/0TYcCIiQqmkMRmYT2evOShcn9skL
	 GHcqJYWIct09URx+jYPeFdDNqNmgF+qTOQGUfajz7iNyjfX0qrW5qkxnA9726J2bv+
	 fWZpxttMNCDrNnP2DAyoPPrHxNFHfgWTyw/KpeJ/ZLUUrCanu3EDbsBSf9JNoFFMyP
	 XSPL1ujtyhygAh3aToqQIIfIIqRmOhuUxxVzeZeXTWzmXD6A3PQbQUWZ0qhS9DzknD
	 O2MWSJFfn6a/VXIu4hUFEd/9fol67SNvjrByMvb384c6KXHfXoG4nxRtD0FjMIdQEu
	 M6bFGQAO9m99Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Stop the hyp trace clock worker on disable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260720184850.1826630-1-fuad.tabba@linux.dev>
References: <20260720184850.1826630-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 19:03:16 +0000
Message-Id: <20260720190317.6AC8C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use of uninitialized stack memory due to missing snap.valid check
- [High] Kernel panics due to multiple missing zero-checks in clock math
- [Medium] Resource leak if hypercall fails in hyp_trace_enable_tracing
- [Medium] Repeated initialization of delayed_work and completion objects
--

--- Patch [1]: [PATCH] KVM: arm64: Stop the hyp trace clock worker on disab=
le ---
commit 036d5fc621f0803d25d344f6b28a01f0246f7e82
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Stop the hyp trace clock worker on disable

When disabling, hyp_trace_clock_enable() cancels the clock work but then
falls through into the enable path, which re-schedules it and marks the
clock running again, so the worker never stops. Return once the work is
cancelled.

Fixes: b22888917fa41 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260720172923.E4F161F000E9@smtp.kernel=
.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 2411b4c32932c..27367843fd211 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -116,6 +116,7 @@ static void hyp_trace_clock_enable(struct hyp_trace_c=
lock *hyp_clock, bool enabl
>  	if (!enable) {
>  		cancel_delayed_work_sync(&hyp_clock->work);
>  		hyp_clock->running =3D false;
> +		return;
>  	}
> =20
>  	ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);

[Severity: High]
This is a pre-existing issue, but the snapshot is read without checking if
it is valid.

If timekeeping is suspended, ktime_get_snapshot_id() sets valid =3D false
and returns without initializing systime or cycles.

Does this mean the kernel will consume uninitialized stack memory when
accessing snap.systime and snap.cycles immediately after?

[Severity: Medium]
This is a pre-existing issue, but later in hyp_trace_clock_enable(),
these initialization macros are called unconditionally:

    init_completion(&hyp_clock->ready);
    INIT_DELAYED_WORK(&hyp_clock->work, __hyp_clock_work);

Since these are called on a static global object on every enable cycle,
does this violate the requirement to initialize such objects only once,
potentially causing lockdep warnings or memory leaks?

[Severity: High]
This is a pre-existing issue, but there are multiple divisions in
__hyp_clock_work() that do not check for zero:

    ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
    boot =3D ktime_to_ns(snap.systime);
    ...
    rate =3D div64_u64(delta_cycles * NSEC_PER_SEC, delta_boot);
   =20
    clocks_calc_mult_shift(&hyp_clock->mult, &hyp_clock->shift,
                           rate, NSEC_PER_SEC, CLOCK_MAX_CONVERSION_S);
                          =20
    /* Add a comfortable 50% margin */
    hyp_clock->cyc_overflow64 =3D (U64_MAX / hyp_clock->mult) >> 1;

First, as mentioned above, if ktime_get_snapshot_id() fails, the worker
consumes the snapshot without checking validity.

If delta_boot becomes 0 (for example, from uninitialized stack memory, or
time failing to advance), will div64_u64() panic?

Similarly, if delta_cycles is 0, rate becomes 0, which would cause
clocks_calc_mult_shift() to execute a divide by zero. And if
hyp_clock->mult becomes 0, the cyc_overflow64 calculation will panic.
Could we add zero-checks here?

[Severity: Medium]
This is a pre-existing issue, but there might be a resource leak in
hyp_trace_enable_tracing() if the hypercall fails:

    hyp_trace_clock_enable(&hyp_clock, enable);

    return kvm_call_hyp_nvhe(__tracing_enable, enable);

The clock worker is started before the hypercall. If
kvm_call_hyp_nvhe() fails when enabling tracing, the error is returned to
the caller but the previously started delayed work is not stopped.

Does this mean the worker will continuously reschedule itself and leak CPU
cycles since the error path does not clean it up?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720184850.1826=
630-1-fuad.tabba@linux.dev?part=3D1
