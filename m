Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D18954A7CA
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083354; cv=none; b=ayexPSTumzOv4t9e2XTSrtkfWUgwUPxS9uMsoWgi/lLPR2SDKK6A2Mhd/PtKMgclYKgcfm/BwyognDxlzkTo4qrVChCUGRaHS4ReAWo6Bjww4vuZZHy7KKoTFrTuwSMMV7pBl9Zru6GiiVtBIDYL3SID09MML7fZMYOSlNg1AXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083354; c=relaxed/simple;
	bh=rh3Sqg4RsdiELQGIYwAqJvMvP6eLBp7vf1nPkr1t4Dg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pjNBTdNcPOcIK+x9jq5x587pE2moOVppEBu7D2dTDr0w+cQD5d7evzgAJSMIVxDXd5Ufjz+b4eFHd+Mj55Z4H9bQB0ccebogXNVjvPnEd5RvOrydzK/w9zBpudLqiHq2pR2lFrEY6GrgxYceQQl3IfSlSLqCbbf5w1jvim4EUYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chyep7yq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chyep7yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E301F000FF;
	Tue, 22 Sep 2026 13:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083353;
	bh=aFPKo2PZFybsSiuDkBAN1GWxs4OOQ+wOEE28E98/+h0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=chyep7yq8bypsMpvXTt+7YXUmgqhrl6K7XgT2BLPZ5s4cSMe5r9i6n1SNYUT7KxS+
	 C3hkjRe0KDdchAcyRWVOkIAMcnoABNMFIokErSl0SKz4ymf2Ykb/x/a48s5wOfYOIO
	 T4yUYlOi+5Dzk98C/7mvv6V+kAVqhy9PUetqA86FRHfVygLAFhYdyS8AQkh09E3n3+
	 Iv9gkF3aZ1BffyQHo/Ki5CX6in9I91cYFfFnBoLtGwUeo+4X7OOmORvHidFAZeWM67
	 v37r6TRMGvbfbSJOkptqNXr8S1pk/0PInxySUsHwznrfkeiwDQqHdcIstzpc/ZxvMh
	 8nGzXyd9EU9aA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 13/25] iommu/arm-smmu-v3-kvm: Add MMIO emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260922131259.2975334-14-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-14-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:22:32 +0000
Message-Id: <20260922132232.B2E301F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] hyp: fatal WARN_ON(!mask) on host SMMU MMIO access
--

commit 0f61ec17741805782c471d3c6da0d9dad62368e6
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Add MMIO emulation

Add data abort handler for the SMMUs, at the moment most registers
are just passthrough.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/i=
ommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> index f8b7c5406017e..7a51cb70205fe 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
[ ... ]
> +static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> +			     struct user_pt_regs *regs,
> +			     u64 esr, u32 off)
> +{
[ ... ]
> +	case ARM_SMMU_CR1:
> +		if (len !=3D sizeof(u32))
> +			break;
> +		/* Don't mess with shareability/cacheability. */
> +		if (is_write &&
> +		    (val !=3D (FIELD_PREP(CR1_TABLE_SH, ARM_SMMU_SH_ISH) |
> +			     FIELD_PREP(CR1_TABLE_OC, CR1_CACHE_WB) |
> +			     FIELD_PREP(CR1_TABLE_IC, CR1_CACHE_WB) |
> +			     FIELD_PREP(CR1_QUEUE_SH, ARM_SMMU_SH_ISH) |
> +			     FIELD_PREP(CR1_QUEUE_OC, CR1_CACHE_WB) |
> +			     FIELD_PREP(CR1_QUEUE_IC, CR1_CACHE_WB))))
> +			break;
> +
> +		mask =3D read_write;
> +		break;
[ ... ]
> +	}
> +
> +	if (WARN_ON(!mask))
> +		goto out_ret;

[Severity: Medium]
Is it safe to use WARN_ON() here to validate host-controlled input?

If the host writes an unallowed value to ARM_SMMU_CR1 (breaking out of the
switch before setting mask), or accesses an unhandled register offset,
mask remains 0. The subsequent WARN_ON(!mask) will trigger a fatal
BRK instruction at EL2, crashing the hypervisor and the host.

Since WARN_ON() is fatal at EL2 and does not execute the goto out_ret
recovery path, should this validation gracefully handle the abort instead of
asserting?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D13
