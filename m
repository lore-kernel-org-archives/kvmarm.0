Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A55481256;
	Fri,  4 Sep 2026 12:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524100; cv=none; b=dwWyRRCbTiFFNNaj2XS8hMkIhrbQxe4ZxZI1hl23y9wZxuEUWzQkfHymgikL8OQK99rihncZCd3AX8nBACo/6GqiLD1uHyEbVWuomiuSFdC5d2gXN/DtNlsmWp01dBPFgsolc4CjlPcyNyR44NWDn8QVZ3BMiwdJwJKwwk73VMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524100; c=relaxed/simple;
	bh=zhamTrL8FEsmE7nThaJYUK3rl+DWh6TRfkBjSr+EHBQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aNIx4ypg6pETXGq7KQsPJmkOZM1E2G/auIo3jR30Vov8qsO4Kjph+mjHO7zsXANz3wLeGERyDngWptgPIJcqGF6k+AAySlXJOR9IX3AAXuTVIyRBAjmxSy1AoTEo+8q/u6snk/OeUjHnkQT5Ba7kd5otTCIoaeUttUpXDZWSHCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUewX2Ef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUewX2Ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000151F00A3D;
	Fri,  4 Sep 2026 12:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788524098;
	bh=wc8TqPztESYNTYvEF4MyCS+xrsLeJESj1BygbNvzmaQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KUewX2EfQbJPgV/dZce3aMVcVzzzJ+FfZvvEo3t5YyJgKMQoZgTzWp2OexWTe60oO
	 FG16PkKvKD8fK23jT5x9MBPC2OWDTEXvSJzKVjflzv7gKbWOnkkZaKbOdIPxLrkp6B
	 65N5rTkdlqHpGKtE6ISMGiPtwZGzA53m3EUjucdDEY8gbcU00O9IcJyHvW8WcNH4jm
	 k5K+pdl8ootk9VphhMaURxFaPN8tKc+NwibuZ7R23zUsdGAHC7AhskMFLoE2dGcs04
	 nHiYXtLhx2KuW5Pk3iSDb++WMD70n/zEQxFVblaiI9bLvEybDXnYllkmgN/n9FPr5L
	 Nb/nMI04RFQMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260904113404.4051341-7-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-7-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:14:57 +0000
Message-Id: <20260904121458.000151F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing Context Synchronization Event (isb) after writing to ICC_C=
R0_EL1 and other ICC_*_EL1 registers.
--

commit 361cdcbfff4bc37ad48869321f633c176369b8d6
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields

This commit adds the missing LINK and LINK_IDLE fields to the
ICC_CR0_EL1 register definition in the arm64 sysreg generator.

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 94bf065c8ac71..e2d37ee221b84 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3761,7 +3761,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
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
This isn't a bug introduced by this patch, but while looking at
ICC_CR0_EL1, it appears there might be a pre-existing missing Context
Synchronization Event (isb) when writing to this register elsewhere in
the tree.

In drivers/irqchip/irq-gic-v5.c, gicv5_cpu_enable_interrupts() writes to
SYS_ICC_CR0_EL1 to enable interrupts but returns without an isb():

    cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 1);
    write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
}

The same pattern exists in the selftests
(tools/testing/selftests/kvm/include/arm64/gic_v5.h) for both enabling and
disabling:

gicv5_cpu_disable_interrupts()
...
    cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
    write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
}

Architectural guidelines mandate that writes to most ICC_*_EL1 registers
require an isb() to be visible to subsequent instructions. Without this,
could the CPU proceed under a stale interrupt configuration, potentially
missing interrupts?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D6
