Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDE159B67E
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096242; cv=none; b=Pvi53vOnV2G1ycLInwHBgc9p0jue3nPu2DiorrplvH398dLRF8wBt/iV4QyJ5UrjDtHO4TQFj5oh4tffAbNfX0PFkwqElsQPxHpd5TKodd2rV+bK0cTrHk5N4NIMl6zMKElvp6aRYyB6tddtEHrGzRGke3extLsIQ+m71N8Hlek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096242; c=relaxed/simple;
	bh=3+ueikak59nVd4tIX5aGiIMucPElrOJhmJuJF+N2iWE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bJTOpTExfZFgNdMT+n9OD68CShZyMrIczrnoYgJ71rQSI+huVG4Wc9ld1atgK6MWNPiLpwd8AiZgM2ucet763gM9pteg6WBbbQ5bLepPtfTnGJ//1BLgYdx0NLafiN7XXtQW2ibDTfNAkkHXF2Yiv2kjkBcz9HMdlpPKH/aEBVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDGJa7q5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDGJa7q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4CF1F000C5;
	Thu, 15 Oct 2026 20:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096239;
	bh=e3LCDIB87fNCLNMT7oVaYMrjUX8pt+PBn/9+C7mbmyQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nDGJa7q5Sp8vTrgXSjLNeDGu8HWsZpLYT2z2N4S8HO2MZkpWYTETp9PP46E7F5F6m
	 HQboOeRoTYf6NhMkEmjKm1SejZZjuhU6PAVZ23YAQdmrJlt3IDBTLWtTjavpqQiNdU
	 pE6b1gKEeu2CntJ7F8Qn2PqiqA2hTGYriZ6wjJha1UUw4G/qPxOboAFFV9iomgUWvz
	 qIzWcZB2hb1KpU3D69URBelG0BthZNHTa/cDAnSNZscYOQqIfztyv0WIJqRUO+k1Ic
	 lDOmOPoAhYWa5rmZSgVmZTvYpG+m0TPMcQBMUiIo9jqZIv695fKEXz9tfBoWHPhGrf
	 aZgZ3U3NI5tWA==
Message-ID: <sashiko-outbox-173397@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 13/25] iommu/arm-smmu-v3-kvm: Add MMIO emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-14-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-14-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:30:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iommu: mmio emulation bitwise logic corrupted on big-endian hosts
--

commit 5a437530a55c608782e029a478141ad9b342c024
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Add MMIO emulation

This commit adds a data abort handler for the SMMUs to handle MMIO emulatio=
n.
Currently, most registers act as a passthrough, and upcoming patches will
add CMDQ/STE emulation with logic for specific register access.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
[ ... ]
> @@ -128,6 +132,170 @@ static int smmu_init(void)
> +static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> +			     struct user_pt_regs *regs,
> +			     u64 esr, u32 off)
> +{
[ ... ]
> +	bool is_xzr =3D (rd =3D=3D 31);
> +	u64 val =3D is_xzr ? 0 : regs->regs[rd];

[Severity: High]
Does extracting the register value directly from the CPU context here bypass
endianness conversion on big-endian hosts?

When the host (EL1) uses writel_relaxed() on a big-endian machine, it
byte-swaps the native value to little-endian representation before issuing
the store. The MMIO trap then retrieves this raw, byte-swapped value
directly into val.

> +
> +	switch (off) {
> +	case ARM_SMMU_IDR0:
[ ... ]
> +	case ARM_SMMU_CR0:
> +		if (len !=3D sizeof(u32))
> +			break;
> +
> +		if (is_write) {
> +			/* Enforce ATS checks. */
> +			if (smmu->features & ARM_SMMU_FEAT_ATS)
> +				val |=3D CR0_ATSCHK;

[Severity: High]
Can this bitwise operation corrupt the configuration on big-endian hosts?

Because val contains a byte-swapped value, applying a native bitmask like
CR0_ATSCHK modifies bits at the wrong offset.

> +			mask =3D read_write;
> +		} else {
> +			mask =3D read_write & ~CR0_ATSCHK;
> +		}
> +		break;
[ ... ]
> +	if (is_write) {
> +		if (len =3D=3D sizeof(u64))
> +			writeq_relaxed(val & mask, smmu->base + off);
> +		else
> +			writel_relaxed(val & mask, smmu->base + off);

[Severity: High]
Will this double-swap the corrupted value?

Since val was already byte-swapped by the host's write, writing it back
using EL2's writel_relaxed() applies a second byte-swap, propagating the
incorrect state to the SMMU hardware.

Read paths face a similar issue where the readl_relaxed() output is passed
directly to the guest without being swapped back into the format expected by
the guest's own le32_to_cpu() calls.

> +
> +		hyp_spin_unlock(&smmu->hw_lock);
> +		return true;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D13
