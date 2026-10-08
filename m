Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C065392C3D
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 12:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462348; cv=none; b=QgOJNuk3dUZJ3RUfealOP9XxAHmrJXala4OWduwO7VVPhBJUEHTQ2tBlpOKUkXozCwQpPnLoHA31U8INYL24QoclMxGVgvORmXO97FNkSt21+s/aX+ZchFiQwT8SWPL0gqqoCsG6L0SatHeoBeBuIpp9TURCLcpe4aCC/luFtLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462348; c=relaxed/simple;
	bh=+waYO2mhBJEk4uM73kt1BqIj6YNPmknn03mbEhYqNMI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TEURl2gJNYhXk36KxAjFwv5fZcIGKIdFedqONDUgdEdwWZU/qzq+kNuNeGe0xI6BY2OQO8/hqi+P/cTvLBVBAD9nlaG/vUvPe0+NDR6/9cQuWf8NKNjVxl2rgKHpUimgMW0AbCJdLm4+yw/KexpdvUt/W9j/kYeVcSqv6U1OqH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbJHq74K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbJHq74K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49FF1F000FF;
	Thu,  8 Oct 2026 12:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791462346;
	bh=cSuJVMhd1Ykjobs4DcG6CDbGwbsg6VG/pWu6sFkyFDw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cbJHq74KCpuvyYx7Py3MP5TntKnCEfyZtzh8jksq68b1+QD/7YHXP4nmA/XuWoYvm
	 Ziqxe+cz6kkzzIIyfk8xYDbowVnfhhp/PPIvibgZzeoOJHd+UfLS5CURskPReQgiRh
	 pq1mqb/TIOLOXOE/MlAxzT4Qs5ytP7/pX4OgNhj6cW/OvS8ngPBLp3D43F6Zzhs082
	 KsWBYq7bus7pjse2Yy62rp0Z28pxiBxfBwGtd32eNvfjX7iITgujyOHykL2TMF/QEU
	 X9A3cMGM4aw6xk2fv1GKEkjtba4+egi9veJlSme6iJ+R2Xg/XPW+84+Y//DZ61DAU8
	 gNbcXpp96Uo0A==
Message-ID: <sashiko-outbox-164141@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] arm64: Apply existing Apple CPU workarounds to M3
 and M4
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Reeves" <michael.reeves077@gmail.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20261008-apple-m3-m4-kvm-v1-2-7bb4cbf3d63b@gmail.com>
References: <20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com>
 <20261008-apple-m3-m4-kvm-v1-2-7bb4cbf3d63b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 12:25:46 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] arm64: missing M3 and M4 from has_vgic_v3 KVM capability array
--

commit adcc2ca70d0cb38584f5c01ccf8a91f249b43c44
Author: Michael Reeves <michael.reeves077@gmail.com>

arm64: Apply existing Apple CPU workarounds to M3 and M4

Add M3, M3 Pro, M3 Max and base M4 to apple_cpus so they receive the
existing PMU trap and broken SEIS workarounds needed by KVM.

> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errat=
a.c
> index e0c09402540ce..8a7703b86f3ef 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -288,6 +288,14 @@ static const struct midr_range apple_cpus[] =3D {
>  	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
>  	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
>  	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_SAWTOOTH),
> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_EVEREST),
> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_SAWTOOTH_PRO),
> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_EVEREST_PRO),
> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_SAWTOOTH_MAX),
> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_EVEREST_MAX),
> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M4_DONAN_ECORE),
> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M4_DONAN_PCORE),
>  	{},
>  };

[Severity: High]
Does this commit also need to update the has_vgic_v3 array in
can_trap_icv_dir_el1() in arch/arm64/kernel/cpufeature.c with these M3 and =
M4
MIDRs?

Because Apple SoCs use AIC instead of a standard physical GIC, they lack the
ARM64_HAS_GICV3_CPUIF CPU capability. To use the hardware vGIC's TDIR (Trap
DIR) feature on Apple Silicon, KVM relies on the has_vgic_v3 array in
can_trap_icv_dir_el1().

Since M3 and M4 are omitted from has_vgic_v3, can_trap_icv_dir_el1() returns
false on M3 and M4, clearing the ARM64_HAS_ICH_HCR_EL2_TDIR capability.

When this capability is missing, KVM's fallback path in
kvm_compute_ich_hcr_trap_bits() forces common_trap =3D true (setting the
ICH_HCR_EL2.TC bit). This traps all guest GICv3 system register accesses to
EL2 for software emulation, causing a catastrophic performance degradation
for interrupt-heavy virtualization workloads.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-apple-m3-m=
4-kvm-v1-0-7bb4cbf3d63b@gmail.com?part=3D2
