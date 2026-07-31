Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7331E36DA0D
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785502566; cv=none; b=YFKXM2hwKvq2cAuS1Ay9K0FExXBnEfJqxJrsuZto3DBRz93/LnkxCel+i2NJc8+yeDVe8FXsH379Tg0BH3DqtaVsJT3Yl0H/U1k0+kpJbb43wchUbMKf/u9WUt0Yh0eCv3oxAfii9EEpAlbRAGS1MYBUGLtu053ryth9HuhuND4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785502566; c=relaxed/simple;
	bh=AkGiOX7UXoxavSX3oJEAIwKRDZqDkcTRo9ytrmevMg8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ooXwdy62a7bW+uMpOBMmuAHTLX/T9A1+RGCWdB2ZLwG67uLIHHSFVeqXU5qPPswBVNKoynyEoWS4KsEwqTLL5hftsFhGOf46xM3YTnU+hia/TyRql7RwZCPsaMeIQRa1xAPXIer2lRR/4OUCbmwWzHkKpSLICImAHKEc/q4D+oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=myX+S1Yq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="myX+S1Yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4B31F000E9;
	Fri, 31 Jul 2026 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785502565;
	bh=PyoTZXV7DUzR7xPUIOEp1yqDhpGSiyyeBOJPZAEqIxk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=myX+S1YqZfQsWVPKdjxNu6zch/Og4aBmvX90LJoGGwnZ7IcrCg026CitOajSHl2Cv
	 CvPLHhGxE+TRaXpfiMI4KDaFfHfWuLzbd+dKbXm1u5AWhL+p1jt6tb+YU3dyNkAFks
	 EyEJKzKOkxHeu4EGi6vcFumz1448D4HrDYhSHXwC63e6xLI9pivtVG79wtvob+Ubdy
	 XV6p0kMTxjwCuNlE26bKzlxGU/qnnYaWRxgODL0mJOnKRYFM+7QxTxB/hDN/yfTuZd
	 fWBegOeeoXQwaZwIrNlCke03GuhwAs9r1O/fP+mf+fCTGBJ9i3BkuFq0Ghr5odXxFp
	 SeKqTd5Pcvo0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-3-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
 <20260731-arm64-gcs-v17-3-5e39ca01b14e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 12:56:04 +0000
Message-Id: <20260731125604.CF4B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] GCS register context switch routines are incorrectly nested inside=
 independent CPU feature checks (S1PIE and TCR2/TCRX), causing state corrup=
tion.
- [High] User-state GCS registers (`GCSPR_EL0` and `GCSCRE0_EL1`) are omitt=
ed from `locate_direct_register()` and live CPU accessors, breaking `KVM_SE=
T_ONE_REG`.
- [High] GCS is explicitly masked out of the ID_AA64PFR1_EL1 register, maki=
ng it impossible to expose to guests.
--

--- Patch [3]: [PATCH v17 03/14] KVM: arm64: Manage GCS access and register=
s for guests ---
commit 886331199ccf7c07df03690da6445af3ec9f7d3d
Author: Mark Brown <broonie@kernel.org>
Subject: KVM: arm64: Manage GCS access and registers for guests

This patch introduces KVM support for the Guarded Control Stack (GCS) exten=
sion.
It handles context switching of GCS registers for guests and configures
HCRX_EL2.GCSEn to enable GCS instruction execution.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/=
hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de9..053d7b3c5104d 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
[ ... ]
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
Does this code inadvertently bypass GCS saves when S1PIE is disabled?

Because the ctxt_has_gcs() block is nested inside if (ctxt_has_s1pie()),=20
a VM with GCS enabled but S1PIE disabled will fail to save these registers,=
=20
leading to state corruption across context switches.

[ ... ]
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
Similarly, does this skip restoring GCS registers if S1PIE is disabled?

> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/=
sysreg-sr.c
> index be685b63e8cf2..2431c18f57928 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
[ ... ]
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

[Severity: High]
Is GCSCR_EL2 supposed to be saved only when TCRX is present?=20

Here, the GCSCR_EL2 save logic is nested inside the if (ctxt_has_tcrx())
block, but below, GCSPR_EL2 is saved unconditionally outside of it.

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

[ ... ]
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

[Severity: High]
Does this code inadvertently skip restoring both GCSPR_EL2 and GCSCR_EL2=20
when TCRX is disabled?

Both are improperly nested inside the ctxt_has_tcrx() block here, meaning
they won't be restored on context switch for VMs without TCRX.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5d5c579d45790..1a1e45d645523 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -109,6 +109,8 @@ static enum sr_loc_attr locate_direct_register(const =
struct kvm_vcpu *vcpu,
>  	case PIR_EL1:
>  	case PIRE0_EL1:
>  	case POR_EL1:
> +	case GCSCR_EL1:
> +	case GCSPR_EL1:
>  	case ESR_EL1:
>  	case AFSR0_EL1:

[Severity: High]
Should the user-state GCS registers (GCSPR_EL0 and GCSCRE0_EL1) be explicit=
ly
added here to return SR_LOC_LOADED?

Because they are omitted from locate_direct_register(), they fall back to
SR_LOC_MEMORY. When userspace uses KVM_SET_ONE_REG, vcpu_put() will overwri=
te
the updated memory array with the unmodified hardware state, breaking state
restoration.

Likewise, it appears they are also missing from the live CPU accessors:
read_sr_from_cpu() and write_sr_to_cpu().

[Severity: High]
Is the GCS feature bit still explicitly masked out of the ID_AA64PFR1_EL1
register limit?

Looking at sanitise_id_aa64pfr1_el1() in arch/arm64/kvm/sys_regs.c, it appe=
ars
the GCS bit is unconditionally cleared. If so, when the VMM tries to enable
GCS via KVM_SET_ONE_REG, arm64_check_features() will validate against a lim=
it
of 0 and reject it with -E2BIG, making it impossible to expose GCS to guest=
s.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731-arm64-gcs-=
v17-0-5e39ca01b14e@kernel.org?part=3D3
