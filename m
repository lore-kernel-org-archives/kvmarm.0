Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C363BBA05;
	Thu, 24 Sep 2026 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271917; cv=none; b=rN2hD0iF0uPWheqaqOgEOa0iud0oiU9vZTgog99VM4rt3kAjgjrsBWo20QetAoV9D6Hs4SVkI0cfqsnb/OtykcsxhjpRqXG+vpLUNvq2iM3tErg+uPUldJIwYAIJmTU294RUCVtNxz3nkgINAgL7D067A2CFNXr8HIc7WAkP6QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271917; c=relaxed/simple;
	bh=tX69Bmg2biB818sJYDrrrj6iuRQdyY/96piGx4KPkmU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MPKXFh+9+D354KuOhKHY0mJDfF57DD5+n12+dKLIw+BKJE2K1LE6lrzT8qYUFJqZpmZyuKcq+fvUwTRR5c+DFLUlsjJgipLc0LUdVZ3qfSlgY3hWWgL0UF29lCa0ZHSJ1R6q+l5aXv6Js2HBf7wJLiyUt621x2oV1Hbj/hUUcb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifUlzGIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifUlzGIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1CA1F000FF;
	Thu, 24 Sep 2026 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271916;
	bh=FZslnUD7Wj2u19IEQI91+wAqKFKVJyAJ+YwaWSb1/q8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ifUlzGISOzkkTruytI5vi1H7JQhFQuYpktUQ2NxTbe5/igmjEFq+MVc2LyHGh2Gm8
	 PpdgdXGSTU6r/7iD3N2aL3ieSCf5BF8Y2TuVv+HIfEvN0ZHDr9LqS2LkT57rRpBhHI
	 BEVGOfrAoRGrWq+zzGlg2RTfsCuvrB8ZMLk3OQMWOrzu2kPLynSVLukPFnBOPalB4Y
	 NhGbawXCc0xJz3E4y8A9GhG1rti3olHXvKiNiUL8qEr4VB/eim+ogVxw0pPyp0UivM
	 ofdRlGfJMCIvJ3/sXVoAZosUEVmzSWX9jWc+6qB7XR6c3Nfx2nxZ/HvNpHGRJIJv9l
	 y4o3OERYtk4Pg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 01/22] arm64: cpufeature: Add cpucap for HPMN0
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260924172928.2110956-2-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-2-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:45:15 +0000
Message-Id: <20260924174515.AA1CA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] arm64: cpufeature: Missing AArch32 ID_DFR1_EL1_HPMN0 in ftr_id_d=
fr1 array
--

commit 5ba8cce217bacafa8dc1ca20dcd2a95acd9bf835
Author: Colton Lewis <coltonlewis@google.com>

arm64: cpufeature: Add cpucap for HPMN0

This commit adds a CPU capability for FEAT_HPMN0, allowing MDCR_EL2.HPMN to
specify 0 counters reserved for the guest. It updates the tools/sysreg
definition to UnsignedEnum and adds the corresponding feature tracking.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index 32102c3912fa7..f8431cf858619 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
[ ... ]
> @@ -564,6 +564,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] =3D=
 {
>  };
> =20
>  static const struct arm64_ftr_bits ftr_id_aa64dfr0[] =3D {
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_E=
L1_HPMN0_SHIFT, 4, 0),

[Severity: Medium]
Does this also require updating the AArch32 counterpart register ID_DFR1_EL1
in the ftr_id_dfr1 array?

By adding ID_AA64DFR0_EL1_HPMN0 as FTR_NONSTRICT here but omitting the field
mapping from ftr_id_dfr1, the AArch32 view remains implicitly STRICT. On a
system with asymmetric HPMN0 support across CPUs, when a secondary CPU
boots and executes update_32bit_cpu_features(), it triggers
check_update_ftr_reg(SYS_ID_DFR1_EL1).=20

This could cause the boot sanity checks to unexpectedly fail and taint the
kernel due to the STRICT default conflicting with this NONSTRICT definition.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D1
