Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC643E44E5;
	Wed, 22 Jul 2026 09:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711179; cv=none; b=bOFs2RmPXvROmGnKj5+LQDW8qJNjnL8uMiJzS/6SSzB9ejUwtG/OSWo9Y4Kv7EjUCzOmm4UDkZlT5kn+jXwsa3xeN3fyqCVB14KkzLQdQTI1JMnaa4dYtDQC/B+h8MxfhRjbSSPaRU+0AxZqw5nS7cjdofecqgZkRnzj2FZnVN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711179; c=relaxed/simple;
	bh=pMbc/v7WQcaHnbE1CUL5hBgYFmUulnK91551kw+XYrM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oALaraBTVgF9b0WT+AMYR4mzZNa2rqVUjar4CmU8r8r2tiGnwf3LByaa/i5xsSAxB+rxWGkXDVPuS4yLnXRbz59GCfwIUip6Z7XBBct2oOYIYJFy5gRGu4Kc+lidfW6V3PVvrlV+10aLkDhREF2wIMF16QSEWdKlM6MJAGvz6X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAdjLroI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAdjLroI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14F51F000E9;
	Wed, 22 Jul 2026 09:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784711178;
	bh=j5BNyyhLGz5yX47VsYdQ3Txq4Lg7743x0LzcxA3egRM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EAdjLroIditTfQGerUfFj1jZOp++H050+ZFCvPLthGjlIE22IUrXdaYG80YHf5XKa
	 FBSeGIHHFebLekg2XdIaPCFG32IkVoDIkb8WyNyOSr1sIXWNZPwjHEfJQiE2OmNbKg
	 4CQAGlNso3kXhUk7Cs89dAyxhlzwRhaM9VfLMEyUqrl5agM9k7wDNNwqanU/zPalmz
	 G5gKx98DswBQKqgU6capcAn8prJSUDl/u61JZHPZtvag/gYxA0tY+1hRO9mOmgf7c5
	 5suLXN0K7v5vPmYDyMfaLP/rgqlYwVbfEDNKFSuMSxijbEDpRufQKWFeG7Sr/UToXX
	 0VVxm6jQV+cdA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 27/28] KVM: arm64: Expose FEAT_NV3 to guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260722074234.3330999-28-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-28-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 09:06:17 +0000
Message-Id: <20260722090617.A14F51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The new system register NVHCR_EL2, which is exposed to userspace=
 when FEAT_NV3 is enabled, is not registered in the get-reg-list selftest.
--

--- Patch [27]: [PATCH v3 27/28] KVM: arm64: Expose FEAT_NV3 to guests ---
commit 736b25683999a8114fb8bc21450f4b90835ba889
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Expose FEAT_NV3 to guests

This commit further enables FEAT_NV3 by making it visible to NV guests.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1739,7 +1739,9 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 v=
al)
>  			val =3D 0;
>  		} else {
>  			val &=3D ID_AA64MMFR4_EL1_NV_frac;
> -			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +			if (cpus_have_final_cap(ARM64_HAS_NV3))
> +				val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV3);

[Severity: Medium]
By exposing FEAT_NV3 here, will new system registers like NVHCR_EL2 become
visible to userspace on NV3-capable hardware? If so, does the get-reg-list
selftest in tools/testing/selftests/kvm/arm64/get-reg-list.c need to be
updated (e.g., adding them to el2_regs or using REG_FEAT) to prevent the
test suite from failing when it discovers unaccounted registers?

> +			else if (cpus_have_final_cap(ARM64_HAS_NV2P1))
>  				val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P=
1);
>  			else
>  				val =3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D27
