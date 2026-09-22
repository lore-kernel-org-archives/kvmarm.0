Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DA854CF5F
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083965; cv=none; b=sHppm9+ltN9ZALICXUBDuqmqzS1omMO6VyvtXFkZR15LxTd535h58Eh4Bjc+dqvpaBRv6W+81J8TdS9b0P0s5qvYFOBXlYrpD24K5Ir8e9AhG/wi9d8k5QKUV8E27YzGtttFdexL4ZgktefGauuPaqGjpyjsk2dw3G44bmO/kPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083965; c=relaxed/simple;
	bh=dco2jVrQ4ttyA+ORM2VfYIhZHB/Y9YLiyo2SZ/8QESI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VDMDTsW4XU7kaztkw9EM+vmRWMirzk/s9S7mudgVLAhkSj0RKlAPXa9wLuPldO7gc3D8WIYP40r9+gku8QzhYrOiVhaYwY4ZmBXRZJu8RzqQ7hMFnjj8hLGqaU5lvMn10rm1hilN7tyM14Fs7PEYIgVXaVtpw9ckw//CogpPu90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heOXJ1eD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heOXJ1eD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4181F000FF;
	Tue, 22 Sep 2026 13:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083964;
	bh=6tjfLXEJM0oFj2CYTy0ziC9uXhb6XSlDtIly26vhE2A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=heOXJ1eDcnatFGzgrYI6nLqrgK4G/Q5bEmmrk2yHiRzMl7VJcNg6VLLmygfaRutka
	 /wbbNWH4DrKgBloo9VbvFRWhd5XkwLHL/AkP8ny3bDiiMTB1rLB8SwLnaTe/WYfgL2
	 TkCSlL6V3LhPC2Jdk9/JcV2lbd3WtWoUgXJEGxmruRy2G44sC9mNBxvYnCa5MvQOKY
	 K1rN2O+JyUviWbUiv6uWFdOoZ0AFUnDjGxwV1if8U0nA17nerZEY9gI8lQcPxrL48i
	 RjFAXsF9HDTJRAEcfIiPJ01uRNH/DOEV/ttiD8Z3DpJJPU5gBTvbYCy/a7ZnPheqD7
	 rRTnt2ruOqMmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 14/25] iommu/arm-smmu-v3-kvm: Shadow the command
 queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260922131259.2975334-15-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-15-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:32:43 +0000
Message-Id: <20260922133243.DE4181F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] hyp: wrong WARN_ON() in smmu_emulate_cmdq_enable() causes panic
- [Medium] hyp: WARN_ON() on host MMIO access creates dead-branch trap
--

commit 6579ca2101bec241418169d448cfd8bd062f327e
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Shadow the command queue

At boot, allocate a command queue per SMMU which is used as a shadow
by the hypervisor. The host command queue is pinned in a shared state
to prevent it from being donated to VMs.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/i=
ommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> index 7a51cb70205fe..b26c21b595b47 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
[ ... ]
> @@ -132,6 +222,23 @@ static int smmu_init(void)
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
If the host provides an invalid or unmapped command queue base address via
the ARM_SMMU_CMDQ_BASE register, smmu_share_pages() will return an error.
Since WARN_ON() expands to a fatal break instruction at EL2, would this
allow the host to intentionally crash the hypervisor by passing bad input?

Could we handle the smmu_share_pages() failure gracefully instead of using
WARN_ON() on host-controlled inputs?

> +}
> +
[ ... ]
> @@ -158,6 +265,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_=
device *smmu,
>  		break;
>  	/* Passthrough the register access for bisectability, handled later */
>  	case ARM_SMMU_CMDQ_BASE:
> +		if (is_write) {
> +			/* Not allowed by the architecture */
> +			if (is_cmdq_enabled(smmu))
> +				break;
> +			smmu->cmdq_host.q_base =3D val;
> +		}
> +		mask =3D read_write;
> +		break;

[Severity: Medium]
When the host writes to ARM_SMMU_CMDQ_BASE while the command queue is
enabled, the switch statement in smmu_dabt_device() breaks with mask
remaining zero.

Later in smmu_dabt_device(), there is an existing check:

> 	if (WARN_ON(!mask))
> 		goto out_ret;

Because WARN_ON() at EL2 causes a fatal panic, the goto out_ret recovery
path is dead code. Would this allow the host to crash the hypervisor by
performing an invalid write to ARM_SMMU_CMDQ_BASE?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D14
