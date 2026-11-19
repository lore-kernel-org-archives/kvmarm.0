Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795080063;
	b=kSLRA8NIxJmotUHzEjVGIUqfek8DWFZAcX/bIxuIXydPcVEALfTkkslU+e1L2PWW0p63
	 i/KBvSKiuddvVPbNRfBIOmHP3af6WMcnmhNGe0ujm9Yh3gdlTLBpZaZBUUAAHf+F/9ARS
	 qC0ENoTkGddz+dNqKvRtTn481ZjyWwScnVLV5NAw+HoW0k0+5Vr6P6pfNK1q6MVXOKZM8
	 E1/oY6UIgoN4l3OkE7yFF1wHylxqdYvAS52Jml9QO5szE9V7IawSdCsbKtO7EaQ2wBhBP
	 rToVCHNxY/PVcWonXUh4Jiwnqp//+/HxeOYKL8PErDlx8YQyLceiyGjI4V7Qdv+Ajwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795080063;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MHmSvi+OV5jvzgmq7bDM3AnXPuRNc02JZ6sNTDteMaA=;
	b=cdIBhfLvOEDjQCHnIH08JbyDbM1GphduPfRU9qTsHpEvBqjfJrGC55s35qEz402isfZ4
	 euM8sDmLMXD2sG7Mw9iJ+7d/nrragohd/igTZ+7s1X4/EmthWopR6t+QaiHEUgZB97pxS
	 4KYU476KOtY3+Ds2SP/ZIP3bpRohV9qraewMCGDPfRqt92VSX9eWaPVNmOAx7EtNPEFHb
	 QZJmM/iYsSb/IS5EVUlATQSZX0xYh3xj9nvlyT5uB88+CeAf/0VyRd9yI6s4e6rqBr7Eq
	 kXouO/ah019m5pv2z/1Bg3IIeQw25XNRuwvxpiIsK/JpqiKEvMhhfkgYBsNqOuPdkTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0KB9hpE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE6C606A320;
	Thu, 19 Nov 2026 09:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0KB9hpE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2EF1F000C4;
	Thu, 19 Nov 2026 09:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795080063;
	bh=MHmSvi+OV5jvzgmq7bDM3AnXPuRNc02JZ6sNTDteMaA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X0KB9hpEszO4cFFTR1ylLsmmt9D7ZRQLAzApPc6Ss9PKH4pJXE1Y2Et6Dhrw6PIfF
	 r0lLYqwRsStrnTW16ABdEvhR1I7W9Swak3mrJoiUKoc02LTvsOlyc7BCHuMX2CjLnf
	 bLKUHfoB0prmTa6f8KCsAbzq+7IzkPThl3E5LN3PP7/LWRC9SvCNgITekZLyl/Qh61
	 79DSaJvyP39Hh8TLpvgzkOtqhGDM5teCt9UZvlqzMppMMc1GIzVV6ioWQcbbgPeKTX
	 uhY257jgE9Y7NuYjppVmzPtX50On/TC6XlSCvwCRqO2mxoaV38dvR3x/eMgn2xusVt
	 c0gshZJzfd/yQ==
Message-ID: <sashiko-outbox-222816@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/5] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
 Erratum E#030003
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tomohiro Misono" <misono.tomohiro@fujitsu.com>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261119-monaka-fix-for-upstream-v3-4-057df4d2ca3c@fujitsu.com>
References: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
 <20261119-monaka-fix-for-upstream-v3-4-057df4d2ca3c@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 09:21:02 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] irqchip/gic-v3: unused variable gic_fujitsu_030003_erratum on
  ARM !SMP
--

commit f40f855ff6d7f791ef5d86b82bce961af1c3d29b
Author: Kohei Enju <enju.kohei@fujitsu.com>

irqchip/gicv3: Add workaround for FUJITSU-MONAKA Erratum E#030003

This commit adds a quirk for FUJITSU-MONAKA Erratum E#030003 to send SGIs
by writing to the target redistributor's GICR_ISPENDR0 register instead of
the ICC_SGI*R_EL1 system registers.

> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 94873646d46fb..18f8b2b40543a 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -80,6 +80,8 @@ static DEFINE_STATIC_KEY_FALSE(gic_nvidia_t241_erratum);
> =20
>  static DEFINE_STATIC_KEY_FALSE(gic_arm64_2941627_erratum);
> =20
> +static DEFINE_STATIC_KEY_FALSE(gic_fujitsu_030003_erratum);
> +
>  static struct gic_chip_data gic_data __read_mostly;
>  static DEFINE_STATIC_KEY_TRUE(supports_deactivate_key);
> =20

[Severity: Low]
Does defining gic_fujitsu_030003_erratum unconditionally trigger a
-Wunused-variable warning when building with CONFIG_ARM=3Dy and
CONFIG_SMP=3Dn?

Its only two users are gic_ipi_send_mask() (under #ifdef CONFIG_SMP) and
gic_enable_quirk_fujitsu_030003() (under #ifdef CONFIG_ARM64), so both are
compiled out on 32-bit ARM UP builds.  Marking it __maybe_unused (like
broken_rdists earlier in the file) or guarding it with #ifdef CONFIG_SMP
would avoid the warning.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-monaka-fix=
-for-upstream-v3-0-057df4d2ca3c@fujitsu.com?part=3D4
