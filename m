Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CD535203E;
	Wed, 22 Jul 2026 08:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784707988; cv=none; b=UI3AggZNHURO4xjBLSK6GlW74HPvIXMr43R0ZHtktyNE7e1Bh6yHNYGl4yCX9BOfLhBul7ZnQcASNXRAlTIxbhSmVHNCBHubXrECxIiR6sgYTjCLYalDwdvLpkVO3fodosd7lud5GlHVWn6sQx1JfHYQBd2gUXzZ229iVFDRMAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784707988; c=relaxed/simple;
	bh=g8cDaJbku32kYuG2MlMcH9liNBLebQOpmD3afSjtjBE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZBI1Pu4NORsWgazdDEhKH2JdSjuvXCCiWk4xrnGWX+Yx0kzmOIWPEgUBvMFJlbKTpD3zH2wFcCmmsSPRJ1YkWM5hIOElx9rx3g19FzrXsjx8Jj3A2J6qQCcXirpeu5z7HnBRI6NtqEy2JAH2kd09lskYxRIhg4GHw6hCqPL5OWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMLxe4jP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMLxe4jP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28D91F000E9;
	Wed, 22 Jul 2026 08:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784707986;
	bh=KjYHMfLCFMYzZ8Y+D7sGXzO82LIRg/P20NGgdi1Xpvw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BMLxe4jPSExtKTwZ976iQoYryQe9broniacQaSViZCCaCn+f5cLiXwXVPa/Nyb1XI
	 VaLG4f9JMSulScCPf0AkizNQ6/GRURqiIie8iCKz9FzpYGWrDLZE842GAV6Z1NcSkM
	 vQuIFoZ7MhhpY2jx3tA8cpHy6gfqj/CgqL25g+J096aa583bJEOAnaZMiC56z0/Z7k
	 dfE8F2f3dbZM0zcjnepwXS5KdCOjcpnODev+1nia1zd1jpPRojp6OUYmDz4Hc20B8O
	 hufVjxjN4yiRe8C7dHAzs/OmiVfYJlMcxf7kKCODJ4SZBFTXhqV9jMdlvalM7Gi181
	 hQt9Sfznkevyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/28] arm64: Add FEAT_NV2p1 detection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260722074234.3330999-13-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-13-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 08:13:05 +0000
Message-Id: <20260722081305.F28D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing isb() immediately after writing to control-plane system re=
gisters.
--

--- Patch [12]: [PATCH v3 12/28] arm64: Add FEAT_NV2p1 detection ---
commit 5488b94ad37f884fedfaca076980f395c30a72bf
Author: Marc Zyngier <maz@kernel.org>

arm64: Add FEAT_NV2p1 detection
   =20
This commit adds the necessary NV2p1 probing to the cpufeature
infrastructure.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index 9a22df0c5120f..c9c124b0ccc8e 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c

[ ... ]

> @@ -2620,6 +2620,13 @@ static const struct arm64_cpu_capabilities arm64_f=
eatures[] =3D {
>  			{ /* Sentinel */ }
>  		},
>  	},
> +	{
> +		.desc =3D "FEAT_NV2p1",
> +		.capability =3D ARM64_HAS_NV2P1,
> +		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches =3D has_cpuid_feature,
> +		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2P1)
> +	},

[Severity: High]
Are we missing an isb() after writing to control-plane system registers when
this capability is enabled?

Looking at arch/arm64/kvm/arch_timer.c in timer_set_traps(), there is a
missing isb() after the system register writes:

arch/arm64/kvm/arch_timer.c:timer_set_traps() {
    ...
	if (!cpus_have_final_cap(ARM64_HAS_NV2P1))
		sysreg_clear_set(cnthctl_el2, clr, set);
	else
		sysreg_clear_set(cntkctl_el1, clr, set);
}

The sysreg_clear_set macro evaluates to a conditional write but lacks an
immediate isb(), and the function returns shortly after.

Similarly, in arch/arm64/kvm/sys_regs.c, are we missing synchronization bef=
ore
the break?

arch/arm64/kvm/sys_regs.c:vcpu_write_sys_reg() {
    ...
		case CNTHCTL_EL2:
			write_sysreg_el1(val, SYS_CNTKCTL);
			break;
		case CPTR_EL2:
			write_sysreg_el1(val, SYS_CPACR);
			break;
    ...
}

The writes to SYS_CPACR and SYS_CNTKCTL are followed by a break and a
subsequent function return, rather than an immediate isb().

Without immediate synchronization, the CPU might operate under a stale
configuration for several cycles, which could cause unexpected traps or bre=
ak
memory safety semantics.

>  	{
>  		.capability =3D ARM64_HAS_32BIT_EL0_DO_NOT_USE,
>  		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D12
