Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE173537F8
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 19:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786563440; cv=none; b=B/BllsvtTkgLKco/un+gpOOJaFl6SS8JUW6flMC6H8WoEPxuo6y+qUTRPUTvqgvISCVxoP5c9RteuvTbsyJU2hCbZMB4k+SUO/DTdBwZaMcEQAZMRY1yM0two0oq9cq+7TyAJLdz4I0zhMm7aFh3HXS/+s5q1xyd1en7O4eXu3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786563440; c=relaxed/simple;
	bh=5IoJ109mXcGUdQNax16kMCplMYhO4F7BAi3ZXJ0/Opo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kgpZhJoI+oKbFNCZzyiJhTW1iXYr4r7G91jnEBKMWn++HDiunm0XDKJf0qT4cezKc4QO2TdsIInEqYam8nQJSgcfNaDH2sVL+uG7nhGRAzo2lnYKPKESd0mAf3m50QSiqw1hmtWUuS+Z/zIgwrMpUI8+fQslfKr5GJI/j1ell9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eewbWqWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eewbWqWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FB31F00A3A;
	Wed, 12 Aug 2026 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786563439;
	bh=q3Tr3fh1u1M60REb+QmDTl/X71ih/fi0g0qNtoAx/s4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eewbWqWSl3p0kzx4yysO4APILMT0PUQGfCqXCytmfIHglIoqKPve8vkyG7gw5ZWaT
	 WbjPk/5Rd39fasz/tLHog7imSk8PGFkoOybvKYEvEpMQ39UgMmVOVOhA2bKROkOrNg
	 Bm/AhhpZp20y3NDMiQbUxkE4xZ75B8T1i//71+453Z3dwV6WJtq68by5vuEpoEahTc
	 OozGvbqZ4D7GV4cxz0EnJVz+DyWNovxEdcbYe+weQqypy7xtT3PGXxHU7yJasJ8kA+
	 oRzZiKrHar6qr8cTR0vZsiXInEMVE+N/74UaQbxytVSQxkEh6fFoxhGP+QzHmlHG/2
	 DI9HTxzhqv0OA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 13/14] tools: Synchronise the kernel esr.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260812-arm64-gcs-v19-13-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-13-9105afd828ac@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 19:37:18 +0000
Message-Id: <20260812193718.D0FB31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Helper functions for fault status codes do not check for level -2 =
page table faults, despite the underlying macros explicitly supporting them.
--

--- Patch [13]: [PATCH v19 13/14] tools: Synchronise the kernel esr.h ---
commit 5fb6f6b253d11f55810a8290d81373d977245cee
Author: Mark Brown <broonie@kernel.org>

tools: Synchronise the kernel esr.h

This commit synchronizes the tools version of the arm64 esr.h header with
the main kernel header. It primarily picks up new definitions for GCS
(Guarded Control Stack) alongside other fault status helpers.

> diff --git a/tools/arch/arm64/include/asm/esr.h b/tools/arch/arm64/includ=
e/asm/esr.h
> index f3c6403e5ef2b..24c6ebe3fd416 100644
> --- a/tools/arch/arm64/include/asm/esr.h
> +++ b/tools/arch/arm64/include/asm/esr.h

[ ... ]

> @@ -439,6 +490,46 @@ static inline bool esr_fsc_is_access_flag_fault(unsi=
gned long esr)

[ ... ]

> +static inline bool esr_fsc_is_addr_sz_fault(unsigned long esr)
> +{
> +	esr &=3D ESR_ELx_FSC;
> +
> +	return (esr =3D=3D ESR_ELx_FSC_ADDRSZ_L(3))	||
> +	       (esr =3D=3D ESR_ELx_FSC_ADDRSZ_L(2))	||
> +	       (esr =3D=3D ESR_ELx_FSC_ADDRSZ_L(1)) ||
> +	       (esr =3D=3D ESR_ELx_FSC_ADDRSZ_L(0))	||
> +	       (esr =3D=3D ESR_ELx_FSC_ADDRSZ_L(-1));
> +}

[Severity: High]
This is a pre-existing issue, but does this helper (along with the existing
esr_fsc_is_translation_fault() function) fail to check for level -2 page
table faults?

If a guest VM utilizing 128-bit page tables (FEAT_D128) encounters a stage-2
translation fault at level -2 (FSC 0x2A) or an address size fault (FSC 0x2C=
),
would KVM's MMU exit handler fail to recognize the fault because the -2 lev=
el
is omitted here?=20

It looks like missing the (esr =3D=3D ESR_ELx_FSC_ADDRSZ_L(-2)) and the
corresponding ESR_ELx_FSC_FAULT_L(-2) check might cause the host to treat a
legitimate memory access as an unhandled abort, resulting in a VM crash.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812-arm64-gcs-=
v19-0-9105afd828ac@kernel.org?part=3D13
