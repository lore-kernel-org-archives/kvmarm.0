Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0137F379C2A
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 19:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786563212; cv=none; b=TCGntQT6UUUz9G48jxOEo5zUwBCE4AeYYFrIA/tstbL1U1mDc8dplBSR8MKiedfXizN+mmKR9o4o5raGTXng6gg2vLI2wl891CUq/7oJ144Yj86ThYsB/ww90rc8WdObBmdSQXWCpGCx5g3E0DlQu5BWmIZd7uRCqQDqhsBO2yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786563212; c=relaxed/simple;
	bh=5d9t/9xRwxNYE4UPY3s3mpOSX28NwlrZvzH4wdf2Iio=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nj06V7Net/5nEdQryh7U06wAdFejlEU6gNKAmQccnS1Eqgauu8Je/9GUfgJ37l1mUHuvTBcRghq1gfezSDDDzlCd4WvSkomzIRY7Nguy1fA7giCKMPiilEFVoM0/S5BmsTlTry9+ARUy2rrCaJtrpHrzByNcHN5BtaroHpLMHsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpCOJY/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpCOJY/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CB31F000E9;
	Wed, 12 Aug 2026 19:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786563210;
	bh=jMSRT4EvpIpdYQnVNmlaFXCTBJnmwLqpaXYAHohAb4s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TpCOJY/srjgiEtj+lk2ZR3szR7pV6x8dUtcOA8u8490fHXQmWpflD4efk4X4+qHAu
	 1+vZLfOxLBob2vj276gdWVWRLJ64OyS45XwcSlBOV9Rl0ZkFe8Fq9aD/CEHOR4Noql
	 yPY9yPGlxQP7rNp6wR+aPxEoH1BZEWBEabyI1UfYykH3NHxDRV9FODuKwj2YmCygCh
	 lS3226U7KjqoG+X/E4sLb8doFRA/6Codb9wGsRcL0n2dhLShYHQexDsAHKwo3OHcye
	 bSXwcI+5x4AzVU9a9E5GS0WsLKNkXKe2mRhSLuHqAZd8HVKmUiSTKGH2/jb9SBj4sq
	 V0F98jdLJogPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering
 an exception
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-5-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-5-9105afd828ac@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 19:33:29 +0000
Message-Id: <20260812193330.51CB31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] `compute_exlock()` uses `is_hyp_ctxt(vcpu)` to select between `G=
CSCR_EL1` and `GCSCR_EL2`, which evaluates the current execution context ra=
ther than the explicit target exception level.
--

--- Patch [5]: [PATCH v19 05/14] KVM: arm64: Set PSTATE.EXLOCK when enterin=
g an exception ---
commit 0b3b4f11382cdcd92d8ee1a1c35e2013e9df99ba
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Set PSTATE.EXLOCK when entering an exception

This commit implements the management of PSTATE.EXLOCK when entering an
exception in KVM's AArch64 exception injection path. When taking an excepti=
on
to the same EL, EXLOCK is set to the value of GCSCR_ELx.EXLOCKEN.

> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exceptio=
n.c
> index bef40ddb16dbc..15b00e0ee1ec7 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
[ ... ]
> @@ -65,6 +65,38 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcp=
u, u64 val)
>  		vcpu->arch.ctxt.spsr_und =3D val;
>  }
> =20
> +static unsigned long compute_exlock(struct kvm_vcpu *vcpu,
> +				    unsigned long mode,
> +				    unsigned long target_mode)
> +{
> +	u64 gcscr;
> +
> +	if (!kvm_has_gcs(kern_hyp_va(vcpu->kvm)))
> +		return 0;
> +
> +	/* GCS can't be enabled for 32 bit */
> +	if (mode & PSR_MODE32_BIT)
> +		return 0;
> +
> +	/* When taking an exception to a higher EL EXLOCK is cleared. */
> +	if ((mode | PSR_MODE_THREAD_BIT) !=3D target_mode)
> +		return 0;
> +
> +	/*
> +	 * When taking an exception to the same EL EXLOCK is set to
> +	 * the effective value of GCSR_ELx.EXLOCKEN.
> +	 */
> +	if (is_hyp_ctxt(vcpu))
> +		gcscr =3D __vcpu_read_sys_reg(vcpu, GCSCR_EL2);
> +	else
> +		gcscr =3D __vcpu_read_sys_reg(vcpu, GCSCR_EL1);

[Severity: Medium]
Does this code read the correct GCSCR_ELx register if the target exception
level differs from the current hypervisor context?

By using is_hyp_ctxt(vcpu), this evaluates the current execution context
(for example, if HCR_EL2.TGE is set) rather than relying on target_mode. In
enter_exception64(), the target mode is explicitly used to select the
correct registers:

	switch (target_mode) {
	case PSR_MODE_EL1h:
		vbar =3D __vcpu_read_sys_reg(vcpu, VBAR_EL1);
		sctlr =3D __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
		...

If KVM injects an exception to EL1 (where target_mode =3D=3D PSR_MODE_EL1h)
while is_hyp_ctxt(vcpu) evaluates to true, compute_exlock() would
incorrectly read GCSCR_EL2 instead of GCSCR_EL1.

Should this logic be updated to use target_mode =3D=3D PSR_MODE_EL2h instea=
d of
is_hyp_ctxt(vcpu) to ensure consistency with the rest of the exception
injection path?

> +
> +	if (gcscr & GCSCR_ELx_EXLOCKEN)
> +		return PSR_EXLOCK_BIT;
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812-arm64-gcs-=
v19-0-9105afd828ac@kernel.org?part=3D5
