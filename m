Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B7476CF6;
	Fri,  7 Aug 2026 12:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786105097; cv=none; b=LIii0nMQgfo+iSezAbLiNah12uQsZj/AFzyL9DPudyfNHUkDktQc2ReLRTuUflPG3zFwuMgzVMVp8CmUom7dy13qV5wz3XydhIcOY2V85tuYxmk36mroKl0xH6YIeHtF5CEz1v23no9vQkxM4D4cyCV7lns+fPQ2EFPSuYc5hWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786105097; c=relaxed/simple;
	bh=5qTXkauWE4iBU09obROsMqO6FBiuubrb9fHPY9tAuXc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qhbpgcpDI4m2fM9i1ZEZpvGbeFf+HdFVx7PdRszjxhyxpug+Y694LuKYuom9GYj4Egw3Ww5Wk3PnyYo2uwgmjsjIiELR5c+K6ls2PZRlqTRFPkKNz/bbRvmAFMZN/Ghgpn/YswvqZ29O9AWhwrbPFQUKENlkotfx04z+kWe9EMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZcpZ8wi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZcpZ8wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B7A1F00A3A;
	Fri,  7 Aug 2026 12:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786105024;
	bh=DYmoo2pETUDkHSzKNwjvfH5jU+Y/5h0MdnUOxsMirUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nZcpZ8wiQBrZP/TP5vEoJMHaf11/0fKirEy1Q1q0cAKM6bAx9DLvstggQKO8h0bFl
	 Nq4cnLb3rutqZTS8Zh8HXDwpw/cW3ji91JY8d/25XEVcrV9aH4XaR7iVvhjFQ/glyq
	 9uDpVNwdh8JZtwurfQSNHKe3CkIYGOyMinFnaxw0KhQo6UcSFpKs/GmMRuhXtpngoq
	 D9HWKCpCVL64xJ+5Y33wDWTql6nq/SBSg6PfjIBNxha4tZZnDNqZm1WXBaltg4cJ6G
	 L8ML8Shl43GcfEv0NbPqiR2m8rA2ZeNrQGWTMzQ53kQRHtJMtmAEECGd9EVKcX+SCU
	 n6YjZ3FUDTBqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-7-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-7-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 12:17:02 +0000
Message-Id: <20260807121703.D4B7A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing Context Synchronization Event (ISB) after control-plane sy=
stem register writes.
- [High] CONSTRAINED UNPREDICTABLE instruction encoding when emitting syste=
m instructions that structurally demand a specific fixed register (e.g., `C=
DEOI`).
- [Medium] Potential clobbering of newly defined `LINK` and `LINK_IDLE` fie=
lds in `ICC_CR0_EL1` due to absolute writes.
--

--- Patch [6]: [PATCH v5 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK =
and LINK_IDLE fields ---
commit 0855c41ea55b7d483129dc1d181e0c36c00b65e4
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
   =20
This commit adds the LINK and LINK_IDLE fields to the ICC_CR0_EL1 sysreg
definition. These fields were missing since the register was added to the
generator.

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index e070ada06196f..ed59330ba51c0 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3737,7 +3737,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
>  Res0	63:39
>  Field	38	PID
>  Field	37:32	IPPT
> -Res0	31:1
> +Res0	31:3
> +Field	2	LINK_IDLE
> +Field	1	LINK

[Severity: Medium]
This isn't a bug introduced by this patch, but does the initialization
code handle these new fields correctly?

If LINK and LINK_IDLE are expected to retain firmware-configured or default
reset values, using an absolute write to initialize only the EN bit will cl=
ear
them to zero, potentially breaking hardware functionality.

For instance, this pattern is seen in drivers/irqchip/irq-gic-v5.c in
gicv5_cpu_enable_interrupts():

	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 1);
	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);

A similar absolute write clearing the newly defined bits is also present in
tools/testing/selftests/kvm/include/arm64/gic_v5.h.

Could you confirm if the consumers are robust to this change?

[Severity: High]
This is a pre-existing issue, but I noticed a missing context synchronizati=
on
event after control-plane system register writes in the GICv5 driver.

Executing instructions in an architecturally undefined pipeline state can r=
esult
in unexpected exceptions, corrupted accesses, or dropped interrupts.

Multiple functions batch writes to ICC_*_EL1 registers or return immediately
after a write without issuing an isb().

For example, in drivers/irqchip/irq-gic-v5.c:gicv5_cpu_disable_interrupts():

	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
}

A similar pattern batches consecutive writes in gicv5_cpu_enable_interrupts=
():

	write_sysreg_s(0, SYS_ICC_PPI_ENABLER0_EL1);
	write_sysreg_s(0, SYS_ICC_PPI_ENABLER1_EL1);

Are these writes supposed to have an isb() as the very next instruction to
synchronize the pipeline?

[Severity: High]
This is a pre-existing issue, but is there a risk of constrained unpredicta=
ble
instruction encoding when emitting system instructions like CDEOI?

The write_sysreg_s macro relies on the compiler's "rZ" constraint for regis=
ter
allocation.

System instructions like GIC CDEOI architecturally mandate the use of XZR
(register 31). Allowing the compiler to select an arbitrary general-purpose
register containing zero misencodes the instruction.

This occurs in tools/testing/selftests/kvm/include/arm64/gic_v5.h:

	#define gic_insn(v, insn)	write_sysreg_s(v, GICV5_OP_GIC_##insn)

and is used in drivers/irqchip/irq-gic-v5.c:gicv5_handle_irq():

	gic_insn(0, CDEOI);

Should this be hardcoded to use XZR to prevent the hardware from treating it
as constrained unpredictable?

>  Field	0	EN
>  EndSysreg

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D6
