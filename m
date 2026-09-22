Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EBB549386
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084714; cv=none; b=NoJf5c2R8QDxSKwrJTLY5VGxTYnRsPBhF7nANQQRUKmZZ3luD5QYadMDhBlomg1WvT/w/ygukPlqUAQse4xrsHWpn83fy1Xe3cYiAUTJyJh2Rqwf4w9FUzECvg+m/N5gjdfvPX5EQZdd34CkBgwH5JEGWYJRSzgJ0qovvYOE9k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084714; c=relaxed/simple;
	bh=qjiH/5v6WT6bDeKHAg7PzMuV21LGxTFbDpub1ztcliY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k3C3yxkDu6Uuq09kMB7pSEJ3ZYqYJNkK9cZEIO9V7EWtd6ProJ3nQKaF8ngLPMuNFOgl9m4HxOEer5FcLW7NUDxkdfL9Dj2Ohfgz9+wWIzNbbGj6mxZhPk725+6atgXEHH53mRqB/ZF1Kz98AbTU84vk3Tt+3gIb8oUz9//xsg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdecfdMV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdecfdMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180151F000FF;
	Tue, 22 Sep 2026 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790084712;
	bh=/J0Ny/WTz1xpBrONFd5t7IHdohI5AKOMOGxBCnLGUEE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WdecfdMVXLX6fc1FC9lkAupxb6YguF5VhvW1N04nLVLvLAhLrEwE7Jhb488Ut7p5R
	 6JDHTP+8WnXl9VYjH1Tmc5c43jwArOd0pSWbwsGCBTkddxyA3rMA/VeMFROtF8xSM8
	 fKh/uDBbYLu5uUyKp/ji0/jr+aVziHOoDprfwLo6R5p/90pkDufSVqtt5iAndy+qZc
	 QzrDR0FkWOIrZGOwMJhBaiUyzGJfHI6rTg/5i4NsM5oLdt6OgTjhU8WA0LQ3NlkiIf
	 BjkDVBKG7CP2X1WyijbBLs0Mz/aA//Kkq0EFL30Ua7wssFjXQ2EIPBbO10j/x98PkR
	 Ee6uwp2SBHS5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 23/25] iommu/arm-smmu-v3-kvm: Invalidate the SMMU
 TLBs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260922131259.2975334-24-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-24-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:45:11 +0000
Message-Id: <20260922134512.180151F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] iommu/arm-smmu-v3-kvm: dead-branch traps and incorrect WARN_ON u=
sage at EL2
--

commit 12e407f77295df6bfe7066853a3a177e9465aaf7
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Invalidate the SMMU TLBs

This commit implements the io-pgtable flush operations to invalidate the
shadow stage-2 in every SMMU. It tracks whether the SMMU command queue is
enabled and issues invalidation commands to the hardware when active.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/i=
ommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> index 6f0ea3a4e48df..5417a5c2bf58a 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c

[ ... ]

> @@ -221,17 +220,139 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_de=
vice *smmu,
>  	return smmu_sync_cmd(smmu);
>  }
> =20
> +static int smmu_tlb_inv_vmid(struct hyp_arm_smmu_v3_device *smmu)

[ ... ]

> +static void smmu_tlb_inv_range(unsigned long iova, size_t size, size_t g=
ranule,
> +			       bool leaf)
> +{
> +	struct hyp_arm_smmu_v3_device *smmu;
> +
> +	for_each_smmu(smmu) {
> +		hyp_spin_lock(&smmu->hw_lock);
> +		/*
> +		 * Don't bother if CMDQ is disabled, this would be useful for the case
> +		 * when RPM is supported to avoid touching the SMMU MMIO when disabled.
> +		 * The hypervisor also asserts CMDQEN is enabled before the SMMU is
> +		 * enabled. As otherwise the host can prevent the hypervisor from doing
> +		 * TLB invalidations.
> +		 * When the SMMU is re-enabled the hypervisor cleans the TLBs.
> +		 */
> +		if (smmu->cmdq_active)
> +			WARN_ON(smmu_tlb_inv_range_smmu(smmu, iova, size,
> +							granule, leaf));

[Severity: Medium]
Does this WARN_ON() panic the hypervisor if the hardware command queue
stalls?

At EL2, WARN_ON() expands to a fatal BRK instruction. If the SMMU command
queue is full or stalls for >1ms, smmu_wait() returns -ETIMEDOUT, which
will bubble up here and cause an unrecoverable hypervisor panic.

> +		hyp_spin_unlock(&smmu->hw_lock);
> +	}
> +}

[ ... ]

> @@ -725,6 +873,8 @@ static void smmu_emulate_enable(struct hyp_arm_smmu_v=
3_device *smmu)
>  		return;
> =20
>  	WARN_ON(smmu_update_ste_shadow(smmu, true));
> +	/* Clean the TLBs each time the SMMU is enabled. */
> +	WARN_ON(smmu_flush_all_tlb(smmu));
>  }

[Severity: Medium]
This isn't a bug introduced by this patch, but looking at the existing code
just above this in smmu_emulate_enable():

	if (WARN_ON(!is_cmdq_enabled(smmu)))
		return;

Does this create a dead-branch trap? Because WARN_ON() is fatal at EL2, the
intended graceful return on an invalid host state is unreachable, as the
warning itself panics the hypervisor.

[ ... ]

> @@ -745,6 +895,13 @@ static void smmu_emulate_cmdq_enable(struct hyp_arm_=
smmu_v3_device *smmu)
> =20
>  static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smm=
u)
>  {
> +	/*
> +	 * We can not enable the SMMU if the CMDQ is disabled and similarly
> +	 * we can not disable the CMDQ if the SMMU is enabled, as that can
> +	 * lead to stale TLBs.
> +	 */
> +	WARN_ON(is_smmu_enabled(smmu));

[Severity: Medium]
Does this allow the host to trivially panic the hypervisor by issuing an
invalid sequence?

Since WARN_ON() expands to a panic at EL2, asserting directly on
host-controlled state (disabling the CMDQ while the SMMU is enabled)
turns a host misconfiguration into a hypervisor panic, bringing down the
host and all protected guests.

> +
>  	WARN_ON(smmu_unshare_pages(smmu->cmdq_host.base_dma,
>  				   cmdq_size(&smmu->cmdq_host)));
>  }

[ ... ]

> @@ -1020,6 +1177,20 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v=
3_device *smmu,
>  		else
>  			writel_relaxed(val & mask, smmu->base + off);
> =20
> +		/*
> +		 * Make sure writes to CR0 are immediately observed, that is important
> +		 * when synchronizing with TLB invalidation as reading CR0 is not enou=
gh
> +		 * to deduce the SMMU state, and we have to enforce the ack with the
> +		 * hw_lock acquired.
> +		 */
> +		if (off =3D=3D ARM_SMMU_CR0) {
> +			u32 cr0 =3D val;
> +
> +			WARN_ON(smmu_wait(false,
> +					  readl_relaxed(smmu->base + ARM_SMMU_CR0ACK) =3D=3D cr0));

[Severity: Medium]
Could this strict equality check predictably time out and panic the
hypervisor if the host writes reserved bits?

If the host writes RES0 bits to CR0, the hardware drops them, making the
strict readl_relaxed(...) =3D=3D cr0 check fail. The poll will then time ou=
t,
and the WARN_ON() will fatally panic the hypervisor.

> +			smmu->cmdq_active =3D !!(cr0 & CR0_CMDQEN);
> +		}
> +
>  		hyp_spin_unlock(&smmu->hw_lock);
>  		return true;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D23
