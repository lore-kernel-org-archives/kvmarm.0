Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BA5208D0
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 19:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241542; cv=none; b=W3aFtJqx2ZokoTpIAohAfmEep3f2N6wIh6L3AATLZTay+G5gbcX8/CYiMGmpfvQ/njSkUw9b+z2fWs0I16xtSY8G/20IEpj8mXmrQXVA8MriORhgGUNa3z9/dE0VxFBS8LnnFW4dEVuxcoohfQ18eArcLNLenyJ9X4mC85l1f60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241542; c=relaxed/simple;
	bh=xdDM50dsbh2HIyIlyd7xXufBLU7VvXOMUoXRSTido1c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pHBHoxO2Ye76radT2C0tjhUHGcwYYx2uSolPgQ578muaZ/UF6J1AQYrAYbhr7FxITAd0n/ezt/Bw+YiPU6lSftDno+mTrVHnzZz3V9iacAO5mWiSi6ratK2l86gbnXSw2krKqsZqRwHrZjJbQrWE6pcaXC3v/5XqGZFvI+CL5QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mq9kNwgN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mq9kNwgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C0A1F000E9;
	Tue, 23 Jun 2026 19:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241541;
	bh=ZgVB0XORqHiq/loo2y2k3yG7BcaPmJ1X+sH+gAPReNs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mq9kNwgNivZPkIZrB7nHdLfhqhfQaOt67Uzp+FZfWJCa8CqlHDYrL2A+Y48hA7jFN
	 2Pz9CcEeaUXxh3k4BhDTpUeOTdPl3jLNkUK+/he3gEsKx9PmJAYmKeisSYx3i1AjnE
	 bOyfGLVoYYtkJxKe6AMr17K0llwikpcPSpqQu/M+QnuDe0TgczWWQUtQtc2vjRWKUI
	 Fv0Fz+wroS9e3EbRSxkM3YQ+55I67QN/qXgu6Ui5DUrFGliidOWaNFg56K0F/QN3vT
	 ZgHPbhMn6BPq0R+bJc7Qy+Dc0QrRaxtqFahwLmZgUWZu3N2uHMwPqLz4VeMxhPXoPI
	 qm5ZcI5r3hc3g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 21/22] KVM: arm64: selftests: Test AT emulation for
 FEAT_HAFT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260623184201.1518871-22-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-22-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 19:05:40 +0000
Message-Id: <20260623190541.17C0A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Missing `isb()` instructions between consecutive writes to contr=
ol-plane system registers.
- [Low] Typo `sysrec_clear_set_s` instead of `sysreg_clear_set_s` causes a =
build failure.
--

commit 72540780d6ff6cb4b6ed1c45760fb4372cfa7e9b
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: selftests: Test AT emulation for FEAT_HAFT

Test that KVM's AT emulation sets the access flag on table descriptors
when FEAT_HAFT is enabled at stage-1. Additionally, add test coverage
that asserts the access flag is clear on table/page descriptors when the
AT instruction generates an access flag fault.

> diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selft=
ests/kvm/arm64/at.c
> index d7289f3df04fa..fb7399736f442 100644
> --- a/tools/testing/selftests/kvm/arm64/at.c
> +++ b/tools/testing/selftests/kvm/arm64/at.c

[ ... ]

> @@ -93,9 +103,43 @@ static void guest_code(void)
>  	isb();
>  	test_at(false);
> =20
> +	if (!guest_has_haft())
> +		GUEST_DONE();
> +
> +	sysrec_clear_set_s(SYS_HCRX_EL2, 0, HCRX_EL2_TCR2En);

[Severity: Low]
There is a typo here: sysrec_clear_set_s instead of sysreg_clear_set_s.

> +	sysreg_clear_set_s(SYS_TCR2_EL12, 0, TCR2_EL1_HAFT);

[Severity: Medium]
Does this sequence need an isb() between the register updates?

Updates to control-plane system registers must be synchronized with an
explicit Context Synchronization Event before any subsequent sysreg accesse=
s.
Because sysreg_clear_set_s() performs reads, issuing back-to-back calls
without an intervening isb() causes the second access to execute against an
architecturally undefined pipeline state.

> +	isb();
> +	test_at(false);
> +
> +	/* The effective value of HAFT is 0 if HA is 0 */
> +	sysreg_clear_set_s(SYS_TCR_EL12, TCR_HA, 0);
> +	isb();
> +	test_at(true);
> +
> +	/* The effective value of HAFT is 0 if HCRX_EL2.TCR2En is 0 */
> +	sysreg_clear_set_s(SYS_HCRX_EL2, HCRX_EL2_TCR2En, 0);
> +	sysreg_clear_set_s(SYS_TCR_EL12, 0, TCR_HA);

[Severity: Medium]
Similar to the above, does this code need an isb() between modifying
SYS_HCRX_EL2 and SYS_TCR_EL12?

> +	isb();
> +	test_at(false);
> +
>  	GUEST_DONE();
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D21
