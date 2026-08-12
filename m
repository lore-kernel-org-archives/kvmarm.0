Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357DF360EE1
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 19:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786563054; cv=none; b=uspsMsq4WoKFlxXdfmChfZUrZ6yFKI0HykMSJhbcT4n23lb4+9jK8zCiVfRYoojcivW/8O7mOATO7JddP4a1IfoUnCuwiCHR6+77FcKggflujtUOK55G9kNRvrShrn+Uq4VNsiABYLRLZTRmpe3apMBLJCW8vStWpwmfp3fj8B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786563054; c=relaxed/simple;
	bh=K+YY5IPBBgCYXzNcjS1++ggza12EsI7nAywovS/FUGA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qPSyszkiZx5FJxIXYtEc9f5Le0p8Ynh7KvOIC5afP8Rt1oW/QcrWoFA9QLlDDDcUVUKQCVQsFx7NCyNRwqyXF+h5uGqrmbIwM+iO8SXgtgfn1VkZsq4sVoUM7eiz99MuuZF+0uEOvkLawM8Q8/jFRY9jQ4k3wM8mHFZ+1OYp6nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hv38PuMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hv38PuMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9654D1F000E9;
	Wed, 12 Aug 2026 19:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786563052;
	bh=MJTYGzJW4mcK1J16grWDGh95e2fYLFDByQOrvopuQHw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hv38PuMUsD8sLZxFBVOMJiW5d5gcjalZHjwx7EvAjST1qettu2dPz+LOkcUDm1XT7
	 6lpuEuOgiSeyuqkpkfBUTVoSANh8gykF5Yp+jlYqSYeDAF+KEs1QHZsB8x6h60lQ+x
	 1vLcvd47zzjFoVdLHlv4Ct4gcreIiuklg5goKfHU8PuEaBmwdaSLCNdaX9qFYYwTqe
	 f66HmD+dl7W7B2Xn/Z393h1Z0/g17hLymWUkZzjVZb58ZKsb1weSOjmiTb7zH2g2CG
	 rhJ1/EKFgcSTnvNqyg6uK0LGEdcxFbDdDOT41u/KZOGzKMDm96x8SWvwu1E40idNQ/
	 M0jPxCW+zVZng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 10/14] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-10-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-10-9105afd828ac@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 19:30:52 +0000
Message-Id: <20260812193052.9654D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The EL2 GCS registers are added out of order in `el2_regs[]`, break=
ing the sysreg encoding sort order.
--

--- Patch [10]: [PATCH v19 10/14] KVM: selftests: arm64: Add GCS registers =
to get-reg-list ---
commit 64edf4a2b97420c00ede7a2556bf99d948255c65
Author: Mark Brown <broonie@kernel.org>

KVM: selftests: arm64: Add GCS registers to get-reg-list

This commit adds the new GCS registers (GCSCR_ELx, GCSCRE0_EL1, and GCSPR_E=
Lx)
to the list of registers validated by the get-reg-list KVM selftest on arm6=
4.

> diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/tes=
ting/selftests/kvm/arm64/get-reg-list.c
> index 0a3a94c4cca16..6a93136d153f0 100644
> --- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c

[ ... ]

> @@ -738,6 +748,8 @@ static __u64 el2_regs[] =3D {
>  	SYS_REG(VTTBR_EL2),
>  	SYS_REG(VTCR_EL2),
>  	SYS_REG(VNCR_EL2),
> +	SYS_REG(GCSPR_EL2),
> +	SYS_REG(GCSCR_EL2),

[Severity: Low]
Are these registers out of order with respect to their sysreg encoding?

The register arrays in get-reg-list are canonically sorted by their (op0, o=
p1,
CRn, CRm, op2) encoding to match KVM's native ordering. Since GCSPR_EL2 has
op2=3D1 and GCSCR_EL2 has op2=3D0, should GCSCR_EL2 come before GCSPR_EL2, =
similar
to how the EL1 variants were added earlier in base_regs[]?

>  	SYS_REG(HDFGRTR2_EL2),
>  	SYS_REG(HDFGWTR2_EL2),
>  	SYS_REG(HFGRTR2_EL2),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812-arm64-gcs-=
v19-0-9105afd828ac@kernel.org?part=3D10
