Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBBE392811;
	Fri, 16 Oct 2026 10:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792145549; cv=none; b=fCtm1vJqix19cONzD58VDiq+LgxZ5QXsjhYWEubT0pzSsuC023zjRGwrVLgPvDu0pCuIo0P8wqMNpeXGY1F7l7zQ0m+MHCm3wAzQxRMw364yUc3rtOvR0/MScaaBIAv5z9sXT51NF9E6RnX43fOVR/JCQ5/2vuzUJkw9MXG0MhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792145549; c=relaxed/simple;
	bh=t1louuqsRdcHdBR+jzhfii8trXrcGgQ1nit0V9wK+Nw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=iQDpR9pdK3omQTOEwdxKxvG04H8A6zbwhxL0rhgPZ+bgpqtYsXi2Eh2Efb6JVQExRBi+W52/EsO3B0jupUeUSi3IfCjblWWMTCmPDZVTg1/FS1Wa8QByxytffEN+1KQ4imsBIduDepL157ZOENA5FARsGTcWq0349bNIsOQIfOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2hMQFkw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2hMQFkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0751F000C4;
	Fri, 16 Oct 2026 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792145547;
	bh=6XWGSGz8Vg6vuz0nSsziqkCdd0FRq8W5K11qLvpM3Aw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l2hMQFkwXufdhGUpmmvOXoh+3SnBzv+3i/Ji1IFIXrg2/SMiPo3MBJ9oYZaN2j4Km
	 8CaGVMumsq2s4+8YlgT/RwrblryjEvRu5b5azdVOUnz5aIdYXk/K4GNUTg+4gE1WcM
	 QOlv6JlKF990ZiVWCCbtnivx5tMu+T3Eya81CM4QE2ajN5GSE3JEeubqQkZ8l1NZ5a
	 OdcDXeld/TLJS41WE+m+oWfd6qHjh+uAps16nQ0IV+2pIZnMOeVdEzGieX2HOcIIlf
	 s9RwXI3fJitif69bjgRQn1d06n8FYdc5ZnQsoXo9h+yfRD3QrGR1pEhh9tsnwlQjAt
	 wFzDKLsb3SJtA==
Message-ID: <sashiko-outbox-174127@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
 erratum E#030003
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tomohiro Misono" <misono.tomohiro@fujitsu.com>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261016-monaka-fix-for-upstream-v2-4-fc7ede7f9f48@fujitsu.com>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-4-fc7ede7f9f48@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 10:12:26 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] irqchip/gic-v3: IPI via GICR_ISPENDR0 targets sleeping redistribut=
or
- [High] irqchip/gicv3: missing NULL check on rd_base causes IPI sender cra=
sh
--

commit 98989a1fb6fe6471377f9b9c4a24e0097c1639a3
Author: Kohei Enju <enju.kohei@fujitsu.com>

irqchip/gicv3: Add workaround for FUJITSU-MONAKA erratum E#030003

This patch works around a FUJITSU-MONAKA erratum where SGIs are lost if an
SGI generation races with CPU interface processing. It addresses the issue
by bypassing the affected system registers and directly writing to the targ=
et
CPU's GICR_ISPENDR0 over MMIO.

> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
[ ... ]
> @@ -1386,6 +1391,17 @@ static void gic_ipi_send_mask(struct irq_data *d, =
const struct cpumask *mask)
>  	 */
>  	dsb(ishst);
> =20
> +	if (static_branch_unlikely(&gic_fujitsu_030003_erratum)) {
> +		for_each_cpu(cpu, mask) {
> +			void __iomem *base =3D gic_data_rdist_sgi_base_cpu(cpu);

[Severity: High]
Could this cause a fatal page fault on the CPU sending the IPI if the target
CPU failed to initialize its redistributor?

If a secondary CPU fails to initialize its GIC redistributor due to a buggy
ACPI MADT or missing DT entry, rd_base remains NULL. However, the CPU can
still come online because gic_starting_cpu() returns 0 on failure.

When another CPU later broadcasts an IPI, this workaround will derive base
from a NULL rd_base, resulting in an unmapped address (0x10000). The sender
CPU will then crash when attempting the writel_relaxed().

Should we validate that the target CPU actually has an initialized
redistributor base before bypassing the architected SGI system registers?

> +
> +			writel_relaxed(BIT(d->hwirq), base + GICR_ISPENDR0);

[Severity: High]
Is it safe to write to a target CPU's GICR_ISPENDR0 directly over MMIO when
that CPU might be in deep idle?

During deep idle, such as via PSCI, the target CPU's redistributor is put
to sleep (ProcessorSleep=3D1 either via gic_cpu_pm_notifier or firmware).
According to the GICv3 architecture, writing to a redistributor register
(other than GICR_WAKER or GICR_TYPER) when ProcessorSleep=3D1 is constrained
unpredictable.

Normal kernel operations, like the scheduler sending smp_send_reschedule()
to an idle CPU, will hit this path. If the hardware ignores the write, the
IPI is dropped, which can lead to deadlocks in smp_call_function() or lost
wakeups.

> +		}
> +
> +		dsb(st);
> +		return;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016-monaka-fix=
-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com?part=3D4
