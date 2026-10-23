Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789604;
	b=Uw087C5Apvb1QKnXobfvyCVEf8criFdEN+9GAPUAaXJVouXV5o80H9Hq1Bw1xfJ0claX
	 olr9HzYkHP50++qpGGjKg4U+JiVKEyf4hJruFYR0YYbUgB+EIAwr26t5s4lV9wOuJVrkB
	 JJLQLWnhkTpq8LZmqMT6mjq5ul59+HUkbdHd6TuAx69rCIslY/KYajFZDH8iJh8+2GDCL
	 DPmEgXzvRXDZbRYEHqAPbcc6Qh0m1cmnMyHrMwqcH8Xc1QFmvUzcLtRuNQKF0vokwCZbK
	 7DZbOVO41FmeVr5zIySayXUmqeaE6scQ9ZAUFfmpQgiK8gKQNfxOecONR1EmS7hspkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789604;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KVCFrjjWmnbV9E6bhYiaqXyJpCgrpliR2ZUgEDqN79k=;
	b=np14/aMJbB391S2Fb9W+uNKivxLiOBsEakZiVJoEtqQBJFf+oBreTaHTFGie80NBDTz1
	 HlDba8PZKHLYPGhYyqIRnnwjwN4hLvK8fRhGqJ9nOOSdAHkbcWrXgKkpK/Bu8wA1b06h+
	 T74Zt4tFTNMfAh7wkT0OvGZpj68GBVmVhVnW+aliUbdzBHSJOLjtqhwin9pr2x0T68+1+
	 DPrG0H1PJ+0Q11XiadWii8wUjD3SJj5ubDF7XIChZReHCJwG19Rdm60jM0eCtBKsT+ArU
	 meFRtYScMOnPVEC995Lf+qLomOqjnVFX4bZGGTYsVV/lEkQ/zwYmQUBgoAA/6xyGqMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQ8Hn0W7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7094B606A31B
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 21:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQ8Hn0W7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE661F01828;
	Fri, 23 Oct 2026 21:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789604;
	bh=KVCFrjjWmnbV9E6bhYiaqXyJpCgrpliR2ZUgEDqN79k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XQ8Hn0W7G82w+JSB/j5/IQNB1jsvw9ciVoGMw3/nQmWelfBAPMg+jL4WLdlX2nQkz
	 CUa8zKuTCl111zZL2J/fLTLDuGvlEIVnRFIMczvKZRPUm5pqXAk7rf7ncmj8PbYha2
	 N/XgGT8vd2N1J++V/Z+CNMdYj5Ju6bF+V3CgcPo3+PF0f2p64tqZTKWbaCaMkM7ebk
	 W74LqWyMekHRrb8Vjc5OcHVanwmJi570kSZKVqSe6bU6KcoWnbd1WLl8dv3ehIdGT0
	 /gcOuij5j6DqtH4UQm1cRlDp/L+5po5WC4rEL87XB4RPedw9IAjwnaE8TvGW24NImi
	 /Pk3s5i6X3Q/Q==
Message-ID: <sashiko-outbox-183222@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/28] KVM: arm64: Plumb through access descriptor
 for stage-1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261023205610.1044532-11-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
 <20261023205610.1044532-11-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 21:06:43 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] KVM: arm64: empty default label without statement in handle_at_slow=
()
--

commit 2d01817a35b4565eced6f12aa2e735cfdeeae327
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: Plumb through access descriptor for stage-1

This commit plumbs struct kvm_walk_access through the stage-1 translation
walk helpers so access-dependent features can inspect the access type and
write intent.

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 3031f58553160..fe1d8a674d64d 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c

[ ... ]

> @@ -1355,9 +1357,21 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u=
32 op, u64 vaddr, u64 *par)
>  	if (wr.level =3D=3D S1_MMU_DISABLED)
>  		goto compute_par;
> =20
> +	access.type =3D WALK_ACCESS_AT;
> +	access.ia =3D vaddr;
> +	switch (op) {
> +	case OP_AT_S1E1WP:
> +	case OP_AT_S1E1W:
> +	case OP_AT_S1E2W:
> +	case OP_AT_S1E0W:
> +		access.write =3D true;
> +		break;
> +	default:
> +	}

[Severity: Low]
Will this bare default: label at the end of the switch block in
handle_at_slow() in arch/arm64/kvm/at.c cause a build regression on older
compilers?

When compiling with -std=3Dgnu11, a label at the end of a compound statement
without a following break; or null statement is a c23 extension only
supported starting in gcc 11, which triggers a "label at end of compound
statement" syntax error on gcc 8 through 10.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023205610.1044=
532-1-oupton@kernel.org?part=3D10
