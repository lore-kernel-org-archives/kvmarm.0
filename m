Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F6625F994;
	Fri,  3 Jul 2026 16:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095772; cv=none; b=RadR3EeBZlcYLzvUrNGwC1hdD6krvIeJu/quThLHK3sxHu9ntb+2w1OV3FVwl+lD25cliIr//6vcEdXKD1ECO1ohP0OwouB7y45y0o1KO1oW8imqPA/6CQlZQq80fKlpQGn4nqwB/dEwWLJHpHWgLGkbX2XaTnLvkO8sHwKaITQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095772; c=relaxed/simple;
	bh=7tX+Is8S6ryg6lsBbB1kXBtC4dMNh6MPFz2oVJVByV0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pf+41x+4qdAduHdClcDzqN+ZuYGMTk5UbEpjc0wInrr5qRojXQ4sDwU2qaD1ZKmYmxs/8SkZdgJTvOYxBBkbbZHSy2F4DS6x2PwE5ik8DPppxgrZgtZXNCQt1vPXia2TmtBl3SFyXKcWfHTJxML02oYH0V1wcOWl3c2z8Ytpgs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQbijA4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQbijA4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8B11F000E9;
	Fri,  3 Jul 2026 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783095771;
	bh=LQiG1pbIcPaZgVyQOoxX7qgVd5js1Qz8lujx9Y37oIw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SQbijA4nCSinquwZH/EXrtv8W64wKKffEjf6SMslf9RkgI57RU0vKKTlmDIe9MROp
	 x85rOW1pGgKrFU2FJXbTT7dut7EnBe+orAEQ52XMdRDxxcDpFrEdywLBQtJU6c/h1G
	 EQrhqsXXyz/8d2u53icMdfBqvN4dkiNNHVLQi8ppaEm+8nIPKhrfZUIixUdnwwrJMg
	 ca+flcIPL8B9cjRgIBRGgfykg4y5ICl++EYHSBoiraD31TchQ7SAtVmKCjqC5IVeH0
	 YM8snRjCOYFOh2awO9HQwtU3XTtiwyAIXP0n4XjPiTt4kfxAzrsULpOxRow51eG56N
	 EMZUlr7vghCTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/40] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-7-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-7-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:22:50 +0000
Message-Id: <20260703162250.AC8B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Writes to control-plane system registers (e.g., ICC_CR0_EL1, ICC_P=
CR_EL1, ICC_PPI_ENABLERx_EL1) are not followed by an immediate isb() instru=
ction.
--

commit a711c6a81167d568ab1f95533a38518adf17a484
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields

This commit updates the sysreg generator definition for ICC_CR0_EL1 to
include the LINK and LINK_IDLE fields, which have been added to the
architecture.

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 6c3ff14e561e6..57ab09404267c 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3736,7 +3736,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
>  Res0	63:39
>  Field	38	PID
>  Field	37:32	IPPT
> -Res0	31:1
> +Res0	31:3
> +Field	2	LINK_IDLE
> +Field	1	LINK
>  Field	0	EN
>  EndSysreg

[Severity: High]
This isn't a bug introduced by this patch, but since it updates the definit=
ion
of ICC_CR0_EL1, I noticed that writes to control-plane system registers (e.=
g.,
ICC_CR0_EL1, ICC_PCR_EL1, ICC_PPI_ENABLERx_EL1) are missing immediate isb()
synchronization in several places.

For example, in drivers/irqchip/irq-gic-v5.c:gicv5_cpu_disable_interrupts():

	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
}

And in drivers/irqchip/irq-gic-v5.c:gicv5_cpu_enable_interrupts():

	pcr =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY, GICV5_IRQ_PRI_MI);
	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);

	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 1);
	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);

There are also instances where multiple writes are batched without an immed=
iate
isb() in between, such as in gicv5_cpu_enable_interrupts():

	write_sysreg_s(0, SYS_ICC_PPI_ENABLER0_EL1);
	write_sysreg_s(0, SYS_ICC_PPI_ENABLER1_EL1);

	gicv5_ppi_priority_init();

And in drivers/irqchip/irq-gic-v5.c:gicv5_ppi_priority_init():

	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_PRI_MI), SYS_ICC_PPI_PRIORITYR0_EL1);
	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_PRI_MI), SYS_ICC_PPI_PRIORITYR1_EL1);

The exact same missing isb() patterns appear in the selftest implementations
in tools/testing/selftests/kvm/include/arm64/gic_v5.h.

Could this leave the CPU operating under an architecturally undefined pipel=
ine
state? According to architectural rules, every write to a control-plane sys=
tem
register (including all ICC_*_EL1 registers except ICC_PMR_EL1) must be
followed by an isb() as the very next instruction.

Batching writes or executing any instruction between the write and the isb()
might lead to unpredictable behavior, spurious traps, or kernel panics.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D6
