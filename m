Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170FC58E2C6
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096151; cv=none; b=AucLlmVyC3BcPVz3LiGWGhK2psYDycpWm6Bx+2ZHtWIphYjKpkw5SsH1aH92aiWbvFEWTZJZ5L+f2+pGsPVrLyDoZhT52Z7NjSNoo8BSr/Rfsu5P3xr5KOkrL8usqCmrtwpPNDN8miJIJdhNCgpxSeV2fxc3Ty3U2spIlUQUCXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096151; c=relaxed/simple;
	bh=sG7XypQRXMvV5UDsmixYU+ByfkGqWcJE7O4XHZ19ud8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OQTs4e88tqiLGPHJF6xO6fZr1LZovDC44eoxLzrJ81rAxBk9lE1rq5qY3ewKpsVRpi/J5oAqU+pfzhx4eof6cghDKBqv+v7BLD1G7m/BIw3OOdPXy+c7HNvVKnDSVUJQJrwXzQtS0J0k0PVve7VE/zuduPk7RKpVabt5og9Ghno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loeqiwH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loeqiwH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8D61F000C4;
	Thu, 15 Oct 2026 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096149;
	bh=kAQlByVXd+jhYdNkSFJXPy2aEbedya/uJmGydjD/1Tw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=loeqiwH+XONfKuyDh6TC5Zn/bjOCl62HxZQIMkhSOwhGzsC3WFPjXjxEjJxJPn/ca
	 U2JpN9gDmureXgLXGxcg3HQIXyDmzvmef59jLmjAPZkrA5bM7sPGDt0xM9hF2Sz06c
	 kOIOf7i7TztblOEYJi7JDQAZkamS0QjfPdfZJzAuwXixQWwKdUmzyezc4KarFKWlcg
	 /qjoCe7tzDC2M7EUvXM+K9JOFV7J0b5WReeWrT/8Fdb1abCdZzV7y3tTqI/6AicYMY
	 kDSXCwsR8cUS4PlcsiHaIF+5WJGn+MmcYx0Hp7/xrCQrZ51kW4oBDAM9VSh/h6/HOn
	 O7vltPz0Myanw==
Message-ID: <sashiko-outbox-173392@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 19/25] iommu/arm-smmu-v3-kvm: Share other queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-20-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-20-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:29:08 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iommu/arm-smmu-v3-kvm: EL2 panic on kexec due to locked EVTQ/PRIQ =
base addresses
--

commit bfd6e271a581b5d4148ccc397cc5a82480d46470
Author: Mostafa Saleh <smostafa@google.com>

    iommu/arm-smmu-v3-kvm: Share other queues

This commit introduces pinning and sharing of the event and PRI queues in t=
he
hypervisor to prevent the host from writing to protected memory. It enforces
that the host cannot change the base addresses of these queues once they are
shared.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> index 132f3a9ba3084..1972df1d2a8dc 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
[ ... ]
> @@ -806,6 +852,34 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_=
device *smmu,
> =20
>  		mask =3D read_write;
>  		break;
> +	case ARM_SMMU_EVTQ_BASE:
> +		if (len !=3D sizeof(u64))
> +			break;
> +
> +		if (is_write) {
> +			/* See ARM_SMMU_CR0 */
> +			if (is_evtq_enabled(smmu) ||
> +			    (smmu->evtq_shared && smmu->evtq_base !=3D val))
> +				break;

[Severity: High]
Does this rigid check prevent the host from performing a successful kexec?

When the host executes a kexec, the new kernel boots and initializes its own
SMMUv3 driver, allocating new memory for the EVTQ and writing the new base
address here. Since EL2 state persists across kexec and the hypervisor never
clears smmu->evtq_shared upon disable, this condition evaluates to true.

The break leaves mask =3D 0, which then triggers the WARN_ON(!mask) at the =
end
of the handler, resulting in a fatal hypervisor panic.

> +			smmu->evtq_base =3D val;
> +		}
> +		mask =3D read_write;
> +		break;
> +
> +	case ARM_SMMU_PRIQ_BASE:
> +		if (len !=3D sizeof(u64))
> +			break;
> +
> +		if (is_write) {
> +			/* See ARM_SMMU_CR0 */
> +			if (is_priq_enabled(smmu) ||
> +			    (smmu->priq_shared && smmu->priq_base !=3D val))
> +				break;

[Severity: High]
Similarly, does this check for the PRIQ base address cause the hypervisor to
panic during kexec?

Just like EVTQ, the new kernel initialized during kexec will write a new
PRIQ base address, triggering this break and hitting the same fatal
WARN_ON(!mask) further down.

> +			smmu->priq_base =3D val;
> +		}
> +		mask =3D read_write;
> +		break;
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D19
