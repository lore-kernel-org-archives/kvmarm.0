Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A85858B6D1
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096485; cv=none; b=lWLw1GnTEFKoDBROMcM6+RhF6oBt1CYRM9aHV/YAlzwF1Ql+8Mf0lid7njbpOUByOeLuEALtyN71qSds8o52cxGXVzmWn2PtMxvUC440hewLuSbOeaQP4fOVQok+Mj+siIRTTm7HcUoObtl4fxNjqk5kx+gaDvPL9+ac9UfleJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096485; c=relaxed/simple;
	bh=9aJHioqT4i3GB/VQ8aHNPGBdx54g3uYD7EBwQ6eJQww=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Ux6oBgQH8pXRbrmEkSL5/1Mp+V/eK+0KGLZyIQzTX0DRQApH68Dj1oZdZNmgAvMs5VDU5NCJpc0jF+oztz5xus6aDiTS+xCPn6KhaCUX8O6UyzwbUwOBmZf43he0jFzbxT3EHZzdVcHOagngFdk6dgDtd2wfR5sSccnn1m8/WLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDbPILx4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDbPILx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5FF1F000C4;
	Thu, 15 Oct 2026 20:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096483;
	bh=lkUm6iimckqWNjID3uSWjuW/6+xGvgu4O9qQAlTo53g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bDbPILx4ZdQXYQqU8pK8aj/rtLZu+BbAT6vRbsGWffJVNc7+pO/hqgsxD96fFJYtG
	 RIjQwT7A5vE5fUTPJcJxo8lKBzWgyyvZAeVUCGqBa9yBuG1ec5elKKeK+P/1cybwK5
	 dfMQFopWhrItPidU22n0GINav9f5YpJSF2KI14SWwKt7BrO6UMj6eMuEBhCvMuGLVo
	 98K/b3khoAX6jzEBTIJKcHxtbimV6BFT+1sroC2C3wyJIir8TUQzCGb/zUnExRxP0f
	 U+ShOGKyH3Pj8OMfB96w69KwD0CT9EuIxfkOJBJTPKARe6fz4yoeaGf0NxEOgUQnkY
	 uMuhVrXrnAWLA==
Message-ID: <sashiko-outbox-173401@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 24/25] iommu/arm-smmu-v3-kvm: Enable nesting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-25-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-25-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:34:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] iommu/arm-smmu-v3: fatal EL2 panic on host-supplied invalid ST=
E or ENOMEM
- [Medium] arm-smmu-v3-kvm: Incorrect EL2 WARN_ON usage for hardware timeout
--

commit 5625f7b65b03ea88554c9ce7668b1dabbbb068b1
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Enable nesting

This commit enables stage-2 translation for the ARM SMMUv3 under pKVM
by allowing the hypervisor to sanitize and control the stage-2 portion
of the Stream Table Entry (STE).

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> index 01f23fce6be50..3562bb222f53e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
[ ... ]
> @@ -443,6 +443,60 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_dev=
ice *smmu)
> +static int smmu_attach_stage_2(struct hyp_arm_smmu_v3_device *smmu,
> +			       struct arm_smmu_ste *ste)
> +{
[ ... ]
> +	/* S2 is not advertised, that should never be attempted. */
> +	if ((cfg =3D=3D STRTAB_STE_0_CFG_S2_TRANS) ||
> +	    (cfg =3D=3D STRTAB_STE_0_CFG_NESTED))
> +		return -EINVAL;

[Severity: Critical]
Can this error return lead to a hypervisor panic?

When smmu_attach_stage_2() returns -EINVAL, the error propagates to
smmu_filter_command(), which evaluates it and returns true to indicate
the command should be skipped.

The preexisting caller smmu_emulate_cmdq_insert() then processes this
skip condition using WARN_ON:

smmu_emulate_cmdq_insert() {
    ...
    skip =3D smmu_filter_command(smmu, cmd);
    if (WARN_ON(skip))
        continue;
}

At EL2 under pKVM, WARN_ON expands to a fatal breakpoint. Since the host
can supply an invalid STE configuration that triggers this -EINVAL, could
this allow the host to maliciously crash the hypervisor?

Similarly, allocating the L2 table in smmu_reshadow_ste() can fail and
return -ENOMEM, which also propagates into this same fatal WARN_ON path
during an out-of-memory event.

[ ... ]
> +static void smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *wri=
ter)
> +{
> +	struct smmu_ste_writer *ste_writer =3D
> +		container_of(writer, struct smmu_ste_writer, writer);
> +	struct arm_smmu_cmd cfgi_cmd =3D arm_smmu_make_cmd_cfgi_ste(ste_writer-=
>sid, true);
> +
> +	WARN_ON(smmu_send_cmd(ste_writer->smmu, &cfgi_cmd));
> +}

[Severity: Medium]
Is it safe to use WARN_ON for hardware interactions that might time out?

If the SMMU command queue is full and smmu_send_cmd() times out waiting
for it to drain, it will return -ETIMEDOUT. Because WARN_ON is fatal at
EL2 under pKVM, this transforms a transient hardware latency or a heavy
command load into a hypervisor panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D24
