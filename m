Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4803438BC;
	Wed, 29 Jul 2026 11:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322933; cv=none; b=keL6zG3u4zIVleHo7y+N+mwT6zj/Nj2YKBJt8oap6y9fZuyK2KO9MGEYZq2n0/qOXBP+K50dPB0BWDOOWfvJzxXebOFV6eLOgHqg5K2VWg5tjNr1b+XU5Zs2YeHBGlZhc7dvtKONUbXahEZkz34ZRsWY47mVhwhM1QyQvQL9GIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322933; c=relaxed/simple;
	bh=deC+pnXfS1anGgbX/9pjXMfCOBYvajXRM+wvG++4wAo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GdSS2397UhujHBtcK75eJbVDN3zh6BcWvXOp4dD3JIWqpyWe77rAo0guiMrU1kaoEv7C5lyhkJn4KwT9riHgBwlqmgqnCENL1PBL5DrPcQr2zA0Ir7XNzKA1GWrXdAUVLtQ2WdYPWVCbLA0UYbsywAU814m1+4pY2usY+EOArcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfsdfOjf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfsdfOjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3183A1F000E9;
	Wed, 29 Jul 2026 11:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785322932;
	bh=SO7vjDvTx3KbftGWlPOgGiPsW7Qr7kaElJlYvFFV2d8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IfsdfOjfbyqxqzQiqURY9w+cXpUDwff6WmxhC+HGeoVIXUAwLBZsCGMHLvLOhI/KK
	 6tE2oLdSa+SeTtZH1CC/gqwaAlS4PRhuwlddmNgNORBT8RXFQ270A0VqdRjnANFQgJ
	 hVSToz+kFbECKNF5pn2SOXYhTr1amMxEF78p2hgFemFwi1tvKa+HfCkKe5+BvmEOqZ
	 qcQ16v/GiLRjv4/kNGCx62tDuGWNedxo/5NgM8nHJ7YEcBTI9/dHN92X2S3PsRYM8o
	 HSi5EeBE+Og2cjz220v2QmFiS4weoDTel+gyWBEcp1qRTRiqTHurzk2kf11sLrwiiA
	 LjQN6dxId+xSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/11] arm64/cpufeature: Add system-wide FEAT_HACDBS
 detection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260729104548.3439958-3-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
 <20260729104548.3439958-3-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:02:11 +0000
Message-Id: <20260729110212.3183A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Missing KVM ID register filtering exposes FEAT_HACDBS to guest=
s, preventing VMMs from hiding the feature and breaking VM migration.
- [Low] The new capability HACDBS is not alphabetically sorted in the cpuca=
ps list.
--

--- Patch [2]: [PATCH v3 02/11] arm64/cpufeature: Add system-wide FEAT_HACD=
BS detection ---
commit 79552fba5f033b2becee395a64d0ccf3fbde7b1a
Author: Leonardo Bras <leo.bras@arm.com>

arm64/cpufeature: Add system-wide FEAT_HACDBS detection

This commit adds system-wide CPU feature detection for FEAT_HACDBS
(Hardware dirty bit Cleaning). It updates the cpufeature structures
and cpucaps list to track the feature across the system.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index aa327eebaf1ca..62f56bbd0a65c 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -523,6 +523,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[]=
 =3D {
>  static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] =3D {
>  	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_E=
L1_E2H0_SHIFT, 4, 0),
>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1=
_NV_frac_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1=
_HACDBS_SHIFT, 4, 0),

[Severity: Critical]
Does exposing this feature here break VM live migration for KVM?

By adding HACDBS to the host's sanitised ID register, it is subsequently
read by KVM to form the guest's ID register limit.

Looking at arch/arm64/kvm/sys_regs.c:__kvm_read_sanitised_id_reg(), there is
no case handling SYS_ID_AA64MMFR4_EL1, which means the host's HACDBS value
unconditionally leaks into the guest's limit.

Furthermore, looking at sys_reg_descs in arch/arm64/kvm/sys_regs.c:

	ID_WRITABLE(ID_AA64MMFR4_EL1, ID_AA64MMFR4_EL1_NV_frac),

The writable mask for ID_AA64MMFR4_EL1 does not include HACDBS. Because KVM
strictly enforces that non-writable fields must match the destination host's
limit, a VMM attempting to restore a saved VM state will fail if the source
and destination hosts have different HACDBS support.

Could this be addressed by either masking HACDBS from the guest view or
making the field writable by the VMM?

>  	ARM64_FTR_END,
>  };

[ ... ]

> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index a87706c9d160e..bd2c0bb98da61 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -72,6 +72,7 @@ HAS_XNX
>  HAS_HDBSS
>  HAFT
>  HW_DBM
> +HACDBS

[Severity: Low]
This isn't a bug, but HACDBS is inserted out of alphabetical order here.

Does this violate the "# Internal CPU capabilities constants, keep this list
sorted" comment at the top of the arch/arm64/tools/cpucaps file?

>  KVM_HVHE
>  KVM_PROTECTED_MODE
>  MISMATCHED_CACHE_TYPE

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729104548.3439=
958-1-leo.bras@arm.com?part=3D2
