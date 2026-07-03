Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12191270552;
	Fri,  3 Jul 2026 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096134; cv=none; b=pGDVLsYkZ24HwGeG8hdI2A+jJOVgT5cDx0+jOuhERAat+CZKWFt6mB925fWiK1/O/IHiMyptSiVPZBGL63b050vfRkWA/NsW7bChYhkyZSaFPEC33P449s/1QQhSj24q30A9gkSy5DtmrEOJ0X7DnR6rIyrnPhEazoVw2aq9EZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096134; c=relaxed/simple;
	bh=DT3LyXVzI94OIhwK3fAVMv+FqAN3+Np6WogldyTO8i0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BHqnFwUyiGMoQcMTI9mC3+XiQgksYk1yvCEiKAArBJfStn01JiNGMz8ZFuI69OTP1/CxoVmp0qsFsR3BrKZBRbkMHeF5y68kmLcHlNUnJjDTP05bKRFT5usVmn2HQgwiAoc5KNNDOXqg3Y8nwed3ZJuAaj6Slv86nCWVyFQHZgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MeonYVpd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MeonYVpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E357C1F000E9;
	Fri,  3 Jul 2026 16:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096132;
	bh=cdIP2/rWWA9Vs7tVm/puqPCxXAZcZxlYapz6yMFGy5I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MeonYVpdWNVWQsmxBzPY6XhRbF4nkbtR2NwP9AU0fpGeHvQZZarSbs1OlVsLrfiqb
	 WKMxwdvSpT4venay0lnxNl1YE2nLQUDcuFbSv6KDzBWaL5zJVKx4wxlkSVjDDoI+72
	 tz4NtsulG+PdVb6DDbU4u90Npj5mSE7ER0iGFLkHUfZZNZDX0ILFMbfFFfXjhS8jvv
	 SZngZhCP7BU92mxFmphjRbeo4EK0g0BqSYVxGY8g6kbuLy/08DvuVKPPzt2wu3WlLi
	 Us0m8kVi/trwbEF/WSqDud+78IIsq0IVZ6XzxQzcZB5iHyiOQFxWr48RKjnY2yo6ZO
	 aJUgDtz+T+PKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/40] arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG
 encodings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260703154811.3355680-6-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-6-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:28:51 +0000
Message-Id: <20260703162851.E357C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing VM ID in GIC VDRCFG payload causes SPI state corruption fo=
r VMs > 0 or during restore.
--

commit af2100cc7ed8bea5d8db7c7e09a649c12e033d80
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG encodings
   =20
Add the encodings for the GIC VDPEND and GIC VDRCFG system
instructions. These operate on the virtual interrupt domain, and are
used to make interrupts pending for a VM and to read back the
configuration of a VM's interrupts.

> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 7aa08d59d4944..40ff7d25d37b0 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
[ ... ]
> @@ -1105,6 +1105,22 @@
>  #define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
>  #define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
> =20
> +/*
> + * Definitions for GICv5 instructions for the Virtual Domain
> + */
> +#define GICV5_OP_GIC_VDPEND		sys_insn(1, 4, 12, 1, 4)
> +#define GICV5_OP_GIC_VDRCFG		sys_insn(1, 4, 12, 1, 5)
> +
> +/* Shift and mask definitions for GIC VDPEND */
> +#define GICV5_GIC_VDPEND_PENDING_MASK	BIT_ULL(63)
> +#define GICV5_GIC_VDPEND_VM_MASK	GENMASK_ULL(47, 32)
> +#define GICV5_GIC_VDPEND_TYPE_MASK	GENMASK_ULL(31, 29)
> +#define GICV5_GIC_VDPEND_ID_MASK	GENMASK_ULL(23, 0)
> +
> +/* Shift and mask definitions for GIC VDRCFG */
> +#define GICV5_GIC_VDRCFG_TYPE_MASK	GENMASK_ULL(31, 29)
> +#define GICV5_GIC_VDRCFG_ID_MASK	GENMASK_ULL(23, 0)

[Severity: High]
Does GIC VDRCFG also need a VM_MASK definition?

The mask definitions for the GIC VDRCFG payload omit a VM_MASK (e.g.,
GENMASK_ULL(47, 32)), which is present for VDPEND above.=20

Could missing the VM ID in the payload cause the GIC to query the SPI state
for VM 0 instead of the target VM?

This regression might lead to incorrect functional behavior for VMs > 0.
For example, when kvm_vgic_sync_hwstate() calls __vgic_v5_vdrcfg(), an empty
VM ID field could cause the hypervisor to fold the SPI state of VM 0 into t=
he
shadow state of VM > 0.

Alternatively, if the instruction architecturally relies on the resident VM=
 in
ICH_CONTEXTR_EL2 rather than a payload field, would executing it during VM
restore when no vCPU is resident (such as in vgic_v5_restore_spi_ap_list())
fail to work correctly?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D5
