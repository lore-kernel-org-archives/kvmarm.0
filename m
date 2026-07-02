Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2713F3438A8;
	Thu,  2 Jul 2026 16:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010392; cv=none; b=rfqWk/L+j6KVWoaHAxnc/DlVg0dvc4i0MpW6DH7IsvGNtZJ5++owxn7LSQ1LjQOBFhlCR9jaiKtD5PkNTfncV606huic/UwpUZ9VxOmRjvQK8DrhhflmBvY7Wlijq51UG2SLEVVEFyQj9/OI9v26/ks4QWuUMohnqWaG66n8gIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010392; c=relaxed/simple;
	bh=t8dNsN1kzP6c6y1CGRrkkQ+50ViSCrfZncDzxGcmS3o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bwftvxCZby0S8hByyqR2xFhib3j4kb7fWKzemTgjhz4wul0PiqVd4OfdwhdCp+zoMRYJ5TxengAzOnyHYT2spl5nEYP9lLwSSjczJKmLtZS6OOf58wbKEZ1U92i6u5IEeKGUxTx2BH++PzMbAW+ugIf2zxXGlm82g0NGnp9IA7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Om0m4pdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Om0m4pdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D301F00A3A;
	Thu,  2 Jul 2026 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010391;
	bh=p1w3WhHGPhbNNzRLnbEetP9eXz8IsQlg6tJA4sna2Go=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Om0m4pdyaq2wWkF3hdr6okqUgVMA8huNlGa1jdh4TOpjWeSEVRK8c/QDUpyPQhUJs
	 2f1J5hh0QTJIhQFjDm1BkdmfME2xACKZ4rtxl+XqiQNxqdvKtY37Kv+o/M7Tm4Wpq+
	 R2ZE1mPvEjqUPSp2kkDPdhKVvjWR18mBbnCa9WZGIK6UMSLWwXooutj+YWh0foYPLI
	 xRELR68N2Ob7GzrGdh1nxwv6D0TtIckw7ewpH2sVNCmkLeMCbF5gouZjef+Vpx4l0S
	 oIX2guhDpQlC2o74UXPy7Tx+3xGIa3o/CCIN42m0sKa2nd7nhB2tf9L98npGBxz+ab
	 7wBQ0mKnGYMBQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 26/28] KVM: arm64: Add FEAT_NV3 detection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260702160248.1377250-27-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-27-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:39:50 +0000
Message-Id: <20260702163950.81D301F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Writes to the SYS_NVHCR_EL2 control system register are not follow=
ed by an immediate isb().
- [High] Writes to CNTKCTL_EL1 and CNTHCTL_EL2 control registers using sysr=
eg_clear_set() lack an immediate isb().
--

commit b72de4ae5666d0aaa35b94915af5eab1152df83b
Author: Marc Zyngier <maz@kernel.org>
KVM: arm64: Add FEAT_NV3 detection

This commit adds the detection code for FEAT_NV3 to the cpufeature
capabilities. This engages the FEAT_NV3 fast-path when the hardware
supports it.

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

[Severity: High]
Could the system operate under a stale configuration when updating timer
control registers based on the ARM64_HAS_NV2P1 capability?

In arch/arm64/kvm/arch_timer.c:timer_set_traps(), the control registers
are modified without an immediate isb() following the update:

arch/arm64/kvm/arch_timer.c:timer_set_traps()
	if (!cpus_have_final_cap(ARM64_HAS_NV2P1))
		sysreg_clear_set(cnthctl_el2, clr, set);
	else
		sysreg_clear_set(cntkctl_el1, clr, set);

The sysreg_clear_set() macro expands to a read-modify-write sequence that
does not include an isb() as the very next instruction. Is an explicit
barrier required here to prevent undefined pipeline state?

> +	{
> +		.desc =3D "FEAT_NV3",
> +		.capability =3D ARM64_HAS_NV3,
> +		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches =3D has_cpuid_feature,
> +		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV3)
> +	},

[Severity: High]
Does enabling the ARM64_HAS_NV3 capability expose missing synchronization
when writing the SYS_NVHCR_EL2 control register?

Looking at __compute_hcr() in arch/arm64/kvm/hyp/vhe/switch.c, the guest
view is published to SYS_NVHCR_EL2 without an immediate isb():

arch/arm64/kvm/hyp/vhe/switch.c:__compute_hcr()
		if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
			write_sysreg_s(__vcpu_sys_reg(vcpu, HCR_EL2), SYS_NVHCR_EL2);
		else
			__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));

Similarly, the L2 view of HCR_EL2 is restored without an immediate isb()
before returning:

arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h:__sysreg_restore_el1_state()
	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
		write_sysreg_s(ctxt_sys_reg(ctxt, NVHCR_EL2), SYS_NVHCR_EL2);
}

Could the CPU operate under a stale configuration for several cycles,
leading to unpredictable behavior or unexpected traps?

>  	{
>  		.capability =3D ARM64_HAS_32BIT_EL0_DO_NOT_USE,
>  		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D26
