Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44339FCBF
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083959; cv=none; b=tQiwZAC9SdRYau9DH6idS+0TC120by0FdNTMjE54Ig9npdSd32XfNPiiSNKWYOtQ0GwAOJBb8tp69p+xozdpxqbVbwfjB/N1Z6ciddzgRRfY/G0+1TY1P2R6iyUIpr7tL/F8PubThXADwzn5rlndFTpd0vpHaVRxWnLZ2Gd/P4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083959; c=relaxed/simple;
	bh=M41UJv0eEz26R7QZjVfNCC/PCDnK6NK5QsuSC2t++kc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=leKJwINliMu4fX6C6NpQ0bU78f1hOPNA3JP1hayeD7P9bYuViiV1vnjkwWA3EbcIR4ls+VxAquPtmkhvsLjFIoc8V2nuQRVQfngLm9E3vxM2TwAbf7FX5OAdUr1AFfiOAmNj/PQqsf4uJRufoW3gHCuLH6Rc+DL6YQPCEX33JIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6ZF3l62; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6ZF3l62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5381F000FF;
	Tue, 22 Sep 2026 13:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083957;
	bh=Rb39+WpH+32bWHJJZZNJUaKFYOnByksxMvZPqKN2X98=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i6ZF3l62GJDHoEkuWXHFZr0sfrO9CLi/GoGREBXjUKdOPN/QRwNudKFcTDo3BSGlj
	 QFi1W+efl/+t1tFANbrH440DdnF51VeH8Pm2+Y35whkxu2cU/+h/OXaEZNNdh8gNLx
	 vgyLvFYarKuWifaYNCYBDd59QV6VhSAsHxz9yAvavgcy0jZdhbLMQfS8gObbuTiwz9
	 TKS3LoBnoyOBvzbI3Zc4mELWN153RrGB603ik6Hyp2zowPqWGw3wSlc8x4U5qhRFse
	 QuWFuTc1wmjRHkLYTpCR2G8tUDyBmOjIZsvrx5E66dyGK00SeRfUO2uqjY7ikAhBZA
	 n/WTgSaK9KznQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 16/25] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260922131259.2975334-17-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-17-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:32:36 +0000
Message-Id: <20260922133237.5A5381F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] arm-smmu-v3-kvm: Incomplete CMD_SYNC filtering allows arbitrary MS=
I DMA writes
- [Medium] arm-smmu-v3-kvm: Data races on concurrent MMIO writes corrupt hy=
pervisor state
- [Medium] arm-smmu-v3-kvm: Misuse of WARN_ON() for untrusted host inputs p=
anics hypervisor
- [Low] arm-smmu-v3-kvm: Unnecessary wfe() sleep when waiting for CMDQ empt=
iness causes CPU stalls
--

commit 59e5e956f9f689e4dbd688035f21063722fbd640
Author: Mostafa Saleh <smostafa@google.com>
Subject: iommu/arm-smmu-v3-kvm: Emulate CMDQ for host

This commit adds emulation for the host command queue in the ARM SMMUv3
hypervisor. It prevents direct access to the command queue from the host,
intercepting writes to CMDQ_PROD and CMDQ_CONS to sanitize commands and
manage the queue lifecycle.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/i=
ommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> index 38b8ecc5cc10c..8c67e348f4a30 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
[ ... ]
> @@ -340,6 +339,105 @@ static int smmu_init(void)
>  	return ret;
>  }
> =20
> +static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64=
 *command)
> +{
> +	u64 type =3D FIELD_GET(CMDQ_0_OP, command[0]);
> +
> +	switch (type) {
[ ... ]
> +	case CMDQ_OP_CMD_SYNC:
> +		if (FIELD_GET(CMDQ_SYNC_0_CS, command[0]) =3D=3D CMDQ_SYNC_0_CS_IRQ) {
> +			/* Do not allow MSI */
> +			command[0] &=3D ~CMDQ_SYNC_0_CS;
> +			command[0] |=3D FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
> +			command[1] &=3D ~CMDQ_SYNC_1_MSIADDR_MASK;
> +		}
> +		break;

[Severity: High]
Does this regression leave the reserved CS value unfiltered? In
smmu_filter_command(), if the host submits a CMD_SYNC command with the CS
field set to 0b11 (Reserved), the filter only sanitizes MSIADDR if CS is
exactly 0b01 (IRQ). Thus, a command with CS=3D0b11 could bypass the filter
unmodified. If the hardware implementation aliases 0b11 to 0b01, this could
allow the host to perform arbitrary DMA writes to hypervisor memory.

> +	default:
> +		/* Deny unknown commands */
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	u64 *host_cmdq =3D hyp_phys_to_virt(smmu->cmdq_host.base_dma);
> +	bool use_wfe =3D smmu->features & ARM_SMMU_FEAT_SEV;
> +	u64 cmd[CMDQ_ENT_DWORDS];
> +	int idx, ret;
> +	u32 pending;
> +	bool skip;
> +
> +	if (!is_cmdq_enabled(smmu))
> +		return 0;
> +
> +	pending =3D (1 << (smmu->cmdq_host.llq.max_n_shift)) - queue_space(&smm=
u->cmdq_host.llq);
> +
> +	hyp_spin_lock(&smmu->hw_lock);
> +	/* Wait for the command queue to have some space. */
> +	ret =3D smmu_wait(use_wfe, smmu_cmdq_has_space(&smmu->cmdq, pending));
> +	if (ret) {
> +		hyp_spin_unlock(&smmu->hw_lock);
> +		return ret;
> +	}
> +
> +	while (pending--) {
> +		int i;
> +
> +		idx =3D Q_IDX(&smmu->cmdq_host.llq, smmu->cmdq_host.llq.cons);
> +		queue_inc_cons(&smmu->cmdq_host.llq);
> +
> +		/* Copy the command to local buffer avoiding TOCTOU */
> +		for (i =3D 0; i < CMDQ_ENT_DWORDS; ++i)
> +			cmd[i] =3D le64_to_cpu(READ_ONCE(host_cmdq[idx * CMDQ_ENT_DWORDS + i]=
));
> +
> +		skip =3D smmu_filter_command(smmu, cmd);
> +		if (WARN_ON(skip))
> +			continue;

[Severity: Medium]
Is this regression safe when using WARN_ON() for untrusted host inputs? At
EL2, WARN_ON() expands to a fatal BRK instruction, causing a hypervisor
panic. If the host writes a malformed command, this could allow a
host-triggered denial of service. Should the code error out or ignore the
command instead? I also noticed similar WARN_ON() assertions in
smmu_dabt_device() when handling an invalid register access size.

> +		smmu_add_cmd_raw(smmu, cmd);
> +	}
> +
> +	writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
> +
> +	ret =3D smmu_wait(use_wfe, smmu_cmdq_empty(&smmu->cmdq));

[Severity: Low]
Could this regression cause the CPU to stall? The smmu_wait() loop uses wfe=
()
to wait for the hardware queue to empty, but the hardware only generates an
SEV on a CMD_SYNC command. If the host submits commands without a CMD_SYNC,
the CPU could stall in wfe() until a random interrupt wakes it up or the 1ms
timeout expires, leading to unnecessary latency.

> +	hyp_spin_unlock(&smmu->hw_lock);
> +	return ret;
> +}
[ ... ]
> @@ -381,18 +479,51 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3=
_device *smmu,
[ ... ]
>  	case ARM_SMMU_CMDQ_PROD:
> +		if (len !=3D sizeof(u32))
> +			break;
> +		if (is_write) {
> +			smmu->cmdq_host.llq.prod =3D val;
> +			WARN_ON(smmu_emulate_cmdq_insert(smmu));

[Severity: Medium]
Could this regression allow multiple threads concurrently mutating
smmu->cmdq_host.llq.prod outside smmu->hw_lock to corrupt the queue state?
Modifying this value without a lock could allow concurrent host writes to
decouple the pending calculation from the consumer index.

Similarly, I see in smmu_dabt_device() that ARM_SMMU_CR0 is modified
locklessly when calling smmu_emulate_cmdq_enable(). Could concurrent writes
from multiple CPUs cause hypervisor panics due to double page
sharing/unsharing or queue desynchronization?

> +			goto out_ret;
> +		} else {
> +			val =3D smmu->cmdq_host.llq.prod;
> +			goto out_update_regs;
> +		}
>  	case ARM_SMMU_CMDQ_CONS:
> +		if (len !=3D sizeof(u32))
> +			break;
> +		if (is_write) {
> +			if (WARN_ON(is_cmdq_enabled(smmu)))
> +				break;

[Severity: Medium]
Could this regression allow the host to panic the hypervisor by attempting =
an
invalid state transition (writing to CONS while the queue is enabled)? Like
the other WARN_ON() usages for host inputs, this should likely be an error
return instead of an assertion.

> +
> +			smmu->cmdq_host.llq.cons =3D val;
> +			goto out_ret;
> +		} else {
> +			/* Propagate errors back to the host.*/
> +			u32 cons =3D readl_relaxed(smmu->base + ARM_SMMU_CMDQ_CONS);
> +
> +			val =3D smmu->cmdq_host.llq.cons | (CMDQ_CONS_ERR & cons);
> +			goto out_update_regs;
> +		}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D16
