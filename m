Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF574307BC
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503010; cv=none; b=rF/PPgGaGJkDbULmVs9bNOMwYwJtUk/bLLtRKyZiR1OW5dsjgkfpH9QvLmpJsh6SozpbCZqrXHSCybrUOBtj4dp9Ph6De4rCDMpHIX3RGLbaRxwCgsQ91DlkvyNJCqz0bPoFMCrYHWs/9IbNSjEIKWNlEKWrD/SJYBhZg+rO0a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503010; c=relaxed/simple;
	bh=Skop0OkqNBIi3mG/tSQIjmWihlK52ACt30u/meYgJYc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kQrMOx3d11wnWREzp2FByc/0sDXkzh0inymgozWiYyvSdDW11EZCGJwv9MoC/HUXHwnNZJz1EutjjIjQR9PxaJzL7tOCgBX0T9l759/Xc8UF/wfbKbp+a7qChLtNlmpt41l7sVSgzShGm4trqa/2CkLtsk2zg8I1Ki8hnQRiUz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSKqYQJe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSKqYQJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B6E1F00A3A;
	Fri, 31 Jul 2026 13:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785503007;
	bh=bdw6AzyQMGKX9nSzHptLtqTTC81meAcxlwyaviU5cNU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SSKqYQJeYxgHN9vHpp6SjJwq978xz3FMzmNavWMctS3FzE3TPQv7KMULv6AFQQuad
	 YQynAQSuB3nRtGG7JD5NdvxgGq/AyN5uLOx8hhYRzZEFuFogGbd9SoFBfHo3CdbAnj
	 f6fcGVW3PotE3+pz8IQ6y7j2fQFg+DVoypwj9jmJpgQVhLPCgFXYs3RSgZmD+AHWB7
	 mezXxSl8OpC0yMZfmh/8xudLuyYUnDMVBRYXPmMCYTPMCrHYnZs4DbhU/WKBWVu1Ex
	 +Icn9fI71ch9g89pjGbrTqBW0RC3hb1OD/EY0FmJMt/H59AfdOoYt7slMbB18Aou49
	 HacT5Tqcu/GJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 10/14] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260731-arm64-gcs-v17-10-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
 <20260731-arm64-gcs-v17-10-5e39ca01b14e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 13:03:27 +0000
Message-Id: <20260731130327.71B6E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] GCS registers in `el2_regs` are inserted out of order compared to t=
heir system register encoding, violating the array's sorting convention.
--

--- Patch [10]: [PATCH v17 10/14] KVM: selftests: arm64: Add GCS registers =
to get-reg-list ---
commit 54610fb50b06e8daefb5c3cb9a29fbd4f7e9af9a
Author: Mark Brown <broonie@kernel.org>

KVM: selftests: arm64: Add GCS registers to get-reg-list

This commit adds the new Guarded Control Stack (GCS) registers to the
get-reg-list selftest for ARM64. It includes GCSCR_ELx, GCSCRE0_EL1, and
GCSPR_ELx in the validation arrays.

> diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/tes=
ting/selftests/kvm/arm64/get-reg-list.c
> --- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
[ ... ]
> @@ -757,6 +767,8 @@ static __u64 el2_regs[] =3D {
>  	SYS_REG(PIRE0_EL2),
>  	SYS_REG(PIR_EL2),
>  	SYS_REG(POR_EL2),
> +	SYS_REG(GCSPR_EL2),
> +	SYS_REG(GCSCR_EL2),

[Severity: Low]
This isn't a bug, but are these registers inserted out of order compared to
their system register encoding?

The el2_regs array appears to be sorted by encoding (Op0, Op1, CRn, CRm,
Op2). Both GCSCR_EL2 (3, 4, 2, 5, 0) and GCSPR_EL2 (3, 4, 2, 5, 1) have
CRn=3D2, which suggests they should be placed earlier in the array, perhaps
near VTCR_EL2 or VNCR_EL2.

Also, should GCSCR_EL2 (Op2=3D0) precede GCSPR_EL2 (Op2=3D1) here to mainta=
in
the correct relative ordering?

>  	SYS_REG(AMAIR_EL2),
>  	SYS_REG(VBAR_EL2),
>  	SYS_REG(CONTEXTIDR_EL2),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731-arm64-gcs-=
v17-0-5e39ca01b14e@kernel.org?part=3D10
