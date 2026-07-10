Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F4A423149;
	Fri, 10 Jul 2026 11:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783683631; cv=none; b=CR5VJPKDs1eJPY2cM3MCHQno/tF0yGVxt7vRZ6ON5QN6W8qMKoanz0QCPZmG85um6pRzZKUvpMG7GCJTaGnzmr1+HlcpJhk8YOlbQTCMM1d0i8iIdwUfVwhP30/9RsPbf1iE6OmEZvPzw1KAV0GvJ+28aH9Nn2WgXtlPzAxGKr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783683631; c=relaxed/simple;
	bh=yXGso/KA5GxjILimML9mSwJj0kTmMIUJFMjAdVX62Sc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EyCLIW/zo8Wf3Fl+7FxNoCqlQh71AhpCP7wyifCGCUCplhdU4v7GUVIVLkCL1AS8QrY7gLH9Kxnt7ocsE5YfD9dH5l8H2Kd9y42COvE953DvroV7tmGeFjCjkunjM66rZQl2LtXrJr+bl2yd2zRh/CARRJy+SG+ig0YDm17Nc5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z0ywD01N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0ywD01N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8F21F000E9;
	Fri, 10 Jul 2026 11:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783683623;
	bh=B1F5lycnjbdKHen2CO5sznDczgJknGwLIsbGdlpOM7E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z0ywD01NyGJ49h16FlZ9UlUUIu+H7ECTAXAo/eJNFYeIde6wm71h56R5htlEt1AaY
	 bQ0yJVmBky649BXUwkFNuT3MxNc1SCH7EiolHdJDyRbikuJpt6FDkpEEgjCJR+eVrb
	 ZUpQ1KmdWqSEBCRX1uSnDijwGY6Vm7AqlUeGsj8H9oj8oGilCBcERnOwVBRW6VBstz
	 WuR8sU8IrGjoiER2YZWys9vv3gXAK0lyXC0d9T7tyfDE8qLHjIG2U/4vpUy7MEI5pZ
	 Q7wyI0jP1SDSyDp6EAXKTrKXw5Pwa7qg5QwITEc6YbC8rMZORt3padSiI+J9Zw3rEN
	 ecuZ4rQRrsbRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 04/11] arm64: errata: Require Apple IMPDEF PMUv3
 traps on all CPUs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260710-hybrid-v8-4-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
 <20260710-hybrid-v8-4-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 11:40:22 +0000
Message-Id: <20260710114023.4F8F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Hardware/Arch: CPU Capability Constraint Violation for Erratum Wor=
karound
--

--- Patch [4]: [PATCH v8 04/11] arm64: errata: Require Apple IMPDEF PMUv3 t=
raps on all CPUs ---
commit 050c419823146065deb90e25a8ad6df622e115c7
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

arm64: errata: Require Apple IMPDEF PMUv3 traps on all CPUs

This commit changes the capability type of the Apple IMPDEF PMUv3 workaround
from a local CPU erratum to an early local CPU feature. It aims to require
the workaround system-wide and reject late CPUs that miss the workaround
once it is enabled.

> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errat=
a.c
> index 5377e4c2eba2b..01bc990b2200f 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -964,7 +964,7 @@ const struct arm64_cpu_capabilities arm64_errata[] =
=3D {
>  	{
>  		.desc =3D "Apple IMPDEF PMUv3 Traps",
>  		.capability =3D ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS,
> -		.type =3D ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
> +		.type =3D ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,

[Severity: High]
Does changing this capability type inadvertently permit an unmitigated late
CPU to boot?

The ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE type includes the
ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU flag. If the system does not enable the
workaround initially (for example, if early CPUs do not all match), this
flag explicitly allows a late CPU that does require the erratum to boot
without triggering a panic.

Because the capability was not enabled system-wide, the .cpu_enable callback
is bypassed for that late CPU, meaning SYS_HACR_EL2 bit 56 is never set.

Could a guest executing on this unmitigated late CPU then directly access
the hardware PMU, leading to guest-to-host privilege escalation or an
information leak?

>  		.matches =3D has_impdef_pmuv3,
>  		.cpu_enable =3D cpu_enable_impdef_pmuv3_traps,
>  	},

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710-hybrid-v8-=
0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp?part=3D4
