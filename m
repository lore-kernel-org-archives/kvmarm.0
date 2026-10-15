Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D8A58B6D1
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096091; cv=none; b=FE3GYrtuh6xcsqjR+tdCUwvNrcGs0BeysIHpaV6zDomenUMIviAe3bYjnkq+JE7TJAFwBLCHgRxFOlhfIQKAv+foGR986OicWSOV2gydzMt5qVS6ZIjkiVRgeD0esbmqNUM7HGYTfYvV/iut/IdEk9U2fYD6tcSIPgBC/llq1sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096091; c=relaxed/simple;
	bh=ZayHndiURx7XsbSMaojZ933rtrGv78AOiG1QlvLHavk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oUSJZ5bfA0AmqcVFTHiv1nqj4p/cNC+FZp0X0FRF/zl9gmPzO0Mda5Eha9tq7k978/s5gzoKMPsWu+3SeusFU9Gq5lo15hOeuJPRwtZPwElmVZRUw62/cTknaUzippnHcRTD9bZQK8fgx1E5xe2M7s2Zi+/NOaNLStgkCAQVP2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+R1evRY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+R1evRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCF21F000C4;
	Thu, 15 Oct 2026 20:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096082;
	bh=Uwo/QS2SJs9AjROI1dxguNIWGjZ64N+8dUHCP7P8v/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c+R1evRYQv1ORFGUKAZyN4rAT2ci7C6vDfGuZFxWZN6l4AfhDvyxui6VhCE57HEeV
	 b0rB71PyPd/asrKpApXmquXJ+yQe1UNaNlR1FszivHJoN6haqGLRa4AZGETKjWuMfU
	 PEG/fW9gSzirF2NXbXuFwJaxG3/G7CbPxV6QaEu4RYTcp59Ms7wINDE6h+mGV7opOs
	 5VfGDKPvdtaPY9UiQpNVMbSSi8Us4ZH82Eiiv11Xg8F4rYH0Zb3I1fuVTSRsIfxVQ4
	 F09ruvoYbIsEkl+N9g5xH0EFq/jqiIy2rWOIsj4hWZ7dWKbFokBHnKxxPvTlP0tAlQ
	 FCXWgsCp5DnXg==
Message-ID: <sashiko-outbox-173389@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 14/25] iommu/arm-smmu-v3-kvm: Shadow the command
 queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-15-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-15-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:28:01 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] iommu/arm-smmu-v3-kvm: wrong WARN_ON() causes hyp panic on inval=
id host MMIO
- [Medium] iommu/arm-smmu-v3-kvm: WARN_ON used to validate host input in SM=
MU emulation
--

commit bf6dcb76ab39be1d82600f47f81d772f4c08b9a6
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Shadow the command queue

This patch allocates a shadow command queue per SMMU to be used by the
hypervisor at boot. The host command queue is pinned in a shared state
when enabled to avoid donation issues and prevent untrusted host access
from reaching the hypervisor state.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c

[ ... ]

> @@ -132,6 +225,23 @@ static int smmu_init(void)
>  	return ret;
>  }
> =20
> +static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	u32 shift =3D smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
> +
> +	smmu->cmdq_host.llq.max_n_shift =3D min(shift, smmu->cmdq_max_shift);
> +	smmu->cmdq_host.base_dma =3D smmu->cmdq_host.q_base & Q_BASE_ADDR_MASK;
> +	smmu->cmdq_host.base_dma &=3D ~(cmdq_size(&smmu->cmdq_host) - 1);
> +	WARN_ON(smmu_share_pages(smmu->cmdq_host.base_dma,
> +				 cmdq_size(&smmu->cmdq_host)));

[Severity: Medium]
Will this cause a fatal hypervisor panic if the host provides an invalid
physical address or an unshareable memory range?

At EL2, the WARN_ON() macro behaves as a fatal exception. If the host
configures the emulated SMMU with an invalid address, smmu_share_pages()
can fail and return an error. Wrapping this fallible, host-influenced
operation in WARN_ON() will crash the hypervisor. Could this path safely
ignore the invalid configuration or return an error instead?

> +}
> +
> +static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smm=
u)
> +{
> +	WARN_ON(smmu_unshare_pages(smmu->cmdq_host.base_dma,
> +				   cmdq_size(&smmu->cmdq_host)));

[Severity: Medium]
Does this also have the same issue with WARN_ON() panicking the hypervisor
if the host-provided memory range fails to unshare?

> +}
> +

[ ... ]

> @@ -158,6 +268,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_=
device *smmu,
>  		break;
>  	/* Passthrough the register access for bisectability, handled later */
>  	case ARM_SMMU_CMDQ_BASE:
> +		if (is_write) {
> +			/* Not allowed by the architecture */
> +			if (is_cmdq_enabled(smmu))
> +				break;

[Severity: Medium]
If the host kernel makes an invalid MMIO write to ARM_SMMU_CMDQ_BASE while
the CMDQ is enabled, the switch statement breaks and leaves the mask set
to 0.

Later in smmu_dabt_device(), there is a pre-existing check:

	if (WARN_ON(!mask))
		goto out_ret;

Since WARN_ON() is fatal at EL2, will this turn an invalid host MMIO access
into a hypervisor panic? It seems like the access should be gracefully
ignored or rejected without triggering a fatal assertion.

> +			smmu->cmdq_host.q_base =3D val;
> +		}
> +		mask =3D read_write;
> +		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D14
