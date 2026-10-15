Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2CC58E2D1
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096208; cv=none; b=tEEs7z958PHWCyB3yrusJdJtRLxQ6/CJrtuXH8FWX1v1CjR4VJEHu0JDUQ7P23RB8ps7gqWHCe+dUyTBccS/Tj4VLvcOqBtVOxpyONr0FPPkaCGxohwTxyx6Yr8xZxVbPrH7OULsTsajplZqavRgabexcgKOkOgzA0h6oremHMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096208; c=relaxed/simple;
	bh=BzZTErzXU9o7kNXZPrTCPUrQYSSdBJ7MnUO4FRsVC0E=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hP1GWticGEMmtQDfg6VUNnDnW2h5wBO66g7+NNCmCiM44QKrkV0J6nWRjQ2axBWoqHQD0sxm7qj/XBIlt5caaRsMm/XATOY/IO7xXoYhR1pIR3pHWoxqp/tAXOHTGJ+W+yaaZtVJxgEhyICT0ovjkxNJS7Ra7LiSlMo9ydBxA4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWAtBiy7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWAtBiy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7061F000C5;
	Thu, 15 Oct 2026 20:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096206;
	bh=toQFWyhAvzScvmsiFAEQShMDE+4eOOidEBNyPILdQ8A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mWAtBiy7OIJWyvPhO8MuxsvzadVbM4mPu0Aez5ZeyMR/kRzDNJ2ljmjK3BV8ovTmd
	 l50kevCLHGz/YBdJ4XdWTA2xRYBAlNBYjE2A38fufI8C6tjYA0RykPy4R68uH0Ld6/
	 B6ivTi1dt+q1dOe6aDgfzy6iHc7BYv5y173oCyO1cOSQTZStMKa7Dg0+T/AgOpjXr/
	 erTh+RGeeYiKyIoCGWofMuL/SEsxrdBoC8U0GhwAdmSsifmmjOIUgMxO1PIpivTFiY
	 J4q2xBh2nZAG9rjOo5FRd6EyX8Bf2ghX2xm3iWdR3k6WK37pBKMofpwoQKVARNBCEO
	 7vhHB67BrNx+Q==
Message-ID: <sashiko-outbox-173394@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 15/25] iommu/arm-smmu-v3-kvm: Add CMDQ functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-16-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-16-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:30:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iommu/arm-smmu-v3-kvm: swapped WFE logic causes queue polling dela=
ys
--

commit 533e5a914cd22f171b26c2c5c0e2acfb11756ea5
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Add CMDQ functions

This commit adds command queue accessors for the ARM SMMUv3 in the
hypervisor. It includes command queuing and synchronization functions,
with a 1 ms polling timeout that sleeps in WFE when SEV is supported.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> index 02e7c61758329..c9fc21e405e79 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
[ ... ]
> @@ -77,6 +113,85 @@ static int smmu_unshare_pages(phys_addr_t addr, size_=
t size)
[ ... ]
> +static int smmu_add_cmd(struct hyp_arm_smmu_v3_device *smmu,
> +			struct arm_smmu_cmd *cmd)
> +{
> +	int ret;
> +
> +	hyp_assert_lock_held(&smmu->hw_lock);
> +	ret =3D smmu_wait(smmu->features & ARM_SMMU_FEAT_SEV,
> +			!smmu_cmdq_full(&smmu->cmdq));

[Severity: High]
Does this cause the CPU to stall until a timer event?

When the hypervisor inserts a batch of commands that exceeds the command
queue size, smmu_add_cmd() waits for queue space and passes
smmu->features & ARM_SMMU_FEAT_SEV as the __use_wfe argument to
smmu_wait(), executing wfe().

However, the SMMU only generates an SEV on a CMD_SYNC with CS_SEV. Since
hw_lock prevents concurrent insertions and the hypervisor only inserts
CMD_SYNC at the end of the batch, no SEVs are generated while the queue
drains. The CPU sleeps in wfe() and relies solely on the timer event
stream to wake up, introducing massive artificial delays. Stalling EL2
with interrupts masked for milliseconds degrades system stability and
risks triggering timeouts.

> +	if (ret)
> +		return ret;
> +
> +	smmu_add_cmd_raw(smmu, cmd->data);
> +	writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
> +	return 0;
> +}
> +
> +static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	int ret;
> +	struct arm_smmu_cmd cmd;
> +
> +	hyp_assert_lock_held(&smmu->hw_lock);
> +	cmd =3D arm_smmu_make_cmd_sync(CMDQ_SYNC_0_CS_SEV, 0);
> +	ret =3D smmu_add_cmd(smmu, &cmd);
> +	if (ret)
> +		return ret;
> +
> +	return smmu_wait(false, smmu_cmdq_empty(&smmu->cmdq));

[Severity: High]
Is the WFE logic swapped between smmu_add_cmd() and smmu_sync_cmd()?

Here, smmu_sync_cmd() inserts a CMD_SYNC with CS_SEV, which will
explicitly generate an SEV upon completion. Yet it passes false for
__use_wfe to smmu_wait(), forcing a busy-wait (cpu_relax()) and ignoring
the precise hardware SEV wakeup it requested.

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D15
