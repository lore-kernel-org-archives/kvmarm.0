Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E935E4734F2
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 22:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300501; cv=none; b=BoOJrOi+KV3xOJL45ruClv7m0b2IMp4iMeP/G+zipHO0JpAFfjlo4Kp9//fyaxZLuGozZrIirXDhICD0Hn0eaw1sskguJiWgRjBL6SEiGuKOHo4GAeJF/hf92YPsOh4T6BPooHNXzA6QsqrwalF03stRkD8ImO3SzdBEwkTd7TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300501; c=relaxed/simple;
	bh=lKe/WadaAFR/hRmbhtKp2V1rrOc2PElWs6goEeyEEE0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VdmtdsqTH2yFWThcBbi+O9IBnb4tDBG/wWcoiUPSkinj64ojepC9gnvb7PC+IWf0lHGHJcyMn2rWMTVJOVTGAelgZnWKc+Hqqx8kmOnxwtol8cmwdBD03BEVBc4V4yC1JpdaENu2WnjZbYMFkEJFf1SHhqUMQG4pxzjrR0pIiDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWoeK/FO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWoeK/FO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04121F000E9;
	Tue,  1 Sep 2026 22:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300498;
	bh=CUbui8CD7Wua3pKfpuk3zN+CNHD2lm9nRmOgNo7lF30=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IWoeK/FOjf8ZsEhT4VmQOV+WPLzT/Qc0FuJV9RQgGyT9MpBQj+DLWTUDkOimKZfvC
	 4Kfxq4yUMvbWJnPJ45I7Qx3wy9WTf67Out84q325Ct7ddRr/NBpaFmukVSzr+jgTMB
	 SiWS+etuiQr+Cvbxzwf4vrIQzNUZ/sP8ykym8m1k5wQ65TBFDdYcm+bArU4EhZ1XWh
	 NumKJzVfaYn/Rdf3ilMHJ765xb9ujWHpB83BvqD9E/S2eqXmH2UMSE4S2BPbEBPJrO
	 7GAKb5BHyPYRhDFZF6UU1tfmsYAlWAd4lSDysSScFHdOdW818tLGLGmIIqOjlyYUjt
	 5WHP29PIV7JSg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 13/14] tools: Synchronise the kernel esr.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-13-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-13-f31750bdfadb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 22:08:17 +0000
Message-Id: <20260901220817.F04121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The tools version of `esr.h` is synchronized incorrectly, introd=
ucing an invalid value for the level -1 address size fault status code, whi=
ch causes `esr_fsc_is_addr_sz_fault()` in userspace tools to misclassify ac=
tual level -1 address size faults.
--

commit 2c5fc93c8578044cae22aadc2c4df4b978889699
Author: Mark Brown <broonie@kernel.org>
Subject: tools: Synchronise the kernel esr.h

This commit updates the tools version of esr.h to match the kernel version,
picking up new definitions for GCS.

> diff --git a/tools/arch/arm64/include/asm/esr.h b/tools/arch/arm64/includ=
e/asm/esr.h
> index f3c6403e5ef2b..24c6ebe3fd416 100644
> --- a/tools/arch/arm64/include/asm/esr.h
> +++ b/tools/arch/arm64/include/asm/esr.h

[ ... ]

> @@ -119,6 +123,16 @@
>  #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
>  #define ESR_ELx_FSC_SECC	(0x18)
>  #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
> +#define ESR_ELx_FSC_EXCL_ATOMIC	(0x35)
> +#define ESR_ELx_FSC_ADDRSZ	(0x00)
> +
> +/*
> + * Annoyingly, the negative levels for Address size faults aren't laid o=
ut
> + * contiguously (or in the desired order)
> + */
> +#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) =3D=3D -1 ? 0x25 : 0x2C)

[Severity: Medium]
Does this synchronization introduce an invalid value for the level -1 addre=
ss
size fault status code?

The main kernel's esr.h defines the level -1 address size fault as 0x29, but
this macro evaluates to 0x25 when n =3D=3D -1. If hardware generates a leve=
l -1
address size fault, the resulting syndrome value is 0x29. Userspace tools or
KVM selftests checking the fault with esr_fsc_is_addr_sz_fault() will test
against 0x25 instead and incorrectly return false.

> +#define ESR_ELx_FSC_ADDRSZ_L(n)		((n) < 0 ? ESR_ELx_FSC_ADDRSZ_nL(n) : \
> +						   (ESR_ELx_FSC_ADDRSZ + (n)))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-arm64-gcs-=
v20-0-f31750bdfadb@kernel.org?part=3D13
