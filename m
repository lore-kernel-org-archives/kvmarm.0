Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E31B381E91
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 23:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800034; cv=none; b=dlpZ0Ku6cJYPMPzaN4JR8PzoUMtllFoRUzRfcJO9aLoOkPdId9n+mcO0xfXRqIz+hh8ZR9dgJVx7UhaIUQiQBbQwwRSoZWJCaaaELKzv9HcAzK023NeIFOUuoXC5VNc4CM0L759bqJ2w7/NeskBWaZawH6E2fLezBDfUSCuXhxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800034; c=relaxed/simple;
	bh=8mXNh2kdvmMPap2Hlyhq5I8UDoOd0C0iF8e8FXzWtI4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uNL4UWL7Jp5LZHXMJE7q+k+6fOSuJVh+OpmktQ2wnhkaRHdMfgp98Wn7aICfHXGDSqR/ZjEKt+3Una+9l1nl7pq2JOKlPPMJZG3xv2KZ+VJAs18mx8ZTTZybsTBoEnUSXCRHyLwzoGmTOqUt3CnM0Kk5+IRRZ6lEZ7LNVLD9CDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYldAAIq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYldAAIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C36B1F000E9;
	Mon,  3 Aug 2026 23:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785800032;
	bh=tXFEeqHBvrO8VExh8n+q0HYZ+lkxfhF7nkER5MPibUA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nYldAAIq0KQAOTFhjvOP7a1ZPw9tvtNispso4lczhMieHbCtbR+/lQ110LyTgF3ia
	 GYsK3xyaFWgCSPG+PlAnOuk8GLCov3vhxobMXLyXeALb/js8elYD37NjaUNdikb8/g
	 nJJoELzrmmmNMWvV56GPqcrx7dnwESBiE2j80mRdruLzOQ3o+8GFdqTe/eR/cwy75Y
	 E0r/G17AccBciA1SnJqCVX6D92XNjQxhXAg1sF4g0h4wxYrZ5Ahlu7BH6XOSmag1ln
	 Ts+g3bHKuAPxGDOfOmet9vHRMbgK5JZnU23VZLIpEHrw7P0rrn2evB9MDy5qvwHmUt
	 r2NOyYy/eWwtg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 04/14] KVM: arm64: Ensure GCS memory effects are
 visible
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-4-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
 <20260803-arm64-gcs-v18-4-fd8c40f5ad88@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 23:33:51 +0000
Message-Id: <20260803233352.6C36B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Coherency bug and asynchronous memory corruption risk in VHE mode =
due to delayed `gcsb_dsync()`.
- [High] Logical ordering and missing synchronization (ISB) violation when =
executing `gcsb_dsync()` in VHE exit path.
- [Medium] Incorrect memory barrier ordering around `gcsb_dsync()` on guest=
 exit/load paths leaves normal memory accesses unsynchronized.
--

--- Patch [4]: [PATCH v18 04/14] KVM: arm64: Ensure GCS memory effects are =
visible ---
commit 1407ce4bfae0ac123f8195fde84320f01f5496bb
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Ensure GCS memory effects are visible

This commit inserts explicit GCSB DSYNC barriers during vCPU state
loading and saving to ensure GCS memory effects are visible. This is
required because the hypervisor cannot rely on implicit barriers in
vCPU context switches.

> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/s=
witch.c
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c

[ ... ]

> @@ -345,6 +351,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 */
>  	dsb(nsh);
> =20
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere.
> +	 */
> +	if (ctxt_has_gcs(guest_ctxt))
> +		gcsb_dsync();

[Severity: Medium]
Does this sequence require a DSB after the GCSB DSYNC instruction?

To guarantee that GCS memory effects are globally visible before subsequent
operations like page table unmapping, a DSB is typically required after
the GCSB DSYNC. In __kvm_vcpu_run(), the DSB occurs before it.

> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/=
sysreg-sr.c
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -239,6 +239,13 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcp=
u)
>  	if (vcpu_has_nv(vcpu))
>  		dsb(nsh);
> =20
> +	/*
> +	 * Ensure any GCS memory effects are visible to the incoming
> +	 * vCPU.
> +	 */
> +	if (ctxt_has_gcs(guest_ctxt))
> +		gcsb_dsync();

[Severity: Medium]
Is another DSB needed here as well?

Similar to the nVHE path, a DSB after the GCSB DSYNC is needed to ensure
memory effects are globally visible. Also, the preceding dsb(nsh) is
conditionally skipped if the vCPU does not have nested virtualization enabl=
ed,
which might leave this barrier in __vcpu_load_switch_sysregs() without
preceding protection.

[ ... ]

> @@ -299,5 +306,12 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
>  	/* Restore host user state */
>  	__sysreg_restore_user_state(host_ctxt);
> =20
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere.
> +	 */
> +	if (ctxt_has_gcs(guest_ctxt))
> +		gcsb_dsync();

[Severity: High]
Could placing this barrier in the lazy vcpu_put() path cause stale memory
reads in the host kernel?

In VHE mode, __vcpu_put_switch_sysregs() executes lazily during vcpu_put().
The host kernel will begin processing guest exits (hypercalls, page faults)
while the vCPU is still loaded. This leaves the CPU's GCS cache with dirty,
unwritten guest data while the host might attempt normal memory reads on th=
at
same memory.=20

Does this need to be in the immediate exit path instead?

[Severity: High]
Does this execute the barrier under the wrong GCS context and an undefined
pipeline state?

This gcsb_dsync() happens after __sysreg_restore_user_state(host_ctxt).
Restoring the host user state overwrites SYS_GCSCRE0_EL1 without a subseque=
nt
ISB, violating system register synchronization rules and leaving the pipeli=
ne
architecturally undefined when the branch and GCSB DSYNC execute.

Additionally, flushing after tearing down the guest's GCS configuration mea=
ns
the flush occurs under the host's context.=20

Should gcsb_dsync() execute before restoring the host state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803-arm64-gcs-=
v18-0-fd8c40f5ad88@kernel.org?part=3D4
