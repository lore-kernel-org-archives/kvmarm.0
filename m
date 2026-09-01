Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDDD476CF0
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 22:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300965; cv=none; b=Wj4n8O6xRriJagC75h+zyOvwS+gX9JifXY+sWa5LFWQ6YzusZlaaozwGh9MaumZ/7Zcj6cp8M1gGvgPq//ySeFZmUwsgntoF5Je32Kml8aY/POBPcAGCKMD8gbjh6gKpdJqqsz6uYTy85tDrVwkXJ5THvHzqx70FszIe1ZZhZFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300965; c=relaxed/simple;
	bh=9EynaLbwidIWI2cvpy39P22jw4Du7nWf1EtrG6lCqi4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HyOcUxt4mZ5Frcmyszt0I5m8paxJh9Wr9HArrU/u7iw4b+IPPRoJCgVioKUFLR1ux5PfCW+aqtyQswASQgSw+c0x9Ax7x0sPslh3bNBJ9nwidHveQdnEJkRUq7NQcRYqFJ32uaMio3oii0sOMJwchR74hT6f1A5U5iQcTKvcL4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJcxCkfG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJcxCkfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDB21F000E9;
	Tue,  1 Sep 2026 22:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300961;
	bh=FEeQQ3SAK2FLJjEM5C2EXEe2N1CG7kFAR8iXgUVSiwo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EJcxCkfGK3XdwTEn4Y/ZUpqEW3tkWoN9qEucdzz6icDyhEDZ0vHPDUCg1yQs15fzj
	 O6kazDH8E6Pu7MRbzp0ICcdeOg8qMC0ET6FQEcEcWKbmesNSEQaA58XFK5NF01GmdT
	 MHAkdqHLe70aTu3m+5SO1q0LhusyMKvMDWcei9zUGm7jIZwHWT0VQAZY9HCwZePLOL
	 sp4qXr/ZWxBHnzjydaRIDJTUsb5F7Ws+iypqLuUAiA2NnGQJQGKWIw7jcKIzplSiL6
	 hsKvmzcCciftqij6dO9ocS2U3FP3qJpBvyfWasLmJR/hOB2CVPeVi7CU+XrMnSmb3s
	 kvIbfWFxA4Piw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 14/14] KVM: selftests: arm64: Add GCS EXLOCK
 exception emulation test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-14-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-14-f31750bdfadb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 22:16:01 +0000
Message-Id: <20260901221601.8CDB21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Test asserts non-compliant KVM behavior for illegal ERET and fai=
ls to repair PC, causing infinite loops on compliant hardware.
--

commit 1bcae6fc1af422d4031f784c89cb5527a9aaf25d
Author: Mark Brown <broonie@kernel.org>

KVM: selftests: arm64: Add GCS EXLOCK exception emulation test

This commit adds a new KVM selftest for ARM64 to validate Exception Locking
(EXLOCK) with Guarded Control Stack (GCS) during exception returns (ERET). =
It
verifies that KVM correctly synthesizes Illegal Execution state exceptions
when an ERET is performed with inconsistent EXLOCK state.

> diff --git a/tools/testing/selftests/kvm/arm64/gcs_exceptions.c b/tools/t=
esting/selftests/kvm/arm64/gcs_exceptions.c
> new file mode 100644
> index 0000000000000..de5bc65907272
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/gcs_exceptions.c
[ ... ]
> +static void guest_illegal_handler(struct ex_regs *regs)
> +{
> +	u64 esr =3D read_sysreg(esr_el2);
> +
> +	illegal_count++;
> +	illegal_pstate =3D regs->pstate;
> +
> +	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_ILL);
> +	GUEST_ASSERT(esr & ESR_ELx_IL);
> +	GUEST_ASSERT(regs->pstate & PSTATE_IL_BIT);
> +	GUEST_ASSERT(!(regs->pstate & PSR_EXLOCK_BIT));
> +	GUEST_ASSERT_EQ(regs->pc, expected_illegal_pc);

[Severity: Medium]
According to the ARM Architecture Reference Manual (DDI0487), when an Excep=
tion
return is illegal (e.g. due to EXLOCKEN), an Illegal Execution state except=
ion
is taken, and the preferred exception return address is the address of the
Exception return instruction (the eret itself).

Does this assertion in guest_illegal_handler incorrectly expect regs->pc to=
 be
the target of the eret (expected_illegal_pc) instead of the eret instructio=
n's
address?

Additionally, because the hardware overwrites the original target ELR_EL2 w=
ith
the address of the eret when taking the illegal exception, will failing to
repair regs->pc back to expected_illegal_pc here cause the subsequent eret
to infinitely return to itself on compliant hardware?

> +
> +	/* Disable exception locking so we can repair the return state. */
> +	write_sysreg_s(0, SYS_GCSCR_EL2);
> +	isb();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-arm64-gcs-=
v20-0-f31750bdfadb@kernel.org?part=3D14
