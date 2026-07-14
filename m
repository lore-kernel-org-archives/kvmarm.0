Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07CF1E5714;
	Tue, 14 Jul 2026 10:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023626; cv=none; b=ECjSpvbbJKkzGgmbu8ekon4ay0b+UP7e0yrQ+NX8dwwaXIThZa4oGLFC8BNDxhaowjTkqJrhc3AksXgCGk7IEerdx2NaJ51Fhclt1WOpg3xpq0/3rcTka4jyqeWg40wuDJ42dpwJwXWUhcNoCaTi6xkr28WN6NlIV5cpWxf2UqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023626; c=relaxed/simple;
	bh=4aHEupHyn2RfmkKJCp9SygMHkSN+b0Y34M+LKNzdYrM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bTJ7Rj0C6siihisBxk5+7dVPvGR4sj4m5XuA+1eqdCQl1FKH23tyjkWBoicg6+BvHp6ch5uA6iRVuW6FPWgdQCX2/z5QskpWRHFmcpWg+saJxipHFlWnAODj+9u7uCM6Poq0QKGNPxAXuxSW3AZKts7qaQkzA1HXjBWwvC1zGAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fmXKZgy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fmXKZgy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206731F000E9;
	Tue, 14 Jul 2026 10:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784023625;
	bh=IVSdDFQVySVftwxvl9M79LFQefajZUvfg0AZy4Jq8wE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fmXKZgy5J6+cYrAiUz7f4WJgXBS2c/YQAorpxgVT56W3U/5NsxeekfBvsVisSxiOn
	 UJlnl6lGzRgoXU80EcBWxi27NZ5U/tuoBppKRGfv4gT/smE0LSY4oyQ9ZUGtfxgoox
	 uruB09WLVFB2do3mgeXFNoHgQWlfAkk+Rl85fRBHE0ElstRkyvVWjqjbKzF7z3hlot
	 +156eww2ZJTpnDIAigH68r4lEuv4Cy2/Np+Im0YKJe7DG1gVoEXhlGjLfGwLlqLn7Y
	 W7UutRJbrsquy8qlsZOFSByhFR0A+PXq4bookkPcG795cSVSnOFGZG3Fk+3vLND202
	 YAc/pAabvFpaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 26/28] KVM: arm64: Add FEAT_NV3 detection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260714091641.1970822-27-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-27-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:07:03 +0000
Message-Id: <20260714100704.206731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Writes to control-plane system registers (SYS_NVHCR_EL2 and SYS_VN=
CR_EL2) are missing the architecturally required `isb()` synchronization ba=
rrier.
--

--- Patch [26]: [PATCH v2 26/28] KVM: arm64: Add FEAT_NV3 detection ---
commit 1e08d22547f3313a77b075620f905436357c4b40
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add FEAT_NV3 detection
   =20
Now that everything is in place to engage the FEAT_NV3 fast-path,
add the detection code to cpufeature.c.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index c9c124b0ccc8e..6ae1c816e2010 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2627,6 +2627,13 @@ static const struct arm64_cpu_capabilities arm64_f=
eatures[] =3D {
>  		.matches =3D has_cpuid_feature,
>  		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2P1)
>  	},
> +	{
> +		.desc =3D "FEAT_NV3",
> +		.capability =3D ARM64_HAS_NV3,
> +		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches =3D has_cpuid_feature,
> +		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV3)
> +	},

[Severity: High]
This isn't a bug introduced by this patch, but enabling FEAT_NV3 here expos=
es
pre-existing paths where control-plane system registers are written without
the architecturally required immediate isb() synchronization barrier.

For example, in arch/arm64/kvm/hyp/vhe/switch.c:__compute_hcr():

	if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
		write_sysreg_s(__vcpu_sys_reg(vcpu, HCR_EL2), SYS_NVHCR_EL2);

and a bit later in the same function:

		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
	} else {

Also in arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h:__sysreg_restore_el2_ret=
urn_state():

	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
		write_sysreg_s(ctxt_sys_reg(ctxt, NVHCR_EL2), SYS_NVHCR_EL2);
}

None of these writes are immediately followed by an isb(). Since they are
control-plane system registers, execution continues to evaluate masks or
return from the function under an architecturally undefined pipeline state.

Should there be an isb() immediately following these writes to
SYS_NVHCR_EL2 and SYS_VNCR_EL2?

>  	{
>  		.capability =3D ARM64_HAS_32BIT_EL0_DO_NOT_USE,
>  		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D26
