Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA2F599A3C
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096242; cv=none; b=Ioo9xRuk4dJjIkkv91icUb8Z/87NgUOsxxU16IAe61WcEKyG3JGnb26R5fcHxybw7TMQ6pB5hKOIFVqLdC0mCePloZtcY2P9CYJdW667C4qYDlOh2NzIAmxRS6TRZM8dBsduPBMR3ov78AoKsNsY2xYf5tPYQ17i6QJXIMN4eqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096242; c=relaxed/simple;
	bh=dbYinMRfNSaRhnm5ymxNCSAly5B7UZ7AwMkvswqnvPE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DUkxjdV+u6ET4DBNK4kyemnQerZDQqbDM3iWBxBtm+B/dUyoRYnRepEaH51YdcR8LV8h7Vjx475IwW8GJqftGyrZyFf4joeRKhoArZalDX6Y50PYQdIl1/E7wmrsTkTJl8k9HYFdl38M7l75D3y9mpLd5nna+iiWrMFQ/RK1++0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZ1T0XnG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZ1T0XnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018CA1F000C4;
	Thu, 15 Oct 2026 20:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096233;
	bh=HJnZD4RDu4a+hzaO8iJANrGP8qFruTQcIXNr20l2So8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fZ1T0XnGAVZ/f+8+4Rw6aSCsl9LQZgqBhd5bInZI5O94zmv9oWzenTp4sW5R7/khb
	 VBFmPUVrpEP0bm/cuZLpW5yVOlvAoEBXwN7/F2hcUW7rcWlN79qpoEGBZ8NyYltXzh
	 UAU6TCh5lzfaiRMV8vLtW6N+gdlPdNXm6e9B/g7bvDeSPPkakUSR0xdz6gp4PpT0g3
	 BuMfINxuau8w+LXU5flf5URex6Lket2QPJRmjFxJ8rANvBUuPOIYxBn5ZfyqCtAomy
	 ttCieTK7yR9kOGYyEO+NAFpAWDbwonE2xPkWxkSeoh+WB8HuGTQMWD/4iHnpWE275l
	 Tijd54TkcZqsw==
Message-ID: <sashiko-outbox-173396@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 16/25] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-17-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-17-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:30:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] iommu/arm-smmu-v3-kvm: user-triggerable hyp panic via unhandle=
d SMMU commands (e.g., CMDQ_OP_ATC_INV)
- [Critical] iommu/arm-smmu-v3-kvm: CMD_SYNC filter allows arbitrary memory=
 writes via SIG32
- [High] iommu: EL2 panic on SMMU hardware timeout or CERROR due to WARN_ON
- [Medium] arm-smmu-v3-kvm: Dead-branch traps due to WARN_ON() panicking at=
 EL2
--

commit 44f2b5e9d53208cadd7d659b59bf05189d20f72d
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Emulate CMDQ for host

This commit introduces command queue emulation for the host in the ARM SMMU=
v3
pKVM driver. It filters command queue entries, shadows the queue, and preve=
nts
the host from directly manipulating the hardware command queue to ensure is=
olation.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> index c9fc21e405e79..dc9b1e659a422 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
[ ... ]
> +static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64=
 *command)
> +{
> +	u64 type =3D FIELD_GET(CMDQ_0_OP, command[0]);
> +
> +	switch (type) {
[ ... ]
> +	case CMDQ_OP_TLBI_NH_ASID:
> +	case CMDQ_OP_TLBI_NH_VA:
> +	case CMDQ_OP_TLBI_NH_ALL:
> +	case 0x13: /* CMD_TLBI_NH_VAA: Not used by Linux */
> +	{
> +		/* Only allow VMID =3D 0 */
> +		if (FIELD_GET(CMDQ_TLBI_0_VMID, command[0]) !=3D 0)
> +			return true;

[Severity: Critical]
Could this reject valid nested-translation TLBI commands? A host userspace
process with IOMMUFD nested translation might legitimately trigger invalida=
tion
commands (like CMDQ_OP_TLBI_NH_VA) where the host injects a non-zero VMID.

Because this returns true, the command gets rejected, which later leads to a
hypervisor panic (see below) triggered directly from userspace.

> +		break;
> +	}
> +	case CMDQ_OP_PREFETCH_CFG:
> +	case CMDQ_OP_CFGI_CD:
> +	case CMDQ_OP_CFGI_CD_ALL:
> +	case CMDQ_OP_TLBI_NSNH_ALL:
> +	case CMDQ_OP_PRI_RESP:
> +	case CMDQ_OP_RESUME:
> +		break;
> +	case CMDQ_OP_CMD_SYNC:
> +		if (FIELD_GET(CMDQ_SYNC_0_CS, command[0]) =3D=3D CMDQ_SYNC_0_CS_IRQ) {
> +			/* Do not allow MSI */
> +			command[0] &=3D ~CMDQ_SYNC_0_CS;
> +			command[0] |=3D FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
> +			command[1] &=3D ~CMDQ_SYNC_1_MSIADDR_MASK;
> +		}

[Severity: Critical]
Does this allow the host to inject an SMMU hardware instruction that execut=
es
an arbitrary physical memory write? The filter specifically neutralizes CS=
=3D1
(IRQ), but it appears to ignore CS=3D3 (SIG32). If a malicious host issues a
CMD_SYNC with CS=3D3, the hardware might perform a 32-bit physical memory w=
rite
of the host-provided MSIData to the host-provided MSIAddress, compromising =
the
hypervisor or guest memory.

> +		break;
> +	default:
> +		/* Deny unknown commands */
> +		return true;

[Severity: Critical]
Could valid user-triggerable commands hit this default case? For example,
CMDQ_OP_ATC_INV appears to be missing from the allowlist. Since it returns
true, this will also result in a user-triggerable hypervisor panic when the
caller evaluates the rejection.

> +	}
> +
> +	return false;
> +}
> +
> +static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
> +{
[ ... ]
> +		skip =3D smmu_filter_command(smmu, cmd);
> +		if (WARN_ON(skip))
> +			continue;

[Severity: Medium]
Will this execute the continue statement? At EL2 in nVHE/pKVM, WARN_ON() ex=
pands
to a BRK instruction and triggers a fatal hypervisor panic. Because the mac=
ro
doesn't return, the error-handling path is dead code, and rejecting a comma=
nd
results in a hard panic.

This also elevates the severity of the filter rejections mentioned above. If
userspace can trigger a rejected command (like CMDQ_OP_ATC_INV or a nested
TLBI with VMID !=3D 0), it becomes a Denial of Service attack against the h=
ost
system.

> +		smmu_add_cmd_raw(smmu, cmd);
> +	}
> +
> +	writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
> +
> +	ret =3D smmu_wait(false, smmu_cmdq_empty(&smmu->cmdq));
> +	hyp_spin_unlock(&smmu->hw_lock);
> +	return ret;
> +}
[ ... ]
> +static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> +			     struct user_pt_regs *regs,
> +			     u64 esr, u32 off)
> +{
[ ... ]
> +	case ARM_SMMU_CMDQ_PROD:
> +		if (len !=3D sizeof(u32))
> +			break;
> +		if (is_write) {
> +			smmu->cmdq_host.llq.prod =3D val;
> +			WARN_ON(smmu_emulate_cmdq_insert(smmu));

[Severity: High]
Can a hardware timeout or CERROR cause a hypervisor panic here?
smmu_emulate_cmdq_insert() relies on smmu_wait() to check if the hardware
command queue is empty. If the SMMU hardware halts due to an error or takes
too long under heavy load, smmu_wait() returns -ETIMEDOUT.

Because the return value is wrapped in WARN_ON(), this timeout will be
converted into a fatal EL2 panic instead of propagating the error.

> +			goto out_ret;
> +		} else {
> +			val =3D smmu->cmdq_host.llq.prod;
> +			goto out_update_regs;
> +		}
> +	case ARM_SMMU_CMDQ_CONS:
> +		if (len !=3D sizeof(u32))
> +			break;
> +		if (is_write) {
> +			if (WARN_ON(is_cmdq_enabled(smmu)))
> +				break;

[Severity: Medium]
Similar to the dead-branch trap above, the break statement here appears to =
be
unreachable code. Because WARN_ON() expands to a fatal BUG() at EL2, writing
to the CMDQ_CONS register when the queue is enabled will panic the hypervis=
or
instead of just ignoring the write.

> +
> +			smmu->cmdq_host.llq.cons =3D val;
> +			goto out_ret;
> +		} else {
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D16
