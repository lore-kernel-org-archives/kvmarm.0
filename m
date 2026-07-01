Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B243C39F174
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 20:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782939149; cv=none; b=APao+Bk/7kDibTq5EFkbcxo4z5ZElmrGBz3mmkxfwshv/4uOoV0PGPTJQeW0LvacX5Un+kr0m2iEPY10RHrEqz/ck5cVwIhtzgsdeB/FeMtHwj/Jzo78ogcDNlHQ9maD1lZaGy95uG82k9viqvGB99wmAyxLuQQXz5NKYFsHPh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782939149; c=relaxed/simple;
	bh=Z0/K5iUtfX9OKiXhXAOYZ9FhiNGYcjE99y/JcmrvxyI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Fp5yMAZlMBYdqvYIE93AsiatJBc+SOuOG1CfPR1wCmB19faPAMTsI1ilQLvVlPiWm9cetD4XZ9uh2Vb6aIiRKgnbr954KU4TSrQDxo6JijnWjIMKEc8EcyIaevMrIJIblQypVKZZlJolV++pzvSs0NtAmF2nKSQIRGOoy0vb/Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxF9VfRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxF9VfRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170F21F000E9;
	Wed,  1 Jul 2026 20:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782939148;
	bh=l20JvLUvLQxF+8B9MJdbl10GtAQE2K5JRdOo9qUDC0s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lxF9VfRoZ8qsumAWbRRexhzN+xGOIEnZKN7C4f3v9VZaY+TSoQWk6xxj9WNL3/9D3
	 RqQtI3P/g1rjq7seNYPup8Qjpye9rNpBj9cZeNmgFbRt0nP23WlxaQQzCxFZsW5haT
	 G9ZylpCDmq3qEriGxFZ/dMsobpFUvibpqKah0j+ZDikgi+4l2HbRTDoCqSjNJ4fvgY
	 GOlTBxEkemv4HXjHu/UYd5ScDuUzVGI2h35Ia2mEZP23DtINZv78kneHq83rrYqSUJ
	 a/3/2nEVawrtHXa0V82+K9q1hTSzAEne3kW2+A94nR4tAWDDIdSAoUZT7EfM24LHiv
	 3eqTkEmPpWxyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/5] arm64: Fix early handling of FEAT_E2H0 not being
 implemented
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260701204342.2654385-4-coltonlewis@google.com>
References: <20260701204342.2654385-1-coltonlewis@google.com>
 <20260701204342.2654385-4-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 20:52:27 +0000
Message-Id: <20260701205228.170F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Preexisting missing Context Synchronization Events (ISB) after con=
trol-plane system register writes in EL2 initialization paths.
--

commit b196767cce7549b6fb016f11fb98e5c15bbcaa71
Author: Marc Zyngier <maz@kernel.org>

arm64: Fix early handling of FEAT_E2H0 not being implemented

This commit fixes the early detection of FEAT_E2H0 when running as a nested
guest, as HCR_EL2.E2H is not guaranteed to be set. It sets HCR_EL2.E2H early
and correctly checks ID_AA64MMFR4_EL1.E2H0 to avoid hVHE boot failures.

Link: https://lore.kernel.org/r/20240321115414.3169115-1-maz@kernel.org

> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index e32c8dd0b17a7..e0e710b36da37 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
[ ... ]
> @@ -588,22 +603,10 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
> =20
>  	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
> =20
>  	mrs	x0, hcr_el2
>  	and	x0, x0, #HCR_E2H
>  	cbz	x0, 2f
> -1:
> +
>  	/* Set a sane SCTLR_EL1, the VHE way */
>  	pre_disable_mmu_workaround
>  	msr_s	SYS_SCTLR_EL12, x1
[Severity: High]
This is a pre-existing issue, but I noticed there is a missing Context
Synchronization Event (ISB) after the control-plane system register write in
this EL2 initialization path.

In init_el2() in arch/arm64/kernel/head.S, writing to control-plane registe=
rs
like SYS_SCTLR_EL12 leaves the pipeline in an architecturally undefined sta=
te
without an ISB instruction immediately following the write.

Does this missing barrier mean the CPU might fetch or execute subsequent
instructions using a stale MMU or caching configuration?

It looks like similar missing ISBs occur in other EL2 and KVM initialization
paths:

- arch/arm64/include/asm/el2_setup.h:__init_el2_hcrx() writes SYS_HCRX_EL2
  and returns to the macro sequence.
- arch/arm64/include/asm/el2_setup.h:__init_el2_fgt() writes FGT control
  registers followed by a read of id_aa64pfr0_el1.
- arch/arm64/include/asm/el2_setup.h:__init_el2_cptr() writes to cpacr_el1 =
and
  cptr_el2 followed by conditional branches.
- arch/arm64/kvm/hyp/nvhe/hyp-init.S:___kvm_hyp_init() writes to hcr_el2
  followed by mov, and, and cbz instructions.

Could these missing synchronizations cause unexpected faults during boot on
some microarchitectures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701204342.2654=
385-1-coltonlewis@google.com?part=3D3
