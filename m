Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9035337E5FD;
	Mon, 20 Jul 2026 06:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784527271; cv=none; b=FuGMPHwFtr60yIMM2hURNlX8fjgAkjDSkpINZ7JZK3hWiPPxbVDPLKFXME9vuLiFg/iBWZtEePrn1seGIFnHu2roFEEvTCm9AFfppPB8BAxbL5zmgzcdcmOFOem0WoMXx8RSSEQA8JVt0PO8lD2HReuf3bf8Fbnh6hb3eqX84Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784527271; c=relaxed/simple;
	bh=odDOMYIFFSe5z17RLybFuXptLCjisF/47PJJeKbsbwI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I31xd8Rt9aTbY1RJwY1AkgcBiFCZZTTmbnLHtPoAZyahlToe5w5akAZgNndITfmZMlM3T+rFD7kCXZcIRIMhSf177VHOSMwb+UFWV8tgbBABOreRJBuuxxASuTtdLUzJ9lRHwkCsLbwcN1Y1kgklz7W/9mJKHi7HpRCAuDzOijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KpLsx65o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KpLsx65o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764901F000E9;
	Mon, 20 Jul 2026 06:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784527261;
	bh=LeBLqrVuwp539+jfocvOT7dA2VjnTJS2r176DKcWYAc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KpLsx65onGSnw/rFuA0rR2TGEswO+AVLVWvTFxkRz7tr2xrWW9So0IKJzBrlyAZsH
	 l6RpgEqh3HBofLgATVcjpxGpemDJFjppenwiKYbmGGkxS1oyqlC3lzlQSLYKfbO7QM
	 HB8v/eaKtZ9/Dd5xUHC7bJSTbmIaXlwG9RUtdf2GA4jhIWtpaznlh1a1Iocd4Pf1ut
	 E0kD/Kw07NFSWimOUtmVUAoP3cuQlp5qg82//vCKnkaZ7MRvEyOmx9K8XbNNveC3UA
	 8Mu2bo1McXR1jsia4P0Feu893fIb0CH1CL/s3lmmFidlqDP5ont66CXXVvRd5NX6gH
	 EbUmWm+bc6LpQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 09/16] arm64: errata: Require Apple IMPDEF PMUv3
 traps on all CPUs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260720-hybrid-v9-9-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-9-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 06:01:00 +0000
Message-Id: <20260720060101.764901F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Permitting late CPUs with IMPDEF PMUv3 to boot without enablin=
g hypervisor traps allows untrapped guest access to host PMU registers.

Pre-existing issues:
- [High] Writes to control-plane system registers in CPU capability enable =
callbacks lack a mandatory `isb()` instruction.
--

--- Patch [9]: [PATCH v9 09/16] arm64: errata: Require Apple IMPDEF PMUv3 t=
raps on all CPUs ---
commit 3e98f085c1f1b418fb0ec6e336b981ba1df07b03
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

arm64: errata: Require Apple IMPDEF PMUv3 traps on all CPUs

This commit changes the ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS erratum to an
all-early-CPU capability. It ensures the capability is only advertised if a=
ll
early CPUs match, aiming to reject late CPUs that miss the capability while
permitting late CPUs to have it when the system does not.

> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errat=
a.c
> index 1995e1198648e..a5ae628204a12 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c

[ ... ]

> @@ -1005,7 +1005,7 @@ const struct arm64_cpu_capabilities arm64_errata[] =
=3D {
>  	{
>  		.desc =3D "Apple IMPDEF PMUv3 Traps",
>  		.capability =3D ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS,
> -		.type =3D ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
> +		.type =3D ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,

[Severity: Critical]
By changing the capability type to ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
does this allow a late CPU with IMPDEF PMUv3 to boot without enabling the
hypervisor trap if the system lacks the capability system-wide?

If an asymmetric system boots without the PMUv3 IMPDEF capability system-wi=
de
and a late Apple CPU with the feature is onlined, verify_local_cpu_caps()
will permit the CPU. However, because system_has_cap is false, it skips
caps->cpu_enable() which leaves HACR_EL2 bit 56 clear.

Since KVM relies on this hardware trap to intercept these instructions and
inject an UNDEF exception, could this missing trap allow a malicious guest
scheduled on the late CPU to execute IMPDEF PMU instructions natively and
manipulate host physical PMU state?

>  		.matches =3D has_impdef_pmuv3,
>  		.cpu_enable =3D cpu_enable_impdef_pmuv3_traps,

[Severity: High]
This is a pre-existing issue, but do the writes to control-plane system
registers in capability enable callbacks require an isb() synchronization
barrier?

Currently, callbacks like cpu_enable_impdef_pmuv3_traps update SYS_HACR_EL2
using sysreg_clear_set_s, and then return immediately without a trailing
isb(). Other callbacks like cpu_enable_trap_ctr_access and
cpu_enable_cache_maint_trap update sctlr_el1 in a similar way.

Under the ARM64 subsystem rules, every write to a control-plane system
register must be followed by an isb() as the very next instruction. Since
sysreg_clear_set_s does not issue this barrier, returning immediately places
the return branch instruction against an architecturally undefined pipeline
state. Should these callbacks issue an explicit isb() before returning?

>  	},

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybrid-v9-=
0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D9
