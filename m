Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B0C2D1913
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 22:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300352; cv=none; b=pARFATC9gYJABL4R566nvUdAMz1hpl+SXD4RSgfqoPkC9B7n8gim15S9sf7CXKf5A0oo8jSPO08pWCq4DIXwzr2LRp6R5WfeJGS0rIgWv7t8AE1w0LA8QNm0l0r0WbIPcaCTOSY5Ta4bc3AwyuF7M8e/LusCCe7emxt5s0Qvw4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300352; c=relaxed/simple;
	bh=T2AHPpX9Y3bS3BGUbDfxx49n+0ga/6iOsNBoacA9hBM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RAsT1LP1tavzbXV89WP86M9ou+ykeKyVVnzJqX99DwiMxsStl4YxYEqo75ptR4Tsk6fQStAhPIAHW9HQDe/wdqB9Jkg1wgx0rHxS+YojZDvcCnkjZDTWQdQN5GUtY0/tpmKQsCBw2plpT5GibsW5fwebaE4F/+u7CaDpKQSJP7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VqUFtZ6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqUFtZ6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710711F000E9;
	Tue,  1 Sep 2026 22:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300350;
	bh=RzSTzF2CBMA1G6qfdKmK0n1GokT6Tvh9q7SL+VuckW8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VqUFtZ6X/QePTySmtxoMW24JyfwGZMax1iIbmjn2jpoIHm6efz8O+xw592O96xdLR
	 67G+oMvymW1n0rJXAv37zO+J9l6Hibi6+HZTutiqe2p4zuXDsFafzUtA4PSeTRWFuP
	 DK5lNplHmsf4uFZULTVUBLkd3EOg5uv90bIXPwyrqLDcpCMaGTXcnGh/P6n9+eppDX
	 dQslL/O1JCFmiStxs9/StHO4qHPtXMQHU1Ju5jHsoiAVI8+dN66qTIoqE40MPkgkP6
	 hoYlMTk6oHL/evawC7wCSAka+ghFR+tg6Kez07jn094pgr1ceCs3L5pcWeF07qOHVj
	 AXDzSZ29+oQkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 10/14] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-10-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-10-f31750bdfadb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 22:05:49 +0000
Message-Id: <20260901220550.710711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] System registers `GCSPR_EL2` and `GCSCR_EL2` are added out of numer=
ical encoding order in the `el2_regs[]` array.
--

commit 48688012983b04c5d07d60f4b5cbfb8bcddc0c42
Author: Mark Brown <broonie@kernel.org>

KVM: selftests: arm64: Add GCS registers to get-reg-list

The commit adds the newly introduced GCS registers (GCSCR_ELx, GCSCRE0_EL1,
and GCSPR_ELx) to the lists validated by the get-reg-list selftest.

> diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/tes=
ting/selftests/kvm/arm64/get-reg-list.c
> index 533994687b5d8..5c1469153b6cf 100644
> --- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c

[ ... ]

> @@ -740,6 +750,8 @@ static __u64 el2_regs[] =3D {
>  	SYS_REG(VTTBR_EL2),
>  	SYS_REG(VTCR_EL2),
>  	SYS_REG(VNCR_EL2),
> +	SYS_REG(GCSPR_EL2),
> +	SYS_REG(GCSCR_EL2),

[Severity: Low]
Are these registers added out of their standard encoding order in the
el2_regs array?

Based on the encoding layout, GCSPR_EL2 has op2=3D1 while GCSCR_EL2 has op2=
=3D0,
which means GCSCR_EL2 should be sorted before GCSPR_EL2.

Adding system registers out of their numerical encoding order (op0, op1, cr=
n,
crm, op2) breaks the implicit sorting invariant of the blessed lists in
get-reg-list.c. When developers regenerate this array using the --list
parameter, the registers will be printed in the correct encoding order,
causing unnecessary diff churn.

>  	SYS_REG(HDFGRTR2_EL2),
>  	SYS_REG(HDFGWTR2_EL2),
>  	SYS_REG(HFGRTR2_EL2),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-arm64-gcs-=
v20-0-f31750bdfadb@kernel.org?part=3D10
