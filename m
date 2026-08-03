Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351502BE639
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 23:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785799899; cv=none; b=nwBUoyfhIHRtSaRajIGI9DzdOGoQhnhImkTFKWPY64DjSYIaO0Xtnqmd4TFQBsWUkWk3R0CRlS2pz+r12YSafPCJuRZ6uXUDUIsV55R1Rzrsv3QiFxj77RE4IYKa6eEZSFujHbN5Ifp6TattOYEh452htyQcRPzBP0UqYPHnoMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785799899; c=relaxed/simple;
	bh=0C6TumyWAmV50ZZHnGMiXywaD1+Od0NiS/JcWFABbCA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W9VXIA+wmwox/vLDBSi0WPzYyUdApjk0R8QV2m25umwHRlMpoKqDxgnofdE4GlYf9/FCwX7WNKmvmB2R4+vuEREJf2Rw8rjRbGk9FXd3ge0J/4+s6XQ10INJpD2aWE2/pYzRQdT7NWqaA7C0Ll+RFOcMwoollZfn/kxYGImO0jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aW+adije; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aW+adije"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ACD1F000E9;
	Mon,  3 Aug 2026 23:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785799897;
	bh=mebeA67YZwixanGKc+5MCfnmdk6U5S4mNEoHuiz+/NE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aW+adijeSO1jJrcfpRinjPQ85WC3DdkYx8R7cqonA1iA6NSjEbZmf3EXWd3a/HwcN
	 V78h61y5IRIRDHAlQg3+6Hs1eQTOB1k6xv168gDn6GTTKp7+yyNosQqK7FCWcOrYbd
	 /9lIxKaOjaHalqeyRGLGej7IydYSvdXjp6ndwuryzonkbgbtTAGfOWW46CQSmSGPY5
	 gzQ1/2ZeXzCQG1DsoyfIvRCWlF8IuohzpdcfH/NwwJovNyb94qT96UTwiRf9s7bzf0
	 GGpT6MIrO1t51BksSCxSszBsZ60j0gKAJ0IYfj/wVNJYLIDsdmnIiUxW9GhbrlS18p
	 oQU70Ym5o8bJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-3-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
 <20260803-arm64-gcs-v18-3-fd8c40f5ad88@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 23:31:36 +0000
Message-Id: <20260803233137.65ACD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] EL1 Guarded Control Stack (GCS) registers are incorrectly nested i=
nside S1PIE and TCRX capability checks.
- [High] EL2 Guarded Control Stack (GCS) registers are incorrectly nested i=
nside TCRX capability checks, with asymmetric save/restore logic for GCSPR_=
EL2.
- [Medium] GCSPR_EL0 and GCSCRE0_EL1 are incorrectly classified as SR_LOC_M=
EMORY when in a nested hypervisor context.
--

--- Patch [3]: [PATCH v18 03/14] KVM: arm64: Manage GCS access and register=
s for guests ---
commit 408aec21b1f27709492e1981fcc42dc3f0f70337
Author: Mark Brown <broonie@kernel.org>
Subject: KVM: arm64: Manage GCS access and registers for guests

This patch adds support for exposing and context switching Guarded Control
Stack (GCS) registers for guests. It also configures HCRX_EL2.GCSEn to
enable GCS instructions.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/=
hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de9..053d7b3c5104d 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -144,6 +161,10 @@ static inline void __sysreg_save_el1_state(struct kv=
m_cpu_context *ctxt)
>  		if (ctxt_has_s1pie(ctxt)) {
>  			ctxt_sys_reg(ctxt, PIR_EL1)	=3D read_sysreg_el1(SYS_PIR);
>  			ctxt_sys_reg(ctxt, PIRE0_EL1)	=3D read_sysreg_el1(SYS_PIRE0);
> +			if (ctxt_has_gcs(ctxt)) {
> +				ctxt_sys_reg(ctxt, GCSPR_EL1)	=3D read_sysreg_el1(SYS_GCSPR);
> +				ctxt_sys_reg(ctxt, GCSCR_EL1)	=3D read_sysreg_el1(SYS_GCSCR);
> +			}
>  		}

[Severity: High]
Are the EL1 Guarded Control Stack (GCS) registers incorrectly nested inside
the S1PIE and TCRX capability checks?

FEAT_GCS, FEAT_S1PIE, and FEAT_TCR2 (TCRX) are architecturally independent =
CPU
features. If a guest is configured with GCS enabled but S1PIE or TCRX
disabled, the host will entirely skip saving the guest's GCSPR_EL1 and
GCSCR_EL1 registers during context switches.

Does this leave stale host or prior-guest state in these hardware registers,
leading to guest state corruption or cross-guest information leaks?

> @@ -239,6 +265,11 @@ static inline void __sysreg_restore_el1_state(struct=
 kvm_cpu_context *ctxt,
>  		if (ctxt_has_s1pie(ctxt)) {
>  			write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1),	SYS_PIR);
>  			write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL1),	SYS_PIRE0);
> +
> +			if (ctxt_has_gcs(ctxt)) {
> +				write_sysreg_el1(ctxt_sys_reg(ctxt, GCSPR_EL1),	SYS_GCSPR);
> +				write_sysreg_el1(ctxt_sys_reg(ctxt, GCSCR_EL1),	SYS_GCSCR);
> +			}
>  		}

[Severity: High]
Similarly, is the restoration of GCSPR_EL1 and GCSCR_EL1 incorrectly nested
inside the S1PIE and TCRX checks, causing restoration to be skipped when
these independent features are disabled?

> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/=
sysreg-sr.c
> index be685b63e8cf2..2431c18f57928 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -61,6 +61,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *v=
cpu)
> =20
>  			if (ctxt_has_s1poe(&vcpu->arch.ctxt))
>  				__vcpu_assign_sys_reg(vcpu, POR_EL2, read_sysreg_el1(SYS_POR));
> +
> +			if (ctxt_has_gcs(&vcpu->arch.ctxt))
> +				__vcpu_assign_sys_reg(vcpu, GCSCR_EL2, read_sysreg_el1(SYS_GCSCR));
>  		}
> =20
>  		/*
> @@ -77,6 +80,8 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *v=
cpu)
>  	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
>  	__vcpu_assign_sys_reg(vcpu, ELR_EL2,	 read_sysreg_el1(SYS_ELR));
>  	__vcpu_assign_sys_reg(vcpu, SPSR_EL2,	 read_sysreg_el1(SYS_SPSR));
> +	if (ctxt_has_gcs(&vcpu->arch.ctxt))
> +		__vcpu_assign_sys_reg(vcpu, GCSPR_EL2, read_sysreg_el1(SYS_GCSPR));
> =20
>  	if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
>  		__vcpu_assign_sys_reg(vcpu, SCTLR2_EL2, read_sysreg_el1(SYS_SCTLR2));

[Severity: High]
Is the GCSCR_EL2 save erroneously nested inside the ctxt_has_tcrx() block,
while GCSPR_EL2 is saved asymmetrically outside of it?

Since GCS does not depend on TCR2 (TCRX), a nested hypervisor running with =
GCS
but without TCR2 will not have GCSCR_EL2 saved correctly. Furthermore,
the asymmetric save logic between the two registers creates an unbalanced
cycle that can lead to corrupted nested guest states.

> @@ -133,6 +138,11 @@ static void __sysreg_restore_vel2_state(struct kvm_v=
cpu *vcpu)
> =20
>  		if (ctxt_has_s1poe(&vcpu->arch.ctxt))
>  			write_sysreg_el1(__vcpu_sys_reg(vcpu, POR_EL2), SYS_POR);
> +
> +		if (ctxt_has_gcs(&vcpu->arch.ctxt)) {
> +			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSCR_EL2), SYS_GCSCR);
> +			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSPR_EL2), SYS_GCSPR);
> +		}
>  	}
> =20
>  	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);

[Severity: High]
Are both EL2 GCS registers erroneously restored inside the ctxt_has_tcrx()
block? GCSPR_EL2 was saved unconditionally outside this block in
__sysreg_save_vel2_state(), meaning it might be saved but never restored if
TCRX is absent.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5d5c579d45790..d18ada283809e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -109,6 +109,10 @@ static enum sr_loc_attr locate_direct_register(const=
 struct kvm_vcpu *vcpu,
>  	case PIR_EL1:
>  	case PIRE0_EL1:
>  	case POR_EL1:
> +	case GCSCRE0_EL1:
> +	case GCSPR_EL0:
> +	case GCSCR_EL1:
> +	case GCSPR_EL1:
>  	case ESR_EL1:
>  	case AFSR0_EL1:
>  	case AFSR1_EL1:

[Severity: Medium]
Are GCSPR_EL0 and GCSCRE0_EL1 incorrectly classified as SR_LOC_MEMORY when =
in
a nested hypervisor context?

These registers are eagerly loaded onto the physical hardware via
__sysreg_save_user_state() and __sysreg_restore_user_state(), and they have=
 no
EL2 aliases. They are always resident on the physical CPU when the vCPU is
running, regardless of whether the guest is in vEL1 or vEL2 context.

Classifying them as SR_LOC_MEMORY when is_hyp_ctxt(vcpu) is true means any
host-side access will read the stale vcpu->arch.ctxt.sys_regs array instead=
 of
the active hardware register. Should they unconditionally return SR_LOC_LOA=
DED
like TPIDR_EL0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803-arm64-gcs-=
v18-0-fd8c40f5ad88@kernel.org?part=3D3
